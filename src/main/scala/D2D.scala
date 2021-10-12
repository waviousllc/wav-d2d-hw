package wav.d2d

import wav.wlink.{WlinkPHYTxBundle, WlinkPHYRxBundle}
import wav.common._

import chisel3._
import chisel3.util._
import chisel3.stage.ChiselStage
import chisel3.experimental.ChiselEnum


import freechips.rocketchip.amba.axi4._
import freechips.rocketchip.amba.ahb._
import freechips.rocketchip.amba.apb._
import freechips.rocketchip.subsystem.BaseSubsystem
import freechips.rocketchip.subsystem.CrossingWrapper
import freechips.rocketchip.config.{Parameters, Field, Config}
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.regmapper._
import freechips.rocketchip.tilelink._
import freechips.rocketchip.util._
import freechips.rocketchip.unittest._
import freechips.rocketchip.devices.tilelink._



class WavD2D(
  val numLanes: Int, 
  val baseAddr: BigInt = 0x0, 
  val phyDataWidth : Int = 16,
  val processSuffix: String = ""
)(implicit p: Parameters) extends LazyModule{
  
  
  val clkrxbase = 0x1000
  val txbase    = 0x4000
  val rxbase    = 0x8000
  
  val xbar = LazyModule(new APBFanout)
  
  val device = new SimpleDevice("wavd2d", Seq("wavious,d2d"))
  
  val node = WavAPBRegisterNode(
    address = AddressSet.misaligned(baseAddr+0x10000, 0x100),     //Figure out how to make this a little better
    device  = device,
    //concurrency = 1, //make depending on apn (apb requires 1)
    beatBytes = 4)
  
  
  val rpll                = LazyModule(new WavRpll    (baseAddr=baseAddr)(p))         //FIX
  val clk_tx              = LazyModule(new WavD2DClkTx(baseAddr=baseAddr+0x100)(p))   //FIX
  val ldo                 = LazyModule(new WavD2DLDO(baseAddr=baseAddr+0x200)(p))
  val clk_rx              = LazyModule(new WavD2DClkRx(numLanes=numLanes, baseAddr=baseAddr+clkrxbase)(p))
  val tx                  = Seq.tabulate(numLanes)(i => LazyModule(new WavD2DTx(baseAddr=baseAddr+txbase+(i*0x100))(p)))
  val rx                  = Seq.tabulate(numLanes)(i => LazyModule(new WavD2DRx(baseAddr=baseAddr+rxbase+(i*0x100), withCDR=true)(p)))
  
  
  rpll.apb            := xbar.node
  clk_tx.node         := xbar.node
  ldo.node            := xbar.node
  clk_rx.xbar.node    := xbar.node
  tx.foreach {t => t.node := xbar.node}
  rx.foreach {r => r.node := xbar.node}
  node                := xbar.node
  
  for(i <- 0 until numLanes){ tx(i).suggestName(s"tx${i}") }
  for(i <- 0 until numLanes){ rx(i).suggestName(s"rx${i}") }
  
  override lazy val module = new LazyModuleImp(this) with RequireAsyncReset{
    val io = IO(new Bundle{
      val scan            = new WavScanBundle
      val iddq            = Input (Bool())
      val highz           = Input (Bool())
      val dsr             = new WavBSRBundle
      val bsr             = new WavBSRBundle
      val por_reset       = Input (Bool())
      val dtst            = Output(Bool())
      val link_tx         = new WlinkPHYTxBundle(numLanes * phyDataWidth)
      val link_rx         = new WlinkPHYRxBundle(numLanes * phyDataWidth)
      
      val refclk_ana_in   = Input (Bool())
      val refclk_ana_out  = Output(Bool())
      val pad             = new WavD2DBumpBundle(numLanes)
      //val pg              = new WavD2DPowerBundle
    })
    
    //-----------------------------------------
    // Boundary Scan connections
    //-----------------------------------------
    dontTouch(io.bsr)
    dontTouch(io.dsr)
    
    io.bsr <> rx(numLanes-1).module.io.bsr  //initial connection to be overridden
    for(i <- numLanes-1 to 0 by -1) {
      if(i == numLanes-1) {
        io.bsr -> rx(i).module.io.bsr
        rx(i).module.io.bsr.tdi := io.bsr.tdi //how can we resovle this?
      }
      else                rx(i+1).module.io.bsr -> rx(i).module.io.bsr
    }
    
    for(i <- numLanes-1 to 0 by -1) {
      if(i == numLanes-1) rx(0).module.io.bsr   -> tx(i).module.io.bsr
      else                tx(i+1).module.io.bsr -> tx(i).module.io.bsr
    }
    
    tx(0).module.io.bsr -> clk_rx.module.io.bsr -> clk_tx.module.io.bsr -> io.bsr.tdo
    
    
    
    
    val tx_bist_en    = Wire(Bool())
    val tx_bist_mode  = Wire(UInt(4.W))
    val swi_rx_cal_detect_en_tx = Wire(Bool())
    
    val refclk        = rpll.module.io.refclk
    val refclk_reset  = WavResetSync(refclk, io.por_reset, io.scan.asyncrst_ctrl)
    
    //-----------------------------------------
    // Analog
    //-----------------------------------------
    val ana         = Module(new WavD2DAnalogPhyBlackBox(numLanes, processSuffix))
    
    ana.io.refclk_in    := io.refclk_ana_in
    io.refclk_ana_out   := ana.io.refclk_out
    ana.io.pad          <> io.pad
    
    //FIX These
    ana.io.clk_rx_dtst_in  := ana.io.rpll_dtest_out
    ana.io.rpll_refclk_alt := false.B//ana.io.tie_lo
    io.dtst                := ana.io.clk_rx_dtst
    
    ana.io.ext_ibias_5u    := ana.io.tie_lo
    
    //-----------------------------------------
    // Digital
    //-----------------------------------------
    val use_core_clk    = Wire(Bool())
    val tx_link_clk     = Wire(Bool())
    val txgfcm          = Module(new WavClkMuxGF)
    txgfcm.io.clk_0     := refclk
    txgfcm.io.clk_rst_0 := refclk_reset
    txgfcm.io.clk_1     := clk_tx.module.io.core.coreclk
    txgfcm.io.clk_rst_1 := WavResetSync(clk_tx.module.io.core.coreclk, io.por_reset, io.scan.asyncrst_ctrl)
    txgfcm.io.sel       := use_core_clk
    txgfcm.io.test_en   := io.scan.mode
    txgfcm.io.cgc_en    := io.scan.mode
    tx_link_clk         := txgfcm.io.clk
    
    val tx_link_clk_reset = WavResetSync(tx_link_clk, io.por_reset, io.scan.asyncrst_ctrl)
    
    val rxctrl      = withClockAndReset(refclk.asClock, refclk_reset.asAsyncReset){ Module(new WavD2DRxCtrlLogic(numLanes=numLanes, dataWidth=phyDataWidth)) }
    rxctrl.io.scan_asyncrst_ctrl  := io.scan.asyncrst_ctrl
    
    val txctrl      = withClockAndReset(tx_link_clk.asClock, tx_link_clk_reset.asAsyncReset){ Module(new WavD2DTxCtrlLogic(numLanes=numLanes, dataWidth=phyDataWidth)) }
    
    use_core_clk    := txctrl.io.use_core_clk
    txctrl.io.rx_cal_recv := rxctrl.io.rx_cal_recv & swi_rx_cal_detect_en_tx
    txctrl.io.enable      := ~tx_link_clk_reset    //should this be a separate signal?
    
    
    
    io.link_tx                        <> txctrl.io.link_tx
    io.link_rx                        <> rxctrl.io.link_rx
    
    
    
    rpll.module.io.core               <> txctrl.io.pll          
    rpll.module.io.ana                <> ana.io.rpll
    rpll.module.io.iddq               := io.iddq
    rpll.module.io.dsr                <> io.dsr
    rpll.module.io.scan.connectScan(io.scan)
    
    clk_tx.module.io.core             <> txctrl.io.clk   
    clk_tx.module.io.ana              <> ana.io.clk_tx
    clk_tx.module.io.scan.connectScan(io.scan)
    
    
    rpll.module.io.dsr -> ldo.module.dsr -> io.dsr.tdo
    
    ldo.module.iddq                   := io.iddq
    ldo.module.highz                  := io.highz
    ldo.module.ana                    <> ana.io.ldo
    ldo.module.core.en                := txctrl.io.ldo.en | rxctrl.io.ldo.en
    ldo.module.scan.connectScan(io.scan)
    
    
    rxctrl.io.clk                     <> clk_rx.module.io.core  
    rxctrl.io.clk_cal                 <> clk_rx.module.io.core_cal
    clk_rx.module.io.ana              <> ana.io.clk_rx
    clk_rx.module.io.refclk           := refclk
    clk_rx.module.io.refclk_reset     := refclk_reset
    clk_rx.module.io.scan.connectScan(io.scan)
    
    
    for(i <- 0 until numLanes){
      tx(i).module.io.core            <> txctrl.io.tx(i)  
      tx(i).module.io.ana             <> ana.io.tx(i)
      
      tx(i).module.io.scan.connectScan(io.scan)
      tx(i).module.io.core_bist.tx_bist_en    := tx_bist_en || txctrl.io.tx_bist_en 
      tx(i).module.io.core_bist.tx_bist_mode  := tx_bist_mode
    }
    
    
    for(i <- 0 until numLanes){
      rx(i).module.io.core            <> rxctrl.io.rx(i)  
      rx(i).module.io.ana             <> ana.io.rx(i)
      rx(i).module.io.ana_q.get       <> ana.io.rxq(i)
      rx(i).module.io.scan.connectScan(io.scan)
      
      rx(i).module.io.core_cdr        <> clk_rx.module.io.rx_cdr(i)
      rx(i).module.io.core_bist       <> clk_rx.module.io.rx_bist(i)
      
      rx(i).module.io.core_cal        <> rxctrl.io.rx_cal(i)
    }
    
    
    
    
    val regs = node.regmap(
      //-----------------------
      // TX Ctrl Registers
      //-----------------------
      WavSWReg(0x0, "TxCtrl", "Controls for Tx Control Logic",
        WavRW   (txctrl.io.swi_data_en,   false.B,        "tx_data_en",       "Enables the Tx Path for sending data. Used when the link is desired to be SW controlled"),
        WavRW   (txctrl.io.swi_cal_en,    false.B,        "tx_cal_en",        "Enables the Tx Path for sending calibration data."),
        WavRW   (txctrl.io.swi_tx_highz,  false.B,        "tx_highz",         "Currently RESERVED"),
        WavRW   (txctrl.io.swi_auto_cal,  true.B,         "tx_auto_cal",      "Start calibrations automatically when calibrations are requested"),
        WavRW   (swi_rx_cal_detect_en_tx, true.B,         "rx_cal_detect_en_tx",      "1 - If receiver sees calibrations start, will enable local Tx to begin calibrations"),
        WavRW   (txctrl.io.swi_need_cals_block, false.B,         "need_cals_block",      "0 - Cals must be ran prior to enabling the data path. 1 - Cals not a requirement"),
        WavRW   (txctrl.io.pstate,        WavD2DPState.P2,            "tx_pstate",        "Pstate to use when the link is disabled")),
        
        
      WavSWReg(0x4, "TxCtrlCounters1", "Counters for Various TX Path Timings",
        WavRW   (txctrl.io.swi_clken2rst_dly,   1.U,        "clken2rst_dly",      "Time from enabling the ClkTx logic until the ClkTx reset sync being deasserted"),
        WavRW   (txctrl.io.swi_clkswitch_dly,   3.U,        "clkswitch_dly",      "Number of cycles between switching from link clk and refclk"),
        WavRW   (txctrl.io.swi_clkrst2drv_dly,  132.U,      "clkrst2drv_dly",     "")),
      
      WavSWReg(0x8, "TxCtrlCounters2", "Counters for Various TX Path Timings",
        WavRW   (txctrl.io.swi_clkpre_dly,      132.U,      "clkpre_dly",         "Number of cycles after starting the high speed clock and sending the SYNC word"),
        WavRW   (txctrl.io.swi_sync_cycles,     0.U,        "sync_cycles",        "Reserved. Keep at 0")),
      
      WavSWReg(0xc, "TxCtrlCounters3", "Counters for Various TX Path Timings",
        WavRW   (txctrl.io.swi_clktrail_dly,    200.U,      "clktrail_dly",       "Number of high speed clock cycles to keep the clock active after prior to entering LP mode"),
        WavRW   (txctrl.io.swi_min_lpxx_hs,     15.U,       "min_lpxx_hs",        "Minimum LP time when staying on the high speed link clock"),
        WavRW   (txctrl.io.swi_min_lpxx_ref,    4.U,        "min_lpxx_ref",       "Minimum LP time when staying on the refclk")),
      
      WavSWReg(0x10, "TxCtrlCounters4", "Counters for Various TX Path Timings",
        WavRW   (txctrl.io.swi_tx_disable_delay,   15790.U,        "tx_disable_delay",      "Number of cycles to wait after entering DATA state in cals to enable the TX with data (TXs are in highz during this time)")),
      
      WavSWReg(0x14, "TxCtrlCounters5", "Counters for Various TX Path Timings",
        WavRW   (txctrl.io.swi_tx_cal_count,       15790.U,        "tx_cal_count",      "Number of cycle to send data for CDR training or eye mapping")),
      
      WavSWReg(0x18, "TxCtrlStatus", "",
        WavRO   (txctrl.io.state,                                  "txctrl_state",      "Status of TxCtrl state machine")),
      
      WavSWReg(0x1c, "TxCtrlIdleTime", "LP11 IDLE Minimum requirement",
        WavRW   (txctrl.io.swi_min_idle_time,       8.U,        "tx_lp11_min_idle_time",      "Minimum number of refclk cycles to remain in LP11/IDLE state")),
      
      WavSWReg(0x20, "TxCtrlSYNCWord", "Sync word to be sent at start of data",
        WavRW   (txctrl.io.swi_sync_word,       "hdead".U,        "tx_sync_word",      "Sync word to use")),
      //-----------------------
      // TX Bist Registers
      //-----------------------
      WavSWReg(0x24, "TxBistControl", "",
        WavRW   (tx_bist_en,    false.B,      "tx_bist_en",       "FILL ME IN"),
        WavRW   (tx_bist_mode,  4.U,          "tx_bist_mode",     "FILL ME IN")),
      
      
      //-----------------------
      // RX Ctrl Registers
      //-----------------------
      WavSWReg(0x80, "RxCtrlCounters1", "Counters for Various RX Path Timings",
        WavRW   (rxctrl.io.swi_lp00hsclk_dly,   0.U,        "lp00hsclk_dly",      ""),
        WavRW   (rxctrl.io.swi_clkpre_dly,      0.U,        "clkpre_dly",         ""),
        WavRW   (rxctrl.io.swi_hsexit_dly,      0.U,        "hsexit_dly",         "")),
        
      WavSWReg(0x84, "RxCtrl1", "Additional RxCtrl Settings",
        WavRW   (rxctrl.io.swi_auto_cal,        true.B,     "auto_cal",           "1 - Automatically run calibrations after seeing calibration signaling and entering the DATA state"),
        WavRW   (rxctrl.io.swi_start_cals,      false.B,    "start_cals",         "Manually run calibrations via SW. No need to use if auto_cal is enabled"),
        WavRW   (rxctrl.io.swi_deskew_bypass,   true.B,     "deskew_bypass",      "0 - Deskew FIFO is used. 1 - Deskew FIFO is bypassed"),
        WavRW   (rxctrl.io.swi_no_em_train_cdr, true.B,     "no_em_train_cdr",    "1 - Skip Eye Mapping and only train the CDR during auto cal. (Used for faster simulations)"),
        WavRW   (rxctrl.io.swi_start_em_delay,  384.U,      "start_em_delay",     "Number of refclk cycles to wait until starting EyeMapping/CDR Training"))
      
    )
    
  }
}




/**********************************************************************
*   Generation Wrappers
**********************************************************************/
// class WavD2DWrapper()(implicit p: Parameters) extends LazyModule{
//   
//   //val xbar = LazyModule(new TLXbar)
//   val ApbPort = APBMasterNode(
//     portParams = Seq(APBMasterPortParameters(masters = Seq(APBMasterParameters(name = "ApbPort"))))
//   )
//   val apbport = InModuleBody {ApbPort.makeIOs()}
//   
//   val d2d = LazyModule(new WavD2D(numLanes=2, baseAddr=0)(p))
//   
//   d2d.xbar.node := APBToTL() := ApbPort
//   
//   lazy val module = new LazyModuleImp(this) with RequireAsyncReset{
//     val io = IO(d2d.module.io.cloneType)
//     
//     io <> d2d.module.io
//   }
//   
// }
// 
// object WavD2DWrapperGen extends App {  
//   //Create an empty parameter if we have nothing to use
//   //implicit val p: Parameters = Parameters.empty
//   implicit val p: Parameters = new BaseXbarConfig
//   
//   val axiverilog = (new ChiselStage).emitVerilog(
//     LazyModule(new WavD2DWrapper()(p)).module,
//      
//     //args
//     Array("--target-dir", "output/")
//   )
// }





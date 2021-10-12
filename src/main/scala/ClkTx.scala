package wav.d2d

import wav.common._

import chisel3._
import chisel3.util._
import chisel3.experimental._
import chisel3.stage.ChiselStage

//import chisel3.experimental._
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


class WavD2DClkTxCoreBundle extends Bundle{
  val coreclk             = Output(Bool()) //should be clock?
  val en                  = Input (Bool())
  val en_div2             = Input (Bool())
  val en_div16            = Input (Bool())
  val reset_sync          = Input (Bool())
  val lp_mode             = Input (Bool())
  val lp_tx               = Input (UInt(2.W))
}


class WavD2DClkTxAnalogBundle extends Bundle{
  val coreclk_div16       = Input (Bool())
  
  val ser_lpb_en          = Output(Bool())
  
  val drv_bypass_out_n    = Output(Bool())
  val drv_bypass_out_p    = Output(Bool())
  val drv_bypass_sel      = Output(Bool())
  val drv_ctrl            = Output(UInt(4.W))
  val drv_en              = Output(Bool())
  val drv_preemp          = Output(UInt(3.W))
  
  val en_tx_div16_clk        = Output(Bool())
  val en_tx_div2_clk         = Output(Bool())
  
  val reset_sync          = Output(Bool())
}


class wav_d2d_clk_ana_tx extends BlackBox{
  val io = IO(new Bundle{
    val clk_tx            = Flipped(new WavD2DClkTxAnalogBundle)
   
    val clk_tx_clk_div16  = Output(Bool())
    val clk_tx_clk_div2   = Output(Bool())
    val clk_tx_clk_div4   = Output(Bool())
    val clk_tx_clk_div8   = Output(Bool())
    val clk_tx_clkb_div2  = Output(Bool())
    
    val clk_tx_pll_clk0   = Input (Bool())
    val clk_tx_pll_clk180 = Input (Bool())
    
    val clk_tx_ser_lpb_p  = Output(Bool())
    val clk_tx_ser_lpb_n  = Output(Bool())
    
    //val pad_clkn_txrx     = Output(Bool())
    //val pad_clkp_txrx     = Output(Bool())
    //Analog is required here as we need to pass strength modelling
    val pad_clkn_txrx     = Analog(1.W)
    val pad_clkp_txrx     = Analog(1.W)
    
    val vdda              = Input (Bool())
    val vddq              = Input (Bool())
    val vss               = Input (Bool())
  })
}


class WavD2DClkTx(val baseAddr: BigInt = 0x0)(implicit p: Parameters) extends LazyModule{
  val device = new SimpleDevice("wavd2dclktx", Seq("wavious,d2dclktx"))
  
  val node = WavAPBRegisterNode(
    address = AddressSet.misaligned(baseAddr, 0x100),
    device  = device,
    //concurrency = 1, //make depending on apn (apb requires 1)
    beatBytes = 4)
  
  
  override lazy val module = new LazyModuleImp(this) with RequireAsyncReset{
    val io = IO(new Bundle{
      val scan          = new WavScanBundle
      val iddq          = Input(Bool())
      val highz         = Input(Bool())
      val bsr           = new WavBSRBundle
      val core          = new WavD2DClkTxCoreBundle
      val ana           = new WavD2DClkTxAnalogBundle
    })
    
    dontTouch(io.bsr)
    
    val coreclk_scan    = WavClockMux(io.scan.mode, io.scan.clk, io.ana.coreclk_div16)
    io.core.coreclk     := coreclk_scan
    
    val core_reset_sync = Wire(Bool())
    io.ana.reset_sync   := core_reset_sync
    
    //BSRs
    //val clk_tx_drv_en_bsr     = WavBSR(1, io.bsr)
    //val clk_tx_lp_mode_bsr    = WavBSR(1, io.bsr)
    val clk_tx_lp_p_data_bsr  = WavBSR(1, io.bsr)
    val clk_tx_lp_n_data_bsr  = WavBSR(1, io.bsr)
    
    (clk_tx_lp_p_data_bsr -> clk_tx_lp_n_data_bsr -> io.bsr.tdo)
    
    
    node.regmap(     
      //-----------------------
      // General Control
      //-----------------------
      WavSWReg(0x0, "CoreOverride", "Overrides for core signals",
        WavRWMux(in=io.core.en,           muxed=io.ana.drv_en,              reg_reset=false.B, mux_reset=false.B, "clk_en",         "",
          corescan=Some(io.scan.mode, false.B), iddq=Some(io.iddq, false.B), highz=Some(io.highz, false.B), bscan=Some(io.bsr.bsr_mode, true.B)),
        WavRWMux(in=io.core.en_div2,      muxed=io.ana.en_tx_div2_clk,      reg_reset=false.B, mux_reset=false.B, "clk_en_div2",    ""),
        WavRWMux(in=io.core.en_div16,     muxed=io.ana.en_tx_div16_clk,     reg_reset=false.B, mux_reset=false.B, "clk_en_div16",   ""),
        WavRWMux(in=io.core.reset_sync,   muxed=core_reset_sync,            reg_reset=false.B, mux_reset=false.B, "clk_reset_sync", "",
          corescan=Some(io.scan.mode, true.B), iddq=Some(io.iddq, true.B))),
      
      //-----------------------
      // Driver
      //-----------------------
      WavSWReg(0x20, "DriverCtrl", "",
        //WavRWMux(in=io.core.drv_en,     muxed=io.ana.drv_en,   reg_reset=false.B, mux_reset=false.B, "drv_en",   ""),
        WavRW   (io.ana.ser_lpb_en,     false.B,  "ser_lpb_en",  ""),
        WavRW   (io.ana.drv_ctrl,       0.U,      "drv_ctrl",    ""),
        WavRW   (io.ana.drv_preemp,     0.U,      "drv_preemp",  "")),
      
      WavSWReg(0x24, "DriverBypass", "",
        WavRWMux(in=io.core.lp_mode,    muxed=io.ana.drv_bypass_sel,   reg_reset=false.B, mux_reset=false.B, "lp_mode",     "",
          corescan=Some(io.scan.mode, false.B), iddq=Some(io.iddq, false.B), highz=Some(io.highz, false.B), bscan=Some(io.bsr.bsr_mode, true.B)),
        WavRWMux(in=io.core.lp_tx(1),   muxed=io.ana.drv_bypass_out_p, reg_reset=false.B, mux_reset=false.B, "lp_data_p",   "",
          bflop=Some(clk_tx_lp_p_data_bsr)),
        WavRWMux(in=io.core.lp_tx(0),   muxed=io.ana.drv_bypass_out_n, reg_reset=false.B, mux_reset=false.B, "lp_data_n",   "",
          bflop=Some(clk_tx_lp_n_data_bsr)))
      
        
    )
     
  }
  
}



/**********************************************************************
*   Generation Wrappers
**********************************************************************/
// class WavD2DClkTxWrapper()(implicit p: Parameters) extends LazyModule{
//   
//   val xbar = LazyModule(new TLXbar)
//   val ApbPort = APBMasterNode(
//     portParams = Seq(APBMasterPortParameters(masters = Seq(APBMasterParameters(name = "ApbPort"))))
//   )
//   val apbport = InModuleBody {ApbPort.makeIOs()}
//   xbar.node := APBToTL() := ApbPort
//   
//   val clktx = LazyModule(new WavD2DClkTx(baseAddr=0)(p))
//   
//   clktx.node := xbar.node
//   
//   lazy val module = new LazyModuleImp(this) with RequireAsyncReset{
//     val io = IO(clktx.module.io.cloneType)
//     
//     io <> clktx.module.io
//   }
//   
// }
// 
// object WavD2DClkTxWrapperGen extends App {  
//   //Create an empty parameter if we have nothing to use
//   //implicit val p: Parameters = Parameters.empty
//   implicit val p: Parameters = new BaseXbarConfig
//   
//   val axiverilog = (new ChiselStage).emitVerilog(
//     LazyModule(new WavD2DClkTxWrapper()(p)).module,
//      
//     //args
//     Array("--target-dir", "output/")
//   )
// }

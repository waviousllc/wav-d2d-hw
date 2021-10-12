package wav.d2d

import wav.common._



import chisel3._
import chisel3.util._
import chisel3.stage.ChiselStage
import chisel3.experimental._


class WavD2DPowerBundle extends Bundle{
  val vdda_rpll         = Input (Bool())
  val vdda_ck           = Input (Bool())
  val vdda              = Input (Bool())
  val vddq              = Input (Bool())
  val vss               = Input (Bool())
}

class WavD2DBumpBundle(val numLanes: Int) extends Bundle{
  val clk_txp           = Analog(1.W)
  val clk_txn           = Analog(1.W)
  
  val clk_rxp           = Analog(1.W)
  val clk_rxn           = Analog(1.W)
  
  val tx                = Output(Vec(numLanes, Bool()))
  val rx                = Input (Vec(numLanes, Bool()))
}


class WavD2DAnalogPhyBlackBox(val numLanes: Int = 8, val processSuffix: String = "") extends BlackBox{

  var moduleName = s"WavD2DAnalogPhy_${numLanes}lane"
  if(processSuffix != "") {
    moduleName = moduleName + s"_${processSuffix}"
  }
  override val desiredName = moduleName
  
  // oh he on x-games mode!!!
  // Steven, why you put the Flipped OUTSIDE the Vec?
  // That's a good question, see the following issue https://github.com/chipsalliance/chisel3/discussions/2038
  
  val io = IO(new Bundle{
    //------------------
    // Digital Side
    //------------------
    val rpll    = Flipped(new WavRpllAnalogBundle)
    val clk_tx  = Flipped(new WavD2DClkTxAnalogBundle)
    val tx      = Flipped(Vec(numLanes, new WavD2DTxAnalogBundle(16)))
    
    val clk_rx  = Flipped(new WavD2DClkRxAnalogBundle)
    val rx      = Flipped(Vec(numLanes, new WavD2DRxAnalogBundle(16)))
    val rxq     = Flipped(Vec(numLanes, new WavD2DRxQPathAnalogBundle(16)))
    
    val ldo     = Flipped(new WavD2DLDOAnalogBundle)
    
    
    //------------------
    // Additional Signals
    //------------------
    val clk_rx_dtst_in  = Input (Bool())
    val clk_rx_dtst     = Output(Bool())
    val rpll_dtest_out  = Output(Bool())
    val rpll_refclk_alt = Input (Bool())
    
    val tie_lo          = Output(Bool())
    val tie_hi          = Output(Bool())
    
    val ext_ibias_5u    = Input (Bool())
    
    //------------------
    // Refclk Passthrough
    //------------------
    val refclk_in   = Input (Bool())
    val refclk_out  = Output(Bool())
    
    //------------------
    // Bumps
    //------------------
    val pad     = new WavD2DBumpBundle(numLanes)
    
    //------------------
    // Power/Grounds
    //------------------
    //val pg      = new WavD2DPowerBundle
    //Not in digital netlists
  })
  
}

/** 
  *   The main analog wrapper. WE use this one for schematic import so 
  *   the power and grounds ARE INCLUDED here and we have a script that 
  *   adds an `ifdef around them
  */
class WavD2DAnalogPhy(val numLanes: Int = 8, val processSuffix: String = "") extends MultiIOModule{

  
  var moduleName = s"WavD2DAnalogPhy_${numLanes}lane"
  if(processSuffix != "") {
    moduleName = moduleName + s"_${processSuffix}"
  }
  override val desiredName = moduleName
  
  //val io = IO(new Bundle{
    //------------------
    // Digital Side
    //------------------
    val rpll        = IO(Flipped(new WavRpllAnalogBundle))
    val clk_tx      = IO(Flipped(new WavD2DClkTxAnalogBundle))
    val tx          = IO(Vec(numLanes, Flipped(new WavD2DTxAnalogBundle(16))))
    
    val clk_rx      = IO(Flipped(new WavD2DClkRxAnalogBundle))
    val rx          = IO(Vec(numLanes, Flipped(new WavD2DRxAnalogBundle(16))))
    val rxq         = IO(Vec(numLanes, Flipped(new WavD2DRxQPathAnalogBundle(16))))
    
    
    
    //------------------
    // Refclk Passthrough
    //------------------
    val refclk_in   = IO(Input (Bool()))
    val refclk_out  = IO(Output(Bool()))
    
    //------------------
    // Power/Grounds
    //------------------
    val pg          = IO(new WavD2DPowerBundle)
    
    //------------------
    // Bumps
    //------------------
    val pad         = IO(new WavD2DBumpBundle(numLanes))
    
    
  //})
  
  //------------------------------------
  // Refclk Passthrough
  //------------------------------------
  // TODO : Do we need to add any kind of buffers here? Maybe a process
  //        specific buffer that a user can override?
  refclk_out   := refclk_in
  
  
  val rpll_ana    = Module(new WavRpllAna(WavRpll14g, includePG=true))
  val clk_tx_ana  = Module(new wav_d2d_clk_ana_tx)
  val tx_ana      = for(i <- 0 until numLanes) yield { Module(new wav_d2d_tx_ana) } 
  
  val clk_rx_ana  = Module(new wav_d2d_clk_ana_rx)
  
  //TODO: Need to figure out a good way to select which lanes
  //      are Ipath and which include Qpath. Probably a Seq
  //      that defines which ones are Qpath.
  //val rxq         = Vec(numLanes, Module(new wav_d2d_rx_ana_IQ).io)
  val rx_ana      = for(i <- 0 until numLanes) yield { Module(new wav_d2d_rx_ana_IQ) }
  
  val tx_ser_lpb_net = Wire(Analog(1.W))
  
  //------------------------------------
  // Ports to Digital
  //------------------------------------
  rpll       <> rpll_ana.io.rpll
  clk_tx     <> clk_tx_ana.io.clk_tx
  clk_rx     <> clk_rx_ana.io.clk_rx
  
  
  for(i <- 0 until numLanes){
    tx(i)    <> tx_ana(i).io.tx
    rx(i)    <> rx_ana(i).io.rx
    rxq(i)   <> rx_ana(i).io.rxq
  }
  
  //------------------------------------
  // Inter-block connections
  //------------------------------------
  rpll_ana.io.vdda.get      := pg.vdda_rpll
  rpll_ana.io.vss.get       := pg.vss
  rpll_ana.io.refclk_alt    := false.B
  rpll_ana.io.refclk        := refclk_in
  
  //-------------
  // CLK Tx
  //-------------
  clk_tx_ana.io.clk_tx_pll_clk0    := rpll_ana.io.clk0
  clk_tx_ana.io.clk_tx_pll_clk180  := rpll_ana.io.clk180
  
  clk_tx_ana.io.vdda        := pg.vdda
  clk_tx_ana.io.vddq        := pg.vddq
  clk_tx_ana.io.vss         := pg.vss
  
  pad.clk_txp        <> clk_tx_ana.io.pad_clkp_txrx
  pad.clk_txn        <> clk_tx_ana.io.pad_clkn_txrx
  
  //-------------
  // Tx
  //-------------
  for(i <- 0 until numLanes){
    tx_ana(i).io.tx_clk_div16_in    := clk_tx_ana.io.clk_tx_clk_div16
    tx_ana(i).io.tx_clk_div2_in     := clk_tx_ana.io.clk_tx_clk_div2
    tx_ana(i).io.tx_clkb_div2_in    := clk_tx_ana.io.clk_tx_clkb_div2
    tx_ana(i).io.tx_clk_div4_in     := clk_tx_ana.io.clk_tx_clk_div4
    tx_ana(i).io.tx_clk_div8_in     := clk_tx_ana.io.clk_tx_clk_div8
    
    pad.tx(i)                       := tx_ana(i).io.pad_tx
    
    tx_ana(i).io.vdda               := pg.vdda
    tx_ana(i).io.vddq               := pg.vddq
    tx_ana(i).io.vss                := pg.vss
    
    attach(tx_ana(i).io.tx_ser_lpb, tx_ser_lpb_net)
    
  }
  
  //-------------
  // CLK Rx
  //-------------
  clk_rx_ana.io.clk_rx_pll_clk0     := rpll_ana.io.clk0
  clk_rx_ana.io.clk_rx_pll_clk90    := rpll_ana.io.clk90
  clk_rx_ana.io.clk_rx_pll_clk180   := rpll_ana.io.clk180
  clk_rx_ana.io.clk_rx_pll_clk270   := rpll_ana.io.clk270
  
  clk_rx_ana.io.clk_rx_dtst_in      := false.B //what should we connect this to?
  
  clk_rx_ana.io.pad_clkp_txrx       <> pad.clk_rxp
  clk_rx_ana.io.pad_clkn_txrx       <> pad.clk_rxn
  
  clk_rx_ana.io.clk_rx_serlb_inp    := clk_tx_ana.io.clk_tx_ser_lpb_p
  clk_rx_ana.io.clk_rx_serlb_inn    := clk_tx_ana.io.clk_tx_ser_lpb_n
  
  clk_rx_ana.io.vdda                := pg.vdda
  clk_rx_ana.io.vddq                := pg.vddq
  clk_rx_ana.io.vss                 := pg.vss
  
  
  
  //-------------
  // Rx
  //-------------
  
  
  for(i <- 0 until numLanes){
    rx_ana(i).io.rx_iclk         := clk_rx_ana.io.clk_rx_iclk
    rx_ana(i).io.rx_iclkb        := clk_rx_ana.io.clk_rx_iclkb
    
    rx_ana(i).io.rxq_qclk        := clk_rx_ana.io.clk_rx_qclk
    rx_ana(i).io.rxq_qclkb       := clk_rx_ana.io.clk_rx_qclkb
    
    rx_ana(i).io.rx_clk_div8_in  := clk_rx_ana.io.clk_rx_clk_div8
    rx_ana(i).io.rx_clk_div16_in := clk_rx_ana.io.clk_rx_clk_div16
    
    attach(rx_ana(i).io.rx_serlb_in, tx_ser_lpb_net)
    
    rx_ana(i).io.rx_iref         := clk_rx_ana.io.clk_rx_vref    
    
    rx_ana(i).io.pad_rx          := pad.rx(i)
    
    rx_ana(i).io.vdda            := pg.vdda
    rx_ana(i).io.vdda_ck         := pg.vdda_ck
    rx_ana(i).io.vss             := pg.vss
  }
  
}





object WavD2DAnalogPhyGen extends App {  
  
  if(args.length != 1){
    println("No outputDir specified!!!")
    System.exit(0)
  }
  val outputDir = args(0)
  
  
  val d2dphyverilog = (new ChiselStage).emitVerilog(
    new WavD2DAnalogPhy(8, "gf12lpp"),
     
    //args
    Array("--target-dir", outputDir/*, "--no-dce"*/)
  )
}


// object WavD2DAnalogPhyBlackBoxGen extends App {  
//   
//   
//   val d2dphyverilog = (new ChiselStage).emitVerilog(
//     new WavD2DAnalogPhyBlackBox(8, "gf12lpp"),
//      
//     //args
//     Array("--target-dir", "WavD2DAnalogPhyBlackBoxRTL/"/*, "--no-dce"*/)
//   )
// }

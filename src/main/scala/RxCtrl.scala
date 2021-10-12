package wav.d2d

import wav.common._
import wav.wlink.{WlinkPHYRxBundle}

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



/**
  *   Main control logic for RX Path
  *
  */


object WavD2DRxCtrlState extends ChiselEnum{
  val IDLE          = Value(0.U)
  val LPXX          = Value(1.U)
  val LP00          = Value(2.U)
  val LP002CLK      = Value(3.U)
  val HSCLKPRE      = Value(4.U)
  val WAIT_SYNC     = Value(5.U)
  val DATA          = Value(6.U)
  val HSEXIT        = Value(7.U)
  val WAIT_LP       = Value(8.U)
}

class WavD2DRxCtrlLogic(val numLanes: Int, val dataWidth: Int)(implicit p: Parameters) extends Module{
  val io = IO(new Bundle{
    val clk                 = Flipped(new WavD2DClkRxCoreBundle)
    val clk_cal             = Flipped(new WavD2DClkRxCoreCalBundle)
    val ldo                 = Flipped(new WavD2DLDOCoreBundle)
    val rx                  = Vec(numLanes, Flipped(new WavD2DRxCoreBundle(dataWidth)))
    val rx_cal              = Vec(numLanes, Flipped(new WavD2DRxCoreCalBundle))
    val link_rx             = new WlinkPHYRxBundle(numLanes * dataWidth)    
    
    val scan_asyncrst_ctrl  = Input (Bool())  //I hate my life
    
    val swi_deskew_bypass   = Input (Bool())
    
    val swi_lp00hsclk_dly   = Input (UInt(5.W))
    val swi_clkpre_dly      = Input (UInt(5.W))
    val swi_hsexit_dly      = Input (UInt(5.W))
    
    val swi_no_em_train_cdr = Input (Bool())
    val swi_auto_cal        = Input (Bool())
    val swi_start_em_delay  = Input (UInt(16.W))      
    val swi_start_cals      = Input (Bool())
    
    val rx_cal_recv         = Output(Bool())
  })
  
  
  val nstate            = WireInit(WavD2DRxCtrlState.IDLE)
  val state             = RegNext(nstate, WavD2DRxCtrlState.IDLE)
  val count_in          = Wire(UInt(16.W))
  val count             = RegNext(count_in, 0.U)
  val in_cal_in         = Wire(Bool())
  val in_cal            = RegNext(in_cal_in, false.B)
  
  val lp_rx_ff2         = WavDemetReset(io.clk.lp_rx)  
  
  //val link_enter_lp_ff2 = WavDemetReset(io.link_rx.rx_enter_lp)
  val rx_link_clk_reset = WavResetSync(io.link_rx.rx_link_clk, reset.asBool, io.scan_asyncrst_ctrl).asAsyncReset
  val link_enter_lp_sync= Module(new WavSyncPulse)
  link_enter_lp_sync.io.clk_in        := io.link_rx.rx_link_clk.asClock
  link_enter_lp_sync.io.clk_in_reset  := rx_link_clk_reset//WavResetSync(io.link_rx.rx_link_clk, reset.asBool, io.scan_asyncrst_ctrl).asAsyncReset
  link_enter_lp_sync.io.data_in       := io.link_rx.rx_enter_lp
  
  link_enter_lp_sync.io.clk_out       := clock
  link_enter_lp_sync.io.clk_out_reset := reset.asAsyncReset
  
  val link_enter_lp     = link_enter_lp_sync.io.data_out
  
  val clk_en_in         = Wire(Bool())
  val clk_en            = RegNext(clk_en_in, false.B)
  val clk_reset_in      = Wire(Bool())
  val clk_reset         = RegNext(clk_reset_in, true.B)
  val clk_lp_mode_in    = Wire(Bool())
  val clk_lp_mode       = RegNext(clk_lp_mode_in, true.B)
  val clk_gate_en_in    = Wire(Bool())
  val clk_gate_en       = RegNext(clk_gate_en_in, false.B)
  
  val rx_en_in          = Wire(Bool())
  val rx_en             = RegNext(rx_en_in, false.B)
  val rx_reset_in       = Wire(Bool())
  val rx_reset          = RegNext(rx_reset_in, true.B)
  
  val run_lane_cals_in  = Wire(Bool())
  val run_lane_cals     = RegNext(run_lane_cals_in, false.B)
  val lane_cals_done    = WavDemetReset(io.rx_cal.map(_.rx_sampler_cal_done).reduce(_&&_) & io.clk_cal.cal_done)  //foreach rx_samp_cal_don in the rx_cal vec, in case you were wondering
  
  val lane_cals_ran_in  = Wire(Bool())
  val lane_cals_ran     = RegNext(lane_cals_ran_in, false.B)
  lane_cals_ran_in      := Mux((state =/= WavD2DRxCtrlState.DATA), false.B, //clear when exiting data state
                           Mux(lane_cals_ran, true.B, lane_cals_done))
  
  val run_em_in         = Wire(Bool())
  val run_em            = RegNext(run_em_in, false.B)
  
  val lp11_seen_in      = Wire(Bool())
  val lp11_seen         = RegNext(lp11_seen_in, false.B)
  
  val ldo_en_in         = Wire(Bool())
  val ldo_en            = RegNext(ldo_en_in, false.B)
  
  
  nstate                := state
  count_in              := 0.U
  in_cal_in             := in_cal
  clk_en_in             := clk_en
  clk_lp_mode_in        := clk_lp_mode
  clk_reset_in          := clk_reset
  clk_gate_en_in        := clk_gate_en
  
  rx_en_in              := rx_en
  rx_reset_in           := rx_reset
  
  run_lane_cals_in      := run_lane_cals
  run_em_in             := run_em
  lp11_seen_in          := false.B
  ldo_en_in             := true.B
  
  
  
  when(state === WavD2DRxCtrlState.IDLE){
    //=================================================
    //
    clk_en_in           := false.B
    run_lane_cals_in    := false.B
    run_em_in           := false.B
    
    lp11_seen_in        := Mux((lp_rx_ff2 === WavD2DLPState.LP11.asUInt), true.B, lp11_seen)  //ensure we see LP11 before exiting
    
    when((lp_rx_ff2 === WavD2DLPState.LP01.asUInt || lp_rx_ff2 === WavD2DLPState.LP10.asUInt) && lp11_seen){
      in_cal_in         := (lp_rx_ff2 === WavD2DLPState.LP01.asUInt)
      nstate            := WavD2DRxCtrlState.LPXX
    }
    
  }.elsewhen(state === WavD2DRxCtrlState.LPXX){
    //=================================================
    // TODO: See about adding in a feature to go ahead and deassert the clk_reset.
    //       It's possible that by the time we see LP00 the clock could already have been
    //       up and we just immediately deassert the reset and skip to HSCLKPRE (or even SYNC)
    when(lp_rx_ff2 === WavD2DLPState.LP00.asUInt){
      clk_lp_mode_in    := true.B
      clk_en_in         := true.B
      clk_reset_in      := true.B     //keep the reset active until the clock is up
      rx_en_in          := false.B
      rx_reset_in       := true.B
      count_in          := io.swi_lp00hsclk_dly
      nstate            := WavD2DRxCtrlState.LP002CLK
    }
    
  }.elsewhen(state === WavD2DRxCtrlState.LP002CLK){
    //=================================================
    // Clock receiver is enabled, however we are still in reset to mitigate
    // bad clock transitions for initial clock
    
    when(count === 0.U){
      clk_reset_in      := false.B
      rx_en_in          := true.B
      count_in          := io.swi_clkpre_dly
      nstate            := WavD2DRxCtrlState.HSCLKPRE
    }.otherwise{
      count_in          := count - 1.U
    }
    
  }.elsewhen(state === WavD2DRxCtrlState.HSCLKPRE){
    //=================================================
    // Keep data path disabled
    
    when(count === 0.U){
      clk_gate_en_in    := true.B
      rx_reset_in       := false.B
      nstate            := WavD2DRxCtrlState.DATA
      
      //
      when(in_cal){
        count_in        := io.swi_start_em_delay
      }
    }.otherwise{
      count_in          := count - 1.U
    }
    
  }.elsewhen(state === WavD2DRxCtrlState.DATA){
    //=================================================
    // 
    
    run_lane_cals_in    := io.swi_auto_cal && in_cal && ~lane_cals_ran
    
    when(count === 0.U){
      run_em_in         := io.swi_auto_cal && in_cal && lane_cals_ran
    }.otherwise{
      count_in          := count - 1.U
    }
    
    //when(link_enter_lp_ff2){
    when(link_enter_lp){
      run_lane_cals_in  := false.B  //Kill if LP is entered
      run_em_in         := false.B
      in_cal_in         := false.B
      clk_gate_en_in    := false.B
      count_in          := io.swi_hsexit_dly
      nstate            := WavD2DRxCtrlState.HSEXIT
    }
    
  }.elsewhen(state === WavD2DRxCtrlState.HSEXIT){
    //=================================================
    // At the end of the count, disable the CLK/RX
    
    when(count === 0.U){
      clk_en_in         := false.B
      clk_reset_in      := true.B
      rx_en_in          := false.B
      rx_reset_in       := true.B
      nstate            := WavD2DRxCtrlState.WAIT_LP
    }.otherwise{
      count_in          := count - 1.U
    }
    
  }.elsewhen(state === WavD2DRxCtrlState.WAIT_LP){
    //=================================================
    // 
    
    when(lp_rx_ff2 === WavD2DLPState.LP01.asUInt || lp_rx_ff2 === WavD2DLPState.LP10.asUInt){
      nstate            := WavD2DRxCtrlState.LPXX
    }
    
  }.otherwise{
    //=================================================
    // Default
    nstate              := WavD2DRxCtrlState.IDLE
  }
  
  
  //LP11 Check
  //How can we disable everything gracefully
  when(lp_rx_ff2 === WavD2DLPState.LP11.asUInt){
    clk_reset_in        := true.B
    rx_en_in            := false.B
    rx_reset_in         := true.B
    nstate              := WavD2DRxCtrlState.IDLE
  }
  
  io.rx_cal_recv        := in_cal
  
  io.clk.en             := clk_en
  io.clk.lp_mode        := clk_lp_mode
  io.clk.reset_sync     := clk_reset
  io.clk.clk_gate_en    := clk_gate_en
  
  io.clk.start_eye_map  := run_em & ~io.swi_no_em_train_cdr
  io.clk.train_cdr      := run_em &  io.swi_no_em_train_cdr
  
  val rx_lane_active = Wire(Vec(numLanes, Bool()))
  for(i <- 0 until numLanes) rx_lane_active(i) := i.asUInt <= io.link_rx.rx_active_lanes
  
  
  //Deskew Fifo
  val deskew_fifo   = withClockAndReset(io.link_rx.rx_link_clk.asClock, rx_link_clk_reset){
    Module(new WavD2DRxCtrlDeskewFifo(numLanes=numLanes, dataWidth=dataWidth, depth=4))
  }
  deskew_fifo.enable        := ~rx_reset && ~in_cal //the reset is held longer than the enable and the clock can be missed
  deskew_fifo.bypass        := io.swi_deskew_bypass
  deskew_fifo.lanes_active  := rx_lane_active
  for(i <- 0 until numLanes){
    deskew_fifo.data_in(i)  := io.rx(i).rx_rd
    deskew_fifo.locked_in(i):= io.rx(i).rx_locked
  }
  
  
  //Why Vec? -> https://github.com/chipsalliance/chisel3/wiki/Cookbook#how-do-i-do-subword-assignment-assign-to-some-bits-in-a-uint
  val rx_link_data      = Wire(Vec(numLanes, UInt(dataWidth.W)))
  for(i <- 0 until numLanes){
    io.rx(i).rx_en      := rx_en    & rx_lane_active(i)
    io.rx(i).rx_reset   := rx_reset | ~rx_lane_active(i)
    
    rx_link_data(i)     := deskew_fifo.data_out(i)//io.rx(i).rx_rd
    
    
    io.rx_cal(i).rx_sampler_cal_en  := (io.swi_start_cals | run_lane_cals) & rx_lane_active(i)
    io.clk_cal.cal_en               := (io.swi_start_cals | run_lane_cals) & rx_lane_active(i)
  }  
  
  
  
  
  
  io.link_rx.rx_link_data   := rx_link_data.asUInt
  io.link_rx.rx_data_valid  := deskew_fifo.valid && ~in_cal//io.rx(0).rx_locked && ~in_cal //should I demet the in_cal? It would be set prior to the clock coming on
  io.link_rx.rx_link_clk    := io.clk.coreclk
  
  
  io.ldo.en                 := ldo_en
  
}







/**********************************************************************
*   Generation Wrappers
**********************************************************************/

object WavD2DRxCtrlLogicGen extends App {  
  //Create an empty parameter if we have nothing to use
  //implicit val p: Parameters = Parameters.empty
  implicit val p: Parameters = new BaseXbarConfig
  
  val axiverilog = (new ChiselStage).emitVerilog(
    new WavD2DRxCtrlLogic(2,16),
     
    //args
    Array("--target-dir", "output/")
  )
}



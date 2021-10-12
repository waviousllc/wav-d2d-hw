package wav.d2d

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


/**
  *   A Simple Deskew Fifo that used the Locked signal from the RX
  *   to indicate data is good. Likely unneeded since we are clock
  *   forwarding and have little skew, but here just in case
  */
object WavD2DRxCtrlDeskewFifoState extends ChiselEnum{
  val IDLE    = Value(0.U)
  val LOCKED  = Value(1.U)
}

class WavD2DRxCtrlDeskewFifo(val numLanes: Int, val dataWidth: Int, val depth: Int = 4)(implicit p: Parameters) extends MultiIOModule{
  
  val enable          = IO(Input (Bool()))
  val bypass          = IO(Input (Bool()))
  val lanes_active    = IO(Vec(numLanes, Input (Bool())))
  val data_in         = IO(Vec(numLanes, Input (UInt(dataWidth.W))))
  val locked_in       = IO(Vec(numLanes, Input (Bool())))
  
  val data_out        = IO(Vec(numLanes, Output(UInt(dataWidth.W))))
  val locked_out      = IO(Vec(numLanes, Output(Bool())))
  val valid           = IO(Output(Bool()))
  
  
  val enable_ff2      = WavDemetReset(enable)
  val nstate          = WireInit(WavD2DRxCtrlDeskewFifoState.IDLE)
  val state           = RegNext(nstate, WavD2DRxCtrlDeskewFifoState.IDLE)
  
  //Index1 - Lane
  //Index2 - entry
  //msb is locked
  val fifo = Seq.fill(numLanes) {RegInit(0.U.asTypeOf(Vec(depth, UInt((dataWidth+1).W))))}
  
  val wptr = Seq.fill(numLanes) {RegInit(0.U((log2Ceil(depth).W)))}
  val rptr = Seq.fill(numLanes) {RegInit(0.U((log2Ceil(depth).W)))}
  
  val lane_has_locked = Wire(Vec(numLanes, Bool()))
  for(lane <- 0 until numLanes){
    lane_has_locked(lane) := fifo(lane)(0)(dataWidth)
  }
  
  val all_lanes_good  = Wire(Bool())
  all_lanes_good      := (lane_has_locked.asUInt | ~lanes_active.asUInt).andR
  
  val valid_reg_in    = Wire(Bool())
  val valid_reg       = RegNext(valid_reg_in, false.B)
  
  
  def clearFifo: Unit = {
    for(lane <- 0 until numLanes){
      wptr(lane)        := 0.U
      rptr(lane)        := 0.U
      for(ent <- 0 until depth){
        fifo(lane)(ent) := 0.U
      }
    }
  }
  
  def writeFifo: Unit = {
    for(lane <- 0 until numLanes){
      fifo(lane)(wptr(lane)) := Mux(lanes_active(lane) && locked_in(lane), Cat(locked_in(lane), data_in(lane)), 0.U)
    }
  }
  
  
  nstate          := state
  valid_reg_in    := valid_reg
  
  when(state === WavD2DRxCtrlDeskewFifoState.IDLE){
    clearFifo
    valid_reg_in        := false.B
    
    when(enable_ff2 & ~bypass){
      writeFifo
      for(lane <- 0 until numLanes){
        wptr(lane)      := Mux(lanes_active(lane) && locked_in(lane), Mux(wptr(lane) === (depth-1).asUInt, 0.U, wptr(lane) + 1.U), wptr(lane))
      }
      when(all_lanes_good){
        for(lane <- 0 until numLanes){
          rptr(lane)    := Mux(lanes_active(lane), Mux(rptr(lane) === (depth-1).asUInt, 0.U, rptr(lane) + 1.U), 0.U)
        }
        valid_reg_in    := true.B
        nstate          := WavD2DRxCtrlDeskewFifoState.LOCKED
      }
    }
  }.elsewhen(state === WavD2DRxCtrlDeskewFifoState.LOCKED){
    when(enable_ff2){
      writeFifo
      for(lane <- 0 until numLanes){
        wptr(lane)      := Mux(wptr(lane) === (depth-1).asUInt, 0.U, wptr(lane) + 1.U)
        rptr(lane)      := Mux(rptr(lane) === (depth-1).asUInt, 0.U, rptr(lane) + 1.U)
      }
    }.otherwise{
      clearFifo
      valid_reg_in      := false.B
      nstate            := WavD2DRxCtrlDeskewFifoState.IDLE
    }
  }.otherwise{
    nstate              := WavD2DRxCtrlDeskewFifoState.IDLE
  }
  
  
  for(lane <- 0 until numLanes){
    data_out(lane)      := Mux(bypass, data_in(lane),   fifo(lane)(rptr(lane))(dataWidth-1,0))
    locked_out(lane)    := Mux(bypass, locked_in(lane), fifo(lane)(rptr(lane))(dataWidth))
  }
  valid                 := Mux(bypass, locked_in(0), valid_reg)
  
  
}

object WavD2DRxCtrlDeskewFifoGen extends App {  
  //Create an empty parameter if we have nothing to use
  //implicit val p: Parameters = Parameters.empty
  implicit val p: Parameters = Parameters.empty
  
  val deskewverilog = (new ChiselStage).emitVerilog(
    new WavD2DRxCtrlDeskewFifo(2,16),
     
    //args
    Array("--target-dir", "output/")
  )
}

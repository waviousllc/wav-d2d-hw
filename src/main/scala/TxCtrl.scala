package wav.d2d

import wav.common._
import wav.wlink.{WlinkPHYTxBundle}

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



object WavD2DTxCtrlState extends ChiselEnum{
  val IDLE              = Value(0.U)
  val PLL_INIT          = Value(1.U) 
  val CAL_LP01          = Value(2.U)
  val CAL_CLK_EN        = Value(3.U)
  val CAL_CLK_DE_RESET  = Value(4.U)
  
  val P1                = Value(5.U)
  val P2                = Value(6.U)  
  val P3                = Value(7.U)
  val EN_CLK            = Value(8.U)
  val CLK_DE_RESET      = Value(9.U)
  val CLK_SWITCH        = Value(10.U)  
  val LP00              = Value(13.U)
  val HS_CLK_PRE        = Value(14.U)
  
  val SYNC              = Value(15.U)
  val DATA              = Value(16.U)
  val CLK_DRV_DISABLE   = Value(17.U)
  val SWITCH2REFCLK     = Value(18.U)
  
}

object WavD2DLPState extends ChiselEnum{
  val LP00 = Value(0.U)
  val LP01 = Value(1.U)
  val LP10 = Value(2.U)
  val LP11 = Value(3.U)
}

object WavD2DPState extends ChiselEnum{
  val P1    = Value(1.U)
  val P2    = Value(2.U)
  val P3    = Value(3.U)
}

/**
  *   Main Control Logic for TX Path
  *
  *   We handle the clock swtich externally to reduce the number of clocks required for this module
  *   I'm getting a little tired of having 42 clocks in each block. 
  */
class WavD2DTxCtrlLogic(val numLanes: Int, val dataWidth: Int)(implicit p: Parameters) extends Module{
  val io = IO(new Bundle{
    val enable                = Input (Bool())    //Main global enable signal
    val pll                   = Flipped(new WavRpllCoreBundle)
    val clk                   = Flipped(new WavD2DClkTxCoreBundle)
    val ldo                   = Flipped(new WavD2DLDOCoreBundle)
    val tx                    = Vec(numLanes, Flipped(new WavD2DTxCoreBundle(dataWidth)))
    val tx_bist_en            = Output(Bool())
    val link_tx               = new WlinkPHYTxBundle(numLanes * dataWidth)
    
    val pstate                = Input (UInt(2.W))
    val swi_min_lpxx_hs       = Input (UInt(10.W))
    val swi_min_lpxx_ref      = Input (UInt(10.W))
    
    val swi_clken2rst_dly     = Input (UInt(10.W))
    val swi_clkswitch_dly     = Input (UInt(10.W))
    val swi_clkrst2drv_dly    = Input (UInt(10.W))
    val swi_clkpre_dly        = Input (UInt(10.W))
    val swi_sync_cycles       = Input (UInt(10.W))
    val swi_clktrail_dly      = Input (UInt(10.W))
    
    val rx_cal_recv           = Input (Bool())      //Local RX has been requested to perform a calibration    
    val swi_auto_cal          = Input (Bool())      //1 - Auto perform calibrations upon first boot
    val swi_tx_disable_delay  = Input (UInt(20.W))  //Number of cycles to wait after entering DATA state in cals to enable the TX with data
    val swi_tx_cal_count      = Input (UInt(20.W))
    
    val swi_sync_word         = Input (UInt(dataWidth.W))
    val swi_min_idle_time     = Input (UInt(10.W))
    val swi_need_cals_block   = Input (Bool())
    
    val swi_cal_en            = Input (Bool())
    val swi_tx_highz          = Input (Bool())
    val swi_data_en           = Input (Bool())
    
    val use_core_clk          = Output(Bool())
    val state                 = Output(WavD2DTxCtrlState())
    
  })
  
  
  val nstate            = WireInit(WavD2DTxCtrlState.IDLE)
  val state             = RegNext(nstate, WavD2DTxCtrlState.IDLE)
  
  val use_core_clk_in   = Wire(Bool())
  val use_core_clk      = RegNext(use_core_clk_in, false.B)
  
  val enable_ff2        = WavDemetReset(io.enable)
  
  val count_in          = Wire(UInt(10.W))
  val count             = RegNext(count_in, 0.U)
  
  val pll_en_in         = Wire(Bool())
  val pll_en            = RegNext(pll_en_in, false.B)
  val pll_ready_ff2     = WavDemetReset(io.pll.ready)
  val pll_ret_in        = Wire(Bool())
  val pll_ret           = RegNext(pll_ret_in, false.B)
  
  val clk_not_in_reset  = RegNext(true.B, false.B)
  
  val clk_en_in         = Wire(Bool())
  val clk_en            = RegNext(clk_en_in, false.B)
  val clk_reset_in      = Wire(Bool())
  val clk_reset         = RegNext(clk_reset_in, true.B)
  val clk_drv_en_in     = Wire(Bool())
  val clk_drv_en        = RegNext(clk_drv_en_in, false.B)
  val lp_tx_in          = WireInit(WavD2DLPState.LP11)
  val lp_tx             = RegNext(lp_tx_in, WavD2DLPState.LP11)
  val lp_mode_in        = Wire(Bool())
  val lp_mode           = RegNext(lp_mode_in, true.B)
  
  val tx_en_in          = Wire(Bool())
  val tx_en             = RegNext(tx_en_in, false.B)
  val tx_reset_in       = Wire(Bool())
  val tx_reset          = RegNext(tx_reset_in, true.B)
  val tx_ready_in       = Wire(Bool())
  val tx_ready          = RegNext(tx_ready_in, false.B)
  val tx_td             = Wire(Vec(numLanes, UInt(dataWidth.W)))
  
  val in_cal_in         = Wire(Bool())
  val in_cal            = RegNext(in_cal_in, false.B)
  
  // When auto_cals are enabled, anytime the link is enabled with the main_enable we will go through
  // and automatically run calibrations. 
  val need_cals_in      = Wire(Bool())
  val need_cals         = RegNext(need_cals_in, true.B)
  need_cals_in          := Mux(~enable_ff2, true.B, Mux((state === WavD2DTxCtrlState.DATA) && in_cal, false.B, need_cals))
  
  // Have this set when RX sends indication, but clear it once this side starts the calibration in data clear this to
  // prevent getting stuck in calibration
  val rx_cal_recv_smack       = WavDemetReset(io.rx_cal_recv)
  val rx_cal_recv_smack_ff3   = RegNext(rx_cal_recv_smack, false.B)
  val rx_cal_recv_one_shot_in = Wire(Bool())
  val rx_cal_recv_one_shot    = RegNext(rx_cal_recv_one_shot_in, false.B)
  rx_cal_recv_one_shot_in     := Mux(rx_cal_recv_smack & ~rx_cal_recv_smack_ff3, true.B, 
                                 Mux(in_cal & (state === WavD2DTxCtrlState.DATA), false.B, rx_cal_recv_one_shot))
  
  val data_trans_en_ff2 = (WavDemetReset(io.swi_data_en) || io.link_tx.tx_en) & (~need_cals | io.swi_need_cals_block)  //block data transmission until cals have been performed
  val cal_en_ff2        = WavDemetReset((io.swi_cal_en || (need_cals && enable_ff2) || rx_cal_recv_one_shot))
  
  
  
  
  
  val cal_exit_in       = Wire(Bool())
  val cal_exit          = RegNext(cal_exit_in, false.B)
  
  val tx_disable_count_in = Wire(UInt(20.W))
  val tx_disable_count    = RegNext(tx_disable_count_in, 0.U)
  tx_disable_count_in     := Mux((state === WavD2DTxCtrlState.DATA) && in_cal, Mux(tx_disable_count === 0.U, 0.U, tx_disable_count - 1.U), io.swi_tx_disable_delay)
  
  //If in auto cal, use the counter, register can always override
  val block_tx_for_cal  = (in_cal & (tx_disable_count.orR | ~io.swi_auto_cal)) || WavDemetReset(io.swi_tx_highz)
  
  val bist_en_in        = Wire(Bool())
  val bist_en           = RegNext(bist_en_in, false.B)
  bist_en_in            := ~block_tx_for_cal & io.swi_auto_cal & in_cal & (state === WavD2DTxCtrlState.DATA)
  
  val cal_count_in      = Wire(UInt(20.W))
  val cal_count         = RegNext(cal_count_in, 0.U)
  cal_count_in          := Mux(io.swi_auto_cal & in_cal & (state === WavD2DTxCtrlState.DATA) && (tx_disable_count === 0.U), Mux(cal_count === 0.U, 0.U, cal_count - 1.U), io.swi_tx_cal_count)
  
  val end_cal_cond      = (cal_count === 0.U && io.swi_auto_cal) || (~cal_en_ff2 && ~io.swi_auto_cal)
  
  val ldo_en_in         = Wire(Bool())
  val ldo_en            = RegNext(ldo_en_in, false.B)
  
  
  nstate                := state
  use_core_clk_in       := use_core_clk
  clk_en_in             := clk_en
  clk_reset_in          := clk_reset
  clk_drv_en_in         := clk_drv_en
  count_in              := count
  pll_en_in             := pll_en
  pll_ret_in            := pll_ret
  lp_mode_in            := lp_mode
  lp_tx_in              := lp_tx
  
  tx_en_in              := tx_en
  tx_reset_in           := tx_reset
  tx_ready_in           := tx_ready
  
  in_cal_in             := in_cal
  cal_exit_in           := cal_exit
  ldo_en_in             := true.B
  
  
  when(state === WavD2DTxCtrlState.IDLE){
    //============================================
    // Disabled/Reset state
    // Here we will hold the line at LP-11. This will indicate to the 
    // other side that this transmitter is completely disabled.
    
    pll_en_in           := ~cal_exit
    lp_tx_in            := WavD2DLPState.LP11
    lp_mode_in          := true.B
    
    clk_en_in           := false.B
    clk_reset_in        := true.B
    clk_drv_en_in       := false.B
    
    in_cal_in           := false.B
    
    when(enable_ff2){
      when(count === io.swi_min_idle_time){
        when(cal_en_ff2){
          lp_tx_in          := WavD2DLPState.LP01
          count_in          := io.swi_min_lpxx_ref
          pll_en_in         := true.B
          in_cal_in         := true.B
          nstate            := WavD2DTxCtrlState.PLL_INIT //always go to PLL
        }.elsewhen(data_trans_en_ff2){
          // Anytime we are coming out of IDLE, go through the P3 state, it will ensure that we have
          // handled any PLL initialization. 
          lp_tx_in          := WavD2DLPState.LP10
          count_in          := io.swi_min_lpxx_ref
          nstate            := WavD2DTxCtrlState.P3
        }
      }.otherwise{
        count_in            := count + 1.U
      }
    }
  }.elsewhen(state === WavD2DTxCtrlState.PLL_INIT){
    //============================================
    // Wait for the PLL to be enabled
    //
    
    //Count for min LP state time
    when(count =/= 0.U){
      count_in          := count - 1.U
    }
    
    when(pll_ready_ff2){
      clk_en_in         := Mux(cal_en_ff2, false.B,                    true.B)
      count_in          := Mux(cal_en_ff2, count,                      io.swi_clken2rst_dly)
      nstate            := Mux(cal_en_ff2, WavD2DTxCtrlState.CAL_LP01, WavD2DTxCtrlState.EN_CLK)
    }
  }.elsewhen(state === WavD2DTxCtrlState.CAL_LP01){
    //============================================
    // CAL_LP01 is the low power state in which the EXIT would be for a calibration action
    // We should only ever enter here through LP11!
    
    // A minimum LP time may be needed to ensure the RX side correctly sees
    // the LP state entry and exit properly.  This prevents the link from "bouncing"
    // faster than the RX can recognize
    when(count =/= 0.U){
      count_in          := count - 1.U
    }
    
    when(cal_en_ff2 && count === 0.U){
      lp_tx_in          := WavD2DLPState.LP00
      clk_en_in         := true.B
      count_in          := io.swi_clken2rst_dly
      nstate            := WavD2DTxCtrlState.CAL_CLK_EN
    }.elsewhen(~cal_en_ff2){
      lp_tx_in          := WavD2DLPState.LP11
      clk_reset_in      := true.B
      clk_en_in         := false.B
      nstate            := WavD2DTxCtrlState.IDLE
    }
    
  }.elsewhen(state === WavD2DTxCtrlState.CAL_CLK_EN){
    //============================================
    // Enable the Clock logic, but still in reset
    //
    when(count === 0.U){
      clk_reset_in      := false.B
      //use_core_clk_in   := true.B
      count_in          := io.swi_clkrst2drv_dly
      nstate            := WavD2DTxCtrlState.CAL_CLK_DE_RESET 
    }.otherwise{
      count_in          := count - 1.U
    }
    
  }.elsewhen(state === WavD2DTxCtrlState.CAL_CLK_DE_RESET){
    //============================================
    // Out of reset, we can switch to clock
    //
    use_core_clk_in     := true.B
    
    when(count === 0.U){
      clk_drv_en_in     := true.B
      count_in          := io.swi_clkpre_dly
      nstate            := WavD2DTxCtrlState.HS_CLK_PRE
    }.otherwise{
      count_in          := count - 1.U
    }
   
  }.elsewhen(state === WavD2DTxCtrlState.HS_CLK_PRE){
    //============================================
    // Clock should start transmitting but be ignored by RX
    //
    lp_mode_in          := false.B    //make this a SW control?
    when(count === 0.U){
      count_in          := io.swi_sync_cycles
      nstate            := WavD2DTxCtrlState.SYNC 
    }.otherwise{
      count_in          := count - 1.U
    }
    
  }.elsewhen(state === WavD2DTxCtrlState.SYNC){
    //============================================
    // Sending sync patterns
    //
    when(count === 0.U){
      tx_ready_in       := ~in_cal
      count_in          := io.swi_clktrail_dly
      nstate            := WavD2DTxCtrlState.DATA 
    }.otherwise{
      count_in          := count - 1.U
    }
    
  }.elsewhen(state === WavD2DTxCtrlState.DATA){
    //============================================
    // Stay here until end of DATA or end of cal
    //
    
    tx_en_in            := ~block_tx_for_cal
    tx_reset_in         := block_tx_for_cal
    
    when((in_cal && end_cal_cond/*~cal_en_ff2*/) || (~in_cal && ~data_trans_en_ff2)){
      //lp_mode_in        := true.B
      //tx_ready_in       := false.B
      tx_en_in          := false.B        //TODO: Probably need to keep enabled to keep from highzing?
      tx_reset_in       := true.B
      
      
      when(count === 0.U){
        clk_drv_en_in   := false.B
        tx_ready_in     := false.B      //Perform here so the pstate controller don't start while in clock trail
        when(in_cal || io.pstate === WavD2DPState.P2.asUInt || io.pstate === WavD2DPState.P3.asUInt){
          use_core_clk_in := false.B
        }
        count_in        := io.swi_clkswitch_dly
        nstate          := WavD2DTxCtrlState.CLK_DRV_DISABLE
      }.otherwise{
        count_in        := count - 1.U
      }
    }
  }.elsewhen(state === WavD2DTxCtrlState.CLK_DRV_DISABLE){
    //============================================
    // Clock driver is disabled. Depending on the PSTATE we will either
    // switch to changing the clock or just keep the driver disabled
    
    lp_mode_in          := true.B
    
    when(count === 0.U){
      when(in_cal){
        lp_tx_in          := WavD2DLPState.LP01
        count_in          := io.swi_min_lpxx_ref
        nstate            := WavD2DTxCtrlState.CAL_LP01
      }.elsewhen(io.pstate === WavD2DPState.P1.asUInt){
        lp_tx_in          := WavD2DLPState.LP10
        count_in          := io.swi_min_lpxx_hs
        nstate            := WavD2DTxCtrlState.P1
      }.elsewhen(io.pstate === WavD2DPState.P2.asUInt){
        clk_reset_in      := true.B
        clk_en_in         := false.B
        lp_tx_in          := WavD2DLPState.LP10
        count_in          := io.swi_min_lpxx_ref
        nstate            := WavD2DTxCtrlState.P2
      }.otherwise{
        clk_reset_in      := true.B
        clk_en_in         := false.B
        pll_en_in         := false.B
        lp_tx_in          := WavD2DLPState.LP10
        count_in          := io.swi_min_lpxx_ref
        nstate            := WavD2DTxCtrlState.P3
      }
    }.otherwise{
      count_in        := count - 1.U
    }
    
  }.elsewhen(state === WavD2DTxCtrlState.P3){
    //============================================
    // 
    when(count =/= 0.U){
      count_in          := count - 1.U
    }
    
    when(count === 0.U && data_trans_en_ff2){
      pll_en_in         := true.B
      nstate            := WavD2DTxCtrlState.PLL_INIT
    }
    
  }.elsewhen(state === WavD2DTxCtrlState.EN_CLK){
    //============================================
    // 
    
    when(count === 0.U){
      count_in          := io.swi_clkswitch_dly
      clk_reset_in      := false.B
      nstate            := WavD2DTxCtrlState.CLK_DE_RESET
    }.otherwise{
      count_in          := count - 1.U
    }
    
  }.elsewhen(state === WavD2DTxCtrlState.CLK_DE_RESET){
    //============================================
    // 
    
    when(count === 0.U){
      count_in          := io.swi_clkswitch_dly
      use_core_clk_in   := true.B
      nstate            := WavD2DTxCtrlState.CLK_SWITCH
    }.otherwise{
      count_in          := count - 1.U
    }
    
  }.elsewhen(state === WavD2DTxCtrlState.CLK_SWITCH){
    //============================================
    // 
    
    when(count === 0.U){
      count_in          := io.swi_clkrst2drv_dly
      use_core_clk_in   := true.B
      lp_tx_in          := WavD2DLPState.LP00
      nstate            := WavD2DTxCtrlState.LP00
    }.otherwise{
      count_in          := count - 1.U
    }
    
  }.elsewhen(state === WavD2DTxCtrlState.LP00){
    //============================================
    // 
    tx_en_in            := true.B
    tx_reset_in         := false.B
    
    when(count === 0.U){
      count_in          := io.swi_clkpre_dly
      lp_mode_in        := false.B
      clk_drv_en_in     := true.B
      nstate            := WavD2DTxCtrlState.HS_CLK_PRE
    }.otherwise{
      count_in          := count - 1.U
    }
    
  }.elsewhen(state === WavD2DTxCtrlState.P1){
    //============================================
    // 
    
    when(count === 0.U){
      when(data_trans_en_ff2){
        count_in        := io.swi_clkrst2drv_dly
        lp_tx_in        := WavD2DLPState.LP00
        nstate          := WavD2DTxCtrlState.LP00
      }
    }.otherwise{
      count_in          := count - 1.U
    }
    
  }.elsewhen(state === WavD2DTxCtrlState.P2){
    //============================================
    // 
    pll_ret_in          := true.B
    
    when(count === 0.U){
      when(data_trans_en_ff2){
        pll_ret_in      := false.B
        nstate          := WavD2DTxCtrlState.PLL_INIT    
      }
    }.otherwise{
      count_in          := count - 1.U
    }
    
  }.otherwise{
    // Default
    nstate              := WavD2DTxCtrlState.IDLE
  }
  
  when(~enable_ff2){
    nstate              := WavD2DTxCtrlState.IDLE
  }
  
  io.pll.reset          := ~pll_en
  io.pll.ret            := pll_ret
  
  io.clk.lp_mode        := lp_mode
  io.clk.lp_tx          := lp_tx.asUInt
  io.clk.en             := clk_not_in_reset

  io.clk.en_div2        := clk_en
  io.clk.en_div16       := clk_en
  io.clk.reset_sync     := clk_reset
  
  io.ldo.en             := ldo_en
  
  io.use_core_clk       := use_core_clk
  
  val tx_lane_active = Wire(Vec(numLanes, Bool()))
  for(i <- 0 until numLanes) tx_lane_active(i) := i.asUInt <= io.link_tx.tx_active_lanes
  
  
  io.tx_bist_en         := bist_en
  for(i <- 0 until numLanes){
    io.tx(i).tx_en      := tx_en    & tx_lane_active(i)
    io.tx(i).tx_reset   := tx_reset | ~tx_lane_active(i)
    io.tx(i).tx_td      := tx_td(i)
    
    tx_td(i)            := Mux((state === WavD2DTxCtrlState.DATA) & tx_lane_active(i), io.link_tx.tx_link_data((dataWidth*i)+dataWidth-1, dataWidth*i),
                           Mux((state === WavD2DTxCtrlState.SYNC) & tx_lane_active(i), io.swi_sync_word, 0.U))
  }
  
  dontTouch(io.link_tx)
  io.link_tx.tx_link_clk := clock.asBool //should I do this?
  io.link_tx.tx_ready    := tx_ready
  
  io.state               := state
  
}




/**********************************************************************
*   Generation Wrappers
**********************************************************************/


object WavD2DTxCtrlLogicGen extends App {  
  //Create an empty parameter if we have nothing to use
  //implicit val p: Parameters = Parameters.empty
  implicit val p: Parameters = new BaseXbarConfig
  
  val axiverilog = (new ChiselStage).emitVerilog(
    new WavD2DTxCtrlLogic(2,16),
     
    //args
    Array("--target-dir", "output/")
  )
}

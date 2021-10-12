package wav.d2d

import wav.common._

import chisel3._
import chisel3.util._
import chisel3.stage.ChiselStage
import chisel3.experimental._
import freechips.rocketchip.config._




/*
 *  Generates one of four fixed patterns
 *    1/2/4 bit long "clock"
 *    SW based pattern
 */
class WavD2DBistFixed (
  dataWidth : Int = 16,
  MODE_55   : UInt = 0.U,
  MODE_CC   : UInt = 1.U,
  MODE_F0   : UInt = 2.U,
  MODE_PAT  : UInt = 3.U
)(implicit p: Parameters) extends Module with RequireAsyncReset{
  val io = IO(new Bundle{
    val enable    = Input (Bool())
    val init      = Input (Bool())
    val mode      = Input (UInt(2.W))
    val pattern   = Input (UInt(64.W))
    val dataout   = Output(UInt(dataWidth.W))
  })
  
  
  val COUNT_CLOG2 = log2Ceil(64/dataWidth)
  val NUM_BYTES   = (dataWidth/8)
  
  val count       = RegInit(0.U(COUNT_CLOG2.W))
  
  val count_in    = Mux(io.mode === MODE_PAT, count + 1.U, 0.U)
  
  count           := Mux(~io.enable || io.init, 0.U, count_in)
  
  val pattern_array = Wire(Vec((64/dataWidth), UInt(dataWidth.W)))
  
  for(i <- 0 until (64/dataWidth)){
    pattern_array(i) := io.pattern(((i+1)*dataWidth)-1, (dataWidth*i))
  }
  
  //
  val pat_55    = VecInit(Seq.fill(NUM_BYTES) {0x55.U(8.W)})
  val pat_cc    = VecInit(Seq.fill(NUM_BYTES) {0xcc.U(8.W)})
  val pat_f0    = VecInit(Seq.fill(NUM_BYTES) {0xf0.U(8.W)})
  
  io.dataout      :=  Mux(io.mode === MODE_55, pat_55.asUInt,
                        Mux(io.mode === MODE_CC, pat_cc.asUInt,
                          Mux(io.mode === MODE_F0, pat_f0.asUInt, pattern_array(count))
                        )
                      )
  
  
}




class WavD2DBistTx (
  dataWidth   : Int = 16,
  MODE_55     : UInt = 0.U,
  MODE_CC     : UInt = 1.U,
  MODE_F0     : UInt = 2.U,
  MODE_PAT    : UInt = 3.U,
  MODE_PRBS9  : UInt = 4.U,
  MODE_PRBS11 : UInt = 5.U,
  MODE_PRBS18 : UInt = 6.U,
  MODE_PRBS23 : UInt = 7.U  
)(implicit p: Parameters) extends Module with RequireAsyncReset{
  val io = IO(new Bundle{
    val en      = Input (Bool())
    val swreset = Input (Bool())
    val mode    = Input (UInt(4.W))
    val err_inj = Input (Bool())
    val pattern = Input (UInt(64.W))
    val seed    = Input (UInt(32.W))
    val dataout = Output(UInt(dataWidth.W))
  })
  
  val en_ff2      = WavDemetReset(io.en)
  val swreset_ff2 = WavDemetReset(io.swreset)
  val err_inj_ff2 = WavDemetReset(io.err_inj)
  
  
  val err_inj_ff3 = RegInit(false.B)
  err_inj_ff3     := err_inj_ff2
  
  val inject_error  = err_inj_ff2 & ~err_inj_ff3
  
  val prbs_enable = (en_ff2 && ~swreset_ff2 && 
                    ((io.mode === MODE_PRBS9)  || 
                     (io.mode === MODE_PRBS11) || 
                     (io.mode === MODE_PRBS18) || 
                     (io.mode === MODE_PRBS23)))
  
  val prbs = Module(new WavD2DBistPRBS(dataWidth))
  
  prbs.io.enable  := prbs_enable
  prbs.io.adv     := prbs_enable
  prbs.io.init    := ~en_ff2
  prbs.io.mode    := io.mode(1,0)
  prbs.io.seed    := io.seed
  
  
  val fixed_enable = (en_ff2 && ~swreset_ff2 && 
                      ((io.mode === MODE_55)  || 
                       (io.mode === MODE_CC) || 
                       (io.mode === MODE_F0) || 
                       (io.mode === MODE_PAT)))
  
  val fixed = Module(new WavD2DBistFixed(dataWidth))
  
  fixed.io.enable := fixed_enable
  fixed.io.init   := false.B
  fixed.io.mode   := io.mode(1,0)
  fixed.io.pattern:= io.pattern
  
  
  val dataout_pre = Mux(prbs_enable, prbs.io.dataout, fixed.io.dataout)
  val dataout_err = dataout_pre ^ 1.U
  io.dataout := Mux(inject_error, dataout_err, dataout_pre)
  
}



/**
  *
  *
  */
class WavD2DBistRx (
  dataWidth   : Int = 16,
  MODE_55     : UInt = 0.U,
  MODE_CC     : UInt = 1.U,
  MODE_F0     : UInt = 2.U,
  MODE_PAT    : UInt = 3.U,
  MODE_PRBS9  : UInt = 4.U,
  MODE_PRBS11 : UInt = 5.U,
  MODE_PRBS18 : UInt = 6.U,
  MODE_PRBS23 : UInt = 7.U 
)(implicit p: Parameters) extends Module with RequireAsyncReset {
  val io = IO(new Bundle{
    val en          = Input (Bool())
    val swreset     = Input (Bool())
    val mode        = Input (UInt(4.W))
    val pattern     = Input (UInt(64.W))
    val seed        = Input (UInt(32.W))
    val exp_count   = Input (UInt(4.W))
    val adv_on_err  = Input (Bool())
    
    val datain      = Input (UInt(dataWidth.W))
    
    val locked      = Output(Bool())
    val locked_seen = Output(Bool())
    val locked_index= Output(UInt(dataWidth.W))
    val error_found = Output(Bool())
    val errors      = Output(UInt(16.W))
  })
  
  
  //Think "localparam" in verilog
  object State extends ChiselEnum{
    val IDLE, LOCKING, LOCKED = Value
  }
  
  val state   = RegInit(State.IDLE)
  //val nstate  = Wire(state.cloneType)
  
  val en_ff2      = WavDemetReset(io.en)
  val swreset_ff2 = WavDemetReset(io.swreset)
  
  
  val datainprev  = RegInit(0.U(dataWidth.W))
  datainprev      := Mux(~en_ff2  || swreset_ff2, 0.U, io.datain)
  
  //Two cycles worth of data  
  val datacomp    = Cat(io.datain, datainprev)
  
  
  //---------------------------
  //Generators
  //---------------------------
  val adv_bist_data = Wire(Bool())
  adv_bist_data := false.B
  
  val prbs_enable = (en_ff2 && ~swreset_ff2 && 
                    ((io.mode === MODE_PRBS9)  || 
                     (io.mode === MODE_PRBS11) || 
                     (io.mode === MODE_PRBS18) || 
                     (io.mode === MODE_PRBS23)))
  val prbs = Module(new WavD2DBistPRBS(dataWidth))
  val prbs_adv    = WireDefault(false.B)
  prbs.io.enable  := prbs_enable
  prbs.io.init    := (state === State.IDLE)//~adv_bist_data //create a particular init signal
  prbs.io.adv     := adv_bist_data
  prbs.io.mode    := io.mode(1,0)
  prbs.io.seed    := io.seed
  
  val fixed_enable = (en_ff2 && ~swreset_ff2 && 
                      ((io.mode === MODE_55)  || 
                       (io.mode === MODE_CC) || 
                       (io.mode === MODE_F0) || 
                       (io.mode === MODE_PAT)))
  
  val fixed = Module(new WavD2DBistFixed(dataWidth))
  
  fixed.io.enable := fixed_enable
  fixed.io.init   := ~adv_bist_data
  fixed.io.mode   := io.mode(1,0)
  fixed.io.pattern:= io.pattern
  
  val exp_data = Wire(UInt(dataWidth.W))
  exp_data    := Mux(fixed_enable, fixed.io.dataout, 
                  Mux(prbs_enable, prbs.io.dataout, 0.U))

  val exp_data_count = RegInit(0.U(io.exp_count.getWidth.W))
  
  //-------------------------------
  //Comparing data
  //-------------------------------
  //We will "slide" a window to check for proper bit alignment, then use
  //that bit alignment to feed into checking
  val aligned_data_index_valid  = Wire(Vec(dataWidth, Bool()))              //1D array used to find bit lock location
  val aligned_data_array        = Wire(Vec(dataWidth, UInt(dataWidth.W)))   //2D array to hold the aligned word
  val aligned_data_index        = Wire(UInt(log2Ceil(dataWidth).W))
  
  val aligned_data_index_reg    = RegInit(0.U(log2Ceil(dataWidth).W))
  
  for (i <- 0 until dataWidth){
    aligned_data_index_valid(i) := en_ff2 & (exp_data === datacomp(i+dataWidth-1, i))
    aligned_data_array(i)       := datacomp(i+dataWidth-1, i)
  }
  
  //get the lowest match
  aligned_data_index := 0.U
  for(i <- dataWidth-1 to 0 by -1){
    when(aligned_data_index_valid(i)){
      aligned_data_index := i.U
    }
  }
  
  
  val locked      = RegInit(false.B)
  val locked_seen = RegInit(false.B)
  val error_found = RegInit(false.B)
  val errors      = RegInit(0.U(16.W))
  
  
  

  
  when(state === State.IDLE) {
    locked            := false.B
    locked_seen       := false.B
    error_found       := false.B
    errors            := 0.U
    exp_data_count    := 0.U
    when(en_ff2){
      state           := State.LOCKING
    }
  }.elsewhen (state === State.LOCKING) {
    //Look to see the first 
    when(aligned_data_index_valid.reduce(_||_)){
      when(exp_data_count === 0.U){
        //First time we have a match
        exp_data_count          := exp_data_count + 1.U
        adv_bist_data           := true.B
        aligned_data_index_reg  := aligned_data_index
      }.otherwise{
        //check to ensure the index hasn't changed
        when(aligned_data_index_reg === aligned_data_index){
          exp_data_count        := exp_data_count + 1.U
          adv_bist_data         := true.B
          when(exp_data_count === io.exp_count){
            state               := State.LOCKED
            locked              := true.B
            locked_seen         := true.B
          }            
        }.otherwise{
          //If change, revert back to 0 and init the pattern generators
          exp_data_count        := 0.U
          adv_bist_data         := true.B            
        }          
      }
    }
  }.elsewhen (state === State.LOCKED) {
    locked                      := true.B

    //when((aligned_data_index_valid.reduce(_||_)) && (aligned_data_index_reg === aligned_data_index)) {
    when(aligned_data_array(aligned_data_index_reg) === exp_data) {
      adv_bist_data             := true.B  
    } .otherwise {
      //not good, we are out of alignment.
      //We may want to keep the bist machines advancing. If we keep them advancing, don't
      //go back to LOCKING, just increment errors
      adv_bist_data             := io.adv_on_err
      error_found               := true.B
      errors                    := Mux(errors === 0xffff.U, 0xffff.U, errors + 1.U)

      when(~io.adv_on_err){
        exp_data_count          := 0.U
        locked                  := false.B
        state                   := State.LOCKING
      }
    }
  } .otherwise {
    state                       := State.IDLE
  }
  
  //final check to disable
  when(~en_ff2 || swreset_ff2){
    state   := State.IDLE
  }
  
  
  
  io.locked         := locked
  io.locked_seen    := locked_seen
  io.locked_index   := aligned_data_index_valid.asUInt
  io.error_found    := error_found
  io.errors         := errors
  
  
  
  
  
}


object WavD2DBistFixedGen extends App {  
  
  //Create an empty parameter if we have nothing to use
  implicit val p: Parameters = Parameters.empty
  
  val axiverilog = (new ChiselStage).emitVerilog(
    //LazyModule(new MyTest()(p)).module,
    new WavD2DBistRx(8)(p),
    
    //args
    Array("--target-dir", "output/")
  )
  
  val bisttx = (new ChiselStage).emitVerilog(
    //LazyModule(new MyTest()(p)).module,
    new WavD2DBistTx(8)(p),
    
    //args
    Array("--target-dir", "output/")
  )
  
  //GenElabArts.gen("WH440TopXbarWithAXI4Xbar")
}





/*
 *  Generates a PRBS pattern
 *  
 *  The patterns HAVE NOT been optimized, so there is room to optimize
 *
 */
class WavD2DBistPRBS (
  dataWidth : Int   = 16,
  PRBS9     : UInt  = 0.U,
  PRBS11    : UInt  = 1.U,
  PRBS18    : UInt  = 2.U,
  PRBS23    : UInt  = 3.U
)(implicit p: Parameters) extends Module with RequireAsyncReset{
  val io = IO(new Bundle{
    val enable  = Input (Bool())
    val init    = Input (Bool())
    val adv     = Input (Bool())
    val mode    = Input (UInt(2.W))
    val seed    = Input (UInt(32.W))
    val dataout = Output(UInt(dataWidth.W))
  })
  
  val lfsr  = RegInit("hffff_ffff".U(32.W))
  
  val init_prev     = RegNext(io.init, false.B)
  val prop_seed     = RegNext((~io.init && init_prev), false.B)

  
  when(io.enable && (io.adv || prop_seed)) {
    switch(io.mode) {
      is(PRBS9){
        if(dataWidth == 16) {
        lfsr  := Cat(Seq(lfsr(15),
                         lfsr(14),
                         lfsr(13),
                         lfsr(12),
                         lfsr(11),
                         lfsr(10),
                         lfsr(9),
                         lfsr(8),
                         lfsr(7),
                         lfsr(6),
                         lfsr(5),
                         lfsr(4),
                         lfsr(3),
                         lfsr(2),
                         lfsr(1),
                         lfsr(0),
                         lfsr(8)^lfsr(4),
                         lfsr(7)^lfsr(3),
                         lfsr(6)^lfsr(2),
                         lfsr(5)^lfsr(1),
                         lfsr(4)^lfsr(0),
                         lfsr(3)^lfsr(8)^lfsr(4),
                         lfsr(2)^lfsr(7)^lfsr(3),
                         lfsr(1)^lfsr(6)^lfsr(2),
                         lfsr(0)^lfsr(5)^lfsr(1),
                         lfsr(8)^lfsr(4)^lfsr(4)^lfsr(0),
                         lfsr(7)^lfsr(3)^lfsr(3)^lfsr(8)^lfsr(4),
                         lfsr(6)^lfsr(2)^lfsr(2)^lfsr(7)^lfsr(3),
                         lfsr(5)^lfsr(1)^lfsr(1)^lfsr(6)^lfsr(2),
                         lfsr(4)^lfsr(0)^lfsr(0)^lfsr(5)^lfsr(1),
                         lfsr(3)^lfsr(8)^lfsr(4)^lfsr(8)^lfsr(4)^lfsr(4)^lfsr(0),
                         lfsr(2)^lfsr(7)^lfsr(3)^lfsr(7)^lfsr(3)^lfsr(3)^lfsr(8)^lfsr(4)))
        }
      }
      
      is(PRBS23) {
        if(dataWidth == 16) {
          lfsr := Cat(Seq(lfsr(15),
                          lfsr(14),
                          lfsr(13),
                          lfsr(12),
                          lfsr(11),
                          lfsr(10),
                          lfsr(9),
                          lfsr(8),
                          lfsr(7),
                          lfsr(6),
                          lfsr(5),
                          lfsr(4),
                          lfsr(3),
                          lfsr(2),
                          lfsr(1),
                          lfsr(0),
                          lfsr(23) ^ lfsr(18),
                          lfsr(22) ^ lfsr(17),
                          lfsr(21) ^ lfsr(16),
                          lfsr(20) ^ lfsr(15),
                          lfsr(19) ^ lfsr(14),
                          lfsr(18) ^ lfsr(13),
                          lfsr(17) ^ lfsr(12),
                          lfsr(16) ^ lfsr(11),
                          lfsr(15) ^ lfsr(10),
                          lfsr(14) ^ lfsr(9),
                          lfsr(13) ^ lfsr(8),
                          lfsr(12) ^ lfsr(7),
                          lfsr(11) ^ lfsr(6),
                          lfsr(10) ^ lfsr(5),
                          lfsr(9) ^ lfsr(4),
                          lfsr(8) ^ lfsr(3)))

        }
      }
    }
  } 
  
  when(io.init){
    lfsr := io.seed
  }
  
  
  io.dataout := lfsr
  
}


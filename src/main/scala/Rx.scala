package wav.d2d

import wav.common._

import chisel3._
import chisel3.util._
import chisel3.experimental.{ChiselEnum, Analog}
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


class WavD2DRxCoreBundle(val dataWidth : Int = 16) extends Bundle{
  val rx_en               = Input (Bool())
  val rx_reset            = Input (Bool())
  val rx_rd               = Output(UInt(dataWidth.W))
  val rx_locked           = Output(Bool())
}

class WavD2DRxCoreCDRBundle extends Bundle{
  val pden                = Input (Bool())
  val pdrst               = Input (Bool())
  val pdup                = Output(Bool())
  val pddn                = Output(Bool())
}

class WavD2DRxCoreBistBundle extends Bundle{  
  val rx_bist_en          = Input (Bool())
  val rx_bist_mode        = Input (UInt(4.W))
  val rx_bist_locked      = Output(Bool())
  val rx_bist_errorfound  = Output(Bool())
}

class WavD2DRxCoreCalBundle extends Bundle{  
  val rx_sampler_cal_en   = Input (Bool())
  val rx_sampler_cal_done = Output(Bool())
}

class WavD2DRxAnalogBundle(val dataWidth : Int = 16) extends Bundle{
  val cal_en         = Output(Bool())
  val clk_div16      = Input (Bool())     //Bool Since from analog
  val i_en           = Output(Bool())
  val idata          = Input (UInt(dataWidth.W))
  val odt_ctrl       = Output(UInt(4.W))
  val odt_dc_mode    = Output(Bool())
  val osc_dir_i_dp   = Output(Bool())
  val osc_dir_ib_dp  = Output(Bool())
  val osc_i_dp       = Output(UInt(4.W))
  val osc_ib_dp      = Output(UInt(4.W))
  
  val serdes_byp_in  = Input (Bool())
  val serdes_byp_sel = Output(Bool())
  val serlb_en       = Output(Bool())
}

class WavD2DRxQPathAnalogBundle(val dataWidth : Int = 16) extends Bundle{
  val q_en           = Output(Bool())
  val qdata          = Input (UInt(dataWidth.W))
  val osc_dir_q_dp   = Output(Bool())
  val osc_dir_qb_dp  = Output(Bool())
  val osc_q_dp       = Output(UInt(4.W))
  val osc_qb_dp      = Output(UInt(4.W))
}

/**
  *   Analog BlackBox wrapper
  */
class wav_d2d_rx_ana extends BlackBox{
  val io = IO(new Bundle{
    
    //Goes to digital
    val rx  = Flipped(new WavD2DRxAnalogBundle(16))
    
    val rx_clk_div16_in   = Input (Bool())
    val rx_clk_div8_in    = Input (Bool())
    val rx_iclk           = Input (Bool())
    val rx_iclkb          = Input (Bool())
    val rx_iref           = Input (Bool())
    //val rx_serlb_in       = Input (Bool())
    val rx_serlb_in       = Analog(1.W)   //Analog for fanout
    
    val pad_rx            = Input (Bool())
    
    val vdda              = Input (Bool())
    val vdda_ck           = Input (Bool())
    val vss               = Input (Bool())
  })
}

//Can we keep the same as above and just have a parameter?
class wav_d2d_rx_ana_IQ extends BlackBox{
  val io = IO(new Bundle{
    
    //Goes to digital
    val rx  = Flipped(new WavD2DRxAnalogBundle(16))
    val rxq = Flipped(new WavD2DRxQPathAnalogBundle(16))
    
    val rx_clk_div16_in   = Input (Bool())
    val rx_clk_div8_in    = Input (Bool())
    
    val rx_iclk           = Input (Bool())
    val rx_iclkb          = Input (Bool())
    val rxq_qclk          = Input (Bool())
    val rxq_qclkb         = Input (Bool())
    
    val rx_iref           = Input (Bool())
    //val rxq_qref          = Analog(1.W)
    //val rx_serlb_in       = Input (Bool())
    val rx_serlb_in       = Analog(1.W)   //Analog for fanout
    
    val pad_rx            = Input (Bool())
    
    val vdda              = Input (Bool())
    val vdda_ck           = Input (Bool())
    val vss               = Input (Bool())
  })
}


class WavD2DRx(val dataWidth : Int = 16, val baseAddr: BigInt = 0x0, val withCDR: Boolean = false)(implicit p: Parameters) extends LazyModule{
  
  val device = new SimpleDevice("wavd2drx", Seq("wavious,d2drx"))
  
  val node = WavAPBRegisterNode(
    address = AddressSet.misaligned(baseAddr, 0x100),
    device  = device,
    //concurrency = 1, //make depending on apn (apb requires 1)
    beatBytes = 4)

  
  override lazy val module = new LazyModuleImp(this) with RequireAsyncReset{
    
    val io = IO(new Bundle{
      val scan      = new WavScanBundle
      val iddq      = Input(Bool())
      val highz     = Input(Bool())
      val bsr       = new WavBSRBundle
      val core      = new WavD2DRxCoreBundle
      val core_bist = new WavD2DRxCoreBistBundle
      val core_cdr  = new WavD2DRxCoreCDRBundle
      val core_cal  = new WavD2DRxCoreCalBundle
      val ana       = new WavD2DRxAnalogBundle
      val ana_q     = if(withCDR) Some(new WavD2DRxQPathAnalogBundle) else None
    })
    
    dontTouch(io.bsr)
    dontTouch(io.scan)
    
    val rx_reset            = Wire(Bool())
    val rx_en               = Wire(Bool())
    
    val rx_pd_en            = Wire(Bool())
    val rx_pd_rst           = Wire(Bool())
    val any_sampler_enabled = Wire(Bool())
    
    // Main Rx Clock Logic
    val rx_clk_scan     = WavClockMux (io.scan.mode,  io.scan.clk,    io.ana.clk_div16)
    val rx_clk_reset    = WavResetSync(rx_clk_scan,   rx_reset,       io.scan.asyncrst_ctrl)
    
    val register_reset  = WavResetSync(rx_clk_scan,   reset.asBool,   io.scan.asyncrst_ctrl)    //Register reset for codes
    
    // Gated RX Clock Logic
    // Enabled when PD or Sampler is enabled
    val rx_clk_en       = rx_pd_en | any_sampler_enabled
    val rx_clk_gated    = WavClockGate(clk_in=rx_clk_scan, reset_in=rx_clk_reset, enable=rx_clk_en, test_en=io.scan.mode)
    
    val rx_data_reg     = withClockAndReset(rx_clk_scan.asClock, rx_clk_reset.asAsyncReset) {RegNext(io.ana.idata, 0.U)}
    val rx_qdata_reg    = withClockAndReset(rx_clk_scan.asClock, rx_clk_reset.asAsyncReset) {RegNext(io.ana_q.get.qdata, 0.U)}
    
    //---------------------------------
    // BIST
    //---------------------------------
    val bist_pattern_lo = Wire(UInt(32.W))
    val bist_pattern_hi = Wire(UInt(32.W))
    val bist_en_reg     = Wire(Bool())
    val bist_mode_reg   = Wire(UInt(4.W))
    val bist_sel        = Wire(Bool())
    val bist            = withClockAndReset(rx_clk_scan.asClock, rx_clk_reset.asAsyncReset) {Module(new WavD2DBistRx(dataWidth))}
    bist.io.en          := Mux(bist_sel, bist_en_reg,   io.core_bist.rx_bist_en)
    bist.io.mode        := Mux(bist_sel, bist_mode_reg, io.core_bist.rx_bist_mode)
    bist.io.pattern     := Cat(bist_pattern_hi, bist_pattern_lo)
    bist.io.datain      := rx_data_reg//io.ana.idata
    
    io.core_bist.rx_bist_locked        := bist.io.locked
    io.core_bist.rx_bist_errorfound    := bist.io.error_found
    
    //---------------------------------
    // CDR / Phase Detector
    //---------------------------------
    val rx_pd_rst_scan  = WavResetSync(rx_clk_gated, rx_pd_rst, io.scan.asyncrst_ctrl)
    val rx_pd           = Module(new wav_phase_detector(width=dataWidth, ileadq=0))
    rx_pd.io.clk        := rx_clk_gated
    rx_pd.io.reset      := rx_pd_rst_scan
    rx_pd.io.enable     := rx_pd_en
    rx_pd.io.idata      := rx_data_reg//io.ana.idata
    rx_pd.io.qdata      := rx_qdata_reg//io.ana_q.get.qdata
    io.core_cdr.pdup    := rx_pd.io.up
    io.core_cdr.pddn    := rx_pd.io.dn
    
    
    //---------------------------------
    // Samplers    
    //---------------------------------
    val rx_sampler_cal_en           = Wire(Bool())
    val sampler_settle_time         = Wire(UInt(8.W))
    val all_samplers_done           = Wire(Bool())
    
    
    val i_sampler = withClockAndReset(rx_clk_gated.asClock, rx_clk_reset.asAsyncReset) {Module(new WavD2DRxSamplerCal(isEven=true, dataWidth=dataWidth))}
    i_sampler.io.code_reset         := register_reset
    i_sampler.io.swi_settle_time    := sampler_settle_time
    i_sampler.io.data               := rx_data_reg//io.ana.idata
    
    
    val ib_sampler = withClockAndReset(rx_clk_gated.asClock, rx_clk_reset.asAsyncReset) {Module(new WavD2DRxSamplerCal(isEven=false, dataWidth=dataWidth))}
    ib_sampler.io.code_reset        := register_reset
    ib_sampler.io.swi_settle_time   := sampler_settle_time
    ib_sampler.io.data              := rx_data_reg//io.ana.idata
    
    
    
    val q_en             = Wire(Bool())
    var q_sampler_swreg  = WavSWReg(0x18, "QSamplercal",  "Q sampler cal signals",  WavRSVD(32))
    var qb_sampler_swreg = WavSWReg(0x1c, "QBSamplercal", "QB sampler cal signals", WavRSVD(32))
    if(withCDR) {
      
      val q_sampler = withClockAndReset(rx_clk_gated.asClock, rx_clk_reset.asAsyncReset) {Module(new WavD2DRxSamplerCal(isEven=true, dataWidth=dataWidth))}
      q_sampler.io.code_reset         := register_reset
      q_sampler.io.swi_settle_time    := sampler_settle_time
      q_sampler.io.data               := io.ana_q.get.qdata

      val qb_sampler = withClockAndReset(rx_clk_gated.asClock, rx_clk_reset.asAsyncReset) {Module(new WavD2DRxSamplerCal(isEven=false, dataWidth=dataWidth))}
      qb_sampler.io.code_reset        := register_reset
      qb_sampler.io.swi_settle_time   := sampler_settle_time
      qb_sampler.io.data              := io.ana_q.get.qdata
      
      
      q_sampler_swreg = WavSWReg(0x18, "QSamplercal", "Q sampler cal signals",
          WavRWMux    (in=rx_sampler_cal_en,                muxed=q_sampler.io.enable,   reg_reset=false.B, mux_reset=false.B, "q_sampler_cal_en", "q_sampler cal enable"),
          WavRWMux    (in=q_sampler.io.result.osc,          muxed=io.ana_q.get.osc_q_dp,     reg_reset=false.B, mux_reset=false.B, "osc_q_dp",        "q_sampler cal value"),
          WavRWMux    (in=q_sampler.io.result.osc_dir,      muxed=io.ana_q.get.osc_dir_q_dp, reg_reset=false.B, mux_reset=false.B, "osc_dir_q_dp",    "q_sampler cal direction value"),
          WavRW       (q_sampler.io.swi_polarity,           true.B,   "q_sampler_pol", "Polarity for sampler signerr"),
          WavROBundle (q_sampler.io.result,                           "q_sampler_results", "Results for Q Sampler Calibration"))
    
      qb_sampler_swreg = WavSWReg(0x1c, "QBSamplercal", "QB sampler cal signals",
          WavRWMux    (in=rx_sampler_cal_en,                muxed=qb_sampler.io.enable,   reg_reset=false.B, mux_reset=false.B, "qb_sampler_cal_en", "qb_sampler cal enable"),
          WavRWMux    (in=qb_sampler.io.result.osc,         muxed=io.ana_q.get.osc_qb_dp,     reg_reset=false.B, mux_reset=false.B, "osc_qb_dp",         "qb_sampler cal value"),
          WavRWMux    (in=qb_sampler.io.result.osc_dir,     muxed=io.ana_q.get.osc_dir_qb_dp, reg_reset=false.B, mux_reset=false.B, "osc_dir_qb_dp",     "qb_sampler cal direction value"),
          WavRW       (qb_sampler.io.swi_polarity,          true.B,   "qb_sampler_pol", "Polarity for sampler signerr"),
          WavROBundle (qb_sampler.io.result,                          "qb_sampler_results", "Results for QB Sampler Calibration"))
      
      
      
      all_samplers_done   := (i_sampler.io.result.done && ib_sampler.io.result.done &&
                              q_sampler.io.result.done && qb_sampler.io.result.done)
      any_sampler_enabled := (i_sampler.io.enable || ib_sampler.io.enable ||
                              q_sampler.io.enable || qb_sampler.io.enable)    
      
      q_en                := q_sampler.io.enable || qb_sampler.io.enable || rx_pd_en /*TODO: ADD OVERRIDE!!!!!*/
      
    } else {
      all_samplers_done   := (i_sampler.io.result.done && ib_sampler.io.result.done)
      any_sampler_enabled := (i_sampler.io.enable || ib_sampler.io.enable)
    }
    
    
    
    // Aligner
    val aligner           = withClockAndReset(rx_clk_scan.asClock, rx_clk_reset.asAsyncReset) {Module(new WavD2DRxAligner(dataWidth))}
    aligner.io.datain     := rx_data_reg//io.ana.idata
    io.core.rx_rd         := aligner.io.dataout
    io.core.rx_locked     := aligner.io.locked
  
    //BSRs
    val rx_byp_in_bsr = WavBSR(1, io.bsr)
    (rx_byp_in_bsr -> io.bsr.tdo)
  
    //Registers
    val regs = node.regmap(
      //-----------------------
      // General Control
      //-----------------------
      WavSWReg(0x0, "CoreOverride", "Overrides for core signals",
        WavRWMux(in=io.core.rx_reset,               muxed=rx_reset,                         reg_reset=false.B, mux_reset=false.B, "rx_reset",             "Main RX Reset"),
        WavRWMux(in=io.core.rx_en,                  muxed=rx_en,                            reg_reset=false.B, mux_reset=false.B, "rx_en",                "RX Enable",
          corescan=Some(io.scan.mode, false.B), iddq=Some(io.iddq, false.B)),
        WavRWMux(in=io.core_cal.rx_sampler_cal_en,  muxed=rx_sampler_cal_en,                reg_reset=false.B, mux_reset=false.B, "rx_sampler_cal_en",    "RX Sampler cal enable"),
        WavRWMux(in=all_samplers_done,              muxed=io.core_cal.rx_sampler_cal_done,  reg_reset=false.B, mux_reset=false.B, "rx_sampler_cal_done",  "Indication of all samplers being completed going out to core side"),
        WavRO   (io.core_cal.rx_sampler_cal_done,                    "rx_sampler_cal_done_status",        "Status of all sampler cals")),
      
      //-----------------------
      // Analog Controls
      //-----------------------
      //Block Serial Loopback during BSCAN as this could short to the TX
      WavSWReg(0x04, "AnalogControls", "",
        WavRWMux(in=(rx_en | rx_pd_en),   muxed=io.ana.i_en,      reg_reset=false.B, mux_reset=false.B, "i_en",             "Enables I path logic",
          corescan=Some(io.scan.mode, false.B), iddq=Some(io.iddq, false.B)),
        WavRWMux(in=q_en,                 muxed=io.ana_q.get.q_en,reg_reset=false.B, mux_reset=false.B, "q_en",             "Enables Q path logic",
          corescan=Some(io.scan.mode, false.B), iddq=Some(io.iddq, false.B)),
        WavRWMux(in=any_sampler_enabled,  muxed=io.ana.cal_en,    reg_reset=false.B, mux_reset=false.B, "cal_en",           "Cal enable to analog to be asserted when Sampler calibration is performed"),
        WavRW   (io.ana.odt_dc_mode,      false.B,        "odt_dc_mode",          "Enables termination"),
        WavRW   (io.ana.odt_ctrl,         8.U,            "odt_ctrl",             "Termination value"),
        WavRW   (io.ana.serlb_en,         false.B,        "serlp_en",             "Enables serial loopback",
          bscan=Some(io.bsr.bsr_mode, false.B)),
        WavRW   (io.ana.serdes_byp_sel,   false.B,        "serdes_byp_sel",       "Enables the serdes bypass path",
          bscan=Some(io.bsr.bsr_mode, true.B)),
        WavRO   (io.ana.serdes_byp_in,                    "serdes_byp_in",        "Serdes bypass status",
          bflop=Some(rx_byp_in_bsr))),
      
      
      //-----------------------
      // Aligner
      //-----------------------
      WavSWReg(0x08, "AlignerControls", "",
        WavRWMux(in=rx_en,                muxed=aligner.io.enable,       reg_reset=false.B, mux_reset=false.B, "aligner_enable",             "Enables the Aligner"),
        WavRW   (aligner.io.datapat,      "hdead".U,      "aligner_pattern",      "Pattern used for data alignment"),
        WavRO   (aligner.io.locked,                       "aligner_locked",       "Aligner locked status")),
      
      //-----------------------
      // CDR/PD
      //-----------------------
      WavSWReg(0x0c, "CDRControls", "",
        WavRWMux(in=io.core_cdr.pden,              muxed=rx_pd_en,           reg_reset=false.B, mux_reset=false.B, "pd_en",             "Enables the Phase Detector"),
        WavRWMux(in=io.core_cdr.pdrst,             muxed=rx_pd_rst,          reg_reset=false.B, mux_reset=false.B, "pd_rst",            "Phase Detector reset"),
        WavRO   (io.core_cdr.pdup,                 "pdup",       "Phase Detector Up Status"),
        WavRO   (io.core_cdr.pddn,                 "pddn",       "Phase Detector Down Status")),
        
      //-----------------------
      // Sampler
      //-----------------------
      WavSWReg(0x10, "ISamplercal", "I sampler cal signals",
        WavRWMux    (in=rx_sampler_cal_en,                muxed=i_sampler.io.enable,    reg_reset=false.B, mux_reset=false.B, "i_sampler_cal_en", "i_sampler cal enable"),
        WavRWMux    (in=i_sampler.io.result.osc,          muxed=io.ana.osc_i_dp,        reg_reset=false.B, mux_reset=false.B, "osc_i_dp",         "i_sampler cal value"),
        WavRWMux    (in=i_sampler.io.result.osc_dir,      muxed=io.ana.osc_dir_i_dp,    reg_reset=false.B, mux_reset=false.B, "osc_dir_i_dp",     "i_sampler cal direction value"),
        WavRW       (i_sampler.io.swi_polarity,           true.B,   "i_sampler_pol", "Polarity for sampler signerr"),
        WavROBundle (i_sampler.io.result,                           "i_sampler_results", "Results for I Sampler Calibration"),
        WavRW       (sampler_settle_time,                 12.U,     "sampler_settle_time", "Settle time for sampler calibrations. (shared for all I/Q samplers)")),
      WavSWReg(0x14, "IBSamplercal", "IB sampler cal signals",
        WavRWMux    (in=rx_sampler_cal_en,                muxed=ib_sampler.io.enable,   reg_reset=false.B, mux_reset=false.B, "ib_sampler_cal_en", "ib_sampler cal enable"),
        WavRWMux    (in=ib_sampler.io.result.osc,         muxed=io.ana.osc_ib_dp,       reg_reset=false.B, mux_reset=false.B, "osc_ib_dp",         "ib_sampler cal value"),
        WavRWMux    (in=ib_sampler.io.result.osc_dir,     muxed=io.ana.osc_dir_ib_dp,   reg_reset=false.B, mux_reset=false.B, "osc_dir_ib_dp",     "ib_sampler cal direction value"),
        WavRW       (ib_sampler.io.swi_polarity,          true.B,   "ib_sampler_pol", "Polarity for sampler signerr"),
        WavROBundle (ib_sampler.io.result,                          "ib_sampler_results", "Results for IB Sampler Calibration")),
        
      q_sampler_swreg,
      qb_sampler_swreg,
      
      
      //-----------------------
      // BIST
      //-----------------------
      WavSWReg(0x40, "BistCtrl", "",
        WavRW(bist_en_reg,          false.B,        "bist_en",            "Enables the Bist logic"),
        WavRW(bist.io.swreset,      false.B,        "bist_reset",         "Resets the BIST logic. This is a synchronous reset"),
        WavRW(bist_mode_reg,        0.U,            "bist_mode",          "Determines which BIST mode is operational"),
        WavRW(bist.io.exp_count,    4.U,            "bist_exp_count",     "Number of cycles to see expected BIST data before declaring locked"),
        WavRW(bist.io.adv_on_err,   true.B,         "bist_adv_on_error",  "1 - When an error is seen, continue the BIST machine. 0 - Restart the BIST on any error"),
        WavRW(bist_sel,             false.B,        "bist_sel",           "1 - SW controlled. 0 - Hardware controlled")),
      
      WavSWReg(0x44, "BistSeed", "",
        WavRW(bist.io.seed,         "hffffffff".U,  "bist_seed",          "Seed for BIST PRBS Generation")),
        
      WavSWReg(0x48, "BistPatternLo", "",
        WavRW(bist_pattern_lo,      "h01234567".U,  "bist_pattern_lo",    "BIST Pattern when set to pattern mode")),
        
      WavSWReg(0x4c, "BistPatternHi", "",
        WavRW(bist_pattern_hi,      "hdeadbeef".U,  "bist_pattern_hi",    "BIST Pattern when set to pattern mode")),
      
      WavSWReg(0x50, "BistStatus", "",
        WavRO(bist.io.locked,                       "bist_locked",        "Indicates BIST is currently in the LOCKED state"),
        WavRO(bist.io.locked_seen,                  "bist_locked_seen",   "Indicates BIST has been in the LOCKED state at least once"),
        WavRO(bist.io.error_found,                  "bist_error_found",   "Indicates BIST has seen at least one error"),
        WavRSVD(13),
        WavRO(bist.io.errors,                       "bist_errors",        "Numbers of BIST Errors seen")),
      
      WavSWReg(0x54, "BistLockedIndex", "",
        WavRO(bist.io.locked_index,                 "bist_locked_index",  "Bit location where the BIST machine has locked"))
      
    )
    
    
  }
  
}




/**
  *   Sampler calibration
  *
  */
class WavD2DRxSamplerCalBundle extends Bundle{
  val signerr             = Output(Bool())
  val osc_dir             = Output(Bool())
  val osc                 = Output(UInt(4.W))
  val done                = Output(Bool())
}

object WavD2DRxSamplerState extends ChiselEnum{
  val IDLE, EN_WAIT, SET_DIR, SETTLE, INCR, DONE = Value
}

class WavD2DRxSamplerCal(val isEven : Boolean, val dataWidth : Int = 16)(implicit p: Parameters) extends Module{
  val io  = IO(new Bundle{
    val code_reset        = Input (Bool())
    val enable            = Input (Bool())
    val swi_settle_time   = Input (UInt(8.W))
    val swi_polarity      = Input (Bool())
    val data              = Input (UInt(dataWidth.W))
    
    val result            = new WavD2DRxSamplerCalBundle
  })
  
  
  val nstate          = WireInit(WavD2DRxSamplerState.IDLE)
  val state           = RegNext(next=nstate, init=WavD2DRxSamplerState.IDLE)
  
  val en_ff2          = WavDemetReset(io.enable)
  
  
  val osc_in          = Wire(UInt(4.W))
  val osc             = withReset(io.code_reset.asAsyncReset){RegNext(next=osc_in, init=0.U)}
  val osc_dir_in      = Wire(UInt(4.W))
  val osc_dir         = withReset(io.code_reset.asAsyncReset){RegNext(next=osc_dir_in, init=0.U)}
  
  val count_in        = Wire(UInt(8.W))
  val count           = RegNext(next=count_in, init=0.U)
  
  val done_in         = Wire(Bool())
  val done            = RegNext(next=done_in, init=false.B)
  
  //Why Vec? -> https://github.com/chipsalliance/chisel3/wiki/Cookbook#how-do-i-do-subword-assignment-assign-to-some-bits-in-a-uint
  //val data_check      = Wire(UInt((dataWidth/2).W))
  val data_check      = Wire(Vec(dataWidth/2, Bool()))
  if(isEven){
    for(i <- 0 until (dataWidth/2)){
      data_check(i) := io.data(i*2)
    }
  } else {
    for(i <- 0 until (dataWidth/2)){
      data_check(i) := io.data((i*2)+1)
    }
  }
  
  
  val data_all_zeros  = ~(data_check.orR)
  val data_all_ones   = data_check.andR
  
  val signerr_prev    = RegInit(false.B)
  val signerr         = Mux(data_all_ones, io.swi_polarity, Mux(data_all_zeros, ~io.swi_polarity, ~signerr_prev))
  //signerr_prev updates on the increment and set_dir states so we can check it on the next check
  when((state === WavD2DRxSamplerState.INCR) || (nstate === WavD2DRxSamplerState.SET_DIR)){
    signerr_prev      := signerr
  }
  
  val signerr_flip    = signerr ^ signerr_prev
  
  
  
  
  nstate              := state
  osc_in              := osc
  osc_dir_in          := osc_dir
  count_in            := 0.U
  done_in             := false.B
  
  
  when(state === WavD2DRxSamplerState.IDLE){
    //-----------------------------------------------
    when(en_ff2){
      count_in        := io.swi_settle_time
      nstate          := WavD2DRxSamplerState.EN_WAIT
    }
    
  }.elsewhen(state === WavD2DRxSamplerState.EN_WAIT){
    //-----------------------------------------------
    when(count === 0.U) {
      count_in        := io.swi_settle_time
      nstate          := WavD2DRxSamplerState.SET_DIR
    }.otherwise{
      count_in        := count - 1.U
    }
    
  }.elsewhen(state === WavD2DRxSamplerState.SET_DIR){
    //-----------------------------------------------
    //Noticed an issue where if the target code is 0, then metastable signerror
    //can cause you to blow to the end if dir is sampled incorrectly and thus
    //you start heading in the wrong direction. Stay in the set dir for an additional 
    //settle time. 
    
    osc_dir_in        := signerr
    
    when(signerr_flip){   //case where the code is meta stable
      done_in         := true.B
      nstate          := WavD2DRxSamplerState.DONE
    }.elsewhen(count === 0.U){
      count_in        := io.swi_settle_time
      nstate          := WavD2DRxSamplerState.SETTLE
    }.otherwise{
      count_in        := count - 1.U
    }
    
  }.elsewhen(state === WavD2DRxSamplerState.SETTLE){
    //-----------------------------------------------
    when(count === 0.U){
      nstate          := WavD2DRxSamplerState.INCR
    }.otherwise{
      count_in        := count - 1.U
    }
    
  }.elsewhen(state === WavD2DRxSamplerState.INCR){
    //-----------------------------------------------
    osc_in            := Mux(~signerr_flip, osc + 1.U, osc)
    
    when(signerr_flip || (osc_in === "hf".U)){
      done_in         := true.B
      nstate          := WavD2DRxSamplerState.DONE
    }.otherwise{
      count_in        := io.swi_settle_time
      nstate          := WavD2DRxSamplerState.SETTLE
    }
  
  }.elsewhen(state === WavD2DRxSamplerState.DONE){
    //-----------------------------------------------
    done_in           := true.B
    when(~en_ff2){
      done_in         := false.B
      nstate          := WavD2DRxSamplerState.IDLE
    }
    
  }.otherwise{
    //-----------------------------------------------
    //Default
    nstate            := WavD2DRxSamplerState.IDLE
  }
  
  
  io.result.signerr   := signerr
  io.result.osc_dir   := osc_dir
  io.result.osc       := osc
  io.result.done      := done
  
}






class WavD2DRxAligner(val dataWidth : Int = 16, val pipelineStage : Boolean = true)(implicit p: Parameters) extends Module{
  val io = IO(new Bundle{
    val enable          = Input (Bool())
    val datapat         = Input (UInt(dataWidth.W))
    val datain          = Input (UInt(dataWidth.W))
    val dataout         = Output(UInt(dataWidth.W))
    val locked          = Output(Bool())
  })
  
  
  val en_ff2 = WavDemetReset(io.enable)
  
  val locked                    = RegInit(false.B)
  
  val datainprev                = RegInit(0.U(dataWidth.W))
  datainprev                    := Mux(~en_ff2, 0.U, io.datain)
  
  val datacomp                  = Cat(io.datain, datainprev) 
  
  val aligned_data_index_valid  = Wire(Vec(dataWidth, Bool()))              //1D array used to find bit lock location
  val aligned_data_array        = Wire(Vec(dataWidth, UInt(dataWidth.W)))   //2D array to hold the aligned word
  val aligned_data_index        = Wire(UInt(log2Ceil(dataWidth).W))
  
  val aligned_data_index_reg    = RegInit(0.U(log2Ceil(dataWidth).W))
  
  for (i <- 0 until dataWidth){
    aligned_data_index_valid(i) := en_ff2 & (io.datapat === datacomp(i+dataWidth-1, i))
    aligned_data_array(i)       := datacomp(i+dataWidth-1, i)
  }
  
  //get the lowest match
  aligned_data_index := 0.U
  for(i <- dataWidth-1 to 0 by -1){
    when(aligned_data_index_valid(i)){
      aligned_data_index := i.U
    }
  }
  
  val valid_index               = Wire(Bool())
  valid_index                   := aligned_data_index_valid.orR
  
  locked                        := Mux(~en_ff2, false.B, Mux(locked, locked, valid_index))
  
  
  aligned_data_index_reg        := Mux(locked, aligned_data_index_reg, Mux(valid_index, aligned_data_index, aligned_data_index_reg))
  
  if(pipelineStage){
    val dataout_reg             = RegNext(aligned_data_array(aligned_data_index_reg), 0.U)
    io.dataout                  := dataout_reg
    
    val locked_reg_in           = Mux(~en_ff2, false.B, locked)
    val locked_reg              = RegNext(locked_reg_in, false.B)
    io.locked                   := locked_reg    
  } else {
    io.dataout                  := aligned_data_array(aligned_data_index_reg)
    io.locked                   := locked
  }
}




/**********************************************************************
*   Generation Wrappers
**********************************************************************/
// class WavD2DRxWrapper()(implicit p: Parameters) extends LazyModule{
//   
//   val xbar = LazyModule(new TLXbar)
//   val ApbPort = APBMasterNode(
//     portParams = Seq(APBMasterPortParameters(masters = Seq(APBMasterParameters(name = "ApbPort"))))
//   )
//   val apbport = InModuleBody {ApbPort.makeIOs()}
//   xbar.node := APBToTL() := ApbPort
//   
//   val rx = LazyModule(new WavD2DRx(baseAddr=0)(p))
//   
//   rx.node := xbar.node
//   
//   lazy val module = new LazyModuleImp(this) with RequireAsyncReset{
//     val io = IO(rx.module.io.cloneType)
//     
//     io <> rx.module.io
//   }
//   
// }
// 
// object WavD2DRxWrapperGen extends App {  
//   //Create an empty parameter if we have nothing to use
//   //implicit val p: Parameters = Parameters.empty
//   implicit val p: Parameters = new BaseXbarConfig
//   
//   val axiverilog = (new ChiselStage).emitVerilog(
//     LazyModule(new WavD2DRxWrapper()(p)).module,
//      
//     //args
//     Array("--target-dir", "output/")
//   )
// }

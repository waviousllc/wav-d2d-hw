package wav.d2d

import wav.common._

import chisel3._
import chisel3.util._
import chisel3.stage.ChiselStage
import chisel3.experimental.{ChiselEnum, Analog}

//import chisel3.experimental._
import freechips.rocketchip.amba.axi4._
import freechips.rocketchip.amba.ahb._
import freechips.rocketchip.amba.apb._
import freechips.rocketchip.subsystem.BaseSubsystem
import freechips.rocketchip.subsystem.CrossingWrapper
import freechips.rocketchip.config.{Parameters, Field, Config}
import freechips.rocketchip.diplomaticobjectmodel.model.{OMRegister, OMRegisterMap}
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.regmapper._
import freechips.rocketchip.tilelink._
import freechips.rocketchip.util._
import freechips.rocketchip.unittest._
import freechips.rocketchip.devices.tilelink._


class WavD2DClkRxCoreBundle extends Bundle{
  val coreclk             = Output(Bool()) //should be clock?
  val coreclk_reset       = Output(Bool())
  val en                  = Input (Bool())
  val clk_gate_en         = Input (Bool())
  val reset_sync          = Input (Bool())
  val lp_mode             = Input (Bool())
  val lp_rx               = Output(UInt(2.W))
  
  val start_eye_map       = Input (Bool())
  val train_cdr           = Input (Bool())
  
}

class WavD2DClkRxCoreCalBundle extends Bundle{
  val cal_en              = Input (Bool())
  val cal_done            = Output(Bool())
}

class WavD2DClkRxCoreCDRBundle extends Bundle{
  val en              = Input (Bool())
  val pd_up           = Input (Bool())
  val pd_dn           = Input (Bool())
  val step_up         = Input (Bool())    
  val step_dn         = Input (Bool())
  val vref_lvl        = Input (UInt(6.W))
}


class WavD2DClkRxAnalogBundle extends Bundle{
  val coreclk_div16       = Input (Bool())
  
  val dll_cal_dat         = Input (Bool())
  val dll_cal_en          = Output(Bool())
  //val dll_clk_sel         = Output(Bool())
  val dll_ctrl            = Output(UInt(6.W))
  val dll_en              = Output(Bool())
  val dll_gear            = Output(UInt(2.W))
  
  val dtst_div            = Output(UInt(4.W))
  val dtst_en             = Output(Bool())
  val dtst_sel            = Output(UInt(3.W))
  
  val en_rx_div16_clk     = Output(Bool())
  val en_rx_div2_clk      = Output(Bool())
  
  val i_pi_code           = Output(UInt(16.W))
  val i_pi_en             = Output(Bool())
  val i_pi_quad           = Output(UInt(2.W))
  
  //val itoq_sel            = Output(Bool())
  val pi_gear             = Output(UInt(4.W))
  val pi_xcpl             = Output(UInt(4.W))
  
  val q_pi_code           = Output(UInt(16.W))
  val q_pi_en             = Output(Bool())
  val q_pi_quad           = Output(UInt(2.W))
  
  val rcvr_ac_mode        = Output(Bool())
  val rcvr_bypass_in_n    = Input (Bool())
  val rcvr_bypass_in_p    = Input (Bool())
  val rcvr_bypass_sel     = Output(Bool())
  
  val rcvr_en             = Output(Bool())
  val rcvr_fb_en          = Output(Bool())
  val rcvr_odt_ctrl       = Output(UInt(4.W))
  val rcvr_odt_dc_mode    = Output(Bool())
  
  val reset_sync          = Output(Bool())
  
  val ser_lpb_en          = Output(Bool())
  
  val vref_en             = Output(Bool())
  val vref_lvl            = Output(UInt(6.W))
}


class wav_d2d_clk_ana_rx extends BlackBox{
  val io = IO(new Bundle{
    val clk_rx              = Flipped(new WavD2DClkRxAnalogBundle)
    
    val clk_rx_pll_clk0     = Input (Bool())
    val clk_rx_pll_clk90    = Input (Bool())
    val clk_rx_pll_clk180   = Input (Bool())
    val clk_rx_pll_clk270   = Input (Bool())
    
    val clk_rx_iclk         = Output(Bool())
    val clk_rx_iclkb        = Output(Bool())
    val clk_rx_qclk         = Output(Bool())
    val clk_rx_qclkb        = Output(Bool())
    val clk_rx_clk_div16    = Output(Bool())
    val clk_rx_clk_div8     = Output(Bool())
    
    val clk_rx_dtest        = Output(Bool())
    val clk_rx_dtst_in      = Input (Bool()) //what should this connect to?
    
    val clk_rx_serlb_inp    = Input (Bool())
    val clk_rx_serlb_inn    = Input (Bool())
    
    //val pad_clkn_txrx       = Input (Bool())
    //val pad_clkp_txrx       = Input (Bool())
    val pad_clkn_txrx       = Analog(1.W)
    val pad_clkp_txrx       = Analog(1.W)
    
    val clk_rx_vref         = Output(Bool()) 
    
    val vdda                = Input (Bool())
    val vddq                = Input (Bool())
    val vss                 = Input (Bool())
  })
}



class WavD2DClkRx(val numLanes: Int, val baseAddr: BigInt = 0x0)(implicit p: Parameters) extends LazyModule{
  val device = new SimpleDevice("wavd2dclkrx", Seq("wavious,d2dclkrx"))
  
  val node = WavAPBRegisterNode(
    address = AddressSet.misaligned(baseAddr, 0x100),
    device  = device,
    //concurrency = 1, //make depending on apn (apb requires 1)
    beatBytes = 4)
  
  val xbar    = LazyModule(new APBFanout)
  val eyemap  = LazyModule(new WavD2DRxEyeMapper(numLanes, baseAddr=baseAddr+0x1000))
  
  node        := xbar.node
  eyemap.node := xbar.node
  
  
  override lazy val module = new LazyModuleImp(this) with RequireAsyncReset{
    val io = IO(new Bundle{
      val scan          = new WavScanBundle
      val iddq          = Input(Bool())
      val highz         = Input(Bool())
      val bsr           = new WavBSRBundle
      val refclk        = Input (Bool())
      val refclk_reset  = Input (Bool())
      val core          = new WavD2DClkRxCoreBundle
      val core_cal      = new WavD2DClkRxCoreCalBundle
      val rx_cdr        = Vec(numLanes, Flipped(new WavD2DRxCoreCDRBundle))
      val rx_bist       = Vec(numLanes, Flipped(new WavD2DRxCoreBistBundle))
      val ana           = new WavD2DClkRxAnalogBundle
    })
    
    dontTouch(io.bsr)
    
    val refclk_reset_muxed  = Wire(Bool())
    val refclk_scan         = WavClockMux (io.scan.mode, io.scan.clk,               io.refclk)
    val refclk_reset_scan   = WavResetSync(refclk_scan.asBool,  refclk_reset_muxed, io.scan.asyncrst_ctrl)
    
    
    
    val core_clk_en         = Wire(Bool())
    io.ana.en_rx_div2_clk   := core_clk_en
    io.ana.en_rx_div16_clk  := core_clk_en
    
    val core_reset_sync     = Wire(Bool())
    io.ana.reset_sync       := core_reset_sync
    
    val coreclk_scan          = WavClockMux(io.scan.mode, io.scan.clk, io.ana.coreclk_div16)
    val coreclk_reset_pregate = WavResetSync(coreclk_scan.asBool,  core_reset_sync,   io.scan.asyncrst_ctrl)
    
    val coreclk_gate_en     = Wire(Bool())
    io.core.coreclk         := WavClockGate(clk_in=coreclk_scan, reset_in=coreclk_reset_pregate, enable=coreclk_gate_en, test_en=io.scan.mode)
    
    val register_reset      = WavResetSync(coreclk_scan,   reset.asBool,   io.scan.asyncrst_ctrl)    //Register reset for codes
    
    val lprx                = Cat(io.ana.rcvr_bypass_in_p, io.ana.rcvr_bypass_in_n)
    
    //--------------------------------
    // DLL Calibration
    //--------------------------------
    val dllcal              = withClockAndReset(refclk_scan.asClock, refclk_reset_scan.asAsyncReset){Module(new WavD2DClkRxDLLCal)}
    dllcal.io.code_reset    := register_reset
    dllcal.io.cal_dat       := io.ana.dll_cal_dat
    
    io.core_cal.cal_done    := dllcal.io.done
    
    //--------------------------------
    // PD / CDR / PI / EyeMapper
    //--------------------------------
    val core_cdr            = Wire(new WavD2DClkRxCoreCDRBundle)
    val cdr_reset_muxed     = Wire(Bool())
    val cdr_en_muxed        = Wire(Bool())
    val cdr_freeze_muxed    = Wire(Bool())
    val start_eye_map_muxed = Wire(Bool())
    val train_cdr_muxed     = Wire(Bool())
    
    val en_cdr_clk          = cdr_en_muxed | start_eye_map_muxed | train_cdr_muxed
    val cdr_reset           = WavResetSync(coreclk_scan, cdr_reset_muxed, io.scan.asyncrst_ctrl)
    val cdr_clk             = WavClockGate(clk_in=coreclk_scan, reset_in=cdr_reset, enable=en_cdr_clk, test_en=io.scan.mode)
    
    val swi_step_up         = Wire(Bool())
    val swi_step_dn         = Wire(Bool())
    val step_up_ff2         = withClockAndReset(cdr_clk.asClock, cdr_reset.asAsyncReset){WavDemetReset(swi_step_up)}
    val step_up_ff3         = withClockAndReset(cdr_clk.asClock, cdr_reset.asAsyncReset){WavDemetReset(step_up_ff2)}
    val step_up_edge        = step_up_ff2 ^ step_up_ff3
    
    val step_dn_ff2         = withClockAndReset(cdr_clk.asClock, cdr_reset.asAsyncReset){WavDemetReset(swi_step_dn)}
    val step_dn_ff3         = withClockAndReset(cdr_clk.asClock, cdr_reset.asAsyncReset){WavDemetReset(step_dn_ff2)}
    val step_dn_edge        = step_dn_ff2 ^ step_dn_ff3
    
    val cdr                 = withClockAndReset(cdr_clk.asClock, cdr_reset.asAsyncReset){Module(new WavD2DClkRxCDRLogic)}
    cdr.io.enable           := cdr_en_muxed
    cdr.io.freeze           := cdr_freeze_muxed
    cdr.io.pd_up            := core_cdr.pd_up
    cdr.io.pd_dn            := core_cdr.pd_dn
    cdr.io.step_up          := core_cdr.step_up | step_up_edge
    cdr.io.step_dn          := core_cdr.step_dn | step_dn_edge
    
    io.ana.i_pi_code        := cdr.io.i_pi_ctrl
    io.ana.i_pi_quad        := cdr.io.i_pi_quad
    
    io.ana.q_pi_code        := cdr.io.q_pi_ctrl
    io.ana.q_pi_quad        := cdr.io.q_pi_quad
        
    
    eyemap.module.io.core_clk       := cdr_clk
    eyemap.module.io.core_clk_reset := cdr_reset
    eyemap.module.io.clk_cdr        <> core_cdr
    eyemap.module.io.start_eye_map  := start_eye_map_muxed
    eyemap.module.io.train_cdr      := train_cdr_muxed
    for(i <- 0 until numLanes){
      eyemap.module.io.rx_cdr(i)    <> io.rx_cdr(i)
      eyemap.module.io.rx_bist(i)   <> io.rx_bist(i)
    }
    
    //BSRs
    //val clk_rx_rcvr_en_bsr   = WavBSR(1, io.bsr)
    //val clk_rx_lp_mode_bsr   = WavBSR(1, io.bsr)
    val clk_rx_lp_p_data_bsr = WavBSR(1, io.bsr)
    val clk_rx_lp_n_data_bsr = WavBSR(1, io.bsr)
    
    (clk_rx_lp_p_data_bsr -> clk_rx_lp_n_data_bsr -> io.bsr.tdo)
    
    node.regmap(     
      //-----------------------
      // General Control
      //-----------------------
      WavSWReg(0x0, "CoreOverride", "Overrides for core signals",
        WavRWMux(in=io.core.en,           muxed=core_clk_en,      reg_reset=false.B, mux_reset=false.B, "clk_en",         ""),
        WavRWMux(in=io.core.reset_sync,   muxed=core_reset_sync,  reg_reset=false.B, mux_reset=false.B, "clk_reset_sync", ""),
        WavRWMux(in=io.core.clk_gate_en,  muxed=coreclk_gate_en,  reg_reset=false.B, mux_reset=false.B, "clk_gate_en",    ""),
        WavRWMux(in=io.refclk_reset,      muxed=refclk_reset_muxed,  reg_reset=false.B, mux_reset=false.B, "refclk_reset", "")),
      
      //-----------------------
      // DLL
      //-----------------------
      WavSWReg(0x8, "DLLCal", "Controls for DLL",
        WavRWMux(in=(dllcal.io.en | core_clk_en),  muxed=io.ana.dll_en,      reg_reset=false.B,  mux_reset=false.B,  "dll_en",               ""), 
        WavRWMux(in=io.core_cal.cal_en,   muxed=dllcal.io.en,       reg_reset=false.B, mux_reset=false.B, "dll_digital_cal_en",   ""),
        WavRWMux(in=dllcal.io.en,         muxed=io.ana.dll_cal_en,  reg_reset=false.B, mux_reset=false.B, "dll_analog_cal_en",    ""),
        WavRWMux(in=dllcal.io.ctrl,       muxed=io.ana.dll_ctrl,    reg_reset=0.U,     mux_reset=false.B, "dll_ctrl",             ""),
        WavRW   (io.ana.dll_gear,         3.U,      "dll_gear",           ""),    //TEMP
        //WavRW   (io.ana.dll_clk_sel,      true.B,   "dll_clk_sel",        ""),
        WavRO   (io.ana.dll_cal_dat,                "dll_cal_dat",        ""),
        WavRO   (io.ana.dll_ctrl,                   "dll_ctrl_status",    ""),
        WavRO   (dllcal.io.done,                    "dll_cal_done",       ""),
        WavRO   (dllcal.io.error,                   "dll_cal_error",      "")),
      
      WavSWReg(0xc, "DLLCalSettings", "Controls for DLL State Machine",
        WavRW   (dllcal.io.swi_settle,      8.U,      "dll_settle_time",  ""),
        WavRW   (dllcal.io.swi_polarity,    true.B,   "dll_polarity",     ""),
        WavRW   (dllcal.io.swi_start_code,  0.U,      "dll_start_code",   ""),
        WavRW   (dllcal.io.swi_fine_adjust, false.B,  "dll_fine_adjust",  "")),  
        
      //-----------------------
      // CDR/PI
      //-----------------------
      WavSWReg(0x10, "CDRControl", "",
        WavRWMux(in=core_cdr.en,            muxed=cdr_en_muxed,         reg_reset=false.B, mux_reset=false.B,   "cdr_en",               ""),
        WavRWMux(reset.asBool,              muxed=cdr_reset_muxed,      reg_reset=false.B, mux_reset=false.B,   "cdr_reset",            ""),  //TODO:  See how we can do this better
        WavRWMux(in=false.B,                muxed=cdr_freeze_muxed,     reg_reset=false.B, mux_reset=false.B,   "cdr_freeze",           ""),
        WavRWMux(in=io.core.start_eye_map,  muxed=start_eye_map_muxed,  reg_reset=false.B, mux_reset=false.B,   "start_eye_map",        ""),
        WavRWMux(in=io.core.train_cdr,      muxed=train_cdr_muxed,      reg_reset=false.B, mux_reset=false.B,   "train_cdr",            ""),
        WavRW   (swi_step_up,               false.B,   "step_up",  ""),
        WavRW   (swi_step_dn,               false.B,   "step_dn",  ""),
        WavRW   (cdr.io.sd_gain,            "h76".U,   "cdr_sd_gain",  ""),
        WavRW   (cdr.io.sd_clear,           false.B,   "cdr_sd_clear",  "")),
      WavSWReg(0x14, "PICtrlStatus", "",
        WavRWMux(in=(cdr_en_muxed | core_clk_en),  muxed=io.ana.i_pi_en,      reg_reset=false.B,  mux_reset=false.B,  "i_pi_en",               ""),
        WavRWMux(in=cdr_en_muxed,                  muxed=io.ana.q_pi_en,      reg_reset=false.B,  mux_reset=false.B,  "q_pi_en",               ""),
        WavRO   (cdr.io.i_pi_bin,           "i_pi_bin",  ""),
        WavRO   (cdr.io.q_pi_bin,           "q_pi_bin",  "")),
      WavSWReg(0x18, "PISettings", "",
        WavRW   (io.ana.pi_gear,       4.U,      "pi_gear",    ""),     //TEMP
        WavRW   (io.ana.pi_xcpl,       0.U,      "pi_xcpl",    "")),
      
      //-----------------------
      // RCVR Controls
      //-----------------------
      WavSWReg(0x20, "RCVRControl", "",
        WavRWMux(in=core_clk_en,          muxed=io.ana.rcvr_en,       reg_reset=false.B, mux_reset=false.B, "rcvr_en",   "",
          corescan=Some(io.scan.mode, false.B), iddq=Some(io.iddq, false.B), highz=Some(io.highz, false.B), bscan=Some(io.bsr.bsr_mode, true.B)),
        WavRW   (io.ana.rcvr_ac_mode,     0.U,      "rcvr_ac_mode",     ""),
        WavRW   (io.ana.ser_lpb_en,       0.U,      "ser_lpb_en",       ""),
        WavRWMux(in=io.core.lp_mode,      muxed=io.ana.rcvr_bypass_sel,    reg_reset=false.B, mux_reset=false.B, "rcvr_bypass_sel",
          corescan=Some(io.scan.mode, false.B), iddq=Some(io.iddq, false.B), highz=Some(io.highz, false.B), bscan=Some(io.bsr.bsr_mode, true.B)),
        WavRW   (io.ana.rcvr_fb_en,       0.U,      "rcvr_fb_en",       ""),
        WavRW   (io.ana.rcvr_odt_ctrl,    0.U,      "rcvr_odt_ctrl",    ""),
        WavRW   (io.ana.rcvr_odt_dc_mode, 0.U,      "rcvr_odt_dc_mode", ""),
        WavRWMux(in=core_clk_en,          muxed=io.ana.vref_en,       reg_reset=false.B, mux_reset=false.B, "vref_en",   "",
          corescan=Some(io.scan.mode, false.B), iddq=Some(io.iddq, false.B), highz=Some(io.highz, false.B), bscan=Some(io.bsr.bsr_mode, false.B)),
        WavRWMux(in=core_cdr.vref_lvl,    muxed=io.ana.vref_lvl,      reg_reset="h13".U, mux_reset=false.B, "vref_lvl",   "")),
      
      WavSWReg(0x24, "RCVRStatus", "",
        WavRO   (io.ana.rcvr_bypass_in_p,           "rcvr_bypass_in_p",       "",
          bflop=Some(clk_rx_lp_p_data_bsr)),
        WavRO   (io.ana.rcvr_bypass_in_n,           "rcvr_bypass_in_n",       "",
          bflop=Some(clk_rx_lp_n_data_bsr)),
        WavRWMux(in=lprx,                 muxed=io.core.lp_rx,    reg_reset=0.U, mux_reset=false.B, "lprx")),
        
        
      //-----------------------
      // DTST
      //-----------------------
      WavSWReg(0x40, "DTSTControl", "",
        WavRW   (io.ana.dtst_div,       0.U,      "dtst_div",   ""),
        WavRW   (io.ana.dtst_en,        0.U,      "dtst_en",    ""),
        WavRW   (io.ana.dtst_sel,       0.U,      "dtst_sel",   ""))
    )
    
  }
}



/**
  *   CDR Control / Eye Mapping
  *
  *   numVrefCodes: Total number of codes +/- from mid/start code
  *
  */
object WavD2DRxEyeMapState extends ChiselEnum{
  val IDLE            = Value(0.U)
  val INITIAL_LOCK    = Value(1.U)
  val FREEZE          = Value(2.U)
  val CLICKING_UP     = Value(3.U)
  val RETURN_UP2CENT  = Value(4.U)
  val CLICKING_DN     = Value(5.U)
  val RETURN_DN2CENT  = Value(6.U)
  val VREF_SETTLE     = Value(7.U)
  val DONE            = Value(8.U)
  val PERIODIC        = Value(9.U)
}

class WavD2DRxEyeMapper(val numLanes : Int, val numVrefCodes : Int = 7, val baseAddr : BigInt = 0x0)(implicit p: Parameters) extends LazyModule{

  
  val device = new SimpleDevice("wavd2drx", Seq("wavious,d2drxeyemapper"))
  //val node = WavTLRegisterNode(
  val node = WavAPBRegisterNode(
    //address = AddressSet(baseAddr, 0xff),
    address = AddressSet.misaligned(baseAddr, 0x100 * (numLanes+1)),
    device  = device,
    //concurrency = 1, //make depending on apn (apb requires 1)
    beatBytes = 4)
    
  override lazy val module = new LazyModuleImp(this) with RequireAsyncReset{
  
    val io = IO(new Bundle{
      val core_clk          = Input (Bool())
      val core_clk_reset    = Input (Bool())
      val clk_cdr           = Flipped(new WavD2DClkRxCoreCDRBundle)
      val rx_cdr            = Vec(numLanes, Flipped(new WavD2DRxCoreCDRBundle))
      val rx_bist           = Vec(numLanes, Flipped(new WavD2DRxCoreBistBundle))

      val start_eye_map     = Input (Bool())    //complete EYE map
      val train_cdr         = Input (Bool())    //Periodic train, small adjustment

    })
    
    val swi_cdr_lane_sel    = Wire(UInt(log2Ceil(numLanes).W))      //Which lane to use for the CDR training/initial lock
    val swi_vref_sweep      = Wire(UInt(log2Ceil(numVrefCodes).W))  //+/- from start code for map, has to be within the number of codes
    val swi_vref_step       = Wire(UInt(2.W))                       //Size of VREF increment (0 - 1, 1 - 2, 3 - 4, 4 - 8)
    val swi_lane_mask       = Wire(UInt(numLanes.W))                //Lanes to check
    val swi_lane_agg        = Wire(Bool())                          //Aggregate all lanes, only saving the results to "lane0" memory
    val swi_rx_bist_mode    = Wire(UInt(4.W))
    val swi_start_code      = Wire(UInt(6.W))
    val global_error        = Wire(Bool())
    
    //Up to user to ensure that settings do not blow out of range
    val vref_step_size      = 1.U << swi_vref_step
    val vref_max            = swi_start_code + (swi_vref_sweep << swi_vref_step)
    val vref_min            = swi_start_code - (swi_vref_sweep << swi_vref_step)
    
    
    //Need to see if we can make a custom clock domain block for all of this
    val start_eye_map_ff2   = withClockAndReset(io.core_clk.asClock, io.core_clk_reset.asAsyncReset){WavDemetReset(io.start_eye_map)}
    val train_cdr_ff2       = withClockAndReset(io.core_clk.asClock, io.core_clk_reset.asAsyncReset){WavDemetReset(io.train_cdr)}
    
    val nstate              = WireInit(WavD2DRxEyeMapState.IDLE)
    val state               = withClockAndReset(io.core_clk.asClock, io.core_clk_reset.asAsyncReset){RegNext(nstate, WavD2DRxEyeMapState.IDLE)}
    val count_in            = Wire(UInt(16.W))
    val count               = withClockAndReset(io.core_clk.asClock, io.core_clk_reset.asAsyncReset){RegNext(count_in, 0.U)}
    val done_in             = Wire(Bool())
    val done                = withClockAndReset(io.core_clk.asClock, io.core_clk_reset.asAsyncReset){RegNext(done_in, false.B)}
    
    val swi_initial_lock_count  = Wire(UInt(16.W))
    val swi_check_count         = Wire(UInt(16.W))
    val swi_cdr_click_count     = Wire(UInt(8.W))
    val swi_vref_settle_count   = Wire(UInt(8.W))
    val swi_cdr_periodic_count  = Wire(UInt(16.W))
    
    
    //------------------------------
    // Eye Maps
    //------------------------------
    val clear_eye_maps      = Wire(Bool())
    val update_eye_maps_ups = Wire(Bool())
    val update_eye_maps_dns = Wire(Bool())
    
    class EyePlotResults extends Bundle{
      val ups   = UInt(5.W)
      val dns   = UInt(5.W)
    }
    // This is a 3D memory where the first index is the lane and the 2nd index refers to the VREF
    // Create a Register of Vectors, the 0.U.asTypeOf will handle the reset initialization
    val eye_plots           = withClockAndReset(io.core_clk.asClock, io.core_clk_reset.asAsyncReset){
      Seq.fill(numLanes) {RegInit(0.U.asTypeOf(Vec((numVrefCodes*2)+1, (new EyePlotResults))))}
    }
    
    val eye_map_start_addr  = 0x100
    val eye_plot_regs_offset_per_lane = 0x100
    var eye_plot_regs_seq : scala.collection.mutable.ArrayBuffer[RegField.Map] = scala.collection.mutable.ArrayBuffer[RegField.Map]()
    
    
    val lane_results        = Wire(Vec(numLanes, Bool()))
    val lane_results_agg    = (lane_results.asUInt | swi_lane_mask.asUInt).andR       //all are good
    val lane_restuls_any    = lane_results.orR                                        //at least one is good
    
    for(i <- 0 until numLanes){
      lane_results(i)       := io.rx_bist(i).rx_bist_locked && ~io.rx_bist(i).rx_bist_errorfound 
    }
    
    
    
    eye_plot_regs_seq += WavSWReg(0x0, "GeneralControl", "",
        WavRW   (swi_cdr_lane_sel,        0.U,                  "cdr_lane_sel",         "Selects which lane is used for CDR initial/periodic locking"),
        WavRW   (swi_start_code,          "h20".U,              "start_code",           "Start VREF code when performing Eye Mapping"),
        WavRW   (swi_vref_sweep,          numVrefCodes.asUInt,  "vref_sweep",           "Number of steps to sweep"),
        WavRW   (swi_vref_step,           0.U,                  "vref_step",            "Value of each VREF Step. 0-1, 1-2, 2-4, 4-8"),
        WavRW   (swi_lane_agg,            false.B,              "lane_agg",             "NOT CURRENTLY USED"),
        WavRW   (swi_rx_bist_mode,        4.U,                  "rx_bist_mode",         "BIST Mode to use during eye mapping. Must match far end TX BIST Mode"))
        
    eye_plot_regs_seq += WavSWReg(0x4, "LaneMask", "",
        WavRW   (swi_lane_mask,           0.U,                  "lane_mask",            "Lanes to disable during Eye Mapping"))
        
    eye_plot_regs_seq += WavSWReg(0x8, "Counters1", "",
        WavRW   (swi_initial_lock_count,  1023.U,               "initial_lock_count",   "Number of core_clk cycles to perform initial lock"),
        WavRW   (swi_check_count,         1023.U,                "check_count",          "Number of core_clk cycles to wait after each PI step during eye mapping"))
    
    eye_plot_regs_seq += WavSWReg(0x10, "Counters2", "",
        WavRW   (swi_cdr_click_count,     7.U,                  "cdr_click_count",      "Number of core_clk cycles between each PI step when recentering"),
        WavRW   (swi_vref_settle_count,   7.U,                  "vref_settle_count",    "Number of core_clk cycles to wait after VREF setting has changed"),
        WavRW   (swi_cdr_periodic_count,  255.U,                "cdr_periodic_count",   "Number of core_clk cycles to run CDR during periodic training"))
    
    eye_plot_regs_seq += WavSWReg(0x14, "Status", "",
        WavRO   (done,                                           "done",             "Indicates the previous eye mapping run has completed. Stays asserted until the start of a new eye map run"),
        WavRO   (global_error,                                   "error",            ""),
        WavRO   (state,                                          "fsm_state",        ""))
    
    
    
    withClockAndReset(io.core_clk.asClock, io.core_clk_reset.asAsyncReset){
      val up_step_in        = Wire(UInt(5.W))
      val up_step           = RegNext(up_step_in, 0.U)
      val dn_step_in        = Wire(UInt(5.W))
      val dn_step           = RegNext(dn_step_in, 0.U)
      val cur_vref_in       = Wire(UInt(6.W))
      val cur_vref          = RegNext(cur_vref_in, 32.U)
      val cdr_en_in         = Wire(Bool())
      val cdr_en            = RegNext(cdr_en_in, false.B)
      val cdr_step_up_in    = Wire(Bool())
      val cdr_step_up       = RegNext(cdr_step_up_in, false.B)
      val cdr_step_dn_in    = Wire(Bool())
      val cdr_step_dn       = RegNext(cdr_step_dn_in, false.B)
      val cur_vref_dir_in   = Wire(Bool())
      val cur_vref_dir      = RegNext(cur_vref_dir_in, false.B)      // 1 - Up, 0 - Down
      
      val rx_bist_en_in     = Wire(Bool())
      val rx_bist_en        = RegNext(rx_bist_en_in, false.B)
      
      val err_reg_in        = Wire(Bool())
      val err_reg           = RegNext(err_reg_in, false.B)
      
      val sec_count_in      = Wire(UInt(8.W))
      val sec_count         = RegNext(sec_count_in, 0.U)
      
      val start_eye_map_ff3 = RegNext(start_eye_map_ff2, false.B)
      val start_eye_map_pe  = start_eye_map_ff2 & ~start_eye_map_ff3
      val train_cdr_ff3     = RegNext(train_cdr_ff2, false.B)
      val train_cdr_pe      = train_cdr_ff2 & ~train_cdr_ff3
      
      
      
      nstate                := state
      count_in              := count
      up_step_in            := up_step
      dn_step_in            := dn_step
      cur_vref_in           := cur_vref
      cdr_en_in             := cdr_en
      cdr_step_up_in        := false.B
      cdr_step_dn_in        := false.B
      err_reg_in            := err_reg
      cur_vref_dir_in       := cur_vref_dir
      
      clear_eye_maps        := false.B
      update_eye_maps_ups   := false.B
      update_eye_maps_dns   := false.B
      
      rx_bist_en_in         := rx_bist_en
      sec_count_in          := 0.U
      done_in               := done
      
      
      
      when(state === WavD2DRxEyeMapState.IDLE){
        when(start_eye_map_pe){
          done_in           := false.B
          cdr_en_in         := true.B
          cur_vref_in       := swi_start_code
          count_in          := swi_initial_lock_count
          err_reg_in        := false.B
          cur_vref_dir_in   := true.B
          clear_eye_maps    := true.B
          up_step_in        := 1.U
          dn_step_in        := 1.U
          nstate            := WavD2DRxEyeMapState.INITIAL_LOCK     //TODO: see about skipping initial lock with setting
        }.elsewhen(train_cdr_pe){
          cdr_en_in         := true.B
          count_in          := swi_cdr_periodic_count
          nstate            := WavD2DRxEyeMapState.PERIODIC
        }
      
      
      }.elsewhen(state === WavD2DRxEyeMapState.INITIAL_LOCK){
        //-------------------------------------
        // Initial locking when performing EYE Mapping
        // Run for X cycles then check the BIST status
        when(count === 0.U){
          cdr_en_in         := false.B
          err_reg_in        := ~lane_results_agg                //all should be good for initial lock
          nstate            := WavD2DRxEyeMapState.FREEZE       //should we revert to IDLE if bad?????????
        }.otherwise{
          count_in          := count - 1.U
        }
      
      }.elsewhen(state === WavD2DRxEyeMapState.FREEZE){
        //-------------------------------------
        // 
        // 
        
        //Check for done
        rx_bist_en_in       := true.B
        cdr_step_up_in      := true.B
        count_in            := swi_check_count
        nstate              := WavD2DRxEyeMapState.CLICKING_UP
        
        
        
      }.elsewhen(state === WavD2DRxEyeMapState.CLICKING_UP){
        //-------------------------------------
        // Going in the UP direction
        // 
        when(count === 0.U){
          
          update_eye_maps_ups := true.B
          
          //As long as ANY of them are good, keep moving, else click back down to center and start in other direction
          when(lane_restuls_any && (up_step =/= 31.U)){
            up_step_in        := up_step + 1.U
            cdr_step_up_in    := true.B
            count_in          := swi_check_count
          }.otherwise{
            up_step_in        := 1.U
            count_in          := up_step
            sec_count_in      := swi_cdr_click_count
            rx_bist_en_in     := false.B
            nstate            := WavD2DRxEyeMapState.RETURN_UP2CENT
          }
        }.otherwise{
          count_in            := count - 1.U
        }
        
      }.elsewhen(state === WavD2DRxEyeMapState.RETURN_UP2CENT){
        //-------------------------------------
        // Returning back to center PI code
        // I tried to get 50cent here, but he wasn't available

        
        when(sec_count === 0.U){
          cdr_step_dn_in      := true.B
          sec_count_in        := swi_cdr_click_count
          
          when(count === 0.U){
            rx_bist_en_in     := true.B
            count_in          := swi_check_count
            nstate            := WavD2DRxEyeMapState.CLICKING_DN
          }.otherwise{
            count_in          := count - 1.U
          }
        }.otherwise{
          sec_count_in        := sec_count - 1.U
        }
      
      }.elsewhen(state === WavD2DRxEyeMapState.CLICKING_DN){
        //-------------------------------------
        // Going in the DN direction
        // 
        when(count === 0.U){
          
          update_eye_maps_dns := true.B
          
          //As long as ANY of them are good, keep moving, else click back down to center and start in other direction
          when(lane_restuls_any && (dn_step =/= 31.U)){
            dn_step_in        := dn_step + 1.U
            cdr_step_dn_in    := true.B
            count_in          := swi_check_count
          }.otherwise{
            dn_step_in        := 1.U
            count_in          := dn_step
            sec_count_in      := swi_cdr_click_count
            rx_bist_en_in     := false.B
            nstate            := WavD2DRxEyeMapState.RETURN_DN2CENT
          }
        }.otherwise{
          count_in            := count - 1.U
        }
        
      }.elsewhen(state === WavD2DRxEyeMapState.RETURN_DN2CENT){
        //-------------------------------------
        // Returning back to center PI code
        
        when(sec_count === 0.U){
          cdr_step_up_in    := true.B
          sec_count_in      := swi_cdr_click_count
          
          when(count === 0.U){
            when(cur_vref_dir){
              when(cur_vref === vref_max){
                cur_vref_dir_in := false.B
                cur_vref_in     := swi_start_code - 1.U
              }.otherwise{
                cur_vref_in     := cur_vref + vref_step_size
              }
              count_in          := swi_vref_settle_count
              nstate            := WavD2DRxEyeMapState.VREF_SETTLE
            }.otherwise{
              when(cur_vref === vref_min){
                cur_vref_in     := swi_start_code
                cdr_step_up_in  := false.B                            //this is to return back to the original center
                done_in         := true.B
                nstate          := WavD2DRxEyeMapState.IDLE
              }.otherwise{
                cur_vref_in     := cur_vref - vref_step_size
                count_in        := swi_vref_settle_count
                nstate          := WavD2DRxEyeMapState.VREF_SETTLE
              }
            }
          }.otherwise{
           count_in           := count - 1.U
          }
        }.otherwise{
          sec_count_in        := sec_count - 1.U
        }
      
      }.elsewhen(state === WavD2DRxEyeMapState.VREF_SETTLE){
        //-------------------------------------
        // Time for VREF to settle after changes
        when(count === 0.U){
          rx_bist_en_in       := true.B
          count_in            := swi_check_count
          nstate              := WavD2DRxEyeMapState.CLICKING_UP
        }.otherwise{
          count               := count - 1.U
        }
        
        
      }.elsewhen(state === WavD2DRxEyeMapState.PERIODIC){
        when(count === 0.U){
          cdr_en_in           := false.B
          nstate              := WavD2DRxEyeMapState.IDLE
        }.otherwise{
          count_in            := count - 1.U
        }
      }.otherwise{
        nstate                := WavD2DRxEyeMapState.IDLE
      }
      
      
      //just tie off for now
      io.clk_cdr.en         := cdr_en
      //io.clk_cdr.freeze     := false.B
      io.clk_cdr.step_up    := cdr_step_up
      io.clk_cdr.step_dn    := cdr_step_dn
      io.clk_cdr.pd_up      := io.rx_cdr(swi_cdr_lane_sel).pdup
      io.clk_cdr.pd_dn      := io.rx_cdr(swi_cdr_lane_sel).pddn
      io.clk_cdr.vref_lvl   := cur_vref
      
      
      global_error          := err_reg
      
      for(i <- 0 until numLanes){
        io.rx_bist(i).rx_bist_en  := rx_bist_en & ~swi_lane_mask(i)
        io.rx_bist(i).rx_bist_mode:= swi_rx_bist_mode
        
        io.rx_cdr(i).pden     := cdr_en
        io.rx_cdr(i).pdrst    := io.core_clk_reset
      }
      
      //-----------------------------------
      // Applying Eye Map updates
      //-----------------------------------
      val cur_vref_em_offset  = Mux(cur_vref === swi_start_code, 0.U,
                                Mux(cur_vref >   swi_start_code, (cur_vref - swi_start_code) >> swi_vref_step, (swi_start_code + cur_vref) >> swi_vref_step))
      val cur_vref_em_index   = numVrefCodes.asUInt + cur_vref_em_offset
      
      
      for(lane <- 0 until numLanes){
        eye_plots(lane)(cur_vref_em_index).ups := Mux(update_eye_maps_ups && lane_results(lane), up_step, eye_plots(lane)(cur_vref_em_index).ups)
        eye_plots(lane)(cur_vref_em_index).dns := Mux(update_eye_maps_dns && lane_results(lane), dn_step, eye_plots(lane)(cur_vref_em_index).dns)
        
        //Register Building
        for(vindex <- 0 until (numVrefCodes*2)+1){
          var vindex_off    = vindex - numVrefCodes
                    
          val vindex_real   = Wire(UInt(6.W))
          if(vindex_off < 0){
            vindex_real       := swi_start_code - ((vindex_off * -1).asUInt << swi_vref_step)
          } else {
            vindex_real       := swi_start_code + (vindex_off.asUInt << swi_vref_step)
          }
          val addr          = eye_map_start_addr + (eye_plot_regs_offset_per_lane*lane) + (vindex*0x4)
          val plus_minus    = if(vindex_off >= 0) "P" else "M"
          vindex_off        = if(vindex_off < 0) vindex_off * -1 else vindex_off
          val reg_name      = s"Lane${lane}_Vref${plus_minus}${vindex_off}"
          
          eye_plot_regs_seq +=  WavSWReg(addr, reg_name, "", 
                                  WavRO(eye_plots(lane)(cur_vref_em_index).dns,   "DNs",        "Number of successful down steps"),
                                  WavRO(eye_plots(lane)(cur_vref_em_index).ups,   "UPs",        "Number of successful up steps"),
                                  WavRO(vindex_real,                              "VREFValue",  "VREF value that was used during check"))
          
          
          //Final check for clearing the eye map
          when(clear_eye_maps){
            eye_plots(lane)(vindex).ups := 0.U
            eye_plots(lane)(vindex).dns := 0.U
          }
        }
      }
      
      
    }
    
    
    
    //------------------------------------------------
    // Register Generation
    //------------------------------------------------
    // Here is an explanation of what is going on here.
    // node.regmap takes a RegField.Map* which is a varargs type of pass. Normally we call node.regmap(WavSWReg, WavSWReg, etc.)
    // which does this vararg by us explicitly adding each register to the call.
    // Since we make a collection of registers on the fly in this case, we need to have a way to pass them all to the node.regmap
    // with only a single call.
    //
    // So to do this, we have this method created which takes our ArrayBuffer and passes it with a smooch operator. This treats
    // each element as it's own "argument", so it comes out to be each RegField.Map
    //
    // There may be better ways to do this....
    def callregmap(rf:scala.collection.mutable.ArrayBuffer[RegField.Map]) = {node.regmap(rf:_*) }
    
    callregmap(eye_plot_regs_seq)
      
  }
}


/**
  *   CDR Logic
  *
  *   
  */
class WavD2DClkRxCDRLogic(val sdWidth: Int = 7)(implicit p: Parameters) extends Module{
  val io = IO(new Bundle{
    val enable      = Input (Bool())
    val freeze      = Input (Bool())
    val sd_clear    = Input (Bool())
    val sd_gain     = Input (UInt(sdWidth.W))
    val pd_up       = Input (Bool())
    val pd_dn       = Input (Bool())
    val step_up     = Input (Bool())
    val step_dn     = Input (Bool())
    
    val i_pi_bin    = Output(UInt(6.W))
    val i_pi_ctrl   = Output(UInt(16.W))
    val i_pi_quad   = Output(UInt(2.W))
    
    val q_pi_bin    = Output(UInt(6.W))
    val q_pi_ctrl   = Output(UInt(16.W))
    val q_pi_quad   = Output(UInt(2.W))
    
  })
  
  
  val sd_dn_gain    = Wire(UInt(sdWidth.W))
  sd_dn_gain        := ~io.sd_gain + 1.U
  val sd_addin      = Mux(io.freeze | WavDemetReset(~io.enable),  0.U, 
                      Mux(io.pd_up,   io.sd_gain,
                      Mux(io.pd_dn,   sd_dn_gain, 0.U)))
  
  val sigdelt       = Module(new wav_sigdelt)
  sigdelt.io.clk    := clock.asBool
  sigdelt.io.reset  := reset.asBool
  sigdelt.io.clear  := WavDemetReset(io.sd_clear)
  sigdelt.io.addin  := sd_addin
  val pol           = sigdelt.io.polarity
  val ov            = sigdelt.io.overflow
  
  val up            = (ov & ~pol) | io.step_up
  val dn            = (ov &  pol) | io.step_dn
  
  val ipi_ce        = Module(new wav_pi_control_encode)
  ipi_ce.io.clk     := clock.asBool
  ipi_ce.io.reset   := reset.asBool
  ipi_ce.io.oneup   := up
  ipi_ce.io.onedown := dn
  
  io.i_pi_bin       := ipi_ce.io.pi_bin
  io.i_pi_ctrl      := ipi_ce.io.pi_ctrl
  io.i_pi_quad      := ipi_ce.io.pi_quad
  
  //COME BACK AND ADD IN QPI OFFSET
  //THIS IS TEMPORARY!!
  io.q_pi_bin       := ipi_ce.io.pi_bin
  io.q_pi_ctrl      := ipi_ce.io.pi_ctrl
  io.q_pi_quad      := ipi_ce.io.pi_quad
  
}


object WavD2DClkRxDLLCalState extends ChiselEnum{
  val IDLE, EN_WAIT, SETTLE, INCR, DONE = Value
}

class WavD2DClkRxDLLCal()(implicit p: Parameters) extends Module{
  val io = IO(new Bundle{
    val code_reset      = Input (Bool())
    val en              = Input (Bool())
    val swi_settle      = Input (UInt(8.W))
    val swi_polarity    = Input (Bool())
    val swi_start_code  = Input (UInt(6.W))
    val swi_fine_adjust = Input (Bool())
    val cal_dat         = Input (Bool())
    
    val ctrl            = Output(UInt(6.W))
    val error           = Output(Bool())
    val done            = Output(Bool())
  })
  
  
  val en_ff2            = WavDemetReset(io.en)
  val cal_dat_ff2       = WavDemetReset(Mux(io.swi_polarity, ~io.cal_dat, io.cal_dat))
  val cal_dat_ff3       = RegNext(next=cal_dat_ff2, init=0.U)
  
    
  val nstate            = WireInit(WavD2DClkRxDLLCalState.IDLE)
  val state             = RegNext(next=nstate, init=WavD2DClkRxDLLCalState.IDLE)
  
  val ctrl_in           = Wire(UInt(6.W))
  val ctrl              = withReset(io.code_reset.asAsyncReset){RegNext(next=ctrl_in, init=0.U)}
  val ctrl_next         = Wire(UInt(6.W))
  
  
  val count_in          = Wire(UInt(8.W))
  val count             = RegNext(next=count_in, 0.U)
  
  val cal_dat_prev_in   = Wire(Bool())
  val cal_dat_prev      = RegNext(next=cal_dat_prev_in, init=false.B)
  val cal_dat_flip      = cal_dat_prev ^ cal_dat_ff2
  
  val done_in           = Wire(Bool())
  val done              = RegNext(done_in, false.B)
  
  val error_in          = Wire(Bool())
  val error             = RegNext(error_in, false.B)
  
  
  //Min/max check
  ctrl_next             := Mux(cal_dat_ff2, 
                             Mux(ctrl === "h3f".U, ctrl, ctrl + 1.U),
                             Mux(ctrl === "h00".U, ctrl, ctrl - 1.U))
  val ctrl_max_min      = ctrl === ctrl_next
  
  nstate                := state
  ctrl_in               := ctrl
  count_in              := 0.U
  cal_dat_prev_in       := cal_dat_prev
  error_in              := error
  done_in               := done
  
  
  when(state === WavD2DClkRxDLLCalState.IDLE){
    //-----------------------------------------------
    when(en_ff2){
      count_in          := io.swi_settle
      //If using fine adjust, keep the last calibrated code
      ctrl_in           := Mux(~io.swi_fine_adjust, io.swi_start_code, ctrl) 
      nstate            := WavD2DClkRxDLLCalState.EN_WAIT                       //Do we want fine adjust to skip EN_WAIT?
    }
  
  }.elsewhen(state === WavD2DClkRxDLLCalState.EN_WAIT){
    //-----------------------------------------------
    // Waiting for the DLL calibration to peform an initial
    // settle time. We go ahead and sample the cal_dat to get
    // a baseline value. We then proceed to the SETTLE state
    // and on the next INCR state will start checking for the 
    // flip of the cal data
    when(count === 0.U){
      cal_dat_prev_in   := cal_dat_ff2
      count_in          := io.swi_settle
      nstate            := WavD2DClkRxDLLCalState.SETTLE
    }.otherwise{
      count_in          := count - 1.U
    }
  
  }.elsewhen(state === WavD2DClkRxDLLCalState.SETTLE){
    //-----------------------------------------------
    when(count === 0.U){
      when(cal_dat_flip){
        // Done
        done_in         := true.B
        nstate          := WavD2DClkRxDLLCalState.DONE
      }.otherwise{
        // Increment or decrement the code based on the cal dat
        // If we have maxed/mined out the code and still need more range
        // set the error
        when(ctrl_max_min){
          done_in       := true.B
          error_in      := true.B
          nstate        := WavD2DClkRxDLLCalState.DONE
        }.otherwise{
          ctrl_in       := ctrl_next
          count_in      := io.swi_settle
          nstate        := WavD2DClkRxDLLCalState.SETTLE
        }
      }
    }.otherwise{
      count_in          := count - 1.U
    }
  
  }.elsewhen(state === WavD2DClkRxDLLCalState.DONE){
    //-----------------------------------------------
    when(~en_ff2){
      done_in           := false.B
      error_in          := false.B
      nstate            := WavD2DClkRxDLLCalState.IDLE
    }
      
  }.otherwise{
    //-----------------------------------------------
    //Default
    nstate              := WavD2DClkRxDLLCalState.IDLE
  }
  
  
  io.done     := done
  io.error    := error
  io.ctrl     := ctrl
  
}


/**********************************************************************
*   Generation Wrappers
**********************************************************************/
// class WavD2DClkRxWrapper()(implicit p: Parameters) extends LazyModule{
//   
//   val xbar = LazyModule(new TLXbar)
//   val ApbPort = APBMasterNode(
//     portParams = Seq(APBMasterPortParameters(masters = Seq(APBMasterParameters(name = "ApbPort"))))
//   )
//   val apbport = InModuleBody {ApbPort.makeIOs()}
//   xbar.node := APBToTL() := ApbPort
//   
//   val clkrx = LazyModule(new WavD2DClkRx(baseAddr=0)(p))
//   
//   clkrx.node := xbar.node
//   
//   lazy val module = new LazyModuleImp(this) with RequireAsyncReset{
//     val io = IO(clkrx.module.io.cloneType)
//     
//     io <> clkrx.module.io
//   }
//   
// }
// 
// object WavD2DClkRxWrapperGen extends App {  
//   //Create an empty parameter if we have nothing to use
//   //implicit val p: Parameters = Parameters.empty
//   implicit val p: Parameters = new BaseXbarConfig
//   
//   val axiverilog = (new ChiselStage).emitVerilog(
//     LazyModule(new WavD2DClkRxWrapper()(p)).module,
//      
//     //args
//     Array("--target-dir", "output/")
//   )
// }


// class WavD2DRxEyeMapperWrapper()(implicit p: Parameters) extends LazyModule{
//   
//   val xbar = LazyModule(new TLXbar)
//   val ApbPort = APBMasterNode(
//     portParams = Seq(APBMasterPortParameters(masters = Seq(APBMasterParameters(name = "ApbPort"))))
//   )
//   val apbport = InModuleBody {ApbPort.makeIOs()}
//   xbar.node := APBToTL() := ApbPort
//   
//   val em = LazyModule(new WavD2DRxEyeMapper(numLanes=2, baseAddr=0)(p))
//   
//   em.node := xbar.node
//   
//   lazy val module = new LazyModuleImp(this) with RequireAsyncReset{
//     val io = IO(em.module.io.cloneType)
//     
//     io <> em.module.io
//   }
//   
// }
// 
// object WavD2DRxEyeMapperWrapperGen extends App {  
//   //Create an empty parameter if we have nothing to use
//   //implicit val p: Parameters = Parameters.empty
//   implicit val p: Parameters = new BaseXbarConfig
//   
//   val axiverilog = (new ChiselStage).emitVerilog(
//     LazyModule(new WavD2DRxEyeMapperWrapper()(p)).module,
//      
//     //args
//     Array("--target-dir", "output/", "--no-dce")
//   )
//   
//   GenElabArts.gen("mytest")
// }

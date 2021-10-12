package wav.d2d

import wav.common._

import chisel3._
import chisel3.util._
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

class WavD2DClkAnalogBundle extends Bundle{
  val coreclk_div16                = Input (Bool())                                                     
  val dll_cal_dat                  = Input (Bool())    
                                                   
  val dll_cal_en                   = Output(Bool())                                                     
  val dll_clk_sel                  = Output(Bool())                                                     
  val dll_ctrl                     = Output(UInt(6.W))                                                  
  val dll_en                       = Output(Bool())                                                     
  val dll_gear                     = Output(UInt(2.W))                                                  
  val drv_bypass_out_n             = Output(Bool())                                                     
  val drv_bypass_out_p             = Output(Bool())                                                     
  val drv_bypass_sel               = Output(Bool())                                                     
  val drv_ctrl                     = Output(UInt(4.W))                                                  
  val drv_en                       = Output(Bool())                                                     
  val drv_preemp                   = Output(UInt(3.W))                                                  
  val dtest_div                    = Output(UInt(4.W))                                                  
  val dtest_en                     = Output(Bool())                                                     
  val dtest_in                     = Output(Bool())                                                     
  val dtest_sel                    = Output(UInt(3.W))                                                  
  val en_rx_div16_clk              = Output(Bool())                                                     
  val en_rx_div2_clk               = Output(Bool())                                                     
  val en_tx_div16_clk              = Output(Bool())                                                     
  val en_tx_div2_clk               = Output(Bool())                                                     
  val itoq_sel                     = Output(Bool())                                                     
  val pi_gear                      = Output(UInt(4.W))                                                  
  val pi_xcpl                      = Output(UInt(4.W))                                                  
  val rcvr_ac_mode                 = Output(Bool())    
                                                   
  val rcvr_bypass_in_n             = Input (Bool())                                                     
  val rcvr_bypass_in_p             = Input (Bool())   
                                                    
  val rcvr_bypass_sel              = Output(Bool())                                                     
  val rcvr_clk_sel                 = Output(Bool())                                                     
  val rcvr_en                      = Output(Bool())                                                     
  val rcvr_fb_en                   = Output(Bool())                                                     
  val rcvr_odt_ctrl                = Output(UInt(4.W))                                                  
  val rcvr_odt_dc_mode             = Output(Bool())                                                     
  val reset_sync                   = Output(Bool())                                                     
  val rx_i_pi_code                 = Output(UInt(16.W))                                                 
  val rx_i_pi_en                   = Output(Bool())                                                     
  val rx_i_pi_quad                 = Output(UInt(2.W))                                                  
  val rx_q_pi_code                 = Output(UInt(16.W))                                                 
  val rx_q_pi_en                   = Output(Bool())                                                     
  val rx_q_pi_quad                 = Output(UInt(2.W))                                                  
  val tx_pi_code                   = Output(UInt(16.W))                                                 
  val tx_pi_en                     = Output(Bool())                                                     
  val tx_pi_quad                   = Output(UInt(2.W))   
}


class WavD2DClkCoreBundle extends Bundle{
  val clk_en          = Input (Bool())
  val clk_reset_sync  = Input (Bool())
  val link_clk        = Output(Bool())
}


object WavD2DClkRegs {
  val CoreOverride      = 0x00
  
  val ClkEnables        = 0x04
  val RX_I_PI           = 0x08
  val RX_Q_PI           = 0x0c
  val TX_PI             = 0x10
  val PIGearXcpl        = 0x14
  
  val DLLCtrl           = 0x18
  val DLLCal            = 0x1c
  val DriverCtrl        = 0x20
  val DriverBypass      = 0x24
  val RcvrCtrl          = 0x28
  val RcvrBypass        = 0x2c
  
  val DtstCtrl          = 0x30
}

class WavD2DClk (val baseAddr: BigInt = 0x0)(implicit p: Parameters) extends LazyModule{
  val device = new SimpleDevice("wavd2dclk", Seq("wavious,d2dclk"))
  val node = TLRegisterNode(
    address = AddressSet.misaligned(baseAddr, 0x100),
    device  = device,
    concurrency = 1, //make depending on apn (apb requires 1)
    beatBytes = 4)
  
  
  override lazy val module = new LazyModuleImp(this) with RequireAsyncReset{
    val io = IO(new Bundle{
      val scan          = new WavScanBundle
      val refclk        = Input (Clock())
      val refclk_reset  = Input (AsyncReset())
      val core          = new WavD2DClkCoreBundle
      val default_master= Input (Bool())
      //val tx_pi_up      = Input (Bool())
      //val rx_pi_up      = Input (Bool())
      val ana           = new WavD2DClkAnalogBundle
    })
    
    dontTouch(io.scan)
    dontTouch(io.core)
    dontTouch(io.ana)
    
    val link_clk_scan   = WavClockMux(io.scan.mode, io.scan.clk, io.ana.coreclk_div16)
    
    io.core.link_clk    := link_clk_scan
    
    val core_clk_en     = Wire(Bool())
    
    // TODO: should we make this synchronous after the clock is enabled?
    val core_reset_sync     = Wire(Bool())
    val core_reset_sync_scan= WavResetSync(link_clk_scan, core_reset_sync, io.scan.asyncrst_ctrl)
    
    io.ana.reset_sync   := core_reset_sync
    
    
    
    
    val dll_en          = WireDefault(false.B)
    val dll_cal_en      = WireDefault(false.B)
    val drv_en          = WireDefault(io.default_master)
    val rcvr_en         = WireDefault(~io.default_master)
    
    //--------------------------
    // PI Control
    //--------------------------
    val rx_i_pi_code    = Wire(UInt(16.W))
    val rx_i_pi_quad    = Wire(UInt(2.W))
    val rx_i_pi_en      = io.core.clk_en 
    val rx_i_pi_bin     = Wire(UInt(6.W))
    
    val rx_q_pi_code    = Wire(UInt(16.W))
    val rx_q_pi_quad    = Wire(UInt(2.W))
    val rx_q_pi_en      = io.core.clk_en 
    val rx_q_pi_bin     = Wire(UInt(6.W))
    
    val tx_pi_code      = Wire(UInt(16.W))
    val tx_pi_quad      = Wire(UInt(2.W))
    val tx_pi_en        = io.core.clk_en 
    val tx_pi_bin       = Wire(UInt(6.W))
    
    //Since we cannot access the implicit clock/reset inside the withClcokAndreset block
    val swi_clk         = clock
    val swi_reset       = reset
    
    withClockAndReset(link_clk_scan.asClock, core_reset_sync_scan.asAsyncReset){
      val tx_pi = Module(new WavD2DClkPIEncode)
      tx_pi.io.training_clk     := io.refclk
      tx_pi.io.training_reset   := io.refclk_reset
      tx_pi.io.training_oneup   := false.B
      tx_pi.io.training_onedn   := false.B    //TODO Connect
      tx_pi.io.training_steps   := 32.U
      
      tx_pi.io.swi_clk          := swi_clk
      tx_pi.io.swi_reset        := swi_reset
      tx_pi.io.swi_oneup        := false.B
      tx_pi.io.swi_onedn        := false.B
      
      tx_pi_bin                 := tx_pi.io.pi_bin
      tx_pi_code                := tx_pi.io.pi_ctrl
      tx_pi_quad                := tx_pi.io.pi_quad
      
      
      val rx_i_pi = Module(new WavD2DClkPIEncode)
      rx_i_pi.io.training_clk     := io.refclk
      rx_i_pi.io.training_reset   := io.refclk_reset
      rx_i_pi.io.training_oneup   := false.B
      rx_i_pi.io.training_onedn   := false.B    //TODO Connect
      rx_i_pi.io.training_steps   := 32.U
      
      rx_i_pi.io.swi_clk          := swi_clk
      rx_i_pi.io.swi_reset        := swi_reset
      rx_i_pi.io.swi_oneup        := false.B
      rx_i_pi.io.swi_onedn        := false.B
      
      rx_i_pi_bin                 := rx_i_pi.io.pi_bin
      rx_i_pi_code                := rx_i_pi.io.pi_ctrl
      rx_i_pi_quad                := rx_i_pi.io.pi_quad
      
      val rx_q_pi = Module(new WavD2DClkPIEncode)
      rx_q_pi.io.training_clk     := io.refclk
      rx_q_pi.io.training_reset   := io.refclk_reset
      rx_q_pi.io.training_oneup   := false.B
      rx_q_pi.io.training_onedn   := false.B    //TODO Connect
      rx_q_pi.io.training_steps   := 32.U
      
      rx_q_pi.io.swi_clk          := swi_clk
      rx_q_pi.io.swi_reset        := swi_reset
      rx_q_pi.io.swi_oneup        := false.B
      rx_q_pi.io.swi_onedn        := false.B
      
      rx_q_pi_bin                 := rx_q_pi.io.pi_bin
      rx_q_pi_code                := rx_q_pi.io.pi_ctrl
      rx_q_pi_quad                := rx_q_pi.io.pi_quad
    }
    
    
    
    
    //Registers
    node.regmap(
      //-----------------------
      // General Control
      //-----------------------
      WavSWReg(0x0, "CoreOverride", "Overrides for core signals",
        WavRWMux(in=io.core.clk_en,         muxed=core_clk_en,      reg_reset=false.B, mux_reset=false.B, "clk_en",         ""),
        WavRWMux(in=io.core.clk_reset_sync, muxed=core_reset_sync,  reg_reset=false.B, mux_reset=false.B, "clk_reset_sync", "")),
      
      //-----------------------
      // PIs/Clocks
      //-----------------------
      WavSWReg(0x4, "ClkEnables", "",
        WavRWMux(in=core_clk_en,     muxed=io.ana.en_rx_div16_clk,   reg_reset=false.B, mux_reset=false.B, "en_rx_div16_clk",   ""),
        WavRWMux(in=core_clk_en,     muxed=io.ana.en_rx_div2_clk,    reg_reset=false.B, mux_reset=false.B, "en_rx_div2_clk",    ""),
        WavRWMux(in=core_clk_en,     muxed=io.ana.en_tx_div16_clk,   reg_reset=false.B, mux_reset=false.B, "en_tx_div16_clk",   ""),
        WavRWMux(in=core_clk_en,     muxed=io.ana.en_tx_div2_clk,    reg_reset=false.B, mux_reset=false.B, "en_tx_div2_clk",    "")),      
      
      WavSWReg(0x8, "RX_I_PI", "",
        WavRWMux(in=rx_i_pi_code,    muxed=io.ana.rx_i_pi_code,   reg_reset=false.B, mux_reset=false.B, "rx_i_pi_code",   ""),
        WavRWMux(in=rx_i_pi_quad,    muxed=io.ana.rx_i_pi_quad,   reg_reset=false.B, mux_reset=false.B, "rx_i_pi_quad",   ""),
        WavRWMux(in=rx_i_pi_en,      muxed=io.ana.rx_i_pi_en,     reg_reset=false.B, mux_reset=false.B, "rx_i_pi_en",     ""),
        WavRO   (rx_i_pi_bin, "rx_i_pi_bin" , "Binary value of current PI location")),
                                       
      WavSWReg(0xc, "RX_Q_PI", "",
        WavRWMux(in=rx_q_pi_code,    muxed=io.ana.rx_q_pi_code,   reg_reset=false.B, mux_reset=false.B, "rx_q_pi_code",   ""),
        WavRWMux(in=rx_q_pi_quad,    muxed=io.ana.rx_q_pi_quad,   reg_reset=false.B, mux_reset=false.B, "rx_q_pi_quad",   ""),
        WavRWMux(in=rx_q_pi_en,      muxed=io.ana.rx_q_pi_en,     reg_reset=false.B, mux_reset=false.B, "rx_q_pi_en",     ""),
        WavRO   (rx_q_pi_bin, "rx_q_pi_bin" , "Binary value of current PI location")),
        
      WavSWReg(0x10, "TX_PI", "",
        WavRWMux(in=tx_pi_code,      muxed=io.ana.tx_pi_code,     reg_reset=false.B, mux_reset=false.B, "tx_pi_code",     ""),
        WavRWMux(in=tx_pi_quad,      muxed=io.ana.tx_pi_quad,     reg_reset=false.B, mux_reset=false.B, "tx_pi_quad",     ""),
        WavRWMux(in=tx_pi_en,        muxed=io.ana.tx_pi_en,       reg_reset=false.B, mux_reset=false.B, "tx_pi_en",       ""),
        WavRO   (tx_pi_bin, "tx_pi_bin" , "Binary value of current PI location")),
      
      WavSWReg(0x14, "PIGearXcpl", "",
        WavRW   (io.ana.pi_gear,        8.U,      "pi_gear",       ""),
        WavRW   (io.ana.pi_xcpl,        0.U,      "pi_xcpl",       ""),
        WavRW   (io.ana.itoq_sel,       0.U,      "dtest_in",      "")),
      
      //-----------------------
      // DLL
      //-----------------------  
      WavSWReg(0x18, "DLLCtrl", "",
        WavRWMux(in=dll_en,         muxed=io.ana.dll_en,   reg_reset=false.B, mux_reset=false.B, "dll_en",   ""),
        WavRW   (io.ana.dll_clk_sel,       0.U,      "dll_clk_sel",    "Clock source 0 - PLL, 1 - DLL"),
        WavRW   (io.ana.dll_ctrl,          0.U,      "dll_ctrl",       "DLL Control Code"),
        WavRW   (io.ana.dll_gear,          0.U,      "dll_gear",       "DLL Gear: 00 - < 8GHz, 01 - 5-8GHz, 10 - 8-10 GHz, 11 - 10-14GHz")),
      
      WavSWReg(0x1c, "DLLCal", "",
        WavRWMux(in=dll_cal_en,     muxed=io.ana.dll_cal_en,   reg_reset=false.B, mux_reset=false.B, "dll_cal_en",   ""),
        WavRO   (io.ana.dll_cal_dat, "dll_cal_dat")),
      
      //-----------------------
      // Driver
      //-----------------------
      WavSWReg(0x20, "DriverCtrl", "",
        WavRWMux(in=drv_en,     muxed=io.ana.drv_en,   reg_reset=false.B, mux_reset=false.B, "drv_en",   ""),
        WavRW   (io.ana.drv_ctrl,       0.U,      "drv_ctrl",    ""),
        WavRW   (io.ana.drv_preemp,     0.U,      "drv_preemp",  "")),
      
      WavSWReg(0x24, "DriverBypass", "",
        WavRW   (io.ana.drv_bypass_sel,       0.U,      "drv_bypass_sel",    ""),
        WavRW   (io.ana.drv_bypass_out_p,     0.U,      "drv_bypass_out_p",  ""),
        WavRW   (io.ana.drv_bypass_out_n,     0.U,      "drv_bypass_out_n",  "")),
      
      //-----------------------
      // Receiver
      //-----------------------
      WavSWReg(0x28, "RcvrCtrl", "",
        WavRWMux(in=rcvr_en,            muxed=io.ana.rcvr_en,       reg_reset=false.B, mux_reset=false.B, "rcvr_en",   ""),
        WavRWMux(in=(~io.default_master),  muxed=io.ana.rcvr_clk_sel,  reg_reset=false.B, mux_reset=false.B, "rcvr_clk_sel",   ""),
        WavRW   (io.ana.rcvr_fb_en,       0.U,      "rcvr_fb_en",         ""),
        WavRW   (io.ana.rcvr_odt_dc_mode, 0.U,      "rcvr_odt_dc_mode",   ""),
        WavRW   (io.ana.rcvr_odt_ctrl,    0.U,      "rcvr_odt_ctrl",      ""),
        WavRW   (io.ana.rcvr_ac_mode,     0.U,      "rcvr_ac_mode",       "")),
      
      WavSWReg(0x2c, "DtstCtrl", "",
        WavRW   (io.ana.dtest_en,       0.U,      "dtest_en",       ""),
        WavRW   (io.ana.dtest_div,      0.U,      "dtest_div",      ""),
        WavRW   (io.ana.dtest_in,       0.U,      "dtest_in",       ""),
        WavRW   (io.ana.dtest_sel,      0.U,      "dtest_sel",      ""))
    )
    
  }
  
}



class WavD2DClkPIEncode()(implicit p: Parameters) extends Module with RequireAsyncReset{
  val io = IO(new Bundle{
    //From training SM
    val training_clk    = Input (Clock())
    val training_reset  = Input (AsyncReset())
    val training_oneup  = Input (Bool())
    val training_onedn  = Input (Bool())
    val training_steps  = Input (UInt(6.W))
    
    //From SW
    val swi_clk         = Input (Clock())
    val swi_reset       = Input (AsyncReset())
    val swi_oneup       = Input (Bool())
    val swi_onedn       = Input (Bool())
    
    val pi_bin          = Output(UInt(6.W))
    val pi_ctrl         = Output(UInt(16.W))
    val pi_quad         = Output(UInt(2.W))
  })
  
  
  val training_oneup_syncp = Module(new WavSyncPulse)
  training_oneup_syncp.io.clk_in        := io.training_clk
  training_oneup_syncp.io.clk_in_reset  := io.training_reset
  training_oneup_syncp.io.data_in       := io.training_oneup
  
  training_oneup_syncp.io.clk_out       := clock
  training_oneup_syncp.io.clk_out_reset := reset
  
  val training_onedn_syncp = Module(new WavSyncPulse)
  training_onedn_syncp.io.clk_in        := io.training_clk
  training_onedn_syncp.io.clk_in_reset  := io.training_reset
  training_onedn_syncp.io.data_in       := io.training_onedn
  
  training_onedn_syncp.io.clk_out       := clock
  training_onedn_syncp.io.clk_out_reset := reset
  
  
  val up_step_count = RegInit(0.U(6.W))
  up_step_count     := Mux(up_step_count =/= 0.U, up_step_count - 1.U, Mux(training_oneup_syncp.io.data_out, io.training_steps, 0.U))
  
  val dn_step_count = RegInit(0.U(6.W))
  dn_step_count     := Mux(dn_step_count =/= 0.U, dn_step_count - 1.U, Mux(training_onedn_syncp.io.data_out, io.training_steps, 0.U))
  
  
  val swi_oneup_syncp = Module(new WavSyncPulse)
  swi_oneup_syncp.io.clk_in        := io.swi_clk
  swi_oneup_syncp.io.clk_in_reset  := io.swi_reset
  swi_oneup_syncp.io.data_in       := io.swi_oneup
  
  swi_oneup_syncp.io.clk_out       := clock
  swi_oneup_syncp.io.clk_out_reset := reset
  
  val swi_onedn_syncp = Module(new WavSyncPulse)
  swi_onedn_syncp.io.clk_in        := io.swi_clk
  swi_onedn_syncp.io.clk_in_reset  := io.swi_reset
  swi_onedn_syncp.io.data_in       := io.swi_onedn
  
  swi_onedn_syncp.io.clk_out       := clock
  swi_onedn_syncp.io.clk_out_reset := reset
  
  
  val pi_encode = Module(new wav_pi_control_encode)
  pi_encode.io.clk      := clock
  pi_encode.io.reset    := reset
  pi_encode.io.oneup    := (up_step_count =/= 0.U) || swi_oneup_syncp.io.data_out
  pi_encode.io.onedown  := (dn_step_count =/= 0.U) || swi_onedn_syncp.io.data_out
  
  io.pi_bin     := pi_encode.io.pi_bin
  io.pi_quad    := pi_encode.io.pi_quad
  io.pi_ctrl    := pi_encode.io.pi_ctrl
  
  
  
}

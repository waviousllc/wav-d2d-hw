package wav.d2d


import wav.common._

import chisel3._
import chisel3.util._
import chisel3.experimental.{Analog}
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




/**
  *   TX Lane
  */

// class WavScanBundle(val numChains: Int = 1) extends Bundle{
//   val mode            = Input (Bool())
//   val asyncrst_ctrl   = Input (Bool())
//   val clk             = Input (Bool())
//   val shift           = Input (Bool())
//   val in              = Input (UInt(numChains.W))
//   val out             = Output(UInt(numChains.W))
//   
//   
//   def connectScan(b: WavScanBundle){
//     mode          := b.mode
//     asyncrst_ctrl := b.asyncrst_ctrl
//     clk           := b.clk
//     in            := b.in
//     shift         := b.shift
//     dontTouch(out)
//     dontTouch(b.out)
//   }
// }

class WavD2DTxCoreBundle(val dataWidth : Int = 16) extends Bundle{
  val tx_en       = Input (Bool())
  val tx_reset    = Input (Bool())
  val tx_td       = Input (UInt(dataWidth.W))
}

class WavD2DTxCoreBistBundle extends Bundle{
  val tx_bist_en      = Input (Bool())
  val tx_bist_mode    = Input (UInt(4.W))
}

class WavD2DTxAnalogBundle(val dataWidth : Int = 16) extends Bundle{
  val clk_div16      = Input (Bool())
  val dly_ctrl       = Output(UInt(6.W))
  val dly_gear       = Output(Bool())
  val drv_imp        = Output(UInt(4.W))
  val drv_preem      = Output(UInt(3.W))
  val en             = Output(Bool())
  val highz          = Output(Bool())
  val preemp_sec_dly = Output(UInt(4.W))
  val preemp_sec_en  = Output(UInt(3.W))
  val ser_lpb_en     = Output(Bool())
  val serdes_byp_out = Output(Bool())
  val serdes_byp_sel = Output(Bool())
  val td             = Output(UInt(dataWidth.W))
}


/**
  *   Analog BlackBox wrapper
  */
class wav_d2d_tx_ana extends BlackBox{
  val io = IO(new Bundle{
    
    //Goes to digital
    val tx  = Flipped(new WavD2DTxAnalogBundle(16))
    
    val tx_clk_div16_in   = Input (Bool())
    val tx_clk_div2_in    = Input (Bool())
    val tx_clkb_div2_in   = Input (Bool())
    val tx_clk_div4_in    = Input (Bool())
    val tx_clk_div8_in    = Input (Bool())
    
    //val tx_ser_lpb        = Output(Bool())
    val tx_ser_lpb        = Analog(1.W)
    
    val pad_tx            = Output(Bool())
    
    val vdda              = Input (Bool())
    val vddq              = Input (Bool())
    val vss               = Input (Bool())
  })
}


class WavD2DTx(val dataWidth : Int = 16, val baseAddr: BigInt = 0x0)(implicit p: Parameters) extends LazyModule{

  val device = new SimpleDevice("wavd2dtx", Seq("wavious,d2dtx"))
  
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
      val core          = new WavD2DTxCoreBundle
      val core_bist     = new WavD2DTxCoreBistBundle
      val ana           = new WavD2DTxAnalogBundle
    })
    
    dontTouch(io.bsr)
    
    dontTouch(io.scan)
    dontTouch(io.core)
    dontTouch(io.ana)
    
    
    val tx_reset        = Wire(Bool())
    
    val tx_clk_scan     = WavClockMux (io.scan.mode,  io.scan.clk,    io.ana.clk_div16)
    val tx_clk_reset    = WavResetSync(tx_clk_scan,   tx_reset,       io.scan.asyncrst_ctrl)
    
    
    
    val bist_pattern_lo = Wire(UInt(32.W))
    val bist_pattern_hi = Wire(UInt(32.W))
    val bist_en_reg     = Wire(Bool())
    val bist_mode_reg   = Wire(UInt(4.W))
    val bist_sel        = Wire(Bool())
    val bist = withClockAndReset(tx_clk_scan.asClock, tx_clk_reset.asAsyncReset) {
      Module(new WavD2DBistTx(dataWidth))
    }
    bist.io.en        := Mux(bist_sel, bist_en_reg,   io.core_bist.tx_bist_en)
    bist.io.mode      := Mux(bist_sel, bist_mode_reg, io.core_bist.tx_bist_mode)
    bist.io.pattern   := Cat(bist_pattern_hi, bist_pattern_lo)
    
    withClockAndReset(tx_clk_scan.asClock, tx_clk_reset.asAsyncReset) {
      io.ana.td :=  RegNext(WavClockMux(WavDemetReset(bist.io.en), bist.io.dataout, io.core.tx_td), 0.U)
    }
    
    //BSRs
    //val tx_en_bsr     = WavBSR(1, io.bsr)
    //val tx_highz_bsr  = WavBSR(1, io.bsr)
    val tx_byp_out_bsr= WavBSR(1, io.bsr)
    
    tx_byp_out_bsr -> io.bsr.tdo
    
    //Registers
    node.regmap(     
      //-----------------------
      // General Control
      //-----------------------
      WavSWReg(0x0, "CoreOverride", "Overrides for core signals",
               WavRWMux(in=io.core.tx_en,                 muxed=io.ana.en,      reg_reset=false.B, mux_reset=false.B, "tx_en",          "Main TX enable",
                  corescan=Some(io.scan.mode, false.B), iddq=Some(io.iddq, false.B), highz=Some(io.highz, false.B), bscan=Some(io.bsr.bsr_mode, true.B)),
               WavRWMux(in=(~io.core.tx_en),              muxed=io.ana.highz,   reg_reset=false.B, mux_reset=false.B, "tx_highz",       "Tx Highz Control",
                  corescan=Some(io.scan.mode, true.B), iddq=Some(io.iddq, true.B), highz=Some(io.highz, true.B), bscan=Some(io.bsr.bsr_mode, false.B)),
               WavRWMux(in=io.core.tx_reset,              muxed=tx_reset,       reg_reset=false.B, mux_reset=false.B, "tx_reset",       "Main TX reset")),
      
      //-----------------------
      // Analog
      //-----------------------
      WavSWReg(0x4, "DelayCtrl", "",
               WavRW(io.ana.dly_ctrl,       0.U,      "tx_dly_ctrl",          "Analog delay setting"),
               WavRW(io.ana.dly_gear,       0.U,      "tx_dly_gear",          "Analog delay gear")),

      WavSWReg(0x8, "DrvCtrl", "",
               WavRW(io.ana.drv_imp,        0.U,      "tx_drv_imp",           "Driver impedance"),
               WavRW(io.ana.drv_preem,      0.U,      "tx_drv_preem",         "Driver pre-emphasis value"),
               WavRW(io.ana.preemp_sec_dly, 0.U,      "tx_preemp_sec_dly",    ""),
               WavRW(io.ana.preemp_sec_en,  0.U,      "tx_preemp_sec_en",     "")),
      
      //Block Serial Loopback during BSCAN as this could short the RX 
      WavSWReg(0xc, "SerLpbByp", "",
               WavRW(io.ana.ser_lpb_en,       0.U,      "tx_ser_lpb_en",          "1 - Serial Loopback enabled",
                  bscan=Some(io.bsr.bsr_mode, false.B)),
               WavRW(io.ana.serdes_byp_sel,   0.U,      "tx_serdes_byp_sel",      "1 - Enable TX bypass mode",
                  bscan=Some(io.bsr.bsr_mode, true.B)),
               WavRW(io.ana.serdes_byp_out,   0.U,      "tx_serdes_byp_out",      "Value for TX bypass", 
                  bflop=Some(tx_byp_out_bsr))),

      //-----------------------
      // BIST
      //-----------------------
      WavSWReg(0x10, "BistCtrlStatus", "",
               WavRW(bist_en_reg,      false.B,        "bist_en",          "Enables the Bist logic"),
               WavRW(bist.io.swreset,  false.B,        "bist_reset",       "Resets the BIST logic. This is a synchronous reset"),
               WavRW(bist_mode_reg,    0.U,            "bist_mode",        "Determines which BIST mode is operational"),
               WavRW(bist.io.err_inj,  false.B,        "bist_err_inject",  "On a rising edge of this register, one bit error is introduced on the BIST data"),
               WavRW(bist_sel,         false.B,        "bist_sel",         "1 - SW controlled. 0 - Hardware controlled")),

      WavSWReg(0x14, "BistPatternLo", "",
               WavRW(bist_pattern_lo,  "h01234567".U,  "bist_pattern_lo",  "BIST Pattern when set to pattern mode")),
      WavSWReg(0x18, "BistPatternHi", "",
               WavRW(bist_pattern_hi,  "hdeadbeef".U,  "bist_pattern_hi",  "BIST Pattern when set to pattern mode")),
      WavSWReg(0x1c, "BistSeed", "",
               WavRW(bist.io.seed,     "hffffffff".U,  "bist_seed",        "BIST Seed when set to PRBS mode"))        
    )
    
    
  }
  
  
}





/**
  *   This Config Mainly just disables the monitors
  */
class BaseXbarConfig extends Config((site, here, up) => {
  case MonitorsEnabled => false
})



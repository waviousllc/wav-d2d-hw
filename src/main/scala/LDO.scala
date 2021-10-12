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


class WavD2DLDOAnalogBundle extends Bundle{
  val byp            = Output(Bool())
  val ena            = Output(Bool())
  val highz          = Output(Bool())
  val lvl            = Output(UInt(6.W))
  val mode           = Output(UInt(8.W))
  val refsel         = Output(Bool())
}


class WavD2DLDOCoreBundle extends Bundle{
  val en              = Input (Bool())
}
//LDO enabling is 1-2us (probably worse case)

class WavD2DLDO(val baseAddr: BigInt = 0x0)(implicit p: Parameters) extends LazyModule{

  val device = new SimpleDevice("wavd2dldo", Seq("wavious,d2dldo"))
  
  val node = WavAPBRegisterNode(
    address = AddressSet.misaligned(baseAddr, 0x100),
    device  = device,
    //concurrency = 1, //make depending on apn (apb requires 1)
    beatBytes = 4)

  override lazy val module = new LazyModuleImp(this) with RequireAsyncReset{
    val iddq          = IO(Input(Bool()))
    val highz         = IO(Input(Bool()))
    val scan          = IO(new WavScanBundle)
    val dsr           = IO(new WavBSRBundle)
    val core          = IO(new WavD2DLDOCoreBundle)
    val ana           = IO(new WavD2DLDOAnalogBundle)
    
    val ldo_en_bsr    = WavBSR(1, dsr)
    val ldo_lvl_bsr   = WavBSR(ana.lvl.getWidth, dsr)
    
    node.regmap(     

      WavSWReg(0x0, "CTRL1", "",
        WavRWMux(in=core.en,                 muxed=ana.ena,      reg_reset=false.B, mux_reset=false.B, "ena",          "",
          corescan=Some(scan.mode, false.B), iddq=Some(iddq, false.B), highz=Some(highz, false.B), bflop=Some(ldo_en_bsr)),
        WavRW(ana.highz,       true.B,       "highz",        "",
          corescan=Some(scan.mode, false.B), iddq=Some(iddq, false.B), highz=Some(highz, true.B), bscan=Some(dsr.bsr_mode, false.B)),
        WavRW(ana.byp,         false.B,      "byp",          "",
          corescan=Some(scan.mode, false.B), iddq=Some(iddq, false.B), highz=Some(highz, false.B), bscan=Some(dsr.bsr_mode, false.B)),
        WavRW(ana.lvl,         50.U,         "lvl",          "",
          corescan=Some(scan.mode, 0.U), iddq=Some(iddq, 0.U), highz=Some(highz, 0.U), bflop=Some(ldo_lvl_bsr)),
        WavRW(ana.mode,        0.U,          "mode",         ""),
        WavRW(ana.refsel,      false.B,      "refsel",       "",
          corescan=Some(scan.mode, false.B), iddq=Some(iddq, false.B), highz=Some(highz, false.B), bscan=Some(dsr.bsr_mode, false.B)))     
    )

  }   
}

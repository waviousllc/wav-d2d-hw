package wav.wlink

import wav.common._
import wav.d2d._

import chisel3._
import chisel3.util._
import chisel3.experimental._
import chisel3.stage.ChiselStage

import freechips.rocketchip.amba._
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



case class WlinkPHYWaviousD2DParams(
  phyType       : (Parameters) => WlinkWaviousD2DPHY = (p: Parameters) => new WlinkWaviousD2DPHY()(p),
  numTxLanes    : Int = 1,
  numRxLanes    : Int = 1,
  baseAddr      : BigInt = 0x0,
  phyDataWidth  : Int = 16,
  phyVersion    : UInt = 1.U,
  phyVersionStr : String = "Wavious D2D",
  
  processSuffix : String = "gf12lpp"
  
) extends WlinkPHYBaseParams

class WlinkWaviousD2DUserBundle extends Bundle{
  val iddq            = Input (Bool())
  val highz           = Input (Bool())
  val dsr             = new WavBSRBundle
  val bsr             = new WavBSRBundle
  val dtst            = Output(Bool())
  val refclk_ana_in   = Input (Bool())
  val refclk_ana_out  = Output(Bool())
}

class WlinkWaviousD2DPHY()(implicit p: Parameters) extends WlinkPHYBase{
  
  val params  : WlinkPHYWaviousD2DParams = p(WlinkParamsKey).phyParams.asInstanceOf[WlinkPHYWaviousD2DParams]
  
  val d2d     = LazyModule(new WavD2D(numLanes=params.numTxLanes, //FIX!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                                      baseAddr=params.baseAddr, 
                                      phyDataWidth=params.phyDataWidth,
                                      processSuffix=params.processSuffix)(p))
  
  d2d.xbar.node    := node
  
  
  override lazy val module = new LazyModuleImp(this) with RequireAsyncReset{
    val scan      = IO(new WavScanBundle)
    val por_reset = IO(Input (Bool()))
    val link_tx   = IO(new WlinkPHYTxBundle(params.numTxLanes * params.phyDataWidth))
    val link_rx   = IO(new WlinkPHYRxBundle(params.numRxLanes * params.phyDataWidth))
    
    val pad       = IO(new WavD2DBumpBundle(params.numTxLanes))   //FIX!!!!!!!!!!!!!!!!!!!
    val user      = IO(new WlinkWaviousD2DUserBundle)    
    
    d2d.module.io.por_reset   := por_reset
    d2d.module.io.link_tx     <> link_tx
    d2d.module.io.link_rx     <> link_rx
    d2d.module.io.pad         <> pad
    d2d.module.io.scan.connectScan(scan)
    

    d2d.module.io.refclk_ana_in := user.refclk_ana_in
    user.refclk_ana_out         := d2d.module.io.refclk_ana_out
    
    d2d.module.io.bsr           <> user.bsr
    d2d.module.io.dsr           <> user.dsr
    user.dtst                   := d2d.module.io.dtst
    
    d2d.module.io.iddq          := user.iddq
    d2d.module.io.highz         := user.highz
  }
}

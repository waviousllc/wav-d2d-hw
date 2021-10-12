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


sealed trait WavRpllVersion
case object WavRpll4g  extends WavRpllVersion
case object WavRpll14g extends WavRpllVersion

class rpll_dig_top extends BlackBox{
  
  val io = IO(new Bundle{
    val core_scan_asyncrst_ctrl  = Input (Bool())
    val core_scan_clk            = Input (Bool())
    val core_scan_mode           = Input (Bool())
    val core_scan_in             = Input (Bool())
    val core_scan_out            = Output(Bool())
    
    val iddq_mode                = Input (Bool())
    val bscan_mode               = Input (Bool())
    val bscan_tck                = Input (Bool())
    val bscan_trst_n             = Input (Bool())
    val bscan_capturedr          = Input (Bool())
    val bscan_shiftdr            = Input (Bool())
    val bscan_updatedr           = Input (Bool())
    val bscan_tdi                = Input (Bool())
    val bscan_tdo                = Output(Bool())
    
    val apb_clk                  = Input (Bool())
    val apb_reset                = Input (Bool())
    val apb_psel                 = Input (Bool())
    val apb_penable              = Input (Bool())
    val apb_pwrite               = Input (Bool())
    val apb_pwdata               = Input (UInt(32.W))
    val apb_paddr                = Input (UInt(8.W))
    val apb_pslverr              = Output(Bool())
    val apb_pready               = Output(Bool())
    val apb_prdata               = Output(UInt(32.W))
    
    val core_reset               = Input (Bool())
    val core_ret                 = Input (Bool())
    val core_ready               = Output(Bool())
    val core_refclk              = Output(Bool())
    val core_interrupt           = Output(Bool())
    
    val rpll_bias_lvl            = Output(UInt(4.W))
    val rpll_bias_sel            = Output(Bool())
    val rpll_byp_clk_sel         = Output(Bool())
    val rpll_clk_div16           = Input (Bool())
    val rpll_cp_int_mode         = Output(Bool())
    val rpll_dbl_clk_sel         = Output(Bool())
    val rpll_dtest_sel           = Output(UInt(3.W))
    val rpll_ena                 = Output(Bool())
    val rpll_fbdiv_sel           = Output(UInt(9.W))
    val rpll_fbclk               = Input (Bool())
    val rpll_int_ctrl            = Output(UInt(5.W))
    val rpll_mode                = Output(UInt(8.W))
    val rpll_pfd_mode            = Output(UInt(2.W))
    val rpll_post_div_sel        = Output(UInt(2.W))
    val rpll_prop_c_ctrl         = Output(UInt(2.W))
    val rpll_prop_ctrl           = Output(UInt(5.W))
    val rpll_prop_r_ctrl         = Output(UInt(2.W))
    val rpll_refclk              = Input (Bool())
    val rpll_reset               = Output(Bool())
    val rpll_ret                 = Output(Bool())
    val rpll_sel_refclk_alt      = Output(Bool())
  })
  
}


class rpll_14g_ana(val includePG: Boolean = false) extends BlackBox{
  val io = IO(new Bundle{
    //------------------
    // Power/Grounds
    //------------------
    val vdda                      = if(includePG) Some(Input (Bool())) else None
    val vss                       = if(includePG) Some(Input (Bool())) else None
    
    //------------------
    // Analog
    //------------------
    val clk0                      = Output(Bool()) 
    val clk90                     = Output(Bool()) 
    val clk180                    = Output(Bool()) 
    val clk270                    = Output(Bool()) 
     
    val dtest_out                 = Output(Bool()) 
    
    val refclk                    = Input (Bool()) 
    val refclk_alt                = Input (Bool()) 
    
    //------------------
    // Digital Side    
    //------------------
    val clk_div16                 = Output(Bool())
    val fbclk                     = Output(Bool()) 
    val refclk_out                = Output(Bool()) 
    val bias_lvl                  = Input (UInt(4.W)) 
    val byp_clk_sel               = Input (Bool()) 
    val cp_int_mode               = Input (Bool()) 
    val dbl_clk_sel               = Input (Bool()) 
    val dtest_sel                 = Input (UInt(3.W)) 
    val ena                       = Input (Bool()) 
    val fbdiv_sel                 = Input (UInt(9.W)) 
    val int_ctrl                  = Input (UInt(5.W)) 
    val mode                      = Input (UInt(8.W)) 
    val pfd_mode                  = Input (UInt(2.W)) 
    val post_div_sel              = Input (UInt(2.W)) 
    val prop_c_ctrl               = Input (UInt(2.W)) 
    val prop_ctrl                 = Input (UInt(5.W)) 
    val prop_r_ctrl               = Input (UInt(2.W)) 
    val reset                     = Input (Bool()) 
    //val ret                       = Input (Bool()) 
    val sel_refclk_alt            = Input (Bool())
    
  })
}

class rpll_4g_ana(val includePG: Boolean = false) extends BlackBox{
  val io = IO(new Bundle{
    //------------------
    // Power/Grounds
    //------------------
    val vdda                      = if(includePG) Some(Input (Bool())) else None
    val vss                       = if(includePG) Some(Input (Bool())) else None
    
    //------------------
    // Analog
    //------------------
    val clk0                      = Output(Bool()) 
    val clk90                     = Output(Bool()) 
    val clk180                    = Output(Bool()) 
    val clk270                    = Output(Bool()) 
    
    val dtest_out                 = Output(Bool()) 
    
    val refclk                    = Input (Bool()) 
    val refclk_alt                = Input (Bool()) 
    
    //------------------
    // Digital Side    
    //------------------
    val clk_div16                 = Output(Bool()) 
    val fbclk                     = Output(Bool()) 
    val refclk_out                = Output(Bool()) 
    val bias_lvl                  = Input (UInt(4.W)) 
    val byp_clk_sel               = Input (Bool()) 
    val cp_int_mode               = Input (Bool()) 
    val dbl_clk_sel               = Input (Bool()) 
    val dtest_sel                 = Input (UInt(3.W)) 
    val ena                       = Input (Bool()) 
    val fbdiv_sel                 = Input (UInt(9.W)) 
    val int_ctrl                  = Input (UInt(5.W)) 
    val mode                      = Input (UInt(8.W)) 
    val pfd_mode                  = Input (UInt(2.W)) 
    val post_div_sel              = Input (UInt(2.W)) 
    val prop_c_ctrl               = Input (UInt(2.W)) 
    val prop_ctrl                 = Input (UInt(5.W)) 
    val prop_r_ctrl               = Input (UInt(2.W)) 
    val reset                     = Input (Bool())
    val ret                       = Input (Bool())  
    val sel_refclk_alt            = Input (Bool())
    
    
  })
}

class rpll_14g_ana_v2(val includePG: Boolean = false) extends BlackBox{
  val io = IO(new Bundle{
    //------------------
    // Power/Grounds
    //------------------
    val vdda                      = if(includePG) Some(Input (Bool())) else None
    val vss                       = if(includePG) Some(Input (Bool())) else None
    
    //------------------
    // Analog
    //------------------
    val clk0                      = Output(Bool()) 
    val clk90                     = Output(Bool()) 
    val clk180                    = Output(Bool()) 
    val clk270                    = Output(Bool()) 
    
    val dtest_out                 = Output(Bool()) 
    
    val refclk                    = Input (Bool()) 
    val refclk_alt                = Input (Bool()) 
    
    //------------------
    // Digital Side    
    //------------------
    val clk_div16                 = Output(Bool()) 
    val fbclk                     = Output(Bool()) 
    val refclk_out                = Output(Bool()) 
    val bias_lvl                  = Input (UInt(4.W)) 
    val byp_clk_sel               = Input (Bool()) 
    val cp_int_mode               = Input (Bool()) 
    val dbl_clk_sel               = Input (Bool()) 
    val dtest_sel                 = Input (UInt(3.W)) 
    val ena                       = Input (Bool()) 
    val fbdiv_sel                 = Input (UInt(9.W)) 
    val int_ctrl                  = Input (UInt(5.W)) 
    val mode                      = Input (UInt(8.W)) 
    val pfd_mode                  = Input (UInt(2.W)) 
    val post_div_sel              = Input (UInt(2.W)) 
    val prop_c_ctrl               = Input (UInt(2.W)) 
    val prop_ctrl                 = Input (UInt(5.W)) 
    val prop_r_ctrl               = Input (UInt(2.W)) 
    val reset                     = Input (Bool())
    val ret                       = Input (Bool())  
    val sel_refclk_alt            = Input (Bool())
    
    
  })
}


//class WavRpll14GAna extends RawModule{
class WavRpllAna(
  val version : WavRpllVersion = WavRpll14g,
  val includePG: Boolean = false  
) extends RawModule{
  val rpll = if(version==WavRpll14g) Module(new rpll_14g_ana_v2(includePG)) else Module(new rpll_4g_ana(includePG))
  
  val io = IO(new Bundle{
    //------------------
    // Power/Grounds
    //------------------
    val vdda                                  = if(includePG) Some(Input (Bool())) else None
    val vss                                   = if(includePG) Some(Input (Bool())) else None
    
    //------------------
    // Digital Side    
    //------------------
    val rpll    = Flipped(new WavRpllAnalogBundle)
    
    //------------------
    // Analog
    //------------------
    val clk0                                  = Output(Bool()) 
    val clk90                                 = Output(Bool()) 
    val clk180                                = Output(Bool()) 
    val clk270                                = Output(Bool()) 
    //val clk_div16                             = Output(Bool())  //are we using this right now?
    val dtest_out                             = Output(Bool()) 
    
    val refclk                                = Input (Bool()) 
    val refclk_alt                            = Input (Bool()) 
  })
  
  //Digital connection
  io.rpll.clk_div16       := rpll.io.clk_div16
  io.rpll.fbclk           <> rpll.io.fbclk         
  io.rpll.refclk_out      <> rpll.io.refclk_out    
  io.rpll.bias_lvl        <> rpll.io.bias_lvl      
  io.rpll.byp_clk_sel     <> rpll.io.byp_clk_sel   
  io.rpll.cp_int_mode     <> rpll.io.cp_int_mode   
  io.rpll.dbl_clk_sel     <> rpll.io.dbl_clk_sel   
  io.rpll.dtest_sel       <> rpll.io.dtest_sel     
  io.rpll.ena             <> rpll.io.ena           
  io.rpll.fbdiv_sel       <> rpll.io.fbdiv_sel     
  io.rpll.int_ctrl        <> rpll.io.int_ctrl      
  io.rpll.mode            <> rpll.io.mode          
  io.rpll.pfd_mode        <> rpll.io.pfd_mode      
  io.rpll.post_div_sel    <> rpll.io.post_div_sel  
  io.rpll.prop_c_ctrl     <> rpll.io.prop_c_ctrl   
  io.rpll.prop_ctrl       <> rpll.io.prop_ctrl     
  io.rpll.prop_r_ctrl     <> rpll.io.prop_r_ctrl   
  io.rpll.reset           <> rpll.io.reset
  io.rpll.ret             <> rpll.io.ret
  io.rpll.sel_refclk_alt  <> rpll.io.sel_refclk_alt
  
  io.clk0        <> rpll.io.clk0      
  io.clk90       <> rpll.io.clk90     
  io.clk180      <> rpll.io.clk180    
  io.clk270      <> rpll.io.clk270    
  //io.clk_div16   <> rpll.io.clk_div16 
  io.dtest_out   <> rpll.io.dtest_out 
  io.refclk      <> rpll.io.refclk    
  io.refclk_alt  <> rpll.io.refclk_alt
  
  if(includePG){
    rpll.io.vdda.get := io.vdda.get
    rpll.io.vss.get  := io.vss.get
  }
}


class WavRpllAnalogBundle extends Bundle{
  val clk_div16                             = Input (Bool()) 
  val fbclk                                 = Input (Bool()) 
  val refclk_out                            = Input (Bool()) 
  val bias_lvl                              = Output(UInt(4.W)) 
  val byp_clk_sel                           = Output(Bool()) 
  val cp_int_mode                           = Output(Bool()) 
  val dbl_clk_sel                           = Output(Bool()) 
  val dtest_sel                             = Output(UInt(3.W)) 
  val ena                                   = Output(Bool()) 
  val fbdiv_sel                             = Output(UInt(9.W)) 
  val int_ctrl                              = Output(UInt(5.W)) 
  val mode                                  = Output(UInt(8.W)) 
  val pfd_mode                              = Output(UInt(2.W)) 
  val post_div_sel                          = Output(UInt(2.W)) 
  val prop_c_ctrl                           = Output(UInt(2.W)) 
  val prop_ctrl                             = Output(UInt(5.W)) 
  val prop_r_ctrl                           = Output(UInt(2.W)) 
  val reset                                 = Output(Bool()) 
  val ret                                   = Output(Bool()) 
  val sel_refclk_alt                        = Output(Bool())
}

class WavRpllCoreBundle extends Bundle{
  val reset     = Input (Bool())
  val ret       = Input (Bool())
  val ready     = Output(Bool())
  val interrupt = Output(Bool())
}


/**
  *   Digital Only
  */
class WavRpll(val baseAddr: BigInt = 0x0, val noRegTest: Boolean = false)(implicit p: Parameters) extends LazyModule{

  val apb = APBSlaveNode(portParams = Seq(APBSlavePortParameters(slaves = Seq(APBSlaveParameters(address = AddressSet.misaligned(baseAddr, 0x100))), beatBytes = 4)))
  
  
  
  override lazy val module = new LazyModuleImp(this) with RequireAsyncReset{
    
    WavRegAnnos.addNonChiselRegFile(baseAddr, "SYS:${RPLL}/rtl/regs/rpll.blk", noRegTest)
    
    val io = IO(new Bundle{
      val scan          = new WavScanBundle
      val iddq          = Input (Bool())
      val dsr           = new WavBSRBundle
      val core          = new WavRpllCoreBundle
      val refclk        = Output(Bool())          //Refclk is different to detach from core interface
      val ana           = new WavRpllAnalogBundle
    })
    
    
    val rpll_dig        = Module(new rpll_dig_top)
    
    rpll_dig.io.core_scan_asyncrst_ctrl := io.scan.asyncrst_ctrl
    rpll_dig.io.core_scan_clk           := io.scan.clk
    rpll_dig.io.core_scan_mode          := io.scan.mode
    rpll_dig.io.core_scan_in            := io.scan.in
    io.scan.out                         := rpll_dig.io.core_scan_out

    //TEMP until we figure out the best way to do our JTAG 
    rpll_dig.io.iddq_mode               := io.iddq 
    rpll_dig.io.bscan_mode              := io.dsr.bsr_mode
    rpll_dig.io.bscan_tck               := io.dsr.tck
    rpll_dig.io.bscan_trst_n            := io.dsr.trst_n
    rpll_dig.io.bscan_capturedr         := io.dsr.capture
    rpll_dig.io.bscan_shiftdr           := io.dsr.shift
    rpll_dig.io.bscan_updatedr          := io.dsr.update
    rpll_dig.io.bscan_tdi               := io.dsr.tdi
    io.dsr.tdo                          := rpll_dig.io.bscan_tdo
    
    val apb_port  = apb.in.head._1
    rpll_dig.io.apb_clk                 := clock.asBool
    rpll_dig.io.apb_reset               := reset.asBool
    rpll_dig.io.apb_psel                := apb_port.psel
    rpll_dig.io.apb_penable             := apb_port.penable
    rpll_dig.io.apb_pwrite              := apb_port.pwrite
    rpll_dig.io.apb_pwdata              := apb_port.pwdata
    rpll_dig.io.apb_paddr               := apb_port.paddr
    apb_port.prdata                     := rpll_dig.io.apb_prdata
    apb_port.pready                     := rpll_dig.io.apb_pready
    apb_port.pslverr                    := rpll_dig.io.apb_pslverr
    
    
    rpll_dig.io.core_reset              := io.core.reset
    rpll_dig.io.core_ret                := io.core.ret
    io.core.ready                       := rpll_dig.io.core_ready
    io.refclk                           := rpll_dig.io.core_refclk
    io.core.interrupt                   := rpll_dig.io.core_interrupt
    
    rpll_dig.io.rpll_bias_lvl           <> io.ana.bias_lvl      
    //rpll_dig.io.rpll_bias_sel           <> io.ana.bias_sel      
    rpll_dig.io.rpll_byp_clk_sel        <> io.ana.byp_clk_sel   
    rpll_dig.io.rpll_clk_div16          <> io.ana.clk_div16
    rpll_dig.io.rpll_cp_int_mode        <> io.ana.cp_int_mode   
    rpll_dig.io.rpll_dbl_clk_sel        <> io.ana.dbl_clk_sel   
    rpll_dig.io.rpll_dtest_sel          <> io.ana.dtest_sel     
    rpll_dig.io.rpll_ena                <> io.ana.ena           
    rpll_dig.io.rpll_fbdiv_sel          <> io.ana.fbdiv_sel     
    rpll_dig.io.rpll_fbclk              <> io.ana.fbclk         
    rpll_dig.io.rpll_int_ctrl           <> io.ana.int_ctrl      
    rpll_dig.io.rpll_mode               <> io.ana.mode          
    rpll_dig.io.rpll_pfd_mode           <> io.ana.pfd_mode      
    rpll_dig.io.rpll_post_div_sel       <> io.ana.post_div_sel  
    rpll_dig.io.rpll_prop_c_ctrl        <> io.ana.prop_c_ctrl   
    rpll_dig.io.rpll_prop_ctrl          <> io.ana.prop_ctrl     
    rpll_dig.io.rpll_prop_r_ctrl        <> io.ana.prop_r_ctrl   
    rpll_dig.io.rpll_refclk             := io.ana.refclk_out        
    rpll_dig.io.rpll_reset              <> io.ana.reset         
    rpll_dig.io.rpll_ret                <> io.ana.ret
    rpll_dig.io.rpll_sel_refclk_alt     <> io.ana.sel_refclk_alt
  }
  
}

class WavRpllWrapper(
  val baseAddr: BigInt = 0x0,
  val version : WavRpllVersion = WavRpll4g,
  val includePG: Boolean = false,
  val noRegTest: Boolean = false
)(implicit p: Parameters) extends LazyModule{
  val node = APBIdentityNode()
  
  val rpll_dig = LazyModule(new WavRpll(baseAddr, noRegTest))
  
  rpll_dig.apb := node
  
  lazy val module = new LazyModuleImp(this) with RequireAsyncReset{
    val io = IO(new Bundle{
      val scan          = new WavScanBundle
      val iddq          = Input (Bool())
      val dsr           = new WavBSRBundle
      
      val core          = new WavRpllCoreBundle
      val refclk        = Output(Bool())          
      
      val clk0          = Output(Bool()) 
      val clk90         = Output(Bool()) 
      val clk180        = Output(Bool()) 
      val clk270        = Output(Bool()) 
      //val clk_div16     = Output(Bool())  //are we using this right now?
      val dtest_out     = Output(Bool()) 

      val refclk_in     = Input (Bool()) 
      
      //------------------
      // Power/Grounds
      //------------------
      val vdda          = if(includePG) Some(Input (Bool())) else None
      val vss           = if(includePG) Some(Input (Bool())) else None
    })
    
    val rpll_ana = Module(new WavRpllAna(version, includePG))
    
    io.scan     <> rpll_dig.module.io.scan
    io.core     <> rpll_dig.module.io.core
    io.refclk   := rpll_dig.module.io.refclk
    
    io.dsr      <> rpll_dig.module.io.dsr
    rpll_dig.module.io.iddq := io.iddq
    
    rpll_dig.module.io.ana <> rpll_ana.io.rpll
    
    
    rpll_ana.io.refclk_alt  := false.B
    rpll_ana.io.refclk      := io.refclk_in
    
    io.clk0                 := rpll_ana.io.clk0
    io.clk90                := rpll_ana.io.clk90
    io.clk180               := rpll_ana.io.clk180
    io.clk270               := rpll_ana.io.clk270
    
    io.dtest_out            := rpll_ana.io.dtest_out
    
    if(includePG){
      rpll_ana.io.vdda.get  := io.vdda.get
      rpll_ana.io.vss.get   := io.vss.get
    }
  }
  
}

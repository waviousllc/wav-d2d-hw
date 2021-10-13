//===================================================================
//
// Created by sbridges on August/20/2021 at 14:56:55
//
// rpll_regs_regs_top.v
//
//===================================================================



module rpll_regs_regs_top #(
  parameter    ADDR_WIDTH = 8
)(
  //CORE_OVERRIDES
  input  wire         core_reset,
  output wire         swi_core_reset_muxed,
  input  wire         core_ready_ov,
  output wire         swi_core_ready_ov_muxed,
  input  wire         core_ret,
  output wire         swi_core_ret_muxed,
  //CORE_STATUS
  input  wire         core_ready,
  input  wire         core_fastlock_ready,
  input  wire         freq_detect_lock,
  input  wire [16:0]  freq_detect_cycles,
  input  wire [3:0]   fsm_state,
  //CORE_STATUS_INT
  input  wire         w1c_in_core_ready_int,
  output wire         w1c_out_core_ready_int,
  input  wire         w1c_in_core_loss_lock_int,
  output wire         w1c_out_core_loss_lock_int,
  input  wire         w1c_in_retention_exit_to_int,
  output wire         w1c_out_retention_exit_to_int,
  output wire         swi_core_ready_int_en,
  output wire         swi_core_loss_lock_int_en,
  output wire         swi_retention_exit_to_int_en,
  //INT_FRAC_SETTINGS
  output wire [8:0]   swi_vco_int,
  output wire [15:0]  swi_vco_frac,
  output wire [1:0]   swi_post_div_sel,
  //SSC_CONTROLS
  output wire         swi_ssc_enable,
  output wire [9:0]   swi_ssc_stepsize,
  output wire [16:0]  swi_ssc_amp,
  output wire         swi_ssc_count_cycles,
  output wire         swi_ssc_center_spread,
  //RETENTION_STATE_CONTROL
  output wire [15:0]  swi_ret_per_training_wait,
  output wire [7:0]   swi_ret_per_training_time,
  //RETENTION_EXIT_SETTINGS
  output wire [15:0]  swi_ret_exit_timeout,
  //RETENTION_LOCK_SETTINGS
  output wire [7:0]   swi_ret_lock_refclk_cycles,
  output wire [15:0]  swi_ret_lock_div16_cycles,
  output wire [7:0]   swi_ret_lock_div16_range,
  //RETENTION_LOCK_SETTINGS2
  input  wire         ret_lock_det_en,
  output wire         swi_ret_lock_det_en_muxed,
  input  wire         ret_lock_det_locked,
  input  wire [15:0]  ret_lock_cycles,
  //STATE_MACHINE_CONTROLS
  output wire [7:0]   swi_bias_settle_count,
  output wire [7:0]   swi_pre_locking_count,
  output wire         swi_disable_lock_det_after_lock,
  //PROP_GAINS
  output wire [4:0]   swi_normal_prop_gain,
  //INTR_GAINS
  output wire [4:0]   swi_normal_int_gain,
  //INTR_PROP_FL_GAINS
  output wire [4:0]   swi_fl_int_gain,
  output wire [4:0]   swi_fl_prop_gain,
  //INTR_PROP_GAINS_OVERRIDE
  input  wire [4:0]   int_gain,
  output wire [4:0]   swi_int_gain_muxed,
  input  wire [4:0]   prop_gain,
  output wire [4:0]   swi_prop_gain_muxed,
  //LOCK_DET_SETTINGS
  output wire [15:0]  swi_ld_refclk_cycles,
  output wire [5:0]   swi_ld_range,
  //FASTLOCK_DET_SETTINGS
  output wire [15:0]  swi_fastld_refclk_cycles,
  output wire [5:0]   swi_fastld_range,
  //ANALOG_EN_RESET
  input  wire         pll_en,
  output wire         swi_pll_en_muxed,
  input  wire         pll_reset,
  output wire         swi_pll_reset_muxed,
  input  wire         pll_ret,
  output wire         swi_pll_ret_muxed,
  input  wire [8:0]   fbdiv_sel,
  output wire [8:0]   swi_fbdiv_sel_muxed,
  //MODE_DTST_MISC
  output wire [3:0]   swi_bias_lvl,
  output wire         swi_cp_int_mode,
  input  wire         en_lock_det,
  output wire         swi_en_lock_det_muxed,
  output wire [2:0]   swi_dtest_sel,
  output wire [7:0]   swi_mode_extra,
  output wire         swi_byp_clk_sel,
  output wire         swi_dbl_clk_sel,
  output wire         swi_bias_sel,
  //PROP_CTRLS
  output wire [1:0]   swi_prop_c_ctrl,
  output wire [1:0]   swi_prop_r_ctrl,
  //REFCLK_CONTROLS
  output wire [1:0]   swi_pfd_mode,
  output wire         swi_sel_refclk_alt,
  //DEBUG_BUS_STATUS
  output reg  [31:0]  debug_bus_ctrl_status,

  //DFT Ports (if used)
  input  wire dft_core_scan_mode,
  input  wire dft_iddq_mode,
  input  wire dft_hiz_mode,
  input  wire dft_bscan_mode,
  // BSCAN Shift Interface
  input  wire dft_bscan_tck,
  input  wire dft_bscan_trst_n,
  input  wire dft_bscan_capturedr,
  input  wire dft_bscan_shiftdr,
  input  wire dft_bscan_updatedr,
  input  wire dft_bscan_tdi,
  output wire dft_bscan_tdo,     //Assigned to last in chain
  
  // APB Interface
  input  wire RegReset,
  input  wire RegClk,
  input  wire PSEL,
  input  wire PENABLE,
  input  wire PWRITE,
  output wire PSLVERR,
  output wire PREADY,
  input  wire [(ADDR_WIDTH-1):0] PADDR,
  input  wire [31:0] PWDATA,
  output wire [31:0] PRDATA
);
  
  //DFT Tieoffs (if not used)

  //APB Setup/Access 
  wire [(ADDR_WIDTH-1):0] RegAddr_in;
  reg  [(ADDR_WIDTH-1):0] RegAddr;
  wire [31:0] RegWrData_in;
  reg  [31:0] RegWrData;
  wire RegWrEn_in;
  reg  RegWrEn_pq;
  wire RegWrEn;

  assign RegAddr_in = PSEL ? PADDR : RegAddr; 

  always @(posedge RegClk or posedge RegReset) begin
    if (RegReset) begin
      RegAddr <= {(ADDR_WIDTH){1'b0}};
    end else begin
      RegAddr <= RegAddr_in;
    end
  end

  assign RegWrData_in = PSEL ? PWDATA : RegWrData; 

  always @(posedge RegClk or posedge RegReset) begin
    if (RegReset) begin
      RegWrData <= 32'h00000000;
    end else begin
      RegWrData <= RegWrData_in;
    end
  end

  assign RegWrEn_in = PSEL & PWRITE;

  always @(posedge RegClk or posedge RegReset) begin
    if (RegReset) begin
      RegWrEn_pq <= 1'b0;
    end else begin
      RegWrEn_pq <= RegWrEn_in;
    end
  end

  assign RegWrEn = RegWrEn_pq & PENABLE;
  
  //assign PSLVERR = 1'b0;
  assign PREADY  = 1'b1;
  


  //Regs for Mux Override sel
  reg  reg_core_reset_mux;
  reg  reg_core_ready_ov_mux;
  reg  reg_core_ret_mux;
  reg  reg_ret_lock_det_en_mux;
  reg  reg_int_gain_mux;
  reg  reg_prop_gain_mux;
  reg  reg_pll_en_mux;
  reg  reg_pll_reset_mux;
  reg  reg_pll_ret_mux;
  reg  reg_fbdiv_sel_mux;
  reg  reg_en_lock_det_mux;



  //---------------------------
  // CORE_OVERRIDES
  // core_reset - Main PLL Reset
  // core_reset_mux - 1 - Use register value, 0 - use logic
  // core_ready_ov - Override for core_ready (sims/debug)
  // core_ready_ov_mux - 1 - Use register value, 0 - use logic
  // core_ret - Enable PLL retention mode (this is not power gating retention)
  // core_ret_mux - 1 - Use register value, 0 - use logic
  //---------------------------
  wire [31:0] CORE_OVERRIDES_reg_read;
  reg          reg_core_reset;
  reg          reg_core_ready_ov;
  reg          reg_core_ret;

  always @(posedge RegClk or posedge RegReset) begin
    if(RegReset) begin
      reg_core_reset                         <= 1'h0;
      reg_core_reset_mux                     <= 1'h0;
      reg_core_ready_ov                      <= 1'h0;
      reg_core_ready_ov_mux                  <= 1'h0;
      reg_core_ret                           <= 1'h0;
      reg_core_ret_mux                       <= 1'h0;
    end else if(RegAddr == 'h0 && RegWrEn) begin
      reg_core_reset                         <= RegWrData[0];
      reg_core_reset_mux                     <= RegWrData[1];
      reg_core_ready_ov                      <= RegWrData[2];
      reg_core_ready_ov_mux                  <= RegWrData[3];
      reg_core_ret                           <= RegWrData[4];
      reg_core_ret_mux                       <= RegWrData[5];
    end else begin
      reg_core_reset                         <= reg_core_reset;
      reg_core_reset_mux                     <= reg_core_reset_mux;
      reg_core_ready_ov                      <= reg_core_ready_ov;
      reg_core_ready_ov_mux                  <= reg_core_ready_ov_mux;
      reg_core_ret                           <= reg_core_ret;
      reg_core_ret_mux                       <= reg_core_ret_mux;
    end
  end

  assign CORE_OVERRIDES_reg_read = {26'h0,
          reg_core_ret_mux,
          reg_core_ret,
          reg_core_ready_ov_mux,
          reg_core_ready_ov,
          reg_core_reset_mux,
          reg_core_reset};

  //-----------------------

  wire        swi_core_reset_muxed_pre;
  wav_clock_mux u_wav_clock_mux_core_reset (
    .clk0    ( core_reset                         ),              
    .clk1    ( reg_core_reset                     ),              
    .sel     ( reg_core_reset_mux                 ),      
    .clk_out ( swi_core_reset_muxed_pre           )); 

  assign swi_core_reset_muxed = swi_core_reset_muxed_pre;

  //-----------------------
  //-----------------------

  wire        swi_core_ready_ov_muxed_pre;
  wav_clock_mux u_wav_clock_mux_core_ready_ov (
    .clk0    ( core_ready_ov                      ),              
    .clk1    ( reg_core_ready_ov                  ),              
    .sel     ( reg_core_ready_ov_mux              ),      
    .clk_out ( swi_core_ready_ov_muxed_pre        )); 

  assign swi_core_ready_ov_muxed = swi_core_ready_ov_muxed_pre;

  //-----------------------
  //-----------------------

  wire        swi_core_ret_muxed_pre;
  wav_clock_mux u_wav_clock_mux_core_ret (
    .clk0    ( core_ret                           ),              
    .clk1    ( reg_core_ret                       ),              
    .sel     ( reg_core_ret_mux                   ),      
    .clk_out ( swi_core_ret_muxed_pre             )); 

  assign swi_core_ret_muxed = swi_core_ret_muxed_pre;

  //-----------------------




  //---------------------------
  // CORE_STATUS
  // core_ready - 1 - PLL is locked and ready to be used
  // core_fastlock_ready - 1 - PLL has completed fast lock
  // freq_detect_lock - Status of the freq detection circuit
  // freq_detect_cycles - Current FB cycles from freq detection circuit
  // fsm_state - FSM State
  //---------------------------
  wire [31:0] CORE_STATUS_reg_read;
  assign CORE_STATUS_reg_read = {8'h0,
          fsm_state,
          freq_detect_cycles,
          freq_detect_lock,
          core_fastlock_ready,
          core_ready};

  //-----------------------
  //-----------------------
  //-----------------------
  //-----------------------
  //-----------------------




  //---------------------------
  // CORE_STATUS_INT
  // core_ready_int - Asserts when core_ready asserts
  // core_loss_lock_int - Asserts when loss of lock is seen
  // retention_exit_to_int - Asserts when retention mode does not exit within programmed time
  // reserved0 - 
  // core_ready_int_en - 1 - Enable core_ready_int interrupt
  // core_loss_lock_int_en - 1 - Enable core_loss_lock_int interrupt
  // retention_exit_to_int_en - 1 - Enable retention_exit_to_int interrupt
  //---------------------------
  wire [31:0] CORE_STATUS_INT_reg_read;
  reg          reg_w1c_core_ready_int;
  wire         reg_w1c_in_core_ready_int_ff2;
  reg          reg_w1c_in_core_ready_int_ff3;
  reg          reg_w1c_core_loss_lock_int;
  wire         reg_w1c_in_core_loss_lock_int_ff2;
  reg          reg_w1c_in_core_loss_lock_int_ff3;
  reg          reg_w1c_retention_exit_to_int;
  wire         reg_w1c_in_retention_exit_to_int_ff2;
  reg          reg_w1c_in_retention_exit_to_int_ff3;
  reg         reg_core_ready_int_en;
  reg         reg_core_loss_lock_int_en;
  reg         reg_retention_exit_to_int_en;

  always @(posedge RegClk or posedge RegReset) begin
    if(RegReset) begin
      reg_core_ready_int_en                  <= 1'h1;
      reg_core_loss_lock_int_en              <= 1'h1;
      reg_retention_exit_to_int_en           <= 1'h1;
    end else if(RegAddr == 'h8 && RegWrEn) begin
      reg_core_ready_int_en                  <= RegWrData[9];
      reg_core_loss_lock_int_en              <= RegWrData[10];
      reg_retention_exit_to_int_en           <= RegWrData[11];
    end else begin
      reg_core_ready_int_en                  <= reg_core_ready_int_en;
      reg_core_loss_lock_int_en              <= reg_core_loss_lock_int_en;
      reg_retention_exit_to_int_en           <= reg_retention_exit_to_int_en;
    end
  end


  // core_ready_int W1C Logic
  always @(posedge RegClk or posedge RegReset) begin
    if(RegReset) begin
      reg_w1c_core_ready_int                    <= 1'h0;
      reg_w1c_in_core_ready_int_ff3             <= 1'h0;
    end else begin
      reg_w1c_core_ready_int                    <= RegWrData[0] && reg_w1c_core_ready_int && (RegAddr == 'h8) && RegWrEn ? 1'b0 : (reg_w1c_in_core_ready_int_ff2 & ~reg_w1c_in_core_ready_int_ff3 ? 1'b1 : reg_w1c_core_ready_int);
      reg_w1c_in_core_ready_int_ff3             <= reg_w1c_in_core_ready_int_ff2;
    end
  end

  demet_reset u_demet_reset_core_ready_int (
    .clk     ( RegClk                                     ),              
    .reset   ( RegReset                                   ),              
    .sig_in  ( w1c_in_core_ready_int                      ),            
    .sig_out ( reg_w1c_in_core_ready_int_ff2              )); 


  // core_loss_lock_int W1C Logic
  always @(posedge RegClk or posedge RegReset) begin
    if(RegReset) begin
      reg_w1c_core_loss_lock_int                <= 1'h0;
      reg_w1c_in_core_loss_lock_int_ff3         <= 1'h0;
    end else begin
      reg_w1c_core_loss_lock_int                <= RegWrData[1] && reg_w1c_core_loss_lock_int && (RegAddr == 'h8) && RegWrEn ? 1'b0 : (reg_w1c_in_core_loss_lock_int_ff2 & ~reg_w1c_in_core_loss_lock_int_ff3 ? 1'b1 : reg_w1c_core_loss_lock_int);
      reg_w1c_in_core_loss_lock_int_ff3         <= reg_w1c_in_core_loss_lock_int_ff2;
    end
  end

  demet_reset u_demet_reset_core_loss_lock_int (
    .clk     ( RegClk                                     ),              
    .reset   ( RegReset                                   ),              
    .sig_in  ( w1c_in_core_loss_lock_int                  ),            
    .sig_out ( reg_w1c_in_core_loss_lock_int_ff2          )); 


  // retention_exit_to_int W1C Logic
  always @(posedge RegClk or posedge RegReset) begin
    if(RegReset) begin
      reg_w1c_retention_exit_to_int             <= 1'h0;
      reg_w1c_in_retention_exit_to_int_ff3      <= 1'h0;
    end else begin
      reg_w1c_retention_exit_to_int             <= RegWrData[2] && reg_w1c_retention_exit_to_int && (RegAddr == 'h8) && RegWrEn ? 1'b0 : (reg_w1c_in_retention_exit_to_int_ff2 & ~reg_w1c_in_retention_exit_to_int_ff3 ? 1'b1 : reg_w1c_retention_exit_to_int);
      reg_w1c_in_retention_exit_to_int_ff3      <= reg_w1c_in_retention_exit_to_int_ff2;
    end
  end

  demet_reset u_demet_reset_retention_exit_to_int (
    .clk     ( RegClk                                     ),              
    .reset   ( RegReset                                   ),              
    .sig_in  ( w1c_in_retention_exit_to_int               ),            
    .sig_out ( reg_w1c_in_retention_exit_to_int_ff2       )); 

  assign CORE_STATUS_INT_reg_read = {20'h0,
          reg_retention_exit_to_int_en,
          reg_core_loss_lock_int_en,
          reg_core_ready_int_en,
          6'd0, //Reserved
          reg_w1c_retention_exit_to_int,
          reg_w1c_core_loss_lock_int,
          reg_w1c_core_ready_int};

  //-----------------------
  assign w1c_out_core_ready_int = reg_w1c_core_ready_int;
  //-----------------------
  assign w1c_out_core_loss_lock_int = reg_w1c_core_loss_lock_int;
  //-----------------------
  assign w1c_out_retention_exit_to_int = reg_w1c_retention_exit_to_int;
  //-----------------------
  //-----------------------
  assign swi_core_ready_int_en = reg_core_ready_int_en;

  //-----------------------
  assign swi_core_loss_lock_int_en = reg_core_loss_lock_int_en;

  //-----------------------
  assign swi_retention_exit_to_int_en = reg_retention_exit_to_int_en;





  //---------------------------
  // INT_FRAC_SETTINGS
  // vco_int - Integer value of feedback divider
  // vco_frac - Fractional value of feedback divider      
  // post_div_sel - Post Divider 00 - No Div, 01 - Div2, 10 - Div4, 11 - Div8   
  //---------------------------
  wire [31:0] INT_FRAC_SETTINGS_reg_read;
  reg [8:0]   reg_vco_int;
  reg [15:0]  reg_vco_frac;
  reg [1:0]   reg_post_div_sel;

  always @(posedge RegClk or posedge RegReset) begin
    if(RegReset) begin
      reg_vco_int                            <= 9'h1a;
      reg_vco_frac                           <= 16'h0;
      reg_post_div_sel                       <= 2'h0;
    end else if(RegAddr == 'hc && RegWrEn) begin
      reg_vco_int                            <= RegWrData[8:0];
      reg_vco_frac                           <= RegWrData[24:9];
      reg_post_div_sel                       <= RegWrData[26:25];
    end else begin
      reg_vco_int                            <= reg_vco_int;
      reg_vco_frac                           <= reg_vco_frac;
      reg_post_div_sel                       <= reg_post_div_sel;
    end
  end

  assign INT_FRAC_SETTINGS_reg_read = {5'h0,
          reg_post_div_sel,
          reg_vco_frac,
          reg_vco_int};

  //-----------------------
  assign swi_vco_int = reg_vco_int;

  //-----------------------
  assign swi_vco_frac = reg_vco_frac;

  //-----------------------
  wire [1:0] post_div_sel_tdo;


  wire [1:0] post_div_sel_bscan_flop_po;
  rpll_regs_jtag_bsr u_rpll_regs_jtag_bsr_post_div_sel[1:0] (   
    .tck        ( dft_bscan_tck                      ),          
    .trst_n     ( dft_bscan_trst_n                   ),      
    .bscan_mode ( dft_bscan_mode                     ),
    .capturedr  ( dft_bscan_capturedr                ),
    .shiftdr    ( dft_bscan_shiftdr                  ),          
    .updatedr   ( dft_bscan_updatedr                 ),               
    .pi         ( reg_post_div_sel                   ),               
    .po         ( post_div_sel_bscan_flop_po         ),               
    .tdi        ( {dft_bscan_tdi,
                   post_div_sel_tdo[1]}     ),                
    .tdo        ( {post_div_sel_tdo[1],
                   post_div_sel_tdo[0]}     )); 

  assign swi_post_div_sel = post_div_sel_bscan_flop_po;





  //---------------------------
  // SSC_CONTROLS
  // ssc_enable - 
  // ssc_stepsize - 
  // ssc_amp - 
  // ssc_count_cycles - 
  // ssc_center_spread - 
  //---------------------------
  wire [31:0] SSC_CONTROLS_reg_read;
  reg         reg_ssc_enable;
  reg [9:0]   reg_ssc_stepsize;
  reg [16:0]  reg_ssc_amp;
  reg         reg_ssc_count_cycles;
  reg         reg_ssc_center_spread;

  always @(posedge RegClk or posedge RegReset) begin
    if(RegReset) begin
      reg_ssc_enable                         <= 1'h0;
      reg_ssc_stepsize                       <= 10'h0;
      reg_ssc_amp                            <= 17'h0;
      reg_ssc_count_cycles                   <= 1'h0;
      reg_ssc_center_spread                  <= 1'h0;
    end else if(RegAddr == 'h10 && RegWrEn) begin
      reg_ssc_enable                         <= RegWrData[0];
      reg_ssc_stepsize                       <= RegWrData[10:1];
      reg_ssc_amp                            <= RegWrData[27:11];
      reg_ssc_count_cycles                   <= RegWrData[28];
      reg_ssc_center_spread                  <= RegWrData[29];
    end else begin
      reg_ssc_enable                         <= reg_ssc_enable;
      reg_ssc_stepsize                       <= reg_ssc_stepsize;
      reg_ssc_amp                            <= reg_ssc_amp;
      reg_ssc_count_cycles                   <= reg_ssc_count_cycles;
      reg_ssc_center_spread                  <= reg_ssc_center_spread;
    end
  end

  assign SSC_CONTROLS_reg_read = {2'h0,
          reg_ssc_center_spread,
          reg_ssc_count_cycles,
          reg_ssc_amp,
          reg_ssc_stepsize,
          reg_ssc_enable};

  //-----------------------
  assign swi_ssc_enable = reg_ssc_enable;

  //-----------------------
  assign swi_ssc_stepsize = reg_ssc_stepsize;

  //-----------------------
  assign swi_ssc_amp = reg_ssc_amp;

  //-----------------------
  assign swi_ssc_count_cycles = reg_ssc_count_cycles;

  //-----------------------
  assign swi_ssc_center_spread = reg_ssc_center_spread;





  //---------------------------
  // RETENTION_STATE_CONTROL
  // ret_per_training_wait - Number of cycles to wait between periodic training while in retention mode. 0 indicates disabled
  // ret_per_training_time - Number of cycles to run periodic training in retention mode
  //---------------------------
  wire [31:0] RETENTION_STATE_CONTROL_reg_read;
  reg [15:0]  reg_ret_per_training_wait;
  reg [7:0]   reg_ret_per_training_time;

  always @(posedge RegClk or posedge RegReset) begin
    if(RegReset) begin
      reg_ret_per_training_wait              <= 16'h7ff;
      reg_ret_per_training_time              <= 8'h3f;
    end else if(RegAddr == 'h14 && RegWrEn) begin
      reg_ret_per_training_wait              <= RegWrData[15:0];
      reg_ret_per_training_time              <= RegWrData[23:16];
    end else begin
      reg_ret_per_training_wait              <= reg_ret_per_training_wait;
      reg_ret_per_training_time              <= reg_ret_per_training_time;
    end
  end

  assign RETENTION_STATE_CONTROL_reg_read = {8'h0,
          reg_ret_per_training_time,
          reg_ret_per_training_wait};

  //-----------------------
  assign swi_ret_per_training_wait = reg_ret_per_training_wait;

  //-----------------------
  assign swi_ret_per_training_time = reg_ret_per_training_time;





  //---------------------------
  // RETENTION_EXIT_SETTINGS
  // ret_exit_timeout - If retention exit does not occur within this time, the PLL will self reset.
  //---------------------------
  wire [31:0] RETENTION_EXIT_SETTINGS_reg_read;
  reg [15:0]  reg_ret_exit_timeout;

  always @(posedge RegClk or posedge RegReset) begin
    if(RegReset) begin
      reg_ret_exit_timeout                   <= 16'hfff;
    end else if(RegAddr == 'h18 && RegWrEn) begin
      reg_ret_exit_timeout                   <= RegWrData[15:0];
    end else begin
      reg_ret_exit_timeout                   <= reg_ret_exit_timeout;
    end
  end

  assign RETENTION_EXIT_SETTINGS_reg_read = {16'h0,
          reg_ret_exit_timeout};

  //-----------------------
  assign swi_ret_exit_timeout = reg_ret_exit_timeout;





  //---------------------------
  // RETENTION_LOCK_SETTINGS
  // ret_lock_refclk_cycles - Number of refclk cycles to check for retention lock
  // ret_lock_div16_cycles - Number of div16 cycles to check for retention lock
  // ret_lock_div16_range - Range available for lock to be determined
  //---------------------------
  wire [31:0] RETENTION_LOCK_SETTINGS_reg_read;
  reg [7:0]   reg_ret_lock_refclk_cycles;
  reg [15:0]  reg_ret_lock_div16_cycles;
  reg [7:0]   reg_ret_lock_div16_range;

  always @(posedge RegClk or posedge RegReset) begin
    if(RegReset) begin
      reg_ret_lock_refclk_cycles             <= 8'h10;
      reg_ret_lock_div16_cycles              <= 16'h0;
      reg_ret_lock_div16_range               <= 8'h20;
    end else if(RegAddr == 'h1c && RegWrEn) begin
      reg_ret_lock_refclk_cycles             <= RegWrData[7:0];
      reg_ret_lock_div16_cycles              <= RegWrData[23:8];
      reg_ret_lock_div16_range               <= RegWrData[31:24];
    end else begin
      reg_ret_lock_refclk_cycles             <= reg_ret_lock_refclk_cycles;
      reg_ret_lock_div16_cycles              <= reg_ret_lock_div16_cycles;
      reg_ret_lock_div16_range               <= reg_ret_lock_div16_range;
    end
  end

  assign RETENTION_LOCK_SETTINGS_reg_read = {          reg_ret_lock_div16_range,
          reg_ret_lock_div16_cycles,
          reg_ret_lock_refclk_cycles};

  //-----------------------
  assign swi_ret_lock_refclk_cycles = reg_ret_lock_refclk_cycles;

  //-----------------------
  assign swi_ret_lock_div16_cycles = reg_ret_lock_div16_cycles;

  //-----------------------
  assign swi_ret_lock_div16_range = reg_ret_lock_div16_range;





  //---------------------------
  // RETENTION_LOCK_SETTINGS2
  // ret_lock_det_en - 
  // ret_lock_det_en_mux - 
  // ret_lock_det_locked - 
  // ret_lock_cycles - 
  //---------------------------
  wire [31:0] RETENTION_LOCK_SETTINGS2_reg_read;
  reg          reg_ret_lock_det_en;

  always @(posedge RegClk or posedge RegReset) begin
    if(RegReset) begin
      reg_ret_lock_det_en                    <= 1'h0;
      reg_ret_lock_det_en_mux                <= 1'h0;
    end else if(RegAddr == 'h20 && RegWrEn) begin
      reg_ret_lock_det_en                    <= RegWrData[0];
      reg_ret_lock_det_en_mux                <= RegWrData[1];
    end else begin
      reg_ret_lock_det_en                    <= reg_ret_lock_det_en;
      reg_ret_lock_det_en_mux                <= reg_ret_lock_det_en_mux;
    end
  end

  assign RETENTION_LOCK_SETTINGS2_reg_read = {13'h0,
          ret_lock_cycles,
          ret_lock_det_locked,
          reg_ret_lock_det_en_mux,
          reg_ret_lock_det_en};

  //-----------------------

  wire        swi_ret_lock_det_en_muxed_pre;
  wav_clock_mux u_wav_clock_mux_ret_lock_det_en (
    .clk0    ( ret_lock_det_en                    ),              
    .clk1    ( reg_ret_lock_det_en                ),              
    .sel     ( reg_ret_lock_det_en_mux            ),      
    .clk_out ( swi_ret_lock_det_en_muxed_pre      )); 

  assign swi_ret_lock_det_en_muxed = swi_ret_lock_det_en_muxed_pre;

  //-----------------------
  //-----------------------
  //-----------------------




  //---------------------------
  // STATE_MACHINE_CONTROLS
  // bias_settle_count - Number of refclk cycles to wait until entering the fastlock routine
  // pre_locking_count - Number of refclk cycles to wait until entering normal lock after fast lock
  // disable_lock_det_after_lock - 1 - Lock Detection circuit is disabled after lock is seen. 0 - Lock detection always enabled. Disabling lock detect would mean loss of lock is not possible to detect.
  //---------------------------
  wire [31:0] STATE_MACHINE_CONTROLS_reg_read;
  reg [7:0]   reg_bias_settle_count;
  reg [7:0]   reg_pre_locking_count;
  reg         reg_disable_lock_det_after_lock;

  always @(posedge RegClk or posedge RegReset) begin
    if(RegReset) begin
      reg_bias_settle_count                  <= 8'h8;
      reg_pre_locking_count                  <= 8'h4;
      reg_disable_lock_det_after_lock        <= 1'h0;
    end else if(RegAddr == 'h24 && RegWrEn) begin
      reg_bias_settle_count                  <= RegWrData[7:0];
      reg_pre_locking_count                  <= RegWrData[15:8];
      reg_disable_lock_det_after_lock        <= RegWrData[16];
    end else begin
      reg_bias_settle_count                  <= reg_bias_settle_count;
      reg_pre_locking_count                  <= reg_pre_locking_count;
      reg_disable_lock_det_after_lock        <= reg_disable_lock_det_after_lock;
    end
  end

  assign STATE_MACHINE_CONTROLS_reg_read = {15'h0,
          reg_disable_lock_det_after_lock,
          reg_pre_locking_count,
          reg_bias_settle_count};

  //-----------------------
  assign swi_bias_settle_count = reg_bias_settle_count;

  //-----------------------
  assign swi_pre_locking_count = reg_pre_locking_count;

  //-----------------------
  assign swi_disable_lock_det_after_lock = reg_disable_lock_det_after_lock;





  //---------------------------
  // PROP_GAINS
  // normal_prop_gain - Proportional Gain when not in fastlock
  //---------------------------
  wire [31:0] PROP_GAINS_reg_read;
  reg [4:0]   reg_normal_prop_gain;

  always @(posedge RegClk or posedge RegReset) begin
    if(RegReset) begin
      reg_normal_prop_gain                   <= 5'h1;
    end else if(RegAddr == 'h28 && RegWrEn) begin
      reg_normal_prop_gain                   <= RegWrData[4:0];
    end else begin
      reg_normal_prop_gain                   <= reg_normal_prop_gain;
    end
  end

  assign PROP_GAINS_reg_read = {27'h0,
          reg_normal_prop_gain};

  //-----------------------
  assign swi_normal_prop_gain = reg_normal_prop_gain;





  //---------------------------
  // INTR_GAINS
  // normal_int_gain - Integral Gain when not in fastlock
  //---------------------------
  wire [31:0] INTR_GAINS_reg_read;
  reg [4:0]   reg_normal_int_gain;

  always @(posedge RegClk or posedge RegReset) begin
    if(RegReset) begin
      reg_normal_int_gain                    <= 5'h4;
    end else if(RegAddr == 'h2c && RegWrEn) begin
      reg_normal_int_gain                    <= RegWrData[4:0];
    end else begin
      reg_normal_int_gain                    <= reg_normal_int_gain;
    end
  end

  assign INTR_GAINS_reg_read = {27'h0,
          reg_normal_int_gain};

  //-----------------------
  assign swi_normal_int_gain = reg_normal_int_gain;





  //---------------------------
  // INTR_PROP_FL_GAINS
  // fl_int_gain - Integral gain when in fastlock
  // fl_prop_gain - Proportional gain when in fastlock
  //---------------------------
  wire [31:0] INTR_PROP_FL_GAINS_reg_read;
  reg [4:0]   reg_fl_int_gain;
  reg [4:0]   reg_fl_prop_gain;

  always @(posedge RegClk or posedge RegReset) begin
    if(RegReset) begin
      reg_fl_int_gain                        <= 5'h1e;
      reg_fl_prop_gain                       <= 5'h1e;
    end else if(RegAddr == 'h30 && RegWrEn) begin
      reg_fl_int_gain                        <= RegWrData[4:0];
      reg_fl_prop_gain                       <= RegWrData[9:5];
    end else begin
      reg_fl_int_gain                        <= reg_fl_int_gain;
      reg_fl_prop_gain                       <= reg_fl_prop_gain;
    end
  end

  assign INTR_PROP_FL_GAINS_reg_read = {22'h0,
          reg_fl_prop_gain,
          reg_fl_int_gain};

  //-----------------------
  assign swi_fl_int_gain = reg_fl_int_gain;

  //-----------------------
  assign swi_fl_prop_gain = reg_fl_prop_gain;





  //---------------------------
  // INTR_PROP_GAINS_OVERRIDE
  // int_gain - Integral gain directly after VCO switch
  // int_gain_mux - 
  // prop_gain - Proportional gain directly after VCO switch
  // prop_gain_mux - 
  //---------------------------
  wire [31:0] INTR_PROP_GAINS_OVERRIDE_reg_read;
  reg  [4:0]   reg_int_gain;
  reg  [4:0]   reg_prop_gain;

  always @(posedge RegClk or posedge RegReset) begin
    if(RegReset) begin
      reg_int_gain                           <= 5'hf;
      reg_int_gain_mux                       <= 1'h0;
      reg_prop_gain                          <= 5'h9;
      reg_prop_gain_mux                      <= 1'h0;
    end else if(RegAddr == 'h34 && RegWrEn) begin
      reg_int_gain                           <= RegWrData[4:0];
      reg_int_gain_mux                       <= RegWrData[5];
      reg_prop_gain                          <= RegWrData[10:6];
      reg_prop_gain_mux                      <= RegWrData[11];
    end else begin
      reg_int_gain                           <= reg_int_gain;
      reg_int_gain_mux                       <= reg_int_gain_mux;
      reg_prop_gain                          <= reg_prop_gain;
      reg_prop_gain_mux                      <= reg_prop_gain_mux;
    end
  end

  assign INTR_PROP_GAINS_OVERRIDE_reg_read = {20'h0,
          reg_prop_gain_mux,
          reg_prop_gain,
          reg_int_gain_mux,
          reg_int_gain};

  //-----------------------

  wire [4:0]  swi_int_gain_muxed_pre;
  wav_clock_mux u_wav_clock_mux_int_gain[4:0] (
    .clk0    ( int_gain                           ),              
    .clk1    ( reg_int_gain                       ),              
    .sel     ( reg_int_gain_mux                   ),      
    .clk_out ( swi_int_gain_muxed_pre             )); 

  wire [4:0] int_gain_tdo;


  wire [4:0] int_gain_bscan_flop_po;
  rpll_regs_jtag_bsr u_rpll_regs_jtag_bsr_int_gain[4:0] (   
    .tck        ( dft_bscan_tck                      ),          
    .trst_n     ( dft_bscan_trst_n                   ),      
    .bscan_mode ( dft_bscan_mode                     ),
    .capturedr  ( dft_bscan_capturedr                ),
    .shiftdr    ( dft_bscan_shiftdr                  ),          
    .updatedr   ( dft_bscan_updatedr                 ),               
    .pi         ( swi_int_gain_muxed_pre             ),               
    .po         ( int_gain_bscan_flop_po             ),               
    .tdi        ( {post_div_sel_tdo[0],
                   int_gain_tdo[4],
                   int_gain_tdo[3],
                   int_gain_tdo[2],
                   int_gain_tdo[1]}     ),                
    .tdo        ( {int_gain_tdo[4],
                   int_gain_tdo[3],
                   int_gain_tdo[2],
                   int_gain_tdo[1],
                   int_gain_tdo[0]}     )); 

  assign swi_int_gain_muxed = int_gain_bscan_flop_po;

  //-----------------------
  //-----------------------

  wire [4:0]  swi_prop_gain_muxed_pre;
  wav_clock_mux u_wav_clock_mux_prop_gain[4:0] (
    .clk0    ( prop_gain                          ),              
    .clk1    ( reg_prop_gain                      ),              
    .sel     ( reg_prop_gain_mux                  ),      
    .clk_out ( swi_prop_gain_muxed_pre            )); 

  wire [4:0] prop_gain_tdo;


  wire [4:0] prop_gain_bscan_flop_po;
  rpll_regs_jtag_bsr u_rpll_regs_jtag_bsr_prop_gain[4:0] (   
    .tck        ( dft_bscan_tck                      ),          
    .trst_n     ( dft_bscan_trst_n                   ),      
    .bscan_mode ( dft_bscan_mode                     ),
    .capturedr  ( dft_bscan_capturedr                ),
    .shiftdr    ( dft_bscan_shiftdr                  ),          
    .updatedr   ( dft_bscan_updatedr                 ),               
    .pi         ( swi_prop_gain_muxed_pre            ),               
    .po         ( prop_gain_bscan_flop_po            ),               
    .tdi        ( {int_gain_tdo[0],
                   prop_gain_tdo[4],
                   prop_gain_tdo[3],
                   prop_gain_tdo[2],
                   prop_gain_tdo[1]}     ),                
    .tdo        ( {prop_gain_tdo[4],
                   prop_gain_tdo[3],
                   prop_gain_tdo[2],
                   prop_gain_tdo[1],
                   prop_gain_tdo[0]}     )); 

  assign swi_prop_gain_muxed = prop_gain_bscan_flop_po;

  //-----------------------




  //---------------------------
  // LOCK_DET_SETTINGS
  // ld_refclk_cycles - Number of refclk cycles to compare against fbclk for detecting lock. A higher number with tighter range equates to a lower PPM tolerance
  // ld_range - Range tolerance for refclk vs. fbclk during normal lock procedure
  //---------------------------
  wire [31:0] LOCK_DET_SETTINGS_reg_read;
  reg [15:0]  reg_ld_refclk_cycles;
  reg [5:0]   reg_ld_range;

  always @(posedge RegClk or posedge RegReset) begin
    if(RegReset) begin
      reg_ld_refclk_cycles                   <= 16'h200;
      reg_ld_range                           <= 6'h4;
    end else if(RegAddr == 'h38 && RegWrEn) begin
      reg_ld_refclk_cycles                   <= RegWrData[15:0];
      reg_ld_range                           <= RegWrData[21:16];
    end else begin
      reg_ld_refclk_cycles                   <= reg_ld_refclk_cycles;
      reg_ld_range                           <= reg_ld_range;
    end
  end

  assign LOCK_DET_SETTINGS_reg_read = {10'h0,
          reg_ld_range,
          reg_ld_refclk_cycles};

  //-----------------------
  assign swi_ld_refclk_cycles = reg_ld_refclk_cycles;

  //-----------------------
  assign swi_ld_range = reg_ld_range;





  //---------------------------
  // FASTLOCK_DET_SETTINGS
  // fastld_refclk_cycles - Number of refclk cycles to compare against fbclk for detecting lock during fastlock. A higher number with tighter range equates to a lower PPM tolerance
  // fastld_range - Range tolerance for refclk vs. fbclk during fast lock procedure
  //---------------------------
  wire [31:0] FASTLOCK_DET_SETTINGS_reg_read;
  reg [15:0]  reg_fastld_refclk_cycles;
  reg [5:0]   reg_fastld_range;

  always @(posedge RegClk or posedge RegReset) begin
    if(RegReset) begin
      reg_fastld_refclk_cycles               <= 16'h100;
      reg_fastld_range                       <= 6'h8;
    end else if(RegAddr == 'h3c && RegWrEn) begin
      reg_fastld_refclk_cycles               <= RegWrData[15:0];
      reg_fastld_range                       <= RegWrData[21:16];
    end else begin
      reg_fastld_refclk_cycles               <= reg_fastld_refclk_cycles;
      reg_fastld_range                       <= reg_fastld_range;
    end
  end

  assign FASTLOCK_DET_SETTINGS_reg_read = {10'h0,
          reg_fastld_range,
          reg_fastld_refclk_cycles};

  //-----------------------
  assign swi_fastld_refclk_cycles = reg_fastld_refclk_cycles;

  //-----------------------
  assign swi_fastld_range = reg_fastld_range;





  //---------------------------
  // ANALOG_EN_RESET
  // pll_en - PLL Enable override going to analog
  // pll_en_mux - 
  // pll_reset - PLL reset override going to analog
  // pll_reset_mux - 
  // pll_ret - PLL retention override going to analog
  // pll_ret_mux - 
  // fbdiv_sel - Feedback divider override going to analog
  // fbdiv_sel_mux - 
  //---------------------------
  wire [31:0] ANALOG_EN_RESET_reg_read;
  reg          reg_pll_en;
  reg          reg_pll_reset;
  reg          reg_pll_ret;
  reg  [8:0]   reg_fbdiv_sel;

  always @(posedge RegClk or posedge RegReset) begin
    if(RegReset) begin
      reg_pll_en                             <= 1'h0;
      reg_pll_en_mux                         <= 1'h0;
      reg_pll_reset                          <= 1'h0;
      reg_pll_reset_mux                      <= 1'h0;
      reg_pll_ret                            <= 1'h0;
      reg_pll_ret_mux                        <= 1'h0;
      reg_fbdiv_sel                          <= 9'h0;
      reg_fbdiv_sel_mux                      <= 1'h0;
    end else if(RegAddr == 'h40 && RegWrEn) begin
      reg_pll_en                             <= RegWrData[0];
      reg_pll_en_mux                         <= RegWrData[1];
      reg_pll_reset                          <= RegWrData[2];
      reg_pll_reset_mux                      <= RegWrData[3];
      reg_pll_ret                            <= RegWrData[4];
      reg_pll_ret_mux                        <= RegWrData[5];
      reg_fbdiv_sel                          <= RegWrData[14:6];
      reg_fbdiv_sel_mux                      <= RegWrData[15];
    end else begin
      reg_pll_en                             <= reg_pll_en;
      reg_pll_en_mux                         <= reg_pll_en_mux;
      reg_pll_reset                          <= reg_pll_reset;
      reg_pll_reset_mux                      <= reg_pll_reset_mux;
      reg_pll_ret                            <= reg_pll_ret;
      reg_pll_ret_mux                        <= reg_pll_ret_mux;
      reg_fbdiv_sel                          <= reg_fbdiv_sel;
      reg_fbdiv_sel_mux                      <= reg_fbdiv_sel_mux;
    end
  end

  assign ANALOG_EN_RESET_reg_read = {16'h0,
          reg_fbdiv_sel_mux,
          reg_fbdiv_sel,
          reg_pll_ret_mux,
          reg_pll_ret,
          reg_pll_reset_mux,
          reg_pll_reset,
          reg_pll_en_mux,
          reg_pll_en};

  //-----------------------

  wire        swi_pll_en_muxed_pre;
  wav_clock_mux u_wav_clock_mux_pll_en (
    .clk0    ( pll_en                             ),              
    .clk1    ( reg_pll_en                         ),              
    .sel     ( reg_pll_en_mux                     ),      
    .clk_out ( swi_pll_en_muxed_pre               )); 


  wire        reg_pll_en_core_scan_mode;
  wav_clock_mux u_wav_clock_mux_pll_en_core_scan_mode (
    .clk0    ( swi_pll_en_muxed_pre               ),              
    .clk1    ( 1'd0                               ),              
    .sel     ( dft_core_scan_mode                 ),      
    .clk_out ( reg_pll_en_core_scan_mode          )); 


  wire        reg_pll_en_iddq_mode;
  wav_clock_mux u_wav_clock_mux_pll_en_iddq_mode (
    .clk0    ( reg_pll_en_core_scan_mode          ),              
    .clk1    ( 1'd0                               ),              
    .sel     ( dft_iddq_mode                      ),      
    .clk_out ( reg_pll_en_iddq_mode               )); 

  wire  pll_en_tdo;


  wire  pll_en_bscan_flop_po;
  rpll_regs_jtag_bsr u_rpll_regs_jtag_bsr_pll_en (   
    .tck        ( dft_bscan_tck                      ),          
    .trst_n     ( dft_bscan_trst_n                   ),      
    .bscan_mode ( dft_bscan_mode                     ),
    .capturedr  ( dft_bscan_capturedr                ),
    .shiftdr    ( dft_bscan_shiftdr                  ),          
    .updatedr   ( dft_bscan_updatedr                 ),               
    .pi         ( reg_pll_en_iddq_mode               ),               
    .po         ( pll_en_bscan_flop_po               ),               
    .tdi        ( prop_gain_tdo[0]                   ),                
    .tdo        ( pll_en_tdo                         )); 

  assign swi_pll_en_muxed = pll_en_bscan_flop_po;

  //-----------------------
  //-----------------------

  wire        swi_pll_reset_muxed_pre;
  wav_clock_mux u_wav_clock_mux_pll_reset (
    .clk0    ( pll_reset                          ),              
    .clk1    ( reg_pll_reset                      ),              
    .sel     ( reg_pll_reset_mux                  ),      
    .clk_out ( swi_pll_reset_muxed_pre            )); 


  wire        reg_pll_reset_core_scan_mode;
  wav_clock_mux u_wav_clock_mux_pll_reset_core_scan_mode (
    .clk0    ( swi_pll_reset_muxed_pre            ),              
    .clk1    ( 1'd1                               ),              
    .sel     ( dft_core_scan_mode                 ),      
    .clk_out ( reg_pll_reset_core_scan_mode       )); 


  wire        reg_pll_reset_iddq_mode;
  wav_clock_mux u_wav_clock_mux_pll_reset_iddq_mode (
    .clk0    ( reg_pll_reset_core_scan_mode       ),              
    .clk1    ( 1'd1                               ),              
    .sel     ( dft_iddq_mode                      ),      
    .clk_out ( reg_pll_reset_iddq_mode            )); 

  wire  pll_reset_tdo;


  wire  pll_reset_bscan_flop_po;
  rpll_regs_jtag_bsr u_rpll_regs_jtag_bsr_pll_reset (   
    .tck        ( dft_bscan_tck                      ),          
    .trst_n     ( dft_bscan_trst_n                   ),      
    .bscan_mode ( dft_bscan_mode                     ),
    .capturedr  ( dft_bscan_capturedr                ),
    .shiftdr    ( dft_bscan_shiftdr                  ),          
    .updatedr   ( dft_bscan_updatedr                 ),               
    .pi         ( reg_pll_reset_iddq_mode            ),               
    .po         ( pll_reset_bscan_flop_po            ),               
    .tdi        ( pll_en_tdo                         ),                
    .tdo        ( pll_reset_tdo                      )); 

  assign swi_pll_reset_muxed = pll_reset_bscan_flop_po;

  //-----------------------
  //-----------------------

  wire        swi_pll_ret_muxed_pre;
  wav_clock_mux u_wav_clock_mux_pll_ret (
    .clk0    ( pll_ret                            ),              
    .clk1    ( reg_pll_ret                        ),              
    .sel     ( reg_pll_ret_mux                    ),      
    .clk_out ( swi_pll_ret_muxed_pre              )); 


  wire        reg_pll_ret_core_scan_mode;
  wav_clock_mux u_wav_clock_mux_pll_ret_core_scan_mode (
    .clk0    ( swi_pll_ret_muxed_pre              ),              
    .clk1    ( 1'd0                               ),              
    .sel     ( dft_core_scan_mode                 ),      
    .clk_out ( reg_pll_ret_core_scan_mode         )); 


  wire        reg_pll_ret_iddq_mode;
  wav_clock_mux u_wav_clock_mux_pll_ret_iddq_mode (
    .clk0    ( reg_pll_ret_core_scan_mode         ),              
    .clk1    ( 1'd0                               ),              
    .sel     ( dft_iddq_mode                      ),      
    .clk_out ( reg_pll_ret_iddq_mode              )); 


  wire        reg_pll_ret_hiz_mode;
  wav_clock_mux u_wav_clock_mux_pll_ret_hiz_mode (
    .clk0    ( reg_pll_ret_iddq_mode              ),              
    .clk1    ( 1'd0                               ),              
    .sel     ( dft_hiz_mode                       ),      
    .clk_out ( reg_pll_ret_hiz_mode               )); 


  wire        reg_pll_ret_bscan_mode;
  wav_clock_mux u_wav_clock_mux_pll_ret_bscan_mode (
    .clk0    ( reg_pll_ret_hiz_mode               ),              
    .clk1    ( 1'd0                               ),              
    .sel     ( dft_bscan_mode                     ),      
    .clk_out ( reg_pll_ret_bscan_mode             )); 

  assign swi_pll_ret_muxed = reg_pll_ret_bscan_mode;

  //-----------------------
  //-----------------------

  wire [8:0]  swi_fbdiv_sel_muxed_pre;
  wav_clock_mux u_wav_clock_mux_fbdiv_sel[8:0] (
    .clk0    ( fbdiv_sel                          ),              
    .clk1    ( reg_fbdiv_sel                      ),              
    .sel     ( reg_fbdiv_sel_mux                  ),      
    .clk_out ( swi_fbdiv_sel_muxed_pre            )); 

  wire [8:0] fbdiv_sel_tdo;


  wire [8:0] fbdiv_sel_bscan_flop_po;
  rpll_regs_jtag_bsr u_rpll_regs_jtag_bsr_fbdiv_sel[8:0] (   
    .tck        ( dft_bscan_tck                      ),          
    .trst_n     ( dft_bscan_trst_n                   ),      
    .bscan_mode ( dft_bscan_mode                     ),
    .capturedr  ( dft_bscan_capturedr                ),
    .shiftdr    ( dft_bscan_shiftdr                  ),          
    .updatedr   ( dft_bscan_updatedr                 ),               
    .pi         ( swi_fbdiv_sel_muxed_pre            ),               
    .po         ( fbdiv_sel_bscan_flop_po            ),               
    .tdi        ( {pll_reset_tdo,
                   fbdiv_sel_tdo[8],
                   fbdiv_sel_tdo[7],
                   fbdiv_sel_tdo[6],
                   fbdiv_sel_tdo[5],
                   fbdiv_sel_tdo[4],
                   fbdiv_sel_tdo[3],
                   fbdiv_sel_tdo[2],
                   fbdiv_sel_tdo[1]}     ),                
    .tdo        ( {fbdiv_sel_tdo[8],
                   fbdiv_sel_tdo[7],
                   fbdiv_sel_tdo[6],
                   fbdiv_sel_tdo[5],
                   fbdiv_sel_tdo[4],
                   fbdiv_sel_tdo[3],
                   fbdiv_sel_tdo[2],
                   fbdiv_sel_tdo[1],
                   fbdiv_sel_tdo[0]}     )); 

  assign swi_fbdiv_sel_muxed = fbdiv_sel_bscan_flop_po;

  //-----------------------




  //---------------------------
  // MODE_DTST_MISC
  // bias_lvl - Bias Level analog control
  // cp_int_mode - Analog control, keep at 0x0
  // en_lock_det - Override for enabling lock detect. Should only be used in testing.
  // en_lock_det_mux - 1 - Use value from register. 0 - Hardware controlled
  // dtest_sel - DTest Control (see analog doc)
  // mode_extra - 
  // byp_clk_sel - 
  // dbl_clk_sel - 
  // bias_sel - 0 - Internal bias generation
  //---------------------------
  wire [31:0] MODE_DTST_MISC_reg_read;
  reg [3:0]   reg_bias_lvl;
  reg         reg_cp_int_mode;
  reg          reg_en_lock_det;
  reg [2:0]   reg_dtest_sel;
  reg [7:0]   reg_mode_extra;
  reg         reg_byp_clk_sel;
  reg         reg_dbl_clk_sel;
  reg         reg_bias_sel;

  always @(posedge RegClk or posedge RegReset) begin
    if(RegReset) begin
      reg_bias_lvl                           <= 4'h8;
      reg_cp_int_mode                        <= 1'h0;
      reg_en_lock_det                        <= 1'h0;
      reg_en_lock_det_mux                    <= 1'h0;
      reg_dtest_sel                          <= 3'h0;
      reg_mode_extra                         <= 8'h0;
      reg_byp_clk_sel                        <= 1'h0;
      reg_dbl_clk_sel                        <= 1'h0;
      reg_bias_sel                           <= 1'h0;
    end else if(RegAddr == 'h44 && RegWrEn) begin
      reg_bias_lvl                           <= RegWrData[3:0];
      reg_cp_int_mode                        <= RegWrData[4];
      reg_en_lock_det                        <= RegWrData[5];
      reg_en_lock_det_mux                    <= RegWrData[6];
      reg_dtest_sel                          <= RegWrData[9:7];
      reg_mode_extra                         <= RegWrData[17:10];
      reg_byp_clk_sel                        <= RegWrData[18];
      reg_dbl_clk_sel                        <= RegWrData[19];
      reg_bias_sel                           <= RegWrData[20];
    end else begin
      reg_bias_lvl                           <= reg_bias_lvl;
      reg_cp_int_mode                        <= reg_cp_int_mode;
      reg_en_lock_det                        <= reg_en_lock_det;
      reg_en_lock_det_mux                    <= reg_en_lock_det_mux;
      reg_dtest_sel                          <= reg_dtest_sel;
      reg_mode_extra                         <= reg_mode_extra;
      reg_byp_clk_sel                        <= reg_byp_clk_sel;
      reg_dbl_clk_sel                        <= reg_dbl_clk_sel;
      reg_bias_sel                           <= reg_bias_sel;
    end
  end

  assign MODE_DTST_MISC_reg_read = {11'h0,
          reg_bias_sel,
          reg_dbl_clk_sel,
          reg_byp_clk_sel,
          reg_mode_extra,
          reg_dtest_sel,
          reg_en_lock_det_mux,
          reg_en_lock_det,
          reg_cp_int_mode,
          reg_bias_lvl};

  //-----------------------
  wire [3:0] bias_lvl_tdo;


  wire [3:0] bias_lvl_bscan_flop_po;
  rpll_regs_jtag_bsr u_rpll_regs_jtag_bsr_bias_lvl[3:0] (   
    .tck        ( dft_bscan_tck                      ),          
    .trst_n     ( dft_bscan_trst_n                   ),      
    .bscan_mode ( dft_bscan_mode                     ),
    .capturedr  ( dft_bscan_capturedr                ),
    .shiftdr    ( dft_bscan_shiftdr                  ),          
    .updatedr   ( dft_bscan_updatedr                 ),               
    .pi         ( reg_bias_lvl                       ),               
    .po         ( bias_lvl_bscan_flop_po             ),               
    .tdi        ( {fbdiv_sel_tdo[0],
                   bias_lvl_tdo[3],
                   bias_lvl_tdo[2],
                   bias_lvl_tdo[1]}     ),                
    .tdo        ( {bias_lvl_tdo[3],
                   bias_lvl_tdo[2],
                   bias_lvl_tdo[1],
                   bias_lvl_tdo[0]}     )); 

  assign swi_bias_lvl = bias_lvl_bscan_flop_po;

  //-----------------------

  wire        reg_cp_int_mode_core_scan_mode;
  wav_clock_mux u_wav_clock_mux_cp_int_mode_core_scan_mode (
    .clk0    ( reg_cp_int_mode                    ),              
    .clk1    ( 1'd0                               ),              
    .sel     ( dft_core_scan_mode                 ),      
    .clk_out ( reg_cp_int_mode_core_scan_mode     )); 


  wire        reg_cp_int_mode_iddq_mode;
  wav_clock_mux u_wav_clock_mux_cp_int_mode_iddq_mode (
    .clk0    ( reg_cp_int_mode_core_scan_mode     ),              
    .clk1    ( 1'd0                               ),              
    .sel     ( dft_iddq_mode                      ),      
    .clk_out ( reg_cp_int_mode_iddq_mode          )); 


  wire        reg_cp_int_mode_bscan_mode;
  wav_clock_mux u_wav_clock_mux_cp_int_mode_bscan_mode (
    .clk0    ( reg_cp_int_mode_iddq_mode          ),              
    .clk1    ( 1'd0                               ),              
    .sel     ( dft_bscan_mode                     ),      
    .clk_out ( reg_cp_int_mode_bscan_mode         )); 

  assign swi_cp_int_mode = reg_cp_int_mode_bscan_mode;

  //-----------------------

  wire        swi_en_lock_det_muxed_pre;
  wav_clock_mux u_wav_clock_mux_en_lock_det (
    .clk0    ( en_lock_det                        ),              
    .clk1    ( reg_en_lock_det                    ),              
    .sel     ( reg_en_lock_det_mux                ),      
    .clk_out ( swi_en_lock_det_muxed_pre          )); 

  assign swi_en_lock_det_muxed = swi_en_lock_det_muxed_pre;

  //-----------------------
  //-----------------------
  assign swi_dtest_sel = reg_dtest_sel;

  //-----------------------
  assign swi_mode_extra = reg_mode_extra;

  //-----------------------
  wire  byp_clk_sel_tdo;


  wire  byp_clk_sel_bscan_flop_po;
  rpll_regs_jtag_bsr u_rpll_regs_jtag_bsr_byp_clk_sel (   
    .tck        ( dft_bscan_tck                      ),          
    .trst_n     ( dft_bscan_trst_n                   ),      
    .bscan_mode ( dft_bscan_mode                     ),
    .capturedr  ( dft_bscan_capturedr                ),
    .shiftdr    ( dft_bscan_shiftdr                  ),          
    .updatedr   ( dft_bscan_updatedr                 ),               
    .pi         ( reg_byp_clk_sel                    ),               
    .po         ( byp_clk_sel_bscan_flop_po          ),               
    .tdi        ( bias_lvl_tdo[0]                    ),                
    .tdo        ( byp_clk_sel_tdo                    )); 

  assign swi_byp_clk_sel = byp_clk_sel_bscan_flop_po;

  //-----------------------
  wire  dbl_clk_sel_tdo;


  wire  dbl_clk_sel_bscan_flop_po;
  rpll_regs_jtag_bsr u_rpll_regs_jtag_bsr_dbl_clk_sel (   
    .tck        ( dft_bscan_tck                      ),          
    .trst_n     ( dft_bscan_trst_n                   ),      
    .bscan_mode ( dft_bscan_mode                     ),
    .capturedr  ( dft_bscan_capturedr                ),
    .shiftdr    ( dft_bscan_shiftdr                  ),          
    .updatedr   ( dft_bscan_updatedr                 ),               
    .pi         ( reg_dbl_clk_sel                    ),               
    .po         ( dbl_clk_sel_bscan_flop_po          ),               
    .tdi        ( byp_clk_sel_tdo                    ),                
    .tdo        ( dbl_clk_sel_tdo                    )); 

  assign swi_dbl_clk_sel = dbl_clk_sel_bscan_flop_po;

  //-----------------------
  wire  bias_sel_tdo;


  wire  bias_sel_bscan_flop_po;
  rpll_regs_jtag_bsr u_rpll_regs_jtag_bsr_bias_sel (   
    .tck        ( dft_bscan_tck                      ),          
    .trst_n     ( dft_bscan_trst_n                   ),      
    .bscan_mode ( dft_bscan_mode                     ),
    .capturedr  ( dft_bscan_capturedr                ),
    .shiftdr    ( dft_bscan_shiftdr                  ),          
    .updatedr   ( dft_bscan_updatedr                 ),               
    .pi         ( reg_bias_sel                       ),               
    .po         ( bias_sel_bscan_flop_po             ),               
    .tdi        ( dbl_clk_sel_tdo                    ),                
    .tdo        ( bias_sel_tdo                       )); 

  assign swi_bias_sel = bias_sel_bscan_flop_po;





  //---------------------------
  // PROP_CTRLS
  // prop_c_ctrl - 
  // prop_r_ctrl - 
  //---------------------------
  wire [31:0] PROP_CTRLS_reg_read;
  reg [1:0]   reg_prop_c_ctrl;
  reg [1:0]   reg_prop_r_ctrl;

  always @(posedge RegClk or posedge RegReset) begin
    if(RegReset) begin
      reg_prop_c_ctrl                        <= 2'h0;
      reg_prop_r_ctrl                        <= 2'h0;
    end else if(RegAddr == 'h48 && RegWrEn) begin
      reg_prop_c_ctrl                        <= RegWrData[1:0];
      reg_prop_r_ctrl                        <= RegWrData[3:2];
    end else begin
      reg_prop_c_ctrl                        <= reg_prop_c_ctrl;
      reg_prop_r_ctrl                        <= reg_prop_r_ctrl;
    end
  end

  assign PROP_CTRLS_reg_read = {28'h0,
          reg_prop_r_ctrl,
          reg_prop_c_ctrl};

  //-----------------------
  wire [1:0] prop_c_ctrl_tdo;


  wire [1:0] prop_c_ctrl_bscan_flop_po;
  rpll_regs_jtag_bsr u_rpll_regs_jtag_bsr_prop_c_ctrl[1:0] (   
    .tck        ( dft_bscan_tck                      ),          
    .trst_n     ( dft_bscan_trst_n                   ),      
    .bscan_mode ( dft_bscan_mode                     ),
    .capturedr  ( dft_bscan_capturedr                ),
    .shiftdr    ( dft_bscan_shiftdr                  ),          
    .updatedr   ( dft_bscan_updatedr                 ),               
    .pi         ( reg_prop_c_ctrl                    ),               
    .po         ( prop_c_ctrl_bscan_flop_po          ),               
    .tdi        ( {bias_sel_tdo,
                   prop_c_ctrl_tdo[1]}     ),                
    .tdo        ( {prop_c_ctrl_tdo[1],
                   prop_c_ctrl_tdo[0]}     )); 

  assign swi_prop_c_ctrl = prop_c_ctrl_bscan_flop_po;

  //-----------------------
  wire [1:0] prop_r_ctrl_tdo;


  wire [1:0] prop_r_ctrl_bscan_flop_po;
  rpll_regs_jtag_bsr u_rpll_regs_jtag_bsr_prop_r_ctrl[1:0] (   
    .tck        ( dft_bscan_tck                      ),          
    .trst_n     ( dft_bscan_trst_n                   ),      
    .bscan_mode ( dft_bscan_mode                     ),
    .capturedr  ( dft_bscan_capturedr                ),
    .shiftdr    ( dft_bscan_shiftdr                  ),          
    .updatedr   ( dft_bscan_updatedr                 ),               
    .pi         ( reg_prop_r_ctrl                    ),               
    .po         ( prop_r_ctrl_bscan_flop_po          ),               
    .tdi        ( {prop_c_ctrl_tdo[0],
                   prop_r_ctrl_tdo[1]}     ),                
    .tdo        ( {prop_r_ctrl_tdo[1],
                   prop_r_ctrl_tdo[0]}     )); 

  assign swi_prop_r_ctrl = prop_r_ctrl_bscan_flop_po;





  //---------------------------
  // REFCLK_CONTROLS
  // pfd_mode - 
  // sel_refclk_alt - 
  //---------------------------
  wire [31:0] REFCLK_CONTROLS_reg_read;
  reg [1:0]   reg_pfd_mode;
  reg         reg_sel_refclk_alt;

  always @(posedge RegClk or posedge RegReset) begin
    if(RegReset) begin
      reg_pfd_mode                           <= 2'h0;
      reg_sel_refclk_alt                     <= 1'h0;
    end else if(RegAddr == 'h4c && RegWrEn) begin
      reg_pfd_mode                           <= RegWrData[1:0];
      reg_sel_refclk_alt                     <= RegWrData[2];
    end else begin
      reg_pfd_mode                           <= reg_pfd_mode;
      reg_sel_refclk_alt                     <= reg_sel_refclk_alt;
    end
  end

  assign REFCLK_CONTROLS_reg_read = {29'h0,
          reg_sel_refclk_alt,
          reg_pfd_mode};

  //-----------------------
  wire [1:0] pfd_mode_tdo;


  wire [1:0] pfd_mode_bscan_flop_po;
  rpll_regs_jtag_bsr u_rpll_regs_jtag_bsr_pfd_mode[1:0] (   
    .tck        ( dft_bscan_tck                      ),          
    .trst_n     ( dft_bscan_trst_n                   ),      
    .bscan_mode ( dft_bscan_mode                     ),
    .capturedr  ( dft_bscan_capturedr                ),
    .shiftdr    ( dft_bscan_shiftdr                  ),          
    .updatedr   ( dft_bscan_updatedr                 ),               
    .pi         ( reg_pfd_mode                       ),               
    .po         ( pfd_mode_bscan_flop_po             ),               
    .tdi        ( {prop_r_ctrl_tdo[0],
                   pfd_mode_tdo[1]}     ),                
    .tdo        ( {pfd_mode_tdo[1],
                   pfd_mode_tdo[0]}     )); 

  assign swi_pfd_mode = pfd_mode_bscan_flop_po;

  //-----------------------
  wire  sel_refclk_alt_tdo;


  wire  sel_refclk_alt_bscan_flop_po;
  rpll_regs_jtag_bsr u_rpll_regs_jtag_bsr_sel_refclk_alt (   
    .tck        ( dft_bscan_tck                      ),          
    .trst_n     ( dft_bscan_trst_n                   ),      
    .bscan_mode ( dft_bscan_mode                     ),
    .capturedr  ( dft_bscan_capturedr                ),
    .shiftdr    ( dft_bscan_shiftdr                  ),          
    .updatedr   ( dft_bscan_updatedr                 ),               
    .pi         ( reg_sel_refclk_alt                 ),               
    .po         ( sel_refclk_alt_bscan_flop_po       ),               
    .tdi        ( pfd_mode_tdo[0]                    ),                
    .tdo        ( sel_refclk_alt_tdo                 )); 

  assign swi_sel_refclk_alt = sel_refclk_alt_bscan_flop_po;





  //---------------------------
  // DEBUG_BUS_CTRL
  // DEBUG_BUS_CTRL_SEL - Select signal for DEBUG_BUS_CTRL
  //---------------------------
  wire [31:0] DEBUG_BUS_CTRL_reg_read;
  reg [3:0]   reg_debug_bus_ctrl_sel;
  wire [3:0]   swi_debug_bus_ctrl_sel;

  always @(posedge RegClk or posedge RegReset) begin
    if(RegReset) begin
      reg_debug_bus_ctrl_sel                 <= 4'h0;
    end else if(RegAddr == 'h50 && RegWrEn) begin
      reg_debug_bus_ctrl_sel                 <= RegWrData[3:0];
    end else begin
      reg_debug_bus_ctrl_sel                 <= reg_debug_bus_ctrl_sel;
    end
  end

  assign DEBUG_BUS_CTRL_reg_read = {28'h0,
          reg_debug_bus_ctrl_sel};

  //-----------------------
  assign swi_debug_bus_ctrl_sel = reg_debug_bus_ctrl_sel;





  //---------------------------
  // DEBUG_BUS_STATUS
  // DEBUG_BUS_CTRL_STATUS - Status output for DEBUG_BUS_STATUS
  //---------------------------
  wire [31:0] DEBUG_BUS_STATUS_reg_read;

  //Debug bus control logic  
  always @(*) begin
    case(swi_debug_bus_ctrl_sel)
      'd0 : debug_bus_ctrl_status = {8'd0, fsm_state, freq_detect_cycles, freq_detect_lock, core_fastlock_ready, core_ready};
      'd1 : debug_bus_ctrl_status = {13'd0, ret_lock_cycles, ret_lock_det_locked, 1'd0, 1'd0};
      'd2 : debug_bus_ctrl_status = {31'd0, swi_core_reset_muxed};
      'd3 : debug_bus_ctrl_status = {31'd0, swi_core_ready_ov_muxed};
      'd4 : debug_bus_ctrl_status = {31'd0, swi_core_ret_muxed};
      'd5 : debug_bus_ctrl_status = {31'd0, swi_ret_lock_det_en_muxed};
      'd6 : debug_bus_ctrl_status = {27'd0, swi_int_gain_muxed};
      'd7 : debug_bus_ctrl_status = {27'd0, swi_prop_gain_muxed};
      'd8 : debug_bus_ctrl_status = {31'd0, swi_pll_en_muxed};
      'd9 : debug_bus_ctrl_status = {31'd0, swi_pll_reset_muxed};
      'd10 : debug_bus_ctrl_status = {31'd0, swi_pll_ret_muxed};
      'd11 : debug_bus_ctrl_status = {23'd0, swi_fbdiv_sel_muxed};
      'd12 : debug_bus_ctrl_status = {31'd0, swi_en_lock_det_muxed};
      default : debug_bus_ctrl_status = 32'd0;
    endcase
  end 
  
  assign DEBUG_BUS_STATUS_reg_read = {          debug_bus_ctrl_status};

  //-----------------------

  //=======================
  // Final BSCAN Connection
  //=======================
  assign dft_bscan_tdo = sel_refclk_alt_tdo;


  
    
  //---------------------------
  // PRDATA Selection
  //---------------------------
  reg [31:0] prdata_sel;
  
  always @(*) begin
    case(RegAddr)
      'h0    : prdata_sel = CORE_OVERRIDES_reg_read;
      'h4    : prdata_sel = CORE_STATUS_reg_read;
      'h8    : prdata_sel = CORE_STATUS_INT_reg_read;
      'hc    : prdata_sel = INT_FRAC_SETTINGS_reg_read;
      'h10   : prdata_sel = SSC_CONTROLS_reg_read;
      'h14   : prdata_sel = RETENTION_STATE_CONTROL_reg_read;
      'h18   : prdata_sel = RETENTION_EXIT_SETTINGS_reg_read;
      'h1c   : prdata_sel = RETENTION_LOCK_SETTINGS_reg_read;
      'h20   : prdata_sel = RETENTION_LOCK_SETTINGS2_reg_read;
      'h24   : prdata_sel = STATE_MACHINE_CONTROLS_reg_read;
      'h28   : prdata_sel = PROP_GAINS_reg_read;
      'h2c   : prdata_sel = INTR_GAINS_reg_read;
      'h30   : prdata_sel = INTR_PROP_FL_GAINS_reg_read;
      'h34   : prdata_sel = INTR_PROP_GAINS_OVERRIDE_reg_read;
      'h38   : prdata_sel = LOCK_DET_SETTINGS_reg_read;
      'h3c   : prdata_sel = FASTLOCK_DET_SETTINGS_reg_read;
      'h40   : prdata_sel = ANALOG_EN_RESET_reg_read;
      'h44   : prdata_sel = MODE_DTST_MISC_reg_read;
      'h48   : prdata_sel = PROP_CTRLS_reg_read;
      'h4c   : prdata_sel = REFCLK_CONTROLS_reg_read;
      'h50   : prdata_sel = DEBUG_BUS_CTRL_reg_read;
      'h54   : prdata_sel = DEBUG_BUS_STATUS_reg_read;

      default : prdata_sel = 32'd0;
    endcase
  end
  
  assign PRDATA = prdata_sel;


  
    
  //---------------------------
  // PSLVERR Detection
  //---------------------------
  reg pslverr_pre;
  
  always @(*) begin
    case(RegAddr)
      'h0    : pslverr_pre = 1'b0;
      'h4    : pslverr_pre = 1'b0;
      'h8    : pslverr_pre = 1'b0;
      'hc    : pslverr_pre = 1'b0;
      'h10   : pslverr_pre = 1'b0;
      'h14   : pslverr_pre = 1'b0;
      'h18   : pslverr_pre = 1'b0;
      'h1c   : pslverr_pre = 1'b0;
      'h20   : pslverr_pre = 1'b0;
      'h24   : pslverr_pre = 1'b0;
      'h28   : pslverr_pre = 1'b0;
      'h2c   : pslverr_pre = 1'b0;
      'h30   : pslverr_pre = 1'b0;
      'h34   : pslverr_pre = 1'b0;
      'h38   : pslverr_pre = 1'b0;
      'h3c   : pslverr_pre = 1'b0;
      'h40   : pslverr_pre = 1'b0;
      'h44   : pslverr_pre = 1'b0;
      'h48   : pslverr_pre = 1'b0;
      'h4c   : pslverr_pre = 1'b0;
      'h50   : pslverr_pre = 1'b0;
      'h54   : pslverr_pre = 1'b0;

      default : pslverr_pre = 1'b1;
    endcase
  end
  
  assign PSLVERR = pslverr_pre;


  `ifdef SIMULATION
  
  reg [8*200:1] file_name;
  integer       file;
  initial begin
    if ($value$plusargs("RPLL_REGS_BSR_MONITOR=%s", file_name)) begin
      file = $fopen(file_name, "w");
      $display("Starting RPLL_REGS_BSR_MONITOR with file: %s", file_name);
      forever begin
        @(posedge RegClk);
        if(RegWrEn) begin
          @(posedge RegClk);  //Wait 1 clock cycle for update
          $fwrite(file, "#Update @ %t\n", $realtime);
          $fwrite(file, "%1b // jtag_chain0 post_div_sel[1]\n", reg_post_div_sel[1]);
          $fwrite(file, "%1b // jtag_chain1 post_div_sel[0]\n", reg_post_div_sel[0]);
          $fwrite(file, "%1b // jtag_chain2 int_gain[4]\n", reg_int_gain[4]);
          $fwrite(file, "%1b // jtag_chain3 int_gain[3]\n", reg_int_gain[3]);
          $fwrite(file, "%1b // jtag_chain4 int_gain[2]\n", reg_int_gain[2]);
          $fwrite(file, "%1b // jtag_chain5 int_gain[1]\n", reg_int_gain[1]);
          $fwrite(file, "%1b // jtag_chain6 int_gain[0]\n", reg_int_gain[0]);
          $fwrite(file, "%1b // jtag_chain7 prop_gain[4]\n", reg_prop_gain[4]);
          $fwrite(file, "%1b // jtag_chain8 prop_gain[3]\n", reg_prop_gain[3]);
          $fwrite(file, "%1b // jtag_chain9 prop_gain[2]\n", reg_prop_gain[2]);
          $fwrite(file, "%1b // jtag_chain10 prop_gain[1]\n", reg_prop_gain[1]);
          $fwrite(file, "%1b // jtag_chain11 prop_gain[0]\n", reg_prop_gain[0]);
          $fwrite(file, "%1b // jtag_chain12 pll_en\n", reg_pll_en);
          $fwrite(file, "%1b // jtag_chain13 pll_reset\n", reg_pll_reset);
          $fwrite(file, "%1b // jtag_chain14 fbdiv_sel[8]\n", reg_fbdiv_sel[8]);
          $fwrite(file, "%1b // jtag_chain15 fbdiv_sel[7]\n", reg_fbdiv_sel[7]);
          $fwrite(file, "%1b // jtag_chain16 fbdiv_sel[6]\n", reg_fbdiv_sel[6]);
          $fwrite(file, "%1b // jtag_chain17 fbdiv_sel[5]\n", reg_fbdiv_sel[5]);
          $fwrite(file, "%1b // jtag_chain18 fbdiv_sel[4]\n", reg_fbdiv_sel[4]);
          $fwrite(file, "%1b // jtag_chain19 fbdiv_sel[3]\n", reg_fbdiv_sel[3]);
          $fwrite(file, "%1b // jtag_chain20 fbdiv_sel[2]\n", reg_fbdiv_sel[2]);
          $fwrite(file, "%1b // jtag_chain21 fbdiv_sel[1]\n", reg_fbdiv_sel[1]);
          $fwrite(file, "%1b // jtag_chain22 fbdiv_sel[0]\n", reg_fbdiv_sel[0]);
          $fwrite(file, "%1b // jtag_chain23 bias_lvl[3]\n", reg_bias_lvl[3]);
          $fwrite(file, "%1b // jtag_chain24 bias_lvl[2]\n", reg_bias_lvl[2]);
          $fwrite(file, "%1b // jtag_chain25 bias_lvl[1]\n", reg_bias_lvl[1]);
          $fwrite(file, "%1b // jtag_chain26 bias_lvl[0]\n", reg_bias_lvl[0]);
          $fwrite(file, "%1b // jtag_chain27 byp_clk_sel\n", reg_byp_clk_sel);
          $fwrite(file, "%1b // jtag_chain28 dbl_clk_sel\n", reg_dbl_clk_sel);
          $fwrite(file, "%1b // jtag_chain29 bias_sel\n", reg_bias_sel);
          $fwrite(file, "%1b // jtag_chain30 prop_c_ctrl[1]\n", reg_prop_c_ctrl[1]);
          $fwrite(file, "%1b // jtag_chain31 prop_c_ctrl[0]\n", reg_prop_c_ctrl[0]);
          $fwrite(file, "%1b // jtag_chain32 prop_r_ctrl[1]\n", reg_prop_r_ctrl[1]);
          $fwrite(file, "%1b // jtag_chain33 prop_r_ctrl[0]\n", reg_prop_r_ctrl[0]);
          $fwrite(file, "%1b // jtag_chain34 pfd_mode[1]\n", reg_pfd_mode[1]);
          $fwrite(file, "%1b // jtag_chain35 pfd_mode[0]\n", reg_pfd_mode[0]);
          $fwrite(file, "%1b // jtag_chain36 sel_refclk_alt\n", reg_sel_refclk_alt);
 
        end
      end
    end  
  end
  `endif
endmodule


      
//JTAG BSR Flop
module rpll_regs_jtag_bsr(
  input  wire tck,
  input  wire trst_n,
  input  wire bscan_mode,
  input  wire capturedr,      
  input  wire shiftdr,
  input  wire updatedr,
  input  wire pi,
  output wire po,
  input  wire tdi,
  output wire tdo
);


wav_jtag_bsr u_wav_jtag_bsr (
  .i_tck         ( tck            ),     
  .i_trst_n      ( trst_n         ),     
  .i_bsr_mode    ( bscan_mode     ),     
  .i_capture     ( capturedr      ),       
  .i_shift       ( shiftdr        ),       
  .i_update      ( updatedr       ),       
  .i_pi          ( pi             ),       
  .o_po          ( po             ),       
  .i_tdi         ( tdi            ),       
  .o_tdo         ( tdo            )); 
  
endmodule

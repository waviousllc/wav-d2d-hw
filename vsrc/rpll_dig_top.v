module rpll_dig_top (
  input  wire                     core_scan_asyncrst_ctrl,                   
  input  wire                     core_scan_clk,                             
  input  wire                     core_scan_mode,   
  input  wire                     core_scan_in,
  output wire                     core_scan_out,
  
  input  wire                     iddq_mode,
  
  input  wire                     bscan_mode,
  input  wire                     bscan_tck,
  input  wire                     bscan_trst_n,
  input  wire                     bscan_capturedr,
  input  wire                     bscan_shiftdr,
  input  wire                     bscan_updatedr,
  input  wire                     bscan_tdi,
  output wire                     bscan_tdo,
                      
  input  wire                     apb_clk,                      
  input  wire                     apb_reset,
  input  wire                     apb_psel,                     
  input  wire                     apb_penable,                  
  input  wire                     apb_pwrite,                   
  input  wire  [31:0]             apb_pwdata,                   
  input  wire  [7:0]              apb_paddr,                    
  output wire                     apb_pslverr,                  
  output wire                     apb_pready ,                  
  output wire  [31:0]             apb_prdata, 
  
  input  wire                     core_reset,
  output wire                     core_ready,
  input  wire                     core_ret,
  output wire                     core_refclk,
  output wire                     core_interrupt,
  
  output wire [3:0]               rpll_bias_lvl,
  output wire                     rpll_bias_sel,
  output wire                     rpll_byp_clk_sel,
  input  wire                     rpll_clk_div16,
  output wire                     rpll_cp_int_mode,
  output wire                     rpll_dbl_clk_sel,
  output wire [2:0]               rpll_dtest_sel,  
  output wire                     rpll_ena,
  output wire [8:0]               rpll_fbdiv_sel,
  input  wire                     rpll_fbclk,
  
  output wire [4:0]               rpll_int_ctrl,
  output wire [7:0]               rpll_mode,
  output wire [1:0]               rpll_pfd_mode,
  output wire [1:0]               rpll_post_div_sel,
  output wire [1:0]               rpll_prop_c_ctrl,
  output wire [4:0]               rpll_prop_ctrl,
  output wire [1:0]               rpll_prop_r_ctrl,
  input  wire                     rpll_refclk,
  output wire                     rpll_ret,
  output wire                     rpll_reset,
  output wire                     rpll_sel_refclk_alt
);


wire          apb_clk_scan;
wire          apb_reset_scan;
wire          refclk_scan;
wire          refclk_reset_scan;
wire          fbclk_scan;
wire          fbclk_reset_scan;
wire          div16_clk_scan;
wire          div16_clk_reset_scan;
wire          swi_core_reset_muxed;
wire          swi_core_ret_muxed;




assign core_refclk = refclk_scan;

rpll_clk_control u_rpll_clk_control (
  .core_scan_asyncrst_ctrl     ( core_scan_asyncrst_ctrl      ),      
  .core_scan_clk               ( core_scan_clk                ),      
  .core_scan_mode              ( core_scan_mode               ),      
  .apb_clk                     ( apb_clk                      ),  
  .apb_reset                   ( apb_reset                    ),  
  .apb_clk_scan                ( apb_clk_scan                 ),  
  .apb_reset_scan              ( apb_reset_scan               ),  
  .core_reset                  ( swi_core_reset_muxed         ),  
  .refclk                      ( rpll_refclk                  ),      
  .refclk_scan                 ( refclk_scan                  ),        
  .refclk_reset_scan           ( refclk_reset_scan            ),      
  .clk_div16                   ( rpll_clk_div16               ),      
  .clk_div16_scan              ( clk_div16_scan               ),        
  .clk_div16_reset_scan        ( clk_div16_reset_scan         ),    
  .fbclk                       ( rpll_fbclk                   ),  
  .fbclk_scan                  ( fbclk_scan                   ),      
  .fbclk_reset_scan            ( fbclk_reset_scan             )); 


wire          pll_reset_sm;
wire          pll_en_sm;
wire          freq_detect_lock;
wire  [7:0]   swi_bias_settle_count;
wire  [7:0]   swi_pre_locking_count;
wire          swi_disable_lock_det_after_lock;
wire          en_lock_det;
wire          swi_en_lock_det_muxed;
wire          en_fastlock;
wire          fastlock_ready;
wire          ready_sm;
wire          loss_of_lock;
wire [3:0]    fsm_state;

wire  [15:0]  swi_ret_per_training_wait;
wire  [7:0]   swi_ret_per_training_time;
wire  [15:0]  swi_ret_exit_timeout;
wire          pll_ret;
wire          ret_exit_timeout;
wire          swi_ret_lock_det_en_muxed;
wire          en_ret_lock_det;
wire          ret_lock_det_locked;

rpll_sm u_rpll_sm (
  .clk                                 ( refclk_scan                          ),  
  .reset                               ( refclk_reset_scan                    ),  
  .enable                              ( ~refclk_reset_scan                   ),  
  .swi_bias_settle_count               ( swi_bias_settle_count                ),  
  .swi_pre_locking_count               ( swi_pre_locking_count                ),  
  .swi_disable_lock_det_after_lock     ( swi_disable_lock_det_after_lock      ),  
  .core_ret                            ( swi_core_ret_muxed                   ),  
  .swi_ret_per_training_wait           ( swi_ret_per_training_wait            ),  
  .swi_ret_per_training_time           ( swi_ret_per_training_time            ),  
  .swi_ret_exit_timeout                ( swi_ret_exit_timeout                 ),  
  .ret_mode_locked                     ( ret_lock_det_locked                  ),
  .pll_en                              ( pll_en_sm                            ),  
  .pll_ret                             ( pll_ret                              ),  
  .en_lock_det                         ( en_lock_det                          ),  
  .en_ret_lock_det                     ( en_ret_lock_det                      ),
  .en_fastlock                         ( en_fastlock                          ),  
  .locked                              ( freq_detect_lock                     ),  
  .pll_reset                           ( pll_reset_sm                         ),  
  .fastlock_ready                      ( fastlock_ready                       ),  
  .ready                               ( ready_sm                             ),  
  .loss_of_lock                        ( loss_of_lock                         ),  
  .ret_exit_timeout                    ( ret_exit_timeout                     ),  
  .fsm_state                           ( fsm_state                            )); 

wire  [7:0]   swi_ret_lock_refclk_cycles;
wire  [15:0]  swi_ret_lock_div16_cycles;
wire  [7:0]   swi_ret_lock_div16_range;
wire  [15:0]  ret_lock_cycles;

pll_freq_detect #(
  //parameters
  .FB_WIDTH           ( 17        ),
  .REF_WIDTH          ( 8         )
) u_ret_lock_detect (
  .ref_clk     ( refclk_scan                        ),     
  .ref_reset   ( refclk_reset_scan                  ),     
  .fb_clk      ( clk_div16_scan                     ),     
  .fb_reset    ( clk_div16_reset_scan               ),     
  .enable      ( swi_ret_lock_det_en_muxed          ),  
  .range       ( swi_ret_lock_div16_range           ),        
  .ref_cycles  ( swi_ret_lock_refclk_cycles         ),  
  .fb_target   ( {1'b0, swi_ret_lock_div16_cycles}  ),     
  .fb_cycles   ( ret_lock_cycles                    ),         
  .match       ( ret_lock_det_locked                )); 



wire [15:0]   swi_ld_refclk_cycles;
wire [5:0]    swi_ld_range;
wire [15:0]   swi_fastld_refclk_cycles;
wire [5:0]    swi_fastld_range;
wire [5:0]    fd_range_sel;
wire [15:0]   fd_refclk_cycles_sel;
wire [16:0]   freq_detect_cycles;

assign fd_range_sel         = en_fastlock ? swi_fastld_range          : swi_ld_range;
assign fd_refclk_cycles_sel = en_fastlock ? swi_fastld_refclk_cycles  : swi_ld_refclk_cycles;

pll_freq_detect #(
  //parameters
  .FB_WIDTH           ( 17        ),
  .REF_WIDTH          ( 16        )
) u_pll_freq_detect (
  .ref_clk     ( refclk_scan                    ),     
  .ref_reset   ( refclk_reset_scan              ),     
  .fb_clk      ( fbclk_scan                     ),     
  .fb_reset    ( fbclk_reset_scan               ),     
  .enable      ( swi_en_lock_det_muxed          ),  
  .range       ( fd_range_sel                   ),        
  .ref_cycles  ( fd_refclk_cycles_sel           ),  
  .fb_target   ( {1'b0, fd_refclk_cycles_sel}   ),     
  .fb_cycles   ( freq_detect_cycles             ),         
  .match       ( freq_detect_lock               )); 



wire          swi_ssc_enable;
wire  [9:0]   swi_ssc_stepsize;
wire  [16:0]  swi_ssc_amp;
wire          swi_ssc_count_cycles;
wire          swi_ssc_center_spread;
wire  [17:0]  sscout;

pll_ssc #(
  //parameters
  .AMPLITUDE_WIDTH    ( 17        ),
  .SSC_WIDTH          ( 18        ),
  .STEPSIZE_WIDTH     ( 10        )
) u_pll_ssc (
  .clk             ( fbclk_scan                   ),  
  .reset           ( fbclk_reset_scan             ),  
  .stepsize        ( swi_ssc_stepsize             ),  
  .amplitude       ( swi_ssc_amp                  ),  
  .enable          ( swi_ssc_enable & core_ready  ),  
  .count_cycles    ( swi_ssc_count_cycles         ),  
  .centerspread    ( swi_ssc_center_spread        ),  
  .sscout          ( sscout                       )); 

wire [8:0]      mash_divout;
wire [8:0]      swi_vco_int;
wire [15:0]     swi_vco_frac;


pll_mash u_pll_mash (
  .clk             ( fbclk_scan             ),  
  .reset           ( fbclk_reset_scan       ),  
  .frac            ( swi_vco_frac           ),  
  .sscoffsetin     ( sscout                 ),  
  .intg            ( swi_vco_int            ),  
  .frac_en         ( (|swi_vco_frac)        ),  
  .divout          ( mash_divout            )); 


wire  [4:0]     swi_normal_prop_gain;
wire  [4:0]     swi_normal_int_gain;
wire  [4:0]     swi_fl_int_gain;
wire  [4:0]     swi_fl_prop_gain;
wire [4:0]      int_gain_sel;
wire [4:0]      prop_gain_sel;

assign int_gain_sel   = en_fastlock ? swi_fl_int_gain   : swi_normal_int_gain;
assign prop_gain_sel  = en_fastlock ? swi_fl_prop_gain  : swi_normal_prop_gain;



wire    w1c_out_core_ready_int;
wire    w1c_out_core_loss_lock_int;
wire    w1c_out_retention_exit_to_int;
wire    swi_core_ready_int_en;
wire    swi_core_loss_lock_int_en;
wire    swi_retention_exit_to_int_en;


assign core_interrupt = w1c_out_core_ready_int ||
                        w1c_out_core_loss_lock_int;

rpll_regs_regs_top u_rpll_regs_regs_top (
  .core_reset                          ( core_reset                                 ), 
  .swi_core_reset_muxed                ( swi_core_reset_muxed                       ), 
  .core_ready_ov                       ( ready_sm                                   ),  
  .swi_core_ready_ov_muxed             ( core_ready                                 ), 
  .core_ret                            ( core_ret                                   ),  
  .swi_core_ret_muxed                  ( swi_core_ret_muxed                         ),  
  .core_ready                          ( core_ready                                 ), 
  .core_fastlock_ready                 ( fastlock_ready                             ),  
  .freq_detect_lock                    ( freq_detect_lock                           ), 
  .freq_detect_cycles                  ( freq_detect_cycles                         ),  
  .fsm_state                           ( fsm_state                                  ),  
  .w1c_in_core_ready_int               ( core_ready && swi_core_ready_int_en        ),  
  .w1c_out_core_ready_int              ( w1c_out_core_ready_int                     ),  
  .w1c_in_core_loss_lock_int           ( loss_of_lock && swi_core_loss_lock_int_en  ),  
  .w1c_out_core_loss_lock_int          ( w1c_out_core_loss_lock_int                 ),  
  .w1c_in_retention_exit_to_int        ( ret_exit_timeout &&
                                         swi_retention_exit_to_int_en               ), 
  .w1c_out_retention_exit_to_int       ( w1c_out_retention_exit_to_int              ),  
  .swi_core_ready_int_en               ( swi_core_ready_int_en                      ),  
  .swi_core_loss_lock_int_en           ( swi_core_loss_lock_int_en                  ),  
  .swi_retention_exit_to_int_en        ( swi_retention_exit_to_int_en               ),  
  .swi_vco_int                         ( swi_vco_int                                ),  
  .swi_vco_frac                        ( swi_vco_frac                               ),  
  .swi_post_div_sel                    ( rpll_post_div_sel                          ),
  .swi_ssc_enable                      ( swi_ssc_enable                             ),  
  .swi_ssc_stepsize                    ( swi_ssc_stepsize                           ),  
  .swi_ssc_amp                         ( swi_ssc_amp                                ),  
  .swi_ssc_count_cycles                ( swi_ssc_count_cycles                       ),  
  .swi_ssc_center_spread               ( swi_ssc_center_spread                      ),  
  .swi_ret_per_training_wait           ( swi_ret_per_training_wait                  ),  
  .swi_ret_per_training_time           ( swi_ret_per_training_time                  ),  
  .swi_ret_exit_timeout                ( swi_ret_exit_timeout                       ),  
  .swi_ret_lock_refclk_cycles          ( swi_ret_lock_refclk_cycles                 ),  
  .swi_ret_lock_div16_cycles           ( swi_ret_lock_div16_cycles                  ),  
  .swi_ret_lock_div16_range            ( swi_ret_lock_div16_range                   ),  
  .ret_lock_det_en                     ( en_ret_lock_det                            ),  
  .swi_ret_lock_det_en_muxed           ( swi_ret_lock_det_en_muxed                  ),  
  .ret_lock_det_locked                 ( ret_lock_det_locked                        ),  
  .ret_lock_cycles                     ( ret_lock_cycles                            ),  
  .swi_bias_settle_count               ( swi_bias_settle_count                      ),  
  .swi_pre_locking_count               ( swi_pre_locking_count                      ),  
  .swi_disable_lock_det_after_lock     ( swi_disable_lock_det_after_lock            ),  
  .swi_normal_prop_gain                ( swi_normal_prop_gain                       ),  
  .swi_normal_int_gain                 ( swi_normal_int_gain                        ),  
  .swi_fl_int_gain                     ( swi_fl_int_gain                            ),  
  .swi_fl_prop_gain                    ( swi_fl_prop_gain                           ),  
  .int_gain                            ( int_gain_sel                               ),  
  .swi_int_gain_muxed                  ( rpll_int_ctrl                              ),  
  .prop_gain                           ( prop_gain_sel                              ),  
  .swi_prop_gain_muxed                 ( rpll_prop_ctrl                             ),  
  .swi_ld_refclk_cycles                ( swi_ld_refclk_cycles                       ),  
  .swi_ld_range                        ( swi_ld_range                               ),  
  .swi_fastld_refclk_cycles            ( swi_fastld_refclk_cycles                   ),  
  .swi_fastld_range                    ( swi_fastld_range                           ),  
  .pll_en                              ( pll_en_sm                                  ),  
  .swi_pll_en_muxed                    ( rpll_ena                                   ),  
  .pll_reset                           ( pll_reset_sm                               ),
  .swi_pll_reset_muxed                 ( rpll_reset                                 ),
  .pll_ret                             ( pll_ret                                    ),  
  .swi_pll_ret_muxed                   ( rpll_ret                                   ),  
  .fbdiv_sel                           ( mash_divout                                ),  
  .swi_fbdiv_sel_muxed                 ( rpll_fbdiv_sel                             ),  
  .swi_bias_lvl                        ( rpll_bias_lvl                              ),  
  .swi_cp_int_mode                     ( rpll_cp_int_mode                           ),  
  .en_lock_det                         ( en_lock_det                                ), 
  .swi_en_lock_det_muxed               ( swi_en_lock_det_muxed                      ), 
  .swi_dtest_sel                       ( rpll_dtest_sel                             ), 
  .swi_mode_extra                      ( rpll_mode                                  ), 
  .swi_byp_clk_sel                     ( rpll_byp_clk_sel                           ),  
  .swi_dbl_clk_sel                     ( rpll_dbl_clk_sel                           ),  
  .swi_bias_sel                        ( rpll_bias_sel                              ),
  .swi_prop_c_ctrl                     ( rpll_prop_c_ctrl                           ),  
  .swi_prop_r_ctrl                     ( rpll_prop_r_ctrl                           ),  
  .swi_pfd_mode                        ( rpll_pfd_mode                              ),  
  .swi_sel_refclk_alt                  ( rpll_sel_refclk_alt                        ),  
  .debug_bus_ctrl_status               (                                            ),  
  .dft_core_scan_mode                  ( core_scan_mode                             ), 
  .dft_iddq_mode                       ( iddq_mode                                  ), 
  .dft_hiz_mode                        ( 1'b0                                       ),
  .dft_bscan_mode                      ( bscan_mode                                 ), 
  .dft_bscan_tck                       ( bscan_tck                                  ),  
  .dft_bscan_trst_n                    ( bscan_trst_n                               ),  
  .dft_bscan_capturedr                 ( bscan_capturedr                            ),  
  .dft_bscan_shiftdr                   ( bscan_shiftdr                              ), 
  .dft_bscan_updatedr                  ( bscan_updatedr                             ), 
  .dft_bscan_tdi                       ( bscan_tdi                                  ), 
  .dft_bscan_tdo                       ( bscan_tdo                                  ), 
  .RegReset                            ( apb_reset_scan                             ),  
  .RegClk                              ( apb_clk_scan                               ),  
  .PSEL                                ( apb_psel                                   ),  
  .PENABLE                             ( apb_penable                                ),  
  .PWRITE                              ( apb_pwrite                                 ),  
  .PSLVERR                             ( apb_pslverr                                ),  
  .PREADY                              ( apb_pready                                 ),  
  .PADDR                               ( apb_paddr                                  ),  
  .PWDATA                              ( apb_pwdata                                 ),  
  .PRDATA                              ( apb_prdata                                 )); 

endmodule
 

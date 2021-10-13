module rpll_clk_control(
  input  wire     core_scan_asyncrst_ctrl,                   
  input  wire     core_scan_clk,                             
  input  wire     core_scan_mode,   
  
  input  wire     apb_clk,
  input  wire     apb_reset,
  output wire     apb_clk_scan,
  output wire     apb_reset_scan,
  
  input  wire     core_reset,
  
  input  wire     refclk,
  output wire     refclk_scan,
  output wire     refclk_reset_scan,
  
  input  wire     clk_div16,
  output wire     clk_div16_scan,
  output wire     clk_div16_reset_scan,
  
  input  wire     fbclk,
  output wire     fbclk_scan,
  output wire     fbclk_reset_scan
);
  
wav_clock_mux  u_wav_clock_mux_apb_clk_scan (
  .clk0    ( apb_clk          ),  
  .clk1    ( core_scan_clk    ),  
  .sel     ( core_scan_mode   ),  
  .clk_out ( apb_clk_scan     )); 

wav_reset_sync u_wav_reset_sync_apb_clk_reset (
  .clk           ( apb_clk_scan            ),  
  .scan_ctrl     ( core_scan_asyncrst_ctrl ),  
  .reset_in      ( apb_reset               ),  
  .reset_out     ( apb_reset_scan          )); 



wav_clock_mux  u_wav_clock_mux_refclk_scan (
  .clk0    ( refclk           ),  
  .clk1    ( core_scan_clk    ),  
  .sel     ( core_scan_mode   ),  
  .clk_out ( refclk_scan      )); 

wav_reset_sync u_wav_reset_sync_refclk_reset (
  .clk           ( refclk_scan             ),  
  .scan_ctrl     ( core_scan_asyncrst_ctrl ),  
  .reset_in      ( core_reset              ),  
  .reset_out     ( refclk_reset_scan       )); 



wav_clock_mux  u_wav_clock_mux_clk_div16_scan (
  .clk0    ( clk_div16        ),  
  .clk1    ( core_scan_clk    ),  
  .sel     ( core_scan_mode   ),  
  .clk_out ( clk_div16_scan   )); 

wav_reset_sync u_wav_reset_sync_clk_div16_reset (
  .clk           ( clk_div16_scan          ),  
  .scan_ctrl     ( core_scan_asyncrst_ctrl ),  
  .reset_in      ( core_reset              ),  
  .reset_out     ( clk_div16_reset_scan    )); 


wav_clock_mux  u_wav_clock_mux_fbclk_scan (
  .clk0    ( fbclk            ),  
  .clk1    ( core_scan_clk    ),  
  .sel     ( core_scan_mode   ),  
  .clk_out ( fbclk_scan       )); 

wav_reset_sync u_wav_reset_sync_fbclk_reset (
  .clk           ( fbclk_scan              ),  
  .scan_ctrl     ( core_scan_asyncrst_ctrl ),  
  .reset_in      ( core_reset              ),  
  .reset_out     ( fbclk_reset_scan        ));  

  
endmodule

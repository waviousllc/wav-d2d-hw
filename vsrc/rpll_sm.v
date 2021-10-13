module rpll_sm(
  input  wire         clk,
  input  wire         reset,
  
  input  wire         enable,
  input  wire [7:0]   swi_bias_settle_count,
  input  wire [7:0]   swi_pre_locking_count,
  input  wire         swi_disable_lock_det_after_lock,
  
  input  wire         core_ret,
  input  wire [15:0]  swi_ret_per_training_wait,
  input  wire [7:0]   swi_ret_per_training_time,
  input  wire [15:0]  swi_ret_exit_timeout,
  input  wire         ret_mode_locked,
  
  output reg          pll_en,
  output reg          pll_ret,
  output reg          en_lock_det,
  output reg          en_ret_lock_det,
  output reg          en_fastlock,
  input  wire         locked,
  output reg          pll_reset,
  output reg          fastlock_ready,
  output reg          ready,
  output reg          loss_of_lock,
  output reg          ret_exit_timeout,
  output wire [3:0]   fsm_state
  
);


localparam    IDLE            = 'd0,
              BIAS_SETTLE     = 'd1,
              FASTLOCKING     = 'd2,
              PRE_LOCKING     = 'd3,
              LOCKING         = 'd4,
              PLL_LOCKED      = 'd5,
              RETEN           = 'd6,
              RETEN_PER       = 'd7,
              RETEN_LOCKING   = 'd8;

reg  [3:0]    state, nstate;
reg  [15:0]   count, count_in;
reg           en_lock_det_in;
reg           en_fastlock_in;
reg           fastlock_ready_in;
reg           loss_of_lock_in;
reg           pll_reset_in;
wire          locked_ff2;
reg           ready_in;
reg           pll_en_in;
reg           pll_ret_in;
reg           ret_exit_timeout_in;
reg           en_ret_lock_det_in;
wire          core_ret_ff2;
wire          ret_mode_locked_ff2;

demet_reset u_demet_reset[3:0] (
  .clk     ( clk                    ),              
  .reset   ( reset                  ),              
  .sig_in  ( {ret_mode_locked,
              core_ret,
              locked,
              enable}               ),   
  .sig_out ( {ret_mode_locked_ff2,
              core_ret_ff2,
              locked_ff2,
              enable_ff2}           )); 


assign fsm_state = state;

always @(posedge clk or posedge reset) begin
  if(reset) begin
    state               <= IDLE;
    count               <= 'd0;
    en_lock_det         <= 1'b0;
    en_fastlock         <= 1'b0;
    fastlock_ready      <= 1'b0;
    loss_of_lock        <= 1'b0;
    pll_reset           <= 1'b1;
    ready               <= 1'b0;
    pll_en              <= 1'b0;
    pll_ret             <= 1'b0;
    ret_exit_timeout    <= 1'b0;
    en_ret_lock_det     <= 1'b0;
  end else begin
    state               <= nstate;
    count               <= count_in;
    en_lock_det         <= en_lock_det_in;
    en_fastlock         <= en_fastlock_in;
    fastlock_ready      <= fastlock_ready_in;
    loss_of_lock        <= loss_of_lock_in;
    pll_reset           <= pll_reset_in;
    ready               <= ready_in;
    pll_en              <= pll_en_in;
    pll_ret             <= pll_ret_in;
    ret_exit_timeout    <= ret_exit_timeout_in;
    en_ret_lock_det     <= en_ret_lock_det_in;
  end
end


always @(*) begin
  nstate                  = state;
  count_in                = 'd0;
  en_lock_det_in          = en_lock_det;
  en_fastlock_in          = en_fastlock;
  fastlock_ready_in       = fastlock_ready;
  loss_of_lock_in         = 1'b0;
  pll_reset_in            = pll_reset;
  ready_in                = 1'b0;
  pll_en_in               = pll_en;
  pll_ret_in              = 1'b0;
  ret_exit_timeout_in     = ret_exit_timeout;
  en_ret_lock_det_in      = 1'b0;
  
  case(state)
    //---------------------------------
    IDLE : begin
      pll_en_in           = 1'b0;
      pll_reset_in        = 1'b1;
      if(enable_ff2) begin
        pll_en_in         = 1'b1;
        count_in          = 'd0;
        nstate            = BIAS_SETTLE;
      end
    end
    
    //---------------------------------
    BIAS_SETTLE : begin
      if(count == swi_bias_settle_count) begin
        count_in          = 'd0;
        pll_reset_in      = 1'b0;
        en_lock_det_in    = 1'b1;
        en_fastlock_in    = 1'b1;
        nstate            = FASTLOCKING;
      end else begin
        count_in          = count + 'd1;
      end
      
      //for fast sims
      `ifdef SIMULATION
      if ($test$plusargs("RPLL_FORCE_PLL_LOCK")) begin 
        nstate            = PLL_LOCKED;
      end  
      `endif
    end
    
    //---------------------------------
    FASTLOCKING : begin
      if(locked_ff2) begin
        en_lock_det_in    = 1'b0;
        en_fastlock_in    = 1'b0;
        fastlock_ready_in = 1'b1;
        nstate            = PRE_LOCKING;
      end 
    end
    
    
    //---------------------------------
    //Switch to Normal lock settings
    PRE_LOCKING : begin
      en_lock_det_in      = 1'b0;
      if(count == swi_pre_locking_count) begin
        nstate            = LOCKING;
        en_lock_det_in    = 1'b1;
      end else begin
        count_in          = count + 'd1;
      end
    end
    
    //---------------------------------
    LOCKING : begin
      if(locked_ff2) begin
        ready_in          = 1'b1;
        nstate            = PLL_LOCKED;
      end   
    end
    
    
    //---------------------------------
    PLL_LOCKED : begin
      ret_exit_timeout_in = 1'b0;
      en_lock_det_in      = ~swi_disable_lock_det_after_lock; //Save power bruddha
      ready_in            = 1'b1;
      loss_of_lock_in     = ~locked_ff2 & ~swi_disable_lock_det_after_lock;
      
      //for fast sims (ignore loss of lock)
      `ifdef SIMULATION
      if ($test$plusargs("RPLL_FORCE_PLL_LOCK")) begin 
        loss_of_lock_in   = 1'b0;
      end  
      `endif
      
      if(core_ret_ff2) begin
        en_lock_det_in    = 1'b0;
        pll_ret_in        = 1'b1;
        count_in          = 'd0;
        nstate            = RETEN;
      end
    end
    
    //---------------------------------
    RETEN : begin
      pll_ret_in            = 1'b1;
      
      if(count == swi_ret_per_training_wait) begin
        if(|swi_ret_per_training_wait) begin  //if 0 do nothing
          count_in          = 'd0;
          pll_ret_in        = 1'b0;
          en_ret_lock_det_in= 1'b1;
          nstate            = RETEN_LOCKING;
        end
      end else begin
        count_in            = count + 'd1;
      end
      
      if(~core_ret_ff2) begin
        count_in            = 'd0;
        pll_ret_in          = 1'b0;
        en_ret_lock_det_in  = 1'b1;
        nstate              = RETEN_LOCKING;
      end
    end
    
    //---------------------------------
    /*RETEN_PER : begin
      if(count == swi_ret_per_training_time) begin
        count_in          = 'd0;
        pll_ret_in        = 1'b1;
        nstate            = RETEN;
      end else begin
        count_in          = count + 'd1;
      end
    end*/
    
    //---------------------------------
    RETEN_LOCKING : begin
      en_ret_lock_det_in    = 1'b1;
      
      if(count == swi_ret_exit_timeout) begin
        pll_en_in           = 1'b0;
        pll_reset_in        = 1'b1;
        ret_exit_timeout_in = 1'b1;
        nstate              = IDLE;
      end else begin
        count_in            = count + 'd1;
      end
      
      if(ret_mode_locked_ff2) begin
        en_ret_lock_det_in  = 1'b0;
        ready_in            = ~core_ret_ff2;
        count_in            = 'd0;
        nstate              = core_ret_ff2 ? RETEN : PLL_LOCKED;
      end  
    end
    
  endcase
end


endmodule

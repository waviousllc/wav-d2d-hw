package wav.common

import chisel3._
import chisel3.util._
import chisel3.util.HasBlackBoxInline
import freechips.rocketchip.config._

import freechips.rocketchip.config.{Parameters, Field, Config}



class wav_pi_control_encode()(implicit p: Parameters) extends BlackBox with HasBlackBoxInline{
  val io = IO(new Bundle{
    val clk       = Input (Bool())
    val reset     = Input (Bool())
    val oneup     = Input (Bool())
    val onedown   = Input (Bool())
    val pi_bin    = Output(UInt(6.W))
    val pi_ctrl   = Output(UInt(16.W))
    val pi_quad   = Output(UInt(2.W))
  })
  
  var prefix = if(p(WavComponentPrefix) != None) p(WavComponentPrefix)+"_" else ""
  override val desiredName = s"${prefix}wav_pi_control_encode" 
  
  setInline(s"${desiredName}.v",
    s"""module ${desiredName}(
      |   input  wire         clk,
      |   input  wire         reset,
      |   input  wire         oneup,
      |   input  wire         onedown,
      |   output reg  [5:0]   pi_bin,
      |   output reg  [15:0]  pi_ctrl,
      |   output reg  [1:0]   pi_quad
      |  );
      |
      |  reg  [1:0]   pi_quad_nxtup;
      |  reg  [1:0]   pi_quad_nxtdown;
      |  wire         quaddown;
      |  wire         quadup;
      |  wire [1:0]   pi_quad_in;
      |  wire [15:0]  pi_ctrl_in;
      |  wire [3:0]   pi_bin_low_in;
      |  wire [1:0]   pi_bin_high_in;
      |
      |
      |  assign pi_ctrl_in  = oneup   ? (pi_quad[1]^pi_quad[0]) ? {1'b1, pi_ctrl[15:1]} : {1'b0, pi_ctrl[15:1]} :
      |                       onedown ? {pi_ctrl[14:0], ~pi_ctrl[15]} : pi_ctrl;
      |
      |  assign quaddown    = onedown & ((pi_ctrl == 16'h0000) || (pi_ctrl == 16'hffff));
      |  assign quadup      = oneup   & ((pi_ctrl == 16'hFFFE) || (pi_ctrl == 16'h0001));
      |  assign pi_quad_in  = quaddown ? pi_quad_nxtdown : (quadup ? pi_quad_nxtup : pi_quad);
      |
      |  //assign pi_bin_in    = oneup ? pi_bin + 1'b1 ? onedown ? pi_bin - 1'b1 : pi_bin;
      |  assign pi_bin_low_in  = oneup ? pi_bin[3:0] + 1'b1 : onedown ? pi_bin[3:0] - 1'b1 : pi_bin[3:0];
      |  //assign pi_quad_in   = (pi_bin_in[5:4] == 2'b00) ? 2'b01 : (pi_bin_in[5:4] == 2'b01) ? 2'b00 : pi_bin_in[5:4];
      |  assign pi_bin_high_in = (pi_quad_in == 2'b01) ? 2'b00 : (pi_quad_in == 2'b00) ? 2'b01 : pi_quad_in;
      |
      |always @(posedge clk or posedge reset) begin
      |  if (reset == 1'b1) begin
      |    pi_bin  <= 6'b000000;
      |    pi_ctrl <= 16'h0000;
      |    pi_quad <= 2'b01;
      |  end else begin
      |    pi_bin  <= {pi_bin_high_in, pi_bin_low_in};
      |    pi_ctrl <= pi_ctrl_in;
      |    pi_quad <= pi_quad_in;
      |  end
      |end
      |
      |// pi_quad is gray coded
      |
      |always @(*) begin
      |  case (pi_quad)
      |    2'b00 : pi_quad_nxtdown = 2'b01;
      |    2'b01 : pi_quad_nxtdown = 2'b11;
      |    2'b11 : pi_quad_nxtdown = 2'b10;
      |    2'b10 : pi_quad_nxtdown = 2'b00;
      |  endcase
      |end
      |
      |always @(*) begin
      |  case (pi_quad)
      |    2'b00 : pi_quad_nxtup = 2'b10;
      |    2'b01 : pi_quad_nxtup = 2'b00;
      |    2'b11 : pi_quad_nxtup = 2'b01;
      |    2'b10 : pi_quad_nxtup = 2'b11;
      |  endcase
      |end
      |
      |endmodule
    """.stripMargin)
}


class wav_phase_detector(
  width   : Int,
  ileadq  : Int = 0
) extends BlackBox (Map(
  "WIDTH"   -> width,
  "ILEADQ"  -> ileadq
)) {
  val io = IO(new Bundle{
    val clk     = Input (Bool())
    val reset   = Input (Bool())
    val enable  = Input (Bool())
    val idata   = Input (UInt(width.W))
    val qdata   = Input (UInt(width.W))
    val up      = Output(Bool())                 
    val dn      = Output(Bool())
  })
}


class wav_sigdelt(width : Int = 7)(implicit p: Parameters)  extends BlackBox (Map("WIDTH" -> width)) with HasBlackBoxInline{
  val io = IO(new Bundle{
    val clk       = Input (Bool())
    val reset     = Input (Bool())
    val clear     = Input (Bool())
    val addin     = Input (UInt(width.W))
    val sumout    = Output(UInt(width.W))
    val polarity  = Output(Bool())
    val overflow  = Output(Bool())
  })
  
  var prefix = if(p(WavComponentPrefix) != None) p(WavComponentPrefix)+"_" else ""
  override val desiredName = s"${prefix}wav_sigdelt" 
  
  //setInline(s"${prefix}wav_sigdelt.v",
  setInline(s"${desiredName}.v",
    s"""module ${desiredName}
      | #(
      |   parameter                  WIDTH                    = 7,
      |   parameter                  REGISTER_OUTPUTS         = 0
      |  )
      |  (
      |   input  wire                clk,
      |   input  wire                reset,
      |   input  wire                clear,
      |   input  wire [WIDTH-1:0]    addin,
      |   output reg  [WIDTH-1:0]    sumout,
      |   output reg                 polarity,
      |   output reg                 overflow
      |  );
      |
      |  wire [WIDTH:0]              se_addin;
      |  wire [WIDTH:0]              se_rem;
      |  wire [WIDTH+1:0]            addout_in;
      |  reg  [WIDTH:0]              addout_ff;
      |
      |  assign se_addin   = {addin[WIDTH-1], addin};
      |  assign se_rem     = {addout_ff[WIDTH], addout_ff[WIDTH], addout_ff[WIDTH-2:0]};
      |  assign addout_in  = se_addin + se_rem;
      |
      |  always @(posedge clk or posedge reset) begin
      |    if (reset) begin
      |      addout_ff  <= {WIDTH+1{1'b0}};
      |      sumout     <= {WIDTH{1'b0}};
      |      polarity   <= 1'b0;
      |      overflow   <= 1'b0;
      |    end else begin
      |      addout_ff  <= clear ? {WIDTH+1{1'b0}} : addout_in[WIDTH:0];
      |      sumout     <= {addout_in[WIDTH], addout_in[WIDTH-2:0]};
      |      polarity   <= addout_in[WIDTH];
      |      overflow   <= addout_in[WIDTH]^addout_in[WIDTH-1];
      |    end
      |  end
      |
      |endmodule
    """.stripMargin)
}

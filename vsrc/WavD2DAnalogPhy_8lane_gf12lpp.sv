// Verilog netlist of
// "WavD2DAnalogPhy_8lane_gf12lpp"

// HDL models

// HDL file - wavshared_gf12lp_dig_lib, LAT_D1_GL16_SLVT, systemVerilog.

//systemVerilog HDL for "wavshared_tsmc12ffc_lib", "LAT_D1_GL16_LVT" "systemVerilog"

`timescale 1ps/1ps
module WavD2DAnalogPhy_8lane_gf12lpp_LAT_D1_GL16_SLVT( q, clk, clkb, d
`ifdef WLOGIC_MODEL_NO_TIE
`else
, tiehi, tielo
`endif //WLOGIC_MODEL_NO_TIE
`ifdef WLOGIC_MODEL_NO_PG
`else
, vss, vdd 
`endif //WLOGIC_MODEL_NO_PG
); 
 
  input clk;
  output q;  
  input d;
  input clkb;
`ifdef WLOGIC_MODEL_NO_TIE
`else
  input tiehi;
  input tielo;
`endif //WLOGIC_MODEL_NO_TIE
`ifdef WLOGIC_MODEL_NO_PG
`else
  inout vdd;
  inout vss;
`endif //WLOGIC_MODEL_NO_PG


  wire #0 polarity_ok = clk^clkb;

`ifdef WLOGIC_MODEL_NO_TIE
`else

`ifdef WLOGIC_TIE_CHECK
  wire signals_ok;
  assign signals_ok = tiehi & ~tielo;

  assign q = (signals_ok) ? 1'bz : 1'bx;
`endif // WLOGIC_TIE_CHECK

`endif //WLOGIC_MODEL_NO_TIE


`ifdef WLOGIC_MODEL_NO_PG
`else

`ifdef WLOGIC_PWR_CHECK
  wire   power_ok;
  assign power_ok = ~vss & vdd;
 
  assign q = (power_ok) ? 1'bz : 1'bx;
 
`endif //WLOGIC_PWR_CHECK

`endif //WLOGIC_MODEL_NO_PG

assign #1  q = polarity_ok ?
                           (clkb) ?
                                  (d===1'bx) ? $random : d
                                  : q
                           : 1'bx;


endmodule


// HDL file - wphy_gf12lp_d2d_serdes_lib, LAT_D1_GL40_SLVT_HZ, functional.

//Verilog HDL for "wmx_d2d_serdes_lib", "wmx_LAT_D1_GL16_LVT_HZ" "functional"

`timescale 1ps/1ps
module WavD2DAnalogPhy_8lane_gf12lpp_LAT_D1_GL40_SLVT_HZ ( q, vdda, vss, clk, clkb, d );

  output q;
  inout vdda;
  input d;
  input clk;
  input clkb;
  inout vss;

  reg q_int;
  reg q;

  initial begin
    q_int = $random;
  end

always @(*) begin
  if(~clk) begin
	q_int = (d === 1'bx) ? $random : d;
  end 
end 

always @(*) begin
#1	q=clk ? q_int : 1'bz;
end

endmodule

// HDL file - wphy_gf12lp_d2d_serdes_lib, LAT_D2_GL16_LVT_HZ, functional.

//Verilog HDL for "wmx_d2d_serdes_lib", "wmx_LAT_D1_GL16_LVT_HZ" "functional"

`timescale 1ps/1ps
module WavD2DAnalogPhy_8lane_gf12lpp_LAT_D2_GL16_LVT_HZ ( q, vdda, vss, clk, clkb, d );

  output q;
  inout vdda;
  input d;
  input clk;
  input clkb;
  inout vss;

  reg q_int;
  reg q;

  initial begin
    q_int = $random;
  end

always @(*) begin
  if(~clk) begin
	q_int = (d === 1'bx) ? $random : d;
  end 
end 

always @(*) begin
#1	q=clk ? q_int : 1'bz;
end

endmodule

// HDL file - wphy_gf12lp_d2d_serdes_lib, LAT_D1_GL16_LVT_HZ, functional.

//Verilog HDL for "wmx_d2d_serdes_lib", "wmx_LAT_D1_GL16_LVT_HZ" "functional"

`timescale 1ps/1ps
module WavD2DAnalogPhy_8lane_gf12lpp_LAT_D1_GL16_LVT_HZ ( q, vdda, vss, clk, clkb, d );

  output q;
  inout vdda;
  input d;
  input clk;
  input clkb;
  inout vss;

  reg q_int;
  reg q;

  initial begin
    q_int = $random;
  end

always @(*) begin
  if(~clk) begin
	q_int = (d === 1'bx) ? $random : d;
  end 
end 

always @(*) begin
#1	q=clk ? q_int : 1'bz;
end

endmodule

// HDL file - wavshared_gf12lp_dig_lib, INV_D2_GL16_SLVT, systemVerilog.

//systemVerilog HDL for "wavshared_tsmc12ffc_lib", "INV_D2_GL16_LVT" "systemVerilog"

module WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_SLVT( in, out
`ifdef WLOGIC_MODEL_NO_PG
`else
, vdd, vss
`endif //WLOGIC_MODEL_NO_PG
);

  input in;
  output out;
`ifdef WLOGIC_MODEL_NO_PG
`else
  inout vdd;
  inout vss;
`endif //WLOGIC_MODEL_NO_PG

`ifdef WLOGIC_MODEL_NO_PG
`else

`ifdef WLOGIC_PWR_CHECK
  wire   power_ok;
  assign power_ok = ~vss & vdd;
  
  assign out = (power_ok) ? 1'bz : 1'bx;

`endif //WLOGIC_PWR_CHECK

`endif //WLOGIC_MODEL_NO_PG

   assign out = ~in;

endmodule

// HDL file - wphy_gf12lp_d2d_serdes_lib, d2d_txdly, functional.

//Verilog HDL for "wmx_d2d_serdes_lib", "wmx_d2d_txdly" "functional"

`timescale 1ps/1fs
module WavD2DAnalogPhy_8lane_gf12lpp_d2d_txdly ( outn, outp, vdda, vss, ctrl, gear, inn, inp );

  input gear;
  output outn;
  inout vdda;
  input inp;
  input  [5:0] ctrl;
  output outp;
  input inn;
  inout vss;
wire pwr_ok ;
real minD;
real step;
real D;
reg outp_int, outn_int;

assign pwr_ok = vdda & ~vss;
initial begin
        minD = gear ? 67 : 90 ;
        step = gear ? 0.25 : 0.5;
end

always @(gear or step) begin
  minD = gear ? 67 : 90 ;
        step = gear ? 0.25 : 0.5; //step is really 0.3 and 0.47 but keeping like this for ease of verification
end

always @(ctrl) begin
        D = minD + (ctrl * step);       
end

always @(*) begin
        outp_int <= #D pwr_ok ? inp : 1'bx;
        outn_int <= #D pwr_ok ? inn : 1'bx;
end
assign outp = outp_int;
assign outn = outn_int; 

endmodule

// HDL file - wphy_gf12lp_d2d_serdes_lib, d2d_drv_slice_dum_x2, behavioral.

//Verilog HDL for "wphy_gf12lp_d2d_serdes_lib", "d2d_drv_slice_dum" "behavioral"


module WavD2DAnalogPhy_8lane_gf12lpp_d2d_drv_slice_dum_x2 ( vss );

  inout vss;
endmodule

// HDL file - wphy_gf12lp_d2d_serdes_lib, d2d_lpde, functional.

//Verilog HDL for "wphy_gf12lp_d2d_serdes_lib", "d2d_lpde" "functional"


module WavD2DAnalogPhy_8lane_gf12lpp_d2d_lpde ( outn, vdda, vss, en, inp, sel );

  output outn;
  inout vdda;
  input inp;
  input  [3:0] sel;
  input en;
  inout vss;
parameter min_delay = 100 ;
parameter step_delay = 5 ;
endmodule

// HDL file - wphy_gf12lp_d2d_serdes_lib, d2d_lane_drv_boost, functional.

//Verilog HDL for "wmx_d2d_serdes_lib", "wmx_d2d_lane_drv_boost" "functional"


module WavD2DAnalogPhy_8lane_gf12lpp_d2d_lane_drv_boost ( out, vdda, vss, en_prim, en_sec, enb_prim,
enb_sec, prim, sec );

  input en_prim;
  input en_sec;
  input enb_prim;
  inout vdda;
  output out;
  input prim;
  input enb_sec;
  input sec;
  inout vss;
endmodule

// HDL file - wphy_gf12lp_d2d_serdes_lib, d2d_lane_drv_boost_dum, functional.

//Verilog HDL for "wmx_d2d_serdes_lib", "wmx_d2d_lane_drv_boost_dum" "functional"


module WavD2DAnalogPhy_8lane_gf12lpp_d2d_lane_drv_boost_dum ( vdda, vss );

  inout vdda;
  inout vss;
endmodule

// HDL file - wavshared_gf12lp_dig_lib, DUM_D1_GL16_SLVT, behavioral.

//Verilog HDL for "wavshared_tsmc12ffc_lib", "DUM_D1_GL16_LVT" "functional"


module WavD2DAnalogPhy_8lane_gf12lpp_DUM_D1_GL16_SLVT ( tiehi, tielo, vdd, vss );

  input tiehi;
  input tielo;
  inout vdd;
  inout vss;
endmodule

// HDL file - wphy_gf12lp_d2d_serdes_lib, d2d_drv_slice_dum, behavioral.

//Verilog HDL for "wphy_gf12lp_d2d_serdes_lib", "d2d_drv_slice_dum" "behavioral"


module WavD2DAnalogPhy_8lane_gf12lpp_d2d_drv_slice_dum ( vss );

  inout vss;
endmodule

// HDL file - wphy_gf12lp_d2d_serdes_lib, d2d_drv_slice_v2, functional.

//Verilog HDL for "wmx_d2d_serdes_lib", "wmx_d2d_drv_slice_v2" "functional"


module WavD2DAnalogPhy_8lane_gf12lpp_d2d_drv_slice_v2 ( outp, vddq, vss, en, inn, inp );

  input inp;
  input en;
  inout outp;
  input inn;
  inout vss;
  inout vddq;

assign pwr_ok = vddq & ~vss;
assign (pull0, pull1) outp = pwr_ok ? (~en ? 1'bz : ((~inn & ~inp) ? 1'bz : ((inn & inp) ? 1'bx : inp))) : 1'bx;

endmodule

// HDL file - wphy_gf12lp_d2d_serdes_lib, d2d_INVT_D2_GL16_LVT_withR, behavioral.

//Verilog HDL for "Serdes", "cmos_inv2_tst" "behavioral"


module WavD2DAnalogPhy_8lane_gf12lpp_d2d_INVT_D2_GL16_LVT_withR( in, vdd, vss, out, en, enb );

  inout vss;
  input in;
  inout vdd;
  input en, enb;
  output out;
  wire out;

assign (strong0, strong1) out= (en) ? ~in:1'bz;


endmodule

// HDL file - wphy_gf12lp_d2d_serdes_lib, d2d_clk_drv_boost, functional.

//Verilog HDL for "wmx_d2d_serdes_lib", "wmx_d2d_lane_drv_boost" "functional"


module WavD2DAnalogPhy_8lane_gf12lpp_d2d_clk_drv_boost ( out, vdda, vss, en_prim,  enb_prim, prim,  );

  input en_prim;
  input enb_prim;
  inout vdda;
  output out;
  input prim;
  inout vss;

endmodule

// HDL file - wavshared_gf12lp_dig_lib, INV_D16_GL16_LVT, systemVerilog.

//systemVerilog HDL for "wavshared_ln08lpu_dig_lib", "INV_D16_GL16_LVT" "systemVerilog"


module WavD2DAnalogPhy_8lane_gf12lpp_INV_D16_GL16_LVT ( in, out
`ifdef WLOGIC_MODEL_NO_PG
`else
, vdd, vss
`endif //WLOGIC_MODEL_NO_PG
);

  input in;
  output out;
`ifdef WLOGIC_MODEL_NO_PG
`else
  inout vdd;
  inout vss;
`endif //WLOGIC_MODEL_NO_PG

`ifdef WLOGIC_MODEL_NO_PG
`else

`ifdef WLOGIC_PWR_CHECK
  wire   power_ok;
  assign power_ok = ~vss & vdd;
  
  assign out = (power_ok) ? 1'bz : 1'bx;

`endif //WLOGIC_PWR_CHECK

`endif //WLOGIC_MODEL_NO_PG

   assign out = ~in;


endmodule

// HDL file - wavshared_gf12lp_dig_lib, INV_D8_GL16_LVT, systemVerilog.

//systemVerilog HDL for "wavshared_ln08lpu_dig_lib", "INV_D8_GL16_LVT" "systemVerilog"


module WavD2DAnalogPhy_8lane_gf12lpp_INV_D8_GL16_LVT ( in, out
`ifdef WLOGIC_MODEL_NO_PG
`else
, vdd, vss
`endif //WLOGIC_MODEL_NO_PG
);

  input in;
  output out;
`ifdef WLOGIC_MODEL_NO_PG
`else
  inout vdd;
  inout vss;
`endif //WLOGIC_MODEL_NO_PG

`ifdef WLOGIC_MODEL_NO_PG
`else

`ifdef WLOGIC_PWR_CHECK
  wire   power_ok;
  assign power_ok = ~vss & vdd;
  
  assign out = (power_ok) ? 1'bz : 1'bx;

`endif //WLOGIC_PWR_CHECK

`endif //WLOGIC_MODEL_NO_PG

   assign out = ~in;


endmodule

// HDL file - wphy_gf12lp_d2d_serdes_lib, d2d_clk_drv_slice_dum, behavioral.

//Verilog HDL for "wphy_gf12lp_d2d_serdes_lib", "d2d_drv_slice_dum" "behavioral"


module WavD2DAnalogPhy_8lane_gf12lpp_d2d_clk_drv_slice_dum ( vss );

  inout vss;
endmodule

// HDL file - wphy_gf12lp_d2d_serdes_lib, d2d_clk_drv_boost_dum, functional.

//Verilog HDL for "wphy_gf12lp_d2d_serdes_lib", "d2d_clk_drv_boost_dum" "functional"


module WavD2DAnalogPhy_8lane_gf12lpp_d2d_clk_drv_boost_dum ( vdda, vss );

  inout vdda;
  inout vss;
endmodule

// HDL file - wavshared_gf12lp_dig_lib, INV_D2_GL16_LVT_Mmod_nomodel, systemVerilog.

//systemVerilog HDL for "wavshared_tsmc12ffc_lib", "INV_D2_GL16_LVT_Mmod_nomodel"
//"systemVerilog"


module WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT_Mmod_nomodel( in, out
`ifdef WLOGIC_MODEL_NO_PG
`else
, vdd, vss
`endif //WLOGIC_MODEL_NO_PG
);

  input in;
  output out;
`ifdef WLOGIC_MODEL_NO_PG
`else
  inout vdd;
  inout vss;
`endif //WLOGIC_MODEL_NO_PG


endmodule

// HDL file - wphy_gf12lp_ips_lib, wphy_pi_14g_inve, behavioral.

//Verilog HDL for "wmx_d2d_serdes_lib", "wmx_d2d_pi_cmos_inv1_en" "functional"


module WavD2DAnalogPhy_8lane_gf12lpp_wphy_pi_14g_inve ( in, vdda, vss, out, en, enb );

  input in;
  inout vdda;
  output out;
  input en;
  input enb;
  inout vss;
  wire pwr_ok;

  assign pwr_ok = vdda & ~vss;
  assign out= pwr_ok ? ( en ? ~in:1'bz) : 1'bx ;

endmodule

// HDL file - wphy_gf12lp_ips_lib, wphy_pi_14g_core, systemVerilog.

`timescale 1ps/1fs
module WavD2DAnalogPhy_8lane_gf12lpp_wphy_pi_14g_core ( outn, outp, vdda, vss, clk0, clk90, clk180, clk270,
sel0, sel0b, sel90, sel90b, sel180, sel180b, sel270, sel270b, xcpl, xcplb );

  input  [3:0] xcplb;
  input  [3:0] xcpl;
  input  [15:0] sel270;
  input  [15:0] sel270b;
  input clk270;
  input  [15:0] sel90b;
  input clk90;
  input  [15:0] sel90;

  input  [15:0] sel180;
  input  [15:0] sel180b;
  input clk180;
  input clk0;

  input  [15:0] sel0b;
  input  [15:0] sel0;

  inout vdda;
  inout vss;
  output reg outp = 1'b0;
  output wire outn;

//reg outp = 1'b0;

reg outp_int = 1'b0;
//reg       outp_int;


wire [63:0]       therm_code;
real        current_edge0, previous_edge0, current_period0;
real        current_edge90, previous_edge90, current_period90;
real        current_edge180, previous_edge180, current_period180;
real        current_edge270, previous_edge270, current_period270;
real        phase_step0, phase_step90, phase_step180, phase_step270;
real        phase_delay0, phase_delay90, phase_delay180, phase_delay270;
integer        delay_count, delay_count_mod;
reg         out_int;
wire [15:0]    tsel0, tsel90, tsel180, tsel270;
wire        power_ok;
reg         del_270_0, del_0_90, del_90_180, del_180_270;

reg         genclk0, genclk90, genclk180, genclk270;

assign power_ok = (vdda & ~vss);

assign tsel0      =  sel0     & ~sel0b;
assign tsel90     =  sel90    & ~sel90b;
assign tsel180 =  sel180   & ~sel180b;
assign tsel270 =  sel270   & ~sel270b;


assign therm_code = {tsel0, tsel90, tsel180, tsel270};

integer ones0;
integer ones90;
integer ones180;
integer ones270;
integer ones [3:0];
real tmin_delay=0.0;
reg assert_en=1'b0;
integer clk0_edges=0;

initial begin
  ones0=$countones(tsel0);
  ones90=$countones(tsel90);
  ones180=$countones(tsel180);
  ones270=$countones(tsel270);

  ones[0]=ones0;
  ones[1]=ones90;
  ones[2]=ones180;
  ones[3]=ones270;
end

initial begin
   if ($value$plusargs("WPHY_ANA_ASSERT_EN=%f", assert_en)) begin
      assert_en=assert_en;
   end
end


always @(tsel0) begin
  ones0=$countones(tsel0);
end
always @(tsel90) begin
  ones90=$countones(tsel90);
end
always @(tsel180) begin
  ones180=$countones(tsel180);
end
always @(tsel270) begin
  ones270=$countones(tsel270);
end

always @(*) begin
  ones[0]=ones0;
  ones[1]=ones90;
  ones[2]=ones180;
  ones[3]=ones270;
end

// BIG TABLE, will change if I have some time
always @(*) begin

   //therm_code_ones = $countones
   case({ones[0],ones[1],ones[2],ones[3]})
    {32'd00,32'd0,32'd0,32'd16}:delay_count = 0;
    {32'd01,32'd0,32'd0,32'd15}:delay_count = 1;
    {32'd02,32'd0,32'd0,32'd14}:delay_count = 2;
    {32'd03,32'd0,32'd0,32'd13}:delay_count = 3;
    {32'd04,32'd0,32'd0,32'd12}:delay_count = 4;
    {32'd05,32'd0,32'd0,32'd11}:delay_count = 5;
    {32'd06,32'd0,32'd0,32'd10}:delay_count = 6;
    {32'd07,32'd0,32'd0,32'd09}:delay_count = 7;
    {32'd08,32'd0,32'd0,32'd08}:delay_count = 8;
    {32'd09,32'd0,32'd0,32'd07}:delay_count = 9;
    {32'd10,32'd0,32'd0,32'd06}:delay_count = 10;
    {32'd11,32'd0,32'd0,32'd05}:delay_count = 11;
    {32'd12,32'd0,32'd0,32'd04}:delay_count = 12;
    {32'd13,32'd0,32'd0,32'd03}:delay_count = 13;
    {32'd14,32'd0,32'd0,32'd02}:delay_count = 14;
    {32'd15,32'd0,32'd0,32'd01}:delay_count = 15;

    {32'd16,32'd00,32'd0,32'd0}:delay_count = 16;
    {32'd15,32'd01,32'd0,32'd0}:delay_count = 17;
    {32'd14,32'd02,32'd0,32'd0}:delay_count = 18;
    {32'd13,32'd03,32'd0,32'd0}:delay_count = 19;
    {32'd12,32'd04,32'd0,32'd0}:delay_count = 20;
    {32'd11,32'd05,32'd0,32'd0}:delay_count = 21;
    {32'd10,32'd06,32'd0,32'd0}:delay_count = 22;
    {32'd09,32'd07,32'd0,32'd0}:delay_count = 23;
    {32'd08,32'd08,32'd0,32'd0}:delay_count = 24;
    {32'd07,32'd09,32'd0,32'd0}:delay_count = 25;
    {32'd06,32'd10,32'd0,32'd0}:delay_count = 26;
    {32'd05,32'd11,32'd0,32'd0}:delay_count = 27;
    {32'd04,32'd12,32'd0,32'd0}:delay_count = 28;
    {32'd03,32'd13,32'd0,32'd0}:delay_count = 29;
    {32'd02,32'd14,32'd0,32'd0}:delay_count = 30;
    {32'd01,32'd15,32'd0,32'd0}:delay_count = 31;

    {32'd00,32'd16,32'd00,32'd0}:delay_count = 32;
    {32'd00,32'd15,32'd01,32'd0}:delay_count = 33;
    {32'd00,32'd14,32'd02,32'd0}:delay_count = 34;
    {32'd00,32'd13,32'd03,32'd0}:delay_count = 35;
    {32'd00,32'd12,32'd04,32'd0}:delay_count = 36;
    {32'd00,32'd11,32'd05,32'd0}:delay_count = 37;
    {32'd00,32'd10,32'd06,32'd0}:delay_count = 38;
    {32'd00,32'd09,32'd07,32'd0}:delay_count = 39;
    {32'd00,32'd08,32'd08,32'd0}:delay_count = 40;
    {32'd00,32'd07,32'd09,32'd0}:delay_count = 41;
    {32'd00,32'd06,32'd10,32'd0}:delay_count = 42;
    {32'd00,32'd05,32'd11,32'd0}:delay_count = 43;
    {32'd00,32'd04,32'd12,32'd0}:delay_count = 44;
    {32'd00,32'd03,32'd13,32'd0}:delay_count = 45;
    {32'd00,32'd02,32'd14,32'd0}:delay_count = 46;
    {32'd00,32'd01,32'd15,32'd0}:delay_count = 47;

    {32'd00,32'd00,32'd16,32'd00}:delay_count = 48;
    {32'd00,32'd00,32'd15,32'd01}:delay_count = 49;
    {32'd00,32'd00,32'd14,32'd02}:delay_count = 50;
    {32'd00,32'd00,32'd13,32'd03}:delay_count = 51;
    {32'd00,32'd00,32'd12,32'd04}:delay_count = 52;
    {32'd00,32'd00,32'd11,32'd05}:delay_count = 53;
    {32'd00,32'd00,32'd10,32'd06}:delay_count = 54;
    {32'd00,32'd00,32'd09,32'd07}:delay_count = 55;
    {32'd00,32'd00,32'd08,32'd08}:delay_count = 56;
    {32'd00,32'd00,32'd07,32'd09}:delay_count = 57;
    {32'd00,32'd00,32'd06,32'd10}:delay_count = 58;
    {32'd00,32'd00,32'd05,32'd11}:delay_count = 59;
    {32'd00,32'd00,32'd04,32'd12}:delay_count = 60;
    {32'd00,32'd00,32'd03,32'd13}:delay_count = 61;
    {32'd00,32'd00,32'd02,32'd14}:delay_count = 62;
    {32'd00,32'd00,32'd01,32'd15}:delay_count = 63;

    default : delay_count = delay_count;
   endcase
  delay_count_mod = delay_count % 16;
end

//period
always @(posedge clk0) begin
  current_edge0            = $realtime;
  current_period0          = current_edge0 - previous_edge0;
  if(current_period0 > 5000) begin
    current_period0     = 5000;
  end
  previous_edge0           = current_edge0;
  phase_step0              = current_period0 / 64;
  //phase_delay0             = del_270_0 ? ((delay_count_mod+1) * phase_step0) : (del_0_90 ? ((15 - delay_count_mod) * phase_step0) : 0);



  if(Ipi_logic.en & assert_en) begin
    if(clk0_edges<5)
     clk0_edges = clk0_edges+1;
    else
      if(current_period0 > 5000)
        $display("WPHY_ANA_ERROR: input PI frequency too low (needs to be >500MHz),  %m at %t",$realtime);

  end
  else
    clk0_edges=0;

end

always @(*) begin
  phase_delay0             = del_0_90 ? ((delay_count_mod) * phase_step0) : 0;
end

always @(posedge clk90) begin
  current_edge90           = $realtime;
  current_period90         = current_edge90 - previous_edge90;
  if(current_period90 > 5000) begin
    current_period90     = 5000;
  end
  previous_edge90          = current_edge90;
  phase_step90                = current_period90 / 64;
  //phase_delay90            = del_0_90 ? ((delay_count_mod+1) * phase_step90) : (del_90_180 ? ((15 - delay_count_mod) * phase_step90) : 0);
end

always @(*) begin
  phase_delay90            = del_90_180 ? ((delay_count_mod) * phase_step90) : 0;
end

always @(posedge clk180) begin
  current_edge180             = $realtime;
  current_period180        = current_edge180 - previous_edge180;
  if(current_period180 > 5000) begin
    current_period180     = 5000;
  end
  previous_edge180            = current_edge180;
  phase_step180               = current_period180 / 64;
  //phase_delay180              = del_90_180 ? ((delay_count_mod+1) * phase_step180) : (del_180_270 ? ((15 - delay_count_mod) * phase_step180) : 0);
end 

always @(*) begin
  phase_delay180              = del_180_270 ? ((delay_count_mod) * phase_step180) : 0;
end

always @(posedge clk270) begin
  current_edge270             = $realtime;
  current_period270        = current_edge270 - previous_edge270;
  if(current_period270 > 5000) begin
    current_period270     = 5000;
  end
  previous_edge270            = current_edge270;
  phase_step270               = (current_period270 / 64) + 0.001;
  //phase_delay270              = del_180_270 ? ((delay_count_mod+1) * phase_step270) : (del_270_0 ? ((15 - delay_count_mod) * phase_step270) : 0);
end

always @(*) begin
  phase_delay270              = del_270_0 ? ((delay_count_mod) * phase_step270) : 0;
end


always @(clk0) begin
  #0;
  if(clk0) genclk0 = #(phase_delay0) 1'b1;
  else     genclk0 = #(phase_delay0) 1'b0;
end

always @(clk90) begin
  #0;
  if(clk90) genclk90 = #(phase_delay90) 1'b1;
  else      genclk90 = #(phase_delay90) 1'b0;
end

always @(clk180) begin
  #0;
  if(clk180) genclk180 = #(phase_delay180) 1'b1;
  else       genclk180 = #(phase_delay180) 1'b0;
end

always @(clk270) begin
  #0;
  if(clk270) genclk270 = #(phase_delay270) 1'b1;
  else       genclk270 = #(phase_delay270) 1'b0;
end


//always @(*) begin
always@(genclk0 or genclk90 or genclk180 or genclk270) begin
    #0;
   //case({del_270_0, del_0_90, del_90_180, del_180_270})
   case({del_0_90, del_90_180, del_180_270,del_270_0})
    4'b1000 : outp_int = genclk0;
    4'b0100 : outp_int = genclk90;
    4'b0010 : outp_int = genclk180;
    4'b0001 : outp_int = genclk270;
    default : outp_int = outp;
  endcase
end

initial begin
   case(Ipi_logic.gear)
      0: tmin_delay = 340.0;
      1: tmin_delay = 177.0;
      2: tmin_delay = 129.0;
      3: tmin_delay = 103.0;
      4: tmin_delay =  90.0;
      default: tmin_delay = 50.0;
   endcase
end
always @(Ipi_logic.gear) begin
   case(Ipi_logic.gear)
      0: tmin_delay = 340.0;
      1: tmin_delay = 177.0;
      2: tmin_delay = 129.0;
      3: tmin_delay = 103.0;
      4: tmin_delay =  90.0;
      default: tmin_delay = 50.0;
   endcase
end

always @(outp_int) begin
  outp <= #(tmin_delay) outp_int;
end


always @(delay_count) begin
  del_270_0    = (delay_count>=0)   && (delay_count<=15);
  del_0_90     = (delay_count>=16)  && (delay_count<=31);
  del_90_180   = (delay_count>=32)  && (delay_count<=47);
  del_180_270  = (delay_count>=48)  && (delay_count<=63);
end

assign outn = ~outp;

endmodule
// HDL file - wavshared_gf12lp_dig_lib, NAND2_D1_GL16_RVT, systemVerilog.




module WavD2DAnalogPhy_8lane_gf12lpp_NAND2_D1_GL16_RVT ( y, a, b
`ifdef WLOGIC_MODEL_NO_TIE
`else
,tielo, tiehi
`endif //WLOGIC_MODEL_NO_TIE
`ifdef WLOGIC_MODEL_NO_PG
`else
, vss, vdd 
`endif //WLOGIC_MODEL_NO_PG
); 

  input b;
  input a;
  output y;
`ifdef WLOGIC_MODEL_NO_TIE
`else
  input tiehi;
  input tielo;
`endif //WLOGIC_MODEL_NO_TIE
`ifdef WLOGIC_MODEL_NO_PG
`else
  inout vdd;
  inout vss;
`endif //WLOGIC_MODEL_NO_PG

`ifdef WLOGIC_MODEL_NO_TIE
`else

`ifdef WLOGIC_TIE_CHECK
  wire   signals_ok;
  assign signals_ok = tiehi & ~tielo;
  
  assign y = (signals_ok) ? 1'bz : 1'bx;
`endif // WLOGIC_TIE_CHECK

`endif //WLOGIC_MODEL_NO_TIE

`ifdef WLOGIC_MODEL_NO_PG
`else

`ifdef WLOGIC_PWR_CHECK
  wire   power_ok;
  assign power_ok = ~vss & vdd;
  
  assign y = (power_ok) ? 1'bz : 1'bx;

`endif //WLOGIC_PWR_CHECK

`endif //WLOGIC_MODEL_NO_PG


 assign y = ~(a&b);

endmodule

// HDL file - wavshared_gf12lp_dig_lib, NOR2_D1_GL16_RVT, systemVerilog.

//systemVerilog HDL for "wavshared_tsmc12ffc_lib", "NOR2_D1_GL16_RVT" "systemVerilog"


module WavD2DAnalogPhy_8lane_gf12lpp_NOR2_D1_GL16_RVT ( y, a, b
`ifdef WLOGIC_MODEL_NO_TIE
`else
,tielo, tiehi
`endif //WLOGIC_MODEL_NO_TIE
`ifdef WLOGIC_MODEL_NO_PG
`else
, vss, vdd 
`endif //WLOGIC_MODEL_NO_PG
); 

  input b;
  input a;
  output y;
`ifdef WLOGIC_MODEL_NO_TIE
`else
  input tiehi;
  input tielo;
`endif //WLOGIC_MODEL_NO_TIE
`ifdef WLOGIC_MODEL_NO_PG
`else
  inout vdd;
  inout vss;
`endif //WLOGIC_MODEL_NO_PG

`ifdef WLOGIC_MODEL_NO_TIE
`else

`ifdef WLOGIC_TIE_CHECK
  wire   signals_ok;
  assign signals_ok = tiehi & ~tielo;
  
  assign y = (signals_ok) ? 1'bz : 1'bx;
`endif // WLOGIC_TIE_CHECK

`endif //WLOGIC_MODEL_NO_TIE

`ifdef WLOGIC_MODEL_NO_PG
`else

`ifdef WLOGIC_PWR_CHECK
  wire   power_ok;
  assign power_ok = ~vss & vdd;
  
  assign y = (power_ok) ? 1'bz : 1'bx;

`endif //WLOGIC_PWR_CHECK

`endif //WLOGIC_MODEL_NO_PG


  assign y=~(a|b);

endmodule

// HDL file - wavshared_gf12lp_dig_lib, DUMLOAD_D1_GL16_LVT, systemVerilog.

//systemVerilog HDL for "wavshared_tsmc12ffc_lib", "DUMLOAD_D1_GL16_LVT" "systemVerilog"


module WavD2DAnalogPhy_8lane_gf12lpp_DUMLOAD_D1_GL16_LVT ( inp, inn
`ifdef WLOGIC_MODEL_NO_PG
`else
, vss, vdd 
`endif //WLOGIC_MODEL_NO_PG
); 

  input inp;
  input inn;
`ifdef WLOGIC_MODEL_NO_PG
`else
  inout vdd;
  inout vss;
`endif //WLOGIC_MODEL_NO_PG


endmodule

// HDL file - wphy_gf12lp_ips_lib, INVT_DIFF_D2_GL16_LVT_BAL, functional.

//Verilog HDL for "wphy_gf12lp_ips_lib", "INVT_DIFF_D2_GL16_LVT_BAL" "functional"

`timescale 1ps/1ps
module WavD2DAnalogPhy_8lane_gf12lpp_INVT_DIFF_D2_GL16_LVT_BAL ( out1b, out2b, vdd, vss, en, enb, in1, in2
);

  output out2b;
  input in2;
  input in1;
  input en;
  inout vdd;
  output out1b;
  input enb;
  inout vss;


wire power_ok = vdd & ~vss;
assign #5 out1b = power_ok ? en & ~enb ? ~in1 : 1'b0 : 1'bx;
assign #5 out2b = power_ok ? en & ~enb ? ~in2 : 1'b0 : 1'bx;

endmodule

// HDL file - wavshared_gf12lp_dig_lib, PDDUM_D1_bal_GL16_LVT, systemVerilog.

//systemVerilog HDL for "wavshared_tsmc12ffc_lib", "PDDUM_D1_GL16_RVT" "systemVerilog"


module WavD2DAnalogPhy_8lane_gf12lpp_PDDUM_D1_GL16_RVT ( tielo
`ifdef WLOGIC_MODEL_NO_PG
`else
, vss
`endif //WLOGIC_MODEL_NO_PG
); 

  input tielo;
`ifdef WLOGIC_MODEL_NO_PG
`else
  inout vss;
`endif //WLOGIC_MODEL_NO_PG

endmodule

// HDL file - wphy_gf12lp_ips_lib, INV_DIFF_D2_GL16_LVT_BAL, functional.

//Verilog HDL for "wphy_gf12lp_ips_lib", "INV_DIFF_D2_GL16_LVT_BAL" "functional"

`timescale 1ps/1ps
module WavD2DAnalogPhy_8lane_gf12lpp_INV_DIFF_D2_GL16_LVT_BAL ( out1b, out2b, vdd, vss, in1, in2 );

  output out2b;
  input in2;
  input in1;
  inout vdd;
  output out1b;
  inout vss;

wire power_ok = vdd & ~vss;

assign #5 out1b = power_ok ? ~in1 : 1'bx;
assign #5 out2b = power_ok ? ~in2 : 1'bx;


endmodule

// HDL file - wavshared_gf12lp_dig_lib, PD_D1_bal_GL16_LVT, systemVerilog.

//systemVerilog HDL for "wavshared_gf12lp_dig_lib", "PD_D1_bal_GL16_LVT" "systemVerilog"


module WavD2DAnalogPhy_8lane_gf12lpp_PD_D1_bal_GL16_LVT ( enb, y

`ifdef WLOGIC_MODEL_NO_PG
`else
, vss
`endif //WLOGIC_MODEL_NO_PG
); 

  input y;
  input enb;

`ifdef WLOGIC_MODEL_NO_PG
`else
  inout vss;
`endif //WLOGIC_MODEL_NO_PG

`ifdef WLOGIC_MODEL_NO_PG
`else

`ifdef WLOGIC_PWR_CHECK
  wire   power_ok;
  assign power_ok = ~vss ;
  
  assign y = (power_ok) ? 1'bz : 1'bx;

`endif //WLOGIC_PWR_CHECK

`endif //WLOGIC_MODEL_NO_PG

  assign y =  enb ? 1'b0 : 1'bz;

endmodule

// HDL file - wphy_gf12lp_ips_lib, iqgen_pdly_v2, systemVerilog.

//systemVerilog HDL for "wphy_gf12lp_ips_lib", "iqgen_pdly_v2" "systemVerilog"

`timescale 1ps/1fs
module WavD2DAnalogPhy_8lane_gf12lpp_iqgen_pdly_v2 ( clk_o, clk_ob, vdda, vss, ctrl, clk_i, clk_ib, ena, enb,
gear, gearb );

  input clk_ib;
  output clk_ob;
  input  [1:0] gearb;
  input  [1:0] gear;
  output clk_o;
  inout vdda;
  input ena;
  input  [5:0] ctrl;
  input enb;
  input clk_i;
  inout vss;

real code = 0 ;
real clk_dly;

wire power_ok = vdda & ~vss;
wire enable   = power_ok ? ena & ~enb : 1'bx;

always @(*) begin
  code      = ctrl;
  
  case(gear)
    0 : clk_dly = -0.00025*(code**2) + 0.5207*code + 51.86;
    1 : clk_dly = -0.00015*(code**2) + 0.2619*code + 29.03;
    2 : clk_dly = -0.00015*(code**2) + 0.1819*code + 21.55;
    3 : clk_dly = -0.00065*(code**2) + 0.1154*code + 16.88;
    default : begin
      $display("WAV_ERROR: Bad DLL gear setting!");
      clk_dly = 0;
    end
  endcase
end

assign #(clk_dly) clk_o  = enable ? clk_i  : 1'b0;
assign #(clk_dly) clk_ob = enable ? clk_ib : 1'b0;
endmodule

// HDL file - wavshared_gf12lp_dig_lib, FFSET_D1_GL16_LVT, systemVerilog.

//systemVerilog HDL for "wavshared_tsmc12ffc_lib", "FFSET_D1_GL16_LVT" "systemVerilog"


module WavD2DAnalogPhy_8lane_gf12lpp_FFSET_D1_GL16_LVT ( q, clk, clkb, d, prst, prstb
`ifdef WLOGIC_MODEL_NO_TIE
`else
,tielo, tiehi
`endif //WLOGIC_MODEL_NO_TIE
`ifdef WLOGIC_MODEL_NO_PG
`else
, vss, vdd 
`endif //WLOGIC_MODEL_NO_PG
); 

  input clk;
  input prst;
  input prstb;
  output q;
  input d;
  input clkb;   
`ifdef WLOGIC_MODEL_NO_TIE
`else
  input tiehi;
  input tielo;
`endif //WLOGIC_MODEL_NO_TIE
`ifdef WLOGIC_MODEL_NO_PG
`else
  inout vdd;
  inout vss;
`endif //WLOGIC_MODEL_NO_PG

`ifdef WLOGIC_MODEL_NO_TIE
`else

`ifdef WLOGIC_TIE_CHECK
  wire   signals_ok;
  assign signals_ok = tiehi & ~tielo;

  initial  begin
       q = (signals_ok) ? 1'bz : 1'bx;
  end
  always @(*) begin
       q = (signals_ok) ? 1'bz : 1'bx;
  end
`endif // WLOGIC_TIE_CHECK

`endif //WLOGIC_MODEL_NO_TIE

`ifdef WLOGIC_MODEL_NO_PG
`else

`ifdef WLOGIC_PWR_CHECK
  wire   power_ok;
  assign power_ok = ~vss & vdd;
  
  initial  begin
       q = (power_ok) ? 1'bz : 1'bx;
  end
  always @(*) begin
       q = (power_ok) ? 1'bz : 1'bx;
  end
`endif //WLOGIC_PWR_CHECK

`endif //WLOGIC_MODEL_NO_PG

  reg q;

  initial begin
    q = $random;
  end

  always @(posedge clk or posedge prst) begin
   if(prst) begin
       q <= 1'b1;
    end else begin
       q <= d;
    end
  end

endmodule

// HDL file - wphy_gf12lp_d2d_serdes_lib, d2d_rx_term_dum, behavioral.

//Verilog HDL for "wphy_gf12lp_d2d_serdes_lib", "d2d_rx_term_dum" "behavioral"


module WavD2DAnalogPhy_8lane_gf12lpp_d2d_rx_term_dum ( vss );

  inout vss;
endmodule

// HDL file - wphy_gf12lp_d2d_serdes_lib, d2d_clk_rcvr_acdcpath, functional.

//Verilog HDL for "wmx_d2d_serdes_lib", "wmx_d2d_clk_rcvr_acdcpath" "functional"


module WavD2DAnalogPhy_8lane_gf12lpp_d2d_clk_rcvr_acdcpath ( clk_outn, clk_outp, vdda, vss, dcen, dcenb,
ena, enb, enfb, enfbb, pad_clk_rxn, pad_clk_rxp );

  input enfbb;
  input dcen;
  input pad_clk_rxp;
  inout vdda;
  input ena;
  input dcenb;
  output clk_outp;
  input pad_clk_rxn;
  output clk_outn;
  input enfb;
  input enb;
  inout vss;

  wire pwr_ok;

  assign pwr_ok = ~vss & vdda;


 assign clk_outp = pwr_ok ? ((ena & ~enb) ?  ~pad_clk_rxn : 1'b0) : 1'bx ;
 assign clk_outn = pwr_ok ? ((ena & ~enb) ?  ~pad_clk_rxp : 1'b0) : 1'bx ;

endmodule

// HDL file - wphy_gf12lp_d2d_serdes_lib, wav_d2d_NAND2_D1_GL16_LVT_strmodel, functional.

//Verilog HDL for "wphy_gf12lp_d2d_serdes_lib", "wav_d2d_NAND2_D1_GL16_LVT_strmodel"
//"functional"


module WavD2DAnalogPhy_8lane_gf12lpp_wav_d2d_NAND2_D1_GL16_LVT_strmodel ( y, a, b, tiehi, tielo, vss, vdd
);

  input tiehi;
  input b;
  input a;
  input tielo;
  inout vdd;
  output y;
  inout vss;

assign power_ok = vdd & ~vss & tiehi & ~tielo;

reg [3*8:1] wire_str;
reg         out_pre;

always @(*) begin
  $sformat(wire_str, "%v", a);
  case(wire_str)
    "St1"     : out_pre = 1'b1;
    "St0"     : out_pre = 1'b0;
    "HiZ"     : out_pre = 1'bz;
    "Pu1"     : out_pre = 1'b0;
    "Pu0"     : out_pre = 1'b0;
    default   : out_pre = 1'bx;
  endcase
end

assign y = power_ok ? ~(b & out_pre) : 1'bx;

endmodule

// HDL file - wphy_gf12lp_d2d_serdes_lib, wav_d2d_clk_vref_gen, systemVerilog.

//systemVerilog HDL for "wphy_gf12lp_d2d_serdes_lib", "wav_d2d_clk_vref_gen"
//"systemVerilog"


module WavD2DAnalogPhy_8lane_gf12lpp_wav_d2d_clk_vref_gen ( irefp, vdda, vddq, vss, en_ref, irefp_lvl );

  input en_ref;
  input  [5:0] irefp_lvl;
  inout vdda;
  inout vddq;
  output var real irefp;
  inout vss;


parameter MV_STEP = 5;

assign power_good = vdda & vddq & ~vss;

always @(*) begin
  if(en_ref) begin
    irefp = (irefp_lvl * MV_STEP) + MV_STEP; //code ==0 is 5mV
  end else begin
    irefp = 0.0;
  end
end

endmodule

// HDL file - wavshared_gf12lp_dig_lib, PUDUM_D2_GL16_LVT, systemVerilog.

//systemVerilog HDL for "wavshared_tsmc12ffc_lib", "PUDUM_D2_GL16_LVT" "systemVerilog"


module WavD2DAnalogPhy_8lane_gf12lpp_PUDUM_D2_GL16_LVT ( tiehi
`ifdef WLOGIC_MODEL_NO_PG
`else
, vdd 
`endif //WLOGIC_MODEL_NO_PG
);

  input tiehi;
`ifdef WLOGIC_MODEL_NO_PG
`else
  inout vdd;
`endif //WLOGIC_MODEL_NO_PG

endmodule

// HDL file - wphy_gf12lp_ips_lib, wphy_sa_14g, systemVerilog.



module WavD2DAnalogPhy_8lane_gf12lpp_wphy_sa_14g ( qb, q, vdda, vss, clk, clkb, ena, inn, inp, cal, cal_dir);


  output qb;
  inout vdda;
  input cal_dir;
  input var real inp;
  input var real inn;   //local_vref handles this
  input  [3:0] cal;
  input ena;
  output q;
  input clk, clkb;
  inout vss;

wire power_ok;
reg in;
reg out_pre;
real SA_OFFSET =0.0;
real cal_v = 0.0;

assign power_ok = (vdda & ~vss);

// THIS IS IN mV!!!! so only pass 4 for 4mV
initial begin
    if ($value$plusargs("WLINK_SA_OFFSET=%f", SA_OFFSET)) begin
        $display("WLINK_SA_OFFSET %f.", SA_OFFSET);
    end
end
always @(*) begin
 
  cal_v = 2*(cal)*((-1.0)**cal_dir);

end

real local_vref;
always @(ICLK_RX.VREF_GEN.irefp) begin
  local_vref  = ICLK_RX.VREF_GEN.irefp;
end

real ch_p;


`ifdef WCL_WREAL_SIM

WavD2DAnalogPhy_8lane_gf12lpp_wcl_real_channel_model #(
  //parameters
  .NUM_OF_COEFFS      ( 100       ),
  .TIMESTEP_PS        ( 5         )
) u_wcl_real_channel_model (
  .rx_in     ( inp      ),         
  .rxp_out   ( ch_p       ),         
  .rxn_out   (            )); 
`else 
assign ch_p = inp;

`endif

always @(posedge clk) begin
        if(ena) begin
        //in      = (inp -local_vref - SA_OFFSET + cal_v)>0;
        in      = (ch_p -local_vref - SA_OFFSET + cal_v)>0;
                //if (inp===1'bx | inn===1'bX | inn===1'bZ | inp===1'bZ)
                //      out_pre <= 1'bx;
                //else
                        //out_pre <= (inp - local_vref==SA_OFFSET - cal_v) ? $random : in;
                        out_pre <= (ch_p - local_vref==SA_OFFSET - cal_v) ? $random : in;
        end
        else begin
                out_pre         <= 1'b0; 
        end
end



assign q = power_ok ? out_pre :1'bx;
assign qb = power_ok ? ~out_pre :1'bx;

endmodule

`timescale 1ps/1fs
module WavD2DAnalogPhy_8lane_gf12lpp_wcl_real_channel_model #(
  parameter     NUM_OF_COEFFS   = 200,
  parameter     TIMESTEP_PS     = 10,
  parameter     COEFF_FILE      = "channel_coeffs_10ps.txt"
)(
  input  var real rx_in,
  
  output var real rxp_out,
  output var real rxn_out
);

integer data_file;      //file handler
integer scan_file;      //file handler
integer i;

real chan_coeffs[200];

real coeffs_array[NUM_OF_COEFFS];
real sample_delays[NUM_OF_COEFFS];

real summed_value;




`ifdef WCL_WREAL_SIM
reg   disable_channel;
time  last_change;
real  last_value;

real diff;

always #(33ps) begin
  diff = rx_in - last_value;
  if((diff > 0.001) || (diff < -0.001)) begin
    last_change = $realtime;
    disable_channel = 0;
    last_value  = rx_in;
  end
  
  if(($realtime - last_change) > 1us) begin
    disable_channel = 1;
  end
end
// 
// //Coeff math
// //Delays go 0 -> NUM_OF_COEFFS
// always #(TIMESTEP_PS) begin
//   summed_value = 0;
//   if(~disable_channel) begin
//     //Delays
//     for(i=NUM_OF_COEFFS-1; i >=0; i--) begin
//       if(i == 0) begin                //First one is the input 
//         sample_delays[i] = rx_in;
//       end else begin                  //remainder are last one
//         sample_delays[i] = sample_delays[i-1];      
//       end
//     end
// 
// 
//     for(i=0; i<NUM_OF_COEFFS; i++) begin
//       //summed_value += coeffs_array[i] * sample_delays[i]; 
//       summed_value += chan_coeffs[i] * sample_delays[i]; 
//       if(summed_value > 200) begin
//         summed_value = 200;
//       end
//     end 
//   end
// end

real Ts;
real Ts_time;
real d0, d1;
real FpFilt;
//real Fp = 5e9;
real Fp = 4e10;
parameter real    PI2   = 6.283185;
parameter real    C_int = 1e-12;

initial begin
  if ($value$plusargs("CH_CUTOFF_FREQ=%f", FpFilt)) begin   
  end else begin
    FpFilt      = Fp;
  end

  Ts_time  = TIMESTEP_PS;
  d0 = 1 + (2 / (PI2 * FpFilt * (Ts_time*1e-12)));  
  d1 = 1 - (2 / (PI2 * FpFilt * (Ts_time*1e-12)));

end

real last_rx_in;

always #(Ts_time) begin
  if(~disable_channel) begin
    //summed_value  = last_rx_in + (((rx_in) * Ts_time) / C_int); 
    summed_value  = (rx_in + last_rx_in - (summed_value*d1)) / d0;
    last_rx_in    = rx_in;
  end else begin
    summed_value  = 0; 
    last_rx_in    = 0;
  end
end


assign rxp_out = summed_value;
assign rxn_out = summed_value * -1.0;

`else
assign rxp_out = rx_in;
assign rxn_out = rx_in * -1.0;
`endif

//--------------------------
// EYE PLOT 
//--------------------------
string  inst_list;
string  file_name;
string  block_name;
integer file;
reg     plot_eye = 0;
string  this_inst;
integer f_char, l_char;
string  cur_inst;

initial begin
  if($value$plusargs("DFE_PLOT_EYE=%s", inst_list)) begin
    //Check that this instance is in the list
    f_char = 0;
    l_char = 0;
    this_inst = $psprintf("%m");
    $display("this inst : %s -- inst_list", this_inst, inst_list);
    for(integer i = 0; i < inst_list.len(); i++) begin
      //$display("-%s", inst_list.getc(i));
      if((inst_list.getc(i) == "#") || (i == inst_list.len()-1)) begin  //check for last char
        l_char = (i == inst_list.len()-1) ? i : i-1;  //last char protection
        //Now check instance
        $display("Checking!");
        cur_inst = inst_list.substr(f_char, l_char);
        $display("Parsed: %s", cur_inst);
        if(this_inst == cur_inst) begin
          plot_eye = 1;
          break;
        end
        $display("char %d %d", f_char, l_char);
        f_char = l_char + 2;
      end 
    end
    
    if(plot_eye) begin
      //If valid, then print the file
      file_name = $psprintf("eye_plot.%m.txt");
      file      = $fopen(file_name, "w");
      $display("Plotting Eye Diagram for -- %m"); 
    end
  end 
end

always @(*) begin
  if(plot_eye) begin
    $fwrite(file,"%f  %f\n", ($realtime/1000), rxp_out);
  end
end
//--------------------------

assign chan_coeffs[0] =     0.00000;
assign chan_coeffs[1] =     0.00174;
assign chan_coeffs[2] =     -0.00152;
assign chan_coeffs[3] =     -0.00069;
assign chan_coeffs[4] =     0.00080;
assign chan_coeffs[5] =     0.00155;
assign chan_coeffs[6] =     0.00204;
assign chan_coeffs[7] =     0.00407;
assign chan_coeffs[8] =     0.00995;
assign chan_coeffs[9] =     0.02174;
assign chan_coeffs[10] =    0.04058;
assign chan_coeffs[11] =    0.06636;
assign chan_coeffs[12] =    0.09776;
assign chan_coeffs[13] =    0.13245;
assign chan_coeffs[14] =    0.16765;
assign chan_coeffs[15] =    0.20058;
assign chan_coeffs[16] =    0.22900;
assign chan_coeffs[17] =    0.25140;
assign chan_coeffs[18] =    0.26718;
assign chan_coeffs[19] =    0.27650;
assign chan_coeffs[20] =    0.28004;
assign chan_coeffs[21] =    0.27881;
assign chan_coeffs[22] =    0.27384;
assign chan_coeffs[23] =    0.26604;
assign chan_coeffs[24] =    0.25617;
assign chan_coeffs[25] =    0.24479;
assign chan_coeffs[26] =    0.23239;
assign chan_coeffs[27] =    0.21942;
assign chan_coeffs[28] =    0.20635;
assign chan_coeffs[29] =    0.19367;
assign chan_coeffs[30] =    0.18181;
assign chan_coeffs[31] =    0.17110;
assign chan_coeffs[32] =    0.16169;
assign chan_coeffs[33] =    0.15353;
assign chan_coeffs[34] =    0.14636;
assign chan_coeffs[35] =    0.13975;
assign chan_coeffs[36] =    0.13326;
assign chan_coeffs[37] =    0.12647;
assign chan_coeffs[38] =    0.11914;
assign chan_coeffs[39] =    0.11120;
assign chan_coeffs[40] =    0.10282;
assign chan_coeffs[41] =    0.09431;
assign chan_coeffs[42] =    0.08610;
assign chan_coeffs[43] =    0.07859;
assign chan_coeffs[44] =    0.07212;
assign chan_coeffs[45] =    0.06688;
assign chan_coeffs[46] =    0.06287;
assign chan_coeffs[47] =    0.05998;
assign chan_coeffs[48] =    0.05795;
assign chan_coeffs[49] =    0.05650;
assign chan_coeffs[50] =    0.05535;
assign chan_coeffs[51] =    0.05428;
assign chan_coeffs[52] =    0.05313;
assign chan_coeffs[53] =    0.05185;
assign chan_coeffs[54] =    0.05044;
assign chan_coeffs[55] =    0.04892;
assign chan_coeffs[56] =    0.04736;
assign chan_coeffs[57] =    0.04580;
assign chan_coeffs[58] =    0.04427;
assign chan_coeffs[59] =    0.04278;
assign chan_coeffs[60] =    0.04133;
assign chan_coeffs[61] =    0.03993;
assign chan_coeffs[62] =    0.03857;
assign chan_coeffs[63] =    0.03728;
assign chan_coeffs[64] =    0.03608;
assign chan_coeffs[65] =    0.03501;
assign chan_coeffs[66] =    0.03408;
assign chan_coeffs[67] =    0.03328;
assign chan_coeffs[68] =    0.03260;
assign chan_coeffs[69] =    0.03199;
assign chan_coeffs[70] =    0.03140;
assign chan_coeffs[71] =    0.03078;
assign chan_coeffs[72] =    0.03010;
assign chan_coeffs[73] =    0.02932;
assign chan_coeffs[74] =    0.02846;
assign chan_coeffs[75] =    0.02753;
assign chan_coeffs[76] =    0.02658;
assign chan_coeffs[77] =    0.02565;
assign chan_coeffs[78] =    0.02479;
assign chan_coeffs[79] =    0.02401;
assign chan_coeffs[80] =    0.02333;
assign chan_coeffs[81] =    0.02275;
assign chan_coeffs[82] =    0.02224;
assign chan_coeffs[83] =    0.02177;
assign chan_coeffs[84] =    0.02131;
assign chan_coeffs[85] =    0.02085;
assign chan_coeffs[86] =    0.02035;
assign chan_coeffs[87] =    0.01982;
assign chan_coeffs[88] =    0.01926;
assign chan_coeffs[89] =    0.01868;
assign chan_coeffs[90] =    0.01810;
assign chan_coeffs[91] =    0.01753;
assign chan_coeffs[92] =    0.01698;
assign chan_coeffs[93] =    0.01646;
assign chan_coeffs[94] =    0.01599;
assign chan_coeffs[95] =    0.01555;
assign chan_coeffs[96] =    0.01516;
assign chan_coeffs[97] =    0.01482;
assign chan_coeffs[98] =    0.01453;
assign chan_coeffs[99] =    0.01429;


// assign chan_coeffs[0] =     0.000000;
// assign chan_coeffs[1] =     0.000174;
// assign chan_coeffs[2] =     -0.000152;
// assign chan_coeffs[3] =     -0.000069;
// assign chan_coeffs[4] =     0.000080;
// assign chan_coeffs[5] =     0.000155;
// assign chan_coeffs[6] =     0.000204;
// assign chan_coeffs[7] =     0.000407;
// assign chan_coeffs[8] =     0.000995;
// assign chan_coeffs[9] =     0.002174;
// assign chan_coeffs[10] =    0.004058;
// assign chan_coeffs[11] =    0.006636;
// assign chan_coeffs[12] =    0.009776;
// assign chan_coeffs[13] =    0.013245;
// assign chan_coeffs[14] =    0.016765;
// assign chan_coeffs[15] =    0.020058;
// assign chan_coeffs[16] =    0.022900;
// assign chan_coeffs[17] =    0.025140;
// assign chan_coeffs[18] =    0.026718;
// assign chan_coeffs[19] =    0.027650;
// assign chan_coeffs[20] =    0.028004;
// assign chan_coeffs[21] =    0.027881;
// assign chan_coeffs[22] =    0.027384;
// assign chan_coeffs[23] =    0.026604;
// assign chan_coeffs[24] =    0.025617;
// assign chan_coeffs[25] =    0.024479;
// assign chan_coeffs[26] =    0.023239;
// assign chan_coeffs[27] =    0.021942;
// assign chan_coeffs[28] =    0.020635;
// assign chan_coeffs[29] =    0.019367;
// assign chan_coeffs[30] =    0.018181;
// assign chan_coeffs[31] =    0.017110;
// assign chan_coeffs[32] =    0.016169;
// assign chan_coeffs[33] =    0.015353;
// assign chan_coeffs[34] =    0.014636;
// assign chan_coeffs[35] =    0.013975;
// assign chan_coeffs[36] =    0.013326;
// assign chan_coeffs[37] =    0.012647;
// assign chan_coeffs[38] =    0.011914;
// assign chan_coeffs[39] =    0.011120;
// assign chan_coeffs[40] =    0.010282;
// assign chan_coeffs[41] =    0.009431;
// assign chan_coeffs[42] =    0.008610;
// assign chan_coeffs[43] =    0.007859;
// assign chan_coeffs[44] =    0.007212;
// assign chan_coeffs[45] =    0.006688;
// assign chan_coeffs[46] =    0.006287;
// assign chan_coeffs[47] =    0.005998;
// assign chan_coeffs[48] =    0.005795;
// assign chan_coeffs[49] =    0.005650;
// assign chan_coeffs[50] =    0.005535;
// assign chan_coeffs[51] =    0.005428;
// assign chan_coeffs[52] =    0.005313;
// assign chan_coeffs[53] =    0.005185;
// assign chan_coeffs[54] =    0.005044;
// assign chan_coeffs[55] =    0.004892;
// assign chan_coeffs[56] =    0.004736;
// assign chan_coeffs[57] =    0.004580;
// assign chan_coeffs[58] =    0.004427;
// assign chan_coeffs[59] =    0.004278;
// assign chan_coeffs[60] =    0.004133;
// assign chan_coeffs[61] =    0.003993;
// assign chan_coeffs[62] =    0.003857;
// assign chan_coeffs[63] =    0.003728;
// assign chan_coeffs[64] =    0.003608;
// assign chan_coeffs[65] =    0.003501;
// assign chan_coeffs[66] =    0.003408;
// assign chan_coeffs[67] =    0.003328;
// assign chan_coeffs[68] =    0.003260;
// assign chan_coeffs[69] =    0.003199;
// assign chan_coeffs[70] =    0.003140;
// assign chan_coeffs[71] =    0.003078;
// assign chan_coeffs[72] =    0.003010;
// assign chan_coeffs[73] =    0.002932;
// assign chan_coeffs[74] =    0.002846;
// assign chan_coeffs[75] =    0.002753;
// assign chan_coeffs[76] =    0.002658;
// assign chan_coeffs[77] =    0.002565;
// assign chan_coeffs[78] =    0.002479;
// assign chan_coeffs[79] =    0.002401;
// assign chan_coeffs[80] =    0.002333;
// assign chan_coeffs[81] =    0.002275;
// assign chan_coeffs[82] =    0.002224;
// assign chan_coeffs[83] =    0.002177;
// assign chan_coeffs[84] =    0.002131;
// assign chan_coeffs[85] =    0.002085;
// assign chan_coeffs[86] =    0.002035;
// assign chan_coeffs[87] =    0.001982;
// assign chan_coeffs[88] =    0.001926;
// assign chan_coeffs[89] =    0.001868;
// assign chan_coeffs[90] =    0.001810;
// assign chan_coeffs[91] =    0.001753;
// assign chan_coeffs[92] =    0.001698;
// assign chan_coeffs[93] =    0.001646;
// assign chan_coeffs[94] =    0.001599;
// assign chan_coeffs[95] =    0.001555;
// assign chan_coeffs[96] =    0.001516;
// assign chan_coeffs[97] =    0.001482;
// assign chan_coeffs[98] =    0.001453;
// assign chan_coeffs[99] =    0.001429;
// assign chan_coeffs[100] =   0.001409;
// assign chan_coeffs[101] =   0.001393;
// assign chan_coeffs[102] =   0.001381;
// assign chan_coeffs[103] =   0.001369;
// assign chan_coeffs[104] =   0.001359;
// assign chan_coeffs[105] =   0.001346;
// assign chan_coeffs[106] =   0.001332;
// assign chan_coeffs[107] =   0.001313;
// assign chan_coeffs[108] =   0.001291;
// assign chan_coeffs[109] =   0.001264;
// assign chan_coeffs[110] =   0.001234;
// assign chan_coeffs[111] =   0.001201;
// assign chan_coeffs[112] =   0.001165;
// assign chan_coeffs[113] =   0.001129;
// assign chan_coeffs[114] =   0.001092;
// assign chan_coeffs[115] =   0.001057;
// assign chan_coeffs[116] =   0.001023;
// assign chan_coeffs[117] =   0.000992;
// assign chan_coeffs[118] =   0.000964;
// assign chan_coeffs[119] =   0.000939;
// assign chan_coeffs[120] =   0.000919;
// assign chan_coeffs[121] =   0.000902;
// assign chan_coeffs[122] =   0.000888;
// assign chan_coeffs[123] =   0.000879;
// assign chan_coeffs[124] =   0.000874;
// assign chan_coeffs[125] =   0.000872;
// assign chan_coeffs[126] =   0.000872;
// assign chan_coeffs[127] =   0.000874;
// assign chan_coeffs[128] =   0.000877;
// assign chan_coeffs[129] =   0.000881;
// assign chan_coeffs[130] =   0.000883;
// assign chan_coeffs[131] =   0.000884;
// assign chan_coeffs[132] =   0.000882;
// assign chan_coeffs[133] =   0.000877;
// assign chan_coeffs[134] =   0.000869;
// assign chan_coeffs[135] =   0.000858;
// assign chan_coeffs[136] =   0.000844;
// assign chan_coeffs[137] =   0.000827;
// assign chan_coeffs[138] =   0.000807;
// assign chan_coeffs[139] =   0.000785;
// assign chan_coeffs[140] =   0.000762;
// assign chan_coeffs[141] =   0.000738;
// assign chan_coeffs[142] =   0.000713;
// assign chan_coeffs[143] =   0.000690;
// assign chan_coeffs[144] =   0.000667;
// assign chan_coeffs[145] =   0.000647;
// assign chan_coeffs[146] =   0.000629;
// assign chan_coeffs[147] =   0.000613;
// assign chan_coeffs[148] =   0.000600;
// assign chan_coeffs[149] =   0.000590;
// assign chan_coeffs[150] =   0.000582;
// assign chan_coeffs[151] =   0.000576;
// assign chan_coeffs[152] =   0.000571;
// assign chan_coeffs[153] =   0.000568;
// assign chan_coeffs[154] =   0.000564;
// assign chan_coeffs[155] =   0.000560;
// assign chan_coeffs[156] =   0.000556;
// assign chan_coeffs[157] =   0.000550;
// assign chan_coeffs[158] =   0.000544;
// assign chan_coeffs[159] =   0.000536;
// assign chan_coeffs[160] =   0.000526;
// assign chan_coeffs[161] =   0.000516;
// assign chan_coeffs[162] =   0.000505;
// assign chan_coeffs[163] =   0.000494;
// assign chan_coeffs[164] =   0.000482;
// assign chan_coeffs[165] =   0.000472;
// assign chan_coeffs[166] =   0.000462;
// assign chan_coeffs[167] =   0.000454;
// assign chan_coeffs[168] =   0.000447;
// assign chan_coeffs[169] =   0.000443;
// assign chan_coeffs[170] =   0.000441;
// assign chan_coeffs[171] =   0.000441;
// assign chan_coeffs[172] =   0.000442;
// assign chan_coeffs[173] =   0.000445;
// assign chan_coeffs[174] =   0.000449;
// assign chan_coeffs[175] =   0.000453;
// assign chan_coeffs[176] =   0.000457;
// assign chan_coeffs[177] =   0.000460;
// assign chan_coeffs[178] =   0.000461;
// assign chan_coeffs[179] =   0.000460;
// assign chan_coeffs[180] =   0.000457;
// assign chan_coeffs[181] =   0.000450;
// assign chan_coeffs[182] =   0.000441;
// assign chan_coeffs[183] =   0.000429;
// assign chan_coeffs[184] =   0.000415;
// assign chan_coeffs[185] =   0.000398;
// assign chan_coeffs[186] =   0.000380;
// assign chan_coeffs[187] =   0.000361;
// assign chan_coeffs[188] =   0.000342;
// assign chan_coeffs[189] =   0.000324;
// assign chan_coeffs[190] =   0.000308;
// assign chan_coeffs[191] =   0.000295;
// assign chan_coeffs[192] =   0.000285;
// assign chan_coeffs[193] =   0.000279;
// assign chan_coeffs[194] =   0.000276;
// assign chan_coeffs[195] =   0.000278;
// assign chan_coeffs[196] =   0.000284;
// assign chan_coeffs[197] =   0.000294;
// assign chan_coeffs[198] =   0.000307;
// assign chan_coeffs[199] =   0.000322;

initial begin  
  foreach (coeffs_array[i]) begin
    coeffs_array[i] = chan_coeffs[i];
  end
end

endmodule


// HDL file - wavshared_gf12lp_dig_lib, FF1P5_D1_GL16_LVT, systemVerilog.

//systemVerilog HDL for "wavshared_tsmc12ffc_lib", "FF1P5_D1_GL16_LVT" "systemVerilog"

module WavD2DAnalogPhy_8lane_gf12lpp_FF1P5_D1_GL16_LVT ( q, q1p5, clk, clkb, d
`ifdef WLOGIC_MODEL_NO_TIE
`else
,tielo, tiehi
`endif //WLOGIC_MODEL_NO_TIE
`ifdef WLOGIC_MODEL_NO_PG
`else
, vss, vdd 
`endif //WLOGIC_MODEL_NO_PG
);

  output q;
  output q1p5;
  input d;
  input clk;
  input clkb;
`ifdef WLOGIC_MODEL_NO_TIE
`else
  input tiehi;
  input tielo;
`endif //WLOGIC_MODEL_NO_TIE
`ifdef WLOGIC_MODEL_NO_PG
`else
  inout vdd;
  inout vss;
`endif //WLOGIC_MODEL_NO_PG

  reg q0p5;
  reg q1p5;
  wire q; 
  reg q_int;

`ifdef WLOGIC_MODEL_NO_TIE
`else

`ifdef WLOGIC_TIE_CHECK
  wire   signals_ok;
  assign signals_ok = tiehi & ~tielo;
  
  initial  begin
       q_int = (signals_ok) ? 1'bz : 1'bx;
       q1p5  = (signals_ok) ? 1'bz : 1'bx;
  end
  always @(*) begin
       q_int = (signals_ok) ? 1'bz : 1'bx;
       q1p5  = (signals_ok) ? 1'bz : 1'bx;
  end
`endif // WLOGIC_TIE_CHECK

`endif //WLOGIC_MODEL_NO_TIE


`ifdef WLOGIC_MODEL_NO_PG
`else

`ifdef WLOGIC_PWR_CHECK
  wire   power_ok;
  assign power_ok = ~vss & vdd;
  
  initial  begin
       q_int = (power_ok) ? 1'bz : 1'bx;
       q1p5  = (power_ok) ? 1'bz : 1'bx;
  end
  always @(*) begin
       q_int = (power_ok) ? 1'bz : 1'bx;
       q1p5  = (power_ok) ? 1'bz : 1'bx;
  end
`endif //WLOGIC_PWR_CHECK

`endif //WLOGIC_MODEL_NO_PG



 always @(clk or d) begin
    if (~clk) begin
      q0p5<=d;
    end
  end

  always @ (clk or q0p5) begin
    if (clk) begin
      q_int<=q0p5;
    end
  end
assign q= q_int;

  always @ (clk or q) begin
    if (~clk) begin
      q1p5<=q;
    end
  end
endmodule

// HDL file - wavshared_gf12lp_dig_lib, INV_D4_GL16_LVT, systemVerilog.

//systemVerilog HDL for "wavshared_ln08lpu_dig_lib", "INV_D4_GL16_LVT" "systemVerilog"


module WavD2DAnalogPhy_8lane_gf12lpp_INV_D4_GL16_LVT ( in, out
`ifdef WLOGIC_MODEL_NO_PG
`else
, vdd, vss
`endif //WLOGIC_MODEL_NO_PG
);

  input in;
  output out;
`ifdef WLOGIC_MODEL_NO_PG
`else
  inout vdd;
  inout vss;
`endif //WLOGIC_MODEL_NO_PG

`ifdef WLOGIC_MODEL_NO_PG
`else

`ifdef WLOGIC_PWR_CHECK
  wire   power_ok;
  assign power_ok = ~vss & vdd;
  
  assign out = (power_ok) ? 1'bz : 1'bx;

`endif //WLOGIC_PWR_CHECK

`endif //WLOGIC_MODEL_NO_PG

   assign out = ~in;

endmodule

// HDL file - wavshared_gf12lp_dig_lib, INV_D2_GL16_LVT_Mmodel_delay, systemVerilog.

//systemVerilog HDL for "wavshared_tsmc12ffc_lib", "INV_D2_GL16_LVT_Mmodel_delay"
//"systemVerilog"

`timescale 1ps/1ps

module WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT_Mmodel_delay( in, out
`ifdef WLOGIC_MODEL_NO_PG
`else
, vdd, vss
`endif //WLOGIC_MODEL_NO_PG
);

  input in;
  output out;
`ifdef WLOGIC_MODEL_NO_PG
`else
  inout vdd;
  inout vss;
`endif //WLOGIC_MODEL_NO_PG

`ifdef WLOGIC_MODEL_NO_PG
`else

`ifdef WLOGIC_PWR_CHECK
  wire   power_ok;
  assign power_ok = ~vss & vdd;
  
  assign out = (power_ok) ? 1'bz : 1'bx;

`endif //WLOGIC_PWR_CHECK

`endif //WLOGIC_MODEL_NO_PG

   assign #12 out = ~in;

endmodule

// HDL file - wavshared_gf12lp_dig_lib, PUDUM_D1_GL16_LVT, systemVerilog.

//systemVerilog HDL for "wavshared_tsmc12ffc_lib", "PUDUM_D1_GL16_LVT" "systemVerilog"


module WavD2DAnalogPhy_8lane_gf12lpp_PUDUM_D1_GL16_LVT ( tiehi
`ifdef WLOGIC_MODEL_NO_PG
`else
, vdd 
`endif //WLOGIC_MODEL_NO_PG
);

  input tiehi;
`ifdef WLOGIC_MODEL_NO_PG
`else
  inout vdd;
`endif //WLOGIC_MODEL_NO_PG

endmodule

// HDL file - wavshared_gf12lp_ana_lib, hbm_d2d, functional.

//Verilog HDL for "wavshared_gf12lp_ana_lib", "hbm" "functional"


module WavD2DAnalogPhy_8lane_gf12lpp_hbm_d2d ( pad, vdd, vss );

  inout pad;
  inout vdd;
  inout vss;
endmodule

// HDL file - wphy_gf12lp_d2d_serdes_lib, wav_d2d_rx_sv_switch, systemVerilog.

//systemVerilog HDL for "wphy_gf12lp_d2d_serdes_lib", "wav_d2d_rx_sv_switch"
//"systemVerilog"


module WavD2DAnalogPhy_8lane_gf12lpp_wav_d2d_rx_sv_switch ( out, pad_in, serlb_in, vref_in );

  input pad_in;
  input var real vref_in;
  output var real out;
  input serlb_in;

real pad_real;
real serlb_real;

assign pad_real   = pad_in === 1'bz   ? 0.0 : (pad_in === 1'bx   ? 100.0 : (pad_in ? 200.0 : 0.0));
assign serlb_real = serlb_in === 1'bz ? 0.0 : (serlb_in === 1'bx ? 100.0 : (serlb_in ? 200.0 : 0.0));

assign out = vref_in + pad_real + serlb_real;
endmodule

// HDL file - wavshared_gf12lp_ana_lib, cdm_50ohm_d2d, systemVerilog.


//systemVerilog HDL for "wavshared_gf12lp_ana_lib", "cdm" "systemVerilog"

module WavD2DAnalogPhy_8lane_gf12lpp_cdm_50ohm_d2d ( out, pad, vdd, vss );
  input pad;
  inout vdd;
  output out;
  inout vss;

assign out = vdd & ~vss ? pad : 1'bx;

endmodule
// HDL file - wphy_gf12lp_d2d_serdes_lib, d2d_hyst_rx, systemVerilog.

//systemVerilog HDL for "wmx_d2d_serdes_lib", "wmx_d2d_hyst_rx" "systemVerilog"


module WavD2DAnalogPhy_8lane_gf12lpp_d2d_hyst_rx ( out, vdda, vss, en, in );

  input var real in;
  inout vdda;
  output out;
  input en;
  inout vss;

  wire power_ok;
  reg out_int;
  
  assign power_ok = vdda & ~vss;

  always @(*) begin
	if (power_ok & en) begin
		if (in > 100.0) out_int = 1'b1;
		else out_int = 1'b0;
	end
	else out_int = 1'b0;
  end

assign out = out_int;

endmodule

// HDL file - wphy_gf12lp_d2d_serdes_lib, wav_d2d_vref_switch, systemVerilog.

//systemVerilog HDL for "wphy_gf12lp_d2d_serdes_lib", "wav_d2d_vref_switch"
//"systemVerilog"


module WavD2DAnalogPhy_8lane_gf12lpp_wav_d2d_vref_switch ( out, vdda, vss, cal_enb, cal_enbuf, vref_dp );

  input var real vref_dp;
  input cal_enbuf;
  inout vdda;
  output var real out;
  input cal_enb;
  inout vss;

wire power_ok = vdda & ~vss;

real local_vref;

always @(ICLK_RX.VREF_GEN.irefp) begin
  local_vref  = ICLK_RX.VREF_GEN.irefp;
end

//assign out = cal_enbuf & ~cal_enb ? vref_dp : 0.0;
assign out = cal_enbuf & ~cal_enb ? local_vref : 0.0;
endmodule

// HDL file - wphy_gf12lp_d2d_serdes_lib, d2d_rx_term_res, functional.

//Verilog HDL for "wmx_d2d_serdes_lib", "wmx_d2d_rx_term_res" "functional"


module WavD2DAnalogPhy_8lane_gf12lpp_d2d_rx_term_res ( pad,  vss, odt_ctrl, odt_dc );

  inout pad;
  input  [3:0] odt_ctrl;
  //inout vdda;
  input odt_dc;
  inout vss;
endmodule

// HDL file - wphy_gf12lp_d2d_serdes_lib, d2d_serlb_switch, systemVerilog.

//systemVerilog HDL for "wmx_d2d_serdes_lib", "wmx_d2d_serlb_switch" "systemVerilog"


module WavD2DAnalogPhy_8lane_gf12lpp_d2d_serlb_switch ( out, vdda, vss, serlb_enb, serlb_enbuf, serlb_in
);

  input serlb_enb;
  inout vdda;
  output  out;
  input serlb_in;
  input serlb_enbuf;
  inout vss;

  wire power_ok;
  assign power_ok = vdda & ~vss;

assign out = power_ok ? (serlb_enbuf & ~serlb_enb ? serlb_in : 1'bz) : 1'bx;

endmodule

// HDL file - gf12lp_rpll_lib, rpll_14g_vco_v2, systemVerilog.

//systemVerilog HDL for "gf12lp_rpll_lib", "rpll_14g_vco_v2" "systemVerilog"

`timescale 1ns/1fs

module WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_vco_v2 ( clk0, clk90, clk180, clk270, vdda, vddr, vss, en );

  input real vddr;
  input vdda;
  output clk270;
  output clk90;
  output clk180;
  output clk0;
  input en;
  input vss;


parameter real          freerun         = 10e6;
wire      power_good = vdda & ~vss;
wire      en_int     = power_good && en;
real freq;
real clk_per = 100;
reg  clk0_int = 0; 
reg  clk90_int = 0;

always @(*) begin
  freq = (-6.402e11 * (vddr**3)) + (8.5e11 * (vddr**2)) - (2.748e11 * vddr) +2.503e10;
  if(freq < freerun || (vddr <0.25)) begin
    freq = freerun;
  end
  clk_per = (1e9 / freq);
end

always begin
  #(clk_per/2)    clk0_int <= ~clk0_int;
end

always @(clk0_int) begin
  #(clk_per/4)    clk90_int <= clk0_int;
end

assign clk0     = en_int ? clk0_int : 1'b0;
assign clk180   = ~clk0;
assign clk90    = en_int ? clk90_int : 1'b0;
assign clk270   = ~clk90;

endmodule

// HDL file - gf12lp_rpll_lib, rpll_14g_chp_prop_dac_v2, systemVerilog.

//systemVerilog HDL for "gf12lp_rpll_lib", "rpll_14g_chp_prop_dac_v2" "systemVerilog"

`timescale 1ns / 1ps 

module WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_chp_prop_dac_v2 (
  input  wire       vdda,
  input  wire       vss,
  input  var real   iup_prop,
  input  var real   iupb_prop,
  input  var real   idn_prop,
  input  var real   idnb_prop,
  input  wire       ena,
  
  input  wire [1:0] c_ctrl,
  input  wire [1:0] r_ctrl,
  
  input  wire [4:0] ctrl,
  
  output var real   iout_prop
);

parameter real  PI2           = 6.283185;
          real  Fp            = 20e6;

wire power_good = vdda & ~vss;
real Ts;
real Ts_time;
real d0, d1;
real prop_scale_fac, up_prop, dn_prop, iprop, iprop_filt, iprop_scale, iprop_scale_old;
real FpFilt;
bit  force_pll;
initial begin
  if ($value$plusargs("RING_PLL_SAMPLE_TIME=%f", Ts)) begin   
  end else begin
    Ts          = 50e-12;
  end 
  
  if ($value$plusargs("RING_PLL_PROP_SCALE_FAC=%f", prop_scale_fac)) begin   //percentage
  end else begin
    prop_scale_fac      = (1 + $random % (4 - 1));
  end
  
  if ($value$plusargs("RING_PLL_CUTOFF_FREQ=%f", FpFilt)) begin   
  end else begin
    FpFilt      = Fp;
  end
  
  if ($test$plusargs("RPLL_FORCE_PLL")) begin   
    force_pll = 1;
  end 
  
  Ts_time                 = force_pll ? 1e9 : Ts/1e-9;
  d0 = 1 + (2 / (PI2 * FpFilt * Ts));  
  d1 = 1 - (2 / (PI2 * FpFilt * Ts));
end


//RC 
// always @(*) begin
//   Fp = 6e6 + ({r_ctrl, c_ctrl} * 1e6);
//   d0 = 1 + (2 / (PI2 * FpFilt * Ts));  
//   d1 = 1 - (2 / (PI2 * FpFilt * Ts));
// end


//Current diff from Up/Down and with scaling factor
always @(*) begin
  iprop             = ((iup_prop * ctrl)*2.0) - ((idn_prop * ctrl)*2.0);
end

// Filter
always #(Ts_time) begin
  if(power_good && ~force_pll && ena) begin
    iprop_scale     = iprop;

    iprop_filt      = (iprop_scale + iprop_scale_old - (iprop_filt*d1)) / d0;
    iprop_scale_old = iprop_scale;
  end
end

assign iout_prop = iprop_filt;

endmodule


// HDL file - gf12lp_rpll_lib, rpll_14g_filter_int_v2, systemVerilog.

//systemVerilog HDL for "gf12lp_rpll_lib", "rpll_14g_filter_int_v2" "systemVerilog"


`timescale 1ns / 1ps 

module WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_filter_int_v2 (
  input  var real   iup_int,
  input  var real   iupb_int,
  input  var real   idn_int,
  input  var real   idnb_int,
  input  wire   vdbl,
  input  wire   vdda,
  input  wire   vss,

  input  wire   ena,
  input  wire   enb,
  
  output var real  iout_up,
  output var real  iout_dn
);

parameter real  Fp  = 20e6;
parameter real  PI2 = 6.283185;

wire power_good = vdda & ~vss;

wire en_int = power_good & ena & ~enb;

real iout_up_int;
real iout_dn_int;

real d0, d1;
real Ts;
real Ts_time;
bit  force_pll;
initial begin
  if ($value$plusargs("RING_PLL_SAMPLE_TIME=%f", Ts)) begin   
  end else begin
    Ts          = 50e-12;
  end 
  
  if ($test$plusargs("RPLL_FORCE_PLL")) begin   
    force_pll = 1;
  end 
  
  Ts_time                 = force_pll ? 1e9 : Ts/1e-9;
  d0 = 1 + (2 / (PI2 * Fp * Ts));  
  d1 = 1 - (2 / (PI2 * Fp * Ts));
end


assign iout_up_int = power_good ? iup_int / 256 : 0;
assign iout_dn_int = power_good ? idn_int / 256 : 0;


real up_filt, up_filt_in, up_filt_old;
real dn_filt, dn_filt_in, dn_filt_old;

always #(Ts_time) begin
  if(power_good && ~force_pll && en_int) begin
    // UP
    up_filt_in      = iout_up_int;
    up_filt         = (up_filt_in + up_filt_old - (up_filt*d1)) / d0;
    up_filt_old     = up_filt_in;
    
    // DN
    dn_filt_in      = iout_dn_int;
    dn_filt         = (dn_filt_in + dn_filt_old - (dn_filt*d1)) / d0;
    dn_filt_old     = dn_filt_in;
  end else begin
    up_filt = 0;
    dn_filt = 0;
  end
end

assign iout_up = up_filt;
assign iout_dn = dn_filt;

endmodule


// HDL file - gf12lp_rpll_lib, rpll_filter_cap_20pF_v2, systemVerilog.

`timescale 1ns / 1ps 

module WavD2DAnalogPhy_8lane_gf12lpp_rpll_filter_cap_20pF_v2 (  
  input   var real iup,
  input   var real idn,
  input   wire     ena,
  input   wire     vdda,
  input   wire     vss,
  output  var real vcap
);


wire en_int = ena & vdda & ~vss;
real Ts;
real Ts_time;
real d0, d1;
real FpFilt;
real                     Fp              = 200e6;
parameter real          Vint_scale              = 0.45;
parameter real          C_int                   = 20e-12;               //Capacitance for int path
real Vint, Vint_old;
parameter real    PI2             = 6.283185;

real delay_val = 1e-3; //mV/ms

bit   force_pll;
initial begin
  if ($value$plusargs("RING_PLL_SAMPLE_TIME=%f", Ts)) begin   
  end else begin
    Ts          = 50e-12;
  end 
  if ($value$plusargs("RING_PLL_CUTOFF_FREQ=%f", FpFilt)) begin   
  end else begin
    FpFilt      = Fp;
  end
  
  if ($test$plusargs("RPLL_FORCE_PLL")) begin   
    force_pll = 1;
  end 
  
  Ts_time                 = force_pll ? 1e9 : Ts/1e-9;
  d0 = 1 + (2 / (PI2 * FpFilt * Ts));  
  d1 = 1 - (2 / (PI2 * FpFilt * Ts));
  
  //mV val div by number of setps in ms
  delay_val = delay_val / (1e6 / Ts_time);
end


always #(Ts_time) begin
  if(en_int && ~force_pll) begin
          Vint        = Vint_old + (((iup - idn) * Ts) / C_int) - delay_val; 
    Vint_old            = Vint > 0 ? Vint : 0;
  end else begin
    Vint        = 0; 
    Vint_old            = 0;
  end
end

assign vcap = Vint;

endmodule
// HDL file - gf12lp_rpll_lib, rpll_14g_ipsum_v2, systemVerilog.

//systemVerilog HDL for "gf12lp_rpll_lib", "rpll_14g_ipsum_v2" "systemVerilog"


module WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_ipsum_v2 ( vring, vdda, vss, iprop, vint );

  input var real vint;
  input var real iprop;
  output var real vring;
  inout vdda;
  inout vss;

  parameter R = 12;     //ohms
  parameter SFG = 0.7; //source follower gain

  assign vring = ((vint * SFG) + (iprop * R));

endmodule


// HDL file - gf12lp_rpll_lib, rpll_14g_dbl_v2, functional.

//Verilog HDL for "wmx_rpll_lib", "rpll_14g_dbl" "functional"

`timescale 1ns/1ps
module WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_dbl_v2 ( vdbl, vdda, vss, clksel, divclk, en, refclk );

  input refclk;
  input clksel;
  output reg vdbl;
  inout vdda;
  input divclk;
  input en;
  inout vss;
  parameter real VDBL_DELAY = 1000 ;	//1us delay from the time refclk/divclk edge is seen
  
  /*
  * clksel = 0 -- refclk
  * clksel = 1 -- divclk
  *
  * One of these clocks needs to be running for this to work. Hold the vdbl until
  * and edge of the selected clock is seen
  */
  
  wire en_int;
  wire sel_clk_int;
  
  
  assign en_int			= en & vdda & ~vss;
  assign sel_clk_int		= clksel ? divclk : refclk;
  
  always @(*) begin
  	if(en_int) begin
    	@(posedge sel_clk_int);
      #(VDBL_DELAY) vdbl = 1'b1;
    end else begin
    	vdbl = 1'b0;
    end
  end
  

endmodule


// HDL file - gf12lp_rpll_lib, rpll_bias, functional.

//Verilog HDL for "wmx_rpll_lib", "rpll_14g_bias" "functional"




`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_rpll_bias ( nbias_cp, bias_lvl, en, vdda, vss );


  output  reg nbias_cp;

  input  en ;
  inout vdda, vss;

  input [3:0]  bias_lvl;

	real bias_delay;

  wire en_int = en & vdda & ~vss;

  
  integer seed;
  initial begin
	  if ($value$plusargs("SEED=%d", seed)) begin   
    end
    else 
  	  seed = $random;
  end
  
  
  always @(*) begin
  	if(en_int) begin
    	bias_delay								  = 20 + {$random(seed)}%(100-20);			//random delay of 20-100ns
    	#(bias_delay)			nbias_cp  =	en_int ; 
                        
    end else begin
    										nbias_cp  = 1'b0;
                        
    end
  end

endmodule

// HDL file - wavshared_gf12lp_dig_lib, INV_D1_GL16_LVT_Mmod_delay, systemVerilog.

//systemVerilog HDL for "wavshared_tsmc12ffc_lib", "INV_D1_GL16_LVT_Mmod_delay"
//"systemVerilog"

`timescale 1ns/1ps

module WavD2DAnalogPhy_8lane_gf12lpp_INV_D1_GL16_LVT_Mmod_delay( in, out, tiehi, tielo
`ifdef WLOGIC_MODEL_NO_PG
`else
, vdd, vss
`endif //WLOGIC_MODEL_NO_PG
);

  input in;
  output out;
  input tiehi;
  input tielo;
`ifdef WLOGIC_MODEL_NO_PG
`else
  inout vdd;
  inout vss;
`endif //WLOGIC_MODEL_NO_PG

  wire out;

`ifdef WLOGIC_MODEL_NO_PG
`else

`ifdef WLOGIC_PWR_CHECK
  wire   power_ok;
  assign power_ok = ~vss & vdd & tiehi & ~tielo;
  
  assign out = (power_ok) ? 1'bz : 1'bx;

`endif //WLOGIC_PWR_CHECK

`endif //WLOGIC_MODEL_NO_PG

   assign #0.01 out = ~in;

endmodule

// HDL file - wavshared_gf12lp_dig_lib, INV_D1_GL16_LVT, systemVerilog.

//systemVerilog HDL for "wavshared_tsmc12ffc_lib", "INV_D1_GL16_LVT" "systemVerilog"

module WavD2DAnalogPhy_8lane_gf12lpp_INV_D1_GL16_LVT( in, out
`ifdef WLOGIC_MODEL_NO_TIE
`else
,tielo, tiehi
`endif //WLOGIC_MODEL_NO_TIE
`ifdef WLOGIC_MODEL_NO_PG
`else
, vdd, vss
`endif //WLOGIC_MODEL_NO_PG
);

  input in;
  output out;
`ifdef WLOGIC_MODEL_NO_TIE
`else
  input tiehi;
  input tielo;
`endif //WLOGIC_MODEL_NO_TIE
`ifdef WLOGIC_MODEL_NO_PG
`else
  inout vdd;
  inout vss;
`endif //WLOGIC_MODEL_NO_PG

`ifdef WLOGIC_MODEL_NO_TIE
`else

`ifdef WLOGIC_TIE_CHECK
  wire   signals_ok;
  assign signals_ok = tiehi & ~tielo;
  
  assign out = (signals_ok) ? 1'bz : 1'bx;
`endif // WLOGIC_TIE_CHECK

`endif //WLOGIC_MODEL_NO_TIE

`ifdef WLOGIC_MODEL_NO_PG
`else

`ifdef WLOGIC_PWR_CHECK
  wire   power_ok;
  assign power_ok = ~vss & vdd;
  
  assign out = (power_ok) ? 1'bz : 1'bx;

`endif //WLOGIC_PWR_CHECK

`endif //WLOGIC_MODEL_NO_PG

   assign out =  ~in;

endmodule

// HDL file - wavshared_gf12lp_dig_lib, PDDUM_D2_GL16_LVT, systemVerilog.

//systemVerilog HDL for "wavshared_tsmc12ffc_lib", "PDDUM_D2_GL16_LVT" "systemVerilog"


module WavD2DAnalogPhy_8lane_gf12lpp_PDDUM_D2_GL16_LVT ( tielo
`ifdef WLOGIC_MODEL_NO_PG
`else
, vss
`endif //WLOGIC_MODEL_NO_PG
); 

  input tielo;
`ifdef WLOGIC_MODEL_NO_PG
`else
  inout vss;
`endif //WLOGIC_MODEL_NO_PG

endmodule

// HDL file - wavshared_gf12lp_dig_lib, LAT_D1_GL16_LVT, systemVerilog.

//systemVerilog HDL for "wavshared_tsmc12ffc_lib", "LAT_D1_GL16_LVT" "systemVerilog"

`timescale 1ps/1ps
module WavD2DAnalogPhy_8lane_gf12lpp_LAT_D1_GL16_LVT( q, clk, clkb, d
`ifdef WLOGIC_MODEL_NO_TIE
`else
, tiehi, tielo
`endif //WLOGIC_MODEL_NO_TIE
`ifdef WLOGIC_MODEL_NO_PG
`else
, vss, vdd 
`endif //WLOGIC_MODEL_NO_PG
); 
 
  input clk;
  output q;  
  input d;
  input clkb;
`ifdef WLOGIC_MODEL_NO_TIE
`else
  input tiehi;
  input tielo;
`endif //WLOGIC_MODEL_NO_TIE
`ifdef WLOGIC_MODEL_NO_PG
`else
  inout vdd;
  inout vss;
`endif //WLOGIC_MODEL_NO_PG


  wire #0 polarity_ok = clk^clkb;

`ifdef WLOGIC_MODEL_NO_TIE
`else

`ifdef WLOGIC_TIE_CHECK
  wire signals_ok;
  assign signals_ok = tiehi & ~tielo;

  assign q = (signals_ok) ? 1'bz : 1'bx;
`endif // WLOGIC_TIE_CHECK

`endif //WLOGIC_MODEL_NO_TIE


`ifdef WLOGIC_MODEL_NO_PG
`else

`ifdef WLOGIC_PWR_CHECK
  wire   power_ok;
  assign power_ok = ~vss & vdd;
 
  assign q = (power_ok) ? 1'bz : 1'bx;
 
`endif //WLOGIC_PWR_CHECK

`endif //WLOGIC_MODEL_NO_PG

assign #1  q = polarity_ok ?
                           (clkb) ?
                                  (d===1'bx) ? $random : d
                                  : q
                           : 1'bx;


endmodule


// HDL file - wavshared_gf12lp_dig_lib, INVT_D2_GL16_LVT, systemVerilog.

//systemVerilog HDL for "wavshared_tsmc12ffc_lib", "INVT_D2_GL16_LVT" "systemVerilog"

module WavD2DAnalogPhy_8lane_gf12lpp_INVT_D2_GL16_LVT( in, out, en, enb 
`ifdef WLOGIC_MODEL_NO_PG
`else
, vdd, vss
`endif //WLOGIC_MODEL_NO_PG
);

  input in;
  input en, enb;
  output out;
`ifdef WLOGIC_MODEL_NO_PG
`else
  inout vdd;
  inout vss;
`endif //WLOGIC_MODEL_NO_PG

  wire out;

`ifdef WLOGIC_MODEL_NO_PG
`else

`ifdef WLOGIC_PWR_CHECK
  wire   power_ok;
  assign power_ok = ~vss & vdd;
  
  assign out = (power_ok) ? 1'bz : 1'bx;

`endif //WLOGIC_PWR_CHECK

`endif //WLOGIC_MODEL_NO_PG



assign out = (en) ? ~in:1'bz;


endmodule

// HDL file - wavshared_gf12lp_dig_lib, PU_D2_GL16_LVT, systemVerilog.

//systemVerilog HDL for "wavshared_tsmc12ffc_lib", "PU_D2_GL16_LVT" "systemVerilog"


module WavD2DAnalogPhy_8lane_gf12lpp_PU_D2_GL16_LVT ( en, y
`ifdef WLOGIC_MODEL_NO_PG
`else
, vdd 
`endif //WLOGIC_MODEL_NO_PG
);

  input y;
  input en;
`ifdef WLOGIC_MODEL_NO_PG
`else
  inout vdd;
`endif //WLOGIC_MODEL_NO_PG

`ifdef WLOGIC_MODEL_NO_PG
`else

`ifdef WLOGIC_PWR_CHECK
  wire   power_ok;
  assign power_ok = vdd;
  
  assign y = (power_ok) ? 1'bz : 1'bx;

`endif //WLOGIC_PWR_CHECK

`endif //WLOGIC_MODEL_NO_PG

 assign  y = en ? 1'bz : 1'b1;

endmodule

// HDL file - wavshared_gf12lp_dig_lib, PD_D2_GL16_LVT, systemVerilog.

//systemVerilog HDL for "wavshared_tsmc12ffc_lib", "PD_D2_GL16_LVT" "systemVerilog"


module WavD2DAnalogPhy_8lane_gf12lpp_PD_D2_GL16_LVT ( enb, y
`ifdef WLOGIC_MODEL_NO_PG
`else
, vss
`endif //WLOGIC_MODEL_NO_PG
); 

  input y;
  input enb;

`ifdef WLOGIC_MODEL_NO_PG
`else
  inout vss;
`endif //WLOGIC_MODEL_NO_PG

`ifdef WLOGIC_MODEL_NO_PG
`else

`ifdef WLOGIC_PWR_CHECK
  wire   power_ok;
  assign power_ok = ~vss ;
  
  assign y = (power_ok) ? 1'bz : 1'bx;

`endif //WLOGIC_PWR_CHECK

`endif //WLOGIC_MODEL_NO_PG

  assign y =  enb ? 1'b0 : 1'bz;
endmodule

// HDL file - wavshared_gf12lp_dig_lib, DUMLOAD_D2_GL16_LVT, systemVerilog.

//systemVerilog HDL for "wavshared_tsmc12ffc_lib", "DUMLOAD_D1_GL16_LVT" "systemVerilog"


module WavD2DAnalogPhy_8lane_gf12lpp_DUMLOAD_D2_GL16_LVT ( inp, inn
`ifdef WLOGIC_MODEL_NO_PG
`else
, vss, vdd 
`endif //WLOGIC_MODEL_NO_PG
); 

  input inp;
  input inn;
`ifdef WLOGIC_MODEL_NO_PG
`else
  inout vdd;
  inout vss;
`endif //WLOGIC_MODEL_NO_PG


endmodule

// HDL file - wavshared_gf12lp_dig_lib, FF_D1_GL16_LVT, systemVerilog.

//systemVerilog HDL for "wavshared_tsmc12ffc_lib", "FF_D1_GL16_LVT" "systemVerilog"

module WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT( q, clk, clkb, d
`ifdef WLOGIC_MODEL_NO_TIE
`else
,tielo, tiehi
`endif //WLOGIC_MODEL_NO_TIE
`ifdef WLOGIC_MODEL_NO_PG
`else
, vss, vdd
`endif //WLOGIC_MODEL_NO_PG
); 

  input clk;
  output q;
  input d;
  input clkb; 
`ifdef WLOGIC_MODEL_NO_TIE
`else
  input tiehi;
  input tielo;
`endif //WLOGIC_MODEL_NO_TIE
`ifdef WLOGIC_MODEL_NO_PG
`else
  inout vdd;
  inout vss;
`endif //WLOGIC_MODEL_NO_PG

  reg q_int;
  wire q;

`ifdef WLOGIC_MODEL_NO_TIE
`else

`ifdef WLOGIC_TIE_CHECK
  wire   signals_ok;
  assign signals_ok = tiehi & ~tielo;

  initial  begin
       q_int = (signals_ok) ? 1'bz : 1'bx;
  end
  always @(*) begin
       q_int = (signals_ok) ? 1'bz : 1'bx;
  end
`endif // WLOGIC_TIE_CHECK

`endif //WLOGIC_MODEL_NO_TIE

`ifdef WLOGIC_MODEL_NO_PG
`else

`ifdef WLOGIC_PWR_CHECK
  wire   power_ok;
  assign power_ok = ~vss & vdd;
  
  initial  begin
       q_int = (power_ok) ? 1'bz : 1'bx;
  end
  always @(*) begin
       q_int = (power_ok) ? 1'bz : 1'bx;
  end
`endif //WLOGIC_PWR_CHECK

`endif //WLOGIC_MODEL_NO_PG


  assign q= q_int;

  initial begin
    q_int = $random;
  end

always @ (posedge clk) q_int<= (d === 1'bx) ? $random : d;

endmodule


// HDL file - wavshared_gf12lp_dig_lib, FFRES_D1_GL16_LVT, systemVerilog.

//systemVerilog HDL for "wavshared_tsmc12ffc_lib", "FFRES_D1_GL16_LVT" "systemVerilog"

module WavD2DAnalogPhy_8lane_gf12lpp_FFRES_D1_GL16_LVT( q, clk, clkb, d, rst, rstb
`ifdef WLOGIC_MODEL_NO_TIE
`else
,tielo, tiehi
`endif //WLOGIC_MODEL_NO_TIE
`ifdef WLOGIC_MODEL_NO_PG
`else
, vss, vdd 
`endif //WLOGIC_MODEL_NO_PG
); 

  input clk;
  input rst;
  input rstb;
  output q;
  input d;
  input clkb; 
`ifdef WLOGIC_MODEL_NO_TIE
`else
  input tiehi;
  input tielo;
`endif //WLOGIC_MODEL_NO_TIE
  reg q;
`ifdef WLOGIC_MODEL_NO_PG
`else
  inout vdd;
  inout vss;
`endif //WLOGIC_MODEL_NO_PG

`ifdef WLOGIC_MODEL_NO_TIE
`else

`ifdef WLOGIC_TIE_CHECK
  wire   signals_ok;
  assign signals_ok = tiehi & ~tielo;

  initial  begin
       q = (signals_ok) ? 1'bz : 1'bx;
  end
  always @(*) begin
       q = (signals_ok) ? 1'bz : 1'bx;
  end
`endif // WLOGIC_TIE_CHECK

`endif //WLOGIC_MODEL_NO_TIE


`ifdef WLOGIC_MODEL_NO_PG
`else

`ifdef WLOGIC_PWR_CHECK
  wire   power_ok;
  assign power_ok = ~vss & vdd;
  
  initial  begin
       q = (power_ok) ? 1'bz : 1'bx;
  end
  always @(*) begin
       q = (power_ok) ? 1'bz : 1'bx;
  end
`endif //WLOGIC_PWR_CHECK

`endif //WLOGIC_MODEL_NO_PG

  initial begin
    q = $random;
  end

  always @(posedge clk or posedge rst) begin
   if(rst) begin
       q <= 1'b0;
    end else begin
       q <= d;
    end
  end

endmodule

// HDL file - wavshared_gf12lp_dig_lib, PU_D1_GL16_LVT, systemVerilog.

//systemVerilog HDL for "wavshared_tsmc12ffc_lib", "PU_D1_GL16_LVT" "systemVerilog"


module WavD2DAnalogPhy_8lane_gf12lpp_PU_D1_GL16_LVT ( en, y
`ifdef WLOGIC_MODEL_NO_PG
`else
, vdd 
`endif //WLOGIC_MODEL_NO_PG
);

  input y;
  input en;
`ifdef WLOGIC_MODEL_NO_PG
`else
  inout vdd;
`endif //WLOGIC_MODEL_NO_PG

`ifdef WLOGIC_MODEL_NO_PG
`else

`ifdef WLOGIC_PWR_CHECK
  wire   power_ok;
  assign power_ok = vdd;
  
  assign y = (power_ok) ? 1'bz : 1'bx;

`endif //WLOGIC_PWR_CHECK

`endif //WLOGIC_MODEL_NO_PG

 assign y = en ? 1'bz : 1'b1;

endmodule

// HDL file - wavshared_gf12lp_dig_lib, INV_D1_GL16_LVT_Mmod_nomodel, systemVerilog.

//systemVerilog HDL for "wavshared_tsmc12ffc_lib", "INV_D1_GL16_LVT_Mmod_nomodel"
//"systemVerilog"


module WavD2DAnalogPhy_8lane_gf12lpp_INV_D1_GL16_LVT_Mmod_nomodel ( in, out, tiehi, tielo
`ifdef WLOGIC_MODEL_NO_PG
`else
, vdd, vss
`endif //WLOGIC_MODEL_NO_PG
);

  input in;
  output out;
  input tiehi;
  input tielo;
`ifdef WLOGIC_MODEL_NO_PG
`else
  inout vdd;
  inout vss;
`endif //WLOGIC_MODEL_NO_PG

endmodule

// HDL file - wavshared_gf12lp_dig_lib, XG_D1_GL16_LVT, systemVerilog.

//systemVerilog HDL for "wavshared_tsmc12ffc_lib", "XG_D1_GL16_LVT" "systemVerilog"


module WavD2DAnalogPhy_8lane_gf12lpp_XG_D1_GL16_LVT ( y, en, enb, a
`ifdef WLOGIC_MODEL_NO_PG
`else
, vss, vdd 
`endif //WLOGIC_MODEL_NO_PG
); 

  input a;
  input en;
  output y;
  input enb;
`ifdef WLOGIC_MODEL_NO_PG
`else
  inout vdd;
  inout vss;
`endif //WLOGIC_MODEL_NO_PG

`ifdef WLOGIC_MODEL_NO_PG
`else

`ifdef WLOGIC_PWR_CHECK
  wire   power_ok;
  assign power_ok = ~vss & vdd;
  
  assign y = (power_ok) ? 1'bz : 1'bx;

`endif //WLOGIC_PWR_CHECK

`endif //WLOGIC_MODEL_NO_PG


assign y = (en && ~enb) ? a:1'bz;

endmodule

// HDL file - wavshared_gf12lp_dig_lib, PD_D1_GL16_LVT, systemVerilog.

//systemVerilog HDL for "wavshared_tsmc12ffc_lib", "PD_D1_GL16_LVT" "systemVerilog"

module WavD2DAnalogPhy_8lane_gf12lpp_PD_D1_GL16_LVT( enb, y
`ifdef WLOGIC_MODEL_NO_PG
`else
, vss
`endif //WLOGIC_MODEL_NO_PG
); 

  input y;
  input enb;

`ifdef WLOGIC_MODEL_NO_PG
`else
  inout vss;
`endif //WLOGIC_MODEL_NO_PG

`ifdef WLOGIC_MODEL_NO_PG
`else

`ifdef WLOGIC_PWR_CHECK
  wire   power_ok;
  assign power_ok = ~vss ;
  
  assign y = (power_ok) ? 1'bz : 1'bx;

`endif //WLOGIC_PWR_CHECK

`endif //WLOGIC_MODEL_NO_PG

  assign y =  enb ? 1'b0 : 1'bz;

endmodule

// HDL file - wavshared_gf12lp_dig_lib, NAND3_D1_GL16_LVT, systemVerilog.

//systemVerilog HDL for "wavshared_tsmc12ffc_lib", "NAND3_D1_GL16_LVT" "systemVerilog"


module WavD2DAnalogPhy_8lane_gf12lpp_NAND3_D1_GL16_LVT ( y, a, b, c
`ifdef WLOGIC_MODEL_NO_TIE
`else
,tielo, tiehi
`endif //WLOGIC_MODEL_NO_TIE
`ifdef WLOGIC_MODEL_NO_PG
`else
, vss, vdd 
`endif //WLOGIC_MODEL_NO_PG
); 

  input c;
  input b;
  input a;
  output y;
`ifdef WLOGIC_MODEL_NO_TIE
`else
  input tiehi;
  input tielo;
`endif //WLOGIC_MODEL_NO_TIE
`ifdef WLOGIC_MODEL_NO_PG
`else
  inout vdd;
  inout vss;
`endif //WLOGIC_MODEL_NO_PG

`ifdef WLOGIC_MODEL_NO_TIE
`else

`ifdef WLOGIC_TIE_CHECK
  wire   signals_ok;
  assign signals_ok = tiehi & ~tielo;
  
  assign y = (signals_ok) ? 1'bz : 1'bx;
`endif // WLOGIC_TIE_CHECK

`endif //WLOGIC_MODEL_NO_TIE

`ifdef WLOGIC_MODEL_NO_PG
`else

`ifdef WLOGIC_PWR_CHECK
  wire   power_ok;
  assign power_ok = ~vss & vdd;
  
  assign y = (power_ok) ? 1'bz : 1'bx;

`endif //WLOGIC_PWR_CHECK

`endif //WLOGIC_MODEL_NO_PG

 assign y = ~(a&b&c);
endmodule

// HDL file - wavshared_gf12lp_dig_lib, NAND2_D1_GL16_LVT, systemVerilog.

//systemVerilog HDL for "wavshared_tsmc12ffc_lib", "NAND2_D1_GL16_LVT" "systemVerilog"


module WavD2DAnalogPhy_8lane_gf12lpp_NAND2_D1_GL16_LVT ( y, a, b
`ifdef WLOGIC_MODEL_NO_TIE
`else
,tielo, tiehi
`endif //WLOGIC_MODEL_NO_TIE
`ifdef WLOGIC_MODEL_NO_PG
`else
, vss, vdd 
`endif //WLOGIC_MODEL_NO_PG
); 

  input b;
  input a;
  output y;
`ifdef WLOGIC_MODEL_NO_TIE
`else
  input tiehi;
  input tielo;
`endif //WLOGIC_MODEL_NO_TIE
`ifdef WLOGIC_MODEL_NO_PG
`else
  inout vdd;
  inout vss;
`endif //WLOGIC_MODEL_NO_PG

`ifdef WLOGIC_MODEL_NO_TIE
`else

`ifdef WLOGIC_TIE_CHECK
  wire   signals_ok;
  assign signals_ok = tiehi & ~tielo;
  
  assign y = (signals_ok) ? 1'bz : 1'bx;
`endif // WLOGIC_TIE_CHECK

`endif //WLOGIC_MODEL_NO_TIE

`ifdef WLOGIC_MODEL_NO_PG
`else

`ifdef WLOGIC_PWR_CHECK
  wire   power_ok;
  assign power_ok = ~vss & vdd;
  
  assign y = (power_ok) ? 1'bz : 1'bx;

`endif //WLOGIC_PWR_CHECK

`endif //WLOGIC_MODEL_NO_PG


 assign y = ~(a&b);

endmodule

// HDL file - wavshared_gf12lp_dig_lib, FFSETRES_D1_GL16_LVT, systemVerilog.

//systemVerilog HDL for "wavshared_tsmc12ffc_lib", "FFSETRES_D1_GL16_LVT" "systemVerilog"

`timescale 1ps/1ps

module WavD2DAnalogPhy_8lane_gf12lpp_FFSETRES_D1_GL16_LVT( q, clk, clkb, d, prst, prstb, rst, rstb
`ifdef WLOGIC_MODEL_NO_TIE
`else
,tielo, tiehi
`endif //WLOGIC_MODEL_NO_TIE
`ifdef WLOGIC_MODEL_NO_PG
`else
, vdd, vss 
`endif //WLOGIC_MODEL_NO_PG
);

  input prst;
  input rst;
  input rstb;
  output reg q;
  input prstb;
  input d;
  input clk;
  input clkb; 
`ifdef WLOGIC_MODEL_NO_TIE
`else
  input tiehi;
  input tielo;
`endif //WLOGIC_MODEL_NO_TIE
`ifdef WLOGIC_MODEL_NO_PG
`else
  inout vdd;
  inout vss;
`endif //WLOGIC_MODEL_NO_PG

`ifdef WLOGIC_MODEL_NO_TIE
`else

`ifdef WLOGIC_TIE_CHECK
  wire   signals_ok;
  assign signals_ok = tiehi & ~tielo;

  initial  begin
       q = (signals_ok) ? 1'bz : 1'bx;
  end
  always @(*) begin
       q = (signals_ok) ? 1'bz : 1'bx;
  end
`endif // WLOGIC_TIE_CHECK

`endif //WLOGIC_MODEL_NO_TIE


`ifdef WLOGIC_MODEL_NO_PG
`else

`ifdef WLOGIC_PWR_CHECK
  wire   power_ok;
  assign power_ok = ~vss & vdd;
  
  initial  begin
       q = (power_ok) ? 1'bz : 1'bx;
  end
  always @(*) begin
       q = (power_ok) ? 1'bz : 1'bx;
  end
`endif //WLOGIC_PWR_CHECK

`endif //WLOGIC_MODEL_NO_PG

  initial begin
   q= $random;
  end
  
  always @(posedge clk or posedge rst or posedge prst) begin
   if(rst & prst) begin
      q <= 1'bx;
    end else if(prst) begin
      q <= 1'b1;
    end else if(rst) begin
        q <= 1'b0;
    end else begin
      q <= d;
    end
  end
endmodule

// HDL file - wavshared_gf12lp_dig_lib, MUXT2_D2_GL16_LVT, systemVerilog.

//systemVerilog HDL for "wavshared_tsmc12ffc_lib", "MUXT2_D2_GL16_LVT" "systemVerilog"

module WavD2DAnalogPhy_8lane_gf12lpp_MUXT2_D2_GL16_LVT( yb, a, b, s, sb
`ifdef WLOGIC_MODEL_NO_PG
`else
, vss, vdd 
`endif //WLOGIC_MODEL_NO_PG
); 

  input a; 
  input sb;
  input s;
  output yb;
  input b;
`ifdef WLOGIC_MODEL_NO_PG
`else
  inout vdd;
  inout vss;
`endif //WLOGIC_MODEL_NO_PG

  wire yb;

`ifdef WLOGIC_MODEL_NO_PG
`else

`ifdef WLOGIC_PWR_CHECK
  wire   power_ok;
  assign power_ok = ~vss & vdd;
  
  assign yb = (power_ok) ? 1'bz : 1'bx;

`endif //WLOGIC_PWR_CHECK

`endif //WLOGIC_MODEL_NO_PG

  assign yb = (s && ~sb) ? ~b:~a;



endmodule

// HDL file - wavshared_gf12lp_dig_lib, INV_D2_GL16_LVT, systemVerilog.

//systemVerilog HDL for "wavshared_tsmc12ffc_lib", "INV_D2_GL16_LVT" "systemVerilog"

`timescale 1ps/1ps

module WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT( in, out
`ifdef WLOGIC_MODEL_NO_PG
`else
, vdd, vss
`endif //WLOGIC_MODEL_NO_PG
);

  input in;
  output out;
`ifdef WLOGIC_MODEL_NO_PG
`else
  inout vdd;
  inout vss;
`endif //WLOGIC_MODEL_NO_PG

`ifdef WLOGIC_MODEL_NO_PG
`else

`ifdef WLOGIC_PWR_CHECK
  wire   power_ok;
  assign power_ok = ~vss & vdd;
  
  assign out = (power_ok) ? 1'bz : 1'bx;

`endif //WLOGIC_PWR_CHECK

`endif //WLOGIC_MODEL_NO_PG

    assign  out = ~in;

endmodule

// HDL file - wavshared_gf12lp_dig_lib, DUM_D1_GL16_LVT, behavioral.

//Verilog HDL for "wavshared_tsmc12ffc_lib", "DUM_D1_GL16_LVT" "functional"


module WavD2DAnalogPhy_8lane_gf12lpp_DUM_D1_GL16_LVT ( tiehi, tielo, vdd, vss );

  input tiehi;
  input tielo;
  inout vdd;
  inout vss;
endmodule

// HDL file - wavshared_gf12lp_dig_lib, NOR2_D1_GL16_LVT, systemVerilog.

//systemVerilog HDL for "wavshared_tsmc12ffc_lib", "NOR2_D1_GL16_LVT" "systemVerilog"


module WavD2DAnalogPhy_8lane_gf12lpp_NOR2_D1_GL16_LVT ( y, a, b
`ifdef WLOGIC_MODEL_NO_TIE
`else
,tielo, tiehi
`endif //WLOGIC_MODEL_NO_TIE
`ifdef WLOGIC_MODEL_NO_PG
`else
, vss, vdd 
`endif //WLOGIC_MODEL_NO_PG
); 

  input b;
  input a;
  output y;
`ifdef WLOGIC_MODEL_NO_TIE
`else
  input tiehi;
  input tielo;
`endif //WLOGIC_MODEL_NO_TIE
`ifdef WLOGIC_MODEL_NO_PG
`else
  inout vdd;
  inout vss;
`endif //WLOGIC_MODEL_NO_PG

`ifdef WLOGIC_MODEL_NO_TIE
`else

`ifdef WLOGIC_TIE_CHECK
  wire   signals_ok;
  assign signals_ok = tiehi & ~tielo;
  
  assign y = (signals_ok) ? 1'bz : 1'bx;
`endif // WLOGIC_TIE_CHECK

`endif //WLOGIC_MODEL_NO_TIE

`ifdef WLOGIC_MODEL_NO_PG
`else

`ifdef WLOGIC_PWR_CHECK
  wire   power_ok;
  assign power_ok = ~vss & vdd;
  
  assign y = (power_ok) ? 1'bz : 1'bx;

`endif //WLOGIC_PWR_CHECK

`endif //WLOGIC_MODEL_NO_PG


  assign y=~(a|b);


endmodule

// HDL file - wavshared_gf12lp_dig_lib, DUM_D1_GL16_RVT, behavioral.

//Verilog HDL for "wavshared_gf12lp_dig_lib", "DUM_D1_GL16_RVT" "behavioral"


module WavD2DAnalogPhy_8lane_gf12lpp_DUM_D1_GL16_RVT ( vdd, vss, tielo, tiehi );

  input tiehi;
  input tielo;
  inout vdd;
  inout vss;
endmodule

// HDL file - wavshared_gf12lp_dig_lib, INV_D2_GL16_RVT, systemVerilog.

//systemVerilog HDL for "wavshared_tsmc12ffc_lib", "INV_D2_GL16_RVT" "systemVerilog"


module WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_RVT ( in, out
`ifdef WLOGIC_MODEL_NO_PG
`else
, vdd, vss
`endif //WLOGIC_MODEL_NO_PG
);

  input in;
  output out;
`ifdef WLOGIC_MODEL_NO_PG
`else
  inout vdd;
  inout vss;
`endif //WLOGIC_MODEL_NO_PG

`ifdef WLOGIC_MODEL_NO_PG
`else

`ifdef WLOGIC_PWR_CHECK
  wire   power_ok;
  assign power_ok = ~vss & vdd;
  
  assign out = (power_ok) ? 1'bz : 1'bx;

`endif //WLOGIC_PWR_CHECK

`endif //WLOGIC_MODEL_NO_PG

   assign out = ~in;

endmodule

// HDL file - gf12lp_rpll_lib, rpll_14g_chp_diff, systemVerilog.

//systemVerilog HDL for "wphy_ln08lpu_rpll_lib", "wphy_rpll_chp_diff" "systemVerilog"


module WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_chp_diff ( out, outb, vdda, vss, bcrnt_en, ictrl, in, inb,
nbias );
  input bcrnt_en;
  input in;
  inout vdda;
  output var real out;
  input  [4:0] ictrl;
  output var real outb;
  input nbias;
  input inb;
  inout vss;

parameter CTRL_AMP = 2e-6;

wire power_good = vdda & ~vss;
wire bias_good  = nbias && (bcrnt_en === 0 || bcrnt_en === 1);

assign out  = in  && bias_good ? (ictrl * CTRL_AMP) : 0;
assign outb = inb && bias_good ? (ictrl * CTRL_AMP) : 0;

endmodule

// HDL file - wphy_gf12lp_ips_lib, wphy_ldo_08to02, systemVerilog.

//systemVerilog HDL for "wphy_gf12lp_ips_lib", "wphy_ldo_08to02" "systemVerilog"


module WavD2DAnalogPhy_8lane_gf12lpp_wphy_ldo_08to02 ( vout, fba, fbb, vdda, vss, byp, ena, highz, ibias_5u,
lvl, mode, refsel );

  input  [7:0] mode;
  input refsel;
  inout fba;
  output reg vout;
  input ibias_5u;
  inout vdda;
  input ena;
  inout fbb;
  input byp;
  input highz;
  input  [5:0] lvl;
  inout vss;

//input power in this case
wire power_ok = vdda & ~vss;

always @(*) begin
  if(power_ok) begin
    casez({ena, highz, byp})
      3'b1??: vout = refsel ? ibias_5u : 1'b1;   //0 - internal, 1 - external bias
      3'b000: vout = 1'b0;
      3'b01?: vout = 1'bz;
      3'b001: vout = 1'b1;
      default: vout= 1'bx;
    endcase
  end else begin
    vout = 1'bx;
  end
end

endmodule
// End HDL models

// Library - gf12lp_rpll_lib, Cell - rpll_14g_csnk_4u_dum_half, View -
//schematic
// LAST TIME SAVED: Mar 18 10:15:21 2021
// NETLIST TIME: Oct  7 15:28:47 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_csnk_4u_dum_half ( 
inout   vss, 
input   nbias );




/*REMOVED VIA SCRIPT -- lvtnfet_b  N2[3:0] ( .b(vss), .d(vss), .s(vss), .g(nbias));*/

endmodule
// Library - gf12lp_rpll_lib, Cell - rpll_14g_chp, View - schematic
// LAST TIME SAVED: Mar 18 10:18:37 2021
// NETLIST TIME: Oct  7 15:28:47 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_chp ( 
output var real  idn_int , 
output var real  idn_prop , 
output var real  idnb_int , 
output var real  idnb_prop , 
output var real  iup_int , 
output var real  iup_prop , 
output var real  iupb_int , 
output var real  iupb_prop , 
inout wire logic   vdda, 
inout wire logic   vss, 
input wire logic   dn, 
input wire logic   dnb, 
input wire logic  [4:0] int_ctrl, 
input wire logic   mode, 
input wire logic   nbias, 
input wire logic   up, 
input wire logic   upb );


wire logic bcrnt_en ;

wire logic net059 ;

// Buses in the design

wire  [4:0]  int_;

wire logic [4:0]  net2;



WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_chp_diff PROP_DN ( .ictrl({vdda, vdda, vdda, vdda, vdda}),
     .vdda(vdda), .out(idn_prop), .outb(idnb_prop),
     .bcrnt_en(bcrnt_en), .in(dn), .inb(dnb), .nbias(nbias),
     .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_chp_diff INT_DN ( .ictrl(int_[4:0]), .vdda(vdda),
     .out(idn_int), .outb(idnb_int), .bcrnt_en(bcrnt_en), .in(dn),
     .inb(dnb), .nbias(nbias), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_chp_diff PROP_UP ( .ictrl({vdda, vdda, vdda, vdda, vdda}),
     .vdda(vdda), .out(iup_prop), .outb(iupb_prop),
     .bcrnt_en(bcrnt_en), .in(up), .inb(upb), .nbias(nbias),
     .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_chp_diff INT_UP ( .ictrl(int_[4:0]), .vdda(vdda),
     .out(iup_int), .outb(iupb_int), .bcrnt_en(bcrnt_en), .in(up),
     .inb(upb), .nbias(nbias), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_csnk_4u_dum_half dum[31:0] ( .vss(vss), .nbias(nbias));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_RVT INV7[4:0] ( .out(net2[4:0]), .vdd(vdda), .vss(vss),
     .in(int_ctrl[4:0]));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_RVT INV0 ( .vdd(vdda), .in(mode), .vss(vss), .out(net059));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_RVT INV1 ( .vdd(vdda), .in(net059), .vss(vss),
     .out(bcrnt_en));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_RVT INV2[4:0] ( .out(int_[4:0]), .vdd(vdda), .vss(vss),
     .in(net2[4:0]));
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUM_D1_GL16_RVT DUM0[1:0] ( .vdd(vdda), .vss(vss), .tiehi(vdda),
     .tielo(vss));*/

endmodule
// Library - gf12lp_rpll_lib, Cell - rpll_14g_fbdiv_logic_unit, View -
//schematic
// LAST TIME SAVED: Jan 20 07:32:46 2021
// NETLIST TIME: Oct  7 15:28:47 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_fbdiv_logic_unit ( 
output wire logic   Q, 
output wire logic   next, 
inout wire logic   vdd, 
inout wire logic   vss, 
input wire logic   T, 
input wire logic   clk, 
input wire logic   clkb, 
input wire logic   load, 
input wire logic   loadval );


wire logic Tb ;

wire logic rst ;

wire logic prst ;

wire logic net015 ;

wire logic prstb ;

wire logic rstb ;

wire logic ffin ;

wire logic ffout2 ;

wire logic ffout ;



WavD2DAnalogPhy_8lane_gf12lpp_NOR2_D1_GL16_LVT NOR0 ( .tielo(vss), .tiehi(vdd), .vdd(vdd), .y(next),
     .vss(vss), .b(Tb), .a(ffout));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV6 ( .vdd(vdd), .in(loadval), .vss(vss),
     .out(net015));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV8 ( .vdd(vdd), .in(ffout2), .vss(vss), .out(Q));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV2 ( .vdd(vdd), .in(T), .vss(vss), .out(Tb));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV9 ( .vdd(vdd), .in(ffout), .vss(vss), .out(ffout2));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV5 ( .vdd(vdd), .in(rstb), .vss(vss), .out(rst));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV4 ( .vdd(vdd), .in(prstb), .vss(vss), .out(prst));
WavD2DAnalogPhy_8lane_gf12lpp_MUXT2_D2_GL16_LVT MUX0 ( .vdd(vdd), .vss(vss), .sb(Q), .s(ffout2),
     .b(Tb), .a(T), .yb(ffin));
WavD2DAnalogPhy_8lane_gf12lpp_FFSETRES_D1_GL16_LVT FF1 ( .tielo(vss), .tiehi(vdd), .prstb(prstb),
     .prst(prst), .rst(rst), .rstb(rstb), .vss(vss), .vdd(vdd),
     .d(ffin), .clkb(clkb), .clk(clk), .q(ffout));
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUM_D1_GL16_LVT DUM0 ( .tielo(vss), .tiehi(vdd), .vdd(vdd), .vss(vss));*/
WavD2DAnalogPhy_8lane_gf12lpp_NAND2_D1_GL16_LVT NAND7 ( .tielo(vss), .tiehi(vdd), .vdd(vdd),
     .y(rstb), .vss(vss), .b(load), .a(net015));
WavD2DAnalogPhy_8lane_gf12lpp_NAND2_D1_GL16_LVT AND0 ( .tielo(vss), .tiehi(vdd), .vdd(vdd),
     .y(prstb), .vss(vss), .b(load), .a(loadval));

endmodule
// Library - wavshared_gf12lp_dig_lib, Cell - SE2DIHS_D2_GL16_LVT, View
//- schematic
// LAST TIME SAVED: Jan 21 11:34:54 2021
// NETLIST TIME: Oct  7 15:28:47 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_SE2DIHS_D2_GL16_LVT ( 
output wire logic   outn, 
output wire logic   outp, 
inout wire logic   vdd, 
inout wire logic   vss, 
input wire logic   in, 
input wire logic   tiehi, 
input wire logic   tielo );


wire logic p1 ;

wire logic n1 ;

wire logic inb ;



WavD2DAnalogPhy_8lane_gf12lpp_PD_D1_GL16_LVT PD1 ( .vss(vss), .enb(tielo), .y(n1));
WavD2DAnalogPhy_8lane_gf12lpp_PD_D1_GL16_LVT PD0 ( .vss(vss), .enb(tielo), .y(inb));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV4[1:0] ( .out(outn), .vdd(vdd), .vss(vss), .in(p1));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV6 ( .in(inb), .vss(vss), .out(p1), .vdd(vdd));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV8 ( .in(in), .vss(vss), .out(inb), .vdd(vdd));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV7 ( .in(in), .vss(vss), .out(inb), .vdd(vdd));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV5[1:0] ( .out(outp), .vdd(vdd), .vss(vss), .in(n1));
WavD2DAnalogPhy_8lane_gf12lpp_XG_D1_GL16_LVT XGATE0[4:0] ( .y(n1), .vdd(vdd), .vss(vss), .a(inb),
     .en(tiehi), .enb(tielo));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D1_GL16_LVT_Mmod_nomodel INV10 ( .tiehi(tiehi), .tielo(tielo),
     .in(outp), .vss(vss), .out(outn), .vdd(vdd));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D1_GL16_LVT_Mmod_nomodel INV3 ( .tiehi(tiehi), .tielo(tielo),
     .in(n1), .vss(vss), .out(p1), .vdd(vdd));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D1_GL16_LVT_Mmod_nomodel INV2 ( .tiehi(tiehi), .tielo(tielo),
     .in(p1), .vss(vss), .out(n1), .vdd(vdd));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D1_GL16_LVT_Mmod_nomodel INV9 ( .tiehi(tiehi), .tielo(tielo),
     .in(outn), .vss(vss), .out(outp), .vdd(vdd));
WavD2DAnalogPhy_8lane_gf12lpp_PU_D1_GL16_LVT PU1 ( .vdd(vdd), .en(tiehi), .y(n1));
WavD2DAnalogPhy_8lane_gf12lpp_PU_D1_GL16_LVT PU0 ( .vdd(vdd), .en(tiehi), .y(inb));

endmodule
// Library - gf12lp_rpll_lib, Cell - rpll_14g_fbdiv_v2, View -
//schematic
// LAST TIME SAVED: Jul 21 09:20:38 2021
// NETLIST TIME: Oct  7 15:28:47 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_fbdiv_v2 ( 
output wire logic   clkdiv_out, 
inout wire logic   vdda, 
inout wire logic   vss, 
input wire logic   clkin, 
input wire logic  [8:0] div, 
input wire logic   reset );


wire logic load ;

wire logic outn ;

wire logic outp ;

wire logic Q3 ;

wire logic Q8 ;

wire logic Q7 ;

wire logic netb ;

wire logic clkb ;

wire logic Q6 ;

wire logic Q5 ;

wire logic clk ;

wire logic Q2 ;

wire logic Q4 ;

wire logic Q1 ;

wire logic resetb ;

wire logic reset_buf ;

wire logic net0154 ;

wire net0151 ;

wire logic net0152 ;

wire logic net0156 ;

wire logic net0136 ;

wire logic net0148 ;

wire logic net0135 ;

wire net0147 ;

wire logic net043 ;

wire logic net0118 ;

wire logic net0140 ;

wire logic net0142 ;

wire logic net0137 ;

wire logic net0124 ;

wire logic net0150 ;

wire logic net0123 ;

wire logic net0120 ;

wire logic net0149 ;

wire logic net0144 ;

wire logic net0127 ;

wire logic net0117 ;

wire logic net0121 ;

wire logic net0119 ;

wire logic net0130 ;

wire logic net0141 ;

wire logic net0146 ;

wire logic net0122 ;

wire logic net0126 ;

wire logic net0112 ;

wire logic net0138 ;

wire net049 ;

wire logic net0128 ;

wire logic net0139 ;

wire logic net0111 ;

wire net0155 ;

wire logic net0160 ;

wire logic net0159 ;



/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUM_D1_GL16_LVT DUM0[21:0] ( .vdd(vdda), .vss(vss), .tiehi(vdda),
     .tielo(vss));*/
WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_fbdiv_logic_unit DIV_UNIT0 ( .vdd(vdda), .T(vdda), .Q(Q1),
     .next(net0140), .clk(clk), .clkb(clkb), .load(load),
     .loadval(div[1]), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_fbdiv_logic_unit DIV_UNIT3 ( .vdd(vdda), .T(net0155), .Q(Q4),
     .next(net0150), .clk(clk), .clkb(clkb), .load(load),
     .loadval(div[4]), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_fbdiv_logic_unit DIV_UNIT4 ( .vdd(vdda), .T(net0150), .Q(Q5),
     .next(net0142), .clk(clk), .clkb(clkb), .load(load),
     .loadval(div[5]), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_fbdiv_logic_unit DIV_UNIT5 ( .vdd(vdda), .T(net0142), .Q(Q6),
     .next(net0160), .clk(clk), .clkb(clkb), .load(load),
     .loadval(div[6]), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_fbdiv_logic_unit DIV_UNIT1 ( .vdd(vdda), .T(net0140), .Q(Q2),
     .next(net0139), .clk(clk), .clkb(clkb), .load(load),
     .loadval(div[2]), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_fbdiv_logic_unit DIV_UNIT6 ( .vdd(vdda), .T(net0151), .Q(Q7),
     .next(net0141), .clk(clk), .clkb(clkb), .load(load),
     .loadval(div[7]), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_fbdiv_logic_unit DIV_UNIT7 ( .vdd(vdda), .T(net0141), .Q(Q8),
     .next(net0138), .clk(clk), .clkb(clkb), .load(load),
     .loadval(div[8]), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_fbdiv_logic_unit DIV_UNIT2 ( .vdd(vdda), .T(net0139), .Q(Q3),
     .next(net0156), .clk(clk), .clkb(clkb), .load(load),
     .loadval(div[3]), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_NAND3_D1_GL16_LVT NAND3 ( .tielo(vss), .tiehi(vdda), .vdd(vdda),
     .y(net0146), .vss(vss), .c(net0127), .b(resetb), .a(net0128));
WavD2DAnalogPhy_8lane_gf12lpp_SE2DIHS_D2_GL16_LVT SE2DIFF0 ( .tiehi(vdda), .tielo(vss), .vdd(vdda),
     .vss(vss), .outp(outp), .outn(outn), .in(clkin));
WavD2DAnalogPhy_8lane_gf12lpp_FFRES_D1_GL16_LVT FF3 ( .tiehi(vdda), .tielo(vss), .rst(reset_buf),
     .vss(vss), .vdd(vdda), .rstb(resetb), .d(net0154), .clkb(clkb),
     .clk(clk), .q(net0147));
WavD2DAnalogPhy_8lane_gf12lpp_FFRES_D1_GL16_LVT FF0 ( .tiehi(vdda), .tielo(vss), .rst(load),
     .vss(vss), .vdd(vdda), .rstb(net0159), .d(net0160), .clkb(clkb),
     .clk(clk), .q(net0151));
WavD2DAnalogPhy_8lane_gf12lpp_FFRES_D1_GL16_LVT FF2 ( .tiehi(vdda), .tielo(vss), .rst(reset_buf),
     .vss(vss), .vdd(vdda), .rstb(resetb), .d(net0146), .clkb(clkb),
     .clk(clk), .q(net049));
WavD2DAnalogPhy_8lane_gf12lpp_FFRES_D1_GL16_LVT FF1 ( .tiehi(vdda), .tielo(vss), .rst(load),
     .vss(vss), .vdd(vdda), .rstb(net0124), .d(net0156), .clkb(clkb),
     .clk(clk), .q(net0155));
WavD2DAnalogPhy_8lane_gf12lpp_NAND2_D1_GL16_LVT NAND7 ( .tielo(vss), .tiehi(vdda), .vdd(vdda),
     .y(net0122), .vss(vss), .b(net0118), .a(net0119));
WavD2DAnalogPhy_8lane_gf12lpp_NAND2_D1_GL16_LVT NAND1 ( .tielo(vss), .tiehi(vdda), .vdd(vdda),
     .y(net0123), .vss(vss), .b(net0120), .a(net0121));
WavD2DAnalogPhy_8lane_gf12lpp_NAND2_D1_GL16_LVT NAND5 ( .tielo(vss), .tiehi(vdda), .vdd(vdda),
     .y(net0127), .vss(vss), .b(net0112), .a(net043));
WavD2DAnalogPhy_8lane_gf12lpp_NAND2_D1_GL16_LVT NAND0 ( .tielo(vss), .tiehi(vdda), .vdd(vdda),
     .y(net0128), .vss(vss), .b(net0126), .a(net0111));
WavD2DAnalogPhy_8lane_gf12lpp_NAND2_D1_GL16_LVT NAND2 ( .tielo(vss), .tiehi(vdda), .vdd(vdda),
     .y(net0137), .vss(vss), .b(load), .a(net0135));
WavD2DAnalogPhy_8lane_gf12lpp_NAND2_D1_GL16_LVT NAND4 ( .tielo(vss), .tiehi(vdda), .vdd(vdda),
     .y(net0154), .vss(vss), .b(net0136), .a(net0137));
WavD2DAnalogPhy_8lane_gf12lpp_NAND2_D1_GL16_LVT NAND6 ( .tielo(vss), .tiehi(vdda), .vdd(vdda),
     .y(net0136), .vss(vss), .b(netb), .a(clkdiv_out));
WavD2DAnalogPhy_8lane_gf12lpp_NAND2_D1_GL16_LVT NAND8 ( .tielo(vss), .tiehi(vdda), .vdd(vdda),
     .y(net0144), .vss(vss), .b(net0130), .a(clkdiv_out));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF6 ( .tiehi(vdda), .tielo(vss), .vss(vss), .vdd(vdda),
     .d(div[0]), .clkb(net0148), .clk(clkdiv_out), .q(net0130));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF5 ( .tiehi(vdda), .tielo(vss), .vss(vss), .vdd(vdda),
     .d(net0111), .clkb(clkb), .clk(clk), .q(net043));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF4 ( .tiehi(vdda), .tielo(vss), .vss(vss), .vdd(vdda),
     .d(net0152), .clkb(clkb), .clk(clk), .q(net0111));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV32 ( .in(load), .vss(vss), .out(net0159),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV0 ( .in(load), .vss(vss), .out(net0124),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV10 ( .in(Q1), .vss(vss), .out(net0117), .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV8 ( .in(Q2), .vss(vss), .out(net0149), .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV12[6:0] ( .out(clk), .vdd(vdda), .vss(vss),
     .in(outn));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV2 ( .in(reset), .vss(vss), .out(resetb),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV15 ( .in(clkdiv_out), .vss(vss), .out(net0148),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV14 ( .in(net0144), .vss(vss), .out(net0112),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV6 ( .in(net0147), .vss(vss), .out(net0135),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV5[4:0] ( .out(load), .vdd(vdda), .vss(vss),
     .in(netb));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV7[3:0] ( .out(clkdiv_out), .vdd(vdda), .vss(vss),
     .in(net0135));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV9 ( .in(net0112), .vss(vss), .out(net0126),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV4[1:0] ( .out(netb), .vdd(vdda), .vss(vss),
     .in(net049));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV3 ( .in(resetb), .vss(vss), .out(reset_buf),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV33[6:0] ( .out(clkb), .vdd(vdda), .vss(vss),
     .in(outp));
WavD2DAnalogPhy_8lane_gf12lpp_NOR2_D1_GL16_LVT NOR10 ( .tielo(vss), .tiehi(vdda), .y(net0152),
     .vss(vss), .vdd(vdda), .b(net0122), .a(net0123));
WavD2DAnalogPhy_8lane_gf12lpp_NOR2_D1_GL16_LVT NOR3 ( .tielo(vss), .tiehi(vdda), .y(net0119),
     .vss(vss), .vdd(vdda), .b(Q3), .a(Q4));
WavD2DAnalogPhy_8lane_gf12lpp_NOR2_D1_GL16_LVT NOR4 ( .tielo(vss), .tiehi(vdda), .y(net0118),
     .vss(vss), .vdd(vdda), .b(net0117), .a(net0149));
WavD2DAnalogPhy_8lane_gf12lpp_NOR2_D1_GL16_LVT NOR0 ( .tielo(vss), .tiehi(vdda), .y(net0121),
     .vss(vss), .vdd(vdda), .b(Q7), .a(Q8));
WavD2DAnalogPhy_8lane_gf12lpp_NOR2_D1_GL16_LVT NOR1 ( .tielo(vss), .tiehi(vdda), .y(net0120),
     .vss(vss), .vdd(vdda), .b(Q5), .a(Q6));

endmodule
// Library - wavshared_gf12lp_dig_lib, Cell - SE2DIHSE_D2_GL16_LVT,
//View - schematic
// LAST TIME SAVED: Aug 17 07:50:34 2021
// NETLIST TIME: Oct  7 15:28:47 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_SE2DIHSE_D2_GL16_LVT ( 
output wire logic   outn, 
output wire logic   outp, 
inout wire logic   vdd, 
inout wire logic   vss, 
input wire logic   ena, 
input wire logic   in, 
input wire logic   tiehi, 
input wire logic   tielo );


wire logic p1 ;

wire logic n1 ;

wire logic inb ;



WavD2DAnalogPhy_8lane_gf12lpp_PU_D1_GL16_LVT PU0 ( .vdd(vdd), .en(tiehi), .y(inb));
WavD2DAnalogPhy_8lane_gf12lpp_PU_D1_GL16_LVT PU1 ( .vdd(vdd), .en(tiehi), .y(n1));
WavD2DAnalogPhy_8lane_gf12lpp_PD_D1_GL16_LVT PD0 ( .vss(vss), .enb(tielo), .y(inb));
WavD2DAnalogPhy_8lane_gf12lpp_PD_D1_GL16_LVT PD1 ( .vss(vss), .enb(tielo), .y(n1));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D1_GL16_LVT_Mmod_nomodel INV3 ( .tiehi(tiehi), .tielo(tielo),
     .in(n1), .vss(vss), .out(p1), .vdd(vdd));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D1_GL16_LVT_Mmod_nomodel INV2 ( .tiehi(tiehi), .tielo(tielo),
     .in(p1), .vss(vss), .out(n1), .vdd(vdd));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV6 ( .in(inb), .vss(vss), .out(p1), .vdd(vdd));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV8 ( .in(in), .vss(vss), .out(inb), .vdd(vdd));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV7 ( .in(in), .vss(vss), .out(inb), .vdd(vdd));
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUM_D1_GL16_LVT DUM0[0:5] ( .vdd(vdd), .vss(vss), .tiehi(tiehi),
     .tielo(tielo));*/
WavD2DAnalogPhy_8lane_gf12lpp_NAND2_D1_GL16_LVT NAND0 ( .tielo(tielo), .vdd(vdd), .y(outp),
     .vss(vss), .tiehi(tiehi), .b(ena), .a(n1));
WavD2DAnalogPhy_8lane_gf12lpp_NAND2_D1_GL16_LVT NAND1 ( .tielo(tielo), .vdd(vdd), .y(outn),
     .vss(vss), .tiehi(tiehi), .b(ena), .a(p1));
WavD2DAnalogPhy_8lane_gf12lpp_XG_D1_GL16_LVT XGATE0[4:0] ( .y(n1), .vdd(vdd), .vss(vss), .a(inb),
     .en(tiehi), .enb(tielo));

endmodule
// Library - gf12lp_rpll_lib, Cell - rpll_14g_div2_iq_lvt, View -
//schematic
// LAST TIME SAVED: Aug 17 07:53:21 2021
// NETLIST TIME: Oct  7 15:28:47 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_div2_iq_lvt ( 
output wire logic   iclk, 
output wire logic   qclk, 
inout wire logic   vdda, 
inout wire logic   vss, 
input wire logic   clkinn, 
input wire logic   clkinp, 
input wire logic   en );


wire logic clkintn ;

wire logic clkintp ;

wire logic enb ;

wire logic net08 ;

wire logic net011 ;

wire logic net07 ;

wire logic net09 ;

wire logic net015 ;



WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV1 ( .vdd(vdda), .in(net07), .vss(vss), .out(net08));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV0 ( .vdd(vdda), .in(net015), .vss(vss),
     .out(net09));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV2[1:0] ( .out(qclk), .vdd(vdda), .vss(vss),
     .in(net09));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV6 ( .vdd(vdda), .in(en), .vss(vss), .out(enb));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV4[1:0] ( .out(iclk), .vdd(vdda), .vss(vss),
     .in(net08));
WavD2DAnalogPhy_8lane_gf12lpp_NAND2_D1_GL16_LVT NAND1 ( .tielo(vss), .tiehi(vdda), .vdd(vdda),
     .y(net011), .vss(vss), .b(en), .a(net015));
WavD2DAnalogPhy_8lane_gf12lpp_PD_D2_GL16_LVT PD0 ( .vss(vss), .enb(enb), .y(clkintn));
WavD2DAnalogPhy_8lane_gf12lpp_PU_D2_GL16_LVT PU0 ( .vdd(vdda), .en(en), .y(clkintp));
WavD2DAnalogPhy_8lane_gf12lpp_INVT_D2_GL16_LVT INV5 ( .vdd(vdda), .out(clkintn), .en(en), .enb(enb),
     .vss(vss), .in(clkinp));
WavD2DAnalogPhy_8lane_gf12lpp_INVT_D2_GL16_LVT INV3 ( .vdd(vdda), .out(clkintp), .en(en), .enb(enb),
     .vss(vss), .in(clkinn));
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUM_D1_GL16_LVT DUM0[2:0] ( .vdd(vdda), .vss(vss), .tiehi(vdda),
     .tielo(vss));*/
/*REMOVED VIA SCRIPT -- pcapacitor  C0 ( .PLUS(net07), .MINUS(vss));*/
WavD2DAnalogPhy_8lane_gf12lpp_LAT_D1_GL16_LVT LA0 ( .tielo(vss), .tiehi(vdda), .vdd(vdda), .vss(vss),
     .d(net07), .clkb(clkintp), .clk(clkintn), .q(net015));
WavD2DAnalogPhy_8lane_gf12lpp_LAT_D1_GL16_LVT LA1 ( .tielo(vss), .tiehi(vdda), .vdd(vdda), .vss(vss),
     .d(net011), .clkb(clkintn), .clk(clkintp), .q(net07));

endmodule
// Library - gf12lp_rpll_lib, Cell - rpll_14g_div2_iq_v2_LVT, View -
//schematic
// LAST TIME SAVED: Aug 17 05:43:03 2021
// NETLIST TIME: Oct  7 15:28:47 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_div2_iq_v2_LVT ( 
output wire logic   iclk, 
output wire logic   qclk, 
inout wire logic   vdda, 
inout wire logic   vss, 
input wire logic   clkinn, 
input wire logic   clkinp, 
input wire logic   en );


wire logic clkintp ;

wire logic net09 ;

wire logic enb ;

wire logic net07 ;

wire logic clkintn ;

wire logic net015 ;

wire logic net011 ;

wire logic net08 ;



/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUM_D1_GL16_LVT DUM0[3:0] ( .vdd(vdda), .vss(vss), .tiehi(vdda),
     .tielo(vss));*/
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV1 ( .vdd(vdda), .in(net07), .vss(vss), .out(net08));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV0 ( .vdd(vdda), .in(net015), .vss(vss),
     .out(net09));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV2[1:0] ( .out(qclk), .vdd(vdda), .vss(vss),
     .in(net09));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV7 ( .in(net015), .vss(vss), .out(net011),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV6 ( .vdd(vdda), .in(en), .vss(vss), .out(enb));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV4[1:0] ( .out(iclk), .vdd(vdda), .vss(vss),
     .in(net08));
WavD2DAnalogPhy_8lane_gf12lpp_INVT_D2_GL16_LVT INV5 ( .vdd(vdda), .out(clkintn), .en(en), .enb(enb),
     .vss(vss), .in(clkinp));
WavD2DAnalogPhy_8lane_gf12lpp_INVT_D2_GL16_LVT INV3 ( .vdd(vdda), .out(clkintp), .en(en), .enb(enb),
     .vss(vss), .in(clkinn));
WavD2DAnalogPhy_8lane_gf12lpp_PU_D2_GL16_LVT PU0 ( .vdd(vdda), .en(en), .y(clkintp));
WavD2DAnalogPhy_8lane_gf12lpp_PD_D2_GL16_LVT PD0 ( .vss(vss), .enb(enb), .y(clkintn));
/*REMOVED VIA SCRIPT -- pcapacitor  C0 ( .PLUS(net07), .MINUS(vss));*/
WavD2DAnalogPhy_8lane_gf12lpp_LAT_D1_GL16_LVT LA0 ( .tielo(vss), .tiehi(vdda), .vdd(vdda), .vss(vss),
     .d(net07), .clkb(clkintp), .clk(clkintn), .q(net015));
WavD2DAnalogPhy_8lane_gf12lpp_LAT_D1_GL16_LVT LA1 ( .tielo(vss), .tiehi(vdda), .vdd(vdda), .vss(vss),
     .d(net011), .clkb(clkintn), .clk(clkintp), .q(net07));

endmodule
// Library - gf12lp_rpll_lib, Cell - rpll_14g_postdiv_v2, View -
//schematic
// LAST TIME SAVED: Aug 17 05:43:37 2021
// NETLIST TIME: Oct  7 15:28:47 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_postdiv_v2 ( 
output wire logic   div2clk, 
output wire logic   div16clk, 
output wire logic   div64clk, 
output wire logic   outclk0, 
output wire logic   outclk90, 
output wire logic   outclk180, 
output wire logic   outclk270, 
inout wire logic   vdda, 
inout wire logic   vss, 
input wire logic   byp_clk, 
input wire logic   byp_clk_sel, 
input wire logic  [1:0] post_div, 
input wire logic   vcoclk0, 
input wire logic   vcoclk90, 
input wire logic   vcoclk180, 
input wire logic   vcoclk270 );


wire logic net6 ;

wire logic iclk4 ;

wire logic qclk2 ;

wire logic qclk2b ;

wire logic clk180b ;

wire logic clk0b ;

wire logic byp_clk_sela ;

wire logic byp_clk_selb ;

wire logic byp_clk_q ;

wire logic byp_clk_i ;

wire logic b111 ;

wire logic byp_clkb ;

wire logic mx90 ;

wire logic mx270 ;

wire logic mx180 ;

wire logic mx0 ;

wire logic div1_sel ;

wire logic post_div_sel ;

wire logic qdiv2_4_8 ;

wire logic idiv2_4_8 ;

wire logic qdiv4_8 ;

wire logic div4_8_sel ;

wire logic idiv4_8 ;

wire logic div64clkb ;

wire logic div32clk ;

wire logic div64clkb_int ;

wire logic div32clkb ;

wire logic div64clk_int ;

wire logic div16clk_int ;

wire logic div16clkb ;

wire logic div8clk ;

wire logic div8clkb ;

wire logic div4clk ;

wire logic div4clkb ;

wire logic div2clkb ;

wire logic div8_sel ;

wire logic div4_sel ;

wire logic div2_sel ;

wire logic qbclkdivint ;

wire logic qclkdivint ;

wire logic ibclkdivint ;

wire logic iclkdivint ;

wire logic iclk2b ;

wire logic qclk8 ;

wire logic a111 ;

wire logic qclk4 ;

wire logic iclk2 ;

wire logic iclk8 ;

wire logic net031 ;

// Buses in the design

wire logic [1:0]  post_divb;



WavD2DAnalogPhy_8lane_gf12lpp_SE2DIHSE_D2_GL16_LVT SE2DIFF1 ( .ena(post_div_sel), .tiehi(vdda),
     .tielo(vss), .vdd(vdda), .vss(vss), .outp(qbclkdivint),
     .outn(qclkdivint), .in(a111));
WavD2DAnalogPhy_8lane_gf12lpp_SE2DIHSE_D2_GL16_LVT SE2DIFF0 ( .ena(post_div_sel), .tiehi(vdda),
     .tielo(vss), .vdd(vdda), .vss(vss), .outp(ibclkdivint),
     .outn(iclkdivint), .in(b111));
WavD2DAnalogPhy_8lane_gf12lpp_NOR2_D1_GL16_LVT NOR3 ( .tielo(vss), .tiehi(vdda), .vdd(vdda),
     .y(div8_sel), .vss(vss), .b(post_divb[1]), .a(post_divb[0]));
WavD2DAnalogPhy_8lane_gf12lpp_NOR2_D1_GL16_LVT NOR1 ( .tielo(vss), .tiehi(vdda), .vdd(vdda),
     .y(div2_sel), .vss(vss), .b(post_div[1]), .a(post_divb[0]));
WavD2DAnalogPhy_8lane_gf12lpp_NOR2_D1_GL16_LVT NOR0 ( .tielo(vss), .tiehi(vdda), .vdd(vdda),
     .y(div1_sel), .vss(vss), .b(post_div[1]), .a(post_div[0]));
WavD2DAnalogPhy_8lane_gf12lpp_NOR2_D1_GL16_LVT NOR2 ( .tielo(vss), .tiehi(vdda), .vdd(vdda),
     .y(div4_sel), .vss(vss), .b(post_divb[1]), .a(post_div[0]));
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUMLOAD_D2_GL16_LVT I6 ( .vdd(vdda), .inn(vcoclk90), .vss(vss),
     .inp(vcoclk90));*/
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUMLOAD_D2_GL16_LVT I5 ( .vdd(vdda), .inn(vcoclk270), .vss(vss),
     .inp(vcoclk270));*/
WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_div2_iq_lvt DIV2IQ3 ( .vdda(vdda), .iclk(byp_clk_i),
     .qclk(byp_clk_q), .clkinp(byp_clk), .clkinn(byp_clkb),
     .en(byp_clk_sela), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_div2_iq_lvt DIV2IQ2 ( .vdda(vdda), .iclk(iclk8), .qclk(qclk8),
     .clkinp(iclk4), .clkinn(net6), .en(div4_8_sel), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_div2_iq_lvt DIV2IQ1 ( .vdda(vdda), .clkinp(iclk2),
     .iclk(iclk4), .qclk(qclk4), .clkinn(iclk2b), .en(div4_8_sel),
     .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV2 ( .in(div4clk), .vss(vss), .out(div4clkb),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV32 ( .in(vcoclk180), .vss(vss), .out(clk180b),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV28 ( .in(byp_clk), .vss(vss), .out(byp_clkb),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV31 ( .in(vcoclk0), .vss(vss), .out(clk0b),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV30 ( .in(byp_clk_selb), .vss(vss),
     .out(byp_clk_sela), .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV27 ( .in(div64clk_int), .vss(vss),
     .out(div64clkb_int), .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV26 ( .in(div32clk), .vss(vss), .out(div32clkb),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV25 ( .in(div16clk_int), .vss(vss), .out(div16clkb),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV24 ( .in(div8clk), .vss(vss), .out(div8clkb),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV22[1:0] ( .out(div16clk), .vdd(vdda), .vss(vss),
     .in(net031));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV21 ( .vdd(vdda), .in(div16clkb), .vss(vss),
     .out(net031));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV17[2:0] ( .out(outclk0), .vdd(vdda), .vss(vss),
     .in(mx0));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV20[2:0] ( .out(outclk270), .vdd(vdda), .vss(vss),
     .in(mx270));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV19[2:0] ( .out(outclk180), .vdd(vdda), .vss(vss),
     .in(mx180));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV18[2:0] ( .out(outclk90), .vdd(vdda), .vss(vss),
     .in(mx90));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV15[1:0] ( .out(div64clk), .vdd(vdda), .vss(vss),
     .in(div64clkb));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV14 ( .vdd(vdda), .in(div64clk_int), .vss(vss),
     .out(div64clkb));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV11[1:0] ( .out(div2clk), .vdd(vdda), .vss(vss),
     .in(div2clkb));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV7[1:0] ( .out(post_divb[1:0]), .vdd(vdda),
     .vss(vss), .in(post_div[1:0]));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV9 ( .vdd(vdda), .in(div1_sel), .vss(vss),
     .out(post_div_sel));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV29 ( .in(byp_clk_sel), .vss(vss),
     .out(byp_clk_selb), .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV8 ( .vdd(vdda), .in(post_divb[1]), .vss(vss),
     .out(div4_8_sel));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV4 ( .vdd(vdda), .in(qclk2), .vss(vss),
     .out(qclk2b));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV1 ( .vdd(vdda), .in(iclk4), .vss(vss), .out(net6));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV0 ( .vdd(vdda), .in(iclk2), .vss(vss),
     .out(iclk2b));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV10 ( .vdd(vdda), .in(iclk2), .vss(vss),
     .out(div2clkb));
WavD2DAnalogPhy_8lane_gf12lpp_MUXT2_D2_GL16_LVT MUX11 ( .vss(vss), .sb(byp_clk_selb),
     .s(byp_clk_sela), .b(byp_clk_i), .a(idiv2_4_8), .yb(b111),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_MUXT2_D2_GL16_LVT MUX10 ( .vss(vss), .sb(byp_clk_selb),
     .s(byp_clk_sela), .b(byp_clk_q), .a(qdiv2_4_8), .yb(a111),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_MUXT2_D2_GL16_LVT MUX7[1:0] ( .yb(mx270), .vdd(vdda), .vss(vss),
     .a(qbclkdivint), .b(vcoclk270), .s(div1_sel), .sb(post_div_sel));
WavD2DAnalogPhy_8lane_gf12lpp_MUXT2_D2_GL16_LVT MUX6[1:0] ( .yb(mx90), .vdd(vdda), .vss(vss),
     .a(qclkdivint), .b(vcoclk90), .s(div1_sel), .sb(post_div_sel));
WavD2DAnalogPhy_8lane_gf12lpp_MUXT2_D2_GL16_LVT MUX5[1:0] ( .yb(mx180), .vdd(vdda), .vss(vss),
     .a(ibclkdivint), .b(vcoclk180), .s(div1_sel), .sb(post_div_sel));
WavD2DAnalogPhy_8lane_gf12lpp_MUXT2_D2_GL16_LVT MUX4[1:0] ( .yb(mx0), .vdd(vdda), .vss(vss),
     .a(iclkdivint), .b(vcoclk0), .s(div1_sel), .sb(post_div_sel));
WavD2DAnalogPhy_8lane_gf12lpp_MUXT2_D2_GL16_LVT MUX3 ( .vdd(vdda), .vss(vss), .sb(div2_sel),
     .s(div4_8_sel), .b(qdiv4_8), .a(qclk2b), .yb(qdiv2_4_8));
WavD2DAnalogPhy_8lane_gf12lpp_MUXT2_D2_GL16_LVT MUX2 ( .vdd(vdda), .vss(vss), .sb(div4_sel),
     .s(div8_sel), .b(qclk8), .a(qclk4), .yb(qdiv4_8));
WavD2DAnalogPhy_8lane_gf12lpp_MUXT2_D2_GL16_LVT MUX1 ( .vdd(vdda), .vss(vss), .sb(div2_sel),
     .s(div4_8_sel), .b(idiv4_8), .a(iclk2b), .yb(idiv2_4_8));
WavD2DAnalogPhy_8lane_gf12lpp_MUXT2_D2_GL16_LVT MUX0 ( .vdd(vdda), .vss(vss), .sb(div4_sel),
     .s(div8_sel), .b(iclk8), .a(iclk4), .yb(idiv4_8));
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUM_D1_GL16_LVT DUM0[308:0] ( .vdd(vdda), .vss(vss), .tiehi(vdda),
     .tielo(vss));*/
WavD2DAnalogPhy_8lane_gf12lpp_PU_D2_GL16_LVT PU0 ( .vdd(vdda), .en(div4_8_sel), .y(idiv4_8));
WavD2DAnalogPhy_8lane_gf12lpp_PU_D2_GL16_LVT PU5 ( .vdd(vdda), .en(post_div_sel), .y(qdiv2_4_8));
WavD2DAnalogPhy_8lane_gf12lpp_PU_D2_GL16_LVT PU6 ( .vdd(vdda), .en(post_div_sel), .y(idiv2_4_8));
WavD2DAnalogPhy_8lane_gf12lpp_PU_D2_GL16_LVT PU4 ( .vdd(vdda), .en(div4_8_sel), .y(qdiv4_8));
WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_div2_iq_v2_LVT DIV2IQ0 ( .vdda(vdda), .clkinp(clk0b),
     .iclk(iclk2), .qclk(qclk2), .clkinn(clk180b), .en(vdda),
     .vss(vss));
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_PDDUM_D2_GL16_LVT PDDUM[0:3] ( .vss(vss), .tielo(vss));*/
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF8 ( .tielo(vss), .tiehi(vdda), .vdd(vdda), .vss(vss),
     .d(div64clkb_int), .clkb(div32clkb), .clk(div32clk),
     .q(div64clk_int));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF7 ( .tielo(vss), .tiehi(vdda), .vdd(vdda), .vss(vss),
     .d(div32clkb), .clkb(div16clkb), .clk(div16clk_int),
     .q(div32clk));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF5 ( .tielo(vss), .tiehi(vdda), .vdd(vdda), .vss(vss),
     .d(div8clkb), .clkb(div4clkb), .clk(div4clk), .q(div8clk));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF1 ( .tielo(vss), .tiehi(vdda), .vss(vss), .vdd(vdda),
     .d(div16clkb), .clkb(div8clkb), .clk(div8clk), .q(div16clk_int));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF0 ( .tielo(vss), .tiehi(vdda), .vdd(vdda), .vss(vss),
     .d(div4clkb), .clkb(div2clkb), .clk(div2clk), .q(div4clk));

endmodule
// Library - wavshared_gf12lp_dig_lib, Cell - TST_DECOD_3TO8_LVT, View
//- schematic
// LAST TIME SAVED: Nov 10 12:05:08 2020
// NETLIST TIME: Oct  7 15:28:47 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_TST_DECOD_3TO8_LVT ( 
output wire logic  [7:0] dec_out, 
inout wire logic   vdd, 
inout wire logic   vss, 
input wire logic  [2:0] sel, 
input wire logic   tiehi, 
input wire logic   tielo );


wire logic net8 ;

wire logic net6 ;

wire logic net10 ;

wire logic net12 ;

wire logic net7 ;

wire logic net13 ;

wire logic net9 ;

wire logic net11 ;

// Buses in the design

wire logic [2:0]  selb;



WavD2DAnalogPhy_8lane_gf12lpp_NAND3_D1_GL16_LVT NAND7 ( .tielo(tielo), .tiehi(tiehi), .vdd(vdd),
     .y(net6), .vss(vss), .c(sel[2]), .b(sel[1]), .a(sel[0]));
WavD2DAnalogPhy_8lane_gf12lpp_NAND3_D1_GL16_LVT NAND6 ( .tielo(tielo), .tiehi(tiehi), .vdd(vdd),
     .y(net7), .vss(vss), .c(sel[2]), .b(sel[1]), .a(selb[0]));
WavD2DAnalogPhy_8lane_gf12lpp_NAND3_D1_GL16_LVT NAND5 ( .tielo(tielo), .tiehi(tiehi), .vdd(vdd),
     .y(net8), .vss(vss), .c(sel[2]), .b(selb[1]), .a(sel[0]));
WavD2DAnalogPhy_8lane_gf12lpp_NAND3_D1_GL16_LVT NAND4 ( .tielo(tielo), .tiehi(tiehi), .vdd(vdd),
     .y(net9), .vss(vss), .c(sel[2]), .b(selb[1]), .a(selb[0]));
WavD2DAnalogPhy_8lane_gf12lpp_NAND3_D1_GL16_LVT NAND3 ( .tielo(tielo), .tiehi(tiehi), .vdd(vdd),
     .y(net10), .vss(vss), .c(selb[2]), .b(sel[1]), .a(sel[0]));
WavD2DAnalogPhy_8lane_gf12lpp_NAND3_D1_GL16_LVT NAND2 ( .tielo(tielo), .tiehi(tiehi), .vdd(vdd),
     .y(net11), .vss(vss), .c(selb[2]), .b(sel[1]), .a(selb[0]));
WavD2DAnalogPhy_8lane_gf12lpp_NAND3_D1_GL16_LVT NAND1 ( .tielo(tielo), .tiehi(tiehi), .vdd(vdd),
     .y(net12), .vss(vss), .c(selb[2]), .b(selb[1]), .a(sel[0]));
WavD2DAnalogPhy_8lane_gf12lpp_NAND3_D1_GL16_LVT NAND0 ( .tielo(tielo), .tiehi(tiehi), .vdd(vdd),
     .y(net13), .vss(vss), .c(selb[2]), .b(selb[1]), .a(selb[0]));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV1[2:0] ( .out(selb[2:0]), .vdd(vdd), .vss(vss),
     .in(sel[2:0]));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D1_GL16_LVT INV8 ( .tielo(tielo), .tiehi(tiehi), .in(net6),
     .vss(vss), .out(dec_out[7]), .vdd(vdd));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D1_GL16_LVT INV7 ( .tielo(tielo), .tiehi(tiehi), .in(net7),
     .vss(vss), .out(dec_out[6]), .vdd(vdd));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D1_GL16_LVT INV6 ( .tielo(tielo), .tiehi(tiehi), .in(net8),
     .vss(vss), .out(dec_out[5]), .vdd(vdd));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D1_GL16_LVT INV5 ( .tielo(tielo), .tiehi(tiehi), .in(net9),
     .vss(vss), .out(dec_out[4]), .vdd(vdd));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D1_GL16_LVT INV4 ( .tielo(tielo), .tiehi(tiehi), .in(net10),
     .vss(vss), .out(dec_out[3]), .vdd(vdd));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D1_GL16_LVT INV3 ( .tielo(tielo), .tiehi(tiehi), .in(net11),
     .vss(vss), .out(dec_out[2]), .vdd(vdd));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D1_GL16_LVT INV2 ( .tielo(tielo), .tiehi(tiehi), .in(net12),
     .vss(vss), .out(dec_out[1]), .vdd(vdd));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D1_GL16_LVT INV0 ( .tielo(tielo), .tiehi(tiehi), .in(net13),
     .vss(vss), .out(dec_out[0]), .vdd(vdd));

endmodule
// Library - wavshared_gf12lp_dig_lib, Cell - TST_MUX_LVT, View -
//schematic
// LAST TIME SAVED: Feb 11 07:29:32 2021
// NETLIST TIME: Oct  7 15:28:47 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_TST_MUX_LVT ( 
output wire logic   tst_out, 
output wire logic   tst_outb, 
inout wire logic   vdd, 
inout wire logic   vss, 
input wire logic  [7:0] in, 
input wire logic  [2:0] sel, 
input wire logic   tiehi, 
input wire logic   tielo );


wire logic b ;

wire logic a ;

// Buses in the design

wire logic [7:0]  dec_selb;

wire logic [7:0]  dec_sel;



WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV2[1:0] ( .out(tst_outb), .vdd(vdd), .vss(vss),
     .in(b));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV0[7:0] ( .out(dec_selb[7:0]), .vdd(vdd), .vss(vss),
     .in(dec_sel[7:0]));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV3[3:0] ( .out(tst_out), .vdd(vdd), .vss(vss),
     .in(tst_outb));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV1 ( .in(a), .vss(vss), .out(b), .vdd(vdd));
WavD2DAnalogPhy_8lane_gf12lpp_TST_DECOD_3TO8_LVT I1 ( .tielo(tielo), .vdd(vdd),
     .dec_out(dec_sel[7:0]), .sel(sel[2:0]), .tiehi(tiehi), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_INVT_D2_GL16_LVT I2[7:0] ( .out(a), .vdd(vdd), .vss(vss),
     .en(dec_sel[7:0]), .enb(dec_selb[7:0]), .in(in[7:0]));

endmodule
// Library - gf12lp_rpll_lib, Cell - rpll_pfd, View - schematic
// LAST TIME SAVED: Mar 24 08:39:00 2021
// NETLIST TIME: Oct  7 15:28:47 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_rpll_pfd ( 
output wire logic   dn, 
output wire logic   dnb, 
output wire logic   up, 
output wire logic   upb, 
inout wire logic   vdda, 
inout wire logic   vss, 
input wire logic   fbclk, 
input wire logic  [1:0] mode, 
input wire logic   refclk, 
input wire logic   reset );


wire logic rst ;

wire net012 ;

wire logic rsta ;

wire net7 ;

wire logic s0b ;

wire logic s1b ;

wire logic s0 ;

wire logic s1 ;

wire logic fbclk_buf ;

wire logic fbclk_b ;

wire logic refclk_buf ;

wire logic refclk_b ;

wire logic net013 ;

wire logic net014 ;

wire logic rstb ;

// Buses in the design

wire logic [0:16]  rstdly;



WavD2DAnalogPhy_8lane_gf12lpp_NAND2_D1_GL16_LVT NAND0 ( .tielo(vss), .tiehi(vdda), .vdd(vdda),
     .y(rsta), .vss(vss), .b(up), .a(dn));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV5 ( .vdd(vdda), .in(rstb), .vss(vss), .out(rst));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV4 ( .vdd(vdda), .in(net013), .vss(vss),
     .out(fbclk_buf));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV3 ( .vdd(vdda), .in(fbclk_buf), .vss(vss),
     .out(fbclk_b));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV2 ( .vdd(vdda), .in(refclk_buf), .vss(vss),
     .out(refclk_b));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV1 ( .vdd(vdda), .in(net014), .vss(vss),
     .out(refclk_buf));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV8[1:0] ( .out({s0, s1}), .vdd(vdda), .vss(vss),
     .in({s0b, s1b}));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV7[1:0] ( .out({s0b, s1b}), .vdd(vdda), .vss(vss),
     .in(mode[1:0]));
WavD2DAnalogPhy_8lane_gf12lpp_SE2DIHS_D2_GL16_LVT SE2DIFF0 ( .tiehi(vdda), .tielo(vss), .vdd(vdda),
     .vss(vss), .outp(dn), .outn(dnb), .in(net7));
WavD2DAnalogPhy_8lane_gf12lpp_SE2DIHS_D2_GL16_LVT SE2DIFF1 ( .tiehi(vdda), .tielo(vss), .vdd(vdda),
     .vss(vss), .outp(up), .outn(upb), .in(net012));
WavD2DAnalogPhy_8lane_gf12lpp_FFRES_D1_GL16_LVT IFF0 ( .tiehi(vdda), .tielo(vss), .rst(rst),
     .rstb(rstb), .vdd(vdda), .d(vdda), .q(net7), .clk(fbclk_buf),
     .clkb(fbclk_b), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_FFRES_D1_GL16_LVT FF0 ( .tiehi(vdda), .tielo(vss), .rst(rst),
     .vss(vss), .vdd(vdda), .rstb(rstb), .d(vdda), .clkb(refclk_b),
     .clk(refclk_buf), .q(net012));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D1_GL16_LVT_Mmod_delay INV0[0:16] ( .out(rstdly[0:16]), .vdd(vdda),
     .vss(vss), .in({rsta, rstdly[0], rstdly[1], rstdly[2], rstdly[3],
     rstdly[4], rstdly[5], rstdly[6], rstdly[7], rstdly[8], rstdly[9],
     rstdly[10], rstdly[11], rstdly[12], rstdly[13], rstdly[14],
     rstdly[15]}), .tiehi(vdda), .tielo(vss));
WavD2DAnalogPhy_8lane_gf12lpp_NOR2_D1_GL16_LVT NOR1 ( .tielo(vss), .tiehi(vdda), .vdd(vdda),
     .y(rstb), .vss(vss), .b(reset), .a(rstdly[16]));
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUM_D1_GL16_LVT DUM0[0:25] ( .vdd(vdda), .vss(vss), .tiehi(vdda),
     .tielo(vss));*/
WavD2DAnalogPhy_8lane_gf12lpp_MUXT2_D2_GL16_LVT MUX0 ( .vdd(vdda), .vss(vss), .sb(s0b), .s(s0),
     .b(refclk), .a(fbclk), .yb(net013));
WavD2DAnalogPhy_8lane_gf12lpp_MUXT2_D2_GL16_LVT MUX1 ( .vdd(vdda), .vss(vss), .sb(s1b), .s(s1),
     .b(fbclk), .a(refclk), .yb(net014));

endmodule
// Library - gf12lp_rpll_lib, Cell - rpll_14g_filter_v2, View -
//schematic
// LAST TIME SAVED: Oct  4 12:21:18 2021
// NETLIST TIME: Oct  7 15:28:47 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_filter_v2 ( 
output var real  vcap , 
output var real  vring , 
inout wire logic   vdbl, 
inout wire logic   vdda, 
inout wire logic   vss, 
input wire logic  [1:0] c_ctrl, 
input wire logic   cap_rstb, 
input wire logic   en, 
input var real  idn_int , 
input var real  idn_prop , 
input var real  idnb_int , 
input var real  idnb_prop , 
input var real  iup_int , 
input var real  iup_prop , 
input var real  iupb_int , 
input var real  iupb_prop , 
input wire logic  [4:0] prop_ctrl, 
input wire logic  [1:0] r_ctrl );


var real iout_prop ;

wire logic ena ;

wire logic enb ;

var real iout_up ;

var real iout_dn ;



WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_ipsum_v2 ISUM ( .vring(vring), .vint(vcap), .iprop(iout_prop),
     .vdda(vdda), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_rpll_filter_cap_20pF_v2 ICAP ( .vcap(vcap), .ena(cap_rstb),
     .idn(iout_dn), .iup(iout_up), .vss(vss), .vdda(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_filter_int_v2 IFIL_INT ( .enb(enb), .ena(ena),
     .iout_dn(iout_dn), .iout_up(iout_up), .idn_int(idn_int),
     .idnb_int(idnb_int), .iup_int(iup_int), .iupb_int(iupb_int),
     .vdbl(vdbl), .vss(vss), .vdda(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_chp_prop_dac_v2 IFIL_PROP ( .ena(ena), .ctrl(prop_ctrl[4:0]),
     .c_ctrl(c_ctrl[1:0]), .r_ctrl(r_ctrl[1:0]), .idn_prop(idn_prop),
     .idnb_prop(idnb_prop), .iup_prop(iup_prop), .iupb_prop(iupb_prop),
     .vdda(vdda), .iout_prop(iout_prop), .vss(vss));
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUM_D1_GL16_RVT DUM0[3:0] ( .vdd(vdda), .vss(vss), .tiehi(vdda),
     .tielo(vss));*/
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_RVT INV3 ( .vdd(vdda), .in(enb), .vss(vss), .out(ena));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_RVT INV2 ( .vdd(vdda), .in(en), .vss(vss), .out(enb));

endmodule
// Library - gf12lp_rpll_lib, Cell - rpll_14g_ana_v2, View - schematic
// LAST TIME SAVED: Sep 14 08:52:00 2021
// NETLIST TIME: Oct  7 15:28:47 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_ana_v2 ( 
output wire logic   clk0, 
output wire logic   clk90, 
output wire logic   clk180, 
output wire logic   clk270, 
output wire logic   clk_div16, 
output wire logic   dtest_out, 
output wire logic   fbclk, 
output wire logic   refclk_out, 
inout wire logic   vdda, 
inout wire logic   vss, 
input  [3:0] bias_lvl, 
input wire logic   byp_clk_sel, 
input wire logic   cp_int_mode, 
input   dbl_clk_sel, 
input wire logic  [2:0] dtest_sel, 
input wire logic   ena, 
input wire logic  [8:0] fbdiv_sel, 
input wire logic  [4:0] int_ctrl, 
input [7:0] mode, 
input wire logic  [1:0] pfd_mode, 
input wire logic  [1:0] post_div_sel, 
input wire logic  [1:0] prop_c_ctrl, 
input wire logic  [4:0] prop_ctrl, 
input wire logic  [1:0] prop_r_ctrl, 
input wire logic   refclk, 
input wire logic   refclk_alt, 
input wire logic   reset, 
input wire logic   ret, 
input wire logic   sel_refclk_alt );


wire logic divclk_dbl ;

wire logic fbclk_int ;

wire logic refclk_int ;

wire logic dtst_b ;

wire logic net042 ;

wire logic refclk_alt_selb ;

wire logic refclk_alt_sel ;

var real upprop ;

var real upbprop ;

wire logic nbias_cp ;

wire logic vco_clk0 ;

wire logic vco_clk270 ;

wire logic vco_clk180 ;

wire logic vco_clk90 ;

var real dnprop ;

var real dnbint ;

var real dnint ;

var real upbint ;

var real upint ;

wire logic vdbl ;

var real dnbprop ;

var real vcap ;

var real vring ;

wire logic dnb ;

wire logic dn ;

wire logic upb ;

wire logic up ;

wire logic net035 ;

wire logic rst_samp ;

wire logic retb ;

wire logic ret_or_rst ;

wire logic ret_or_rst_b ;

wire logic ena_retb ;

wire logic ena_retb_b ;

wire net14 ;

wire net2 ;

wire logic clk_rstb ;

wire net4 ;

wire logic clk_rst ;



WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_chp CP ( .int_ctrl(int_ctrl[4:0]), .vdda(vdda),
     .iupb_prop(upbprop), .mode(cp_int_mode), .idn_prop(dnprop),
     .idnb_prop(dnbprop), .iup_prop(upprop), .nbias(nbias_cp),
     .idn_int(dnint), .idnb_int(dnbint), .iup_int(upint),
     .iupb_int(upbint), .dn(dn), .dnb(dnb), .up(up), .upb(upb),
     .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_NOR2_D1_GL16_LVT NOR0 ( .tielo(vss), .tiehi(vdda), .y(ret_or_rst_b),
     .vss(vss), .vdd(vdda), .b(reset), .a(ret));
WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_fbdiv_v2 IFBDIV ( .vdda(vdda), .clkdiv_out(fbclk_int),
     .div(fbdiv_sel[8:0]), .reset(rst_samp), .clkin(net035),
     .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_MUXT2_D2_GL16_LVT MUX0 ( .vss(vss), .sb(refclk_alt_selb),
     .s(refclk_alt_sel), .b(refclk_alt), .a(refclk), .yb(net042),
     .vdd(vdda));
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUM_D1_GL16_LVT DUM1[0:805] ( .vdd(vdda), .vss(vss), .tiehi(vdda),
     .tielo(vss));*/
WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_postdiv_v2 IPOSTDIV ( .byp_clk_sel(byp_clk_sel),
     .byp_clk(refclk_int), .div16clk(clk_div16), .vdda(vdda),
     .div64clk(divclk_dbl), .div2clk(net035),
     .post_div(post_div_sel[1:0]), .outclk0(clk0), .outclk90(clk90),
     .outclk180(clk180), .outclk270(clk270), .vcoclk0(vco_clk0),
     .vcoclk90(vco_clk90), .vcoclk180(vco_clk180),
     .vcoclk270(vco_clk270), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_TST_MUX_LVT DTEST_MUX ( .tielo(vss), .tiehi(vdda), .tst_outb(dtst_b),
     .in({vss, vss, vss, vss, vss, divclk_dbl, refclk_int, fbclk_int}),
     .tst_out(dtest_out), .vdd(vdda), .sel(dtest_sel[2:0]), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV10 ( .in(net4), .vss(vss), .out(rst_samp),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV9 ( .in(clk_rstb), .vss(vss), .out(clk_rst),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV8 ( .in(refclk_int), .vss(vss), .out(clk_rstb),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV7 ( .in(ret_or_rst_b), .vss(vss), .out(ret_or_rst),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV6 ( .in(ena_retb_b), .vss(vss), .out(ena_retb),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV5 ( .in(ret), .vss(vss), .out(retb), .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV3 ( .vdd(vdda), .in(net042), .vss(vss),
     .out(refclk_int));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV1 ( .in(fbclk_int), .vss(vss), .out(fbclk),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV2 ( .in(sel_refclk_alt), .vss(vss),
     .out(refclk_alt_selb), .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV4 ( .in(refclk_alt_selb), .vss(vss),
     .out(refclk_alt_sel), .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV0 ( .in(refclk_int), .vss(vss), .out(refclk_out),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_rpll_pfd IPFD ( .reset(rst_samp), .vdda(vdda), .fbclk(fbclk_int),
     .mode(pfd_mode[1:0]), .refclk(refclk_int), .vss(vss), .dn(dn),
     .dnb(dnb), .up(up), .upb(upb));
WavD2DAnalogPhy_8lane_gf12lpp_rpll_bias IBIAS ( .bias_lvl(bias_lvl[3:0]), .vdda(vdda),
     .nbias_cp(nbias_cp), .en(ena_retb), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_FFRES_D1_GL16_LVT FF2 ( .rst(ret_or_rst), .rstb(ret_or_rst_b),
     .tielo(vss), .vss(vss), .vdd(vdda), .tiehi(vdda), .d(net14),
     .clkb(clk_rstb), .clk(clk_rst), .q(net4));
WavD2DAnalogPhy_8lane_gf12lpp_FFRES_D1_GL16_LVT FF1 ( .rst(ret_or_rst), .rstb(ret_or_rst_b),
     .tielo(vss), .vss(vss), .vdd(vdda), .tiehi(vdda), .d(net2),
     .clkb(clk_rstb), .clk(clk_rst), .q(net14));
WavD2DAnalogPhy_8lane_gf12lpp_FFRES_D1_GL16_LVT FF0 ( .rst(ret_or_rst), .rstb(ret_or_rst_b),
     .tiehi(vdda), .tielo(vss), .vss(vss), .vdd(vdda), .d(vdda),
     .clkb(clk_rstb), .clk(clk_rst), .q(net2));
WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_dbl_v2 IDBL ( .vdda(vdda), .clksel(dbl_clk_sel), .vdbl(vdbl),
     .divclk(divclk_dbl), .en(ena), .refclk(refclk_int), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_filter_v2 IFILTER ( .cap_rstb(ena),
     .prop_ctrl(prop_ctrl[4:0]), .vring(vring),
     .c_ctrl(prop_c_ctrl[1:0]), .r_ctrl(prop_r_ctrl[1:0]), .vdda(vdda),
     .idn_prop(dnprop), .idnb_prop(dnbprop), .iupb_prop(upbprop),
     .iup_prop(upprop), .vdbl(vdbl), .en(ena_retb), .vcap(vcap),
     .idn_int(dnint), .idnb_int(dnbint), .iup_int(upint),
     .iupb_int(upbint), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_NAND2_D1_GL16_LVT NAND0 ( .tielo(vss), .vdd(vdda), .y(ena_retb_b),
     .vss(vss), .tiehi(vdda), .b(ena), .a(retb));
WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_vco_v2 IRING ( .vddr(vring), .vdda(vdda), .en(ena_retb),
     .vss(vss), .clk270(vco_clk270), .clk180(vco_clk180),
     .clk90(vco_clk90), .clk0(vco_clk0));

endmodule
// Library - wphy_gf12lp_d2d_serdes_lib, Cell -
//WavD2DAnalogPhy_8lane_gf12lpp_WavRpllAna, View - schematic
// LAST TIME SAVED: Sep 14 09:16:05 2021
// NETLIST TIME: Oct  7 15:28:47 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_WavD2DAnalogPhy_8lane_gf12lpp_WavRpllAna ( 
output wire logic   rpll_fbclk,
output wire logic   rpll_refclk_out,
input  [3:0] rpll_bias_lvl,
input wire logic   rpll_byp_clk_sel,
input wire logic   rpll_cp_int_mode,
input   rpll_dbl_clk_sel,
input wire logic  [2:0] rpll_dtest_sel,
input wire logic   rpll_ena,
input wire logic  [8:0] rpll_fbdiv_sel,
input wire logic  [4:0] rpll_int_ctrl,
input [7:0] rpll_mode,
input wire logic  [1:0] rpll_pfd_mode,
input wire logic  [1:0] rpll_post_div_sel,
input wire logic  [1:0] rpll_prop_c_ctrl,
input wire logic  [4:0] rpll_prop_ctrl,
input wire logic  [1:0] rpll_prop_r_ctrl,
input wire logic   rpll_reset,
input wire logic   rpll_sel_refclk_alt,
output wire logic   clk0,
output wire logic   clk90,
output wire logic   clk180,
output wire logic   clk270,
input wire logic   refclk,
input wire logic   vdda,
input wire logic   vss,
output wire logic   rpll_clk_div16,
output wire logic   rpll_dtest_out,
output wire logic   refclk_out,
input wire logic   rpll_ret,
input wire logic   rpll_refclk_alt );


wire logic net2 ;



WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_ana_v2 rpll ( .ret(rpll_ret), .dtest_sel(rpll_dtest_sel[2:0]),
     .prop_c_ctrl(rpll_prop_c_ctrl[1:0]), .clk_div16(rpll_clk_div16),
     .refclk_alt(rpll_refclk_alt), .reset(rpll_reset),
     .prop_r_ctrl(rpll_prop_r_ctrl[1:0]), .clk0(clk0), .clk90(clk90),
     .clk180(clk180), .clk270(clk270), .fbclk(rpll_fbclk),
     .sel_refclk_alt(rpll_sel_refclk_alt),
     .refclk_out(rpll_refclk_out), .cp_int_mode(rpll_cp_int_mode),
     .dtest_out(rpll_dtest_out), .prop_ctrl(rpll_prop_ctrl[4:0]),
     .vdda(vdda), .fbdiv_sel(rpll_fbdiv_sel[8:0]),
     .int_ctrl(rpll_int_ctrl[4:0]), .mode(rpll_mode[7:0]),
     .pfd_mode(rpll_pfd_mode[1:0]),
     .post_div_sel(rpll_post_div_sel[1:0]), .refclk(refclk),
     .dbl_clk_sel(rpll_dbl_clk_sel), .ena(rpll_ena),
     .byp_clk_sel(rpll_byp_clk_sel), .bias_lvl(rpll_bias_lvl[3:0]),
     .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV0 ( .in(net2), .vss(vss), .out(refclk_out),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT I0 ( .in(refclk), .vss(vss), .out(net2), .vdd(vdda));

endmodule
// Library - wphy_gf12lp_d2d_serdes_lib, Cell - wav_d2d_rx_term_noxtlk,
//View - schematic
// LAST TIME SAVED: Aug 25 07:54:26 2021
// NETLIST TIME: Oct  7 15:28:48 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_wav_d2d_rx_term_noxtlk ( 
output var real  out , 
output wire logic   serdes_byp_in, 
inout wire logic   pad, 
inout wire logic   vdda, 
inout wire logic   vss, 
input wire logic   cal_en, 
input wire logic  [3:0] odt_ctrl, 
input wire logic   odt_dc, 
input wire logic   serdes_byp_sel, 
input wire logic   serlb_en, 
input wire logic   serlb_in, 
input var real  vref_dp  );


wire logic odt_dc_int ;

wire logic cal_enb ;

wire logic cal_enbuf ;

wire logic serlb_enbuf ;

wire logic serlb_enb ;

wire logic net019 ;

wire logic net021 ;

var real net018 ;

wire logic net1 ;

// Buses in the design

wire logic [3:0]  imp_ctrl;

wire logic [3:0]  imp_ctrl_b;



WavD2DAnalogPhy_8lane_gf12lpp_d2d_serlb_switch Iserlbswitch ( .vdda(vdda), .vss(vss), .out(net019),
     .serlb_enb(serlb_enb), .serlb_enbuf(serlb_enbuf),
     .serlb_in(serlb_in));
WavD2DAnalogPhy_8lane_gf12lpp_d2d_rx_term_res ODT ( .odt_dc(odt_dc_int), .pad(pad),
     .odt_ctrl(imp_ctrl[3:0]), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_wav_d2d_vref_switch Ivrefswitch ( .vdda(vdda), .vss(vss), .out(net018),
     .cal_enb(cal_enb), .cal_enbuf(cal_enbuf), .vref_dp(vref_dp));
WavD2DAnalogPhy_8lane_gf12lpp_d2d_hyst_rx I4 ( .vdda(vdda), .out(serdes_byp_in), .en(serdes_byp_sel),
     .in(out), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_cdm_50ohm_d2d HBM1 ( .out(net1), .vss(vss), .vdd(vdda), .pad(pad));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV5 ( .vdd(vdda), .in(odt_dc), .vss(vss),
     .out(net021));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV3[1:0] ( .out(odt_dc_int), .vdd(vdda), .vss(vss),
     .in(net021));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV7 ( .vdd(vdda), .in(cal_en), .vss(vss),
     .out(cal_enb));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV6 ( .vdd(vdda), .in(cal_enb), .vss(vss),
     .out(cal_enbuf));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV2[3:0] ( .out(imp_ctrl_b[3:0]), .vdd(vdda),
     .vss(vss), .in(odt_ctrl[3:0]));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV4[3:0] ( .out(imp_ctrl[3:0]), .vdd(vdda), .vss(vss),
     .in(imp_ctrl_b[3:0]));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV1 ( .vdd(vdda), .in(serlb_enb), .vss(vss),
     .out(serlb_enbuf));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV0 ( .vdd(vdda), .in(serlb_en), .vss(vss),
     .out(serlb_enb));
WavD2DAnalogPhy_8lane_gf12lpp_wav_d2d_rx_sv_switch ISV_SW ( .out(out), .pad_in(net1),
     .serlb_in(net019), .vref_in(net018));
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUM_D1_GL16_LVT Icdum[25:0] ( .vdd(vdda), .vss(vss), .tiehi(vdda),
     .tielo(vss));*/
WavD2DAnalogPhy_8lane_gf12lpp_hbm_d2d HBM0 ( .vss(vss), .vdd(vdda), .pad(pad));

endmodule
// Library - wphy_gf12lp_d2d_serdes_lib, Cell -
//wav_d2d_deserializer_1to2_IQ, View - schematic
// LAST TIME SAVED: Aug 16 09:44:49 2021
// NETLIST TIME: Oct  7 15:28:48 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_wav_d2d_deserializer_1to2_IQ ( 
output wire logic   Data_I, 
output wire logic   Data_Ib, 
output wire logic   Data_Q, 
output wire logic   Data_Qb, 
output wire logic  [1:0] iclk_out, 
output wire logic  [1:0] iclkb_out, 
inout wire logic   vdda, 
inout wire logic   vdda_ck, 
inout wire logic   vss, 
input var real  data_in , 
input wire logic   i_en, 
input wire logic   iclk, 
input wire logic   iclkb, 
input wire logic   osc_dir_i_dp, 
input wire logic   osc_dir_ib_dp, 
input wire logic   osc_dir_q_dp, 
input wire logic   osc_dir_qb_dp, 
input wire logic  [3:0] osc_i_dp, 
input wire logic  [3:0] osc_ib_dp, 
input wire logic  [3:0] osc_q_dp, 
input wire logic  [3:0] osc_qb_dp, 
input wire logic   q_en, 
input wire logic   qclk, 
input wire logic   qclkb, 
input var real  ref_dp , 
input var real  ref_qp  );


wire logic net3 ;

wire logic sa_ib_dp_n ;

wire logic net0244 ;

wire logic iclk_buf_fff ;

wire logic sa_qb_dp_n ;

wire logic sa_i_dp_n ;

wire logic iclkb_buf ;

wire logic iclk_buf ;

wire logic ff3_q ;

wire logic sa_q_dp_n ;

wire logic ff1_q ;

wire logic ff2_q ;

wire logic qclk_buf_fff ;

wire logic ff3_i ;

wire logic iclk1 ;

wire ff1_qb ;

wire logic ff2_qb ;

wire logic qclkb1 ;

wire logic net4 ;

wire logic net0239 ;

wire logic net0245 ;

wire logic ff2_i ;

wire ff1_ib ;

wire logic ff1_i ;

wire logic ff2_ib ;

wire logic net1 ;

wire logic qclk1 ;

wire logic ilckb1 ;

wire logic ff3_qb ;

wire logic qclkb_buf_fff ;

wire logic iclkb_buf_fff ;



/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUMLOAD_D2_GL16_LVT I113[5:0] ( .vdd(vdda), .vss(vss), .inn(qclk1),
     .inp(qclk1));*/
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUMLOAD_D2_GL16_LVT I115[5:0] ( .vdd(vdda), .vss(vss), .inn(qclkb1),
     .inp(qclkb1));*/
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_PUDUM_D1_GL16_LVT PUdumSA[19:0] ( .vdd(vdda_ck), .tiehi(vdda_ck));*/
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT_Mmodel_delay INV43[1:0] ( .out(iclkb_buf_fff),
     .vdd(vdda), .vss(vss), .in(iclk1));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT_Mmodel_delay INV2[5:0] ( .out(iclkb_buf), .vdd(vdda),
     .vss(vss), .in(iclk1));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT_Mmodel_delay INV0[5:0] ( .out(iclk_buf), .vdd(vdda),
     .vss(vss), .in(ilckb1));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT_Mmodel_delay INV42[1:0] ( .out(iclk_buf_fff),
     .vdd(vdda), .vss(vss), .in(ilckb1));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT_Mmodel_delay INV44[1:0] ( .out(qclkb_buf_fff),
     .vdd(vdda), .vss(vss), .in(qclk1));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT_Mmodel_delay INV45[1:0] ( .out(qclk_buf_fff),
     .vdd(vdda), .vss(vss), .in(qclkb1));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF9 ( .tiehi(vdda), .vss(vss), .vdd(vdda), .tielo(vss),
     .d(ff2_i), .clkb(iclkb_buf), .clk(iclk_buf), .q(ff3_i));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF13 ( .tiehi(vdda), .vss(vss), .vdd(vdda), .tielo(vss),
     .d(sa_i_dp_n), .clkb(iclkb_buf_fff), .clk(iclk_buf_fff),
     .q(ff1_i));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF0 ( .tiehi(vdda), .vss(vss), .vdd(vdda), .tielo(vss),
     .d(ff1_i), .clkb(iclkb_buf), .clk(iclk_buf), .q(ff2_i));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF10 ( .tiehi(vdda), .vss(vss), .vdd(vdda), .tielo(vss),
     .d(ff1_ib), .clkb(iclkb_buf), .clk(iclk_buf), .q(ff2_ib));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF6 ( .tiehi(vdda), .tielo(vss), .vss(vss), .vdd(vdda),
     .d(ff1_q), .clkb(iclkb_buf), .clk(iclk_buf), .q(ff2_q));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF12 ( .tiehi(vdda), .tielo(vss), .vss(vss), .vdd(vdda),
     .d(ff2_qb), .clkb(iclkb_buf), .clk(iclk_buf), .q(ff3_qb));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF11 ( .tiehi(vdda), .tielo(vss), .vss(vss), .vdd(vdda),
     .d(ff1_qb), .clkb(iclkb_buf), .clk(iclk_buf), .q(ff2_qb));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF16 ( .tiehi(vdda), .tielo(vss), .vss(vss), .vdd(vdda),
     .d(sa_q_dp_n), .clkb(qclkb_buf_fff), .clk(qclk_buf_fff),
     .q(ff1_q));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF7 ( .tiehi(vdda), .tielo(vss), .vss(vss), .vdd(vdda),
     .d(ff2_q), .clkb(iclkb_buf), .clk(iclk_buf), .q(ff3_q));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D4_GL16_LVT INV16[1:0] ( .out(iclk_out[1:0]), .vdd(vdda),
     .vss(vss), .in(iclkb_buf));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D4_GL16_LVT INV17[1:0] ( .out(iclkb_out[1:0]), .vdd(vdda),
     .vss(vss), .in(iclk_buf));
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUM_D1_GL16_LVT Icmos_dum[61:0] ( .vdd(vdda), .vss(vss), .tiehi(vdda),
     .tielo(vss));*/
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUM_D1_GL16_LVT DUMSA[157:0] ( .vdd(vdda_ck), .vss(vss),
     .tiehi(vdda_ck), .tielo(vss));*/
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV10 ( .in(ff3_i), .vss(vss), .out(Data_I),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV8[3:0] ( .out(iclk1), .vdd(vdda_ck), .vss(vss),
     .in(iclkb));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV12[3:0] ( .out(ilckb1), .vdd(vdda_ck), .vss(vss),
     .in(iclk));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV11[3:0] ( .out(qclk1), .vdd(vdda_ck), .vss(vss),
     .in(qclkb));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV35 ( .in(ff3_qb), .vss(vss), .out(Data_Qb),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV15 ( .in(ff3_q), .vss(vss), .out(Data_Q),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV6 ( .in(ff2_ib), .vss(vss), .out(Data_Ib),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV13[3:0] ( .out(qclkb1), .vdd(vdda_ck), .vss(vss),
     .in(qclk));
WavD2DAnalogPhy_8lane_gf12lpp_FF1P5_D1_GL16_LVT FF4 ( .tielo(vss), .tiehi(vdda), .vss(vss),
     .vdd(vdda), .q1p5(ff1_qb), .d(sa_qb_dp_n), .clkb(qclk_buf_fff),
     .clk(qclkb_buf_fff), .q(net0244));
WavD2DAnalogPhy_8lane_gf12lpp_FF1P5_D1_GL16_LVT FF1 ( .tielo(vss), .tiehi(vdda), .vss(vss),
     .vdd(vdda), .q1p5(ff1_ib), .d(sa_ib_dp_n), .clkb(iclk_buf_fff),
     .clk(iclkb_buf_fff), .q(net4));
WavD2DAnalogPhy_8lane_gf12lpp_wphy_sa_14g SNSAMP_I_DP ( .cal(osc_i_dp[3:0]), .vdda(vdda_ck),
     .clkb(iclkb), .inn(ref_dp), .inp(data_in), .ena(i_en),
     .qb(sa_i_dp_n), .cal_dir(osc_dir_i_dp), .q(net1), .vss(vss),
     .clk(iclk));
WavD2DAnalogPhy_8lane_gf12lpp_wphy_sa_14g SNSAMP_Q_DP ( .clkb(qclkb), .cal(osc_q_dp[3:0]),
     .ena(q_en), .qb(sa_q_dp_n), .cal_dir(osc_dir_q_dp), .q(net0239),
     .vdda(vdda_ck), .clk(qclk), .inn(ref_qp), .inp(data_in),
     .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_wphy_sa_14g SNSAMP_QB_DP ( .clkb(qclk), .cal(osc_qb_dp[3:0]),
     .ena(q_en), .qb(sa_qb_dp_n), .cal_dir(osc_dir_qb_dp), .q(net0245),
     .vdda(vdda_ck), .clk(qclkb), .inn(ref_qp), .inp(data_in),
     .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_wphy_sa_14g SNSAMP_IB_DP ( .cal(osc_ib_dp[3:0]), .vdda(vdda_ck),
     .clkb(iclk), .inn(ref_dp), .inp(data_in), .ena(i_en),
     .qb(sa_ib_dp_n), .cal_dir(osc_dir_ib_dp), .q(net3), .vss(vss),
     .clk(iclkb));

endmodule
// Library - wphy_gf12lp_d2d_serdes_lib, Cell - d2d_deserializer_2to16,
//View - schematic
// LAST TIME SAVED: Aug 13 13:43:27 2021
// NETLIST TIME: Oct  7 15:28:48 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_d2d_deserializer_2to16 ( 
output wire logic  [15:0] rdata, 
inout wire logic   vdda, 
inout wire logic   vss, 
input wire logic   clk_div2, 
input wire logic   clk_div16, 
input wire logic   clkb_div2, 
input wire logic   clkb_div8, 
input wire logic   din, 
input wire logic   dinb );


wire logic clk_div2buf ;

wire logic clk_div8_int ;

wire logic clkb_div8_int ;

wire logic clkb_div8_a ;

wire logic clkb_div16 ;

wire logic clka_div16 ;

wire logic ff_3 ;

wire logic ff_1 ;

wire logic ff_2 ;

wire logic ff_4 ;

wire logic ff_7 ;

wire logic clkb_div2buf ;

wire logic ff_0 ;

wire logic ff_6 ;

wire logic ff_5 ;

wire logic clk_div8_a ;

// Buses in the design

wire logic [15:0]  net34;

wire logic [15:0]  div16_dat;

wire logic [15:0]  div8_dat;



/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUM_D1_GL16_LVT Icdum[25:0] ( .vdd(vdda), .vss(vss), .tiehi(vdda),
     .tielo(vss));*/
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF10 ( .tiehi(vdda), .tielo(vss), .vdd(vdda), .vss(vss),
     .d(div8_dat[11]), .clkb(clk_div8_int), .clk(clkb_div8_int),
     .q(div8_dat[3]));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF8 ( .tiehi(vdda), .tielo(vss), .vdd(vdda), .vss(vss),
     .d(div8_dat[15]), .clkb(clk_div8_int), .clk(clkb_div8_int),
     .q(div8_dat[7]));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF12[15:0] ( .q(div16_dat[15:0]), .vdd(vdda), .vss(vss),
     .clk(clkb_div16), .clkb(clka_div16), .d(div8_dat[15:0]),
     .tiehi(vdda), .tielo(vss));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF3 ( .tiehi(vdda), .tielo(vss), .vdd(vdda), .vss(vss),
     .d(div8_dat[8]), .clkb(clk_div8_int), .clk(clkb_div8_int),
     .q(div8_dat[0]));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF11 ( .tiehi(vdda), .tielo(vss), .vdd(vdda), .vss(vss),
     .d(div8_dat[13]), .clkb(clk_div8_int), .clk(clkb_div8_int),
     .q(div8_dat[5]));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF9 ( .tiehi(vdda), .tielo(vss), .vdd(vdda), .vss(vss),
     .d(div8_dat[9]), .clkb(clk_div8_int), .clk(clkb_div8_int),
     .q(div8_dat[1]));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF0 ( .tiehi(vdda), .tielo(vss), .vdd(vdda), .vss(vss),
     .d(div8_dat[14]), .clkb(clk_div8_int), .clk(clkb_div8_int),
     .q(div8_dat[6]));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF2 ( .tiehi(vdda), .tielo(vss), .vdd(vdda), .vss(vss),
     .d(div8_dat[10]), .clkb(clk_div8_int), .clk(clkb_div8_int),
     .q(div8_dat[2]));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF1 ( .tiehi(vdda), .tielo(vss), .vdd(vdda), .vss(vss),
     .d(div8_dat[12]), .clkb(clk_div8_int), .clk(clkb_div8_int),
     .q(div8_dat[4]));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT Idiv2_ff6 ( .tiehi(vdda), .tielo(vss), .vdd(vdda),
     .vss(vss), .q(ff_6), .clk(clk_div2buf), .clkb(clkb_div2buf),
     .d(din));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT Idiv2_ff7 ( .tiehi(vdda), .tielo(vss), .vdd(vdda),
     .vss(vss), .q(ff_7), .clk(clk_div2buf), .clkb(clkb_div2buf),
     .d(dinb));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT Idiv2_ff2 ( .tiehi(vdda), .tielo(vss), .vdd(vdda),
     .vss(vss), .q(ff_2), .clk(clk_div2buf), .clkb(clkb_div2buf),
     .d(ff_4));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT Idiv2_ff0 ( .tiehi(vdda), .tielo(vss), .vdd(vdda),
     .vss(vss), .q(ff_0), .clk(clk_div2buf), .clkb(clkb_div2buf),
     .d(ff_2));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF4 ( .tiehi(vdda), .tielo(vss), .vdd(vdda), .vss(vss),
     .d(ff_0), .clkb(clk_div8_int), .clk(clkb_div8_int),
     .q(div8_dat[8]));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF5 ( .tiehi(vdda), .tielo(vss), .vdd(vdda), .vss(vss),
     .d(ff_2), .clkb(clk_div8_int), .clk(clkb_div8_int),
     .q(div8_dat[10]));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF6 ( .tiehi(vdda), .tielo(vss), .vdd(vdda), .vss(vss),
     .d(ff_4), .clkb(clk_div8_int), .clk(clkb_div8_int),
     .q(div8_dat[12]));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT Idiv2_ff4 ( .tiehi(vdda), .tielo(vss), .vdd(vdda),
     .vss(vss), .q(ff_4), .clk(clk_div2buf), .clkb(clkb_div2buf),
     .d(ff_6));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF7 ( .tiehi(vdda), .tielo(vss), .vdd(vdda), .vss(vss),
     .d(ff_6), .clkb(clk_div8_int), .clk(clkb_div8_int),
     .q(div8_dat[14]));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF16 ( .tiehi(vdda), .tielo(vss), .vdd(vdda), .vss(vss),
     .d(ff_7), .clkb(clk_div8_int), .clk(clkb_div8_int),
     .q(div8_dat[15]));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT Idiv2_ff1 ( .tiehi(vdda), .tielo(vss), .vdd(vdda),
     .vss(vss), .q(ff_1), .clk(clk_div2buf), .clkb(clkb_div2buf),
     .d(ff_3));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF15 ( .tiehi(vdda), .tielo(vss), .vdd(vdda), .vss(vss),
     .d(ff_5), .clkb(clk_div8_int), .clk(clkb_div8_int),
     .q(div8_dat[13]));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT Idiv2_ff3 ( .tiehi(vdda), .tielo(vss), .vdd(vdda),
     .vss(vss), .q(ff_3), .clk(clk_div2buf), .clkb(clkb_div2buf),
     .d(ff_5));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF13 ( .tiehi(vdda), .tielo(vss), .vdd(vdda), .vss(vss),
     .d(ff_1), .clkb(clk_div8_int), .clk(clkb_div8_int),
     .q(div8_dat[9]));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF14 ( .tiehi(vdda), .tielo(vss), .vdd(vdda), .vss(vss),
     .d(ff_3), .clkb(clk_div8_int), .clk(clkb_div8_int),
     .q(div8_dat[11]));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT Idiv2_ff5 ( .tiehi(vdda), .tielo(vss), .vdd(vdda),
     .vss(vss), .q(ff_5), .clk(clk_div2buf), .clkb(clkb_div2buf),
     .d(ff_7));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV10[15:0] ( .out(net34[15:0]), .vdd(vdda), .vss(vss),
     .in(div16_dat[15:0]));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV2[1:0] ( .out(clk_div8_a), .vdd(vdda), .vss(vss),
     .in(clkb_div8));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV6[5:0] ( .out(clka_div16), .vdd(vdda), .vss(vss),
     .in(clkb_div16));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV18[5:0] ( .out(clkb_div16), .vdd(vdda), .vss(vss),
     .in(clk_div16));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV11[15:0] ( .out(rdata[15:0]), .vdd(vdda), .vss(vss),
     .in(net34[15:0]));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV3[5:0] ( .out(clkb_div8_int), .vdd(vdda), .vss(vss),
     .in(clkb_div8_a));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV16[3:0] ( .out(clkb_div2buf), .vdd(vdda), .vss(vss),
     .in(clk_div2));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV12[1:0] ( .out(clkb_div8_a), .vdd(vdda), .vss(vss),
     .in(clk_div8_a));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV17[3:0] ( .out(clk_div2buf), .vdd(vdda), .vss(vss),
     .in(clkb_div2));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV7[5:0] ( .out(clk_div8_int), .vdd(vdda), .vss(vss),
     .in(clkb_div8_int));

endmodule
// Library - wphy_gf12lp_d2d_serdes_lib, Cell -
//wav_d2d_deserializer_IQ, View - schematic
// LAST TIME SAVED: Aug 20 11:21:23 2021
// NETLIST TIME: Oct  7 15:28:48 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_wav_d2d_deserializer_IQ ( 
output wire logic   clk_div16, 
output wire logic  [15:0] idata, 
output wire logic  [15:0] qdata, 
inout wire logic   vdda, 
inout wire logic   vdda_ck, 
inout wire logic   vss, 
input wire logic   clk_div8_in, 
input wire logic   clk_div16_in, 
input var real  data_in , 
input wire logic   i_en, 
input wire logic   iclk_in, 
input wire logic   iclkb_in, 
input wire logic   osc_dir_i_dp, 
input wire logic   osc_dir_ib_dp, 
input wire logic   osc_dir_q_dp, 
input wire logic   osc_dir_qb_dp, 
input wire logic  [3:0] osc_i_dp, 
input wire logic  [3:0] osc_ib_dp, 
input wire logic  [3:0] osc_q_dp, 
input wire logic  [3:0] osc_qb_dp, 
input wire logic   q_en, 
input wire logic   qclk_in, 
input wire logic   qclkb_in, 
input var real  ref_dp , 
input var real  ref_qp  );


wire logic q_en8_16 ;

wire logic i_en8_16 ;

wire logic i_enb8_16 ;

wire logic clk_div16_int_q ;

wire logic clkb_div16_int_q ;

wire logic q_enb8_16 ;

wire logic clkb_div8_int_q ;

wire logic q_enb ;

wire logic q_en_buf ;

wire logic i_enb ;

wire logic i_en_buf ;

wire logic qclk_int ;

wire logic qclkb_int ;

wire logic iclk_int ;

wire logic qclkb ;

wire logic iclkb ;

wire logic iclk ;

wire logic iclkb_int ;

wire logic clkb_div16_int_i ;

wire logic clkb_div8_int_i ;

wire logic qclk ;

wire logic clk_div16_int_i ;

wire logic data_i ;

wire logic data_qb ;

wire logic data_q ;

wire logic data_ib ;

// Buses in the design

wire logic [1:0]  iclkb_d;

wire logic [1:0]  iclk_d;



/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUM_D1_GL16_LVT Icdum[155:0] ( .vdd(vdda), .vss(vss), .tiehi(vdda),
     .tielo(vss));*/
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUM_D1_GL16_LVT Icdum_ck[43:0] ( .vdd(vdda_ck), .vss(vss),
     .tiehi(vdda_ck), .tielo(vss));*/
WavD2DAnalogPhy_8lane_gf12lpp_wav_d2d_deserializer_1to2_IQ Ides_1to2 ( .osc_qb_dp(osc_qb_dp[3:0]),
     .osc_ib_dp(osc_ib_dp[3:0]), .iclk_out(iclk_d[1:0]),
     .osc_q_dp(osc_q_dp[3:0]), .iclkb_out(iclkb_d[1:0]),
     .ref_dp(ref_dp), .q_en(q_en_buf), .i_en(i_en_buf),
     .osc_i_dp(osc_i_dp[3:0]), .vss(vss), .qclkb(qclkb), .qclk(qclk),
     .iclkb(iclkb), .iclk(iclk), .vdda_ck(vdda_ck), .data_in(data_in),
     .osc_dir_qb_dp(osc_dir_qb_dp), .osc_dir_q_dp(osc_dir_q_dp),
     .osc_dir_ib_dp(osc_dir_ib_dp), .Data_Qb(data_qb), .Data_Q(data_q),
     .Data_Ib(data_ib), .Data_I(data_i), .osc_dir_i_dp(osc_dir_i_dp),
     .ref_qp(ref_qp), .vdda(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INVT_D2_GL16_LVT INVT1[1:0] ( .out(clkb_div16_int_q), .vdd(vdda),
     .vss(vss), .en(q_en8_16), .enb(q_enb8_16), .in(clk_div16_in));
WavD2DAnalogPhy_8lane_gf12lpp_INVT_D2_GL16_LVT INV18 ( .out(clkb_div8_int_i), .en(i_en8_16),
     .enb(i_enb8_16), .vss(vss), .in(clk_div8_in), .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INVT_D2_GL16_LVT INV26[2:0] ( .out(iclkb_int), .vdd(vdda_ck),
     .vss(vss), .en(i_en_buf), .enb(i_enb), .in(iclk_in));
WavD2DAnalogPhy_8lane_gf12lpp_INVT_D2_GL16_LVT INV30[2:0] ( .out(iclk_int), .vdd(vdda_ck), .vss(vss),
     .en(i_en_buf), .enb(i_enb), .in(iclkb_in));
WavD2DAnalogPhy_8lane_gf12lpp_INVT_D2_GL16_LVT INVT0 ( .out(clkb_div8_int_q), .en(q_en8_16),
     .enb(q_enb8_16), .vss(vss), .in(clk_div8_in), .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INVT_D2_GL16_LVT INV34[2:0] ( .out(qclkb_int), .vdd(vdda_ck),
     .vss(vss), .en(q_en_buf), .enb(q_enb), .in(qclk_in));
WavD2DAnalogPhy_8lane_gf12lpp_INVT_D2_GL16_LVT INV6[1:0] ( .out(clkb_div16_int_i), .vdd(vdda),
     .vss(vss), .en(i_en8_16), .enb(i_enb8_16), .in(clk_div16_in));
WavD2DAnalogPhy_8lane_gf12lpp_INVT_D2_GL16_LVT INV36[2:0] ( .out(qclk_int), .vdd(vdda_ck), .vss(vss),
     .en(q_en_buf), .enb(q_enb), .in(qclkb_in));
WavD2DAnalogPhy_8lane_gf12lpp_PU_D2_GL16_LVT PD15 ( .vdd(vdda_ck), .en(q_en_buf), .y(qclkb_int));
WavD2DAnalogPhy_8lane_gf12lpp_PU_D2_GL16_LVT PU1 ( .vdd(vdda), .en(i_en8_16), .y(clkb_div16_int_i));
WavD2DAnalogPhy_8lane_gf12lpp_PU_D2_GL16_LVT PD10 ( .vdd(vdda_ck), .en(i_en_buf), .y(iclkb_int));
WavD2DAnalogPhy_8lane_gf12lpp_PU_D2_GL16_LVT PU0 ( .vdd(vdda), .en(q_en8_16), .y(clkb_div16_int_q));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV44 ( .in(i_en), .vss(vss), .out(i_enb8_16),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV0 ( .in(q_en), .vss(vss), .out(q_enb8_16),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV1[1:0] ( .out(q_enb), .vdd(vdda_ck), .vss(vss),
     .in(q_en));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV22[1:0] ( .out(i_en_buf), .vdd(vdda_ck), .vss(vss),
     .in(i_enb));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV10[1:0] ( .out(clk_div16_int_i), .vdd(vdda),
     .vss(vss), .in(clkb_div16_int_i));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV40[9:0] ( .out(qclkb), .vdd(vdda_ck), .vss(vss),
     .in(qclk_int));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV4[1:0] ( .out(i_enb), .vdd(vdda_ck), .vss(vss),
     .in(i_en));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV38[9:0] ( .out(qclk), .vdd(vdda_ck), .vss(vss),
     .in(qclkb_int));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV2 ( .in(q_enb8_16), .vss(vss), .out(q_en8_16),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV28[9:0] ( .out(iclk), .vdd(vdda_ck), .vss(vss),
     .in(iclkb_int));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV32[9:0] ( .out(iclkb), .vdd(vdda_ck), .vss(vss),
     .in(iclk_int));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV16[1:0] ( .out(clk_div16), .vdd(vdda), .vss(vss),
     .in(clkb_div16_int_i));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV45 ( .in(i_enb8_16), .vss(vss), .out(i_en8_16),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV23[1:0] ( .out(q_en_buf), .vdd(vdda_ck), .vss(vss),
     .in(q_enb));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV5[1:0] ( .out(clk_div16_int_q), .vdd(vdda),
     .vss(vss), .in(clkb_div16_int_q));
WavD2DAnalogPhy_8lane_gf12lpp_d2d_deserializer_2to16 Ides_2to10i ( .vss(vss),
     .clk_div16(clk_div16_int_i), .dinb(data_ib), .din(data_i),
     .clkb_div8(clkb_div8_int_i), .vdda(vdda), .clkb_div2(iclkb_d[0]),
     .rdata(idata[15:0]), .clk_div2(iclk_d[0]));
WavD2DAnalogPhy_8lane_gf12lpp_d2d_deserializer_2to16 Ides_2to10q ( .vss(vss),
     .clk_div16(clk_div16_int_q), .dinb(data_q), .din(data_qb),
     .clkb_div8(clkb_div8_int_q), .vdda(vdda), .clkb_div2(iclkb_d[1]),
     .rdata(qdata[15:0]), .clk_div2(iclk_d[1]));
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_PDDUM_D2_GL16_LVT PUdum0 ( .vss(vss), .tielo(i_en_buf));*/
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_PDDUM_D2_GL16_LVT PDdum1 ( .tielo(q_en8_16), .vss(vss));*/
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_PDDUM_D2_GL16_LVT PDdum0 ( .tielo(i_en8_16), .vss(vss));*/
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_PDDUM_D2_GL16_LVT PUdum2 ( .vss(vss), .tielo(q_en_buf));*/
WavD2DAnalogPhy_8lane_gf12lpp_PD_D2_GL16_LVT PD16 ( .vss(vss), .enb(q_enb), .y(qclk_int));
WavD2DAnalogPhy_8lane_gf12lpp_PD_D2_GL16_LVT PD0 ( .vss(vss), .enb(i_enb8_16), .y(clkb_div8_int_i));
WavD2DAnalogPhy_8lane_gf12lpp_PD_D2_GL16_LVT PD1 ( .vss(vss), .enb(q_enb8_16), .y(clkb_div8_int_q));
WavD2DAnalogPhy_8lane_gf12lpp_PD_D2_GL16_LVT PD14 ( .vss(vss), .enb(i_enb), .y(iclk_int));
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_PUDUM_D2_GL16_LVT PUdum3 ( .vdd(vdda_ck), .tiehi(q_enb));*/
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_PUDUM_D2_GL16_LVT PUdum1 ( .vdd(vdda_ck), .tiehi(i_enb));*/
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_PUDUM_D2_GL16_LVT PUdum8 ( .tiehi(q_enb8_16), .vdd(vdda));*/
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_PUDUM_D2_GL16_LVT PU9dum ( .tiehi(i_enb8_16), .vdd(vdda));*/
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUMLOAD_D2_GL16_LVT Idumload16[1:0] ( .vdd(vdda), .vss(vss),
     .inn(clk_div16_in), .inp(clk_div16_in));*/
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUMLOAD_D2_GL16_LVT Idumload8[3:0] ( .vdd(vdda), .vss(vss),
     .inn(clk_div8_in), .inp(clk_div8_in));*/
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUMLOAD_D2_GL16_LVT I42[1:0] ( .vdd(vdda), .vss(vss),
     .inn(clkb_div16_int_q), .inp(clkb_div16_int_q));*/

endmodule
// Library - wphy_gf12lp_d2d_serdes_lib, Cell - cmos_cap, View -
//schematic
// LAST TIME SAVED: Apr 19 18:08:32 2021
// NETLIST TIME: Oct  7 15:28:48 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_cmos_cap ( 
inout   plus, 
inout   vss );




/*REMOVED VIA SCRIPT -- ncap_2t  C0[7:0] ( .g(plus), .sd(vss));*/
/*REMOVED VIA SCRIPT -- pcapacitor  C1 ( .MINUS(vss), .PLUS(plus));*/

endmodule
// Library - wavshared_gf12lp_ana_lib, Cell - MOSMOM_LV_N_THIN, View -
//schematic
// LAST TIME SAVED: Nov 20 08:17:04 2020
// NETLIST TIME: Oct  7 15:28:48 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_MOSMOM_LV_N_THIN ( 
inout   MINUS, 
inout   PLUS );




/*REMOVED VIA SCRIPT -- ncap_2t  C0 ( .sd(MINUS), .g(PLUS));*/
/*REMOVED VIA SCRIPT -- pcapacitor  C1 ( .MINUS(MINUS), .PLUS(PLUS));*/

endmodule
// Library - wphy_gf12lp_d2d_serdes_lib, Cell - wav_d2d_rx_ana_IQ, View
//- schematic
// LAST TIME SAVED: Sep 13 07:17:54 2021
// NETLIST TIME: Oct  7 15:28:48 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_wav_d2d_rx_ana_IQ ( 
output wire logic   rx_clk_div16, 
output wire logic  [15:0] rx_idata, 
output wire logic   rx_serdes_byp_in, 
output wire logic  [15:0] rxq_qdata, 
inout wire logic   pad_rx, 
inout wire logic   vdda, 
inout wire logic   vdda_ck, 
inout wire logic   vss, 
input wire logic   rx_cal_en, 
input wire logic   rx_clk_div8_in, 
input wire logic   rx_clk_div16_in, 
input wire logic   rx_i_en, 
input wire logic   rx_iclk, 
input wire logic   rx_iclkb, 
input var real  rx_iref , 
input wire logic  [3:0] rx_odt_ctrl, 
input wire logic   rx_odt_dc_mode, 
input wire logic   rx_osc_dir_i_dp, 
input wire logic   rx_osc_dir_ib_dp, 
input wire logic  [3:0] rx_osc_i_dp, 
input wire logic  [3:0] rx_osc_ib_dp, 
input wire logic   rx_serdes_byp_sel, 
input wire logic   rx_serlb_en, 
input wire logic   rx_serlb_in, 
input wire logic   rxq_osc_dir_q_dp, 
input wire logic   rxq_osc_dir_qb_dp, 
input wire logic  [3:0] rxq_osc_q_dp, 
input wire logic  [3:0] rxq_osc_qb_dp, 
input wire logic   rxq_q_en, 
input wire logic   rxq_qclk, 
input wire logic   rxq_qclkb );


var real sampler_in ;



WavD2DAnalogPhy_8lane_gf12lpp_wav_d2d_rx_term_noxtlk RXTERM ( .vdda(vdda), .vref_dp(rx_iref),
     .serdes_byp_sel(rx_serdes_byp_sel),
     .serdes_byp_in(rx_serdes_byp_in), .odt_dc(rx_odt_dc_mode),
     .cal_en(rx_cal_en), .odt_ctrl(rx_odt_ctrl[3:0]), .vss(vss),
     .out(sampler_in), .pad(pad_rx), .serlb_in(rx_serlb_in),
     .serlb_en(rx_serlb_en));
WavD2DAnalogPhy_8lane_gf12lpp_wav_d2d_deserializer_IQ DESER ( .ref_qp(rx_iref), .ref_dp(rx_iref),
     .vdda(vdda), .vdda_ck(vdda_ck), .osc_ib_dp(rx_osc_ib_dp[3:0]),
     .osc_dir_ib_dp(rx_osc_dir_ib_dp), .osc_dir_q_dp(rxq_osc_dir_q_dp),
     .osc_dir_qb_dp(rxq_osc_dir_qb_dp), .osc_qb_dp(rxq_osc_qb_dp[3:0]),
     .osc_q_dp(rxq_osc_q_dp[3:0]), .osc_dir_i_dp(rx_osc_dir_i_dp),
     .osc_i_dp(rx_osc_i_dp[3:0]), .clk_div8_in(rx_clk_div8_in),
     .clk_div16_in(rx_clk_div16_in), .idata(rx_idata[15:0]),
     .qdata(rxq_qdata[15:0]), .clk_div16(rx_clk_div16),
     .qclkb_in(rxq_qclkb), .qclk_in(rxq_qclk), .iclkb_in(rx_iclkb),
     .iclk_in(rx_iclk), .i_en(rx_i_en), .q_en(rxq_q_en),
     .data_in(sampler_in), .vss(vss));
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_cmos_cap C1[16:0] ( .plus(vdda_ck), .vss(vss));*/
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_cmos_cap C0[13:0] ( .plus(rx_iref), .vss(vss));*/
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_MOSMOM_LV_N_THIN C2[3:0] ( .MINUS(vss), .PLUS(vdda_ck));*/

endmodule
// Library - wphy_gf12lp_d2d_serdes_lib, Cell - wav_d2d_clk_rcvr, View
//- schematic
// LAST TIME SAVED: Sep  7 10:15:47 2021
// NETLIST TIME: Oct  7 15:28:48 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_wav_d2d_clk_rcvr ( 
output wire logic   clk_bypass_n_in, 
output wire logic   clk_bypass_p_in, 
output wire logic   clkn, 
output wire logic   clkp, 
inout wire logic   vdda, 
inout wire logic   vss, 
input wire logic   ac_mode, 
input wire logic   clk_bypass_sel, 
input wire logic   clk_serlb_inn, 
input wire logic   clk_serlb_inp, 
input wire logic   en, 
input wire logic   en_fb, 
input wire logic  [3:0] odt_ctrl, 
input wire logic   odt_dc, 
input wire logic   pad_rxn, 
input wire logic   pad_rxp, 
input wire logic   ser_lpb_en );


wire logic net018 ;

wire logic clk_int_p ;

wire logic net3 ;

wire logic clk_int_n ;

wire logic dcen ;

wire logic dcenb ;

wire logic enbuf ;

wire logic enfbb ;

wire logic enb ;

wire logic enfb ;

wire logic odt_dcb ;

wire logic odt_dc_int ;

wire logic net017 ;

wire logic net4 ;

wire logic serlb_enb ;

wire logic net022 ;

wire logic serlb_enbuf ;

wire logic bypass_selb ;

wire logic bypass_sel ;

// Buses in the design

wire logic [3:0]  imp_ctrl_b;

wire logic [3:0]  imp_ctrl;



WavD2DAnalogPhy_8lane_gf12lpp_XG_D1_GL16_LVT XGATE0[1:0] ( .y(pad_rxn), .vdd(vdda), .vss(vss),
     .a(clk_serlb_inn), .en(serlb_enbuf), .enb(serlb_enb));
WavD2DAnalogPhy_8lane_gf12lpp_XG_D1_GL16_LVT I0[1:0] ( .y(pad_rxp), .vdd(vdda), .vss(vss),
     .a(clk_serlb_inp), .en(serlb_enbuf), .enb(serlb_enb));
WavD2DAnalogPhy_8lane_gf12lpp_XG_D1_GL16_LVT XGATE1[1:0] ( .y(net4), .vdd(vdda), .vss(vss),
     .a(pad_rxp), .en(bypass_sel), .enb(bypass_selb));
WavD2DAnalogPhy_8lane_gf12lpp_XG_D1_GL16_LVT XGATE3[1:0] ( .y(net3), .vdd(vdda), .vss(vss),
     .a(pad_rxn), .en(bypass_sel), .enb(bypass_selb));
WavD2DAnalogPhy_8lane_gf12lpp_wav_d2d_NAND2_D1_GL16_LVT_strmodel NAND2 ( .tielo(vss), .tiehi(vdda),
     .vdd(vdda), .y(net018), .vss(vss), .b(clk_bypass_sel), .a(net4));
WavD2DAnalogPhy_8lane_gf12lpp_wav_d2d_NAND2_D1_GL16_LVT_strmodel NAND3 ( .tielo(vss), .tiehi(vdda),
     .vdd(vdda), .y(net022), .vss(vss), .b(clk_bypass_sel), .a(net3));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV13 ( .in(ser_lpb_en), .vss(vss), .out(serlb_enb),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV9 ( .in(serlb_enb), .vss(vss), .out(serlb_enbuf),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV0[1:0] ( .out(clk_bypass_p_in), .vdd(vdda),
     .vss(vss), .in(net018));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV5 ( .vdd(vdda), .in(odt_dc), .vss(vss),
     .out(odt_dcb));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV19[3:0] ( .out(imp_ctrl_b[3:0]), .vdd(vdda),
     .vss(vss), .in(odt_ctrl[3:0]));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV4[3:0] ( .out(imp_ctrl[3:0]), .vdd(vdda), .vss(vss),
     .in(imp_ctrl_b[3:0]));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV3 ( .in(odt_dcb), .vss(vss), .out(odt_dc_int),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV6[1:0] ( .out(clk_bypass_n_in), .vdd(vdda),
     .vss(vss), .in(net022));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV18 ( .in(bypass_selb), .vss(vss), .out(bypass_sel),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV15 ( .in(clk_bypass_sel), .vss(vss),
     .out(bypass_selb), .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV7 ( .vdd(vdda), .in(en), .vss(vss), .out(enb));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV8 ( .vdd(vdda), .in(enb), .vss(vss), .out(enbuf));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV16 ( .vdd(vdda), .in(enfbb), .vss(vss), .out(enfb));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV17 ( .vdd(vdda), .in(ac_mode), .vss(vss),
     .out(net017));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV11 ( .vdd(vdda), .in(dcenb), .vss(vss), .out(dcen));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV2[3:0] ( .out(clkp), .vdd(vdda), .vss(vss),
     .in(clk_int_n));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV1[3:0] ( .out(clkn), .vdd(vdda), .vss(vss),
     .in(clk_int_p));
WavD2DAnalogPhy_8lane_gf12lpp_hbm_d2d ESDN ( .vdd(vdda), .vss(vss), .pad(pad_rxn));
WavD2DAnalogPhy_8lane_gf12lpp_hbm_d2d ESDP ( .vdd(vdda), .vss(vss), .pad(pad_rxp));
WavD2DAnalogPhy_8lane_gf12lpp_NAND2_D1_GL16_LVT NAND0 ( .tielo(vss), .tiehi(vdda), .vdd(vdda),
     .y(dcenb), .vss(vss), .b(net017), .a(en));
WavD2DAnalogPhy_8lane_gf12lpp_NAND2_D1_GL16_LVT NAND1 ( .tielo(vss), .tiehi(vdda), .vdd(vdda),
     .y(enfbb), .vss(vss), .b(en_fb), .a(en));
WavD2DAnalogPhy_8lane_gf12lpp_d2d_rx_term_res IRESN ( .odt_dc(odt_dc_int), .pad(pad_rxn),
     .odt_ctrl(imp_ctrl[3:0]), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_d2d_rx_term_res IRESP ( .odt_dc(odt_dc_int), .pad(pad_rxp),
     .odt_ctrl(imp_ctrl[3:0]), .vss(vss));
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUM_D1_GL16_LVT DUM0[47:0] ( .vdd(vdda), .vss(vss), .tiehi(vdda),
     .tielo(vss));*/
WavD2DAnalogPhy_8lane_gf12lpp_d2d_clk_rcvr_acdcpath CLKRCVR ( .ena(enbuf), .clk_outn(clk_int_n),
     .clk_outp(clk_int_p), .pad_clk_rxp(pad_rxp),
     .pad_clk_rxn(pad_rxn), .vdda(vdda), .vss(vss), .dcen(dcen),
     .dcenb(dcenb), .enb(enb), .enfb(enfb), .enfbb(enfbb));
WavD2DAnalogPhy_8lane_gf12lpp_d2d_rx_term_dum DUM1[1:0] ( .vss(vss));

endmodule
// Library - wavshared_gf12lp_dig_lib, Cell -
//PD_D1_bal_GL16_LVT_nomodel, View - schematic
// LAST TIME SAVED: Oct  7 12:25:41 2021
// NETLIST TIME: Oct  7 15:28:48 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_PD_D1_bal_GL16_LVT_nomodel ( 
inout   vss, 
input   enb, 
input   y );




/*REMOVED VIA SCRIPT -- lvtnfet_b  M0 ( .b(vss), .s(vss), .g(enb), .d(y));*/

endmodule
// Library - wphy_gf12lp_ips_lib, Cell - iqgen_core_direct_v2, View -
//schematic
// LAST TIME SAVED: Jul 23 15:02:22 2021
// NETLIST TIME: Oct  7 15:28:48 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_iqgen_core_direct_v2 ( 
output   clk_o, 
output   clk_ob, 
inout wire logic   vdda, 
inout wire logic   vss, 
input   clk_i, 
input   clk_ib, 
input wire logic   en, 
input wire logic   enb );


wire logic net3 ;

wire net052 ;

wire net051 ;

wire net4 ;

wire net2 ;

wire logic net1 ;



WavD2DAnalogPhy_8lane_gf12lpp_PU_D1_GL16_LVT PU0[1:0] ( .vdd(vdda), .en(en), .y(net1));
WavD2DAnalogPhy_8lane_gf12lpp_PD_D1_bal_GL16_LVT PD0[1:0] ( .vss(vss), .enb(enb), .y(net3));
WavD2DAnalogPhy_8lane_gf12lpp_INV_DIFF_D2_GL16_LVT_BAL INV4 ( .out1b(net052), .out2b(net2),
     .in2(net051), .in1(net4), .vdd(vdda), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_INV_DIFF_D2_GL16_LVT_BAL INV2[1:0] ( .out1b(clk_o), .out2b(clk_ob),
     .vdd(vdda), .vss(vss), .in1(net052), .in2(net2));
WavD2DAnalogPhy_8lane_gf12lpp_INV_DIFF_D2_GL16_LVT_BAL INV3 ( .out1b(net4), .out2b(net051),
     .in2(net3), .in1(net1), .vdd(vdda), .vss(vss));
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_PUDUM_D1_GL16_LVT PUdum1[5:0] ( .vdd(vdda), .tiehi(enb));*/
/*REMOVED VIA SCRIPT -- PDDUM_D1_bal_GL16_LVT PDdum1[5:0] ( .vss(vss), .tielo(en));*/
WavD2DAnalogPhy_8lane_gf12lpp_INVT_DIFF_D2_GL16_LVT_BAL INV8[1:0] ( .out1b(net1), .out2b(net3),
     .vdd(vdda), .vss(vss), .en(en), .enb(enb), .in1(clk_i),
     .in2(clk_ib));

endmodule
// Library - wphy_gf12lp_ips_lib, Cell - iqgen_core_v2, View -
//schematic
// LAST TIME SAVED: Jul 28 14:19:53 2021
// NETLIST TIME: Oct  7 15:28:48 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_iqgen_core_v2 ( 
output   clk0, 
output wire logic   clk90, 
output   clk180, 
output wire logic   clk270, 
inout wire logic   vdda, 
inout wire logic   vss, 
input   dirinn, 
input   dirinp, 
input wire logic  [5:0] dly_ctrl, 
input wire logic   ena, 
input wire logic  [1:0] gear, 
input wire logic   inn, 
input wire logic   inp );


wire logic en ;

wire logic enb ;

wire logic clk_x1 ;

wire logic clk_x1b ;

// Buses in the design

wire logic [1:0]  gear_int;

wire logic [1:0]  gearb;



WavD2DAnalogPhy_8lane_gf12lpp_INV_D4_GL16_LVT INV1[1:0] ( .out(gear_int[1:0]), .vdd(vdda), .vss(vss),
     .in(gearb[1:0]));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D4_GL16_LVT INV3 ( .in(enb), .vss(vss), .out(en), .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D4_GL16_LVT INV2 ( .in(ena), .vss(vss), .out(enb), .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D4_GL16_LVT INV0[1:0] ( .out(gearb[1:0]), .vdd(vdda), .vss(vss),
     .in(gear[1:0]));
WavD2DAnalogPhy_8lane_gf12lpp_iqgen_pdly_v2 DLY2 ( .ctrl(dly_ctrl[5:0]), .vdda(vdda), .vss(vss),
     .clk_o(clk90), .clk_ob(clk270), .clk_i(clk_x1), .clk_ib(clk_x1b),
     .ena(en), .enb(enb), .gear(gear_int[1:0]), .gearb(gearb[1:0]));
WavD2DAnalogPhy_8lane_gf12lpp_iqgen_pdly_v2 DLY1 ( .ctrl(dly_ctrl[5:0]), .vdda(vdda), .vss(vss),
     .clk_o(clk_x1), .clk_ob(clk_x1b), .clk_i(inp), .clk_ib(inn),
     .ena(en), .enb(enb), .gear(gear_int[1:0]), .gearb(gearb[1:0]));
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUM_D1_GL16_LVT DUMcmos[39:0] ( .vdd(vdda), .vss(vss), .tiehi(vdda),
     .tielo(vss));*/
WavD2DAnalogPhy_8lane_gf12lpp_iqgen_core_direct_v2 DIRECT ( .clk_o(clk0), .en(en), .enb(enb),
     .clk_i(dirinp), .clk_ob(clk180), .clk_ib(dirinn), .vss(vss),
     .vdda(vdda));

endmodule
// Library - wavshared_gf12lp_dig_lib, Cell - INV_DIFF_D2_GL16_LVT,
//View - schematic
// LAST TIME SAVED: Nov 10 11:34:26 2020
// NETLIST TIME: Oct  7 15:28:48 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_INV_DIFF_D2_GL16_LVT ( 
output wire logic   out1b, 
output wire logic   out2b, 
inout wire logic   vdd, 
inout wire logic   vss, 
input wire logic   in1, 
input wire logic   in2 );




WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV1 ( .in(in2), .vss(vss), .out(out2b), .vdd(vdd));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV0 ( .in(in1), .vss(vss), .out(out1b), .vdd(vdd));

endmodule
// Library - wphy_gf12lp_ips_lib, Cell - iqgen_capswitch_dummy_v2, View
//- schematic
// LAST TIME SAVED: Jul 28 12:03:11 2021
// NETLIST TIME: Oct  7 15:28:48 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_iqgen_capswitch_dummy_v2 ( 
inout   vss );




/*REMOVED VIA SCRIPT -- lvtnfet_b  M2 ( .b(vss), .s(vss), .g(vss), .d(vss));*/

endmodule
// Library - wphy_gf12lp_ips_lib, Cell - iqgen_14g_v2, View - schematic
// LAST TIME SAVED: Oct  7 12:27:47 2021
// NETLIST TIME: Oct  7 15:28:48 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_iqgen_14g_v2 ( 
output wire logic   cal_dat, 
output wire logic   clk0, 
output wire logic   clk90, 
output wire logic   clk180, 
output wire logic   clk270, 
inout wire logic   vdda, 
inout wire logic   vss, 
input wire logic   cal_en, 
input wire logic   clk_i, 
input wire logic   clk_ib, 
input wire logic  [5:0] dly_ctrl, 
input wire logic   ena, 
input wire logic  [1:0] gear );


wire logic clk0x ;

wire logic clk180x ;

wire logic cal_clk0b ;

wire logic cal_clk180b ;

wire logic clk270x ;

wire logic clk90x ;

wire logic prstb ;

wire logic prst ;

wire q1 ;



/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUM_D1_GL16_LVT Icmosdum[62:0] ( .vdd(vdda), .vss(vss), .tiehi(vdda),
     .tielo(vss));*/
WavD2DAnalogPhy_8lane_gf12lpp_FFSET_D1_GL16_LVT FF0 ( .prst(prst), .prstb(prstb), .tiehi(vdda),
     .tielo(vss), .vss(vss), .vdd(vdda), .d(clk270x), .clkb(cal_clk0b),
     .clk(cal_clk180b), .q(q1));
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_PUDUM_D1_GL16_LVT PUdum2[11:0] ( .vdd(vdda), .tiehi(vdda));*/
WavD2DAnalogPhy_8lane_gf12lpp_INV_D1_GL16_LVT I17 ( .tielo(vss), .tiehi(vdda), .in(prst), .vss(vss),
     .out(prstb), .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D1_GL16_LVT I16 ( .tielo(vss), .tiehi(vdda), .in(cal_en),
     .vss(vss), .out(prst), .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_PD_D1_bal_GL16_LVT_nomodel PDdum4[11:0] ( .vss(vss), .enb(vss),
     .y(vss));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV8 ( .in(q1), .vss(vss), .out(cal_dat), .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_iqgen_core_v2 IDLL_CAL ( .gear(gear[1:0]), .dly_ctrl(dly_ctrl[5:0]),
     .ena(cal_en), .dirinn(clk180), .dirinp(clk0), .clk270(clk270x),
     .clk180(clk180x), .clk0(clk0x), .clk90(clk90x), .inp(clk90),
     .inn(clk270), .vss(vss), .vdda(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_iqgen_core_v2 IDLL_MAIN ( .gear(gear[1:0]), .dly_ctrl(dly_ctrl[5:0]),
     .ena(ena), .dirinn(clk_ib), .dirinp(clk_i), .clk270(clk270),
     .clk180(clk180), .clk0(clk0), .clk90(clk90), .inp(clk_i),
     .inn(clk_ib), .vss(vss), .vdda(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_DIFF_D2_GL16_LVT INV9[1:0] ( .out1b(cal_clk0b),
     .out2b(cal_clk180b), .vdd(vdda), .vss(vss), .in1(clk0x),
     .in2(clk180x));
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUMLOAD_D1_GL16_LVT IDUMLOAD0[3:0] ( .vdd(vdda), .vss(vss),
     .inn(clk180), .inp(clk180));*/
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUMLOAD_D1_GL16_LVT IDUMLOAD1[3:0] ( .vdd(vdda), .vss(vss), .inn(clk0),
     .inp(clk0));*/
WavD2DAnalogPhy_8lane_gf12lpp_iqgen_capswitch_dummy_v2 DUM0[7:0] ( .vss(vss));

endmodule
// Library - wphy_gf12lp_ips_lib, Cell - wphy_pi_logic, View -
//schematic
// LAST TIME SAVED: Dec 10 18:30:29 2020
// NETLIST TIME: Oct  7 15:28:48 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_wphy_pi_logic ( 
output wire logic   en_int, 
output wire logic   enb_int, 
output wire logic  [3:0] gear_out, 
output wire logic  [3:0] gear_outb, 
output wire logic  [15:0] sel0, 
output wire logic  [15:0] sel0b, 
output wire logic  [15:0] sel90, 
output wire logic  [15:0] sel90b, 
output wire logic  [15:0] sel180, 
output wire logic  [15:0] sel180b, 
output wire logic  [15:0] sel270, 
output wire logic  [15:0] sel270b, 
output wire logic  [3:0] xcpl, 
output wire logic  [3:0] xcplb, 
inout wire logic   vdda, 
inout wire logic   vss, 
input wire logic  [15:0] code, 
input wire logic   en, 
input wire logic  [3:0] gear, 
input wire logic  [1:0] quad, 
input wire logic  [3:0] xcpl_in );


// Buses in the design

wire logic [1:0]  quadb;

wire logic [1:0]  quada;



WavD2DAnalogPhy_8lane_gf12lpp_NAND2_D1_GL16_LVT NAND2[1:0] ( .y(quadb[1:0]), .vdd(vdda), .vss(vss),
     .a(quad[1:0]), .b(en), .tiehi(vdda), .tielo(vss));
WavD2DAnalogPhy_8lane_gf12lpp_NAND2_D1_GL16_LVT NAND1[3:0] ( .y(gear_outb[3:0]), .vdd(vdda),
     .vss(vss), .a(gear[3:0]), .b(en), .tiehi(vdda), .tielo(vss));
WavD2DAnalogPhy_8lane_gf12lpp_NOR2_D1_GL16_RVT NOR0[15:0] ( .y(sel90[15:0]), .vdd(vdda), .vss(vss),
     .a(quada[0]), .b(code[15:0]), .tiehi(vdda), .tielo(vss));
WavD2DAnalogPhy_8lane_gf12lpp_NOR2_D1_GL16_RVT NOR1[15:0] ( .y(sel270[15:0]), .vdd(vdda), .vss(vss),
     .a(quadb[0]), .b(code[15:0]), .tiehi(vdda), .tielo(vss));
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUM_D1_GL16_LVT DUM0[1:0] ( .vdd(vdda), .vss(vss), .tiehi(vdda),
     .tielo(vss));*/
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_RVT INV4[15:0] ( .out(sel0[15:0]), .vdd(vdda), .vss(vss),
     .in(sel0b[15:0]));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_RVT INV5[15:0] ( .out(sel90b[15:0]), .vdd(vdda), .vss(vss),
     .in(sel90[15:0]));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_RVT INV8[3:0] ( .out(xcpl[3:0]), .vdd(vdda), .vss(vss),
     .in(xcplb[3:0]));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_RVT INV6[15:0] ( .out(sel180[15:0]), .vdd(vdda), .vss(vss),
     .in(sel180b[15:0]));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_RVT INV7[15:0] ( .out(sel270b[15:0]), .vdd(vdda),
     .vss(vss), .in(sel270[15:0]));
WavD2DAnalogPhy_8lane_gf12lpp_NAND2_D1_GL16_RVT NAND7[3:0] ( .y(xcplb[3:0]), .vdd(vdda), .vss(vss),
     .a(xcpl_in[3:0]), .b(en), .tiehi(vdda), .tielo(vss));
WavD2DAnalogPhy_8lane_gf12lpp_NAND2_D1_GL16_RVT NAND0[15:0] ( .y(sel0b[15:0]), .vdd(vdda), .vss(vss),
     .a(quadb[1]), .b(code[15:0]), .tiehi(vdda), .tielo(vss));
WavD2DAnalogPhy_8lane_gf12lpp_NAND2_D1_GL16_RVT NAND5[15:0] ( .y(sel180b[15:0]), .vdd(vdda),
     .vss(vss), .a(quada[1]), .b(code[15:0]), .tiehi(vdda),
     .tielo(vss));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV3 ( .in(enb_int), .vss(vss), .out(en_int),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV1[1:0] ( .out(quada[1:0]), .vdd(vdda), .vss(vss),
     .in(quadb[1:0]));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV10[3:0] ( .out(gear_out[3:0]), .vdd(vdda),
     .vss(vss), .in(gear_outb[3:0]));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV2 ( .in(en), .vss(vss), .out(enb_int), .vdd(vdda));
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUM_D1_GL16_RVT DUM1[11:0] ( .vdd(vdda), .vss(vss), .tiehi(vdda),
     .tielo(vss));*/

endmodule
// Library - wphy_gf12lp_ips_lib, Cell - wphy_pi_14g_outdrv, View -
//schematic
// LAST TIME SAVED: Dec 15 08:12:19 2020
// NETLIST TIME: Oct  7 15:28:48 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_wphy_pi_14g_outdrv ( 
output wire logic   outn, 
output wire logic   outp, 
inout wire logic   vdda, 
inout wire logic   vss, 
input wire logic   inn, 
input wire logic   inp );

supply0 gnd_;

wire logic n1 ;

wire logic p1 ;

wire logic net013 ;

wire logic net014 ;



/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUM_D1_GL16_LVT CmosDum[3:0] ( .vdd(vdda), .vss(vss), .tiehi(vdda),
     .tielo(vss));*/
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV0[1:0] ( .out(net014), .vdd(vdda), .vss(vss),
     .in(n1));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV2[1:0] ( .out(net013), .vdd(vdda), .vss(vss),
     .in(p1));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV6[3:0] ( .out(outp), .vdd(vdda), .vss(vss),
     .in(net013));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV3[1:0] ( .out(p1), .vdd(vdda), .vss(vss), .in(inn));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV1[1:0] ( .out(n1), .vdd(vdda), .vss(vss), .in(inp));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV7[3:0] ( .out(outn), .vdd(vdda), .vss(vss),
     .in(net014));
/*REMOVED VIA SCRIPT -- pcapacitor  C3 ( .MINUS(gnd_), .PLUS(n1));*/
/*REMOVED VIA SCRIPT -- pcapacitor  C2 ( .MINUS(gnd_), .PLUS(p1));*/
WavD2DAnalogPhy_8lane_gf12lpp_INV_D1_GL16_LVT_Mmod_nomodel INV5 ( .tiehi(vdda), .tielo(vss),
     .in(net014), .vss(vss), .out(net013), .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D1_GL16_LVT_Mmod_nomodel INV4 ( .tiehi(vdda), .tielo(vss),
     .in(net013), .vss(vss), .out(net014), .vdd(vdda));

endmodule
// Library - wphy_gf12lp_ips_lib, Cell - wphy_pi_14g_predrv, View -
//schematic
// LAST TIME SAVED: Sep 18 06:50:39 2020
// NETLIST TIME: Oct  7 15:28:48 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_wphy_pi_14g_predrv ( 
output wire logic   outn, 
output wire logic   outp, 
inout wire logic   vdda, 
inout wire logic   vss, 
input wire logic   en, 
input wire logic   enb, 
input  [3:0] gear, 
input  [3:0] gearb, 
input   inn, 
input   inp );




WavD2DAnalogPhy_8lane_gf12lpp_PD_D1_GL16_LVT PDDUM1 ( .vss(vss), .enb(vss), .y(outn));
WavD2DAnalogPhy_8lane_gf12lpp_PD_D1_GL16_LVT PD0 ( .vss(vss), .enb(enb), .y(outp));
WavD2DAnalogPhy_8lane_gf12lpp_PU_D1_GL16_LVT PUDUM1 ( .vdd(vdda), .en(vdda), .y(outp));
WavD2DAnalogPhy_8lane_gf12lpp_PU_D1_GL16_LVT PU0 ( .vdd(vdda), .en(en), .y(outn));
WavD2DAnalogPhy_8lane_gf12lpp_wphy_pi_14g_inve INV7 ( .en(gear[0]), .enb(gearb[0]), .in(inp),
     .vss(vss), .out(outn), .vdda(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_wphy_pi_14g_inve INV6[1:0] ( .out(outn), .vdda(vdda), .vss(vss),
     .en(gear[1]), .enb(gearb[1]), .in(inp));
WavD2DAnalogPhy_8lane_gf12lpp_wphy_pi_14g_inve INV5[7:0] ( .out(outn), .vdda(vdda), .vss(vss),
     .en(gear[3]), .enb(gearb[3]), .in(inp));
WavD2DAnalogPhy_8lane_gf12lpp_wphy_pi_14g_inve INV3[7:0] ( .out(outp), .vdda(vdda), .vss(vss),
     .en(gear[3]), .enb(gearb[3]), .in(inn));
WavD2DAnalogPhy_8lane_gf12lpp_wphy_pi_14g_inve INV1[1:0] ( .out(outp), .vdda(vdda), .vss(vss),
     .en(gear[1]), .enb(gearb[1]), .in(inn));
WavD2DAnalogPhy_8lane_gf12lpp_wphy_pi_14g_inve INV0 ( .en(gear[0]), .enb(gearb[0]), .in(inn),
     .vss(vss), .out(outp), .vdda(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_wphy_pi_14g_inve INV2[3:0] ( .out(outp), .vdda(vdda), .vss(vss),
     .en(gear[2]), .enb(gearb[2]), .in(inn));
WavD2DAnalogPhy_8lane_gf12lpp_wphy_pi_14g_inve INV4[3:0] ( .out(outn), .vdda(vdda), .vss(vss),
     .en(gear[2]), .enb(gearb[2]), .in(inp));

endmodule
// Library - wphy_gf12lp_ips_lib, Cell - wphy_pi_14g, View - schematic
// LAST TIME SAVED: Jul  8 06:03:03 2021
// NETLIST TIME: Oct  7 15:28:48 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_wphy_pi_14g ( 
output wire logic   out, 
output wire logic   outb, 
inout wire logic   vdda, 
inout wire logic   vss, 
input   clk0, 
input   clk90, 
input   clk180, 
input   clk270, 
input wire logic  [15:0] code, 
input wire logic   ena, 
input wire logic  [3:0] gear, 
input wire logic  [1:0] quad, 
input wire logic  [3:0] xcpl );


wire logic mix_outn ;

wire mix_outp ;

wire logic preclk0 ;

wire logic preclk270 ;

wire logic en_int ;

wire logic preclk180 ;

wire logic enb_int ;

wire logic preclk90 ;

// Buses in the design

wire logic [15:0]  sel90b;

wire logic [15:0]  sel90;

wire logic [15:0]  sel270b;

wire logic [15:0]  sel180;

wire logic [15:0]  sel180b;

wire logic [3:0]  xcpl_int;

wire logic [15:0]  sel270;

wire logic [15:0]  sel0b;

wire logic [3:0]  gear_int;

wire logic [3:0]  xcplb_int;

wire logic [3:0]  gear_intb;

wire logic [15:0]  sel0;



WavD2DAnalogPhy_8lane_gf12lpp_wphy_pi_logic Ipi_logic ( .gear_out(gear_int[3:0]),
     .gear_outb(gear_intb[3:0]), .enb_int(enb_int), .en_int(en_int),
     .en(ena), .xcpl_in(xcpl[3:0]), .gear(gear[3:0]), .vss(vss),
     .xcplb(xcplb_int[3:0]), .xcpl(xcpl_int[3:0]),
     .sel270b(sel270b[15:0]), .sel270(sel270[15:0]),
     .sel180b(sel180b[15:0]), .sel180(sel180[15:0]),
     .sel90b(sel90b[15:0]), .sel90(sel90[15:0]), .sel0b(sel0b[15:0]),
     .sel0(sel0[15:0]), .vdda(vdda), .quad(quad[1:0]),
     .code(code[15:0]));
WavD2DAnalogPhy_8lane_gf12lpp_wphy_pi_14g_outdrv Ioutdrv ( .vss(vss), .outp(out), .outn(outb),
     .inp(mix_outp), .inn(mix_outn), .vdda(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_wphy_pi_14g_core core ( .vdda(vdda), .vss(vss), .outn(mix_outn),
     .outp(mix_outp), .clk0(preclk0), .clk90(preclk90),
     .clk180(preclk180), .clk270(preclk270), .sel0(sel0[15:0]),
     .sel0b(sel0b[15:0]), .sel90(sel90[15:0]), .sel90b(sel90b[15:0]),
     .sel180(sel180[15:0]), .sel180b(sel180b[15:0]),
     .sel270(sel270[15:0]), .sel270b(sel270b[15:0]),
     .xcpl(xcpl_int[3:0]), .xcplb(xcplb_int[3:0]));
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUM_D1_GL16_LVT CmosDum[15:0] ( .vdd(vdda), .vss(vss), .tiehi(vdda),
     .tielo(vss));*/
/*REMOVED VIA SCRIPT -- pcapacitor  C5 ( .MINUS(vss), .PLUS(mix_outp));*/
/*REMOVED VIA SCRIPT -- pcapacitor  C4 ( .MINUS(vss), .PLUS(mix_outn));*/
/*REMOVED VIA SCRIPT -- pcapacitor  C3 ( .MINUS(vss), .PLUS(preclk270));*/
/*REMOVED VIA SCRIPT -- pcapacitor  C2 ( .MINUS(vss), .PLUS(preclk90));*/
/*REMOVED VIA SCRIPT -- pcapacitor  C1 ( .MINUS(vss), .PLUS(preclk0));*/
/*REMOVED VIA SCRIPT -- pcapacitor  C0 ( .MINUS(vss), .PLUS(preclk180));*/
WavD2DAnalogPhy_8lane_gf12lpp_wphy_pi_14g_predrv predrvQ ( .vdda(vdda), .en(en_int), .enb(enb_int),
     .gearb(gear_intb[3:0]), .vss(vss), .inp(clk90), .inn(clk270),
     .outp(preclk90), .outn(preclk270), .gear(gear_int[3:0]));
WavD2DAnalogPhy_8lane_gf12lpp_wphy_pi_14g_predrv predrvI ( .vdda(vdda), .en(en_int), .enb(enb_int),
     .gearb(gear_intb[3:0]), .vss(vss), .inp(clk0), .inn(clk180),
     .outp(preclk0), .outn(preclk180), .gear(gear_int[3:0]));

endmodule
// Library - wphy_gf12lp_d2d_serdes_lib, Cell - wav_d2d_clk_pi_top,
//View - schematic
// LAST TIME SAVED: Aug 31 07:24:21 2021
// NETLIST TIME: Oct  7 15:28:48 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_wav_d2d_clk_pi_top ( 
output wire logic   clk0b, 
output wire logic   clk90b, 
output wire logic   clk180b, 
output wire logic   clk270b, 
output wire logic   rx_clki, 
output wire logic   rx_clkib, 
output wire logic   rx_clkq, 
output wire logic   rx_clkqb, 
inout wire logic   vdda, 
inout wire logic   vss, 
input wire logic  [3:0] pi_gear, 
input wire logic  [3:0] pi_xcpl, 
input wire logic   pll_clk0, 
input wire logic   pll_clk90, 
input wire logic   pll_clk180, 
input wire logic   pll_clk270, 
input wire logic  [15:0] rx_i_pi_code, 
input wire logic   rx_i_pi_en, 
input wire logic  [1:0] rx_i_pi_quad, 
input wire logic  [15:0] rx_q_pi_code, 
input wire logic   rx_q_pi_en, 
input wire logic  [1:0] rx_q_pi_quad );


wire logic clk0_int_rx_i ;

wire logic clk0_int_rx_q ;

wire logic clk90_int_rx_i ;

wire logic clk180_int_rx_i ;

wire logic clk180_int_rx_q ;

wire logic clk90_int_rx_q ;

wire logic clk270_int_rx_q ;

wire logic clk270_int_rx_i ;



/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUM_D1_GL16_LVT Ilvt_cmos_dum[3:0] ( .vdd(vdda), .vss(vss),
     .tiehi(vdda), .tielo(vss));*/
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV15[3:0] ( .out(clk270_int_rx_q), .vdd(vdda),
     .vss(vss), .in(clk270b));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV14[3:0] ( .out(clk270_int_rx_i), .vdd(vdda),
     .vss(vss), .in(clk270b));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV6[3:0] ( .out(clk0_int_rx_q), .vdd(vdda), .vss(vss),
     .in(clk0b));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV28[3:0] ( .out(clk0b), .vdd(vdda), .vss(vss),
     .in(pll_clk0));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV1[3:0] ( .out(clk180b), .vdd(vdda), .vss(vss),
     .in(pll_clk180));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV2[3:0] ( .out(clk90b), .vdd(vdda), .vss(vss),
     .in(pll_clk90));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV3[3:0] ( .out(clk270b), .vdd(vdda), .vss(vss),
     .in(pll_clk270));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV8[3:0] ( .out(clk180_int_rx_i), .vdd(vdda),
     .vss(vss), .in(clk180b));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV10[3:0] ( .out(clk90_int_rx_q), .vdd(vdda),
     .vss(vss), .in(clk90b));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV5[3:0] ( .out(clk0_int_rx_i), .vdd(vdda), .vss(vss),
     .in(clk0b));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV9[3:0] ( .out(clk180_int_rx_q), .vdd(vdda),
     .vss(vss), .in(clk180b));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV11[3:0] ( .out(clk90_int_rx_i), .vdd(vdda),
     .vss(vss), .in(clk90b));
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUM_D1_GL16_RVT Irvt_cmos_dum[7:0] ( .vdd(vdda), .vss(vss),
     .tiehi(vdda), .tielo(vss));*/
WavD2DAnalogPhy_8lane_gf12lpp_wphy_pi_14g RXI_PI ( .clk0(clk0_int_rx_i), .clk180(clk180_int_rx_i),
     .outb(rx_clkib), .clk90(clk90_int_rx_i), .out(rx_clki),
     .ena(rx_i_pi_en), .clk270(clk270_int_rx_i), .vdda(vdda),
     .xcpl(pi_xcpl[3:0]), .quad(rx_i_pi_quad[1:0]),
     .gear(pi_gear[3:0]), .code(rx_i_pi_code[15:0]), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_wphy_pi_14g RXQ_PI ( .clk0(clk90_int_rx_q), .clk180(clk270_int_rx_q),
     .outb(rx_clkqb), .clk90(clk180_int_rx_q), .out(rx_clkq),
     .ena(rx_q_pi_en), .clk270(clk0_int_rx_q), .vdda(vdda),
     .xcpl(pi_xcpl[3:0]), .quad(rx_q_pi_quad[1:0]),
     .gear(pi_gear[3:0]), .code(rx_q_pi_code[15:0]), .vss(vss));

endmodule
// Library - gf12lp_rpll_lib, Cell - rpll_14g_fbdiv, View - schematic
// LAST TIME SAVED: Jan 21 18:40:42 2021
// NETLIST TIME: Oct  7 15:28:48 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_fbdiv ( 
output wire logic   clkdiv_out, 
inout wire logic   vdda, 
inout wire logic   vss, 
input wire logic   clkin, 
input wire logic  [8:0] div, 
input wire logic   reset );


wire logic load ;

wire logic outn ;

wire logic outp ;

wire logic Q3 ;

wire logic Q8 ;

wire logic Q7 ;

wire logic netb ;

wire logic clkb ;

wire logic Q6 ;

wire logic Q5 ;

wire logic clk ;

wire logic Q2 ;

wire logic Q4 ;

wire logic Q1 ;

wire logic resetb ;

wire logic reset_buf ;

wire logic net0154 ;

wire net0151 ;

wire logic net0152 ;

wire logic net0156 ;

wire logic net0136 ;

wire logic net0148 ;

wire logic net0135 ;

wire net0147 ;

wire logic net043 ;

wire logic net0118 ;

wire logic net0140 ;

wire logic net0142 ;

wire logic net0137 ;

wire logic net0124 ;

wire logic net0150 ;

wire logic net0123 ;

wire logic net0120 ;

wire logic net0149 ;

wire logic net0144 ;

wire logic net0127 ;

wire logic net0117 ;

wire logic net0121 ;

wire logic net0119 ;

wire logic net0130 ;

wire logic net0141 ;

wire logic net0146 ;

wire logic net0122 ;

wire logic net0126 ;

wire logic net0112 ;

wire logic net0138 ;

wire logic net049 ;

wire logic net0128 ;

wire logic net0139 ;

wire logic net0111 ;

wire net0155 ;

wire logic net0160 ;

wire logic net0159 ;



/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUM_D1_GL16_LVT DUM0[21:0] ( .vdd(vdda), .vss(vss), .tiehi(vdda),
     .tielo(vss));*/
WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_fbdiv_logic_unit DIV_UNIT0 ( .vdd(vdda), .T(vdda), .Q(Q1),
     .next(net0140), .clk(clk), .clkb(clkb), .load(load),
     .loadval(div[1]), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_fbdiv_logic_unit DIV_UNIT3 ( .vdd(vdda), .T(net0155), .Q(Q4),
     .next(net0150), .clk(clk), .clkb(clkb), .load(load),
     .loadval(div[4]), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_fbdiv_logic_unit DIV_UNIT4 ( .vdd(vdda), .T(net0150), .Q(Q5),
     .next(net0142), .clk(clk), .clkb(clkb), .load(load),
     .loadval(div[5]), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_fbdiv_logic_unit DIV_UNIT5 ( .vdd(vdda), .T(net0142), .Q(Q6),
     .next(net0160), .clk(clk), .clkb(clkb), .load(load),
     .loadval(div[6]), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_fbdiv_logic_unit DIV_UNIT1 ( .vdd(vdda), .T(net0140), .Q(Q2),
     .next(net0139), .clk(clk), .clkb(clkb), .load(load),
     .loadval(div[2]), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_fbdiv_logic_unit DIV_UNIT6 ( .vdd(vdda), .T(net0151), .Q(Q7),
     .next(net0141), .clk(clk), .clkb(clkb), .load(load),
     .loadval(div[7]), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_fbdiv_logic_unit DIV_UNIT7 ( .vdd(vdda), .T(net0141), .Q(Q8),
     .next(net0138), .clk(clk), .clkb(clkb), .load(load),
     .loadval(div[8]), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_fbdiv_logic_unit DIV_UNIT2 ( .vdd(vdda), .T(net0139), .Q(Q3),
     .next(net0156), .clk(clk), .clkb(clkb), .load(load),
     .loadval(div[3]), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_NAND3_D1_GL16_LVT NAND3 ( .tielo(vss), .tiehi(vdda), .vdd(vdda),
     .y(net0146), .vss(vss), .c(net0127), .b(resetb), .a(net0128));
WavD2DAnalogPhy_8lane_gf12lpp_SE2DIHS_D2_GL16_LVT SE2DIFF0 ( .tiehi(vdda), .tielo(vss), .vdd(vdda),
     .vss(vss), .outp(outp), .outn(outn), .in(clkin));
WavD2DAnalogPhy_8lane_gf12lpp_FFRES_D1_GL16_LVT FF3 ( .tiehi(vdda), .tielo(vss), .rst(reset_buf),
     .vss(vss), .vdd(vdda), .rstb(resetb), .d(net0154), .clkb(clkb),
     .clk(clk), .q(net0147));
WavD2DAnalogPhy_8lane_gf12lpp_FFRES_D1_GL16_LVT FF0 ( .tiehi(vdda), .tielo(vss), .rst(load),
     .vss(vss), .vdd(vdda), .rstb(net0159), .d(net0160), .clkb(clkb),
     .clk(clk), .q(net0151));
WavD2DAnalogPhy_8lane_gf12lpp_FFRES_D1_GL16_LVT FF1 ( .tiehi(vdda), .tielo(vss), .rst(load),
     .vss(vss), .vdd(vdda), .rstb(net0124), .d(net0156), .clkb(clkb),
     .clk(clk), .q(net0155));
WavD2DAnalogPhy_8lane_gf12lpp_NAND2_D1_GL16_LVT NAND7 ( .tielo(vss), .tiehi(vdda), .vdd(vdda),
     .y(net0122), .vss(vss), .b(net0118), .a(net0119));
WavD2DAnalogPhy_8lane_gf12lpp_NAND2_D1_GL16_LVT NAND1 ( .tielo(vss), .tiehi(vdda), .vdd(vdda),
     .y(net0123), .vss(vss), .b(net0120), .a(net0121));
WavD2DAnalogPhy_8lane_gf12lpp_NAND2_D1_GL16_LVT NAND5 ( .tielo(vss), .tiehi(vdda), .vdd(vdda),
     .y(net0127), .vss(vss), .b(net0112), .a(net043));
WavD2DAnalogPhy_8lane_gf12lpp_NAND2_D1_GL16_LVT NAND0 ( .tielo(vss), .tiehi(vdda), .vdd(vdda),
     .y(net0128), .vss(vss), .b(net0126), .a(net0111));
WavD2DAnalogPhy_8lane_gf12lpp_NAND2_D1_GL16_LVT NAND2 ( .tielo(vss), .tiehi(vdda), .vdd(vdda),
     .y(net0137), .vss(vss), .b(load), .a(net0135));
WavD2DAnalogPhy_8lane_gf12lpp_NAND2_D1_GL16_LVT NAND4 ( .tielo(vss), .tiehi(vdda), .vdd(vdda),
     .y(net0154), .vss(vss), .b(net0136), .a(net0137));
WavD2DAnalogPhy_8lane_gf12lpp_NAND2_D1_GL16_LVT NAND6 ( .tielo(vss), .tiehi(vdda), .vdd(vdda),
     .y(net0136), .vss(vss), .b(netb), .a(clkdiv_out));
WavD2DAnalogPhy_8lane_gf12lpp_NAND2_D1_GL16_LVT NAND8 ( .tielo(vss), .tiehi(vdda), .vdd(vdda),
     .y(net0144), .vss(vss), .b(net0130), .a(clkdiv_out));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF6 ( .tiehi(vdda), .tielo(vss), .vss(vss), .vdd(vdda),
     .d(div[0]), .clkb(net0148), .clk(clkdiv_out), .q(net0130));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF5 ( .tiehi(vdda), .tielo(vss), .vss(vss), .vdd(vdda),
     .d(net0111), .clkb(clkb), .clk(clk), .q(net043));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF2 ( .tiehi(vdda), .tielo(vss), .vss(vss), .vdd(vdda),
     .d(net0146), .clkb(clkb), .clk(clk), .q(net049));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF4 ( .tiehi(vdda), .tielo(vss), .vss(vss), .vdd(vdda),
     .d(net0152), .clkb(clkb), .clk(clk), .q(net0111));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV32 ( .in(load), .vss(vss), .out(net0159),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV0 ( .in(load), .vss(vss), .out(net0124),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV10 ( .in(Q1), .vss(vss), .out(net0117), .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV8 ( .in(Q2), .vss(vss), .out(net0149), .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV12[6:0] ( .out(clk), .vdd(vdda), .vss(vss),
     .in(outn));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV2 ( .in(reset), .vss(vss), .out(resetb),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV15 ( .in(clkdiv_out), .vss(vss), .out(net0148),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV14 ( .in(net0144), .vss(vss), .out(net0112),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV6 ( .in(net0147), .vss(vss), .out(net0135),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV5[4:0] ( .out(load), .vdd(vdda), .vss(vss),
     .in(netb));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV7[3:0] ( .out(clkdiv_out), .vdd(vdda), .vss(vss),
     .in(net0135));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV9 ( .in(net0112), .vss(vss), .out(net0126),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV4[1:0] ( .out(netb), .vdd(vdda), .vss(vss),
     .in(net049));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV3 ( .in(resetb), .vss(vss), .out(reset_buf),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV33[6:0] ( .out(clkb), .vdd(vdda), .vss(vss),
     .in(outp));
WavD2DAnalogPhy_8lane_gf12lpp_NOR2_D1_GL16_LVT NOR10 ( .tielo(vss), .tiehi(vdda), .y(net0152),
     .vss(vss), .vdd(vdda), .b(net0122), .a(net0123));
WavD2DAnalogPhy_8lane_gf12lpp_NOR2_D1_GL16_LVT NOR3 ( .tielo(vss), .tiehi(vdda), .y(net0119),
     .vss(vss), .vdd(vdda), .b(Q3), .a(Q4));
WavD2DAnalogPhy_8lane_gf12lpp_NOR2_D1_GL16_LVT NOR4 ( .tielo(vss), .tiehi(vdda), .y(net0118),
     .vss(vss), .vdd(vdda), .b(net0117), .a(net0149));
WavD2DAnalogPhy_8lane_gf12lpp_NOR2_D1_GL16_LVT NOR0 ( .tielo(vss), .tiehi(vdda), .y(net0121),
     .vss(vss), .vdd(vdda), .b(Q7), .a(Q8));
WavD2DAnalogPhy_8lane_gf12lpp_NOR2_D1_GL16_LVT NOR1 ( .tielo(vss), .tiehi(vdda), .y(net0120),
     .vss(vss), .vdd(vdda), .b(Q5), .a(Q6));

endmodule
// Library - wphy_gf12lp_d2d_serdes_lib, Cell - d2d_dtest, View -
//schematic
// LAST TIME SAVED: Sep  9 04:45:43 2021
// NETLIST TIME: Oct  7 15:28:48 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_d2d_dtest ( 
output wire logic   dtest, 
inout wire logic   vdda, 
inout wire logic   vss, 
input wire logic  [3:0] dtst_div, 
input wire logic   dtst_en, 
input wire logic  [2:0] dtst_sel, 
input wire logic  [7:0] in );


wire logic net2 ;

wire logic dtst_ena ;

wire logic net6 ;

wire logic net3 ;

wire logic dtst_enb ;

wire logic net1 ;

wire logic net20 ;



WavD2DAnalogPhy_8lane_gf12lpp_rpll_14g_fbdiv I0 ( .clkdiv_out(dtest), .div({vss, dtst_div[3:0], vss,
     vss, vss, vss}), .reset(dtst_enb), .clkin(net1), .vdda(vdda),
     .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_NAND2_D1_GL16_LVT NAND0 ( .tielo(vss), .vdd(vdda), .y(net3), .vss(vss),
     .tiehi(vdda), .b(dtst_ena), .a(net6));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF0 ( .tielo(vss), .vss(vss), .vdd(vdda), .tiehi(vdda),
     .d(net3), .clkb(net20), .clk(net2), .q(net6));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV2[1:0] ( .out(net1), .vdd(vdda), .vss(vss),
     .in(net6));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV1 ( .in(dtst_enb), .vss(vss), .out(dtst_ena),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV0 ( .in(dtst_en), .vss(vss), .out(dtst_enb),
     .vdd(vdda));
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUM_D1_GL16_LVT DUMcmoslvt[128:0] ( .vdd(vdda), .vss(vss),
     .tiehi(vdda), .tielo(vss));*/
WavD2DAnalogPhy_8lane_gf12lpp_TST_MUX_LVT DTEST_MUX ( .tielo(vss), .tiehi(vdda), .in(in[7:0]),
     .tst_out(net2), .vdd(vdda), .sel(dtst_sel[2:0]), .tst_outb(net20),
     .vss(vss));

endmodule
// Library - wphy_gf12lp_d2d_serdes_lib, Cell - wav_d2d_rx_clkgen_1dir,
//View - schematic
// LAST TIME SAVED: Sep  9 10:08:53 2021
// NETLIST TIME: Oct  7 15:28:49 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_wav_d2d_rx_clkgen_1dir ( 
output wire logic   coreclk_div16, 
output wire logic   rx_div8, 
output wire logic   rx_div16, 
output wire logic   rx_iclk, 
output wire logic   rx_iclkb, 
output wire logic   rx_qclk, 
output wire logic   rx_qclkb, 
inout wire logic   vdda, 
inout wire logic   vss, 
input wire logic   clki_in, 
input wire logic   clkib_in, 
input wire logic   clkq_in, 
input wire logic   clkqb_in, 
input wire logic   en_div2_clk, 
input wire logic   en_div16_clk, 
input wire logic   reset_sync );


wire logic net1 ;

wire logic net0177 ;

wire logic net2 ;

wire logic net3 ;

wire logic rx_div16a ;

wire logic rxclk_div2b ;

wire logic clkq1 ;

wire logic net4 ;

wire logic iclkb ;

wire logic clk_divrx_outnb ;

wire logic clk_div8b ;

wire logic ena_div2_clk ;

wire logic enb_div16_clk ;

wire logic f1 ;

wire logic rx_div8b2 ;

wire logic rx_div16b ;

wire logic cmos_syncb_int ;

wire logic a ;

wire logic f2 ;

wire logic qclkb ;

wire logic qclk ;

wire logic clki1 ;

wire logic clkib1 ;

wire logic net0179 ;

wire logic reset_sync_div2 ;

wire logic clkqb1 ;

wire logic clk_divrx_outpb ;

wire logic singlenet ;

wire logic clkqb_divrx_outnb ;

wire logic clkq_divrx_outpb ;

wire logic iclk ;

wire logic net0178 ;

wire logic net0158 ;

wire logic net0176 ;

wire logic enb_div2_clk ;

wire logic rxclk_div2 ;

wire logic ena_div16_clk ;

wire logic net5 ;

wire logic net0180 ;

wire logic rx_div8a ;



/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUM_D1_GL16_LVT I0[256:0] ( .vdd(vdda), .vss(vss), .tiehi(vdda),
     .tielo(vss));*/
WavD2DAnalogPhy_8lane_gf12lpp_INVT_D2_GL16_LVT INVT2[3:0] ( .out(rx_div16b), .vdd(vdda), .vss(vss),
     .en(ena_div16_clk), .enb(enb_div16_clk), .in(rx_div16a));
WavD2DAnalogPhy_8lane_gf12lpp_INVT_D2_GL16_LVT INVT1[3:0] ( .out(qclkb), .vdd(vdda), .vss(vss),
     .en(ena_div2_clk), .enb(enb_div2_clk), .in(clkqb_divrx_outnb));
WavD2DAnalogPhy_8lane_gf12lpp_INVT_D2_GL16_LVT INVT4[3:0] ( .out(iclk), .vdd(vdda), .vss(vss),
     .en(ena_div2_clk), .enb(enb_div2_clk), .in(clk_divrx_outpb));
WavD2DAnalogPhy_8lane_gf12lpp_INVT_D2_GL16_LVT INVT5[3:0] ( .out(iclkb), .vdd(vdda), .vss(vss),
     .en(ena_div2_clk), .enb(enb_div2_clk), .in(clk_divrx_outnb));
WavD2DAnalogPhy_8lane_gf12lpp_INVT_D2_GL16_LVT INVT0[3:0] ( .out(qclk), .vdd(vdda), .vss(vss),
     .en(ena_div2_clk), .enb(enb_div2_clk), .in(clkq_divrx_outpb));
WavD2DAnalogPhy_8lane_gf12lpp_INVT_D2_GL16_LVT INVT3[3:0] ( .out(rx_div8b2), .vdd(vdda), .vss(vss),
     .en(ena_div2_clk), .enb(enb_div2_clk), .in(rx_div8a));
WavD2DAnalogPhy_8lane_gf12lpp_NAND2_D1_GL16_LVT NAND1 ( .tielo(vss), .tiehi(vdda), .vdd(vdda), .y(a),
     .vss(vss), .b(f2), .a(cmos_syncb_int));
WavD2DAnalogPhy_8lane_gf12lpp_NOR2_D1_GL16_LVT NOR0 ( .tielo(vss), .tiehi(vdda), .y(net0176),
     .vss(vss), .vdd(vdda), .b(net0158), .a(reset_sync_div2));
WavD2DAnalogPhy_8lane_gf12lpp_NOR2_D1_GL16_LVT NOR1 ( .tielo(vss), .tiehi(vdda), .y(cmos_syncb_int),
     .vss(vss), .vdd(vdda), .b(reset_sync), .a(net0180));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT_Mmod_nomodel INV8 ( .in(qclk), .vss(vss), .out(qclkb),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT_Mmod_nomodel INV26 ( .in(iclk), .vss(vss), .out(iclkb),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT_Mmod_nomodel INV27 ( .in(iclkb), .vss(vss), .out(iclk),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT_Mmod_nomodel INV10 ( .in(qclkb), .vss(vss), .out(qclk),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF0 ( .tiehi(vdda), .tielo(vss), .vss(vss), .vdd(vdda),
     .d(net0176), .clkb(rx_div8a), .clk(clk_div8b), .q(net0158));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF2 ( .tiehi(vdda), .tielo(vss), .vss(vss), .vdd(vdda),
     .d(f1), .clkb(rxclk_div2), .clk(rxclk_div2b), .q(f2));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF5 ( .tiehi(vdda), .tielo(vss), .vss(vss), .vdd(vdda),
     .d(reset_sync_div2), .clkb(rxclk_div2), .clk(rxclk_div2b),
     .q(net0179));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF3 ( .tiehi(vdda), .tielo(vss), .vss(vss), .vdd(vdda),
     .d(reset_sync), .clkb(rxclk_div2), .clk(rxclk_div2b),
     .q(net0177));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF4 ( .tiehi(vdda), .tielo(vss), .vss(vss), .vdd(vdda),
     .d(net0177), .clkb(rxclk_div2), .clk(rxclk_div2b),
     .q(reset_sync_div2));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF6 ( .tiehi(vdda), .tielo(vss), .vss(vss), .vdd(vdda),
     .d(net0179), .clkb(rxclk_div2), .clk(rxclk_div2b), .q(net0178));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF1 ( .tiehi(vdda), .tielo(vss), .vss(vss), .vdd(vdda),
     .d(a), .clkb(rxclk_div2), .clk(rxclk_div2b), .q(f1));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF7 ( .tiehi(vdda), .tielo(vss), .vss(vss), .vdd(vdda),
     .d(net0178), .clkb(rxclk_div2), .clk(rxclk_div2b), .q(net0180));
WavD2DAnalogPhy_8lane_gf12lpp_INV_DIFF_D2_GL16_LVT INV22 ( .out1b(net4), .out2b(net5),
     .in2(clkqb_in), .in1(clkq_in), .vdd(vdda), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_INV_DIFF_D2_GL16_LVT INV17 ( .out1b(net2), .out2b(net3),
     .in2(clkib_in), .in1(clki_in), .vdd(vdda), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_INV_DIFF_D2_GL16_LVT INV30[1:0] ( .out1b(clkq1), .out2b(clkqb1),
     .vdd(vdda), .vss(vss), .in1(net4), .in2(net5));
WavD2DAnalogPhy_8lane_gf12lpp_INV_DIFF_D2_GL16_LVT INV19[1:0] ( .out1b(clki1), .out2b(clkib1),
     .vdd(vdda), .vss(vss), .in1(net2), .in2(net3));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV14[1:0] ( .out(coreclk_div16), .vdd(vdda),
     .vss(vss), .in(net1));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV5 ( .in(rx_div16a), .vss(vss), .out(net1),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV1[1:0] ( .out(enb_div2_clk), .vdd(vdda), .vss(vss),
     .in(en_div2_clk));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV18[11:0] ( .out(rx_div16), .vdd(vdda), .vss(vss),
     .in(rx_div16b));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV20[1:0] ( .out(clk_div8b), .vdd(vdda), .vss(vss),
     .in(f2));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV3 ( .in(en_div16_clk), .vss(vss),
     .out(enb_div16_clk), .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV23[3:0] ( .out(clk_divrx_outpb), .vdd(vdda),
     .vss(vss), .in(clki1));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV29[11:0] ( .out(rx_iclk), .vdd(vdda), .vss(vss),
     .in(iclkb));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV7[11:0] ( .out(rx_qclkb), .vdd(vdda), .vss(vss),
     .in(qclk));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV9[3:0] ( .out(rxclk_div2), .vdd(vdda), .vss(vss),
     .in(clk_divrx_outpb));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV11[3:0] ( .out(clkqb_divrx_outnb), .vdd(vdda),
     .vss(vss), .in(clkqb1));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV21[1:0] ( .out(rx_div8a), .vdd(vdda), .vss(vss),
     .in(clk_div8b));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV24[11:0] ( .out(rx_iclkb), .vdd(vdda), .vss(vss),
     .in(iclk));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV12[11:0] ( .out(rx_qclk), .vdd(vdda), .vss(vss),
     .in(qclkb));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV13[3:0] ( .out(rxclk_div2b), .vdd(vdda), .vss(vss),
     .in(clk_divrx_outnb));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV6[3:0] ( .out(clkq_divrx_outpb), .vdd(vdda),
     .vss(vss), .in(clkq1));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV25[11:0] ( .out(rx_div8), .vdd(vdda), .vss(vss),
     .in(rx_div8b2));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV28[3:0] ( .out(clk_divrx_outnb), .vdd(vdda),
     .vss(vss), .in(clkib1));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV15[1:0] ( .out(singlenet), .vdd(vdda), .vss(vss),
     .in(net0158));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV16[1:0] ( .out(rx_div16a), .vdd(vdda), .vss(vss),
     .in(singlenet));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV4 ( .in(enb_div16_clk), .vss(vss),
     .out(ena_div16_clk), .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV2[1:0] ( .out(ena_div2_clk), .vdd(vdda), .vss(vss),
     .in(enb_div2_clk));
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUMLOAD_D2_GL16_LVT I1[3:0] ( .vdd(vdda), .vss(vss),
     .inn(clkq_divrx_outpb), .inp(clkq_divrx_outpb));*/
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUMLOAD_D2_GL16_LVT I2[3:0] ( .vdd(vdda), .vss(vss),
     .inn(clkqb_divrx_outnb), .inp(clkqb_divrx_outnb));*/
WavD2DAnalogPhy_8lane_gf12lpp_PD_D2_GL16_LVT PD0 ( .vss(vss), .enb(enb_div2_clk), .y(qclk));
WavD2DAnalogPhy_8lane_gf12lpp_PD_D2_GL16_LVT PD2 ( .vss(vss), .enb(enb_div2_clk), .y(iclk));
WavD2DAnalogPhy_8lane_gf12lpp_PU_D2_GL16_LVT PU1 ( .vdd(vdda), .en(ena_div16_clk), .y(rx_div16b));
WavD2DAnalogPhy_8lane_gf12lpp_PU_D2_GL16_LVT PU2 ( .vdd(vdda), .en(ena_div2_clk), .y(iclkb));
WavD2DAnalogPhy_8lane_gf12lpp_PU_D2_GL16_LVT PU0 ( .vdd(vdda), .en(ena_div2_clk), .y(qclkb));
WavD2DAnalogPhy_8lane_gf12lpp_PU_D2_GL16_LVT PU3 ( .vdd(vdda), .en(ena_div2_clk), .y(rx_div8b2));
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_PUDUM_D2_GL16_LVT PUdum1 ( .vdd(vdda), .tiehi(enb_div2_clk));*/
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_PUDUM_D2_GL16_LVT PUdum2 ( .vdd(vdda), .tiehi(enb_div2_clk));*/
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_PDDUM_D2_GL16_LVT PDdum3 ( .vss(vss), .tielo(ena_div2_clk));*/
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_PDDUM_D2_GL16_LVT PDdum1 ( .vss(vss), .tielo(ena_div2_clk));*/
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_PDDUM_D2_GL16_LVT PDdum4 ( .vss(vss), .tielo(ena_div16_clk));*/
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_PDDUM_D2_GL16_LVT PDdum2 ( .vss(vss), .tielo(ena_div2_clk));*/

endmodule
// Library - wphy_gf12lp_d2d_serdes_lib, Cell - wav_d2d_clk_ana_rx,
//View - schematic
// LAST TIME SAVED: Sep 27 09:09:09 2021
// NETLIST TIME: Oct  7 15:28:49 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_wav_d2d_clk_ana_rx ( 
output wire logic   clk_rx_clk_div8, 
output wire logic   clk_rx_clk_div16, 
output wire logic   clk_rx_coreclk_div16, 
output wire logic   clk_rx_dll_cal_dat, 
output wire logic   clk_rx_dtest, 
output wire logic   clk_rx_iclk, 
output wire logic   clk_rx_iclkb, 
output wire logic   clk_rx_qclk, 
output wire logic   clk_rx_qclkb, 
output wire logic   clk_rx_rcvr_bypass_in_n, 
output wire logic   clk_rx_rcvr_bypass_in_p, 
output var real  clk_rx_vref , 
inout wire logic   pad_clkn_txrx, 
inout wire logic   pad_clkp_txrx, 
inout wire logic   vdda, 
inout wire logic   vddq, 
inout wire logic   vss, 
input wire logic   clk_rx_dll_cal_en, 
input wire logic  [5:0] clk_rx_dll_ctrl, 
input wire logic   clk_rx_dll_en, 
input wire logic  [1:0] clk_rx_dll_gear, 
input wire logic  [3:0] clk_rx_dtst_div, 
input wire logic   clk_rx_dtst_en, 
input wire logic   clk_rx_dtst_in, 
input wire logic  [2:0] clk_rx_dtst_sel, 
input wire logic   clk_rx_en_rx_div2_clk, 
input wire logic   clk_rx_en_rx_div16_clk, 
input wire logic  [15:0] clk_rx_i_pi_code, 
input wire logic   clk_rx_i_pi_en, 
input wire logic  [1:0] clk_rx_i_pi_quad, 
input wire logic  [3:0] clk_rx_pi_gear, 
input wire logic  [3:0] clk_rx_pi_xcpl, 
input wire logic  [15:0] clk_rx_q_pi_code, 
input wire logic   clk_rx_q_pi_en, 
input wire logic  [1:0] clk_rx_q_pi_quad, 
input wire logic   clk_rx_rcvr_ac_mode, 
input wire logic   clk_rx_rcvr_bypass_sel, 
input wire logic   clk_rx_rcvr_en, 
input wire logic   clk_rx_rcvr_fb_en, 
input wire logic  [3:0] clk_rx_rcvr_odt_ctrl, 
input wire logic   clk_rx_rcvr_odt_dc_mode, 
input wire logic   clk_rx_reset_sync, 
input wire logic   clk_rx_ser_lpb_en, 
input wire logic   clk_rx_serlb_inn, 
input wire logic   clk_rx_serlb_inp, 
input wire logic   clk_rx_vref_en, 
input wire logic  [5:0] clk_rx_vref_lvl );


wire logic rx_pi_iclk ;

wire logic int_clk0b ;

wire logic int_clk90b ;

wire logic int_clk0 ;

wire logic int_clk90 ;

wire logic int_clk270 ;

wire logic dll_clk90 ;

wire logic dll_clk0 ;

wire logic int_clk180_dtest ;

wire logic int_clk180b ;

wire logic rcvr_clkb ;

wire logic rcvr_clk ;

wire logic int_clk270b ;

wire logic dll_clk180 ;

wire logic int_clk180 ;

wire logic rx_pi_qclkb ;

wire logic rx_pi_qclk ;

wire logic int_clk0_dtest ;

wire logic dll_clk270 ;

wire logic rx_pi_iclkb ;

wire logic pi_clk90b ;

wire logic int_clk270_dtest ;

wire logic int_clk90_dtest ;

wire logic pi_clk270b ;

wire logic pi_clk180b ;

wire logic pi_clk0b ;



WavD2DAnalogPhy_8lane_gf12lpp_wav_d2d_clk_vref_gen VREF_GEN ( .vddq(vddq), .irefp(clk_rx_vref),
     .vdda(vdda), .irefp_lvl(clk_rx_vref_lvl[5:0]),
     .en_ref(clk_rx_vref_en), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_wav_d2d_clk_rcvr RCVR ( .clk_serlb_inn(clk_rx_serlb_inn),
     .clk_serlb_inp(clk_rx_serlb_inp), .ser_lpb_en(clk_rx_ser_lpb_en),
     .clk_bypass_n_in(clk_rx_rcvr_bypass_in_n),
     .clk_bypass_p_in(clk_rx_rcvr_bypass_in_p),
     .pad_rxn(pad_clkn_txrx), .pad_rxp(pad_clkp_txrx), .vdda(vdda),
     .clk_bypass_sel(clk_rx_rcvr_bypass_sel),
     .odt_dc(clk_rx_rcvr_odt_dc_mode), .ac_mode(clk_rx_rcvr_ac_mode),
     .en_fb(clk_rx_rcvr_fb_en), .clkp(rcvr_clk), .clkn(rcvr_clkb),
     .vss(vss), .odt_ctrl(clk_rx_rcvr_odt_ctrl[3:0]),
     .en(clk_rx_rcvr_en));
WavD2DAnalogPhy_8lane_gf12lpp_iqgen_14g_v2 I14 ( .ena(clk_rx_dll_en),
     .dly_ctrl(clk_rx_dll_ctrl[5:0]), .clk_i(rcvr_clk),
     .clk_ib(rcvr_clkb), .cal_dat(clk_rx_dll_cal_dat),
     .cal_en(clk_rx_dll_cal_en), .clk270(dll_clk270),
     .clk180(dll_clk180), .gear(clk_rx_dll_gear[1:0]), .clk0(dll_clk0),
     .clk90(dll_clk90), .vss(vss), .vdda(vdda));
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_cmos_cap C0[46:0] ( .plus(vdda), .vss(vss));*/
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV1[1:0] ( .out(int_clk90), .vdd(vdda), .vss(vss),
     .in(int_clk90b));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV0[1:0] ( .out(int_clk0), .vdd(vdda), .vss(vss),
     .in(int_clk0b));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV5[1:0] ( .out(int_clk0_dtest), .vdd(vdda),
     .vss(vss), .in(pi_clk180b));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV8 ( .in(dll_clk180), .vss(vss), .out(int_clk180b),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV2[1:0] ( .out(int_clk180), .vdd(vdda), .vss(vss),
     .in(int_clk180b));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV4[1:0] ( .out(int_clk270), .vdd(vdda), .vss(vss),
     .in(int_clk270b));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV7 ( .in(dll_clk270), .vss(vss), .out(int_clk270b),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV6[1:0] ( .out(int_clk180_dtest), .vdd(vdda),
     .vss(vss), .in(pi_clk0b));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV3[1:0] ( .out(int_clk90_dtest), .vdd(vdda),
     .vss(vss), .in(pi_clk270b));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV10 ( .in(dll_clk0), .vss(vss), .out(int_clk0b),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV9 ( .in(dll_clk90), .vss(vss), .out(int_clk90b),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV3_match[1:0] ( .out(int_clk270_dtest), .vdd(vdda),
     .vss(vss), .in(pi_clk90b));
WavD2DAnalogPhy_8lane_gf12lpp_wav_d2d_clk_pi_top IPI_TOP ( .clk270b(pi_clk270b),
     .clk180b(pi_clk180b), .clk90b(pi_clk90b), .clk0b(pi_clk0b),
     .vdda(vdda), .vss(vss), .rx_clkqb(rx_pi_qclkb),
     .rx_clkq(rx_pi_qclk), .rx_clkib(rx_pi_iclkb),
     .rx_clki(rx_pi_iclk), .rx_q_pi_quad(clk_rx_q_pi_quad[1:0]),
     .rx_q_pi_en(clk_rx_q_pi_en),
     .rx_q_pi_code(clk_rx_q_pi_code[15:0]),
     .rx_i_pi_quad(clk_rx_i_pi_quad[1:0]), .rx_i_pi_en(clk_rx_i_pi_en),
     .rx_i_pi_code(clk_rx_i_pi_code[15:0]), .pll_clk270(int_clk270),
     .pll_clk180(int_clk180), .pll_clk90(int_clk90),
     .pll_clk0(int_clk0), .pi_xcpl(clk_rx_pi_xcpl[3:0]),
     .pi_gear(clk_rx_pi_gear[3:0]));
WavD2DAnalogPhy_8lane_gf12lpp_d2d_dtest I15 ( .dtst_div(clk_rx_dtst_div[3:0]), .dtest(clk_rx_dtest),
     .in({int_clk180_dtest, int_clk270_dtest, int_clk90_dtest,
     int_clk0_dtest, rcvr_clk, vss, clk_rx_dtst_in, rcvr_clkb}),
     .dtst_sel(clk_rx_dtst_sel[2:0]), .dtst_en(clk_rx_dtst_en),
     .vdda(vdda), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_wav_d2d_rx_clkgen_1dir IRXCLK ( .coreclk_div16(clk_rx_coreclk_div16),
     .rx_iclkb(clk_rx_iclkb), .rx_div8(clk_rx_clk_div8),
     .rx_div16(clk_rx_clk_div16), .rx_qclk(clk_rx_qclk),
     .rx_iclk(clk_rx_iclk), .rx_qclkb(clk_rx_qclkb),
     .en_div16_clk(clk_rx_en_rx_div16_clk), .vdda(vdda),
     .en_div2_clk(clk_rx_en_rx_div2_clk), .clki_in(rx_pi_iclk),
     .clkib_in(rx_pi_iclkb), .clkq_in(rx_pi_qclk),
     .clkqb_in(rx_pi_qclkb), .reset_sync(clk_rx_reset_sync),
     .vss(vss));
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUM_D1_GL16_LVT DUMcmos[79:0] ( .vdd(vdda), .vss(vss), .tiehi(vdda),
     .tielo(vss));*/

endmodule
// Library - wphy_gf12lp_d2d_serdes_lib, Cell - wav_wlink_8l_rx_ana,
//View - schematic
// LAST TIME SAVED: Sep 14 11:54:06 2021
// NETLIST TIME: Oct  7 15:28:49 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_wav_wlink_8l_rx_ana ( 
output wire logic   clk_rx_coreclk_div16, 
output wire logic   clk_rx_dll_cal_dat, 
output wire logic   clk_rx_dtest, 
output wire logic   clk_rx_rcvr_bypass_in_n, 
output wire logic   clk_rx_rcvr_bypass_in_p, 
output wire logic   rx0_clk_div16, 
output wire logic  [15:0] rx0_idata, 
output wire logic  [15:0] rx0_qdata, 
output wire logic   rx0_serdes_byp_in, 
output wire logic   rx1_clk_div16, 
output wire logic  [15:0] rx1_idata, 
output wire logic  [15:0] rx1_qdata, 
output wire logic   rx1_serdes_byp_in, 
output wire logic   rx2_clk_div16, 
output wire logic  [15:0] rx2_idata, 
output wire logic  [15:0] rx2_qdata, 
output wire logic   rx2_serdes_byp_in, 
output wire logic   rx3_clk_div16, 
output wire logic  [15:0] rx3_idata, 
output wire logic  [15:0] rx3_qdata, 
output wire logic   rx3_serdes_byp_in, 
output wire logic   rx4_clk_div16, 
output wire logic  [15:0] rx4_idata, 
output wire logic  [15:0] rx4_qdata, 
output wire logic   rx4_serdes_byp_in, 
output wire logic   rx5_clk_div16, 
output wire logic  [15:0] rx5_idata, 
output wire logic  [15:0] rx5_qdata, 
output wire logic   rx5_serdes_byp_in, 
output wire logic   rx6_clk_div16, 
output wire logic  [15:0] rx6_idata, 
output wire logic  [15:0] rx6_qdata, 
output wire logic   rx6_serdes_byp_in, 
output wire logic   rx7_clk_div16, 
output wire logic  [15:0] rx7_idata, 
output wire logic  [15:0] rx7_qdata, 
output wire logic   rx7_serdes_byp_in, 
inout wire logic   pad_clk_rxn, 
inout wire logic   pad_clk_rxp, 
inout wire logic   vdda, 
inout wire logic   vdda_ck, 
inout wire logic   vddq, 
inout wire logic   vss, 
input wire logic   clk_rx_dll_cal_en, 
input wire logic  [5:0] clk_rx_dll_ctrl, 
input wire logic   clk_rx_dll_en, 
input wire logic  [1:0] clk_rx_dll_gear, 
input wire logic  [3:0] clk_rx_dtest_div, 
input wire logic   clk_rx_dtest_en, 
input wire logic   clk_rx_dtest_in, 
input wire logic   clk_rx_en_rx_div2_clk, 
input wire logic   clk_rx_en_rx_div16_clk, 
input wire logic  [15:0] clk_rx_i_pi_code, 
input wire logic   clk_rx_i_pi_en, 
input wire logic  [1:0] clk_rx_i_pi_quad, 
input wire logic  [3:0] clk_rx_pi_gear, 
input wire logic  [3:0] clk_rx_pi_xcpl, 
input wire logic  [15:0] clk_rx_q_pi_code, 
input wire logic   clk_rx_q_pi_en, 
input wire logic  [1:0] clk_rx_q_pi_quad, 
input wire logic   clk_rx_rcvr_ac_mode, 
input wire logic   clk_rx_rcvr_bypass_sel, 
input wire logic   clk_rx_rcvr_en, 
input wire logic   clk_rx_rcvr_fb_en, 
input wire logic  [3:0] clk_rx_rcvr_odt_ctrl, 
input wire logic   clk_rx_rcvr_odt_dc_mode, 
input wire logic   clk_rx_reset_sync, 
input wire logic   clk_rx_ser_lpb_en, 
input wire logic   clk_rx_ser_lpb_n, 
input wire logic   clk_rx_ser_lpb_p, 
input wire logic  [2:0] clk_rx_test_sel, 
input wire logic   clk_rx_vref_en, 
input wire logic  [5:0] clk_rx_vref_lvl, 
input wire logic   pad_rx0, 
input wire logic   pad_rx1, 
input wire logic   pad_rx2, 
input wire logic   pad_rx3, 
input wire logic   pad_rx4, 
input wire logic   pad_rx5, 
input wire logic   pad_rx6, 
input wire logic   pad_rx7, 
input wire logic   rx0_cal_en, 
input wire logic   rx0_i_en, 
input wire logic  [3:0] rx0_odt, 
input wire logic   rx0_odt_dc_mode, 
input wire logic   rx0_osc_dir_i_dp, 
input wire logic   rx0_osc_dir_ib_dp, 
input wire logic   rx0_osc_dir_q_dp, 
input wire logic   rx0_osc_dir_qb_dp, 
input wire logic  [3:0] rx0_osc_i_dp, 
input wire logic  [3:0] rx0_osc_ib_dp, 
input wire logic  [3:0] rx0_osc_q_dp, 
input wire logic  [3:0] rx0_osc_qb_dp, 
input wire logic   rx0_q_en, 
input wire logic   rx0_ser_lpb, 
input wire logic   rx0_serdes_byp_sel, 
input wire logic   rx0_serlb_en, 
input wire logic   rx1_cal_en, 
input wire logic   rx1_i_en, 
input wire logic  [3:0] rx1_odt, 
input wire logic   rx1_odt_dc_mode, 
input wire logic   rx1_osc_dir_i_dp, 
input wire logic   rx1_osc_dir_ib_dp, 
input wire logic   rx1_osc_dir_q_dp, 
input wire logic   rx1_osc_dir_qb_dp, 
input wire logic  [3:0] rx1_osc_i_dp, 
input wire logic  [3:0] rx1_osc_ib_dp, 
input wire logic  [3:0] rx1_osc_q_dp, 
input wire logic  [3:0] rx1_osc_qb_dp, 
input wire logic   rx1_q_en, 
input wire logic   rx1_ser_lpb, 
input wire logic   rx1_serdes_byp_sel, 
input wire logic   rx1_serlb_en, 
input wire logic   rx2_cal_en, 
input wire logic   rx2_i_en, 
input wire logic  [3:0] rx2_odt, 
input wire logic   rx2_odt_dc_mode, 
input wire logic   rx2_osc_dir_i_dp, 
input wire logic   rx2_osc_dir_ib_dp, 
input wire logic   rx2_osc_dir_q_dp, 
input wire logic   rx2_osc_dir_qb_dp, 
input wire logic  [3:0] rx2_osc_i_dp, 
input wire logic  [3:0] rx2_osc_ib_dp, 
input wire logic  [3:0] rx2_osc_q_dp, 
input wire logic  [3:0] rx2_osc_qb_dp, 
input wire logic   rx2_q_en, 
input wire logic   rx2_ser_lpb, 
input wire logic   rx2_serdes_byp_sel, 
input wire logic   rx2_serlb_en, 
input wire logic   rx3_cal_en, 
input wire logic   rx3_i_en, 
input wire logic  [3:0] rx3_odt, 
input wire logic   rx3_odt_dc_mode, 
input wire logic   rx3_osc_dir_i_dp, 
input wire logic   rx3_osc_dir_ib_dp, 
input wire logic   rx3_osc_dir_q_dp, 
input wire logic   rx3_osc_dir_qb_dp, 
input wire logic  [3:0] rx3_osc_i_dp, 
input wire logic  [3:0] rx3_osc_ib_dp, 
input wire logic  [3:0] rx3_osc_q_dp, 
input wire logic  [3:0] rx3_osc_qb_dp, 
input wire logic   rx3_q_en, 
input wire logic   rx3_ser_lpb, 
input wire logic   rx3_serdes_byp_sel, 
input wire logic   rx3_serlb_en, 
input wire logic   rx4_cal_en, 
input wire logic   rx4_i_en, 
input wire logic  [3:0] rx4_odt, 
input wire logic   rx4_odt_dc_mode, 
input wire logic   rx4_osc_dir_i_dp, 
input wire logic   rx4_osc_dir_ib_dp, 
input wire logic   rx4_osc_dir_q_dp, 
input wire logic   rx4_osc_dir_qb_dp, 
input wire logic  [3:0] rx4_osc_i_dp, 
input wire logic  [3:0] rx4_osc_ib_dp, 
input wire logic  [3:0] rx4_osc_q_dp, 
input wire logic  [3:0] rx4_osc_qb_dp, 
input wire logic   rx4_q_en, 
input wire logic   rx4_ser_lpb, 
input wire logic   rx4_serdes_byp_sel, 
input wire logic   rx4_serlb_en, 
input wire logic   rx5_cal_en, 
input wire logic   rx5_i_en, 
input wire logic  [3:0] rx5_odt, 
input wire logic   rx5_odt_dc_mode, 
input wire logic   rx5_osc_dir_i_dp, 
input wire logic   rx5_osc_dir_ib_dp, 
input wire logic   rx5_osc_dir_q_dp, 
input wire logic   rx5_osc_dir_qb_dp, 
input wire logic  [3:0] rx5_osc_i_dp, 
input wire logic  [3:0] rx5_osc_ib_dp, 
input wire logic  [3:0] rx5_osc_q_dp, 
input wire logic  [3:0] rx5_osc_qb_dp, 
input wire logic   rx5_q_en, 
input wire logic   rx5_ser_lpb, 
input wire logic   rx5_serdes_byp_sel, 
input wire logic   rx5_serlb_en, 
input wire logic   rx6_cal_en, 
input wire logic   rx6_i_en, 
input wire logic  [3:0] rx6_odt, 
input wire logic   rx6_odt_dc_mode, 
input wire logic   rx6_osc_dir_i_dp, 
input wire logic   rx6_osc_dir_ib_dp, 
input wire logic   rx6_osc_dir_q_dp, 
input wire logic   rx6_osc_dir_qb_dp, 
input wire logic  [3:0] rx6_osc_i_dp, 
input wire logic  [3:0] rx6_osc_ib_dp, 
input wire logic  [3:0] rx6_osc_q_dp, 
input wire logic  [3:0] rx6_osc_qb_dp, 
input wire logic   rx6_q_en, 
input wire logic   rx6_ser_lpb, 
input wire logic   rx6_serdes_byp_sel, 
input wire logic   rx6_serlb_en, 
input wire logic   rx7_cal_en, 
input wire logic   rx7_i_en, 
input wire logic  [3:0] rx7_odt, 
input wire logic   rx7_odt_dc_mode, 
input wire logic   rx7_osc_dir_i_dp, 
input wire logic   rx7_osc_dir_ib_dp, 
input wire logic   rx7_osc_dir_q_dp, 
input wire logic   rx7_osc_dir_qb_dp, 
input wire logic  [3:0] rx7_osc_i_dp, 
input wire logic  [3:0] rx7_osc_ib_dp, 
input wire logic  [3:0] rx7_osc_q_dp, 
input wire logic  [3:0] rx7_osc_qb_dp, 
input wire logic   rx7_q_en, 
input wire logic   rx7_ser_lpb, 
input wire logic   rx7_serdes_byp_sel, 
input wire logic   rx7_serlb_en );


wire logic rx_iclkb ;

wire logic rx_qclk ;

wire logic rx_iclk ;

wire logic rx_clk_div8 ;

wire logic rx_qclkb ;

wire logic rx_clk_div16 ;

var real iref ;



WavD2DAnalogPhy_8lane_gf12lpp_wav_d2d_rx_ana_IQ IRX4 ( .vdda(vdda),
     .rx_osc_dir_i_dp(rx4_osc_dir_i_dp),
     .rx_osc_dir_ib_dp(rx4_osc_dir_ib_dp),
     .rx_osc_ib_dp(rx4_osc_ib_dp[3:0]), .rx_i_en(rx4_i_en),
     .rxq_osc_dir_q_dp(rx4_osc_dir_q_dp),
     .rxq_osc_q_dp(rx4_osc_q_dp[3:0]),
     .rxq_osc_dir_qb_dp(rx4_osc_dir_qb_dp),
     .rxq_osc_qb_dp(rx4_osc_qb_dp[3:0]), .rx_cal_en(rx4_cal_en),
     .rx_serlb_in(rx4_ser_lpb), .rx_clk_div16(rx4_clk_div16),
     .pad_rx(pad_rx4), .rx_serdes_byp_in(rx4_serdes_byp_in),
     .rx_iref(iref), .rx_osc_i_dp(rx4_osc_i_dp[3:0]),
     .vdda_ck(vdda_ck), .vss(vss), .rx_iclkb(rx_iclkb),
     .rx_odt_dc_mode(rx4_odt_dc_mode),
     .rx_serdes_byp_sel(rx4_serdes_byp_sel),
     .rx_clk_div16_in(rx_clk_div16), .rx_clk_div8_in(rx_clk_div8),
     .rxq_qdata(rx4_qdata[15:0]), .rxq_q_en(rx4_q_en),
     .rx_odt_ctrl(rx4_odt[3:0]), .rx_iclk(rx_iclk), .rxq_qclk(rx_qclk),
     .rx_serlb_en(rx4_serlb_en), .rx_idata(rx4_idata[15:0]),
     .rxq_qclkb(rx_qclkb));
WavD2DAnalogPhy_8lane_gf12lpp_wav_d2d_rx_ana_IQ IRX6 ( .vdda(vdda),
     .rx_osc_dir_i_dp(rx6_osc_dir_i_dp),
     .rx_osc_dir_ib_dp(rx6_osc_dir_ib_dp),
     .rx_osc_ib_dp(rx6_osc_ib_dp[3:0]), .rx_i_en(rx6_i_en),
     .rxq_osc_dir_q_dp(rx6_osc_dir_q_dp),
     .rxq_osc_q_dp(rx6_osc_q_dp[3:0]),
     .rxq_osc_dir_qb_dp(rx6_osc_dir_qb_dp),
     .rxq_osc_qb_dp(rx6_osc_qb_dp[3:0]), .rx_cal_en(rx6_cal_en),
     .rx_serlb_in(rx6_ser_lpb), .rx_clk_div16(rx6_clk_div16),
     .pad_rx(pad_rx6), .rx_serdes_byp_in(rx6_serdes_byp_in),
     .rx_iref(iref), .rx_osc_i_dp(rx6_osc_i_dp[3:0]),
     .vdda_ck(vdda_ck), .vss(vss), .rx_iclkb(rx_iclkb),
     .rx_odt_dc_mode(rx6_odt_dc_mode),
     .rx_serdes_byp_sel(rx6_serdes_byp_sel),
     .rx_clk_div16_in(rx_clk_div16), .rx_clk_div8_in(rx_clk_div8),
     .rxq_qdata(rx6_qdata[15:0]), .rxq_q_en(rx6_q_en),
     .rx_odt_ctrl(rx6_odt[3:0]), .rx_iclk(rx_iclk), .rxq_qclk(rx_qclk),
     .rx_serlb_en(rx6_serlb_en), .rx_idata(rx6_idata[15:0]),
     .rxq_qclkb(rx_qclkb));
WavD2DAnalogPhy_8lane_gf12lpp_wav_d2d_rx_ana_IQ IRX7 ( .vdda(vdda),
     .rx_osc_dir_i_dp(rx7_osc_dir_i_dp),
     .rx_osc_dir_ib_dp(rx7_osc_dir_ib_dp),
     .rx_osc_ib_dp(rx7_osc_ib_dp[3:0]), .rx_i_en(rx7_i_en),
     .rxq_osc_dir_q_dp(rx7_osc_dir_q_dp),
     .rxq_osc_q_dp(rx7_osc_q_dp[3:0]),
     .rxq_osc_dir_qb_dp(rx7_osc_dir_qb_dp),
     .rxq_osc_qb_dp(rx7_osc_qb_dp[3:0]), .rx_cal_en(rx7_cal_en),
     .rx_serlb_in(rx7_ser_lpb), .rx_clk_div16(rx7_clk_div16),
     .pad_rx(pad_rx7), .rx_serdes_byp_in(rx7_serdes_byp_in),
     .rx_iref(iref), .rx_osc_i_dp(rx7_osc_i_dp[3:0]),
     .vdda_ck(vdda_ck), .vss(vss), .rx_iclkb(rx_iclkb),
     .rx_odt_dc_mode(rx7_odt_dc_mode),
     .rx_serdes_byp_sel(rx7_serdes_byp_sel),
     .rx_clk_div16_in(rx_clk_div16), .rx_clk_div8_in(rx_clk_div8),
     .rxq_qdata(rx7_qdata[15:0]), .rxq_q_en(rx7_q_en),
     .rx_odt_ctrl(rx7_odt[3:0]), .rx_iclk(rx_iclk), .rxq_qclk(rx_qclk),
     .rx_serlb_en(rx7_serlb_en), .rx_idata(rx7_idata[15:0]),
     .rxq_qclkb(rx_qclkb));
WavD2DAnalogPhy_8lane_gf12lpp_wav_d2d_rx_ana_IQ IRX5 ( .vdda(vdda),
     .rx_osc_dir_i_dp(rx5_osc_dir_i_dp),
     .rx_osc_dir_ib_dp(rx5_osc_dir_ib_dp),
     .rx_osc_ib_dp(rx5_osc_ib_dp[3:0]), .rx_i_en(rx5_i_en),
     .rxq_osc_dir_q_dp(rx5_osc_dir_q_dp),
     .rxq_osc_q_dp(rx5_osc_q_dp[3:0]),
     .rxq_osc_dir_qb_dp(rx5_osc_dir_qb_dp),
     .rxq_osc_qb_dp(rx5_osc_qb_dp[3:0]), .rx_cal_en(rx5_cal_en),
     .rx_serlb_in(rx5_ser_lpb), .rx_clk_div16(rx5_clk_div16),
     .pad_rx(pad_rx5), .rx_serdes_byp_in(rx5_serdes_byp_in),
     .rx_iref(iref), .rx_osc_i_dp(rx5_osc_i_dp[3:0]),
     .vdda_ck(vdda_ck), .vss(vss), .rx_iclkb(rx_iclkb),
     .rx_odt_dc_mode(rx5_odt_dc_mode),
     .rx_serdes_byp_sel(rx5_serdes_byp_sel),
     .rx_clk_div16_in(rx_clk_div16), .rx_clk_div8_in(rx_clk_div8),
     .rxq_qdata(rx5_qdata[15:0]), .rxq_q_en(rx5_q_en),
     .rx_odt_ctrl(rx5_odt[3:0]), .rx_iclk(rx_iclk), .rxq_qclk(rx_qclk),
     .rx_serlb_en(rx5_serlb_en), .rx_idata(rx5_idata[15:0]),
     .rxq_qclkb(rx_qclkb));
WavD2DAnalogPhy_8lane_gf12lpp_wav_d2d_rx_ana_IQ IRX2 ( .vdda(vdda),
     .rx_osc_dir_i_dp(rx2_osc_dir_i_dp),
     .rx_osc_dir_ib_dp(rx2_osc_dir_ib_dp),
     .rx_osc_ib_dp(rx2_osc_ib_dp[3:0]), .rx_i_en(rx2_i_en),
     .rxq_osc_dir_q_dp(rx2_osc_dir_q_dp),
     .rxq_osc_q_dp(rx2_osc_q_dp[3:0]),
     .rxq_osc_dir_qb_dp(rx2_osc_dir_qb_dp),
     .rxq_osc_qb_dp(rx2_osc_qb_dp[3:0]), .rx_cal_en(rx2_cal_en),
     .rx_serlb_in(rx2_ser_lpb), .rx_clk_div16(rx2_clk_div16),
     .pad_rx(pad_rx2), .rx_serdes_byp_in(rx2_serdes_byp_in),
     .rx_iref(iref), .rx_osc_i_dp(rx2_osc_i_dp[3:0]),
     .vdda_ck(vdda_ck), .vss(vss), .rx_iclkb(rx_iclkb),
     .rx_odt_dc_mode(rx2_odt_dc_mode),
     .rx_serdes_byp_sel(rx2_serdes_byp_sel),
     .rx_clk_div16_in(rx_clk_div16), .rx_clk_div8_in(rx_clk_div8),
     .rxq_qdata(rx2_qdata[15:0]), .rxq_q_en(rx2_q_en),
     .rx_odt_ctrl(rx2_odt[3:0]), .rx_iclk(rx_iclk), .rxq_qclk(rx_qclk),
     .rx_serlb_en(rx2_serlb_en), .rx_idata(rx2_idata[15:0]),
     .rxq_qclkb(rx_qclkb));
WavD2DAnalogPhy_8lane_gf12lpp_wav_d2d_rx_ana_IQ IRX3 ( .vdda(vdda),
     .rx_osc_dir_i_dp(rx3_osc_dir_i_dp),
     .rx_osc_dir_ib_dp(rx3_osc_dir_ib_dp),
     .rx_osc_ib_dp(rx3_osc_ib_dp[3:0]), .rx_i_en(rx3_i_en),
     .rxq_osc_dir_q_dp(rx3_osc_dir_q_dp),
     .rxq_osc_q_dp(rx3_osc_q_dp[3:0]),
     .rxq_osc_dir_qb_dp(rx3_osc_dir_qb_dp),
     .rxq_osc_qb_dp(rx3_osc_qb_dp[3:0]), .rx_cal_en(rx3_cal_en),
     .rx_serlb_in(rx3_ser_lpb), .rx_clk_div16(rx3_clk_div16),
     .pad_rx(pad_rx3), .rx_serdes_byp_in(rx3_serdes_byp_in),
     .rx_iref(iref), .rx_osc_i_dp(rx3_osc_i_dp[3:0]),
     .vdda_ck(vdda_ck), .vss(vss), .rx_iclkb(rx_iclkb),
     .rx_odt_dc_mode(rx3_odt_dc_mode),
     .rx_serdes_byp_sel(rx3_serdes_byp_sel),
     .rx_clk_div16_in(rx_clk_div16), .rx_clk_div8_in(rx_clk_div8),
     .rxq_qdata(rx3_qdata[15:0]), .rxq_q_en(rx3_q_en),
     .rx_odt_ctrl(rx3_odt[3:0]), .rx_iclk(rx_iclk), .rxq_qclk(rx_qclk),
     .rx_serlb_en(rx3_serlb_en), .rx_idata(rx3_idata[15:0]),
     .rxq_qclkb(rx_qclkb));
WavD2DAnalogPhy_8lane_gf12lpp_wav_d2d_rx_ana_IQ IRX1 ( .vdda(vdda),
     .rx_osc_dir_i_dp(rx1_osc_dir_i_dp),
     .rx_osc_dir_ib_dp(rx1_osc_dir_ib_dp),
     .rx_osc_ib_dp(rx1_osc_ib_dp[3:0]), .rx_i_en(rx1_i_en),
     .rxq_osc_dir_q_dp(rx1_osc_dir_q_dp),
     .rxq_osc_q_dp(rx1_osc_q_dp[3:0]),
     .rxq_osc_dir_qb_dp(rx1_osc_dir_qb_dp),
     .rxq_osc_qb_dp(rx1_osc_qb_dp[3:0]), .rx_cal_en(rx1_cal_en),
     .rx_serlb_in(rx1_ser_lpb), .rx_clk_div16(rx1_clk_div16),
     .pad_rx(pad_rx1), .rx_serdes_byp_in(rx1_serdes_byp_in),
     .rx_iref(iref), .rx_osc_i_dp(rx1_osc_i_dp[3:0]),
     .vdda_ck(vdda_ck), .vss(vss), .rx_iclkb(rx_iclkb),
     .rx_odt_dc_mode(rx1_odt_dc_mode),
     .rx_serdes_byp_sel(rx1_serdes_byp_sel),
     .rx_clk_div16_in(rx_clk_div16), .rx_clk_div8_in(rx_clk_div8),
     .rxq_qdata(rx1_qdata[15:0]), .rxq_q_en(rx1_q_en),
     .rx_odt_ctrl(rx1_odt[3:0]), .rx_iclk(rx_iclk), .rxq_qclk(rx_qclk),
     .rx_serlb_en(rx1_serlb_en), .rx_idata(rx1_idata[15:0]),
     .rxq_qclkb(rx_qclkb));
WavD2DAnalogPhy_8lane_gf12lpp_wav_d2d_rx_ana_IQ IRX0 ( .vdda(vdda),
     .rx_osc_dir_i_dp(rx0_osc_dir_i_dp),
     .rx_osc_dir_ib_dp(rx0_osc_dir_ib_dp),
     .rx_osc_ib_dp(rx0_osc_ib_dp[3:0]), .rx_i_en(rx0_i_en),
     .rxq_osc_dir_q_dp(rx0_osc_dir_q_dp),
     .rxq_osc_q_dp(rx0_osc_q_dp[3:0]),
     .rxq_osc_dir_qb_dp(rx0_osc_dir_qb_dp),
     .rxq_osc_qb_dp(rx0_osc_qb_dp[3:0]), .rx_cal_en(rx0_cal_en),
     .rx_serlb_in(rx0_ser_lpb), .rx_clk_div16(rx0_clk_div16),
     .pad_rx(pad_rx0), .rx_serdes_byp_in(rx0_serdes_byp_in),
     .rx_iref(iref), .rx_osc_i_dp(rx0_osc_i_dp[3:0]),
     .vdda_ck(vdda_ck), .vss(vss), .rx_iclkb(rx_iclkb),
     .rx_odt_dc_mode(rx0_odt_dc_mode),
     .rx_serdes_byp_sel(rx0_serdes_byp_sel),
     .rx_clk_div16_in(rx_clk_div16), .rx_clk_div8_in(rx_clk_div8),
     .rxq_qdata(rx0_qdata[15:0]), .rxq_q_en(rx0_q_en),
     .rx_odt_ctrl(rx0_odt[3:0]), .rx_iclk(rx_iclk), .rxq_qclk(rx_qclk),
     .rx_serlb_en(rx0_serlb_en), .rx_idata(rx0_idata[15:0]),
     .rxq_qclkb(rx_qclkb));
WavD2DAnalogPhy_8lane_gf12lpp_wav_d2d_clk_ana_rx ICLK_RX (
     .clk_rx_rcvr_odt_ctrl(clk_rx_rcvr_odt_ctrl[3:0]), .vdda(vdda_ck),
     .clk_rx_rcvr_bypass_in_p(clk_rx_rcvr_bypass_in_p),
     .pad_clkn_txrx(pad_clk_rxn),
     .clk_rx_rcvr_bypass_sel(clk_rx_rcvr_bypass_sel), .vss(vss),
     .clk_rx_dtst_en(clk_rx_dtest_en), .clk_rx_rcvr_en(clk_rx_rcvr_en),
     .clk_rx_clk_div16(rx_clk_div16),
     .clk_rx_dtst_div(clk_rx_dtest_div[3:0]), .clk_rx_iclk(rx_iclk),
     .vddq(vddq), .clk_rx_dll_gear(clk_rx_dll_gear[1:0]),
     .clk_rx_dtst_in(clk_rx_dtest_in),
     .clk_rx_coreclk_div16(clk_rx_coreclk_div16),
     .clk_rx_rcvr_ac_mode(clk_rx_rcvr_ac_mode),
     .clk_rx_clk_div8(rx_clk_div8),
     .clk_rx_rcvr_odt_dc_mode(clk_rx_rcvr_odt_dc_mode),
     .clk_rx_dll_cal_en(clk_rx_dll_cal_en),
     .clk_rx_dll_cal_dat(clk_rx_dll_cal_dat),
     .clk_rx_reset_sync(clk_rx_reset_sync), .clk_rx_iclkb(rx_iclkb),
     .clk_rx_dtst_sel(clk_rx_test_sel[2:0]),
     .pad_clkp_txrx(pad_clk_rxp),
     .clk_rx_dll_ctrl(clk_rx_dll_ctrl[5:0]),
     .clk_rx_pi_xcpl(clk_rx_pi_xcpl[3:0]), .clk_rx_dtest(clk_rx_dtest),
     .clk_rx_qclkb(rx_qclkb), .clk_rx_qclk(rx_qclk),
     .clk_rx_dll_en(clk_rx_dll_en), .clk_rx_i_pi_en(clk_rx_i_pi_en),
     .clk_rx_q_pi_quad(clk_rx_q_pi_quad[1:0]),
     .clk_rx_i_pi_code(clk_rx_i_pi_code[15:0]),
     .clk_rx_q_pi_en(clk_rx_q_pi_en), .clk_rx_vref_en(clk_rx_vref_en),
     .clk_rx_ser_lpb_en(clk_rx_ser_lpb_en), .clk_rx_vref(iref),
     .clk_rx_serlb_inn(clk_rx_ser_lpb_n),
     .clk_rx_vref_lvl(clk_rx_vref_lvl[5:0]),
     .clk_rx_i_pi_quad(clk_rx_i_pi_quad[1:0]),
     .clk_rx_rcvr_bypass_in_n(clk_rx_rcvr_bypass_in_n),
     .clk_rx_en_rx_div2_clk(clk_rx_en_rx_div2_clk),
     .clk_rx_q_pi_code(clk_rx_q_pi_code[15:0]),
     .clk_rx_serlb_inp(clk_rx_ser_lpb_p),
     .clk_rx_pi_gear(clk_rx_pi_gear[3:0]),
     .clk_rx_en_rx_div16_clk(clk_rx_en_rx_div16_clk),
     .clk_rx_rcvr_fb_en(clk_rx_rcvr_fb_en));
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUM_D1_GL16_LVT DUM1[1054:0] ( .vdd(vdda_ck), .vss(vss),
     .tiehi(vdda_ck), .tielo(vss));*/
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUM_D1_GL16_LVT DUM0[2742:0] ( .vdd(vdda), .vss(vss), .tiehi(vdda),
     .tielo(vss));*/
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_cmos_cap C0[299:0] ( .plus(vdda), .vss(vss));*/
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_cmos_cap C2[34:0] ( .plus(vdda_ck), .vss(vss));*/

endmodule
// Library - wphy_gf12lp_d2d_serdes_lib, Cell - d2d_vddq_cap, View -
//schematic
// LAST TIME SAVED: Feb  5 04:36:43 2021
// NETLIST TIME: Oct  7 15:28:49 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_d2d_vddq_cap ( 
inout   vddq, 
inout   vss );




/*REMOVED VIA SCRIPT -- ncap_2t  C0[1:0] ( .g(vddq), .sd(vss));*/
/*REMOVED VIA SCRIPT -- pcapacitor  C1 ( .MINUS(vss), .PLUS(vddq));*/

endmodule
// Library - wphy_gf12lp_d2d_serdes_lib, Cell - d2d_vddq_cap_tall, View
//- schematic
// LAST TIME SAVED: Mar 31 03:58:37 2021
// NETLIST TIME: Oct  7 15:28:49 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_d2d_vddq_cap_tall ( 
inout   vddq, 
inout   vss );




/*REMOVED VIA SCRIPT -- ncap_2t  C0[1:0] ( .g(vddq), .sd(vss));*/
/*REMOVED VIA SCRIPT -- pcapacitor  C1 ( .MINUS(vss), .PLUS(vddq));*/

endmodule
// Library - wphy_gf12lp_d2d_serdes_lib, Cell - d2d_drv_slice_all, View
//- schematic
// LAST TIME SAVED: Nov 24 13:56:36 2020
// NETLIST TIME: Oct  7 15:28:49 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_d2d_drv_slice_all ( 
output   outp, 
inout   vddq, 
inout   vss, 
input  [31:0] imp_ctrl, 
input   inn, 
input   inp );




WavD2DAnalogPhy_8lane_gf12lpp_d2d_drv_slice_v2 DRV[31:0] ( .outp(outp), .vddq(vddq), .vss(vss),
     .en(imp_ctrl[31:0]), .inn(inn), .inp(inp));

endmodule
// Library - wphy_gf12lp_d2d_serdes_lib, Cell - wav_d2d_clk_drv, View -
//schematic
// LAST TIME SAVED: Sep 16 11:49:12 2021
// NETLIST TIME: Oct  7 15:28:49 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_wav_d2d_clk_drv ( 
output wire logic   clk_ser_lpb_n, 
output wire logic   clk_ser_lpb_p, 
output wire logic   outn, 
output wire logic   outp, 
inout wire logic   vdda, 
inout   vddq, 
inout wire logic   vss, 
input wire logic   bypass_out_n, 
input wire logic   bypass_out_p, 
input wire logic   bypass_sel, 
input wire logic  [3:0] drv_ctrl, 
input wire logic   en, 
input wire logic   inn, 
input wire logic   inp, 
input wire logic  [2:0] preemp_en, 
input wire logic   ser_lpb_en );


wire logic prim_p ;

wire logic prim_p_b ;

wire logic nb ;

wire logic pren ;

wire logic prep ;

wire logic bypass_p_datb ;

wire logic bypass_n_datb ;

wire logic nb2 ;

wire logic main_path_en ;

wire logic pb ;

wire logic byp_path_enb ;

wire logic main_path_enb ;

wire logic byp_path_en ;

wire logic byp_selb ;

wire logic prim_n ;

wire logic pb2 ;

wire logic prim_n_b ;

wire logic slpb_en ;

wire logic slpb_enb ;

// Buses in the design

wire logic [3:0]  imp_ctrlb;

wire logic [3:0]  imp_ctrl;

wire logic [2:0]  pre_enb_int;

wire logic [2:0]  pre_en_int;



WavD2DAnalogPhy_8lane_gf12lpp_d2d_clk_drv_boost_dum Iclk_boost_dum[1:0] ( .vdda(vdda), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_d2d_clk_drv_slice_dum Islicedum ( .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D8_GL16_LVT INV3 ( .in(pb), .vss(vss), .out(prim_p), .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D8_GL16_LVT INV10 ( .in(nb), .vss(vss), .out(prim_n), .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_d2d_vddq_cap C0[29:0] ( .vddq(vddq), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D4_GL16_LVT INVT0 ( .in(inp), .vss(vss), .out(pb), .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D4_GL16_LVT INV15[2:0] ( .out(pre_en_int[2:0]), .vdd(vdda),
     .vss(vss), .in(pre_enb_int[2:0]));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D4_GL16_LVT INV8 ( .in(inn), .vss(vss), .out(nb), .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_NAND2_D1_GL16_LVT NAND2[2:0] ( .y(pre_enb_int[2:0]), .vdd(vdda),
     .vss(vss), .a(main_path_en), .b(preemp_en[2:0]), .tiehi(vdda),
     .tielo(vss));
WavD2DAnalogPhy_8lane_gf12lpp_NAND2_D1_GL16_LVT NAND1 ( .tielo(vss), .tiehi(vdda), .vdd(vdda),
     .y(main_path_enb), .vss(vss), .b(byp_selb), .a(en));
WavD2DAnalogPhy_8lane_gf12lpp_NAND2_D1_GL16_LVT NAND0 ( .tielo(vss), .tiehi(vdda), .vdd(vdda),
     .y(byp_path_enb), .vss(vss), .b(bypass_sel), .a(en));
WavD2DAnalogPhy_8lane_gf12lpp_NAND2_D1_GL16_LVT NAND[3:0] ( .y(imp_ctrlb[3:0]), .vdd(vdda),
     .vss(vss), .a(drv_ctrl[3:0]), .b(main_path_en), .tiehi(vdda),
     .tielo(vss));
WavD2DAnalogPhy_8lane_gf12lpp_d2d_vddq_cap_tall C1[3:0] ( .vddq(vddq), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D1_GL16_LVT I17 ( .tielo(vss), .tiehi(vdda), .in(main_path_enb),
     .vss(vss), .out(main_path_en), .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D1_GL16_LVT INV9 ( .tielo(vss), .tiehi(vdda), .vdd(vdda),
     .in(bypass_sel), .vss(vss), .out(byp_selb));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D1_GL16_LVT INV11 ( .tielo(vss), .tiehi(vdda), .vdd(vdda),
     .in(byp_path_enb), .vss(vss), .out(byp_path_en));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D16_GL16_LVT INV12 ( .in(prim_p), .vss(vss), .out(prim_p_b),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D16_GL16_LVT INV19 ( .in(prim_n), .vss(vss), .out(prim_n_b),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_d2d_clk_drv_boost BOOST0[6:0] ( .out(outn), .vdda(vdda), .vss(vss),
     .en_prim({pre_en_int[2], pre_en_int[2], pre_en_int[2],
     pre_en_int[2], pre_en_int[1], pre_en_int[1], pre_en_int[0]}),
     .enb_prim({pre_enb_int[2], pre_enb_int[2], pre_enb_int[2],
     pre_enb_int[2], pre_enb_int[1], pre_enb_int[1], pre_enb_int[0]}),
     .prim(prim_n_b));
WavD2DAnalogPhy_8lane_gf12lpp_d2d_clk_drv_boost BOOST1[6:0] ( .out(outp), .vdda(vdda), .vss(vss),
     .en_prim({pre_en_int[2], pre_en_int[2], pre_en_int[2],
     pre_en_int[2], pre_en_int[1], pre_en_int[1], pre_en_int[0]}),
     .enb_prim({pre_enb_int[2], pre_enb_int[2], pre_enb_int[2],
     pre_enb_int[2], pre_enb_int[1], pre_enb_int[1], pre_enb_int[0]}),
     .prim(prim_p_b));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT I18[3:0] ( .out(imp_ctrl[3:0]), .vdd(vdda), .vss(vss),
     .in(imp_ctrlb[3:0]));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV5[5:0] ( .out(pb2), .vdd(vdda), .vss(vss),
     .in(prim_p));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV2[15:0] ( .out(prep), .vdd(vdda), .vss(vss),
     .in(pb2));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV6[5:0] ( .out(nb2), .vdd(vdda), .vss(vss),
     .in(prim_n));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV13 ( .in(ser_lpb_en), .vss(vss), .out(slpb_enb),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV14 ( .in(bypass_out_n), .vss(vss),
     .out(bypass_n_datb), .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV4 ( .in(slpb_enb), .vss(vss), .out(slpb_en),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV1[15:0] ( .out(pren), .vdd(vdda), .vss(vss),
     .in(nb2));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV7 ( .in(bypass_out_p), .vss(vss),
     .out(bypass_p_datb), .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_d2d_INVT_D2_GL16_LVT_withR INVT1 ( .out(outn), .en(byp_path_en),
     .enb(byp_path_enb), .vss(vss), .in(bypass_n_datb), .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_d2d_INVT_D2_GL16_LVT_withR INV0 ( .vdd(vdda), .out(outp),
     .en(byp_path_en), .enb(byp_path_enb), .vss(vss),
     .in(bypass_p_datb));
WavD2DAnalogPhy_8lane_gf12lpp_d2d_drv_slice_all DRVN ( .inn(prep), .vddq(vddq), .vss(vss),
     .imp_ctrl({imp_ctrl[3], imp_ctrl[3], imp_ctrl[3], imp_ctrl[3],
     imp_ctrl[3], imp_ctrl[3], imp_ctrl[3], imp_ctrl[3], imp_ctrl[3],
     imp_ctrl[3], imp_ctrl[3], imp_ctrl[3], imp_ctrl[3], imp_ctrl[3],
     imp_ctrl[3], imp_ctrl[3], imp_ctrl[2], imp_ctrl[2], imp_ctrl[2],
     imp_ctrl[2], imp_ctrl[2], imp_ctrl[2], imp_ctrl[2], imp_ctrl[2],
     imp_ctrl[1], imp_ctrl[1], imp_ctrl[1], imp_ctrl[1], imp_ctrl[0],
     imp_ctrl[0], main_path_en, main_path_en}), .outp(outn),
     .inp(pren));
WavD2DAnalogPhy_8lane_gf12lpp_d2d_drv_slice_all DRVP ( .inn(pren), .vddq(vddq), .vss(vss),
     .imp_ctrl({imp_ctrl[3], imp_ctrl[3], imp_ctrl[3], imp_ctrl[3],
     imp_ctrl[3], imp_ctrl[3], imp_ctrl[3], imp_ctrl[3], imp_ctrl[3],
     imp_ctrl[3], imp_ctrl[3], imp_ctrl[3], imp_ctrl[3], imp_ctrl[3],
     imp_ctrl[3], imp_ctrl[3], imp_ctrl[2], imp_ctrl[2], imp_ctrl[2],
     imp_ctrl[2], imp_ctrl[2], imp_ctrl[2], imp_ctrl[2], imp_ctrl[2],
     imp_ctrl[1], imp_ctrl[1], imp_ctrl[1], imp_ctrl[1], imp_ctrl[0],
     imp_ctrl[0], main_path_en, main_path_en}), .outp(outp),
     .inp(prep));
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUM_D1_GL16_LVT DUMCMOS[174:0] ( .vdd(vdda), .vss(vss), .tiehi(vdda),
     .tielo(vss));*/
WavD2DAnalogPhy_8lane_gf12lpp_XG_D1_GL16_LVT XGATE1[3:0] ( .y(clk_ser_lpb_n), .vdd(vdda), .vss(vss),
     .a(outn), .en(slpb_en), .enb(slpb_enb));
WavD2DAnalogPhy_8lane_gf12lpp_XG_D1_GL16_LVT XGATE0[3:0] ( .y(clk_ser_lpb_p), .vdd(vdda), .vss(vss),
     .a(outp), .en(slpb_en), .enb(slpb_enb));
WavD2DAnalogPhy_8lane_gf12lpp_hbm_d2d HBM0 ( .vss(vss), .vdd(vdda), .pad(outn));
WavD2DAnalogPhy_8lane_gf12lpp_hbm_d2d HBM1 ( .vss(vss), .vdd(vdda), .pad(outp));

endmodule
// Library - wphy_gf12lp_d2d_serdes_lib, Cell - wav_d2d_tx_clkgen_1dir,
//View - schematic
// LAST TIME SAVED: Aug 31 10:19:32 2021
// NETLIST TIME: Oct  7 15:28:49 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_wav_d2d_tx_clkgen_1dir ( 
output wire logic   coreclk_div16, 
output wire logic   tx_clk_div2, 
output wire logic   tx_clk_div4, 
output wire logic   tx_clk_div8, 
output wire logic   tx_clk_div16, 
output wire logic   tx_clkb_div2, 
inout wire logic   vdda, 
inout wire logic   vss, 
input wire logic   clk_div2_in, 
input wire logic   clkb_div2_in, 
input wire logic   en_div2_clk, 
input wire logic   en_div16_clk, 
input wire logic   reset_sync );


wire logic net061 ;

wire logic q13 ;

wire logic enb_div16_clk ;

wire logic ena_div2_clk ;

wire logic clkb_div2_a ;

wire logic enb_div2_clk ;

wire logic clk_div2_d ;

wire logic clkb_div2_d ;

wire logic clkb_div2_ff ;

wire logic clk_div2_ff ;

wire logic clk_div2_c ;

wire logic clkb_div2_c ;

wire logic q_FF2 ;

wire logic clkb_div2_b ;

wire logic clk_div2_b ;

wire logic clk_div2_a ;

wire logic tx_div4b ;

wire logic tx_div8b ;

wire logic tx_div16b ;

wire logic tx_div4 ;

wire logic tx_div16 ;

wire logic clk_div2_g ;

wire logic clkb_div2_g ;

wire logic ena_div16_clk ;

wire logic clkb_div4 ;

wire logic clkb_div16 ;

wire logic syncb ;

wire logic clkb_div2_f ;

wire logic tx_div8 ;

wire logic clkb_div8 ;

wire logic clk_div2_e ;

wire logic clkb_div2_e ;

wire logic q1234 ;

wire logic q12 ;

wire logic q_FF3 ;

wire logic clk_div2_f ;

wire logic q11 ;

wire logic net059 ;

wire logic net046 ;

wire logic net058 ;

wire logic net010 ;

wire logic net057 ;

wire logic net041 ;

wire logic net039 ;



WavD2DAnalogPhy_8lane_gf12lpp_INVT_D2_GL16_LVT INV83[1:0] ( .out(tx_div8), .vdd(vdda), .vss(vss),
     .en(ena_div2_clk), .enb(enb_div2_clk), .in(q_FF2));
WavD2DAnalogPhy_8lane_gf12lpp_INVT_D2_GL16_LVT INV21[1:0] ( .out(clkb_div2_e), .vdd(vdda), .vss(vss),
     .en(ena_div2_clk), .enb(enb_div2_clk), .in(clk_div2_d));
WavD2DAnalogPhy_8lane_gf12lpp_INVT_D2_GL16_LVT INV46[1:0] ( .out(tx_div16), .vdd(vdda), .vss(vss),
     .en(ena_div16_clk), .enb(enb_div16_clk), .in(clkb_div16));
WavD2DAnalogPhy_8lane_gf12lpp_INVT_D2_GL16_LVT INV84[1:0] ( .out(tx_div4), .vdd(vdda), .vss(vss),
     .en(ena_div2_clk), .enb(enb_div2_clk), .in(q_FF3));
WavD2DAnalogPhy_8lane_gf12lpp_INVT_D2_GL16_LVT INV20[1:0] ( .out(clk_div2_e), .vdd(vdda), .vss(vss),
     .en(ena_div2_clk), .enb(enb_div2_clk), .in(clkb_div2_d));
WavD2DAnalogPhy_8lane_gf12lpp_PD_D2_GL16_LVT PD3 ( .vss(vss), .enb(enb_div16_clk), .y(tx_div16));
WavD2DAnalogPhy_8lane_gf12lpp_PD_D2_GL16_LVT PD2 ( .vss(vss), .enb(enb_div2_clk), .y(tx_div8));
WavD2DAnalogPhy_8lane_gf12lpp_PD_D2_GL16_LVT PD0 ( .vss(vss), .enb(enb_div2_clk), .y(clkb_div2_e));
WavD2DAnalogPhy_8lane_gf12lpp_PD_D2_GL16_LVT PD1 ( .vss(vss), .enb(enb_div2_clk), .y(tx_div4));
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_PDDUM_D2_GL16_LVT PDdum1 ( .vss(vss), .tielo(ena_div2_clk));*/
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUM_D1_GL16_LVT Icdum[346:0] ( .vdd(vdda), .vss(vss), .tiehi(vdda),
     .tielo(vss));*/
WavD2DAnalogPhy_8lane_gf12lpp_NAND2_D1_GL16_LVT NAND2 ( .tielo(vss), .tiehi(vdda), .vdd(vdda),
     .y(net039), .vss(vss), .b(clkb_div16), .a(syncb));
WavD2DAnalogPhy_8lane_gf12lpp_NAND2_D1_GL16_LVT NAND1 ( .tielo(vss), .tiehi(vdda), .vdd(vdda),
     .y(net046), .vss(vss), .b(clkb_div8), .a(syncb));
WavD2DAnalogPhy_8lane_gf12lpp_NAND2_D1_GL16_LVT NAND0 ( .tielo(vss), .tiehi(vdda), .vdd(vdda),
     .y(net010), .vss(vss), .b(clkb_div4), .a(syncb));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV7 ( .in(clk_div2_in), .vss(vss), .out(clkb_div2_a),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV3 ( .in(clkb_div2_in), .vss(vss), .out(clk_div2_a),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV87[3:0] ( .out(tx_div16b), .vdd(vdda), .vss(vss),
     .in(tx_div16));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV12[1:0] ( .out(clkb_div2_b), .vdd(vdda), .vss(vss),
     .in(clk_div2_a));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV85[3:0] ( .out(tx_div4b), .vdd(vdda), .vss(vss),
     .in(tx_div4));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV18[3:0] ( .out(clkb_div2_c), .vdd(vdda), .vss(vss),
     .in(clkb_div2_b));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV13[3:0] ( .out(clkb_div2_g), .vdd(vdda), .vss(vss),
     .in(clk_div2_f));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV16[1:0] ( .out(clk_div2_d), .vdd(vdda), .vss(vss),
     .in(clkb_div2_c));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV19[3:0] ( .out(clk_div2_c), .vdd(vdda), .vss(vss),
     .in(clk_div2_b));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV17[1:0] ( .out(clkb_div2_d), .vdd(vdda), .vss(vss),
     .in(clk_div2_c));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV81[11:0] ( .out(tx_clk_div4), .vdd(vdda), .vss(vss),
     .in(tx_div4b));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV2[1:0] ( .out(coreclk_div16), .vdd(vdda), .vss(vss),
     .in(net061));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV1 ( .vdd(vdda), .in(tx_div16), .vss(vss),
     .out(net061));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV64[11:0] ( .out(tx_clkb_div2), .vdd(vdda),
     .vss(vss), .in(clk_div2_g));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV9[7:0] ( .out(clk_div2_ff), .vdd(vdda), .vss(vss),
     .in(clkb_div2_c));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV90 ( .vdd(vdda), .in(en_div2_clk), .vss(vss),
     .out(enb_div2_clk));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV15[1:0] ( .out(clkb_div2_f), .vdd(vdda), .vss(vss),
     .in(clk_div2_e));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV91 ( .vdd(vdda), .in(enb_div2_clk), .vss(vss),
     .out(ena_div2_clk));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV0[7:0] ( .out(clkb_div2_ff), .vdd(vdda), .vss(vss),
     .in(clk_div2_c));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV14[1:0] ( .out(clk_div2_f), .vdd(vdda), .vss(vss),
     .in(clkb_div2_e));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV65[11:0] ( .out(tx_clk_div2), .vdd(vdda), .vss(vss),
     .in(clkb_div2_g));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV8[1:0] ( .out(clk_div2_b), .vdd(vdda), .vss(vss),
     .in(clkb_div2_a));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV86[3:0] ( .out(tx_div8b), .vdd(vdda), .vss(vss),
     .in(tx_div8));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV6 ( .vdd(vdda), .in(en_div16_clk), .vss(vss),
     .out(enb_div16_clk));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV4 ( .vdd(vdda), .in(enb_div16_clk), .vss(vss),
     .out(ena_div16_clk));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV5[11:0] ( .out(tx_clk_div16), .vdd(vdda), .vss(vss),
     .in(tx_div16b));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV80[11:0] ( .out(tx_clk_div8), .vdd(vdda), .vss(vss),
     .in(tx_div8b));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV10[3:0] ( .out(clk_div2_g), .vdd(vdda), .vss(vss),
     .in(clkb_div2_f));
WavD2DAnalogPhy_8lane_gf12lpp_NOR2_D1_GL16_LVT NAND3 ( .tielo(vss), .tiehi(vdda), .vdd(vdda),
     .y(syncb), .vss(vss), .b(reset_sync), .a(net041));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF3 ( .tiehi(vdda), .tielo(vss), .vdd(vdda), .vss(vss),
     .d(clkb_div4), .clkb(clkb_div2_ff), .clk(clk_div2_ff), .q(q_FF3));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF23 ( .tiehi(vdda), .tielo(vss), .vdd(vdda), .vss(vss),
     .d(net039), .clkb(clkb_div2_ff), .clk(clk_div2_ff), .q(q11));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF22 ( .tiehi(vdda), .tielo(vss), .vdd(vdda), .vss(vss),
     .d(q11), .clkb(clkb_div2_ff), .clk(clk_div2_ff), .q(q12));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF21 ( .tiehi(vdda), .tielo(vss), .vdd(vdda), .vss(vss),
     .d(q12), .clkb(clkb_div2_ff), .clk(clk_div2_ff), .q(q13));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF20 ( .tiehi(vdda), .tielo(vss), .vdd(vdda), .vss(vss),
     .d(net046), .clkb(clkb_div2_ff), .clk(clk_div2_ff), .q(q1234));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF13 ( .tiehi(vdda), .tielo(vss), .vdd(vdda), .vss(vss),
     .d(reset_sync), .clkb(clkb_div2_ff), .clk(clk_div2_ff),
     .q(net059));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF14 ( .tiehi(vdda), .tielo(vss), .vdd(vdda), .vss(vss),
     .d(net059), .clkb(clkb_div2_ff), .clk(clk_div2_ff), .q(net058));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF15 ( .tiehi(vdda), .tielo(vss), .vdd(vdda), .vss(vss),
     .d(net058), .clkb(clkb_div2_ff), .clk(clk_div2_ff), .q(net057));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF16 ( .tiehi(vdda), .tielo(vss), .vdd(vdda), .vss(vss),
     .d(net057), .clkb(clkb_div2_ff), .clk(clk_div2_ff), .q(net041));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF17 ( .tiehi(vdda), .tielo(vss), .vdd(vdda), .vss(vss),
     .d(q13), .clkb(clkb_div2_ff), .clk(clk_div2_ff), .q(clkb_div16));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF1 ( .tiehi(vdda), .tielo(vss), .vdd(vdda), .vss(vss),
     .d(q1234), .clkb(clkb_div2_ff), .clk(clk_div2_ff), .q(clkb_div8));
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF0 ( .tiehi(vdda), .tielo(vss), .vdd(vdda), .vss(vss),
     .d(net010), .clkb(clkb_div2_ff), .clk(clk_div2_ff),
     .q(clkb_div4));
WavD2DAnalogPhy_8lane_gf12lpp_LAT_D1_GL16_LVT FF2 ( .tielo(vss), .tiehi(vdda), .vdd(vdda), .vss(vss),
     .d(clkb_div8), .clkb(clk_div2_ff), .clk(clkb_div2_ff), .q(q_FF2));
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_PUDUM_D2_GL16_LVT PUdum2 ( .vdd(vdda), .tiehi(enb_div2_clk));*/
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_PUDUM_D2_GL16_LVT PUdum4 ( .vdd(vdda), .tiehi(enb_div16_clk));*/
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_PUDUM_D2_GL16_LVT PUdum3 ( .vdd(vdda), .tiehi(enb_div2_clk));*/
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_PUDUM_D2_GL16_LVT PUdum1 ( .vdd(vdda), .tiehi(enb_div2_clk));*/
WavD2DAnalogPhy_8lane_gf12lpp_PU_D2_GL16_LVT PU0 ( .vdd(vdda), .en(ena_div2_clk), .y(clk_div2_e));

endmodule
// Library - wphy_gf12lp_d2d_serdes_lib, Cell - wav_d2d_clk_ana_tx,
//View - schematic
// LAST TIME SAVED: Sep 16 08:44:24 2021
// NETLIST TIME: Oct  7 15:28:49 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_wav_d2d_clk_ana_tx ( 
output wire logic   clk_tx_clk_div2, 
output wire logic   clk_tx_clk_div4, 
output wire logic   clk_tx_clk_div8, 
output wire logic   clk_tx_clk_div16, 
output wire logic   clk_tx_clkb_div2, 
output wire logic   clk_tx_coreclk_div16, 
output wire logic   clk_tx_ser_lpb_n, 
output wire logic   clk_tx_ser_lpb_p, 
inout wire logic   pad_clkn_txrx, 
inout wire logic   pad_clkp_txrx, 
inout wire logic   vdda, 
inout   vddq, 
inout wire logic   vss, 
input wire logic   clk_tx_drv_bypass_out_n, 
input wire logic   clk_tx_drv_bypass_out_p, 
input wire logic   clk_tx_drv_bypass_sel, 
input wire logic  [3:0] clk_tx_drv_ctrl, 
input wire logic   clk_tx_drv_en, 
input wire logic  [2:0] clk_tx_drv_preemp, 
input wire logic   clk_tx_en_tx_div2_clk, 
input wire logic   clk_tx_en_tx_div16_clk, 
input wire logic   clk_tx_pll_clk0, 
input wire logic   clk_tx_pll_clk180, 
input wire logic   clk_tx_reset_sync, 
input wire logic   clk_tx_ser_lpb_en );


wire logic int_clk0b ;

wire logic int_clk0 ;

wire logic int_clk180b ;

wire logic int_clk180 ;



/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_cmos_cap C0[135:0] ( .plus(vdda), .vss(vss));*/
WavD2DAnalogPhy_8lane_gf12lpp_wav_d2d_clk_drv DRV ( .ser_lpb_en(clk_tx_ser_lpb_en),
     .clk_ser_lpb_n(clk_tx_ser_lpb_n),
     .clk_ser_lpb_p(clk_tx_ser_lpb_p), .vddq(vddq),
     .preemp_en(clk_tx_drv_preemp[2:0]),
     .bypass_out_p(clk_tx_drv_bypass_out_p),
     .bypass_out_n(clk_tx_drv_bypass_out_n),
     .drv_ctrl(clk_tx_drv_ctrl[3:0]), .outn(pad_clkn_txrx),
     .inn(int_clk180), .inp(int_clk0), .outp(pad_clkp_txrx),
     .vdda(vdda), .bypass_sel(clk_tx_drv_bypass_sel),
     .en(clk_tx_drv_en), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_wav_d2d_tx_clkgen_1dir ITXCLK ( .vdda(vdda),
     .en_div2_clk(clk_tx_en_tx_div2_clk),
     .tx_clk_div4(clk_tx_clk_div4),
     .coreclk_div16(clk_tx_coreclk_div16),
     .tx_clk_div8(clk_tx_clk_div8), .tx_clk_div16(clk_tx_clk_div16),
     .tx_clk_div2(clk_tx_clk_div2), .tx_clkb_div2(clk_tx_clkb_div2),
     .clk_div2_in(int_clk0), .clkb_div2_in(int_clk180),
     .reset_sync(clk_tx_reset_sync),
     .en_div16_clk(clk_tx_en_tx_div16_clk), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV10[1:0] ( .out(int_clk180b), .vdd(vdda), .vss(vss),
     .in(clk_tx_pll_clk180));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV0[1:0] ( .out(int_clk0), .vdd(vdda), .vss(vss),
     .in(int_clk0b));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV2[1:0] ( .out(int_clk180), .vdd(vdda), .vss(vss),
     .in(int_clk180b));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV3[1:0] ( .out(int_clk0b), .vdd(vdda), .vss(vss),
     .in(clk_tx_pll_clk0));
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUM_D1_GL16_LVT DUMcmos[609:0] ( .vdd(vdda), .vss(vss), .tiehi(vdda),
     .tielo(vss));*/

endmodule
// Library - wphy_gf12lp_d2d_serdes_lib, Cell -
//d2d_lane_drv_top_noxtalkoff, View - schematic
// LAST TIME SAVED: Oct  4 09:58:04 2021
// NETLIST TIME: Oct  7 15:28:49 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_d2d_lane_drv_top_noxtalkoff ( 
output wire logic   pad, 
output wire logic   ser_lpb, 
inout wire logic   vdda, 
inout   vddq, 
inout wire logic   vss, 
input wire logic  [3:0] drv_imp, 
input wire logic   en, 
input wire logic   hiz, 
input wire logic   inn, 
input wire logic   inp, 
input wire logic  [2:0] preemp_en, 
input  [3:0] preemp_sec_dly, 
input wire logic  [2:0] preemp_sec_en, 
input wire logic   ser_lpb_en, 
input wire logic   serdes_byp_out, 
input wire logic   serdes_byp_sel );


wire logic byp_en ;

wire logic byp_enb ;

wire logic byp_datb ;

wire logic n0 ;

wire logic byp_path_enb ;

wire logic p1 ;

wire logic n1 ;

wire logic n2 ;

wire logic p2 ;

wire logic p3 ;

wire logic n3 ;

wire logic main_path_enb ;

wire logic hizb ;

wire logic p0 ;

wire logic slpb_en ;

wire logic slpb_enb ;

wire logic enandhizb ;

wire logic nn111 ;

wire logic main_path_en ;

wire logic preemp_sec_en_any ;

wire net040 ;

wire logic byp_path_en ;

wire logic net044 ;

// Buses in the design

wire logic [2:0]  pre2_en_int;

wire logic [3:0]  imp_ctrl;

wire logic [2:0]  pre_enb_int;

wire logic [3:0]  net050;

wire logic [2:0]  pre2_enb_int;

wire logic [2:0]  pre_en_int;



WavD2DAnalogPhy_8lane_gf12lpp_INV_D8_GL16_LVT INV11 ( .in(p0), .vss(vss), .out(n1), .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D8_GL16_LVT INV4 ( .in(n0), .vss(vss), .out(p1), .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D8_GL16_LVT INV12 ( .in(n1), .vss(vss), .out(p2), .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D8_GL16_LVT INV7 ( .in(p1), .vss(vss), .out(n2), .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_d2d_drv_slice_all DRV ( .inn(n3), .vddq(vddq), .vss(vss),
     .imp_ctrl({imp_ctrl[3], imp_ctrl[3], imp_ctrl[3], imp_ctrl[3],
     imp_ctrl[3], imp_ctrl[3], imp_ctrl[3], imp_ctrl[3], imp_ctrl[3],
     imp_ctrl[3], imp_ctrl[3], imp_ctrl[3], imp_ctrl[3], imp_ctrl[3],
     imp_ctrl[3], imp_ctrl[3], imp_ctrl[2], imp_ctrl[2], imp_ctrl[2],
     imp_ctrl[2], imp_ctrl[2], imp_ctrl[2], imp_ctrl[2], imp_ctrl[2],
     imp_ctrl[1], imp_ctrl[1], imp_ctrl[1], imp_ctrl[1], imp_ctrl[0],
     imp_ctrl[0], main_path_en, main_path_en}), .outp(pad), .inp(p3));
WavD2DAnalogPhy_8lane_gf12lpp_d2d_lane_drv_boost_dum I23 ( .vss(vss), .vdda(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_d2d_lane_drv_boost BOOST0[6:0] ( .out(pad), .vdda(vdda), .vss(vss),
     .en_prim({pre_en_int[2], pre_en_int[2], pre_en_int[2],
     pre_en_int[2], pre_en_int[1], pre_en_int[1], pre_en_int[0]}),
     .en_sec({pre2_en_int[2], pre2_en_int[2], pre2_en_int[2],
     pre2_en_int[2], pre2_en_int[1], pre2_en_int[1], pre2_en_int[0]}),
     .enb_prim({pre_enb_int[2], pre_enb_int[2], pre_enb_int[2],
     pre_enb_int[2], pre_enb_int[1], pre_enb_int[1], pre_enb_int[0]}),
     .enb_sec({pre2_enb_int[2], pre2_enb_int[2], pre2_enb_int[2],
     pre2_enb_int[2], pre2_enb_int[1], pre2_enb_int[1],
     pre2_enb_int[0]}), .prim(nn111), .sec(net040));
WavD2DAnalogPhy_8lane_gf12lpp_d2d_lpde Isec_boost_delay ( .outn(net040), .inp(p0),
     .en(preemp_sec_en_any), .sel(preemp_sec_dly[3:0]), .vdda(vdda),
     .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_NOR2_D1_GL16_LVT NOR32[3:0] ( .y(imp_ctrl[3:0]), .vdd(vdda), .vss(vss),
     .a(net050[3:0]), .b(byp_en), .tiehi(vdda), .tielo(vss));
WavD2DAnalogPhy_8lane_gf12lpp_NAND3_D1_GL16_LVT NAND4 ( .tielo(vss), .tiehi(vdda), .vdd(vdda),
     .y(preemp_sec_en_any), .vss(vss), .c(pre2_enb_int[2]),
     .b(pre2_enb_int[1]), .a(pre2_enb_int[0]));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV2 ( .in(net044), .vss(vss), .out(enandhizb),
     .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV24 ( .vdd(vdda), .in(serdes_byp_out), .vss(vss),
     .out(byp_datb));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV21 ( .vdd(vdda), .in(serdes_byp_sel), .vss(vss),
     .out(byp_enb));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV20 ( .vdd(vdda), .in(byp_enb), .vss(vss),
     .out(byp_en));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV17[2:0] ( .out(pre2_en_int[2:0]), .vdd(vdda),
     .vss(vss), .in(pre2_enb_int[2:0]));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV3 ( .vdd(vdda), .in(hiz), .vss(vss), .out(hizb));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV8 ( .vdd(vdda), .in(ser_lpb_en), .vss(vss),
     .out(slpb_enb));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV9 ( .vdd(vdda), .in(slpb_enb), .vss(vss),
     .out(slpb_en));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV26 ( .vdd(vdda), .in(byp_path_enb), .vss(vss),
     .out(byp_path_en));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV27 ( .vdd(vdda), .in(main_path_enb), .vss(vss),
     .out(main_path_en));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV6[2:0] ( .out(pre_en_int[2:0]), .vdd(vdda),
     .vss(vss), .in(pre_enb_int[2:0]));
WavD2DAnalogPhy_8lane_gf12lpp_hbm_d2d Iesdq ( .vdd(vdda), .pad(pad), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_d2d_vddq_cap C0[13:0] ( .vddq(vddq), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_XG_D1_GL16_LVT XGATE0[3:0] ( .y(ser_lpb), .vdd(vdda), .vss(vss),
     .a(pad), .en(slpb_en), .enb(slpb_enb));
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUMLOAD_D2_GL16_LVT INV14 ( .vdd(vdda), .inn(n0), .vss(vss), .inp(n0));*/
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUMLOAD_D2_GL16_LVT INV0[7:0] ( .vdd(vdda), .vss(vss), .inn(p1),
     .inp(p1));*/
WavD2DAnalogPhy_8lane_gf12lpp_INV_D4_GL16_LVT INVT1 ( .out(n0), .vss(vss), .in(inp), .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D4_GL16_LVT INVT0 ( .out(p0), .vss(vss), .in(inn), .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D16_GL16_LVT INV19 ( .in(n1), .vss(vss), .out(nn111), .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D16_GL16_LVT INV30 ( .in(n2), .vss(vss), .out(p3), .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D16_GL16_LVT INV5 ( .in(p2), .vss(vss), .out(n3), .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_d2d_INVT_D2_GL16_LVT_withR INVT2 ( .out(pad), .en(byp_path_en),
     .enb(byp_path_enb), .vss(vss), .in(byp_datb), .vdd(vdda));
WavD2DAnalogPhy_8lane_gf12lpp_d2d_drv_slice_dum_x2 I24 ( .vss(vss));
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUM_D1_GL16_LVT Dumcmos[91:0] ( .vdd(vdda), .vss(vss), .tiehi(vdda),
     .tielo(vss));*/
WavD2DAnalogPhy_8lane_gf12lpp_NAND2_D1_GL16_LVT NAND7[3:0] ( .y(net050[3:0]), .vdd(vdda), .vss(vss),
     .a(enandhizb), .b(drv_imp[3:0]), .tiehi(vdda), .tielo(vss));
WavD2DAnalogPhy_8lane_gf12lpp_NAND2_D1_GL16_LVT NAND6 ( .tielo(vss), .tiehi(vdda), .vdd(vdda),
     .y(net044), .vss(vss), .b(en), .a(hizb));
WavD2DAnalogPhy_8lane_gf12lpp_NAND2_D1_GL16_LVT NAND2[2:0] ( .y(pre2_enb_int[2:0]), .vdd(vdda),
     .vss(vss), .a(enandhizb), .b(preemp_sec_en[2:0]), .tiehi(vdda),
     .tielo(vss));
WavD2DAnalogPhy_8lane_gf12lpp_NAND2_D1_GL16_LVT NAND3 ( .tielo(vss), .tiehi(vdda), .vdd(vdda),
     .y(main_path_enb), .vss(vss), .b(byp_enb), .a(enandhizb));
WavD2DAnalogPhy_8lane_gf12lpp_NAND2_D1_GL16_LVT NAND1 ( .tielo(vss), .tiehi(vdda), .vdd(vdda),
     .y(byp_path_enb), .vss(vss), .b(byp_en), .a(enandhizb));
WavD2DAnalogPhy_8lane_gf12lpp_NAND2_D1_GL16_LVT NAND0[2:0] ( .y(pre_enb_int[2:0]), .vdd(vdda),
     .vss(vss), .a(enandhizb), .b(preemp_en[2:0]), .tiehi(vdda),
     .tielo(vss));

endmodule
// Library - wphy_gf12lp_d2d_serdes_lib, Cell - d2d_serializer_2to1_v2,
//View - schematic
// LAST TIME SAVED: Oct  2 16:06:56 2020
// NETLIST TIME: Oct  7 15:28:49 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_d2d_serializer_2to1_v2 ( 
output   y, 
inout wire logic   vdd, 
inout wire logic   vss, 
input wire logic   clk, 
input wire logic   clkb, 
input   even, 
input wire logic   odd );


wire logic q ;



WavD2DAnalogPhy_8lane_gf12lpp_LAT_D1_GL16_LVT_HZ I81 ( .vdda(vdd), .vss(vss), .d(even), .clkb(clkb),
     .clk(clk), .q(y));
WavD2DAnalogPhy_8lane_gf12lpp_LAT_D1_GL16_LVT_HZ LA2 ( .vdda(vdd), .vss(vss), .d(q), .clkb(clk),
     .clk(clkb), .q(y));
WavD2DAnalogPhy_8lane_gf12lpp_LAT_D1_GL16_LVT LA3 ( .tielo(vss), .tiehi(vdd), .vdd(vdd), .vss(vss),
     .d(odd), .clkb(clkb), .clk(clk), .q(q));

endmodule
// Library - wphy_gf12lp_d2d_serdes_lib, Cell - d2d_serializer_2to1_v3,
//View - schematic
// LAST TIME SAVED: Oct  2 16:06:56 2020
// NETLIST TIME: Oct  7 15:28:49 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_d2d_serializer_2to1_v3 ( 
output   y, 
inout wire logic   vdd, 
inout wire logic   vss, 
input wire logic   clk, 
input wire logic   clkb, 
input   even, 
input wire logic   odd );


wire logic q ;



WavD2DAnalogPhy_8lane_gf12lpp_LAT_D2_GL16_LVT_HZ I81 ( .vdda(vdd), .vss(vss), .d(even), .clkb(clkb),
     .clk(clk), .q(y));
WavD2DAnalogPhy_8lane_gf12lpp_LAT_D2_GL16_LVT_HZ LA2 ( .vdda(vdd), .vss(vss), .d(q), .clkb(clk),
     .clk(clkb), .q(y));
WavD2DAnalogPhy_8lane_gf12lpp_LAT_D1_GL16_LVT LA3 ( .tielo(vss), .tiehi(vdd), .vdd(vdd), .vss(vss),
     .d(odd), .clkb(clkb), .clk(clk), .q(q));

endmodule
// Library - wphy_gf12lp_d2d_serdes_lib, Cell -
//d2d_serializer_2to1_d2_slvt, View - schematic
// LAST TIME SAVED: Aug  4 10:19:58 2021
// NETLIST TIME: Oct  7 15:28:49 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_d2d_serializer_2to1_d2_slvt ( 
output   y, 
inout wire logic   vdda, 
inout wire logic   vss, 
input wire logic   clk, 
input wire logic   clkb, 
input   even, 
input wire logic   odd );


wire logic net12 ;



WavD2DAnalogPhy_8lane_gf12lpp_LAT_D1_GL40_SLVT_HZ LA1 ( .vdda(vdda), .vss(vss), .d(even),
     .clkb(clkb), .clk(clk), .q(y));
WavD2DAnalogPhy_8lane_gf12lpp_LAT_D1_GL40_SLVT_HZ LA2 ( .vdda(vdda), .vss(vss), .d(net12),
     .clkb(clk), .clk(clkb), .q(y));
WavD2DAnalogPhy_8lane_gf12lpp_LAT_D1_GL16_SLVT LA0 ( .tielo(vss), .tiehi(vdda), .vdd(vdda),
     .vss(vss), .d(odd), .clkb(clkb), .clk(clk), .q(net12));

endmodule
// Library - wphy_gf12lp_d2d_serdes_lib, Cell -
//d2d_serializer_16to1_v2, View - schematic
// LAST TIME SAVED: Oct  4 09:55:18 2021
// NETLIST TIME: Oct  7 15:28:49 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_d2d_serializer_16to1_v2 ( 
output wire logic   clk_div16, 
output wire logic   sdata, 
output wire logic   sdatab, 
inout wire logic   vdda, 
inout wire logic   vss, 
input wire logic   clk_div2_in, 
input wire logic   clk_div4_in, 
input wire logic   clk_div8_in, 
input wire logic   clk_div16_in, 
input wire logic   clkb_div2_in, 
input wire logic  [15:0] data, 
input wire logic   en );


wire logic net042 ;

wire logic enb ;

wire logic en_buf ;

wire logic clk_div8 ;

wire logic clkb_div8 ;

wire n1n9 ;

wire n3n11 ;

wire logic clk_div16_buf ;

wire logic clkb_div16 ;

wire logic n3n7n11n15 ;

wire logic n6n14 ;

wire n2n10 ;

wire logic n0n2n4n6n8n10n12n14 ;

wire logic n1n3n5n7n9n11n13n15 ;

wire n0n4n8n12 ;

wire logic n2n6n10n14 ;

wire n0n8 ;

wire logic n4n12 ;

wire logic n7n15 ;

wire logic clk_div4 ;

wire n1n5n9n13 ;

wire logic n5n13 ;

wire logic clkb_div4 ;

wire logic clk_div2_buf ;

wire logic n2 ;

wire logic p2 ;

wire logic clkb_div2_buf ;

wire logic clk_div16_ff ;

wire logic clkb_div16_ff ;

wire logic clk_div2d ;

wire logic clkb_div2d ;

wire logic n1 ;

wire logic p1 ;

wire logic net047 ;

wire logic net048 ;

// Buses in the design

wire logic [15:0]  pdata;



/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUM_D1_GL16_SLVT Icdmum_slvt[37:0] ( .vdd(vdda), .vss(vss),
     .tiehi(vdda), .tielo(vss));*/
WavD2DAnalogPhy_8lane_gf12lpp_PD_D2_GL16_LVT PD2 ( .vss(vss), .enb(enb), .y(clkb_div8));
WavD2DAnalogPhy_8lane_gf12lpp_PD_D2_GL16_LVT PD0 ( .vss(vss), .enb(enb), .y(clkb_div4));
WavD2DAnalogPhy_8lane_gf12lpp_PD_D2_GL16_LVT PD1 ( .vss(vss), .enb(enb), .y(clk_div2_buf));
WavD2DAnalogPhy_8lane_gf12lpp_PD_D2_GL16_LVT PD3 ( .vss(vss), .enb(enb), .y(clkb_div16));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_SLVT INV35 ( .vdd(vdda), .in(n0n2n4n6n8n10n12n14),
     .vss(vss), .out(net047));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_SLVT INV34 ( .vdd(vdda), .in(n1n3n5n7n9n11n13n15),
     .vss(vss), .out(net048));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_SLVT INV53[2:0] ( .out(sdata), .vdd(vdda), .vss(vss),
     .in(n2));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_SLVT INV54[2:0] ( .out(sdatab), .vdd(vdda), .vss(vss),
     .in(p2));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_SLVT INV51 ( .vdd(vdda), .in(n1), .vss(vss), .out(p2));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_SLVT INV1 ( .vdd(vdda), .in(p1), .vss(vss), .out(n2));
WavD2DAnalogPhy_8lane_gf12lpp_INVT_D2_GL16_LVT INV11[3:0] ( .out(clkb_div4), .vdd(vdda), .vss(vss),
     .en(en_buf), .enb(enb), .in(clk_div4_in));
WavD2DAnalogPhy_8lane_gf12lpp_INVT_D2_GL16_LVT INV13[3:0] ( .out(clkb_div2_buf), .vdd(vdda),
     .vss(vss), .en(en_buf), .enb(enb), .in(clk_div2_in));
WavD2DAnalogPhy_8lane_gf12lpp_INVT_D2_GL16_LVT INV12[3:0] ( .out(clk_div2_buf), .vdd(vdda),
     .vss(vss), .en(en_buf), .enb(enb), .in(clkb_div2_in));
WavD2DAnalogPhy_8lane_gf12lpp_INVT_D2_GL16_LVT INV8[3:0] ( .out(clkb_div8), .vdd(vdda), .vss(vss),
     .en(en_buf), .enb(enb), .in(clk_div8_in));
WavD2DAnalogPhy_8lane_gf12lpp_INVT_D2_GL16_LVT INV10[3:0] ( .out(clkb_div16), .vdd(vdda), .vss(vss),
     .en(en_buf), .enb(enb), .in(clk_div16_in));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV46[3:0] ( .out(clk_div8), .vdd(vdda), .vss(vss),
     .in(clkb_div8));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV47[3:0] ( .out(clk_div16_buf), .vdd(vdda),
     .vss(vss), .in(clkb_div16));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV57 ( .vdd(vdda), .in(clk_div16_buf), .vss(vss),
     .out(net042));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV56[3:0] ( .out(clk_div16), .vdd(vdda), .vss(vss),
     .in(net042));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV40[1:0] ( .out(en_buf), .vdd(vdda), .vss(vss),
     .in(enb));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV43[3:0] ( .out(clk_div2d), .vdd(vdda), .vss(vss),
     .in(clkb_div2_buf));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV44[3:0] ( .out(clkb_div2d), .vdd(vdda), .vss(vss),
     .in(clk_div2_buf));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV59[3:0] ( .out(clk_div16_ff), .vdd(vdda), .vss(vss),
     .in(clkb_div16_ff));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV45[3:0] ( .out(clk_div4), .vdd(vdda), .vss(vss),
     .in(clkb_div4));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV39[1:0] ( .out(enb), .vdd(vdda), .vss(vss),
     .in(en));
WavD2DAnalogPhy_8lane_gf12lpp_INV_D2_GL16_LVT INV58[3:0] ( .out(clkb_div16_ff), .vdd(vdda),
     .vss(vss), .in(clk_div16_buf));
WavD2DAnalogPhy_8lane_gf12lpp_PU_D2_GL16_LVT PU1 ( .en(en_buf), .vdd(vdda), .y(clkb_div2_buf));
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_PDDUM_D2_GL16_LVT PDdum1 ( .tielo(en_buf), .vss(vss));*/
WavD2DAnalogPhy_8lane_gf12lpp_d2d_serializer_2to1_v2 I2TO1_46 ( .vdd(vdda), .y(n3n7n11n15),
     .clkb(clkb_div8), .even(n3n11), .odd(n7n15), .clk(clk_div8),
     .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_d2d_serializer_2to1_v2 I2TO1_45 ( .vdd(vdda), .y(n1n5n9n13),
     .clkb(clkb_div8), .even(n1n9), .odd(n5n13), .clk(clk_div8),
     .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_d2d_serializer_2to1_v2 I2TO1_44 ( .vdd(vdda), .y(n2n6n10n14),
     .clkb(clkb_div8), .even(n2n10), .odd(n6n14), .clk(clk_div8),
     .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_d2d_serializer_2to1_v2 I2TO1_29 ( .vdd(vdda), .y(n7n15),
     .clkb(clkb_div16), .even(pdata[7]), .odd(pdata[15]),
     .clk(clk_div16_buf), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_d2d_serializer_2to1_v2 I2TO1_26 ( .vdd(vdda), .y(n3n11),
     .clkb(clkb_div16), .even(pdata[3]), .odd(pdata[11]),
     .clk(clk_div16_buf), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_d2d_serializer_2to1_v2 I2TO1_23 ( .vdd(vdda), .y(n5n13),
     .clkb(clkb_div16), .even(pdata[5]), .odd(pdata[13]),
     .clk(clk_div16_buf), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_d2d_serializer_2to1_v2 I2TO1_20 ( .vdd(vdda), .y(n1n9),
     .clkb(clkb_div16), .even(pdata[1]), .odd(pdata[9]),
     .clk(clk_div16_buf), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_d2d_serializer_2to1_v2 I2TO1_17 ( .vdd(vdda), .y(n6n14),
     .clkb(clkb_div16), .even(pdata[6]), .odd(pdata[14]),
     .clk(clk_div16_buf), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_d2d_serializer_2to1_v2 I2TO1_14 ( .vdd(vdda), .y(n2n10),
     .clkb(clkb_div16), .even(pdata[2]), .odd(pdata[10]),
     .clk(clk_div16_buf), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_d2d_serializer_2to1_v2 I2TO1_11 ( .vdd(vdda), .y(n4n12),
     .clkb(clkb_div16), .even(pdata[4]), .odd(pdata[12]),
     .clk(clk_div16_buf), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_d2d_serializer_2to1_v2 I2TO1_8 ( .vdd(vdda), .y(n0n8),
     .clkb(clkb_div16), .even(pdata[0]), .odd(pdata[8]),
     .clk(clk_div16_buf), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_d2d_serializer_2to1_v2 I2TO1_5 ( .vdd(vdda), .y(n0n4n8n12),
     .clkb(clkb_div8), .even(n0n8), .odd(n4n12), .clk(clk_div8),
     .vss(vss));
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_PUDUM_D2_GL16_LVT PUdum1 ( .tiehi(enb), .vdd(vdda));*/
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_PUDUM_D2_GL16_LVT PUdum[2:0] ( .vdd(vdda), .tiehi(vdda));*/
WavD2DAnalogPhy_8lane_gf12lpp_FF_D1_GL16_LVT FF0[15:0] ( .q(pdata[15:0]), .vdd(vdda), .vss(vss),
     .clk(clk_div16_ff), .clkb(clkb_div16_ff), .d(data[15:0]),
     .tiehi(vdda), .tielo(vss));
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUM_D1_GL16_LVT Icdum[398:0] ( .vdd(vdda), .vss(vss), .tiehi(vdda),
     .tielo(vss));*/
WavD2DAnalogPhy_8lane_gf12lpp_d2d_serializer_2to1_v3 I2TO1_49 ( .vdd(vdda), .y(n1n3n5n7n9n11n13n15),
     .clkb(clkb_div4), .even(n1n5n9n13), .odd(n3n7n11n15),
     .clk(clk_div4), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_d2d_serializer_2to1_v3 I2TO1_48 ( .vdd(vdda), .y(n0n2n4n6n8n10n12n14),
     .clkb(clkb_div4), .even(n0n4n8n12), .odd(n2n6n10n14),
     .clk(clk_div4), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_d2d_serializer_2to1_d2_slvt I2TO1_50 ( .vdda(vdda), .y(p1),
     .clkb(clkb_div2d), .even(n0n2n4n6n8n10n12n14),
     .odd(n1n3n5n7n9n11n13n15), .clk(clk_div2d), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_d2d_serializer_2to1_d2_slvt I2TO1_1 ( .vdda(vdda), .y(n1),
     .clkb(clkb_div2d), .even(net047), .odd(net048), .clk(clk_div2d),
     .vss(vss));

endmodule
// Library - wphy_gf12lp_d2d_serdes_lib, Cell - wav_d2d_tx_ana, View -
//schematic
// LAST TIME SAVED: Apr 13 13:22:56 2021
// NETLIST TIME: Oct  7 15:28:49 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_wav_d2d_tx_ana ( 
output wire logic   pad_tx, 
output wire logic   tx_clk_div16, 
output wire logic   tx_ser_lpb, 
inout wire logic   vdda, 
inout   vddq, 
inout wire logic   vss, 
input wire logic   tx_clk_div2_in, 
input wire logic   tx_clk_div4_in, 
input wire logic   tx_clk_div8_in, 
input wire logic   tx_clk_div16_in, 
input wire logic   tx_clkb_div2_in, 
input  [5:0] tx_dly_ctrl, 
input   tx_dly_gear, 
input wire logic  [3:0] tx_drv_imp, 
input wire logic  [2:0] tx_drv_preem, 
input wire logic   tx_en, 
input wire logic   tx_highz, 
input  [3:0] tx_preemp_sec_dly, 
input wire logic  [2:0] tx_preemp_sec_en, 
input wire logic   tx_ser_lpb_en, 
input wire logic   tx_serdes_byp_out, 
input wire logic   tx_serdes_byp_sel, 
input wire logic  [15:0] tx_td );


wire logic serdatp ;

wire logic txn ;

wire logic txp ;

wire logic serdatn ;



WavD2DAnalogPhy_8lane_gf12lpp_d2d_lane_drv_top_noxtalkoff DRV ( .vddq(vddq),
     .drv_imp(tx_drv_imp[3:0]), .vdda(vdda),
     .serdes_byp_out(tx_serdes_byp_out),
     .serdes_byp_sel(tx_serdes_byp_sel),
     .preemp_sec_dly(tx_preemp_sec_dly[3:0]),
     .preemp_sec_en(tx_preemp_sec_en[2:0]),
     .preemp_en(tx_drv_preem[2:0]), .ser_lpb(tx_ser_lpb),
     .ser_lpb_en(tx_ser_lpb_en), .hiz(tx_highz), .pad(pad_tx),
     .en(tx_en), .inn(txn), .inp(txp), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_d2d_txdly BITDEL ( .outp(txp), .outn(txn), .inp(serdatp),
     .inn(serdatn), .gear(tx_dly_gear), .ctrl(tx_dly_ctrl[5:0]),
     .vdda(vdda), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_d2d_serializer_16to1_v2 S2P ( .vdda(vdda),
     .clk_div16_in(tx_clk_div16_in), .clk_div2_in(tx_clk_div2_in),
     .clkb_div2_in(tx_clkb_div2_in), .sdatab(serdatn),
     .clk_div16(tx_clk_div16), .sdata(serdatp),
     .clk_div8_in(tx_clk_div8_in), .data(tx_td[15:0]),
     .clk_div4_in(tx_clk_div4_in), .en(tx_en), .vss(vss));

endmodule
// Library - wphy_gf12lp_d2d_serdes_lib, Cell - wav_wlink_8l_tx_ana,
//View - schematic
// LAST TIME SAVED: Oct  6 14:13:30 2021
// NETLIST TIME: Oct  7 15:28:49 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_wav_wlink_8l_tx_ana ( 
output wire logic   clk_tx_coreclk_div16, 
output wire logic   clk_tx_ser_lpb_n, 
output wire logic   clk_tx_ser_lpb_p, 
output wire logic   pad_tx0, 
output wire logic   pad_tx1, 
output wire logic   pad_tx2, 
output wire logic   pad_tx3, 
output wire logic   pad_tx4, 
output wire logic   pad_tx5, 
output wire logic   pad_tx6, 
output wire logic   pad_tx7, 
output wire logic   tx0_ser_lpb, 
output wire logic   tx0_tclk_div16, 
output wire logic   tx1_ser_lpb, 
output wire logic   tx1_tclk_div16, 
output wire logic   tx2_ser_lpb, 
output wire logic   tx2_tclk_div16, 
output wire logic   tx3_ser_lpb, 
output wire logic   tx3_tclk_div16, 
output wire logic   tx4_ser_lpb, 
output wire logic   tx4_tclk_div16, 
output wire logic   tx5_ser_lpb, 
output wire logic   tx5_tclk_div16, 
output wire logic   tx6_ser_lpb, 
output wire logic   tx6_tclk_div16, 
output wire logic   tx7_ser_lpb, 
output wire logic   tx7_tclk_div16, 
inout wire logic   pad_clk_txn, 
inout wire logic   pad_clk_txp, 
inout wire logic   vdda, 
inout wire logic   vdda_ck, 
inout   vddq, 
inout wire logic   vss, 
input wire logic   clk_tx_drv_bypass_out_n, 
input wire logic   clk_tx_drv_bypass_out_p, 
input wire logic   clk_tx_drv_bypass_sel, 
input wire logic  [3:0] clk_tx_drv_ctrl, 
input wire logic   clk_tx_drv_en, 
input wire logic  [2:0] clk_tx_drv_preemp, 
input wire logic   clk_tx_en_tx_div2_clk, 
input wire logic   clk_tx_en_tx_div16_clk, 
input wire logic   clk_tx_reset_sync, 
input wire logic   clk_tx_ser_lpb_en, 
input wire logic   pll_clk0, 
input wire logic   pll_clk180, 
input  [5:0] tx0_dly_ctrl, 
input   tx0_dly_gear, 
input wire logic  [3:0] tx0_drv_imp, 
input wire logic  [2:0] tx0_drv_preem, 
input wire logic   tx0_en, 
input wire logic   tx0_highz, 
input  [3:0] tx0_preemp_sec_dly, 
input wire logic  [2:0] tx0_preemp_sec_en, 
input wire logic   tx0_ser_lpb_en, 
input wire logic   tx0_serdes_byp_out, 
input wire logic   tx0_serdes_byp_sel, 
input wire logic  [15:0] tx0_td, 
input  [5:0] tx1_dly_ctrl, 
input   tx1_dly_gear, 
input wire logic  [3:0] tx1_drv_imp, 
input wire logic  [2:0] tx1_drv_preem, 
input wire logic   tx1_en, 
input wire logic   tx1_highz, 
input  [3:0] tx1_preemp_sec_dly, 
input wire logic  [2:0] tx1_preemp_sec_en, 
input wire logic   tx1_ser_lpb_en, 
input wire logic   tx1_serdes_byp_out, 
input wire logic   tx1_serdes_byp_sel, 
input wire logic  [15:0] tx1_td, 
input  [5:0] tx2_dly_ctrl, 
input   tx2_dly_gear, 
input wire logic  [3:0] tx2_drv_imp, 
input wire logic  [2:0] tx2_drv_preem, 
input wire logic   tx2_en, 
input wire logic   tx2_highz, 
input  [3:0] tx2_preemp_sec_dly, 
input wire logic  [2:0] tx2_preemp_sec_en, 
input wire logic   tx2_ser_lpb_en, 
input wire logic   tx2_serdes_byp_out, 
input wire logic   tx2_serdes_byp_sel, 
input wire logic  [15:0] tx2_td, 
input  [5:0] tx3_dly_ctrl, 
input   tx3_dly_gear, 
input wire logic  [3:0] tx3_drv_imp, 
input wire logic  [2:0] tx3_drv_preem, 
input wire logic   tx3_en, 
input wire logic   tx3_highz, 
input  [3:0] tx3_preemp_sec_dly, 
input wire logic  [2:0] tx3_preemp_sec_en, 
input wire logic   tx3_ser_lpb_en, 
input wire logic   tx3_serdes_byp_out, 
input wire logic   tx3_serdes_byp_sel, 
input wire logic  [15:0] tx3_td, 
input  [5:0] tx4_dly_ctrl, 
input   tx4_dly_gear, 
input wire logic  [3:0] tx4_drv_imp, 
input wire logic  [2:0] tx4_drv_preem, 
input wire logic   tx4_en, 
input wire logic   tx4_highz, 
input  [3:0] tx4_preemp_sec_dly, 
input wire logic  [2:0] tx4_preemp_sec_en, 
input wire logic   tx4_ser_lpb_en, 
input wire logic   tx4_serdes_byp_out, 
input wire logic   tx4_serdes_byp_sel, 
input wire logic  [15:0] tx4_td, 
input  [5:0] tx5_dly_ctrl, 
input   tx5_dly_gear, 
input wire logic  [3:0] tx5_drv_imp, 
input wire logic  [2:0] tx5_drv_preem, 
input wire logic   tx5_en, 
input wire logic   tx5_highz, 
input  [3:0] tx5_preemp_sec_dly, 
input wire logic  [2:0] tx5_preemp_sec_en, 
input wire logic   tx5_ser_lpb_en, 
input wire logic   tx5_serdes_byp_out, 
input wire logic   tx5_serdes_byp_sel, 
input wire logic  [15:0] tx5_td, 
input  [5:0] tx6_dly_ctrl, 
input   tx6_dly_gear, 
input wire logic  [3:0] tx6_drv_imp, 
input wire logic  [2:0] tx6_drv_preem, 
input wire logic   tx6_en, 
input wire logic   tx6_highz, 
input  [3:0] tx6_preemp_sec_dly, 
input wire logic  [2:0] tx6_preemp_sec_en, 
input wire logic   tx6_ser_lpb_en, 
input wire logic   tx6_serdes_byp_out, 
input wire logic   tx6_serdes_byp_sel, 
input wire logic  [15:0] tx6_td, 
input  [5:0] tx7_dly_ctrl, 
input   tx7_dly_gear, 
input wire logic  [3:0] tx7_drv_imp, 
input wire logic  [2:0] tx7_drv_preem, 
input wire logic   tx7_en, 
input wire logic   tx7_highz, 
input  [3:0] tx7_preemp_sec_dly, 
input wire logic  [2:0] tx7_preemp_sec_en, 
input wire logic   tx7_ser_lpb_en, 
input wire logic   tx7_serdes_byp_out, 
input wire logic   tx7_serdes_byp_sel, 
input wire logic  [15:0] tx7_td );


wire logic tx_clk_div8 ;

wire logic tx_clkb_div2 ;

wire logic tx_clk_div2 ;

wire logic tx_clk_div4 ;

wire logic tx_clk_div16 ;



WavD2DAnalogPhy_8lane_gf12lpp_wav_d2d_clk_ana_tx ICLK_TX ( .clk_tx_ser_lpb_n(clk_tx_ser_lpb_n),
     .vddq(vddq), .clk_tx_drv_bypass_out_n(clk_tx_drv_bypass_out_n),
     .clk_tx_drv_bypass_out_p(clk_tx_drv_bypass_out_p),
     .clk_tx_ser_lpb_p(clk_tx_ser_lpb_p), .pad_clkn_txrx(pad_clk_txn),
     .vdda(vdda_ck), .clk_tx_pll_clk0(pll_clk0),
     .clk_tx_drv_en(clk_tx_drv_en),
     .clk_tx_drv_bypass_sel(clk_tx_drv_bypass_sel),
     .clk_tx_ser_lpb_en(clk_tx_ser_lpb_en),
     .clk_tx_en_tx_div16_clk(clk_tx_en_tx_div16_clk),
     .clk_tx_drv_ctrl(clk_tx_drv_ctrl[3:0]),
     .clk_tx_clk_div8(tx_clk_div8), .clk_tx_clk_div4(tx_clk_div4),
     .clk_tx_clk_div2(tx_clk_div2), .pad_clkp_txrx(pad_clk_txp),
     .vss(vss), .clk_tx_drv_preemp(clk_tx_drv_preemp[2:0]),
     .clk_tx_clkb_div2(tx_clkb_div2), .clk_tx_clk_div16(tx_clk_div16),
     .clk_tx_en_tx_div2_clk(clk_tx_en_tx_div2_clk),
     .clk_tx_coreclk_div16(clk_tx_coreclk_div16),
     .clk_tx_pll_clk180(pll_clk180),
     .clk_tx_reset_sync(clk_tx_reset_sync));
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUM_D1_GL16_LVT cmosdum[599:0] ( .vdd(vdda), .vss(vss), .tiehi(vdda),
     .tielo(vss));*/
WavD2DAnalogPhy_8lane_gf12lpp_d2d_drv_slice_dum I32[2:0] ( .vss(vss));
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_cmos_cap C2[77:0] ( .plus(vdda_ck), .vss(vss));*/
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_cmos_cap C0[389:0] ( .plus(vdda), .vss(vss));*/
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_MOSMOM_LV_N_THIN C1[71:0] ( .MINUS(vss), .PLUS(vdda));*/
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_MOSMOM_LV_N_THIN C3 ( .MINUS(vss), .PLUS(vdda_ck));*/
/*REMOVED VIA SCRIPT -- WavD2DAnalogPhy_8lane_gf12lpp_DUM_D1_GL16_SLVT DUM0[59:0] ( .vdd(vdda), .vss(vss), .tiehi(vdda),
     .tielo(vss));*/
WavD2DAnalogPhy_8lane_gf12lpp_wav_d2d_tx_ana ITX7 ( .tx_dly_gear(tx7_dly_gear), .tx_td(tx7_td[15:0]),
     .tx_drv_imp(tx7_drv_imp[3:0]), .tx_clk_div4_in(tx_clk_div4),
     .tx_dly_ctrl(tx7_dly_ctrl[5:0]),
     .tx_preemp_sec_en(tx7_preemp_sec_en[2:0]),
     .tx_ser_lpb(tx7_ser_lpb), .tx_clkb_div2_in(tx_clkb_div2),
     .tx_serdes_byp_sel(tx7_serdes_byp_sel),
     .tx_clk_div8_in(tx_clk_div8),
     .tx_serdes_byp_out(tx7_serdes_byp_out),
     .tx_ser_lpb_en(tx7_ser_lpb_en), .tx_drv_preem(tx7_drv_preem[2:0]),
     .tx_clk_div2_in(tx_clk_div2), .tx_clk_div16(tx7_tclk_div16),
     .tx_preemp_sec_dly(tx7_preemp_sec_dly[3:0]), .pad_tx(pad_tx7),
     .tx_clk_div16_in(tx_clk_div16), .vddq(vddq), .vss(vss),
     .vdda(vdda), .tx_highz(tx7_highz), .tx_en(tx7_en));
WavD2DAnalogPhy_8lane_gf12lpp_wav_d2d_tx_ana ITX3 ( .tx_dly_gear(tx3_dly_gear), .tx_td(tx3_td[15:0]),
     .tx_drv_imp(tx3_drv_imp[3:0]), .tx_clk_div4_in(tx_clk_div4),
     .tx_dly_ctrl(tx3_dly_ctrl[5:0]),
     .tx_preemp_sec_en(tx3_preemp_sec_en[2:0]),
     .tx_ser_lpb(tx3_ser_lpb), .tx_clkb_div2_in(tx_clkb_div2),
     .tx_serdes_byp_sel(tx3_serdes_byp_sel),
     .tx_clk_div8_in(tx_clk_div8),
     .tx_serdes_byp_out(tx3_serdes_byp_out),
     .tx_ser_lpb_en(tx3_ser_lpb_en), .tx_drv_preem(tx3_drv_preem[2:0]),
     .tx_clk_div2_in(tx_clk_div2), .tx_clk_div16(tx3_tclk_div16),
     .tx_preemp_sec_dly(tx3_preemp_sec_dly[3:0]), .pad_tx(pad_tx3),
     .tx_clk_div16_in(tx_clk_div16), .vddq(vddq), .vss(vss),
     .vdda(vdda), .tx_highz(tx3_highz), .tx_en(tx3_en));
WavD2DAnalogPhy_8lane_gf12lpp_wav_d2d_tx_ana ITX6 ( .tx_dly_gear(tx6_dly_gear), .tx_td(tx6_td[15:0]),
     .tx_drv_imp(tx6_drv_imp[3:0]), .tx_clk_div4_in(tx_clk_div4),
     .tx_dly_ctrl(tx6_dly_ctrl[5:0]),
     .tx_preemp_sec_en(tx6_preemp_sec_en[2:0]),
     .tx_ser_lpb(tx6_ser_lpb), .tx_clkb_div2_in(tx_clkb_div2),
     .tx_serdes_byp_sel(tx6_serdes_byp_sel),
     .tx_clk_div8_in(tx_clk_div8),
     .tx_serdes_byp_out(tx6_serdes_byp_out),
     .tx_ser_lpb_en(tx6_ser_lpb_en), .tx_drv_preem(tx6_drv_preem[2:0]),
     .tx_clk_div2_in(tx_clk_div2), .tx_clk_div16(tx6_tclk_div16),
     .tx_preemp_sec_dly(tx6_preemp_sec_dly[3:0]), .pad_tx(pad_tx6),
     .tx_clk_div16_in(tx_clk_div16), .vddq(vddq), .vss(vss),
     .vdda(vdda), .tx_highz(tx6_highz), .tx_en(tx6_en));
WavD2DAnalogPhy_8lane_gf12lpp_wav_d2d_tx_ana ITX2 ( .tx_dly_gear(tx2_dly_gear), .tx_td(tx2_td[15:0]),
     .tx_drv_imp(tx2_drv_imp[3:0]), .tx_clk_div4_in(tx_clk_div4),
     .tx_dly_ctrl(tx2_dly_ctrl[5:0]),
     .tx_preemp_sec_en(tx2_preemp_sec_en[2:0]),
     .tx_ser_lpb(tx2_ser_lpb), .tx_clkb_div2_in(tx_clkb_div2),
     .tx_serdes_byp_sel(tx2_serdes_byp_sel),
     .tx_clk_div8_in(tx_clk_div8),
     .tx_serdes_byp_out(tx2_serdes_byp_out),
     .tx_ser_lpb_en(tx2_ser_lpb_en), .tx_drv_preem(tx2_drv_preem[2:0]),
     .tx_clk_div2_in(tx_clk_div2), .tx_clk_div16(tx2_tclk_div16),
     .tx_preemp_sec_dly(tx2_preemp_sec_dly[3:0]), .pad_tx(pad_tx2),
     .tx_clk_div16_in(tx_clk_div16), .vddq(vddq), .vss(vss),
     .vdda(vdda), .tx_highz(tx2_highz), .tx_en(tx2_en));
WavD2DAnalogPhy_8lane_gf12lpp_wav_d2d_tx_ana ITX5 ( .tx_dly_gear(tx5_dly_gear), .tx_td(tx5_td[15:0]),
     .tx_drv_imp(tx5_drv_imp[3:0]), .tx_clk_div4_in(tx_clk_div4),
     .tx_dly_ctrl(tx5_dly_ctrl[5:0]),
     .tx_preemp_sec_en(tx5_preemp_sec_en[2:0]),
     .tx_ser_lpb(tx5_ser_lpb), .tx_clkb_div2_in(tx_clkb_div2),
     .tx_serdes_byp_sel(tx5_serdes_byp_sel),
     .tx_clk_div8_in(tx_clk_div8),
     .tx_serdes_byp_out(tx5_serdes_byp_out),
     .tx_ser_lpb_en(tx5_ser_lpb_en), .tx_drv_preem(tx5_drv_preem[2:0]),
     .tx_clk_div2_in(tx_clk_div2), .tx_clk_div16(tx5_tclk_div16),
     .tx_preemp_sec_dly(tx5_preemp_sec_dly[3:0]), .pad_tx(pad_tx5),
     .tx_clk_div16_in(tx_clk_div16), .vddq(vddq), .vss(vss),
     .vdda(vdda), .tx_highz(tx5_highz), .tx_en(tx5_en));
WavD2DAnalogPhy_8lane_gf12lpp_wav_d2d_tx_ana ITX1 ( .tx_dly_gear(tx1_dly_gear), .tx_td(tx1_td[15:0]),
     .tx_drv_imp(tx1_drv_imp[3:0]), .tx_clk_div4_in(tx_clk_div4),
     .tx_dly_ctrl(tx1_dly_ctrl[5:0]),
     .tx_preemp_sec_en(tx1_preemp_sec_en[2:0]),
     .tx_ser_lpb(tx1_ser_lpb), .tx_clkb_div2_in(tx_clkb_div2),
     .tx_serdes_byp_sel(tx1_serdes_byp_sel),
     .tx_clk_div8_in(tx_clk_div8),
     .tx_serdes_byp_out(tx1_serdes_byp_out),
     .tx_ser_lpb_en(tx1_ser_lpb_en), .tx_drv_preem(tx1_drv_preem[2:0]),
     .tx_clk_div2_in(tx_clk_div2), .tx_clk_div16(tx1_tclk_div16),
     .tx_preemp_sec_dly(tx1_preemp_sec_dly[3:0]), .pad_tx(pad_tx1),
     .tx_clk_div16_in(tx_clk_div16), .vddq(vddq), .vss(vss),
     .vdda(vdda), .tx_highz(tx1_highz), .tx_en(tx1_en));
WavD2DAnalogPhy_8lane_gf12lpp_wav_d2d_tx_ana ITX4 ( .tx_dly_gear(tx4_dly_gear), .tx_td(tx4_td[15:0]),
     .tx_drv_imp(tx4_drv_imp[3:0]), .tx_clk_div4_in(tx_clk_div4),
     .tx_dly_ctrl(tx4_dly_ctrl[5:0]),
     .tx_preemp_sec_en(tx4_preemp_sec_en[2:0]),
     .tx_ser_lpb(tx4_ser_lpb), .tx_clkb_div2_in(tx_clkb_div2),
     .tx_serdes_byp_sel(tx4_serdes_byp_sel),
     .tx_clk_div8_in(tx_clk_div8),
     .tx_serdes_byp_out(tx4_serdes_byp_out),
     .tx_ser_lpb_en(tx4_ser_lpb_en), .tx_drv_preem(tx4_drv_preem[2:0]),
     .tx_clk_div2_in(tx_clk_div2), .tx_clk_div16(tx4_tclk_div16),
     .tx_preemp_sec_dly(tx4_preemp_sec_dly[3:0]), .pad_tx(pad_tx4),
     .tx_clk_div16_in(tx_clk_div16), .vddq(vddq), .vss(vss),
     .vdda(vdda), .tx_highz(tx4_highz), .tx_en(tx4_en));
WavD2DAnalogPhy_8lane_gf12lpp_wav_d2d_tx_ana ITX0 ( .tx_dly_gear(tx0_dly_gear), .tx_td(tx0_td[15:0]),
     .tx_drv_imp(tx0_drv_imp[3:0]), .tx_clk_div4_in(tx_clk_div4),
     .tx_dly_ctrl(tx0_dly_ctrl[5:0]),
     .tx_preemp_sec_en(tx0_preemp_sec_en[2:0]),
     .tx_ser_lpb(tx0_ser_lpb), .tx_clkb_div2_in(tx_clkb_div2),
     .tx_serdes_byp_sel(tx0_serdes_byp_sel),
     .tx_clk_div8_in(tx_clk_div8),
     .tx_serdes_byp_out(tx0_serdes_byp_out),
     .tx_ser_lpb_en(tx0_ser_lpb_en), .tx_drv_preem(tx0_drv_preem[2:0]),
     .tx_clk_div2_in(tx_clk_div2), .tx_clk_div16(tx0_tclk_div16),
     .tx_preemp_sec_dly(tx0_preemp_sec_dly[3:0]), .pad_tx(pad_tx0),
     .tx_clk_div16_in(tx_clk_div16), .vddq(vddq), .vss(vss),
     .vdda(vdda), .tx_highz(tx0_highz), .tx_en(tx0_en));

endmodule
// Library - wphy_gf12lp_d2d_serdes_lib, Cell - wav_wlink_8l_ana, View
//- schematic
// LAST TIME SAVED: Oct  2 06:48:24 2021
// NETLIST TIME: Oct  7 15:28:49 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp_wav_wlink_8l_ana ( 
output wire logic   clk_rx_coreclk_div16, 
output wire logic   clk_rx_dll_cal_dat, 
output wire logic   clk_rx_dtest, 
output wire logic   clk_rx_rcvr_bypass_in_n, 
output wire logic   clk_rx_rcvr_bypass_in_p, 
output wire logic   clk_tx_coreclk_div16, 
output wire logic   pad_clk_txn, 
output wire logic   pad_clk_txp, 
output wire logic   pad_tx0, 
output wire logic   pad_tx1, 
output wire logic   pad_tx2, 
output wire logic   pad_tx3, 
output wire logic   pad_tx4, 
output wire logic   pad_tx5, 
output wire logic   pad_tx6, 
output wire logic   pad_tx7, 
output wire logic   rx0_clk_div16, 
output wire logic  [15:0] rx0_idata, 
output wire logic  [15:0] rx0_qdata, 
output wire logic   rx0_serdes_byp_in, 
output wire logic   rx1_clk_div16, 
output wire logic  [15:0] rx1_idata, 
output wire logic  [15:0] rx1_qdata, 
output wire logic   rx1_serdes_byp_in, 
output wire logic   rx2_clk_div16, 
output wire logic  [15:0] rx2_idata, 
output wire logic  [15:0] rx2_qdata, 
output wire logic   rx2_serdes_byp_in, 
output wire logic   rx3_clk_div16, 
output wire logic  [15:0] rx3_idata, 
output wire logic  [15:0] rx3_qdata, 
output wire logic   rx3_serdes_byp_in, 
output wire logic   rx4_clk_div16, 
output wire logic  [15:0] rx4_idata, 
output wire logic  [15:0] rx4_qdata, 
output wire logic   rx4_serdes_byp_in, 
output wire logic   rx5_clk_div16, 
output wire logic  [15:0] rx5_idata, 
output wire logic  [15:0] rx5_qdata, 
output wire logic   rx5_serdes_byp_in, 
output wire logic   rx6_clk_div16, 
output wire logic  [15:0] rx6_idata, 
output wire logic  [15:0] rx6_qdata, 
output wire logic   rx6_serdes_byp_in, 
output wire logic   rx7_clk_div16, 
output wire logic  [15:0] rx7_idata, 
output wire logic  [15:0] rx7_qdata, 
output wire logic   rx7_serdes_byp_in, 
output  tie_hi, 
output  tie_lo, 
output wire logic   tx0_tclk_div16, 
output wire logic   tx1_tclk_div16, 
output wire logic   tx2_tclk_div16, 
output wire logic   tx3_tclk_div16, 
output wire logic   tx4_tclk_div16, 
output wire logic   tx5_tclk_div16, 
output wire logic   tx6_tclk_div16, 
output wire logic   tx7_tclk_div16, 
inout wire logic   vdda, 
inout wire logic   vdda_ck, 
inout wire logic   vddq, 
inout wire logic   vss, 
input wire logic   clk_rx_dll_cal_en, 
input wire logic  [5:0] clk_rx_dll_ctrl, 
input wire logic   clk_rx_dll_en, 
input wire logic  [1:0] clk_rx_dll_gear, 
input wire logic  [3:0] clk_rx_dtest_div, 
input wire logic   clk_rx_dtest_en, 
input wire logic   clk_rx_dtest_in, 
input wire logic   clk_rx_en_rx_div2_clk, 
input wire logic   clk_rx_en_rx_div16_clk, 
input wire logic  [15:0] clk_rx_i_pi_code, 
input wire logic   clk_rx_i_pi_en, 
input wire logic  [1:0] clk_rx_i_pi_quad, 
input wire logic  [3:0] clk_rx_pi_gear, 
input wire logic  [3:0] clk_rx_pi_xcpl, 
input wire logic  [15:0] clk_rx_q_pi_code, 
input wire logic   clk_rx_q_pi_en, 
input wire logic  [1:0] clk_rx_q_pi_quad, 
input wire logic   clk_rx_rcvr_ac_mode, 
input wire logic   clk_rx_rcvr_bypass_sel, 
input wire logic   clk_rx_rcvr_en, 
input wire logic   clk_rx_rcvr_fb_en, 
input wire logic  [3:0] clk_rx_rcvr_odt_ctrl, 
input wire logic   clk_rx_rcvr_odt_dc_mode, 
input wire logic   clk_rx_reset_sync, 
input wire logic   clk_rx_ser_lpb_en, 
input wire logic  [2:0] clk_rx_test_sel, 
input wire logic   clk_rx_vref_en, 
input wire logic  [5:0] clk_rx_vref_lvl, 
input wire logic   clk_tx_drv_bypass_out_n, 
input wire logic   clk_tx_drv_bypass_out_p, 
input wire logic   clk_tx_drv_bypass_sel, 
input wire logic  [3:0] clk_tx_drv_ctrl, 
input wire logic   clk_tx_drv_en, 
input wire logic  [2:0] clk_tx_drv_preemp, 
input wire logic   clk_tx_en_tx_div2_clk, 
input wire logic   clk_tx_en_tx_div16_clk, 
input wire logic   clk_tx_reset_sync, 
input wire logic   clk_tx_ser_lpb_en, 
input wire logic   pad_clk_rxn, 
input wire logic   pad_clk_rxp, 
input wire logic   pad_rx0, 
input wire logic   pad_rx1, 
input wire logic   pad_rx2, 
input wire logic   pad_rx3, 
input wire logic   pad_rx4, 
input wire logic   pad_rx5, 
input wire logic   pad_rx6, 
input wire logic   pad_rx7, 
input wire logic   pll_clk0, 
input wire logic   pll_clk180, 
input wire logic   rx0_cal_en, 
input wire logic   rx0_i_en, 
input wire logic  [3:0] rx0_odt, 
input wire logic   rx0_odt_dc_mode, 
input wire logic   rx0_osc_dir_i_dp, 
input wire logic   rx0_osc_dir_ib_dp, 
input wire logic   rx0_osc_dir_q_dp, 
input wire logic   rx0_osc_dir_qb_dp, 
input wire logic  [3:0] rx0_osc_i_dp, 
input wire logic  [3:0] rx0_osc_ib_dp, 
input wire logic  [3:0] rx0_osc_q_dp, 
input wire logic  [3:0] rx0_osc_qb_dp, 
input wire logic   rx0_q_en, 
input wire logic   rx0_serdes_byp_sel, 
input wire logic   rx0_serlb_en, 
input wire logic   rx1_cal_en, 
input wire logic   rx1_i_en, 
input wire logic  [3:0] rx1_odt, 
input wire logic   rx1_odt_dc_mode, 
input wire logic   rx1_osc_dir_i_dp, 
input wire logic   rx1_osc_dir_ib_dp, 
input wire logic   rx1_osc_dir_q_dp, 
input wire logic   rx1_osc_dir_qb_dp, 
input wire logic  [3:0] rx1_osc_i_dp, 
input wire logic  [3:0] rx1_osc_ib_dp, 
input wire logic  [3:0] rx1_osc_q_dp, 
input wire logic  [3:0] rx1_osc_qb_dp, 
input wire logic   rx1_q_en, 
input wire logic   rx1_serdes_byp_sel, 
input wire logic   rx1_serlb_en, 
input wire logic   rx2_cal_en, 
input wire logic   rx2_i_en, 
input wire logic  [3:0] rx2_odt, 
input wire logic   rx2_odt_dc_mode, 
input wire logic   rx2_osc_dir_i_dp, 
input wire logic   rx2_osc_dir_ib_dp, 
input wire logic   rx2_osc_dir_q_dp, 
input wire logic   rx2_osc_dir_qb_dp, 
input wire logic  [3:0] rx2_osc_i_dp, 
input wire logic  [3:0] rx2_osc_ib_dp, 
input wire logic  [3:0] rx2_osc_q_dp, 
input wire logic  [3:0] rx2_osc_qb_dp, 
input wire logic   rx2_q_en, 
input wire logic   rx2_serdes_byp_sel, 
input wire logic   rx2_serlb_en, 
input wire logic   rx3_cal_en, 
input wire logic   rx3_i_en, 
input wire logic  [3:0] rx3_odt, 
input wire logic   rx3_odt_dc_mode, 
input wire logic   rx3_osc_dir_i_dp, 
input wire logic   rx3_osc_dir_ib_dp, 
input wire logic   rx3_osc_dir_q_dp, 
input wire logic   rx3_osc_dir_qb_dp, 
input wire logic  [3:0] rx3_osc_i_dp, 
input wire logic  [3:0] rx3_osc_ib_dp, 
input wire logic  [3:0] rx3_osc_q_dp, 
input wire logic  [3:0] rx3_osc_qb_dp, 
input wire logic   rx3_q_en, 
input wire logic   rx3_serdes_byp_sel, 
input wire logic   rx3_serlb_en, 
input wire logic   rx4_cal_en, 
input wire logic   rx4_i_en, 
input wire logic  [3:0] rx4_odt, 
input wire logic   rx4_odt_dc_mode, 
input wire logic   rx4_osc_dir_i_dp, 
input wire logic   rx4_osc_dir_ib_dp, 
input wire logic   rx4_osc_dir_q_dp, 
input wire logic   rx4_osc_dir_qb_dp, 
input wire logic  [3:0] rx4_osc_i_dp, 
input wire logic  [3:0] rx4_osc_ib_dp, 
input wire logic  [3:0] rx4_osc_q_dp, 
input wire logic  [3:0] rx4_osc_qb_dp, 
input wire logic   rx4_q_en, 
input wire logic   rx4_serdes_byp_sel, 
input wire logic   rx4_serlb_en, 
input wire logic   rx5_cal_en, 
input wire logic   rx5_i_en, 
input wire logic  [3:0] rx5_odt, 
input wire logic   rx5_odt_dc_mode, 
input wire logic   rx5_osc_dir_i_dp, 
input wire logic   rx5_osc_dir_ib_dp, 
input wire logic   rx5_osc_dir_q_dp, 
input wire logic   rx5_osc_dir_qb_dp, 
input wire logic  [3:0] rx5_osc_i_dp, 
input wire logic  [3:0] rx5_osc_ib_dp, 
input wire logic  [3:0] rx5_osc_q_dp, 
input wire logic  [3:0] rx5_osc_qb_dp, 
input wire logic   rx5_q_en, 
input wire logic   rx5_serdes_byp_sel, 
input wire logic   rx5_serlb_en, 
input wire logic   rx6_cal_en, 
input wire logic   rx6_i_en, 
input wire logic  [3:0] rx6_odt, 
input wire logic   rx6_odt_dc_mode, 
input wire logic   rx6_osc_dir_i_dp, 
input wire logic   rx6_osc_dir_ib_dp, 
input wire logic   rx6_osc_dir_q_dp, 
input wire logic   rx6_osc_dir_qb_dp, 
input wire logic  [3:0] rx6_osc_i_dp, 
input wire logic  [3:0] rx6_osc_ib_dp, 
input wire logic  [3:0] rx6_osc_q_dp, 
input wire logic  [3:0] rx6_osc_qb_dp, 
input wire logic   rx6_q_en, 
input wire logic   rx6_serdes_byp_sel, 
input wire logic   rx6_serlb_en, 
input wire logic   rx7_cal_en, 
input wire logic   rx7_i_en, 
input wire logic  [3:0] rx7_odt, 
input wire logic   rx7_odt_dc_mode, 
input wire logic   rx7_osc_dir_i_dp, 
input wire logic   rx7_osc_dir_ib_dp, 
input wire logic   rx7_osc_dir_q_dp, 
input wire logic   rx7_osc_dir_qb_dp, 
input wire logic  [3:0] rx7_osc_i_dp, 
input wire logic  [3:0] rx7_osc_ib_dp, 
input wire logic  [3:0] rx7_osc_q_dp, 
input wire logic  [3:0] rx7_osc_qb_dp, 
input wire logic   rx7_q_en, 
input wire logic   rx7_serdes_byp_sel, 
input wire logic   rx7_serlb_en, 
input  [5:0] tx0_dly_ctrl, 
input   tx0_dly_gear, 
input wire logic  [3:0] tx0_drv_imp, 
input wire logic  [2:0] tx0_drv_preem, 
input wire logic   tx0_en, 
input wire logic   tx0_highz, 
input  [3:0] tx0_preemp_sec_dly, 
input wire logic  [2:0] tx0_preemp_sec_en, 
input wire logic   tx0_ser_lpb_en, 
input wire logic   tx0_serdes_byp_out, 
input wire logic   tx0_serdes_byp_sel, 
input wire logic  [15:0] tx0_td, 
input  [5:0] tx1_dly_ctrl, 
input   tx1_dly_gear, 
input wire logic  [3:0] tx1_drv_imp, 
input wire logic  [2:0] tx1_drv_preem, 
input wire logic   tx1_en, 
input wire logic   tx1_highz, 
input  [3:0] tx1_preemp_sec_dly, 
input wire logic  [2:0] tx1_preemp_sec_en, 
input wire logic   tx1_ser_lpb_en, 
input wire logic   tx1_serdes_byp_out, 
input wire logic   tx1_serdes_byp_sel, 
input wire logic  [15:0] tx1_td, 
input  [5:0] tx2_dly_ctrl, 
input   tx2_dly_gear, 
input wire logic  [3:0] tx2_drv_imp, 
input wire logic  [2:0] tx2_drv_preem, 
input wire logic   tx2_en, 
input wire logic   tx2_highz, 
input  [3:0] tx2_preemp_sec_dly, 
input wire logic  [2:0] tx2_preemp_sec_en, 
input wire logic   tx2_ser_lpb_en, 
input wire logic   tx2_serdes_byp_out, 
input wire logic   tx2_serdes_byp_sel, 
input wire logic  [15:0] tx2_td, 
input  [5:0] tx3_dly_ctrl, 
input   tx3_dly_gear, 
input wire logic  [3:0] tx3_drv_imp, 
input wire logic  [2:0] tx3_drv_preem, 
input wire logic   tx3_en, 
input wire logic   tx3_highz, 
input  [3:0] tx3_preemp_sec_dly, 
input wire logic  [2:0] tx3_preemp_sec_en, 
input wire logic   tx3_ser_lpb_en, 
input wire logic   tx3_serdes_byp_out, 
input wire logic   tx3_serdes_byp_sel, 
input wire logic  [15:0] tx3_td, 
input  [5:0] tx4_dly_ctrl, 
input   tx4_dly_gear, 
input wire logic  [3:0] tx4_drv_imp, 
input wire logic  [2:0] tx4_drv_preem, 
input wire logic   tx4_en, 
input wire logic   tx4_highz, 
input  [3:0] tx4_preemp_sec_dly, 
input wire logic  [2:0] tx4_preemp_sec_en, 
input wire logic   tx4_ser_lpb_en, 
input wire logic   tx4_serdes_byp_out, 
input wire logic   tx4_serdes_byp_sel, 
input wire logic  [15:0] tx4_td, 
input  [5:0] tx5_dly_ctrl, 
input   tx5_dly_gear, 
input wire logic  [3:0] tx5_drv_imp, 
input wire logic  [2:0] tx5_drv_preem, 
input wire logic   tx5_en, 
input wire logic   tx5_highz, 
input  [3:0] tx5_preemp_sec_dly, 
input wire logic  [2:0] tx5_preemp_sec_en, 
input wire logic   tx5_ser_lpb_en, 
input wire logic   tx5_serdes_byp_out, 
input wire logic   tx5_serdes_byp_sel, 
input wire logic  [15:0] tx5_td, 
input  [5:0] tx6_dly_ctrl, 
input   tx6_dly_gear, 
input wire logic  [3:0] tx6_drv_imp, 
input wire logic  [2:0] tx6_drv_preem, 
input wire logic   tx6_en, 
input wire logic   tx6_highz, 
input  [3:0] tx6_preemp_sec_dly, 
input wire logic  [2:0] tx6_preemp_sec_en, 
input wire logic   tx6_ser_lpb_en, 
input wire logic   tx6_serdes_byp_out, 
input wire logic   tx6_serdes_byp_sel, 
input wire logic  [15:0] tx6_td, 
input  [5:0] tx7_dly_ctrl, 
input   tx7_dly_gear, 
input wire logic  [3:0] tx7_drv_imp, 
input wire logic  [2:0] tx7_drv_preem, 
input wire logic   tx7_en, 
input wire logic   tx7_highz, 
input  [3:0] tx7_preemp_sec_dly, 
input wire logic  [2:0] tx7_preemp_sec_en, 
input wire logic   tx7_ser_lpb_en, 
input wire logic   tx7_serdes_byp_out, 
input wire logic   tx7_serdes_byp_sel, 
input wire logic  [15:0] tx7_td );


wire logic net8 ;

wire logic net7 ;

wire logic net6 ;

wire logic net5 ;

wire logic net4 ;

wire logic net3 ;

wire logic net2 ;

wire logic clk_ser_lpb_p ;

wire logic clk_ser_lpb_n ;

wire logic net1 ;



WavD2DAnalogPhy_8lane_gf12lpp_wav_wlink_8l_rx_ana IRX_8L ( .clk_rx_ser_lpb_n(clk_ser_lpb_n),
     .clk_rx_ser_lpb_p(clk_ser_lpb_p),
     .clk_rx_coreclk_div16(clk_rx_coreclk_div16),
     .clk_rx_dll_cal_dat(clk_rx_dll_cal_dat),
     .clk_rx_dtest(clk_rx_dtest),
     .clk_rx_rcvr_bypass_in_n(clk_rx_rcvr_bypass_in_n),
     .clk_rx_rcvr_bypass_in_p(clk_rx_rcvr_bypass_in_p),
     .clk_rx_dll_cal_en(clk_rx_dll_cal_en),
     .clk_rx_dll_ctrl(clk_rx_dll_ctrl[5:0]),
     .clk_rx_dll_en(clk_rx_dll_en),
     .clk_rx_dll_gear(clk_rx_dll_gear[1:0]),
     .clk_rx_dtest_div(clk_rx_dtest_div[3:0]),
     .clk_rx_dtest_en(clk_rx_dtest_en),
     .clk_rx_dtest_in(clk_rx_dtest_in),
     .clk_rx_en_rx_div2_clk(clk_rx_en_rx_div2_clk),
     .clk_rx_en_rx_div16_clk(clk_rx_en_rx_div16_clk),
     .clk_rx_i_pi_code(clk_rx_i_pi_code[15:0]),
     .clk_rx_i_pi_en(clk_rx_i_pi_en),
     .clk_rx_i_pi_quad(clk_rx_i_pi_quad[1:0]),
     .clk_rx_pi_gear(clk_rx_pi_gear[3:0]),
     .clk_rx_pi_xcpl(clk_rx_pi_xcpl[3:0]),
     .clk_rx_q_pi_code(clk_rx_q_pi_code[15:0]),
     .clk_rx_q_pi_en(clk_rx_q_pi_en),
     .clk_rx_q_pi_quad(clk_rx_q_pi_quad[1:0]),
     .clk_rx_rcvr_ac_mode(clk_rx_rcvr_ac_mode),
     .clk_rx_rcvr_bypass_sel(clk_rx_rcvr_bypass_sel),
     .clk_rx_rcvr_en(clk_rx_rcvr_en),
     .clk_rx_rcvr_fb_en(clk_rx_rcvr_fb_en),
     .clk_rx_rcvr_odt_ctrl(clk_rx_rcvr_odt_ctrl[3:0]),
     .clk_rx_rcvr_odt_dc_mode(clk_rx_rcvr_odt_dc_mode),
     .clk_rx_reset_sync(clk_rx_reset_sync),
     .clk_rx_ser_lpb_en(clk_rx_ser_lpb_en),
     .clk_rx_test_sel(clk_rx_test_sel[2:0]),
     .clk_rx_vref_en(clk_rx_vref_en), .pad_clk_rxn(pad_clk_rxn),
     .clk_rx_vref_lvl(clk_rx_vref_lvl[5:0]), .vddq(vddq),
     .pad_clk_rxp(pad_clk_rxp), .rx0_clk_div16(rx0_clk_div16),
     .rx0_idata(rx0_idata[15:0]), .rx0_qdata(rx0_qdata[15:0]),
     .rx0_serdes_byp_in(rx0_serdes_byp_in),
     .rx1_clk_div16(rx1_clk_div16), .rx1_idata(rx1_idata[15:0]),
     .rx1_qdata(rx1_qdata[15:0]),
     .rx1_serdes_byp_in(rx1_serdes_byp_in),
     .rx2_clk_div16(rx2_clk_div16), .rx2_idata(rx2_idata[15:0]),
     .rx2_qdata(rx2_qdata[15:0]),
     .rx2_serdes_byp_in(rx2_serdes_byp_in),
     .rx3_clk_div16(rx3_clk_div16), .rx3_idata(rx3_idata[15:0]),
     .rx3_qdata(rx3_qdata[15:0]),
     .rx3_serdes_byp_in(rx3_serdes_byp_in),
     .rx4_clk_div16(rx4_clk_div16), .rx4_idata(rx4_idata[15:0]),
     .rx4_qdata(rx4_qdata[15:0]),
     .rx4_serdes_byp_in(rx4_serdes_byp_in),
     .rx5_clk_div16(rx5_clk_div16), .rx5_idata(rx5_idata[15:0]),
     .rx5_qdata(rx5_qdata[15:0]),
     .rx5_serdes_byp_in(rx5_serdes_byp_in),
     .rx6_clk_div16(rx6_clk_div16), .rx6_idata(rx6_idata[15:0]),
     .rx6_qdata(rx6_qdata[15:0]),
     .rx6_serdes_byp_in(rx6_serdes_byp_in),
     .rx7_clk_div16(rx7_clk_div16), .rx7_idata(rx7_idata[15:0]),
     .rx7_qdata(rx7_qdata[15:0]),
     .rx7_serdes_byp_in(rx7_serdes_byp_in), .pad_rx0(pad_rx0),
     .pad_rx1(pad_rx1), .pad_rx2(pad_rx2), .pad_rx3(pad_rx3),
     .pad_rx4(pad_rx4), .pad_rx5(pad_rx5), .pad_rx6(pad_rx6),
     .pad_rx7(pad_rx7), .rx0_cal_en(rx0_cal_en), .rx0_i_en(rx0_i_en),
     .rx0_odt(rx0_odt[3:0]), .rx0_odt_dc_mode(rx0_odt_dc_mode),
     .rx0_osc_dir_i_dp(rx0_osc_dir_i_dp),
     .rx0_osc_dir_ib_dp(rx0_osc_dir_ib_dp),
     .rx0_osc_dir_q_dp(rx0_osc_dir_q_dp),
     .rx0_osc_dir_qb_dp(rx0_osc_dir_qb_dp),
     .rx0_osc_i_dp(rx0_osc_i_dp[3:0]),
     .rx0_osc_ib_dp(rx0_osc_ib_dp[3:0]),
     .rx0_osc_q_dp(rx0_osc_q_dp[3:0]),
     .rx0_osc_qb_dp(rx0_osc_qb_dp[3:0]), .rx0_q_en(rx0_q_en),
     .rx0_ser_lpb(net2), .rx0_serdes_byp_sel(rx0_serdes_byp_sel),
     .rx0_serlb_en(rx0_serlb_en), .rx1_cal_en(rx1_cal_en),
     .rx1_i_en(rx1_i_en), .rx1_odt(rx1_odt[3:0]),
     .rx1_odt_dc_mode(rx1_odt_dc_mode),
     .rx1_osc_dir_i_dp(rx1_osc_dir_i_dp),
     .rx1_osc_dir_ib_dp(rx1_osc_dir_ib_dp),
     .rx1_osc_dir_q_dp(rx1_osc_dir_q_dp),
     .rx1_osc_dir_qb_dp(rx1_osc_dir_qb_dp),
     .rx1_osc_i_dp(rx1_osc_i_dp[3:0]),
     .rx1_osc_ib_dp(rx1_osc_ib_dp[3:0]),
     .rx1_osc_q_dp(rx1_osc_q_dp[3:0]),
     .rx1_osc_qb_dp(rx1_osc_qb_dp[3:0]), .rx1_q_en(rx1_q_en),
     .rx1_ser_lpb(net3), .rx1_serdes_byp_sel(rx1_serdes_byp_sel),
     .rx1_serlb_en(rx1_serlb_en), .rx2_cal_en(rx2_cal_en),
     .rx2_i_en(rx2_i_en), .rx2_odt(rx2_odt[3:0]),
     .rx2_odt_dc_mode(rx2_odt_dc_mode),
     .rx2_osc_dir_i_dp(rx2_osc_dir_i_dp),
     .rx2_osc_dir_ib_dp(rx2_osc_dir_ib_dp),
     .rx2_osc_dir_q_dp(rx2_osc_dir_q_dp),
     .rx2_osc_dir_qb_dp(rx2_osc_dir_qb_dp),
     .rx2_osc_i_dp(rx2_osc_i_dp[3:0]),
     .rx2_osc_ib_dp(rx2_osc_ib_dp[3:0]),
     .rx2_osc_q_dp(rx2_osc_q_dp[3:0]),
     .rx2_osc_qb_dp(rx2_osc_qb_dp[3:0]), .rx2_q_en(rx2_q_en),
     .rx2_ser_lpb(net1), .rx2_serdes_byp_sel(rx2_serdes_byp_sel),
     .rx2_serlb_en(rx2_serlb_en), .rx3_cal_en(rx3_cal_en),
     .rx3_i_en(rx3_i_en), .rx3_odt(rx3_odt[3:0]),
     .rx3_odt_dc_mode(rx3_odt_dc_mode),
     .rx3_osc_dir_i_dp(rx3_osc_dir_i_dp),
     .rx3_osc_dir_ib_dp(rx3_osc_dir_ib_dp),
     .rx3_osc_dir_q_dp(rx3_osc_dir_q_dp),
     .rx3_osc_dir_qb_dp(rx3_osc_dir_qb_dp),
     .rx3_osc_i_dp(rx3_osc_i_dp[3:0]),
     .rx3_osc_ib_dp(rx3_osc_ib_dp[3:0]),
     .rx3_osc_q_dp(rx3_osc_q_dp[3:0]),
     .rx3_osc_qb_dp(rx3_osc_qb_dp[3:0]), .rx3_q_en(rx3_q_en),
     .rx3_ser_lpb(net8), .rx3_serdes_byp_sel(rx3_serdes_byp_sel),
     .rx3_serlb_en(rx3_serlb_en), .rx4_cal_en(rx4_cal_en),
     .rx4_i_en(rx4_i_en), .rx4_odt(rx4_odt[3:0]),
     .rx4_odt_dc_mode(rx4_odt_dc_mode),
     .rx4_osc_dir_i_dp(rx4_osc_dir_i_dp),
     .rx4_osc_dir_ib_dp(rx4_osc_dir_ib_dp),
     .rx4_osc_dir_q_dp(rx4_osc_dir_q_dp),
     .rx4_osc_dir_qb_dp(rx4_osc_dir_qb_dp),
     .rx4_osc_i_dp(rx4_osc_i_dp[3:0]),
     .rx4_osc_ib_dp(rx4_osc_ib_dp[3:0]),
     .rx4_osc_q_dp(rx4_osc_q_dp[3:0]),
     .rx4_osc_qb_dp(rx4_osc_qb_dp[3:0]), .rx4_q_en(rx4_q_en),
     .rx4_ser_lpb(net7), .rx4_serdes_byp_sel(rx4_serdes_byp_sel),
     .rx4_serlb_en(rx4_serlb_en), .rx5_cal_en(rx5_cal_en),
     .rx5_i_en(rx5_i_en), .rx5_odt(rx5_odt[3:0]),
     .rx5_odt_dc_mode(rx5_odt_dc_mode),
     .rx5_osc_dir_i_dp(rx5_osc_dir_i_dp),
     .rx5_osc_dir_ib_dp(rx5_osc_dir_ib_dp),
     .rx5_osc_dir_q_dp(rx5_osc_dir_q_dp),
     .rx5_osc_dir_qb_dp(rx5_osc_dir_qb_dp),
     .rx5_osc_i_dp(rx5_osc_i_dp[3:0]),
     .rx5_osc_ib_dp(rx5_osc_ib_dp[3:0]),
     .rx5_osc_q_dp(rx5_osc_q_dp[3:0]),
     .rx5_osc_qb_dp(rx5_osc_qb_dp[3:0]), .rx5_q_en(rx5_q_en),
     .rx5_ser_lpb(net6), .rx5_serdes_byp_sel(rx5_serdes_byp_sel),
     .rx5_serlb_en(rx5_serlb_en), .rx6_cal_en(rx6_cal_en),
     .rx6_i_en(rx6_i_en), .rx6_odt(rx6_odt[3:0]),
     .rx6_odt_dc_mode(rx6_odt_dc_mode),
     .rx6_osc_dir_i_dp(rx6_osc_dir_i_dp),
     .rx6_osc_dir_ib_dp(rx6_osc_dir_ib_dp),
     .rx6_osc_dir_q_dp(rx6_osc_dir_q_dp),
     .rx6_osc_dir_qb_dp(rx6_osc_dir_qb_dp),
     .rx6_osc_i_dp(rx6_osc_i_dp[3:0]),
     .rx6_osc_ib_dp(rx6_osc_ib_dp[3:0]),
     .rx6_osc_q_dp(rx6_osc_q_dp[3:0]),
     .rx6_osc_qb_dp(rx6_osc_qb_dp[3:0]), .rx6_q_en(rx6_q_en),
     .rx6_ser_lpb(net5), .rx6_serdes_byp_sel(rx6_serdes_byp_sel),
     .rx6_serlb_en(rx6_serlb_en), .rx7_cal_en(rx7_cal_en),
     .rx7_i_en(rx7_i_en), .rx7_odt(rx7_odt[3:0]),
     .rx7_odt_dc_mode(rx7_odt_dc_mode),
     .rx7_osc_dir_i_dp(rx7_osc_dir_i_dp),
     .rx7_osc_dir_ib_dp(rx7_osc_dir_ib_dp),
     .rx7_osc_dir_q_dp(rx7_osc_dir_q_dp),
     .rx7_osc_dir_qb_dp(rx7_osc_dir_qb_dp),
     .rx7_osc_i_dp(rx7_osc_i_dp[3:0]),
     .rx7_osc_ib_dp(rx7_osc_ib_dp[3:0]),
     .rx7_osc_q_dp(rx7_osc_q_dp[3:0]),
     .rx7_osc_qb_dp(rx7_osc_qb_dp[3:0]), .rx7_q_en(rx7_q_en),
     .rx7_ser_lpb(net4), .rx7_serdes_byp_sel(rx7_serdes_byp_sel),
     .rx7_serlb_en(rx7_serlb_en), .vdda_ck(vdda_ck), .vdda(vdda),
     .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_wav_wlink_8l_tx_ana ITX_8L (
     .clk_tx_coreclk_div16(clk_tx_coreclk_div16),
     .clk_tx_ser_lpb_n(clk_ser_lpb_n),
     .clk_tx_ser_lpb_p(clk_ser_lpb_p),
     .clk_tx_drv_bypass_out_n(clk_tx_drv_bypass_out_n),
     .clk_tx_drv_bypass_out_p(clk_tx_drv_bypass_out_p),
     .clk_tx_drv_bypass_sel(clk_tx_drv_bypass_sel),
     .clk_tx_drv_ctrl(clk_tx_drv_ctrl[3:0]),
     .clk_tx_drv_en(clk_tx_drv_en),
     .clk_tx_drv_preemp(clk_tx_drv_preemp[2:0]),
     .clk_tx_en_tx_div2_clk(clk_tx_en_tx_div2_clk),
     .clk_tx_en_tx_div16_clk(clk_tx_en_tx_div16_clk),
     .clk_tx_reset_sync(clk_tx_reset_sync), .pad_clk_txn(pad_clk_txn),
     .vdda_ck(vdda_ck), .pll_clk180(pll_clk180),
     .pad_clk_txp(pad_clk_txp), .pll_clk0(pll_clk0),
     .clk_tx_ser_lpb_en(clk_tx_ser_lpb_en), .vddq(vddq),
     .tx0_dly_ctrl(tx0_dly_ctrl[5:0]), .tx0_dly_gear(tx0_dly_gear),
     .tx1_dly_ctrl(tx1_dly_ctrl[5:0]), .tx1_dly_gear(tx1_dly_gear),
     .pad_tx0(pad_tx0), .pad_tx1(pad_tx1), .pad_tx2(pad_tx2),
     .pad_tx3(pad_tx3), .pad_tx4(pad_tx4), .pad_tx5(pad_tx5),
     .pad_tx6(pad_tx6), .pad_tx7(pad_tx7), .tx0_ser_lpb(net2),
     .tx0_tclk_div16(tx0_tclk_div16), .tx1_ser_lpb(net3),
     .tx1_tclk_div16(tx1_tclk_div16), .tx2_ser_lpb(net1),
     .tx2_tclk_div16(tx2_tclk_div16), .tx3_ser_lpb(net8),
     .tx3_tclk_div16(tx3_tclk_div16), .tx4_ser_lpb(net7),
     .tx4_tclk_div16(tx4_tclk_div16), .tx5_ser_lpb(net6),
     .tx5_tclk_div16(tx5_tclk_div16), .tx6_ser_lpb(net5),
     .tx6_tclk_div16(tx6_tclk_div16), .tx7_ser_lpb(net4),
     .tx7_tclk_div16(tx7_tclk_div16), .tx0_drv_imp(tx0_drv_imp[3:0]),
     .tx0_drv_preem(tx0_drv_preem[2:0]), .tx0_en(tx0_en),
     .tx0_highz(tx0_highz),
     .tx0_preemp_sec_dly(tx0_preemp_sec_dly[3:0]),
     .tx0_preemp_sec_en(tx0_preemp_sec_en[2:0]),
     .tx0_ser_lpb_en(tx0_ser_lpb_en),
     .tx0_serdes_byp_out(tx0_serdes_byp_out),
     .tx0_serdes_byp_sel(tx0_serdes_byp_sel), .tx0_td(tx0_td[15:0]),
     .tx1_drv_imp(tx1_drv_imp[3:0]),
     .tx1_drv_preem(tx1_drv_preem[2:0]), .tx1_en(tx1_en),
     .tx1_highz(tx1_highz),
     .tx1_preemp_sec_dly(tx1_preemp_sec_dly[3:0]),
     .tx1_preemp_sec_en(tx1_preemp_sec_en[2:0]),
     .tx1_ser_lpb_en(tx1_ser_lpb_en),
     .tx1_serdes_byp_out(tx1_serdes_byp_out),
     .tx1_serdes_byp_sel(tx1_serdes_byp_sel), .tx1_td(tx1_td[15:0]),
     .tx2_dly_gear(tx2_dly_gear), .tx2_dly_ctrl(tx2_dly_ctrl[5:0]),
     .tx2_drv_imp(tx2_drv_imp[3:0]),
     .tx2_drv_preem(tx2_drv_preem[2:0]), .tx2_en(tx2_en),
     .tx2_highz(tx2_highz),
     .tx2_preemp_sec_dly(tx2_preemp_sec_dly[3:0]),
     .tx2_preemp_sec_en(tx2_preemp_sec_en[2:0]),
     .tx2_ser_lpb_en(tx2_ser_lpb_en),
     .tx2_serdes_byp_out(tx2_serdes_byp_out),
     .tx2_serdes_byp_sel(tx2_serdes_byp_sel), .tx2_td(tx2_td[15:0]),
     .tx3_dly_ctrl(tx3_dly_ctrl[5:0]), .tx3_dly_gear(tx3_dly_gear),
     .tx3_drv_imp(tx3_drv_imp[3:0]),
     .tx3_drv_preem(tx3_drv_preem[2:0]), .tx3_en(tx3_en),
     .tx3_highz(tx3_highz),
     .tx3_preemp_sec_dly(tx3_preemp_sec_dly[3:0]),
     .tx3_preemp_sec_en(tx3_preemp_sec_en[2:0]),
     .tx3_ser_lpb_en(tx3_ser_lpb_en),
     .tx3_serdes_byp_out(tx3_serdes_byp_out),
     .tx3_serdes_byp_sel(tx3_serdes_byp_sel), .tx3_td(tx3_td[15:0]),
     .tx4_dly_ctrl(tx4_dly_ctrl[5:0]), .tx4_dly_gear(tx4_dly_gear),
     .tx4_drv_imp(tx4_drv_imp[3:0]),
     .tx4_drv_preem(tx4_drv_preem[2:0]), .tx4_en(tx4_en),
     .tx4_highz(tx4_highz),
     .tx4_preemp_sec_dly(tx4_preemp_sec_dly[3:0]),
     .tx4_preemp_sec_en(tx4_preemp_sec_en[2:0]),
     .tx4_ser_lpb_en(tx4_ser_lpb_en),
     .tx4_serdes_byp_out(tx4_serdes_byp_out),
     .tx4_serdes_byp_sel(tx4_serdes_byp_sel), .tx4_td(tx4_td[15:0]),
     .tx5_drv_imp(tx5_drv_imp[3:0]),
     .tx5_drv_preem(tx5_drv_preem[2:0]), .tx5_en(tx5_en),
     .tx5_highz(tx5_highz),
     .tx5_preemp_sec_dly(tx5_preemp_sec_dly[3:0]),
     .tx5_preemp_sec_en(tx5_preemp_sec_en[2:0]),
     .tx5_ser_lpb_en(tx5_ser_lpb_en),
     .tx5_serdes_byp_out(tx5_serdes_byp_out),
     .tx5_serdes_byp_sel(tx5_serdes_byp_sel), .tx5_td(tx5_td[15:0]),
     .tx5_dly_gear(tx5_dly_gear), .tx5_dly_ctrl(tx5_dly_ctrl[5:0]),
     .tx6_drv_imp(tx6_drv_imp[3:0]),
     .tx6_drv_preem(tx6_drv_preem[2:0]), .tx6_en(tx6_en),
     .tx6_highz(tx6_highz),
     .tx6_preemp_sec_dly(tx6_preemp_sec_dly[3:0]),
     .tx6_preemp_sec_en(tx6_preemp_sec_en[2:0]),
     .tx6_ser_lpb_en(tx6_ser_lpb_en),
     .tx6_serdes_byp_out(tx6_serdes_byp_out),
     .tx6_serdes_byp_sel(tx6_serdes_byp_sel), .tx6_td(tx6_td[15:0]),
     .tx6_dly_ctrl(tx6_dly_ctrl[5:0]), .tx6_dly_gear(tx6_dly_gear),
     .tx7_drv_imp(tx7_drv_imp[3:0]),
     .tx7_drv_preem(tx7_drv_preem[2:0]), .tx7_en(tx7_en),
     .tx7_highz(tx7_highz),
     .tx7_preemp_sec_dly(tx7_preemp_sec_dly[3:0]),
     .tx7_preemp_sec_en(tx7_preemp_sec_en[2:0]),
     .tx7_ser_lpb_en(tx7_ser_lpb_en),
     .tx7_serdes_byp_out(tx7_serdes_byp_out),
     .tx7_serdes_byp_sel(tx7_serdes_byp_sel), .tx7_td(tx7_td[15:0]),
     .tx7_dly_ctrl(tx7_dly_ctrl[5:0]), .tx7_dly_gear(tx7_dly_gear),
     .vdda(vdda), .vss(vss));

endmodule
// Library - wphy_gf12lp_d2d_serdes_lib, Cell -
//WavD2DAnalogPhy_8lane_gf12lpp, View - schematic
// LAST TIME SAVED: Sep 23 06:49:12 2021
// NETLIST TIME: Oct  7 15:28:50 2021
`timescale 1ns / 1ns 

module WavD2DAnalogPhy_8lane_gf12lpp ( 
output wire logic   clk_rx_coreclk_div16, 
output wire logic   clk_rx_dll_cal_dat, 
output wire logic   clk_rx_dtst, 
output wire logic   clk_rx_rcvr_bypass_in_n, 
output wire logic   clk_rx_rcvr_bypass_in_p, 
output wire logic   clk_tx_coreclk_div16, 
output wire logic   pad_tx_0, 
output wire logic   pad_tx_1, 
output wire logic   pad_tx_2, 
output wire logic   pad_tx_3, 
output wire logic   pad_tx_4, 
output wire logic   pad_tx_5, 
output wire logic   pad_tx_6, 
output wire logic   pad_tx_7, 
output wire logic   refclk_out, 
output wire logic   rpll_clk_div16, 
output wire logic   rpll_dtest_out, 
output wire logic   rpll_fbclk, 
output wire logic   rpll_refclk_out, 
output wire logic   rx_0_clk_div16, 
output wire logic  [15:0] rx_0_idata, 
output wire logic   rx_0_serdes_byp_in, 
output wire logic   rx_1_clk_div16, 
output wire logic  [15:0] rx_1_idata, 
output wire logic   rx_1_serdes_byp_in, 
output wire logic   rx_2_clk_div16, 
output wire logic  [15:0] rx_2_idata, 
output wire logic   rx_2_serdes_byp_in, 
output wire logic   rx_3_clk_div16, 
output wire logic  [15:0] rx_3_idata, 
output wire logic   rx_3_serdes_byp_in, 
output wire logic   rx_4_clk_div16, 
output wire logic  [15:0] rx_4_idata, 
output wire logic   rx_4_serdes_byp_in, 
output wire logic   rx_5_clk_div16, 
output wire logic  [15:0] rx_5_idata, 
output wire logic   rx_5_serdes_byp_in, 
output wire logic   rx_6_clk_div16, 
output wire logic  [15:0] rx_6_idata, 
output wire logic   rx_6_serdes_byp_in, 
output wire logic   rx_7_clk_div16, 
output wire logic  [15:0] rx_7_idata, 
output wire logic   rx_7_serdes_byp_in, 
output wire logic  [15:0] rxq_0_qdata, 
output wire logic  [15:0] rxq_1_qdata, 
output wire logic  [15:0] rxq_2_qdata, 
output wire logic  [15:0] rxq_3_qdata, 
output wire logic  [15:0] rxq_4_qdata, 
output wire logic  [15:0] rxq_5_qdata, 
output wire logic  [15:0] rxq_6_qdata, 
output wire logic  [15:0] rxq_7_qdata, 
output  tie_hi, 
output  tie_lo, 
output wire logic   tx_0_clk_div16, 
output wire logic   tx_1_clk_div16, 
output wire logic   tx_2_clk_div16, 
output wire logic   tx_3_clk_div16, 
output wire logic   tx_4_clk_div16, 
output wire logic   tx_5_clk_div16, 
output wire logic   tx_6_clk_div16, 
output wire logic   tx_7_clk_div16, 
inout wire logic   pad_clk_txn, 
inout wire logic   pad_clk_txp, 
input wire logic   clk_rx_dll_cal_en, 
input wire logic  [5:0] clk_rx_dll_ctrl, 
input wire logic   clk_rx_dll_en, 
input wire logic  [1:0] clk_rx_dll_gear, 
input wire logic  [3:0] clk_rx_dtst_div, 
input wire logic   clk_rx_dtst_en, 
input wire logic   clk_rx_dtst_in, 
input wire logic  [2:0] clk_rx_dtst_sel, 
input wire logic   clk_rx_en_rx_div2_clk, 
input wire logic   clk_rx_en_rx_div16_clk, 
input wire logic  [15:0] clk_rx_i_pi_code, 
input wire logic   clk_rx_i_pi_en, 
input wire logic  [1:0] clk_rx_i_pi_quad, 
input wire logic  [3:0] clk_rx_pi_gear, 
input wire logic  [3:0] clk_rx_pi_xcpl, 
input wire logic  [15:0] clk_rx_q_pi_code, 
input wire logic   clk_rx_q_pi_en, 
input wire logic  [1:0] clk_rx_q_pi_quad, 
input wire logic   clk_rx_rcvr_ac_mode, 
input wire logic   clk_rx_rcvr_bypass_sel, 
input wire logic   clk_rx_rcvr_en, 
input wire logic   clk_rx_rcvr_fb_en, 
input wire logic  [3:0] clk_rx_rcvr_odt_ctrl, 
input wire logic   clk_rx_rcvr_odt_dc_mode, 
input wire logic   clk_rx_reset_sync, 
input wire logic   clk_rx_ser_lpb_en, 
input wire logic   clk_rx_vref_en, 
input wire logic  [5:0] clk_rx_vref_lvl, 
input wire logic   clk_tx_drv_bypass_out_n, 
input wire logic   clk_tx_drv_bypass_out_p, 
input wire logic   clk_tx_drv_bypass_sel, 
input wire logic  [3:0] clk_tx_drv_ctrl, 
input wire logic   clk_tx_drv_en, 
input wire logic  [2:0] clk_tx_drv_preemp, 
input wire logic   clk_tx_en_tx_div2_clk, 
input wire logic   clk_tx_en_tx_div16_clk, 
input wire logic   clk_tx_reset_sync, 
input wire logic   clk_tx_ser_lpb_en, 
input wire logic   ext_ibias_5u, 
input wire logic   ldo_byp, 
input wire logic   ldo_ena, 
input wire logic   ldo_highz, 
input wire logic  [5:0] ldo_lvl, 
input wire logic  [7:0] ldo_mode, 
input wire logic   ldo_refsel, 
input wire logic   pad_clk_rxn, 
input wire logic   pad_clk_rxp, 
input wire logic   pad_rx_0, 
input wire logic   pad_rx_1, 
input wire logic   pad_rx_2, 
input wire logic   pad_rx_3, 
input wire logic   pad_rx_4, 
input wire logic   pad_rx_5, 
input wire logic   pad_rx_6, 
input wire logic   pad_rx_7, 
input wire logic   refclk_in, 
input  [3:0] rpll_bias_lvl, 
input wire logic   rpll_byp_clk_sel, 
input wire logic   rpll_cp_int_mode, 
input   rpll_dbl_clk_sel, 
input wire logic  [2:0] rpll_dtest_sel, 
input wire logic   rpll_ena, 
input wire logic  [8:0] rpll_fbdiv_sel, 
input wire logic  [4:0] rpll_int_ctrl, 
input [7:0] rpll_mode, 
input wire logic  [1:0] rpll_pfd_mode, 
input wire logic  [1:0] rpll_post_div_sel, 
input wire logic  [1:0] rpll_prop_c_ctrl, 
input wire logic  [4:0] rpll_prop_ctrl, 
input wire logic  [1:0] rpll_prop_r_ctrl, 
input wire logic   rpll_refclk_alt, 
input wire logic   rpll_reset, 
input wire logic   rpll_ret, 
input wire logic   rpll_sel_refclk_alt, 
input wire logic   rx_0_cal_en, 
input wire logic   rx_0_i_en, 
input wire logic  [3:0] rx_0_odt_ctrl, 
input wire logic   rx_0_odt_dc_mode, 
input wire logic   rx_0_osc_dir_i_dp, 
input wire logic   rx_0_osc_dir_ib_dp, 
input wire logic  [3:0] rx_0_osc_i_dp, 
input wire logic  [3:0] rx_0_osc_ib_dp, 
input wire logic   rx_0_serdes_byp_sel, 
input wire logic   rx_0_serlb_en, 
input wire logic   rx_1_cal_en, 
input wire logic   rx_1_i_en, 
input wire logic  [3:0] rx_1_odt_ctrl, 
input wire logic   rx_1_odt_dc_mode, 
input wire logic   rx_1_osc_dir_i_dp, 
input wire logic   rx_1_osc_dir_ib_dp, 
input wire logic  [3:0] rx_1_osc_i_dp, 
input wire logic  [3:0] rx_1_osc_ib_dp, 
input wire logic   rx_1_serdes_byp_sel, 
input wire logic   rx_1_serlb_en, 
input wire logic   rx_2_cal_en, 
input wire logic   rx_2_i_en, 
input wire logic  [3:0] rx_2_odt_ctrl, 
input wire logic   rx_2_odt_dc_mode, 
input wire logic   rx_2_osc_dir_i_dp, 
input wire logic   rx_2_osc_dir_ib_dp, 
input wire logic  [3:0] rx_2_osc_i_dp, 
input wire logic  [3:0] rx_2_osc_ib_dp, 
input wire logic   rx_2_serdes_byp_sel, 
input wire logic   rx_2_serlb_en, 
input wire logic   rx_3_cal_en, 
input wire logic   rx_3_i_en, 
input wire logic  [3:0] rx_3_odt_ctrl, 
input wire logic   rx_3_odt_dc_mode, 
input wire logic   rx_3_osc_dir_i_dp, 
input wire logic   rx_3_osc_dir_ib_dp, 
input wire logic  [3:0] rx_3_osc_i_dp, 
input wire logic  [3:0] rx_3_osc_ib_dp, 
input wire logic   rx_3_serdes_byp_sel, 
input wire logic   rx_3_serlb_en, 
input wire logic   rx_4_cal_en, 
input wire logic   rx_4_i_en, 
input wire logic  [3:0] rx_4_odt_ctrl, 
input wire logic   rx_4_odt_dc_mode, 
input wire logic   rx_4_osc_dir_i_dp, 
input wire logic   rx_4_osc_dir_ib_dp, 
input wire logic  [3:0] rx_4_osc_i_dp, 
input wire logic  [3:0] rx_4_osc_ib_dp, 
input wire logic   rx_4_serdes_byp_sel, 
input wire logic   rx_4_serlb_en, 
input wire logic   rx_5_cal_en, 
input wire logic   rx_5_i_en, 
input wire logic  [3:0] rx_5_odt_ctrl, 
input wire logic   rx_5_odt_dc_mode, 
input wire logic   rx_5_osc_dir_i_dp, 
input wire logic   rx_5_osc_dir_ib_dp, 
input wire logic  [3:0] rx_5_osc_i_dp, 
input wire logic  [3:0] rx_5_osc_ib_dp, 
input wire logic   rx_5_serdes_byp_sel, 
input wire logic   rx_5_serlb_en, 
input wire logic   rx_6_cal_en, 
input wire logic   rx_6_i_en, 
input wire logic  [3:0] rx_6_odt_ctrl, 
input wire logic   rx_6_odt_dc_mode, 
input wire logic   rx_6_osc_dir_i_dp, 
input wire logic   rx_6_osc_dir_ib_dp, 
input wire logic  [3:0] rx_6_osc_i_dp, 
input wire logic  [3:0] rx_6_osc_ib_dp, 
input wire logic   rx_6_serdes_byp_sel, 
input wire logic   rx_6_serlb_en, 
input wire logic   rx_7_cal_en, 
input wire logic   rx_7_i_en, 
input wire logic  [3:0] rx_7_odt_ctrl, 
input wire logic   rx_7_odt_dc_mode, 
input wire logic   rx_7_osc_dir_i_dp, 
input wire logic   rx_7_osc_dir_ib_dp, 
input wire logic  [3:0] rx_7_osc_i_dp, 
input wire logic  [3:0] rx_7_osc_ib_dp, 
input wire logic   rx_7_serdes_byp_sel, 
input wire logic   rx_7_serlb_en, 
input wire logic   rxq_0_osc_dir_q_dp, 
input wire logic   rxq_0_osc_dir_qb_dp, 
input wire logic  [3:0] rxq_0_osc_q_dp, 
input wire logic  [3:0] rxq_0_osc_qb_dp, 
input wire logic   rxq_0_q_en, 
input wire logic   rxq_1_osc_dir_q_dp, 
input wire logic   rxq_1_osc_dir_qb_dp, 
input wire logic  [3:0] rxq_1_osc_q_dp, 
input wire logic  [3:0] rxq_1_osc_qb_dp, 
input wire logic   rxq_1_q_en, 
input wire logic   rxq_2_osc_dir_q_dp, 
input wire logic   rxq_2_osc_dir_qb_dp, 
input wire logic  [3:0] rxq_2_osc_q_dp, 
input wire logic  [3:0] rxq_2_osc_qb_dp, 
input wire logic   rxq_2_q_en, 
input wire logic   rxq_3_osc_dir_q_dp, 
input wire logic   rxq_3_osc_dir_qb_dp, 
input wire logic  [3:0] rxq_3_osc_q_dp, 
input wire logic  [3:0] rxq_3_osc_qb_dp, 
input wire logic   rxq_3_q_en, 
input wire logic   rxq_4_osc_dir_q_dp, 
input wire logic   rxq_4_osc_dir_qb_dp, 
input wire logic  [3:0] rxq_4_osc_q_dp, 
input wire logic  [3:0] rxq_4_osc_qb_dp, 
input wire logic   rxq_4_q_en, 
input wire logic   rxq_5_osc_dir_q_dp, 
input wire logic   rxq_5_osc_dir_qb_dp, 
input wire logic  [3:0] rxq_5_osc_q_dp, 
input wire logic  [3:0] rxq_5_osc_qb_dp, 
input wire logic   rxq_5_q_en, 
input wire logic   rxq_6_osc_dir_q_dp, 
input wire logic   rxq_6_osc_dir_qb_dp, 
input wire logic  [3:0] rxq_6_osc_q_dp, 
input wire logic  [3:0] rxq_6_osc_qb_dp, 
input wire logic   rxq_6_q_en, 
input wire logic   rxq_7_osc_dir_q_dp, 
input wire logic   rxq_7_osc_dir_qb_dp, 
input wire logic  [3:0] rxq_7_osc_q_dp, 
input wire logic  [3:0] rxq_7_osc_qb_dp, 
input wire logic   rxq_7_q_en, 
input  [5:0] tx_0_dly_ctrl, 
input   tx_0_dly_gear, 
input wire logic  [3:0] tx_0_drv_imp, 
input wire logic  [2:0] tx_0_drv_preem, 
input wire logic   tx_0_en, 
input wire logic   tx_0_highz, 
input  [3:0] tx_0_preemp_sec_dly, 
input wire logic  [2:0] tx_0_preemp_sec_en, 
input wire logic   tx_0_ser_lpb_en, 
input wire logic   tx_0_serdes_byp_out, 
input wire logic   tx_0_serdes_byp_sel, 
input wire logic  [15:0] tx_0_td, 
input  [5:0] tx_1_dly_ctrl, 
input   tx_1_dly_gear, 
input wire logic  [3:0] tx_1_drv_imp, 
input wire logic  [2:0] tx_1_drv_preem, 
input wire logic   tx_1_en, 
input wire logic   tx_1_highz, 
input  [3:0] tx_1_preemp_sec_dly, 
input wire logic  [2:0] tx_1_preemp_sec_en, 
input wire logic   tx_1_ser_lpb_en, 
input wire logic   tx_1_serdes_byp_out, 
input wire logic   tx_1_serdes_byp_sel, 
input wire logic  [15:0] tx_1_td, 
input  [5:0] tx_2_dly_ctrl, 
input   tx_2_dly_gear, 
input wire logic  [3:0] tx_2_drv_imp, 
input wire logic  [2:0] tx_2_drv_preem, 
input wire logic   tx_2_en, 
input wire logic   tx_2_highz, 
input  [3:0] tx_2_preemp_sec_dly, 
input wire logic  [2:0] tx_2_preemp_sec_en, 
input wire logic   tx_2_ser_lpb_en, 
input wire logic   tx_2_serdes_byp_out, 
input wire logic   tx_2_serdes_byp_sel, 
input wire logic  [15:0] tx_2_td, 
input  [5:0] tx_3_dly_ctrl, 
input   tx_3_dly_gear, 
input wire logic  [3:0] tx_3_drv_imp, 
input wire logic  [2:0] tx_3_drv_preem, 
input wire logic   tx_3_en, 
input wire logic   tx_3_highz, 
input  [3:0] tx_3_preemp_sec_dly, 
input wire logic  [2:0] tx_3_preemp_sec_en, 
input wire logic   tx_3_ser_lpb_en, 
input wire logic   tx_3_serdes_byp_out, 
input wire logic   tx_3_serdes_byp_sel, 
input wire logic  [15:0] tx_3_td, 
input  [5:0] tx_4_dly_ctrl, 
input   tx_4_dly_gear, 
input wire logic  [3:0] tx_4_drv_imp, 
input wire logic  [2:0] tx_4_drv_preem, 
input wire logic   tx_4_en, 
input wire logic   tx_4_highz, 
input  [3:0] tx_4_preemp_sec_dly, 
input wire logic  [2:0] tx_4_preemp_sec_en, 
input wire logic   tx_4_ser_lpb_en, 
input wire logic   tx_4_serdes_byp_out, 
input wire logic   tx_4_serdes_byp_sel, 
input wire logic  [15:0] tx_4_td, 
input  [5:0] tx_5_dly_ctrl, 
input   tx_5_dly_gear, 
input wire logic  [3:0] tx_5_drv_imp, 
input wire logic  [2:0] tx_5_drv_preem, 
input wire logic   tx_5_en, 
input wire logic   tx_5_highz, 
input  [3:0] tx_5_preemp_sec_dly, 
input wire logic  [2:0] tx_5_preemp_sec_en, 
input wire logic   tx_5_ser_lpb_en, 
input wire logic   tx_5_serdes_byp_out, 
input wire logic   tx_5_serdes_byp_sel, 
input wire logic  [15:0] tx_5_td, 
input  [5:0] tx_6_dly_ctrl, 
input   tx_6_dly_gear, 
input wire logic  [3:0] tx_6_drv_imp, 
input wire logic  [2:0] tx_6_drv_preem, 
input wire logic   tx_6_en, 
input wire logic   tx_6_highz, 
input  [3:0] tx_6_preemp_sec_dly, 
input wire logic  [2:0] tx_6_preemp_sec_en, 
input wire logic   tx_6_ser_lpb_en, 
input wire logic   tx_6_serdes_byp_out, 
input wire logic   tx_6_serdes_byp_sel, 
input wire logic  [15:0] tx_6_td, 
input  [5:0] tx_7_dly_ctrl, 
input   tx_7_dly_gear, 
input wire logic  [3:0] tx_7_drv_imp, 
input wire logic  [2:0] tx_7_drv_preem, 
input wire logic   tx_7_en, 
input wire logic   tx_7_highz, 
input  [3:0] tx_7_preemp_sec_dly, 
input wire logic  [2:0] tx_7_preemp_sec_en, 
input wire logic   tx_7_ser_lpb_en, 
input wire logic   tx_7_serdes_byp_out, 
input wire logic   tx_7_serdes_byp_sel, 
input wire logic  [15:0] tx_7_td
`ifdef WAV_D2D_INCLUDE_PG
 ,
input wire logic   vdda, 
input wire logic   vdda_ck, 
input wire logic   vdda_rpll, 
input  vddq, 
input wire logic   vss );
`endif
);
`ifndef WAV_D2D_INCLUDE_PG
wire vdda_rpll = 1'b1;
wire vdda_ck   = 1'b1;
wire vdda      = 1'b1;
wire vddq      = 1'b1;
wire vss       = 1'b0;
`endif


wire logic net327 ;

wire logic net328 ;

wire vldo ;

wire logic net10 ;

wire logic pll_clk180 ;

wire logic pll_clk0 ;



WavD2DAnalogPhy_8lane_gf12lpp_wphy_ldo_08to02 I5 ( .ibias_5u(ext_ibias_5u), .ena(ldo_ena),
     .fba(net10), .fbb(net10), .byp(ldo_byp), .highz(ldo_highz),
     .vout(vldo), .mode(ldo_mode[7:0]), .vdda(vdda),
     .lvl(ldo_lvl[5:0]), .refsel(ldo_refsel), .vss(vss));
WavD2DAnalogPhy_8lane_gf12lpp_WavD2DAnalogPhy_8lane_gf12lpp_WavRpllAna IPLL (
     .rpll_bias_lvl(rpll_bias_lvl[3:0]), .vdda(vdda_rpll),
     .rpll_prop_ctrl(rpll_prop_ctrl[4:0]),
     .rpll_prop_c_ctrl(rpll_prop_c_ctrl[1:0]),
     .rpll_post_div_sel(rpll_post_div_sel[1:0]),
     .rpll_pfd_mode(rpll_pfd_mode[1:0]), .rpll_mode(rpll_mode[7:0]),
     .rpll_int_ctrl(rpll_int_ctrl[4:0]), .vss(vss),
     .refclk_out(refclk_out), .refclk(refclk_in),
     .rpll_sel_refclk_alt(rpll_sel_refclk_alt),
     .rpll_reset(rpll_reset), .rpll_prop_r_ctrl(rpll_prop_r_ctrl[1:0]),
     .clk270(net328), .clk180(pll_clk180), .clk90(net327),
     .clk0(pll_clk0), .rpll_refclk_out(rpll_refclk_out),
     .rpll_fbclk(rpll_fbclk), .rpll_fbdiv_sel(rpll_fbdiv_sel[8:0]),
     .rpll_ena(rpll_ena), .rpll_dtest_sel(rpll_dtest_sel[2:0]),
     .rpll_dbl_clk_sel(rpll_dbl_clk_sel),
     .rpll_cp_int_mode(rpll_cp_int_mode),
     .rpll_byp_clk_sel(rpll_byp_clk_sel),
     .rpll_refclk_alt(rpll_refclk_alt), .rpll_ret(rpll_ret),
     .rpll_clk_div16(rpll_clk_div16), .rpll_dtest_out(rpll_dtest_out));
WavD2DAnalogPhy_8lane_gf12lpp_wav_wlink_8l_ana WLINK_8L ( .vdda(vdda), .vdda_ck(vdda_ck),
     .vddq(vldo), .vss(vss),
     .clk_rx_coreclk_div16(clk_rx_coreclk_div16),
     .clk_rx_dll_cal_dat(clk_rx_dll_cal_dat),
     .clk_rx_dtest(clk_rx_dtst),
     .clk_rx_rcvr_bypass_in_n(clk_rx_rcvr_bypass_in_n),
     .clk_rx_rcvr_bypass_in_p(clk_rx_rcvr_bypass_in_p),
     .clk_tx_coreclk_div16(clk_tx_coreclk_div16),
     .pad_clk_txn(pad_clk_txn), .pad_clk_txp(pad_clk_txp),
     .pad_tx0(pad_tx_0), .pad_tx1(pad_tx_1), .pad_tx2(pad_tx_2),
     .pad_tx3(pad_tx_3), .pad_tx4(pad_tx_4), .pad_tx5(pad_tx_5),
     .pad_tx6(pad_tx_6), .pad_tx7(pad_tx_7),
     .rx0_clk_div16(rx_0_clk_div16), .rx0_idata(rx_0_idata[15:0]),
     .rx0_qdata(rxq_0_qdata[15:0]),
     .rx0_serdes_byp_in(rx_0_serdes_byp_in),
     .rx1_clk_div16(rx_1_clk_div16), .rx1_idata(rx_1_idata[15:0]),
     .rx1_qdata(rxq_1_qdata[15:0]),
     .rx1_serdes_byp_in(rx_1_serdes_byp_in),
     .rx2_clk_div16(rx_2_clk_div16), .rx2_idata(rx_2_idata[15:0]),
     .rx2_qdata(rxq_2_qdata[15:0]),
     .rx2_serdes_byp_in(rx_2_serdes_byp_in),
     .rx3_clk_div16(rx_3_clk_div16), .rx3_idata(rx_3_idata[15:0]),
     .rx3_qdata(rxq_3_qdata[15:0]),
     .rx3_serdes_byp_in(rx_3_serdes_byp_in),
     .rx4_clk_div16(rx_4_clk_div16), .rx4_idata(rx_4_idata[15:0]),
     .rx4_qdata(rxq_4_qdata[15:0]),
     .rx4_serdes_byp_in(rx_4_serdes_byp_in),
     .rx5_clk_div16(rx_5_clk_div16), .rx5_idata(rx_5_idata[15:0]),
     .rx5_qdata(rxq_5_qdata[15:0]),
     .rx5_serdes_byp_in(rx_5_serdes_byp_in),
     .rx6_clk_div16(rx_6_clk_div16), .rx6_idata(rx_6_idata[15:0]),
     .rx6_qdata(rxq_6_qdata[15:0]),
     .rx6_serdes_byp_in(rx_6_serdes_byp_in),
     .rx7_clk_div16(rx_7_clk_div16), .rx7_idata(rx_7_idata[15:0]),
     .rx7_qdata(rxq_7_qdata[15:0]),
     .rx7_serdes_byp_in(rx_7_serdes_byp_in), .tie_hi(tie_hi),
     .tie_lo(tie_lo), .tx0_tclk_div16(tx_0_clk_div16),
     .tx1_tclk_div16(tx_1_clk_div16), .tx2_tclk_div16(tx_2_clk_div16),
     .tx3_tclk_div16(tx_3_clk_div16), .tx4_tclk_div16(tx_4_clk_div16),
     .tx5_tclk_div16(tx_5_clk_div16), .tx6_tclk_div16(tx_6_clk_div16),
     .tx7_tclk_div16(tx_7_clk_div16),
     .clk_rx_dll_cal_en(clk_rx_dll_cal_en),
     .clk_rx_dll_ctrl(clk_rx_dll_ctrl[5:0]),
     .clk_rx_dll_en(clk_rx_dll_en),
     .clk_rx_dll_gear(clk_rx_dll_gear[1:0]),
     .clk_rx_dtest_div(clk_rx_dtst_div[3:0]),
     .clk_rx_dtest_en(clk_rx_dtst_en),
     .clk_rx_dtest_in(clk_rx_dtst_in),
     .clk_rx_en_rx_div2_clk(clk_rx_en_rx_div2_clk),
     .clk_rx_en_rx_div16_clk(clk_rx_en_rx_div16_clk),
     .clk_rx_i_pi_code(clk_rx_i_pi_code[15:0]),
     .clk_rx_i_pi_en(clk_rx_i_pi_en),
     .clk_rx_i_pi_quad(clk_rx_i_pi_quad[1:0]),
     .clk_rx_pi_gear(clk_rx_pi_gear[3:0]),
     .clk_rx_pi_xcpl(clk_rx_pi_xcpl[3:0]),
     .clk_rx_q_pi_code(clk_rx_q_pi_code[15:0]),
     .clk_rx_q_pi_en(clk_rx_q_pi_en),
     .clk_rx_q_pi_quad(clk_rx_q_pi_quad[1:0]),
     .clk_rx_rcvr_ac_mode(clk_rx_rcvr_ac_mode),
     .clk_rx_rcvr_bypass_sel(clk_rx_rcvr_bypass_sel),
     .clk_rx_rcvr_en(clk_rx_rcvr_en),
     .clk_rx_rcvr_fb_en(clk_rx_rcvr_fb_en),
     .clk_rx_rcvr_odt_ctrl(clk_rx_rcvr_odt_ctrl[3:0]),
     .clk_rx_rcvr_odt_dc_mode(clk_rx_rcvr_odt_dc_mode),
     .clk_rx_reset_sync(clk_rx_reset_sync),
     .clk_rx_ser_lpb_en(clk_rx_ser_lpb_en),
     .clk_rx_test_sel(clk_rx_dtst_sel[2:0]),
     .clk_rx_vref_en(clk_rx_vref_en),
     .clk_rx_vref_lvl(clk_rx_vref_lvl[5:0]),
     .clk_tx_drv_bypass_out_n(clk_tx_drv_bypass_out_n),
     .clk_tx_drv_bypass_out_p(clk_tx_drv_bypass_out_p),
     .clk_tx_drv_bypass_sel(clk_tx_drv_bypass_sel),
     .clk_tx_drv_ctrl(clk_tx_drv_ctrl[3:0]),
     .clk_tx_drv_en(clk_tx_drv_en),
     .clk_tx_drv_preemp(clk_tx_drv_preemp[2:0]),
     .clk_tx_en_tx_div2_clk(clk_tx_en_tx_div2_clk),
     .clk_tx_en_tx_div16_clk(clk_tx_en_tx_div16_clk),
     .clk_tx_reset_sync(clk_tx_reset_sync),
     .clk_tx_ser_lpb_en(clk_tx_ser_lpb_en), .pad_clk_rxn(pad_clk_rxn),
     .pad_clk_rxp(pad_clk_rxp), .pad_rx0(pad_rx_0), .pad_rx1(pad_rx_1),
     .pad_rx2(pad_rx_2), .pad_rx3(pad_rx_3), .pad_rx4(pad_rx_4),
     .pad_rx5(pad_rx_5), .pad_rx6(pad_rx_6), .pad_rx7(pad_rx_7),
     .pll_clk0(pll_clk0), .pll_clk180(pll_clk180),
     .rx0_cal_en(rx_0_cal_en), .rx0_i_en(rx_0_i_en),
     .rx0_odt(rx_0_odt_ctrl[3:0]), .rx0_odt_dc_mode(rx_0_odt_dc_mode),
     .rx0_osc_dir_i_dp(rx_0_osc_dir_i_dp),
     .rx0_osc_dir_ib_dp(rx_0_osc_dir_ib_dp),
     .rx0_osc_dir_q_dp(rxq_0_osc_dir_q_dp),
     .rx0_osc_dir_qb_dp(rxq_0_osc_dir_qb_dp),
     .rx0_osc_i_dp(rx_0_osc_i_dp[3:0]),
     .rx0_osc_ib_dp(rx_0_osc_ib_dp[3:0]),
     .rx0_osc_q_dp(rxq_0_osc_q_dp[3:0]),
     .rx0_osc_qb_dp(rxq_0_osc_qb_dp[3:0]), .rx0_q_en(rxq_0_q_en),
     .rx0_serdes_byp_sel(rx_0_serdes_byp_sel),
     .rx0_serlb_en(rx_0_serlb_en), .rx1_cal_en(rx_1_cal_en),
     .rx1_i_en(rx_1_i_en), .rx1_odt(rx_1_odt_ctrl[3:0]),
     .rx1_odt_dc_mode(rx_1_odt_dc_mode),
     .rx1_osc_dir_i_dp(rx_1_osc_dir_i_dp),
     .rx1_osc_dir_ib_dp(rx_1_osc_dir_ib_dp),
     .rx1_osc_dir_q_dp(rxq_1_osc_dir_q_dp),
     .rx1_osc_dir_qb_dp(rxq_1_osc_dir_qb_dp),
     .rx1_osc_i_dp(rx_1_osc_i_dp[3:0]),
     .rx1_osc_ib_dp(rx_1_osc_ib_dp[3:0]),
     .rx1_osc_q_dp(rxq_1_osc_q_dp[3:0]),
     .rx1_osc_qb_dp(rxq_1_osc_qb_dp[3:0]), .rx1_q_en(rxq_1_q_en),
     .rx1_serdes_byp_sel(rx_1_serdes_byp_sel),
     .rx1_serlb_en(rx_1_serlb_en), .rx2_cal_en(rx_2_cal_en),
     .rx2_i_en(rx_2_i_en), .rx2_odt(rx_2_odt_ctrl[3:0]),
     .rx2_odt_dc_mode(rx_2_odt_dc_mode),
     .rx2_osc_dir_i_dp(rx_2_osc_dir_i_dp),
     .rx2_osc_dir_ib_dp(rx_2_osc_dir_ib_dp),
     .rx2_osc_dir_q_dp(rxq_2_osc_dir_q_dp),
     .rx2_osc_dir_qb_dp(rxq_2_osc_dir_qb_dp),
     .rx2_osc_i_dp(rx_2_osc_i_dp[3:0]),
     .rx2_osc_ib_dp(rx_2_osc_ib_dp[3:0]),
     .rx2_osc_q_dp(rxq_2_osc_q_dp[3:0]),
     .rx2_osc_qb_dp(rxq_2_osc_qb_dp[3:0]), .rx2_q_en(rxq_2_q_en),
     .rx2_serdes_byp_sel(rx_2_serdes_byp_sel),
     .rx2_serlb_en(rx_2_serlb_en), .rx3_cal_en(rx_3_cal_en),
     .rx3_i_en(rx_3_i_en), .rx3_odt(rx_3_odt_ctrl[3:0]),
     .rx3_odt_dc_mode(rx_3_odt_dc_mode),
     .rx3_osc_dir_i_dp(rx_3_osc_dir_i_dp),
     .rx3_osc_dir_ib_dp(rx_3_osc_dir_ib_dp),
     .rx3_osc_dir_q_dp(rxq_3_osc_dir_q_dp),
     .rx3_osc_dir_qb_dp(rxq_3_osc_dir_qb_dp),
     .rx3_osc_i_dp(rx_3_osc_i_dp[3:0]),
     .rx3_osc_ib_dp(rx_3_osc_ib_dp[3:0]),
     .rx3_osc_q_dp(rxq_3_osc_q_dp[3:0]),
     .rx3_osc_qb_dp(rxq_3_osc_qb_dp[3:0]), .rx3_q_en(rxq_3_q_en),
     .rx3_serdes_byp_sel(rx_3_serdes_byp_sel),
     .rx3_serlb_en(rx_3_serlb_en), .rx4_cal_en(rx_4_cal_en),
     .rx4_i_en(rx_4_i_en), .rx4_odt(rx_4_odt_ctrl[3:0]),
     .rx4_odt_dc_mode(rx_4_odt_dc_mode),
     .rx4_osc_dir_i_dp(rx_4_osc_dir_i_dp),
     .rx4_osc_dir_ib_dp(rx_4_osc_dir_ib_dp),
     .rx4_osc_dir_q_dp(rxq_4_osc_dir_q_dp),
     .rx4_osc_dir_qb_dp(rxq_4_osc_dir_qb_dp),
     .rx4_osc_i_dp(rx_4_osc_i_dp[3:0]),
     .rx4_osc_ib_dp(rx_4_osc_ib_dp[3:0]),
     .rx4_osc_q_dp(rxq_4_osc_q_dp[3:0]),
     .rx4_osc_qb_dp(rxq_4_osc_qb_dp[3:0]), .rx4_q_en(rxq_4_q_en),
     .rx4_serdes_byp_sel(rx_4_serdes_byp_sel),
     .rx4_serlb_en(rx_4_serlb_en), .rx5_cal_en(rx_5_cal_en),
     .rx5_i_en(rx_5_i_en), .rx5_odt(rx_5_odt_ctrl[3:0]),
     .rx5_odt_dc_mode(rx_5_odt_dc_mode),
     .rx5_osc_dir_i_dp(rx_5_osc_dir_i_dp),
     .rx5_osc_dir_ib_dp(rx_5_osc_dir_ib_dp),
     .rx5_osc_dir_q_dp(rxq_5_osc_dir_q_dp),
     .rx5_osc_dir_qb_dp(rxq_5_osc_dir_qb_dp),
     .rx5_osc_i_dp(rx_5_osc_i_dp[3:0]),
     .rx5_osc_ib_dp(rx_5_osc_ib_dp[3:0]),
     .rx5_osc_q_dp(rxq_5_osc_q_dp[3:0]),
     .rx5_osc_qb_dp(rxq_5_osc_qb_dp[3:0]), .rx5_q_en(rxq_5_q_en),
     .rx5_serdes_byp_sel(rx_5_serdes_byp_sel),
     .rx5_serlb_en(rx_5_serlb_en), .rx6_cal_en(rx_6_cal_en),
     .rx6_i_en(rx_6_i_en), .rx6_odt(rx_6_odt_ctrl[3:0]),
     .rx6_odt_dc_mode(rx_6_odt_dc_mode),
     .rx6_osc_dir_i_dp(rx_6_osc_dir_i_dp),
     .rx6_osc_dir_ib_dp(rx_6_osc_dir_ib_dp),
     .rx6_osc_dir_q_dp(rxq_6_osc_dir_q_dp),
     .rx6_osc_dir_qb_dp(rxq_6_osc_dir_qb_dp),
     .rx6_osc_i_dp(rx_6_osc_i_dp[3:0]),
     .rx6_osc_ib_dp(rx_6_osc_ib_dp[3:0]),
     .rx6_osc_q_dp(rxq_6_osc_q_dp[3:0]),
     .rx6_osc_qb_dp(rxq_6_osc_qb_dp[3:0]), .rx6_q_en(rxq_6_q_en),
     .rx6_serdes_byp_sel(rx_6_serdes_byp_sel),
     .rx6_serlb_en(rx_6_serlb_en), .rx7_cal_en(rx_7_cal_en),
     .rx7_i_en(rx_7_i_en), .rx7_odt(rx_7_odt_ctrl[3:0]),
     .rx7_odt_dc_mode(rx_7_odt_dc_mode),
     .rx7_osc_dir_i_dp(rx_7_osc_dir_i_dp),
     .rx7_osc_dir_ib_dp(rx_7_osc_dir_ib_dp),
     .rx7_osc_dir_q_dp(rxq_7_osc_dir_q_dp),
     .rx7_osc_dir_qb_dp(rxq_7_osc_dir_qb_dp),
     .rx7_osc_i_dp(rx_7_osc_i_dp[3:0]),
     .rx7_osc_ib_dp(rx_7_osc_ib_dp[3:0]),
     .rx7_osc_q_dp(rxq_7_osc_q_dp[3:0]),
     .rx7_osc_qb_dp(rxq_7_osc_qb_dp[3:0]), .rx7_q_en(rxq_7_q_en),
     .rx7_serdes_byp_sel(rx_7_serdes_byp_sel),
     .rx7_serlb_en(rx_7_serlb_en), .tx0_dly_ctrl(tx_0_dly_ctrl[5:0]),
     .tx0_dly_gear(tx_0_dly_gear), .tx0_drv_imp(tx_0_drv_imp[3:0]),
     .tx0_drv_preem(tx_0_drv_preem[2:0]), .tx0_en(tx_0_en),
     .tx0_highz(tx_0_highz),
     .tx0_preemp_sec_dly(tx_0_preemp_sec_dly[3:0]),
     .tx0_preemp_sec_en(tx_0_preemp_sec_en[2:0]),
     .tx0_ser_lpb_en(tx_0_ser_lpb_en),
     .tx0_serdes_byp_out(tx_0_serdes_byp_out),
     .tx0_serdes_byp_sel(tx_0_serdes_byp_sel), .tx0_td(tx_0_td[15:0]),
     .tx1_dly_ctrl(tx_1_dly_ctrl[5:0]), .tx1_dly_gear(tx_1_dly_gear),
     .tx1_drv_imp(tx_1_drv_imp[3:0]),
     .tx1_drv_preem(tx_1_drv_preem[2:0]), .tx1_en(tx_1_en),
     .tx1_highz(tx_1_highz),
     .tx1_preemp_sec_dly(tx_1_preemp_sec_dly[3:0]),
     .tx1_preemp_sec_en(tx_1_preemp_sec_en[2:0]),
     .tx1_ser_lpb_en(tx_1_ser_lpb_en),
     .tx1_serdes_byp_out(tx_1_serdes_byp_out),
     .tx1_serdes_byp_sel(tx_1_serdes_byp_sel), .tx1_td(tx_1_td[15:0]),
     .tx2_dly_ctrl(tx_2_dly_ctrl[5:0]), .tx2_dly_gear(tx_2_dly_gear),
     .tx2_drv_imp(tx_2_drv_imp[3:0]),
     .tx2_drv_preem(tx_2_drv_preem[2:0]), .tx2_en(tx_2_en),
     .tx2_highz(tx_2_highz),
     .tx2_preemp_sec_dly(tx_2_preemp_sec_dly[3:0]),
     .tx2_preemp_sec_en(tx_2_preemp_sec_en[2:0]),
     .tx2_ser_lpb_en(tx_2_ser_lpb_en),
     .tx2_serdes_byp_out(tx_2_serdes_byp_out),
     .tx2_serdes_byp_sel(tx_2_serdes_byp_sel), .tx2_td(tx_2_td[15:0]),
     .tx3_dly_ctrl(tx_3_dly_ctrl[5:0]), .tx3_dly_gear(tx_3_dly_gear),
     .tx3_drv_imp(tx_3_drv_imp[3:0]),
     .tx3_drv_preem(tx_3_drv_preem[2:0]), .tx3_en(tx_3_en),
     .tx3_highz(tx_3_highz),
     .tx3_preemp_sec_dly(tx_3_preemp_sec_dly[3:0]),
     .tx3_preemp_sec_en(tx_3_preemp_sec_en[2:0]),
     .tx3_ser_lpb_en(tx_3_ser_lpb_en),
     .tx3_serdes_byp_out(tx_3_serdes_byp_out),
     .tx3_serdes_byp_sel(tx_3_serdes_byp_sel), .tx3_td(tx_3_td[15:0]),
     .tx4_dly_ctrl(tx_4_dly_ctrl[5:0]), .tx4_dly_gear(tx_4_dly_gear),
     .tx4_drv_imp(tx_4_drv_imp[3:0]),
     .tx4_drv_preem(tx_4_drv_preem[2:0]), .tx4_en(tx_4_en),
     .tx4_highz(tx_4_highz),
     .tx4_preemp_sec_dly(tx_4_preemp_sec_dly[3:0]),
     .tx4_preemp_sec_en(tx_4_preemp_sec_en[2:0]),
     .tx4_ser_lpb_en(tx_4_ser_lpb_en),
     .tx4_serdes_byp_out(tx_4_serdes_byp_out),
     .tx4_serdes_byp_sel(tx_4_serdes_byp_sel), .tx4_td(tx_4_td[15:0]),
     .tx5_dly_ctrl(tx_5_dly_ctrl[5:0]), .tx5_dly_gear(tx_5_dly_gear),
     .tx5_drv_imp(tx_5_drv_imp[3:0]),
     .tx5_drv_preem(tx_5_drv_preem[2:0]), .tx5_en(tx_5_en),
     .tx5_highz(tx_5_highz),
     .tx5_preemp_sec_dly(tx_5_preemp_sec_dly[3:0]),
     .tx5_preemp_sec_en(tx_5_preemp_sec_en[2:0]),
     .tx5_ser_lpb_en(tx_5_ser_lpb_en),
     .tx5_serdes_byp_out(tx_5_serdes_byp_out),
     .tx5_serdes_byp_sel(tx_5_serdes_byp_sel), .tx5_td(tx_5_td[15:0]),
     .tx6_dly_ctrl(tx_6_dly_ctrl[5:0]), .tx6_dly_gear(tx_6_dly_gear),
     .tx6_drv_imp(tx_6_drv_imp[3:0]),
     .tx6_drv_preem(tx_6_drv_preem[2:0]), .tx6_en(tx_6_en),
     .tx6_highz(tx_6_highz),
     .tx6_preemp_sec_dly(tx_6_preemp_sec_dly[3:0]),
     .tx6_preemp_sec_en(tx_6_preemp_sec_en[2:0]),
     .tx6_ser_lpb_en(tx_6_ser_lpb_en),
     .tx6_serdes_byp_out(tx_6_serdes_byp_out),
     .tx6_serdes_byp_sel(tx_6_serdes_byp_sel), .tx6_td(tx_6_td[15:0]),
     .tx7_dly_ctrl(tx_7_dly_ctrl[5:0]), .tx7_dly_gear(tx_7_dly_gear),
     .tx7_drv_imp(tx_7_drv_imp[3:0]),
     .tx7_drv_preem(tx_7_drv_preem[2:0]), .tx7_en(tx_7_en),
     .tx7_highz(tx_7_highz),
     .tx7_preemp_sec_dly(tx_7_preemp_sec_dly[3:0]),
     .tx7_preemp_sec_en(tx_7_preemp_sec_en[2:0]),
     .tx7_ser_lpb_en(tx_7_ser_lpb_en),
     .tx7_serdes_byp_out(tx_7_serdes_byp_out),
     .tx7_serdes_byp_sel(tx_7_serdes_byp_sel), .tx7_td(tx_7_td[15:0]));

endmodule

/* This alias module is for use internal to the netlister only.
 Please
      do not use the same name for modules or
 assume the existence of 
     this module. */

module WavD2DAnalogPhy_8lane_gf12lpp_cds_alias( cds_alias_sig, cds_alias_sig);

parameter width = 1;

     input [width:1] cds_alias_sig;

endmodule

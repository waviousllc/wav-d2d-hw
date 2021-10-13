import shutil


rpll_dir    = "/prj/wavious/dev/frontend/core/workareas/sbridges/rpll/rtl/"
rpll_files  = ["rpll_dig_top.v", "rpll_clk_control.v", "rpll_regs_regs_top.v", "rpll_sm.v"]

for f in rpll_files:
  shutil.copy(rpll_dir + f, f)

shutil.copy("/prj/wavious/dev/frontend/shared/workareas/sbridges/pll_shared/dev/wav_pll_shared_lib.v",    "wav_pll_shared_lib.v")
shutil.copy("/prj/wavious/dev/frontend/shared/workareas/sbridges/component/dev/rtl/wav_component_lib.sv", "wav_component_lib.sv")
shutil.copy("/prj/wavious/dev/frontend/tech/shared/latest/wav_legacy_stdcell_lib.v", "wav_legacy_stdcell_lib.v")
shutil.copy("/prj/wavious/dev/frontend/tech/shared/latest/wav_stdcell_lib.sv", "wav_stdcell_lib.sv")

shutil.copy("/prj/wavious/dev/frontend/shared/workareas/sbridges/jtag/dev/rtl/wav_jtag_lib.sv", "wav_jtag_lib.sv")

shutil.copy("/prj/wavious/dev/frontend/core/workareas/sbridges/wtm_slave_wlp12x/behavioral/WavD2DAnalogPhy_8lane_gf12lpp.sv", "WavD2DAnalogPhy_8lane_gf12lpp.sv")

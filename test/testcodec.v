`define SYSRST            I_tb_codec_top.I_sys_rst_fm
`define CLK50M            I_tb_codec_top.I_sys_clk50MHz_fm
`define CODECI2C          I_tb_codec_top.I_sys_i2c_fm
//`define CODECDaC          I_tb_codec_top.I_codec_top.data_acces_controller


module test_codec_top();
  
tb_codec_top I_tb_codec_top();



initial
begin
  
   `SYSRST.rstOn;
   `CODECI2C.disablei2c;
   `CLK50M.waitCycles(3);   
   `CODECI2C.enablei2c;
   `CODECI2C.i2cpacket;
   `CLK50M.waitCycles(3);
   `SYSRST.rstOff;
   
   
       
#10000 $finish(); 


end  
  
endmodule 
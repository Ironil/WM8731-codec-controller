`timescale 1ns/100ps

`define SYSRST            I_tb_codec_top.I_sys_rst_fm
`define CLK50M            I_tb_codec_top.I_sys_clk50MHz_fm
`define I2CFM             I_tb_codec_top.I_sys_i2c_fm
`define TOP				           I_tb_codec_top		//t: Enable & disable wr_i2c
//`define CODECDaC          I_tb_codec_top.I_codec_top.data_acces_controller


module test_codec_top();

   //La variable error en la que anirem sumant els errors
  integer error;
  
tb_codec_top I_tb_codec_top();




initial
begin
  
   `SYSRST.rstOn;
   
   `CLK50M.waitCycles(3);   
   `SYSRST.rstOff;
   `CLK50M.waitCycles(3); 
   
   `CLK50M.waitCycles(3);
   
	fork
	`I2CFM.waitstart;
	`I2CFM.measuresclk;
	`I2CFM.listen_acknowledge(1,24'b101010100011110011000011);
	join
	`I2CFM.waitend;
   
   
       
#1000000 $finish(); 


end  
  
endmodule 

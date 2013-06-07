`timescale 1ns/100ps

`define SYSRST            I_tb_codec_top.I_sys_rst_fm
`define CLK50M            I_tb_codec_top.I_sys_clk50MHz_fm
`define I2CFM             I_tb_codec_top.I_sys_i2c_fm
`define DACFM             I_tb_codec_top.I_dac_fm
`define ADCFM             I_tb_codec_top.I_adc_fm
`define MASTER            I_tb_codec_top.I_master_bus_fm


module test_codec_top();

   //La variable error en la que anirem sumant els errors
  integer error;
  
tb_codec_top I_tb_codec_top();

initial
begin
  
   `SYSRST.rstOn;
   
   `CLK50M.waitCycles(3);   
   `SYSRST.rstOff;
   `CLK50M.waitCycles(10); 
   `MASTER.seti2cpacket(24'h842124);
   `CLK50M.waitCycles(10);
   `MASTER.setDACaudio(32'h24842124);
   `CLK50M.waitCycles(10);
   `MASTER.llegiradcfifoout;
   `ADCFM.adcwrite(32'h24842124);
   
   
   /*
   fork
   `DACFM.dacread
   compara(
   join
   *(¡/
   /*
	fork
	`I2CFM.waitstart;
	`I2CFM.measuresclk;
	`I2CFM.listen_acknowledge(1,24'b101010100011110011000011);
	join
	`I2CFM.waitend;
   */
   
       
#10000000 $finish(); 

end

	task compara;
	  input reg [31:0] d1, d2;
	  begin
    if (d1 != d2) begin
                 $display("Error, transmitted data %h is not the expected value %h", d1, d2);
                 error = error +1;
                 end
  else $display("Correct, transmitted data %h is the expected value %h", d1, d2);    
	
	end
	endtask


  
endmodule 

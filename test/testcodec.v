`timescale 1ns/100ps

`include "global.v"

`define SYSRST            I_tb_codec_top.I_sys_rst_fm
`define CLK50M            I_tb_codec_top.I_sys_clk50MHz_fm
`define I2CFM             I_tb_codec_top.I_sys_i2c_fm
`define DACFM             I_tb_codec_top.I_dac_fm
`define ADCFM             I_tb_codec_top.I_adc_fm
`define MASTER            I_tb_codec_top.I_master_bus_fm


module test_codec_top();

   //La variable error en la que anirem sumant els errors
  integer error;
  
  
  reg [31:0] dades_adc [0:5];
  reg [191:0] dades_a_enviar;
  
  
tb_codec_top I_tb_codec_top();

initial
begin
  error=0;
   `SYSRST.rstOn;
   
   `CLK50M.waitCycles(10);   
   `SYSRST.rstOff;
   
  dades_adc[0] =32'h24842214;
  dades_adc[1] =32'h24842204;
  dades_adc[2] =32'h24842194;
  dades_adc[3] =32'h24842184;
  dades_adc[4] =32'h24842174;
  dades_adc[5] =32'h24842164;
  
	dades_a_enviar = {dades_adc[0],dades_adc[1],dades_adc[2],dades_adc[3],dades_adc[4],dades_adc[5]};
   //fork
   testadc(dades_a_enviar);
   testdac;
   //join
   //testi2c;
   check_error;
   
   
       
#1000000 $finish(); 

end

task checkReceivedADC;

input[31:0] dataToReceive;

 begin
  
     `MASTER.simpleRead(`ADDR_ADC_AUDIO);
 if (dataToReceive != `MASTER.readData) begin
                                            $display("ADC:Error, transmitted data %h is not the expected value %h", `MASTER.readData, dataToReceive);
                                            error = error +1;
                                           end
   else $display("ADC:Correct, transmitted data %h is the expected value %h", `MASTER.readData, dataToReceive);
  end
  
endtask

task ADC_get_ready;
	input [191:0] dades_enviar;
	reg [31:0] dades_adc [0:5];
	integer i;
	
	
	begin
	
	dades_adc[0] =dades_enviar[31:0];
	dades_adc[1] =dades_enviar[63:32];
	dades_adc[2] =dades_enviar[95:64];
	dades_adc[3] =dades_enviar[127:96];
	dades_adc[4] =dades_enviar[159:128];
	dades_adc[5] =dades_enviar[191:160];
	
	i = 0;
	`ADCFM.adcwrite(32'hFFFFAAAA);
	
	fork
		repeat(6) begin
			`ADCFM.adcwrite(dades_adc[i]);
			i = i+1;
		end
		while(`MASTER.readData != 32'hFFFFAAAA) begin
			`MASTER.simpleRead(`ADDR_ADC_AUDIO);
		end
	join
	i = 0;
	repeat(6) begin
		checkReceivedADC(dades_adc[i]);
		i = i+1;
	end
	end
endtask

task transmitADC_and_check;

  input[31:0] dataToTransmit;
  
  begin
   `ADCFM.adcwrite(dataToTransmit);
   checkReceivedADC(dataToTransmit);
  end
 
endtask


task transmitDAC_and_check;

  input[31:0] dataToTransmit;
  
  begin
   `MASTER.setDACaudio(dataToTransmit);
   `DACFM.dacread(dataToTransmit);
  end
endtask

/*
task checkReceivedI2C;

input[23:0] dataToReceive;

 begin
   if (dataToReceive != `I2CFM.listen_acknowledge) begin
                                            $display("Error, transmitted data %h is not the expected value %h", `I2CFM.listen_acknowledge, dataToReceive);
                                            error = error +1;
                                           end
   else $display("Correct, transmitted data %h is the expected value %h", `I2CFM.listen_acknowledge, dataToReceive);
 end
endtask
  */

task transmitI2C_and_check;

  input[23:0] dataToTransmit;
  
  begin
   `MASTER.seti2cpacket(dataToTransmit);
   `I2CFM.listen_acknowledge(1,dataToTransmit);
   //checkReceivedI2C(dataToTransmit);
  end
endtask



task check_error;

 begin
   if (error != 0) $display("Test unsuccessful, %d errors", error);
   else $display("Test successful, %d errors", error);
 end
endtask



task testdac;
  begin
    $display("Starting test DAC");
    //`DACFM.measuresclk;
    transmitDAC_and_check(32'h24842129);
    transmitDAC_and_check(32'h24842128);
    transmitDAC_and_check(32'h24842127);
    transmitDAC_and_check(32'h24842126);
    transmitDAC_and_check(32'h24842125);
    transmitDAC_and_check(32'h24842124);
    `SYSRST.rstOn;
    `CLK50M.waitCycles(10);    
    `SYSRST.rstOff;
    transmitDAC_and_check(32'h24842123);    
    transmitDAC_and_check(32'h24842122);
    transmitDAC_and_check(32'h24842121);
    transmitDAC_and_check(32'h24842120);
    //check_error;
  end
 endtask
 
 
task testadc;
input reg [191:0] dades_adc;
  begin
    $display("Starting test ADC");
    `ADCFM.measuresclk;
    ADC_get_ready(dades_adc);
    /*transmitADC_and_check(32'h24842214);
    transmitADC_and_check(32'h24842204);
    transmitADC_and_check(32'h24842194);
    transmitADC_and_check(32'h24842184);
    transmitADC_and_check(32'h24842174);
    transmitADC_and_check(32'h24842164);
    transmitADC_and_check(32'h24842154);
    `SYSRST.rstOn;
    `CLK50M.waitCycles(10);    
    `SYSRST.rstOff;
    transmitADC_and_check(32'h24842144);
    transmitADC_and_check(32'h24842134);
    transmitADC_and_check(32'h24842124);
    transmitADC_and_check(32'h24842114);
    transmitADC_and_check(32'h24842104);    
    //check_error;*/
  end
 endtask


task testi2c;
  begin
    $display("Starting test I2C");
    transmitI2C_and_check(32'h24842124);
    check_error;
  end
 endtask
endmodule

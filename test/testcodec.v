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
   
   `CLK50M.waitCycles(10);   
   `SYSRST.rstOff;
   testdac;
   
   
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

/*task checkReceivedDataMASTER;

input[31:0] dataToReceive;

 begin
   `MASTER.simpleRead(`ADDR_DAC_AUDIO);
   if (dataToReceive != `MASTER.llegiradcfifoout) begin
                                            $display("Error, transmitted data %h is not the expected value %h", `MASTER.llegiradcfifoout, dataToReceive);
                                            error = error +1;
                                           end
   else $display("Correct, transmitted data %h is the expected value %h", `MASTER.llegiradcfifoout, dataToReceive);
  end
  
endtask
*/
task transmitADC_and_check;

  input[31:0] dataToTransmit;
  
  begin
   `ADCFM.adcwrite(dataToTransmit);
   checkReceivedDataMASTER(dataToTransmit);
  end
 
endtask


task checkReceivedDataDAC;

input[31:0] dataToReceive;

 begin
   if (dataToReceive != `DACFM.dacread) begin
                                            $display("Error, transmitted data %h is not the expected value %h", `DACFM.dacread, dataToReceive);
                                            error = error +1;
                                           end
   else $display("Correct, transmitted data %h is the expected value %h", `DACFM.dacread, dataToReceive);
 end
endtask
  

task transmitDAC_and_check;

  input[31:0] dataToTransmit;
  
  begin
   `MASTER.setDACaudio(dataToTransmit);
   checkReceivedDataDAC(dataToTransmit);
  end
endtask



task check_error;

 begin
   if (error != 0) $display("Test unsuccessful, %d errors", error);
   else $display("Test successful, %d errors", error);
 end
endtask



/*

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

*/

task testdac;
  begin
    $display("Starting test DAC");
    transmitDAC_and_check(32'h24842124);
    check_error;
  end
 endtask

  
endmodule 

module sys_i2c_fm (i2c_packet, wr_i2c, i2c_sdat);
  
  output [23:0] i2c_packet; 
  output  wr_i2c;
  output i2c_sdat;
  
  reg [23:0] i2c_packet;
  reg wr_i2c, i2c_sdat;
     
task enablei2c;
 
  begin
    wr_i2c=1;    
  end
endtask
  
task disablei2c;
  
  begin
    wr_i2c =0;    
  end
endtask  

task i2cpacket;

begin  
  i2c_packet = 24'b101010100011110011000011;
  i2c_sdat=1'b0;
end

endtask 

    
endmodule

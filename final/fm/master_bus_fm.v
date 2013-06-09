`timescale 1ns/100ps

`include "global.v"

module master_bus_fm(
    Clk,
    slave_read           ,
    slave_write          ,
    slave_address        ,
    slave_readdata       ,
    slave_writedata      ,
    slave_chipselect     ,
    slave_waitrequest    ,
    slave_beginbursttransfer,
    slave_burstcount     ,
    slave_irq
    );

input           Clk                 ; // Clock

output          slave_read          ; // Read request signal. Acvtive high.
output          slave_write         ; // Write request signal. Active high.
output  [2:0]   slave_address       ; // Bus address.
input   [31:0]  slave_readdata      ; // Read bus.
output  [31:0]  slave_writedata     ; // Write bus.
output          slave_chipselect    ; // Chip select. Read and write operations are allowd when it is asserted. 
                                      // Active high.
input           slave_waitrequest   ;
output          slave_beginbursttransfer; // Indicates burst transfer. Active high.
output  [7:0]   slave_burstcount    ; // Number of transfers in a burst;
input           slave_irq           ;

reg             slave_read          ; // Read request signal. Acvtive high.
reg             slave_write         ; // Write request signal. Active high.
reg     [2:0]   slave_address       ; // Bus address.
reg     [31:0]  slave_writedata     ; // Write bus.
reg             slave_chipselect    ; // Chip select. Read and write operations are allowd when it is asserted. 
                                      // Active high.
reg             slave_beginbursttransfer; // Indicates burst transfer. Active high.
reg     [7:0]   slave_burstcount    ; // Number of transfers in a burst;

reg     [31:0]  readData;

reg     [7:0]   dataArray [0:255]  ;

integer i;
                                                                            
task simpleWrite;

input [31:0] dataToWrite;
input [2:0]  addressToWrite;

  begin
    @(posedge Clk)
    #2 slave_writedata = dataToWrite;
       slave_address   = addressToWrite;
       slave_write     = 1'b1;
       slave_chipselect= 1'b1;
    #1
    while(slave_waitrequest)
     begin
       @(posedge Clk)
       #2;
     end  
    @(posedge Clk)
    #2
     slave_write     = 1'b0; 
     slave_chipselect= 1'b0;
  end  
  
endtask

task simpleRead;

input [2:0]  addressToWrite;

  begin
    @(posedge Clk)
    #2 slave_address   = addressToWrite;
       slave_read      = 1'b1;
       slave_chipselect= 1'b1;
    while(slave_waitrequest)
     begin
       @(posedge Clk)
       #2;
     end
    @(posedge Clk)
    #2 readData        = slave_readdata;
       slave_read      = 1'b0; 
       slave_chipselect= 1'b0;
  end  
  
endtask

task seti2cpacket;

input [23:0] i2cpacket;
reg   [31:0] dataToWrite;

  begin
    
    simpleRead(`ADDR_I2C_DATA_AUDIO);
    //I2C_command of (I2C_DATA_AUDIO) are set to 0 in order to rewrite that value 
    //without modifying the other bits of the register.
    dataToWrite = readData & 32'hFF000000;
    //The desired baudRate value is written into I2C_DATA_AUDIO) 
    //without modifying the other bits of the register.
    dataToWrite = dataToWrite | i2cpacket;
    simpleWrite(dataToWrite, `ADDR_I2C_DATA_AUDIO);
   // $display("Master: i2cpacket set to %h", i2cpacket);
  end
  
endtask


task setDACaudio;

input [31:0] dac_data;
reg   [31:0] dataToWrite;
  begin
    dataToWrite = dac_data;
    simpleWrite(dataToWrite, `ADDR_DAC_AUDIO);
    //$display("Master: DAC audio set to %h", dac_data);
  end
endtask

task llegiradcfifoout;

  begin
    simpleRead(`ADDR_ADC_AUDIO);
    //$display("Master: read ADC audio %h", readData);
  end
endtask

task waitFifoADCNoFull;
  
  reg   full;
  
  begin
  full = 0;
  
  while (full)
   begin
     simpleRead(`ADDR_STATUS_AUDIO);
     full = readData[2];
     $display("\\  ADC FIFO full flag: %d",full);
   end
   $display("\\  ADC FIFO no full");
  end
endtask


initial
 begin
   slave_read       <= 1'b0;
   slave_write      <= 1'b0;
   slave_address    <= 3'h0;
   slave_writedata  <= 32'h0;
   slave_chipselect <= 1'b0;
   slave_beginbursttransfer <= 1'b0;
   slave_burstcount <= 8'h0;  
   readData         <= 32'h0;
   for (i = 0; i < 256; i = i + 1)
    dataArray [i] = 8'h0;
 end
 
endmodule

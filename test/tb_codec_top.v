module tb_codec_top(); 
   
wire          slave_read          ; // Read request signal. Acvtive high.
wire          slave_write         ; // Write request signal. Active high.
wire  [2:0]   slave_address       ; // Bus address.
wire  [31:0]  slave_readdata      ; // Read bus.
wire  [31:0]  slave_writedata     ; // Write bus.
wire          slave_chipselect    ; // Chip select. Read and write operations are allowd when it is asserted. 
                                    // Active high.
wire          slave_waitrequest   ;
wire          slave_beginbursttransfer; // Indicates burst transfer. Active high.
wire  [7:0]   slave_burstcount    ; // Number of transfers in a burst;
wire          slave_irq           ;
   
wire clk, reset, i2c_sclk, i2c_sdat;
wire m_clk, b_clk, dac_lr_clk, adc_lr_clk, dacdat, adcdat, rd_adc_fifo, adc_fifo_empty, wr_dac_fifo, sample_tick;

reg wr_i2c;
   
     
   codec_avalon I_codec_avalon(
    .clk                  (clk),
    .reset                (reset),
    .slave_read           (slave_read),
    .slave_write          (slave_write),
    .slave_address        (slave_address),
    .slave_readdata       (slave_readdata),
    .slave_writedata      (slave_writedata),
    .slave_chipselect     (slave_chipselect),
    .slave_waitrequest    (slave_waitrequest),
    .slave_beginbursttransfer (slave_beginbursttransfer),
    .slave_burstcount     (slave_burstcount),
    .slave_irq            (slave_irq),
    .i2c_sclk             (i2c_sclk), 
    .i2c_sdat             (i2c_sdat),
    .adcdat               (adcdat),
		.m_clk                (m_clk),
		.b_clk                (b_clk),
		.dac_lr_clk           (dac_lr_clk),
		.adc_lr_clk           (adc_lr_clk), 
		.dacdat               (dacdat),
		.wr_i2c               (wr_i2c)
    );
   
   /*
   codec_avalon I_codec_avalon( .rd_adc_fifo(rd_adc_fifo), .adc_fifo_empty(adc_fifo_empty), 
                                .wr_dac_fifo(wr_dac_fifo), .sample_tick(sample_tick));
   */
   
   sys_clk50MHz_fm I_sys_clk50MHz_fm(.Clk(clk));

   sys_rst_fm I_sys_rst_fm(.Rst (reset));
   
   sys_i2c_fm I_sys_i2c_fm(.i2c_sdat(i2c_sdat), .i2c_sclk(i2c_sclk));

   master_bus_fm I_master_bus_fm(
    .Clk                  (clk),
    .slave_read           (slave_read),
    .slave_write          (slave_write),
    .slave_address        (slave_address),
    .slave_readdata       (slave_readdata),
    .slave_writedata      (slave_writedata),
    .slave_chipselect     (slave_chipselect),
    .slave_waitrequest    (slave_waitrequest),
    .slave_beginbursttransfer (slave_beginbursttransfer),
    .slave_burstcount     (slave_burstcount),
    .slave_irq            (slave_irq)
    );
    
initial begin
wr_i2c = 0;
end
    
task enablei2c;
	wr_i2c = 1;
endtask

task disablei2c;
	wr_i2c = 0;
endtask

    
endmodule

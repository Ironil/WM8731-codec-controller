module tb_codec_top(); 
   
   
   wire clk, reset, m_clk, b_clk, dac_lr_clk, adc_lr_clk, dacdat, adcdat, i2c_sclk, i2c_sdat, wr_i2c, i2c_idle, rd_adc_fifo, adc_fifo_empty, dac_fifo_full, wr_dac_fifo, sample_tick;
   wire [23:0] i2c_packet;
   wire [31:0] adc_fifo_out;
   wire [31:0] dac_fifo_in;     
 
   
   controlador I_codec_top(.clk(clk), .reset(reset), .m_clk(m_clk), .b_clk(b_clk), .dac_lr_clk(dac_lr_clk), .adc_lr_clk(adc_lr_clk), .dacdat(dacdat), .adcdat(adcdat), .i2c_sclk(i2c_sclk),
                         .i2c_sdat(i2c_sdat), .i2c_idle(i2c_idle), .rd_adc_fifo(rd_adc_fifo), .adc_fifo_empty(adc_fifo_empty), .dac_fifo_full(dac_fifo_full),
                         .wr_dac_fifo(wr_dac_fifo), .wr_i2c(wr_i2c), .i2c_packet(i2c_packet), .adc_fifo_out(adc_fifo_out), .dac_fifo_in(dac_fifo_in));

   sys_clk50MHz_fm I_sys_clk50MHz_fm(.Clk(clk));

   sys_rst_fm I_sys_rst_fm(.Rst (reset));
   sys_i2c_fm I_sys_i2c_fm(.clk(clk), .reset(reset), .i2c_sclk(i2c_sclk), .i2c_sdat(i2c_sdat));


endmodule

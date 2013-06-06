module codec_top 
   #(parameter FIFO_SIZE = 3)
   (
    input wire clk, reset,
    
    // to WM8731
    output wire m_clk, b_clk, dac_lr_clk, adc_lr_clk,
    output wire dacdat,
    input wire adcdat,
    output wire i2c_sclk,
    inout  wire i2c_sdat,
    
    // to main system
    input wire wr_i2c,
    input wire [23:0] i2c_packet,
    output wire i2c_idle,
    input wire rd_adc_fifo,
    output wire [31:0] adc_fifo_out,
    output wire adc_fifo_empty,
    input wire wr_dac_fifo,
    input wire [31:0] dac_fifo_in,
    output wire dac_fifo_full,
    output wire sample_tick
   );

   // signal declaration
   wire [31:0] dac_data_in, adc_data_out;
   wire dac_done_tick;

   // body
   assign sample_tick = dac_done_tick;
   
   //  i2c 
   i2c i2c_controller
      (.clk(clk), .reset(reset), .wr_i2c(wr_i2c), .din(i2c_packet),
       .i2c_sclk(i2c_sclk), .i2c_sdat(i2c_sdat), .i2c_idle(i2c_idle),
       .i2c_done_tick(), .i2c_fail());
       
   //  codec dac/adc
   adc_dac data_acces_controller
      (.clk(clk), .reset(reset),
       .dac_data_in(dac_data_in), .adc_data_out(adc_data_out),
       .m_clk(m_clk), .b_clk(b_clk), .dac_lr_clk(dac_lr_clk), 
       .adc_lr_clk(adc_lr_clk), .load_done_tick(dac_done_tick),
       .dacdat(dacdat), .adcdat(adcdat)); 
              
   //  adc fifo 
   fifo #(.B(32), .W(3)) I_fifo_adc
      (.clk(clk), .reset(reset), .rd(rd_adc_fifo),
       .wr(dac_done_tick), .w_data(adc_data_out),
       . empty(adc_fifo_empty), .full(), .r_data(adc_fifo_out));  
                               
   // dac fifo
   fifo #(.B(32), .W(3)) I_fifo_dac
      (.clk(clk), .reset(reset), .rd(dac_done_tick),
       .wr(wr_dac_fifo), .w_data(dac_fifo_in),
       . empty(), .full(dac_fifo_full), .r_data(dac_data_in)); 
endmodule
       

`timescale 1ns/100ps

module dac_fm(clk, reset, m_clk, b_clk, dac_lr_clk, dacdat);
	
	input clk, reset, m_clk, b_clk, dac_lr_clk, dacdat;
	
	
	task measuresclk;
	real frequency_m, frequency_b, frequency_lr;
	
	fork
		`mesura_m_clk(frequency_m);
		`mesura_b_clk(frequency_b);
		`mesura_dac_lr_clk(frequency_lr);
	join
	
	$display("Measured mclk = %f KHz", frequency_m);
	$display("Measured bclk = %f KHz", frequency_b);
	$display("Measured dac_lr_clk = %f KHz", frequency_lr);
	
	endtask
	
	task mesura_m_clk;
	input real frequency_m;
	time t1, t2;
	
	fork : timeout
      begin
         // Timeout check
         #100000
         $display("%t : timeout, no START received", $time);
         $finish();
         disable timeout;
      end
      begin
         // m_clk
         @(posedge m_clk);
         t1 = $realtime;
         @(posedge m_clk);
         t2 = $realtime;
         
         frequency_m = 1/((t2-t1)*1e-7);
      end
	join
	endtask
	
	task mesura_b_clk;
	input real frequency_b;
	time t1, t2;
	
	fork : timeout
      begin
         // Timeout check
         #100000
         $display("%t : timeout, no START received", $time);
         $finish();
         disable timeout;
      end
      begin
         // m_clk
         @(posedge b_clk);
         t1 = $realtime;
         @(posedge b_clk);
         t2 = $realtime;
         
         frequency_b = 1/((t2-t1)*1e-7);
      end
	join
	endtask
	
	task mesura_dac_lr_clk;
	input real frequency_lr;
	time t1, t2;
	
	fork : timeout
      begin
         // Timeout check
         #100000
         $display("%t : timeout, no START received", $time);
         $finish();
         disable timeout;
      end
      begin
         // m_clk
         @(posedge dac_lr_clk);
         t1 = $realtime;
         @(posedge dac_lr_clk);
         t2 = $realtime;
         
         frequency_lr = 1/((t2-t1)*1e-7);
      end
	join
	endtask
	
	
	
endmodule

module comptadorquarts(clk,reset,quart, nbit);
	
	input clk, reset;
	
	output reg [1:0] quart;
	output reg [4:0] nbit;
	
	reg [6:0] estat;
	reg[6:0] estat_s;
	
	
	always @ (estat)
	if (estat == 7'd124)
	 begin
	 estat_s = 0;
	 if (reset) begin
		quart = 0;
		nbit = 0;
	 end
	 else begin
		quart = quart + (1 & !reset); //Per evitar que hi hagi el canvi a l'inici del reset
		if (quart == 2'd0) nbit = nbit+ (1 & !reset);
	 end
	 end
	else estat_s = estat+7'd1;
	    
	always @ (posedge clk or posedge reset)
	if(reset == 1)
	  begin
	  estat <= 124;
	  //quart <= 0;
	  //nbit <= 0;
	  end
	else estat <= estat_s;
	
endmodule

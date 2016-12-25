module Tx_counter(clk , counter_rst , count_out , ov , BaudTick , Busy);

	input clk , counter_rst , BaudTick , Busy;
	output [3:0] count_out;
	output reg ov;
	reg [3:0] counting_reg;

	initial begin
		ov = 0;
		counting_reg = 0;
	end

	always @(posedge clk) begin
	  ov = 0;
		if(!counter_rst) begin
			counting_reg = 0;
			ov = 0;
		end
		else if(!Busy)
		  counting_reg = counting_reg;
		  
		else if(BaudTick)begin
			counting_reg = counting_reg + 1;
			if(counting_reg == 4'b1010)begin
				ov = 1;
				counting_reg = 0;
			end
		end
		else
			counting_reg = counting_reg;
	end
	assign count_out = counting_reg ;
endmodule
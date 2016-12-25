module counter(clk ,cnt ,counter_rst, ov , count_out);

	parameter counter_size = 6;
	input cnt , counter_rst , clk;
	output reg ov;
	output [counter_size-1:0]count_out;
	reg [counter_size:0] counter_reg;
	initial begin
		counter_reg = 0;
	end
	always@(posedge clk)begin
	  ov <= 0;
		if(!counter_rst)
			counter_reg = 0;
		else if(cnt)begin
			counter_reg = counter_reg+1;
		end
		else if(counter_reg >= 2**counter_size-1)
   			ov <= 1;
 		else
			counter_reg = counter_reg;
	end
	assign count_out = counter_reg[counter_size-1:0];
endmodule
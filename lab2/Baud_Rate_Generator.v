module Baud_Rate_Generator(input clk,rst, output reg baud_out);
parameter baud=115200;
parameter pulses_for_tick=50000000/baud;
localparam counter_width=$clog2(pulses_for_tick);

reg  [counter_width-1:0 ]counter;


always @(posedge clk)begin
	baud_out<=0;
	if(rst)
		counter<=0;
	else begin
		counter<=counter+1;
		if(counter==pulses_for_tick)begin
			baud_out<=1;
			counter<=0;
		end
	end	
end
endmodule
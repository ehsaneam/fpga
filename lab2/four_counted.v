module four_counter(input clk, Baud4Tick,reset, count_four, output reg four_counted);
reg [1:0]counter;
always@ (posedge clk) begin
  if(reset)
    counter=0;
	four_counted<=0;
	if(Baud4Tick) begin
		if(count_four) begin
			counter=counter+1;
			if(counter==2'b01)
				four_counted<=1;
		end
		else begin
			counter<=0;
		end
	end
end

endmodule
module two_counter(input clk, Baud4Tick,reset, count_two, output reg two_counted);
reg [1:0]counter;
always@ (posedge clk) begin
  if(reset)
    counter=0;
	two_counted<=0;
	if(Baud4Tick) begin
		if(count_two) begin
			counter=counter+1;
			if(counter==2'b10)
				two_counted<=1;
		end
		else begin
			counter<=0;
		end
	end
end

endmodule
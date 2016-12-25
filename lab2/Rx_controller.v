module Rx_controller( input rst,clk,RxD, Baud4Tick, four_counted, data_ready, output reg get_inp, count_four, reset );
localparam idle= 3'b000;
localparam z1= 3'b001;
localparam z2= 3'b010;
localparam get_input= 3'b011;
localparam wait_till_end=3'b100;
//localparam wait_two_baud=3'b100;

reg [2:0]cs, ns;

always @ (negedge clk) begin 
  reset=0;
	
	case(cs)
	idle: begin
	 reset=1;
	 count_four<=0;
	 get_inp<=0;
		if(RxD==0)
			ns<=z1;
	end
	z1:begin
	  count_four<=0;
	  get_inp<=0;
		if(Baud4Tick) begin
			if(RxD==0)
				ns<= z2;
			else
				ns<= idle;
		end
	end
	z2:begin
		count_four<=1;
		get_inp<=0;
		if(data_ready)
		  ns<=wait_till_end;
		else if(four_counted)
			ns<= get_input;
		else
			ns<= z2;
	end
	
	get_input: begin
	  count_four<=1;
		get_inp<=1;
		if(data_ready)
			ns<=wait_till_end;
		else
			ns<= z2;
	end
	wait_till_end: begin
		if(RxD)
			ns<=idle;
		else
			ns<=wait_till_end;
	end
	default:begin
	 ns<=0;
	end
	endcase

end 
always @(posedge clk) begin
cs<=ns;
if(rst)begin
		cs<=0;
	end
end

endmodule
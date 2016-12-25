module Tx_controller(TxD_start , ov ,rst , clk , Busy );

	localparam start = 1'b0;
	localparam wait_for_ov = 1'b1;

	input TxD_start, clk , ov , rst;
	output reg Busy;
	
	reg curr , next;
	
	initial begin
	  curr = start;
	  next = start;
	  Busy = 0;
	end
	always@(posedge clk , negedge rst)begin
		if(!rst)
			curr = start;
		else
			curr = next;
	end
	always@(negedge clk) begin
		case(curr)
			start: begin
				if(TxD_start)begin
				  Busy = 1;
					next = wait_for_ov;
				end
				else
					next = start;
			end
			wait_for_ov: begin
				if(ov)begin
				  Busy = 0;
					next = start;
				end
				else begin
					next = wait_for_ov;
				end
			end
			
			default: begin
				next = start;
				Busy = 0;
			end
		endcase
	end
endmodule
module controller( clk , reset , ov , inputvalid , outputvalid , ld , sum_ld , cnt ,count_rst );
	
	parameter [2:0]START = 3'b000;
	parameter [2:0]GET_INPUT = 3'b001;
	parameter [2:0]CALCULATION = 3'b010;
	parameter [2:0]PREPARE_NEXTCAL = 3'b011;
	parameter [2:0]SIGNAL_OUT = 3'b100;
	parameter [2:0]WAIT_FOR_ROM = 3'b101;

	input ov , reset , inputvalid , clk;
	output reg outputvalid , ld , sum_ld , cnt ,count_rst;
	
	reg [2:0] curr , next;
	
	initial begin
		curr = START;
		next = 3'bxxx;
	end
	
	always@(posedge clk , negedge reset) begin
		if(!reset) begin
			curr = START;
		end
		else
			curr = next;
	end
	
	always@(negedge clk)begin
		case(curr)
			START: begin
				ld = 0;
				sum_ld = 0;
				cnt = 0;
				outputvalid = 0;
				count_rst = 1;
				if(inputvalid)
					next = GET_INPUT;
				else
					next = START;
				end
			GET_INPUT: begin
				ld = 1;
				count_rst = 0;
				cnt = 0;
				outputvalid = 0;
				next = CALCULATION;
				end
			CALCULATION: begin
				ld = 0;
				cnt = 0;
				count_rst = 1;
				next = WAIT_FOR_ROM;
				end
			WAIT_FOR_ROM : begin
			  sum_ld = 1;
			  next = PREPARE_NEXTCAL;
			end
			PREPARE_NEXTCAL: begin
				sum_ld = 0;
				cnt = 1;
				if(ov)begin
					next = SIGNAL_OUT;
				end
				else
					next = CALCULATION;
				end
			SIGNAL_OUT: begin
				outputvalid = 1;
				cnt = 0;
				next = START;
				end
			default: begin
				curr = START;
				next = 3'bxxx;
				end
		endcase
	end
endmodule
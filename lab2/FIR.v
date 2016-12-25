module FIR(clk , reset , FIR_input , inputvalid , FIR_output , outputvalid);
	parameter in_WIDTH = 16;
	parameter filter_LENGTH = 64;
	parameter out_WIDTH = 2*in_WIDTH + $clog2(filter_LENGTH) + 1;
	parameter counter_size = $clog2(filter_LENGTH);
	
	input clk , reset , inputvalid;
	output outputvalid;
	input [in_WIDTH-1:0]FIR_input;
	output [out_WIDTH-1:0]FIR_output;
	
	wire ld , cnt , sum_ld , ov , cnt_rst;
	
	datapath #(.in_WIDTH(in_WIDTH) , .out_WIDTH(out_WIDTH) , .filter_LENGTH(filter_LENGTH) , 
		.counter_size(counter_size) ) dp(.clk(clk) , .reset(reset), .ld(ld) , .cnt(cnt) ,
			.sum_ld(sum_ld) , .in(FIR_input) , .out(FIR_output) , 
				.ov(ov) , .counter_rst(cnt_rst));
	controller ctrl(.clk(clk) , .reset(reset) , .inputvalid(inputvalid) , .ov(ov) , .outputvalid(outputvalid) ,
		.ld(ld) , .cnt(cnt) , .sum_ld(sum_ld) , .count_rst(cnt_rst));
/*	always@(posedge clk)begin
		if(inputvalid)
			$display("input	:	%b" , FIR_input);
		else if(outputvalid)
			$display("output	:	%b",FIR_output);
	end*/
endmodule
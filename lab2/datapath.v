module datapath( clk ,reset , ld , sum_ld , cnt, counter_rst , in , out , ov);
	
	parameter in_WIDTH = 16;
	parameter filter_LENGTH = 64;
	parameter counter_size = $clog2(filter_LENGTH);
	parameter out_WIDTH = 2*in_WIDTH + counter_size + 1;
	
	input reset , ld , sum_ld , cnt ,counter_rst, clk;
	input signed[in_WIDTH-1:0] in;
	
	output ov;
	output signed[out_WIDTH-1:0] out;
	
	reg signed[in_WIDTH-1:0] register [0:filter_LENGTH-1];
	reg signed[out_WIDTH-1:0] sum;
	wire signed[in_WIDTH - 1:0] coef_filter;
	wire [counter_size-1:0]sel;
	wire[out_WIDTH-1:0] cal_r;
	
	integer i ;
	
	counter #(counter_size) mycntr (.clk(clk) , .cnt(cnt) , .counter_rst(counter_rst & reset) , .ov(ov) , .count_out(sel) );
	
	mult_and_addr #(.in_WIDTH(in_WIDTH) , .out_WIDTH(out_WIDTH)) my_cal(.coef(coef_filter) ,
		.in(register[sel]) , .last_add(sum) , .calculation_result(cal_r));
	
	coeff_rom my_rom(.address(sel),.clock(clk),.q(coef_filter));

	initial begin
		for(i=0 ; i<filter_LENGTH ; i=i+1)
			register[i] = 0;
		sum <= 0;
	end
	
	always@(posedge clk , negedge reset)begin
		i = 0;
		if(!reset)begin
			sum <= 0;
			for(i=0 ; i<filter_LENGTH ; i=i+1)
				register[i] <= 0;
		end
		else if(ld) begin
			register[0] <= in;
			for(i=1 ; i<filter_LENGTH; i=i+1)begin
				register[i] <= register[i-1];
			end
			sum <= 0;
		end
		else if(sum_ld) begin
		  //$display("sel : %d   output of multaddr : %f",sel ,cal_r*2.0**(-30));
			sum <= cal_r;
		end
		//if(cnt)
		  //$display("sel : %d  coef : %d  register : %d  output: %d",sel,coef_filter , register[sel], out)
	end
	assign out = sum;
endmodule
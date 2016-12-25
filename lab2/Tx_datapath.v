module Tx_datapath(TxD_start , clk , ov ,rst ,TxD_data , TxD , BaudTick , Busy);

	input [7:0]TxD_data;
	output TxD , ov;
	input clk , rst , BaudTick , Busy , TxD_start;

	reg[9:0] startDataEnd;
	wire [3:0] sel;

	Tx_counter cntr(.clk(clk) , .counter_rst(rst) , .count_out(sel) , .ov(ov) , .BaudTick(BaudTick) , .Busy(Busy));
	
	always@(negedge clk)begin
		if(TxD_start & !Busy)
			startDataEnd = {1'b1 , TxD_data , 1'b0};
	end
	assign TxD = (sel==4'b0000)?1'b1: startDataEnd[sel-1];

endmodule
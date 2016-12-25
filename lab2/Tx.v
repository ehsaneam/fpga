module Tx(TxD_start , TxD_data , BaudTick , Busy , clk , rst , TxD);

input clk , rst , TxD_start , BaudTick;
input [7:0]TxD_data;
output Busy , TxD;
wire ov;
Tx_controller my_cntrl(.TxD_start(TxD_start) , .ov(ov) ,.rst(rst) , .clk(clk) , .Busy(Busy) );
Tx_datapath my_dp(.clk(clk) , .ov(ov) ,.rst(rst) ,.TxD_data(TxD_data) , .TxD(TxD) , .BaudTick(BaudTick) , .Busy(Busy) , .TxD_start(TxD_start));

endmodule
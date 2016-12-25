module Tx_test();

reg clk , rst , TxD_start;
reg [7:0]TxD_data;
wire BaudTick;
wire TxD;
wire Busy;
reg [15:0]coef[63:0];
integer i;
Tx my_transceiver(TxD_start , TxD_data , BaudTick , Busy , clk , rst , TxD);
Baud_Rate_Generator BRG(clk,rst,BaudTick);

initial begin
  $readmemb("coeffs.txt",coef);
  for(i=0 ; i< 64; i=i+1 )
    $display("%d",coef[i]);
  clk = 0;
end

always
  #5
  clk = ~clk;

initial begin
  #10
  rst = 0;
  #400
  rst = 1;
  #50
  TxD_data = 8'b01010101;
  TxD_start = 1;
  #100
  TxD_start = 0;
  wait(!Busy);
  #50
  TxD_data = 8'b10010010;
  TxD_start = 1;
  #50
  TxD_start = 0;
end

endmodule
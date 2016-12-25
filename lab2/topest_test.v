module topest_test();

parameter OUT_WIDTH = 38;
parameter DATA_LEN = 1000;

reg clk,  RST_n , TxD_start;
wire data_ready , busy , TxD , RxD ;
wire BaudTick , Baud4Tick;
reg [7:0] TxD_data;
wire [7:0] RxD_data;
reg [15:0] INs [0:DATA_LEN-1];
reg [OUT_WIDTH-1:0]  exp_OUTs [0:DATA_LEN-1];
reg [OUT_WIDTH-1:0]  OUTs [0:DATA_LEN-1];

Baud_Rate_Generator #(115200) COM_brg(.clk(clk),.rst(~RST_n),.baud_out(BaudTick));
Baud_Rate_Generator #(4*115200) COM_brg2(.clk(clk),.rst(~RST_n),.baud_out(Baud4Tick));
Tx COM_TX (.TxD_start(TxD_start) , .TxD_data(TxD_data) , .BaudTick(BaudTick) , 
		.Busy(busy) , .clk(clk) , .rst(RST_n) , .TxD(TxD));
TOP #(38) uut(clk , RST_n , RxD , TxD);
RX COM_RX (.RxD(RxD),.clk(clk),.rst(~RST_n),.Baud4Tick(Baud4Tick),.data_ready(data_ready),.RxD_data(RxD_data));

integer i;
integer j;

initial
begin
	clk = 1'b0;
end

always #1 clk = ~clk;
initial begin
  $readmemb("inputs.txt" , INs);
  $readmemb("outputs.txt" , exp_OUTs);
  #10
  RST_n = 0;
  #400
  RST_n = 1;
  #50
  for(i=0 ; i<DATA_LEN  ; i=i+1)begin
    TxD_data = INs[i][7:0];
    #2
    TxD_start = 1;
    #5
    TxD_start = 0;
    #2
    wait(~busy);
    TxD_data = INs[i][15:8];
    #2
   	TxD_start = 1;
    #10
    TxD_start = 0;
    wait(~busy);
    
    wait(data_ready);
    wait(~data_ready);
    OUTs[i][7:0] = RxD_data;
    wait(data_ready);
    wait(~data_ready);
    OUTs[i][15:8] = RxD_data;
    wait(data_ready);
    wait(~data_ready);
    OUTs[i][23:16] = RxD_data;
    wait(data_ready);
    wait(~data_ready);
    OUTs[i][31:24] = RxD_data;
    wait(data_ready);
    wait(~data_ready);
    OUTs[i][37:32] = RxD_data;
    $display("%d  input = %d , exp_output = %d , output = %d",$time , INs[i] , exp_OUTs[i] , OUTs[i]);
    if(exp_OUTs[i] != OUTs[i])
      $display("#############################invalid output#############################");
  end
  #1000
  $stop;
  $finish;
end
endmodule
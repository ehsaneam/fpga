module TOP(CLOCK_50 , KEY, UART_TXD , UART_RXD);
	parameter OUT_WIDTH = 38;
	wire clk , RST_n , RxD ;
	wire TxD;
	
	input CLOCK_50  , UART_RXD;
	input KEY;
	output UART_TXD;
	
	assign clk = CLOCK_50;
	assign RST_n = KEY;
	assign RxD = UART_RXD;
	assign UART_TXD = TxD;
	
	wire BaudTick , Baud4Tick , busy , data_ready , output_Valid , TxD_start , input_Valid,ffld , ffturn;
	wire turn;
	wire [7:0] TxD_data , RxD_data;
	wire [OUT_WIDTH-1:0] dout;
	reg [15:0]ffinput;
	Baud_Rate_Generator #(115200) brg(.clk(clk),.rst(~RST_n),.baud_out(BaudTick));
	Baud_Rate_Generator #(4*115200) brg2(.clk(clk),.rst(~RST_n),.baud_out(Baud4Tick));
	Tx The_Tx(.TxD_start(TxD_start) , .TxD_data(TxD_data) , .BaudTick(BaudTick) , 
		.Busy(busy) , .clk(clk) , .rst(RST_n) , .TxD(TxD));
	RX The_Rx (.RxD(RxD),.clk(clk),.rst(~RST_n),.Baud4Tick(Baud4Tick),.data_ready(data_ready),.RxD_data(RxD_data));
	FIR#(.out_WIDTH(OUT_WIDTH))TheFIR (.FIR_input(ffinput),.inputvalid(input_Valid),.clk(clk),.reset( RST_n ),
		.FIR_output(dout),.outputvalid(output_Valid));
	TOP_controller topCtrl(.clk(clk) , .rst(RST_n) , .data_ready(data_ready) , .inputvalid(input_Valid) ,
		.outputvalid(output_Valid) , .TxD_start(TxD_start) , .busy(busy) ,.turn(turn) , .ffld(ffld) , .ffturn(ffturn));
	initial
	  ffinput = 0;
	always@(posedge clk)begin
		if(ffld)begin
			if(~ffturn)begin
				ffinput[15:8] = ffinput[15:8];
				ffinput[7:0] = RxD_data;
			end
			else begin
				ffinput[7:0] = ffinput[7:0];
				ffinput[15:8] = RxD_data;
			end
		end
		else
			ffinput = ffinput;
	end
	assign TxD_data = (turn==1)?dout[31:24]:dout[23:16];
endmodule
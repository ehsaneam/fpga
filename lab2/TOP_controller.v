module TOP_controller(clk , rst , data_ready , inputvalid , outputvalid , TxD_start , busy ,turn , ffld , ffturn);

input data_ready , outputvalid , busy , rst , clk;
output reg inputvalid , TxD_start , ffturn , ffld;
output reg turn;

localparam START = 3'b000;
localparam WAITFORNEXT = 3'b001;
localparam INVALIDDATA = 3'b010;
localparam LAZYTX = 3'b011;
localparam ISBUSY = 3'b100;
localparam LAZYTX2 = 3'b101;
localparam ISBUSY2 = 3'b110;

localparam FIRST = 1'b0;
localparam SEC = 1'b1;

reg [2:0] curr;
reg [2:0] next;

initial begin
	curr = START;
	next = START;
	inputvalid = 0;
	TxD_start = 0;
	turn = FIRST;
	ffld = 0;
	ffturn = 0;
end
always@(posedge clk)begin
	if(!rst)
		curr = START;
	else
		curr = next;
end

always@(negedge clk)begin
	case(curr)
		START: begin
			ffturn = 0;
			if(data_ready)begin
				ffld = 1;
				next = WAITFORNEXT;
			end
			else
				next = START;
		end
		WAITFORNEXT:begin
			ffld = 0;
			ffturn = 1;
			if(data_ready)begin
				ffld = 1;
				inputvalid = 1;
				next = INVALIDDATA;
			end
			else
				next = WAITFORNEXT;
		end
		INVALIDDATA: begin
		  ffld = 0;
		  turn = FIRST;
			inputvalid = 0;
			if(outputvalid)begin
				TxD_start = 1;
				next = LAZYTX;
			end
			else
				next = INVALIDDATA;
		end
		LAZYTX:begin
		  TxD_start = 0;
		  next = ISBUSY;
		end
		ISBUSY: begin
			TxD_start = 0;
			if(busy)
				next = ISBUSY;
			else begin
				TxD_start = 1;
				turn = SEC;
				next = LAZYTX2;
			end
		end
		LAZYTX2: begin
		  TxD_start = 0;
		  next = ISBUSY2;
		end
		ISBUSY2: begin
			TxD_start = 0;
			if(busy)
				next = ISBUSY2;
			else begin
				turn = FIRST;
				next = START;
			end
		end
		default: begin
			next = START;
		end
	endcase
	end
endmodule
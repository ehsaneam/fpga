module RX_reg(input Baud4Tick,RxD, rst, clk,get_inp, output reg data_ready, output reg[8:0]RxD_data);
reg start_found;

reg[3:0] converted_counter;

always @(posedge clk)begin
  if (rst)begin
    converted_counter=0;
    RxD_data<=0;
    data_ready =0;
  end
  else	if(get_inp) begin
      data_ready=0;
			RxD_data[converted_counter]<=RxD;
			converted_counter=converted_counter+1;
		end
		if(converted_counter!=9)
		  data_ready=0;
		 else if(converted_counter==9) begin
		  converted_counter=0;
		  data_ready=1;
	end
end


endmodule
module RX(input clk,rst,RxD,Baud4Tick,output data_ready, output[7:0]RxD_data);

wire zero_found,four_counted ,get_inp, count_four, count_two,  two_counted , reset;
wire [8:0] out_of_reg ;

Rx_controller Rx_c ( rst,	clk,RxD, Baud4Tick, four_counted, data_ready, get_inp, count_four, reset );

RX_reg r_reg	(Baud4Tick,	RxD, reset, clk,	get_inp, data_ready, out_of_reg);

four_counter four_c	( clk, Baud4Tick, reset, count_four,  four_counted);

//zero_finder z_r ( clk, Baud4Tick, RxD, zero_found);
two_counter t_c( clk, Baud4Tick,reset, count_two,  two_counted);

assign RxD_data=out_of_reg[8:1];

endmodule
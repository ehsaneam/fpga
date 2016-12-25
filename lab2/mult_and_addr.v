module mult_and_addr(coef , in , last_add , calculation_result);
parameter in_WIDTH = 8;
parameter filter_LENGTH = 8;
parameter counter_size = $clog2(filter_LENGTH);
parameter out_WIDTH = in_WIDTH*2 + counter_size + 1;

input signed[in_WIDTH-1:0]coef;
input signed[in_WIDTH-1:0]in;
input signed[out_WIDTH-1:0]last_add;

output signed[out_WIDTH-1:0]calculation_result;

assign calculation_result = last_add + coef*in;
endmodule
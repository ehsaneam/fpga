module myFIR_filter_tb;

	parameter WIDTH = 16;
	parameter OUT_WIDTH = 38;
	parameter LENGTH = 64;
	parameter DATA_LEN = 1000;
	
	reg signed [WIDTH - 1 : 0] din;
	wire signed [OUT_WIDTH - 1 : 0] dout;
	
	reg signed [OUT_WIDTH - 1 : 0] exp_data [0 : DATA_LEN];
	
	reg signed [15 : 0] input_read [0 : DATA_LEN];
	reg clk, Rst, input_Valid;
	wire output_Valid;
	
	integer i, fp;
	
FIR #(.out_WIDTH(OUT_WIDTH))uut (
    .FIR_input(din), 
    .inputvalid (input_Valid),
	.clk(clk), 
    .reset(Rst), 
    .FIR_output(dout),
	.outputvalid(output_Valid)
    );

initial
    begin
    $readmemb("outputs.txt", exp_data);
end

initial
    begin  
    $readmemb("inputs.txt", input_read);
end

initial
begin
	clk = 1'b0;
end

always #10 clk = ~clk;

initial
   begin
   Rst = 1'b0;
   din = 16'b0;
   #400;
   Rst = 1'b1;
   #50;
   input_Valid = 1;
end         

initial
begin
	fp = $fopen("log.txt");
	#400;
	$display("Testing %d Samples..." , DATA_LEN);
	for(i = 0 ; i < DATA_LEN ; i = i+1)
	begin
	  if(i>=59)
	    i = i;
		@(negedge clk)
		begin
		      din = input_read[i];
					wait(output_Valid==1);
						@(posedge clk)
						begin
							$fwrite(fp,"output of filter :   %f   expected data :  %f\n",dout*2.0**(-30) , exp_data[i]*2.0**(-30));
						  if(dout != exp_data[i])
								$display("test failed: %d   input: %f expected: %f output: %f" , i, din*2.0**(-15),exp_data[i]*2.0**(-30), dout*2.0**(-30));
							else
							  $display("$%d   correct output",i);	
						end
		end
	end
	$fclose(fp);
	$display ("Test Passed.");
	$stop;
end

endmodule
module mips_alu_testbench();

	wire zero;					//	Branc Result
	wire [31:0] result;

	reg [31:0] first_data;		//R[s]
	reg [31:0] second_data;		//R[t] or singExtendImmediate
	reg [3:0] alu_op;				//look excel file for details
	reg [4:0] shamt;
	mips_alu test(zero, result, alu_op, first_data, second_data, shamt);
	
	initial first_data = 32'b10000000000000000000000000000000;
	initial second_data = 32'b01111111111111111111111111111111;
	
	initial begin
	#10 alu_op = 4'b0000; 
	#10 alu_op = 4'b0001;  
	#10 alu_op = 4'b0010; 
	#10 alu_op = 4'b0100;  	
	#10 alu_op = 4'b0101;
	#10 alu_op = 4'b0110;
	#10 alu_op = 4'b0111;
	#10 alu_op = 4'b1000;
	#10 alu_op = 4'b1001;
	#10 alu_op = 4'b1010;
	#10 alu_op = 4'b1011;
	#10 alu_op = 4'b1110;
	#10 alu_op = 4'b1111;
	#10 alu_op = 4'b1100;
		
end

initial begin
	$monitor(" alu_op: %b, result: %b zero: %b",alu_op, result, zero);
end

endmodule
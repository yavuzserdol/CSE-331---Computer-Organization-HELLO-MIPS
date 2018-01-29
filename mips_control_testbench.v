module mips_control_testbench();

wire [1:0] reg_dst ;						//00 = I[20:16], 11 = I[20:16], 01/10 =  R[31] for JAL instruction
wire alu_src;								//0 = Read Data 2, 1 = signExtend(I[15:0])
wire [1:0] mem_to_reg ;					//00 = data from Alu, 01/10 = PC+4 for JAL instruction, 11 = data from Memory
wire reg_write;							//1 = for all R, JAL and I type instructions except store types instructions and branches, 0 = for others
wire mem_read;								//1 = for load types instructions, 0 =  for others 
wire mem_write;							//1 = for store types instructions, 0 = for others
wire [1:0] branch ;						//00 = no branch, 01 = BEQ, 10 = BNE, 11 = Undefined
wire [3:0] alu_op ;						//look excel file for details
wire [1:0] jump ;							//00 = no jump, 01/10 = JR, 11 = J and JAL
wire [1:0] byte_number ;				//00 = WORD, 01 = HALF WORD, 10 = BYTE, 11 = UPPER IMMEDIATE

reg [5:0] op_code;
reg [5:0] funct;

mips_control test(reg_dst, alu_src, mem_to_reg, reg_write, mem_read, mem_write, branch, alu_op, jump, byte_number, op_code, funct);

initial begin
	#10 op_code = 6'b100011; 
	#10 op_code = 6'b000000; funct = 6'b100010; 
	#10 op_code = 6'b000000; funct = 6'b000111;
	#10 op_code = 6'b000000; funct = 6'b100011; 	
	#10 op_code = 6'b000010;
		
end

initial begin
	$monitor("opCode: %b, funct: %b, reg_dst: %b, alu_src: %b, mem_to_reg: %b, reg_write: %b, mem_read: %b, mem_write: %b, branch: %b, alu_op: %b, jump: %b, byte_number: %b",op_code,funct,reg_dst,alu_src,mem_to_reg,reg_write,mem_read,mem_write,branch,alu_op,jump,byte_number);
end

endmodule
module mips_core(clock);
	input clock;
	wire [31:0] instruction;	
	wire [31:0] read_data_1,read_data_2;	//register's datas R[t] and R[s]
	wire [31:0] alu_result;						//result from alu
	wire zero;										//branch control
	wire [1:0] reg_dst ;							//00 = I[20:16], 11 = I[20:16], 01/10 =  R[31] for JAL instruction
	wire alu_src;									//0 = Read Data 2, 1 = signExtend(I[15:0])
	wire [1:0] mem_to_reg ;						//00 = data from Alu, 01/10 = PC+4 for JAL instruction, 11 = data from Memory
	wire reg_write;								//1 = for all R, JAL and I type instructions except store types instructions and branches, 0 = for others
	wire mem_read;									//1 = for load types instructions, 0 =  for others 
	wire mem_write;								//1 = for store types instructions, 0 = for others
	wire [1:0] branch ;							//00 = no branch, 01 = BEQ, 10 = BNE, 11 = Undefined
	wire [3:0] alu_op ;							//look excel file for details
	wire [1:0] jump ;								//00 = no jump, 01/10 = JR, 11 = J and JAL
	wire [1:0] byte_number ;					//00 = WORD, 01 = HALF WORD, 10 = BYTE, 11 = UPPER IMMEDIATE
	wire [31:0] memory_data;					//data for load type instructions
	
	reg [31:0] PC = 32'b0;
	
	reg [5:0] op_code;							//instruction[31:26]
	reg [5:0] funct;								//instruction[5:0]
	reg [4:0] read_reg_1;						//instruction[25:21]
	reg [4:0] read_reg_2;						//instruction[20:16]
	reg [4:0] write_reg;							//if instruction is R type then write_reg will be instruction[15:11]
														//else I type then it  will be instruction[20:16] otherwise it will be R[31]
														
	reg [4:0] shamt;								//instruction[10:6];
	reg [31:0] sign_extend_imme;
	reg [31:0] alu_input_1;						// read_data_1
	reg [31:0] alu_input_2;						//if instruction is R type then alu_input_2 will be read_data_2 else it will be sign_extend_imme
	reg [31:0] write_data;						//if instruction is load type then write_data will be Memory[R[s] + sign_extend_imme]
	
	reg [31:0] jump_address;					//jump address for J type instructions
	reg [31:0] branch_address;					//branch address
	reg [31:0] last_pc_address = 32'b0;				//last value of PC
	wire is_branch;
	
	always @* begin		
		op_code = instruction[31:26];
		funct = instruction[5:0];
		read_reg_1 = instruction[25:21];
		read_reg_2 = instruction[20:16];
		shamt = instruction[10:6];
		
		if(reg_dst == 2'b00) begin											//if reg_dst is 00 then write_reg will be instruction[20:16]
			write_reg = instruction[20:16];
		end else if(reg_dst == 2'b11) begin								//if reg_dst is 11 then write_reg will be instruction[15:11]
			write_reg = instruction[15:11];
		end else if(reg_dst == 2'b01 || reg_dst == 2'b10) begin 	//if reg_dst is 01 or 10 then write_reg will be 11111
			write_reg = 5'b11111;
		end		
	
		sign_extend_imme = {{16{instruction[15]}}, instruction[15:0]};	//sign_extend_imme using concatenation	
		jump_address = {PC[31:28], (instruction[25:0] << 2)};				//jump address using concatenation	
		branch_address = (is_branch == 1'b1) ? ( (sign_extend_imme << 2) + PC + 4 ) : PC + 4;
			
		if(jump == 2'b11) begin
			last_pc_address = jump_address;		
		end else if (jump == 2'b01 || jump == 2'b10) begin 
			last_pc_address = read_data_1;
		end else if(jump == 2'b00) begin
			last_pc_address = branch_address;
		end
		
		alu_input_1 = read_data_1;											//ALU's first_data
		
		if(alu_src == 1'b0) begin											//MUX for ALU's second_data
			alu_input_2 = read_data_2;					
		end else if(alu_src == 1'b1) begin
			alu_input_2 = sign_extend_imme;
		end
		
		if(mem_to_reg == 2'b00) begin										//mux for data to be written to the register 
			write_data = alu_result;										//00 = data from Alu, 01/10 = PC+4 for JAL instruction, 11 = data from Memory
		end else if(mem_to_reg == 2'b01 || mem_to_reg == 2'b10) begin
			write_data = PC + 4;
		end else if(mem_to_reg == 2'b11) begin
			write_data = memory_data;
		end		
				

	end
	
	mips_alu alu(zero, alu_result, alu_op, alu_input_1, alu_input_2, shamt);
	mips_control signals(reg_dst, alu_src, mem_to_reg, reg_write, mem_read, mem_write, branch, alu_op, jump, byte_number, op_code, funct);
	mips_instr_mem instruction_mem(instruction, PC);
	mips_registers registers(read_data_1, read_data_2, write_data, read_reg_1, read_reg_2, write_reg, reg_write);
	mips_data_mem memory(memory_data, alu_result, alu_input_2, mem_read, mem_write, byte_number);
	mips_is_branch branch_value(is_branch, branch, zero);

	always @(posedge clock) begin 
		PC <= last_pc_address;
		
	end
	

	initial begin
		$monitor("instruction: %b R1r:%b R2r:%b RS: %32b, RT: %32b, signal: %b, RD adress: %5b AluResult: %b Zero: %b alu_op: %4b",instruction, read_reg_1, read_reg_2, read_data_1, read_data_2, reg_write, write_reg, alu_result, zero, alu_op);
	end


endmodule
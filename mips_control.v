module mips_control(reg_dst, alu_src, mem_to_reg, reg_write, mem_read, mem_write, branch, alu_op, jump, byte_number, op_code, funct);

	output reg [1:0] reg_dst ;						//00 = I[20:16], 11 = I[20:16], 01/10 =  R[31] for JAL instruction
	output reg alu_src;								//0 = Read Data 2, 1 = signExtend(I[15:0])
	output reg [1:0] mem_to_reg ;					//00 = data from Alu, 01/10 = PC+4 for JAL instruction, 11 = data from Memory
	output reg reg_write;							//1 = for all R, JAL and I type instructions except store types instructions and branches, 0 = for others
	output reg mem_read;								//1 = for load types instructions, 0 =  for others 
	output reg mem_write;							//1 = for store types instructions, 0 = for others
	output reg [1:0] branch ;						//00 = no branch, 01 = BEQ, 10 = BNE, 11 = Undefined
	output reg [3:0] alu_op ;						//look excel file for details
	output reg [1:0] jump ;							//00 = no jump, 01/10 = JR, 11 = J and JAL
	output reg [1:0] byte_number ;				//00 = WORD, 01 = HALF WORD, 10 = BYTE, 11 = UPPER IMMEDIATE

	input [5:0] op_code;
	input [5:0] funct;



	always @* begin
		
		if(op_code == 6'b000000) begin 	//common signals for R type instructions
			reg_dst = 2'b11;					//I[15:11]
			alu_src = 1'b0;					//Read Data 2
			mem_to_reg = 2'b00;				//data from ALU will be written to REGISTER
			mem_read = 1'b0;					//will not read from MEMORY
			mem_write = 1'b0;					//will not write to MEMORY
			branch = 2'b00; 					//no branch 
			byte_number = 2'b00;
			
			if(funct == 6'b001000) begin 	//R type JR instruction
				alu_op = 4'b0011;				//will not use ALU
				jump = 2'b01;					//change PC to data of R[rs]
				reg_write = 1'b0;				//will not read to REGISTER
				
				$display("R type JR instruction %b", funct);
				
			end else begin	
				reg_write = 1'b1;				//remaining common signals for other R type instructions
				jump = 2'b00;
				
				$display("R type other instruction %b", funct);
				
				case (funct) 
					6'b100000 : 				//R type ADD instruction 
						alu_op = 4'b0100;		
					6'b100001 :					//R type ADDU instruction
						alu_op = 4'b0101;	
					6'b100100 : 				//R type AND instruction
						alu_op = 4'b0000; 
					6'b100111 : 				//R type NOR instruction
						alu_op = 4'b0010; 
					6'b100101 : 				//R type OR instruction
						alu_op = 4'b0001;
					6'b101010 : 				//R type SLT instruction
						alu_op = 4'b1110;
					6'b101011 : 				//R type SLTU instruction
						alu_op = 4'b1111;
					6'b000000 :					//R type SLL instruction
						alu_op = 4'b1000;
					6'b000010 :					//R type SRL instruction
						alu_op = 4'b1010;
					6'b100010 :					//R type SUB instruction
						alu_op = 4'b0110;
					6'b100011 :					//R type SUBU instruction
						alu_op = 4'b0111;
							
					default : $display("Error in R type instruction %b",funct); 		 
				endcase
			
			end
		end else begin
			if(op_code == 6'b000010) begin	//J type J instruction
				reg_dst = 2'b01;				//not important for J instruction
				alu_src = 1'b0;				//not important for J instruction
				mem_to_reg = 2'b00;			//not important for J instruction
				reg_write = 1'b0;				//will not write to REGISTER
				mem_read = 1'b0;				//will not read from MEMORY
				mem_write = 1'b0;				//will not write to MEMORY
				branch = 2'b00;				//no branch
				alu_op = 4'b0011;				//undefined alu operation
				jump = 2'b11;					//PC = JUMP ADDRESS
				byte_number = 2'b00;			//not important for J instruction
				
				$display("J type J instruction %b", op_code);
				
			end else if(op_code == 6'b000011) begin // J type JAL instruction
			
				reg_dst = 2'b01;				//R[31] for JAL instruction				
				alu_src = 1'b0;				//not important for J instruction
				mem_to_reg = 2'b01;			//PC+4 for JAL instruction
				reg_write = 1'b1;				//will write to REGISTER
				mem_read = 1'b0;				//will not read from MEMORY
				mem_write = 1'b0;				//will not write to MEMORY
				branch = 2'b00;				//no branch
				alu_op = 4'b0011;				//undefined alu operation
				jump = 2'b11;					//PC = JUMP ADDRESS
				byte_number = 2'b00;			//not important for J instruction
				
				$display("J type JAL instruction %b", op_code);
			
			end else if (op_code == 6'b100011 || op_code == 6'b110000) begin //I type LW instruction and I type LL instruction
			
				reg_dst = 2'b00;						//R[rt] for I instructions				
				alu_src = 1'b1;						//signExtendImmediate for ALU
				mem_to_reg = 2'b11;					//data from MEMORY will be written to REGISTER
				reg_write = 1'b1;						//will write to REGISTER
				mem_read = 1'b1;						//will read from MEMORY
				mem_write = 1'b0;						//will not write to MEMORY
				branch = 2'b00;						//no branch
				alu_op = 4'b0100;						//ALU operation ADD
				jump = 2'b00;							//no jump
				byte_number = 2'b00;					//load word from MEMORY	
				
				$display("I type LB or LL instruction %b", op_code);
				
			end else if(op_code == 6'b100100) begin	//I type LBU instruction
			
				reg_dst = 2'b00;						//R[rt] for I instructions				
				alu_src = 1'b1;						//signExtendImmediate for ALU
				mem_to_reg = 2'b11;					//data from MEMORY will be written to REGISTER
				reg_write = 1'b1;						//will write to REGISTER
				mem_read = 1'b1;						//will read from MEMORY
				mem_write = 1'b0;						//will not write to MEMORY
				branch = 2'b00;						//no branch
				alu_op = 4'b0100;						//ALU operation ADD
				jump = 2'b00;							//no jump
				byte_number = 2'b10;					//load byte from MEMORY	
				
				$display("I type LBU instruction %b", op_code);
				
			end else if(op_code == 6'b100101) begin 	//I type LHU instruction
			
				reg_dst = 2'b00;						//R[rt] for I instructions				
				alu_src = 1'b1;						//signExtendImmediate for ALU
				mem_to_reg = 2'b11;					//data from MEMORY will be written to REGISTER
				reg_write = 1'b1;						//will write to REGISTER
				mem_read = 1'b1;						//will read from MEMORY
				mem_write = 1'b0;						//will not write to MEMORY
				branch = 2'b00;						//no branch
				alu_op = 4'b0100;						//ALU operation ADD
				jump = 2'b00;							//no jump
				byte_number = 2'b01;					//load halfword from MEMORY	
				
				$display("I type LHU instruction %b", op_code);
				
			end else if(op_code == 6'b001111) begin	//I type LUI instruction		
				reg_dst = 2'b00;						//R[rt] for I instructions				
				alu_src = 1'b1;						//signExtendImmediate for ALU
				mem_to_reg = 2'b00;					//data from ALU will be written to REGISTER
				reg_write = 1'b1;						//will write to REGISTER
				mem_read = 1'b0;						//will not read from MEMORY
				mem_write = 1'b0;						//will not write to MEMORY
				branch = 2'b00;						//no branch
				alu_op = 4'b1100;						//LUI operation(Result will be (signExtendImmediate << 16))
				jump = 2'b00;							//no jump
				byte_number = 2'b00;					//not important for LUI instruction
				
				$display("I type LUI instruction %b", op_code);
				
			end else if(op_code == 6'b101011 || op_code == 6'b111000) begin	//I type SW instruction and I type SC instruction
			
				reg_dst = 2'b00;						//R[rt] for I instructions
				alu_src = 1'b1;						//signExtendImmediate for ALU
				mem_to_reg = 2'b11;					//not important for store type instructions
				reg_write = 1'b0;						//will not write to REGISTER
				mem_read = 1'b0;						//will not read from MEMORY
				mem_write = 1'b1;						//will write to MEMORY
				branch = 2'b00;						//no branch
				alu_op = 4'b0100;						//ALU operation ADD
				jump = 2'b00;							//no jump
				byte_number = 2'b00;					//store word in MEMORY
				
				$display("I type SW OR SC instruction %b", op_code);
				
			end else if(op_code == 6'b101000) begin	//I type SB instruction
			
				reg_dst = 2'b00;						//R[rt] for I instructions
				alu_src = 1'b1;						//signExtendImmediate for ALU
				mem_to_reg = 2'b11;					//not important for store type instructions
				reg_write = 1'b0;						//will not write to REGISTER
				mem_read = 1'b0;						//will not read from MEMORY
				mem_write = 1'b1;						//will write to MEMORY
				branch = 2'b00;						//no branch
				alu_op = 4'b0100;						//ALU operation ADD
				jump = 2'b00;							//no jump
				byte_number = 2'b10;					//store byte in MEMORY		
				
				$display("I type SB instruction %b", op_code);
				
			end else if(op_code == 6'b101011) begin	//I type SH instruction
			
				reg_dst = 2'b00;						//R[rt] for I instructions
				alu_src = 1'b1;						//signExtendImmediate for ALU
				mem_to_reg = 2'b11;					//not important for store type instructions
				reg_write = 1'b0;						//will not write to REGISTER
				mem_read = 1'b0;						//will not read from MEMORY
				mem_write = 1'b1;						//will write to MEMORY
				branch = 2'b00;						//no branch
				alu_op = 4'b0100;						//ALU operation ADD
				jump = 2'b00;							//no jump
				byte_number = 2'b01;					//store halfword in MEMORY	
				
				$display("I type SH instruction %b", op_code);
				
			end else if (op_code == 6'b000100) begin //I type BEQ instruction
			
				reg_dst = 2'b00;						//R[rt] for I instructions
				alu_src = 1'b0;						//Read Data 2 for ALU
				mem_to_reg = 2'b00;					//not important for branch instructions
				reg_write = 1'b0;						//will not write to REGISTER
				mem_read = 1'b0;						//will not read from MEMORY
				mem_write = 1'b0;						//will not write to MEMORY
				branch = 2'b01;						//branch when two register data same
				alu_op = 4'b0110;						//ALU operation SUB
				jump = 2'b00;							//no jump
				byte_number = 2'b00;					//not important for branch instructions	
				
				$display("I type BEQ instruction %b", op_code);
				
			end else if (op_code == 6'b000101) begin //I type BNE instruction
			
				reg_dst = 2'b00;						//R[rt] for I instructions
				alu_src = 1'b0;						//Read Data 2 for ALU
				mem_to_reg = 2'b00;					//not important for branch instructions
				reg_write = 1'b0;						//will not write to REGISTER
				mem_read = 1'b0;						//will not read from MEMORY
				mem_write = 1'b0;						//will not write to MEMORY
				branch = 2'b10;						//branch when two register data not same
				alu_op = 4'b0110;						//ALU operation SUB
				jump = 2'b00;							//no jump
				byte_number = 2'b00;					//not important for branch instructions
				
				$display("I type BNE instruction %b", op_code);
				
			end else begin								//common signals for other I type instructions
			
				reg_dst = 2'b00;						//R[rt] for I instructions
				alu_src = 1'b1;						//signExtendImmediate for ALU
				mem_to_reg = 2'b00;					//data from ALU will be written to REGISTER
				reg_write = 1'b1;						//will write to REGISTER
				mem_read = 1'b0;						//will not read from MEMORY
				mem_write = 1'b0;						//will not write to MEMORY
				branch = 2'b00;						//no branch
				jump = 2'b00;							//no jump
				byte_number = 2'b00;					//not important for remaining I type instructions
				
				$display("I type other instructions %b", op_code);
				
				case(op_code)
					6'b001000 : 				//I type ADDI instruction 
						alu_op = 4'b0100;		
					6'b001001 :					//I type ADDIU instruction
						alu_op = 4'b0101;	
					6'b001100 : 				//I type ANDI instruction
						alu_op = 4'b0000; 	
					6'b001101 :					//I type ORI instruction
						alu_op = 4'b0001;
					6'b001010 :					//I type SLTI instruction
						alu_op = 4'b1110;
					6'b001011 :					//I type SLTIU instruction
						alu_op = 4'b1111;
						
					default : $display("Error in I type instruction %b",op_code);
				
				endcase
				
			end
		
		end

	end


endmodule
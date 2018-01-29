module mips_alu(zero, result, alu_op, first_data, second_data, shamt);

	output reg zero;					//	Branc Result
	output reg [31:0] result;

	input [31:0] first_data;		//R[s]
	input [31:0] second_data;		//R[t] or singExtendImmediate
	input [3:0] alu_op;				//look excel file for details
	input [4:0] shamt;              //Shift Amount

	always @* begin
		if(alu_op == 4'b1110) begin
			result = ($signed(first_data) < $signed(second_data)) ? 1 : 0 ;
		end else if(alu_op == 4'b1111) begin
			result = (first_data < second_data) ? 1 : 0 ;
		end else begin
			case(alu_op)
				4'b0000 :										//AND
					result = first_data & second_data;
				4'b0001 :										//OR
					result = first_data | second_data;
				4'b0010 :										//NOR
					result = !(first_data | second_data);
				4'b0100 : 										//ADD
					result = $signed(first_data) + $signed(second_data);
				4'b0101 :										//ADDU
					result = first_data + second_data;
				4'b0110 :										//SUB
					result = $signed(first_data) - $signed(second_data);
				4'b0111 :										//SUBU
					result = first_data - second_data;			
				4'b1000 :										//SLL
					result = first_data <<< shamt;
				4'b1001 :										//SLA
					result = first_data << shamt;
				4'b1010 :										//SRL
					result = first_data >>> shamt;
				4'b1011 :										//SRA
					result = first_data >> shamt;					
				4'b1100 :										//LUI
					result = {first_data[15:0],{16'b0}};
				4'b0011 :										//Undefined
					result = first_data;
			endcase
		end
		zero = (first_data == second_data) ? 0 : 1 ;
	end
	
	initial begin
		$monitor("first_data: %b alu_op: %b second_data: %b = result: %b",first_data, alu_op, second_data, result);		
	end
endmodule
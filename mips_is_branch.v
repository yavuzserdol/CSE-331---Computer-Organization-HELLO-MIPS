module mips_is_branch(is_branch, branch, zero);
	output reg is_branch;
	input [1:0] branch;
	input zero;
	
	
	always @* begin		
		is_branch = ( ( (!branch[1]) & branch[0] & (!zero) ) |  (branch[1] & (!branch[0]) & zero  ) ); //y = A'BC' + AB'C
	end
	
	
endmodule
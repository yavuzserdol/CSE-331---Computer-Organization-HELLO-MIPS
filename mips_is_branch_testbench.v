module mips_is_branch_testbench();
	
	wire is_branch;
	reg [1:0] branch;
	reg zero;
	
	mips_is_branch is(is_branch, branch, zero);
	
	initial begin
	#10 branch = 2'b00; zero = 1'b0; 
	#10 branch = 2'b00; zero = 1'b1; 
	#10 branch = 2'b01; zero = 1'b0; 
	#10 branch = 2'b01; zero = 1'b1; 
	#10 branch = 2'b10; zero = 1'b0;
	#10 branch = 2'b10; zero = 1'b1;
	#10 branch = 2'b11; zero = 1'b0;
	#10 branch = 2'b11; zero = 1'b1;
	
		
end

initial begin
	$monitor("branch: %b, zero: %b, is_branch %b",branch, zero, is_branch);
end
	
endmodule
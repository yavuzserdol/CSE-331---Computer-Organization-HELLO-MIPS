module mips_core_testbench ();
	reg clock;
	wire result;

	mips_core test(clock);

	initial clock = 0;

	//intruction.mem content will change. Its just start point for you. 
	//Please change it and try other instructions
	initial begin
		#30 clock=~clock; 
		#30 clock=~clock;
		#30 clock=~clock;
		#30 clock=~clock;
		#30 clock=~clock;
		#30 clock=~clock;
		#30 clock=~clock;
		#30 clock=~clock;
		#30 clock=~clock;
		#30 clock=~clock;
		#30 clock=~clock; 
		#30 clock=~clock;
		#30 clock=~clock;
		#30 clock=~clock;
		#30 clock=~clock;
		#30 clock=~clock;
		#30 clock=~clock;
		#30 clock=~clock;
		#30 clock=~clock;
		#30 clock=~clock;
		#30 clock=~clock; 
		#30 clock=~clock;
		#30 clock=~clock;
		#30 clock=~clock;
		#30 clock=~clock;
		#30 clock=~clock;
		#30 clock=~clock;
		#30 clock=~clock;
		#30 clock=~clock;
		#30 clock=~clock;
		
		//depend instrucion number 
	end

	//End of the test stage, you have to save register & data contents 
	//to res_registers.mem , res_data.mem (create new files)
	initial begin
		$writememb("../../res_registers.mem", test.registers.registers);
		$writememb("../../res_data.mem", test.memory.data_mem);
	end

endmodule
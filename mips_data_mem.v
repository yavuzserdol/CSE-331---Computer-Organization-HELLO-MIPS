module mips_data_mem (read_data, mem_address, write_data, sig_mem_read, sig_mem_write, byte_number);
output [31:0] read_data;
input [31:0] mem_address;
input [31:0] write_data;
input [1:0] byte_number;
input sig_mem_read;
input sig_mem_write;

reg [31:0] data_mem  [255:0];
reg [31:0] read_data;
reg [31:0] temp;
initial begin
	$readmemb("../../data.mem", data_mem);
end

always @* begin
	temp = data_mem[mem_address];
	if (sig_mem_read) begin
		if(byte_number == 2'b00) begin
			read_data = temp;
		end else if(byte_number == 2'b01) begin
			read_data = {{16{1'b0}}, temp[15:0]};
		end else if(byte_number == 2'b10) begin
			read_data = {{24{1'b0}}, temp[7:0]};
		end
	end
	
	if (sig_mem_write) begin
		if(byte_number == 2'b00) begin
			data_mem[mem_address] = write_data[31:0];
		end else if(byte_number == 2'b01) begin
			data_mem[mem_address] = {{16{1'b0}}, write_data[15:0]};
		end else if(byte_number == 2'b10) begin
			data_mem[mem_address] = {{24{1'b0}}, write_data[7:0]};
		end
	end
end

endmodule
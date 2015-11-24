module alu_ctrl_ckt(input [1:0] aluOp, input ff, output reg [1:0] finalaluOp);

	always@(aluOp, ff) // ff is the 9th bit of opcode
		if(aluOp == 2'b11)
			if(ff == 1'b0) finalaluOp = 2'b10;
			else finalaluOp = 2'b11;
		else
			finalaluOp = aluOp;
			
endmodule

module alu(input [1:0] aluOp, input[31:0] in1, input[31:0] in2, output reg [31:0] res, output reg n_flag, z_flag, c_flag, o_flag);

	always@(aluOp, in1, in2)
	begin
	
		n_flag = 1'b0;
		z_flag = 1'b0;
		o_flag = 1'b0;
		c_flag = 1'b0;
	
		case(aluOp)
		
			2'b00:
			begin
				res = 32'd0;
			end
			
			2'b01:
			begin
				{c_flag, res} = in1+in2;
				n_flag = res[31];
				if(res == 32'd0) z_flag = 1'b1;
				if(in1[31] == in2[31] && in1[31] != res[31]) o_flag = 1'b1;
			end
			
			2'b10:
			begin
				{c_flag, res} = in1-in2;
				n_flag = res[31];
				if(res == 32'd0) z_flag = 1'b1;
				if((in1[31] != in2[31]) && (in1[31] != res[31])) o_flag = 1'b1;
			end
			
			2'b11:
			begin
				{c_flag, res} = in1 << in2;
				n_flag = res[31];
				if(res == 32'd0) z_flag = 1'b1;
			end
		endcase
	end
endmodule
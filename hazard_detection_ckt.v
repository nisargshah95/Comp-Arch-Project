module hazard_detection_ckt (input [31:16] opcodeg2, input[15:0] opcodeg1,
	input IDEX_MemRead,	input EXMEM_MemRead, input flagWrite, input IDEX_rd,
	input EXMEM_n_flag,
	output reg PCWrite, output reg IFWrite, output reg IDEX_ctrl_flush);
	
	always@(opcode, IDEX_MemRead, IDEX_rt, flagWrite, IDEX_rd, IDEX_rdAdd)
	begin
		
		PCWrite = 1'b1;
		IFWrite = 1'b1;
		IDEX_ctrl_flush = 1'b0;
		
		// hazard detection for load
		if(IDEX_MemRead == 1'b1)
		begin
			if( (opcodeg1[15:11] == 5'b00100 && IDEX_rd == opcodeg1[10:8]) || // lw-add
				(opcodeg1[15:11] == 5'b00011 && (IDEX_rd == opcodeg1[8:6] || IDEX_rd == opcodeg1[5:3])) || // lw-sub
				(opcodeg1[15:11] == 5'b01000 && (IDEX_rd == opcodeg1[5:3] || IDEX_rd == opcodeg1[2:0])) || // lw-shft/cmp
				(opcodeg2[15:11] == 5'b10001 && IDEX_rd == opcodeg2[5:3]) || // lw-lw
				(opcodeg2[15:11] == 5'b10000 && (IDEX_rd == opcodeg2[5:3] && IDEX_rd == opcodeg2[2:0])) || // lw-sw
				(opcodeg2[15:11] == 5'b11010) // lw-br
				)	
			begin
				PCWrite = 1'b0;
				IFWrite = 1'b0;
				IDEX_ctrl_flush = 1'b1;
			end
		end
		
		// hazard detection for branch
		else if(opcodeg2[15:11] == 5'b11010)
		begin
			if( (EXMEM_MemRead == 1'b1 && EXMEM_n_flag == 1'b0) || // br-lw (2nd stall)
				(flagWrite == 1'b1) // other branches
				)
			begin
				PCWrite = 1'b0;
				IFWrite = 1'b0;
				IDEX_ctrl_flush = 1'b1;
			end
		end
		
	end
endmodule
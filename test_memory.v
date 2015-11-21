module D_ff_Mem (input clk, input reset, input regWrite, input decOut1b,input init, input d, output reg q);
	always @ (negedge clk)
	begin
	if(reset==1)
		q=init;
	else
		if(regWrite == 1 && decOut1b==1) begin q=d; end
	end
endmodule

module register_Mem(input clk,input reset,input regWrite,input decOut1b,input [31:0]init, input [31:0] d_in, output [31:0] q_out);
	
	D_ff_Mem dMem[31:0] (clk,reset,regWrite,decOut1b,init,d_in,q_out);
	
/* 	D_ff_Mem dMem0 (clk,reset,regWrite,decOut1b,init[0],d_in[0],q_out[0]);
	D_ff_Mem dMem1 (clk,reset,regWrite,decOut1b,init[1],d_in[1],q_out[1]);
	D_ff_Mem dMem2 (clk,reset,regWrite,decOut1b,init[2],d_in[2],q_out[2]);
	D_ff_Mem dMem3 (clk,reset,regWrite,decOut1b,init[3],d_in[3],q_out[3]);
	
	D_ff_Mem dMem4 (clk,reset,regWrite,decOut1b,init[4],d_in[4],q_out[4]);
	D_ff_Mem dMem5 (clk,reset,regWrite,decOut1b,init[5],d_in[5],q_out[5]);
	D_ff_Mem dMem6 (clk,reset,regWrite,decOut1b,init[6],d_in[6],q_out[6]);
	D_ff_Mem dMem7 (clk,reset,regWrite,decOut1b,init[7],d_in[7],q_out[7]);

	D_ff_Mem dMem8 (clk,reset,regWrite,decOut1b,init[8],d_in[8],q_out[8]);
	D_ff_Mem dMem9 (clk,reset,regWrite,decOut1b,init[9],d_in[9],q_out[9]);
	D_ff_Mem dMem10 (clk,reset,regWrite,decOut1b,init[10],d_in[10],q_out[10]);
	D_ff_Mem dMem11 (clk,reset,regWrite,decOut1b,init[11],d_in[11],q_out[11]);
	
	D_ff_Mem dMem12 (clk,reset,regWrite,decOut1b,init[12],d_in[12],q_out[12]);
	D_ff_Mem dMem13 (clk,reset,regWrite,decOut1b,init[13],d_in[13],q_out[13]);
	D_ff_Mem dMem14 (clk,reset,regWrite,decOut1b,init[14],d_in[14],q_out[14]);
	D_ff_Mem dMem15 (clk,reset,regWrite,decOut1b,init[15],d_in[15],q_out[15]); */
	
endmodule

module Mem(input clk, input reset,input memWrite,input memRead, input [31:0] pc, input [31:0] dataIn,output [31:0] IR );
	wire [31:0] Qout0, Qout1, Qout2, Qout3, Qout4, Qout5, Qout6, Qout7,
					Qout8, Qout9, Qout10, Qout11, Qout12, Qout13, Qout14, Qout15,decOut;
	
	decoder4to16 dec0( pc[4:1], decOut);

	//nop, nop
	register_Mem r0(clk,reset,memWrite,decOut[0],32'b 0000000000000000__0000000000000000,		dataIn,Qout0);
	
	//addi $r0, 1, nop
	register_Mem r1(clk,reset,memWrite,decOut[1],32'b 00100_000_00000001__0000000000000000,		dataIn,Qout1);
	
	//sub $r1, $1, $1, nop
	register_Mem r2(clk,reset,memWrite,decOut[2],32'b 00011_01_001_001_001__0000000000000000,	dataIn,Qout2);
	
	//shift $r2, $2, $2, nop
	register_Mem r3(clk,reset,memWrite,decOut[3],32'b 01000_01000_010_010__0000000000000000,	dataIn,Qout3);
	
	//cmp $r1, $1, nop
	register_Mem r4(clk,reset,memWrite,decOut[4],32'b 01000_00001_001_001__0000000000000000,	dataIn,Qout4);
	
	//nop, lw 1, $r0, $0
	register_Mem r5(clk,reset,memWrite,decOut[5],32'b 0000000000000000__10001_00001_000_000,	dataIn,Qout5);
	
	//nop, sw 1, $r2, $2
	register_Mem r6(clk,reset,memWrite,decOut[6],32'b 0000000000000000__10000_00001_010_010,	dataIn,Qout6);
	
	//nop, jmp 1
	register_Mem r7(clk,reset,memWrite,decOut[7],32'b 0000000000000000__11100_00000010,			dataIn,Qout7);
	
	//nop, nop
	register_Mem r8(clk,reset,memWrite,decOut[8],32'b 0000000000000000__0000000000000000,		dataIn,Qout8);

	//addi $r0, -1, nop // added this to test branch (n flag set) and jmp
	register_Mem r9(clk,reset,memWrite,decOut[9],32'b 00100_000_11111111__0000000000000000,		dataIn,Qout9);
	
	//nop, br 1
	register_Mem r10(clk,reset,memWrite,decOut[10],32'b 0000000000000000__11010_000_00000010,	dataIn,Qout10);
	
	//nop, nop
	register_Mem r11(clk,reset,memWrite,decOut[11],32'b 0000000000000000__0000000000000000,		dataIn,Qout11);
	
	//addi $r0, 6, nop // added this to test branch
	register_Mem r12(clk,reset,memWrite,decOut[12],32'b 00100_000_00000110__0000000000000000,	dataIn,Qout12);
	
	//nop, nop
	register_Mem r13(clk,reset,memWrite,decOut[13],32'b 0000000000000000__0000000000000000,		dataIn,Qout13);
	
	//nop, nop
	register_Mem r14(clk,reset,memWrite,decOut[14],32'b 0000000000000000__0000000000000000,		dataIn,Qout14);
	
	//nop, nop
	register_Mem r15(clk,reset,memWrite,decOut[15],32'b 0000000000000000__0000000000000000,		dataIn,Qout15);

	/*
	//sub $r0, $r0, $r0, nop
	register_Mem r1(clk,reset,memWrite,decOut[1],32'b 00011_01_000_000_000__0000000000000000,	dataIn,Qout1);
	
	//addi $r1, 1, nop
	register_Mem r0(clk,reset,memWrite,decOut[0],32'b 00100_001_00000001__0000000000000000,		dataIn,Qout0);
	
	//sub $r1, $r1, $r1, nop
	register_Mem r1(clk,reset,memWrite,decOut[1],32'b 00011_01_001_001_001__0000000000000000,	dataIn,Qout1);

	//nop, nop
	register_Mem r1(clk,reset,memWrite,decOut[1],32'b 0000000000000000__0000000000000000,	dataIn,Qout1);
	
	//addi $r0, 2, nop
	register_Mem r2(clk,reset,memWrite,decOut[2],32'b 00100_000_00000010__0000000000000000,		dataIn,Qout2);
	
	//shift $r0, $r0, nop
	register_Mem r3(clk,reset,memWrite,decOut[3],32'b 01000_01000_000_000__0000000000000000,	dataIn,Qout3);
	
	//nop, nop
	register_Mem r1(clk,reset,memWrite,decOut[1],32'b 0000000000000000__0000000000000000,	dataIn,Qout1);
	
	//cmp $0, $0, lw 5, $1, $1
	register_Mem r4(clk,reset,memWrite,decOut[4],32'b 01000_00001_000_000__01000_00101_000_000,	dataIn,Qout4);
	
	//addi $r0, 1, br 2
	register_Mem r5(clk,reset,memWrite,decOut[5],32'b 00100_00001_000_000__01000_00101_000_000,	dataIn,Qout5);
	*/
	
	
	mux16to1 mMem (Qout0,Qout1,Qout2,Qout3,Qout4,Qout5,Qout6,Qout7,Qout8,Qout9,Qout10,Qout11,Qout12,Qout13,Qout14,Qout15,pc[4:1],IR);
endmodule

module mux16to1( input [15:0] outR0,outR1,outR2,outR3,outR4,outR5,outR6,outR7,outR8,outR9,outR10,outR11,outR12,outR13,outR14,outR15, input [3:0] Sel, output reg [15:0] outBus );
	always@(outR0 or outR1 or outR2 or outR3 or outR4 or outR5 or outR6 or outR7 or outR8 or outR9 or outR10 or outR11 or outR12 or outR13 or outR14 or outR15 or Sel)
	case (Sel)
				4'b0000: outBus=outR0;
				4'b0001: outBus=outR1;
				4'b0010: outBus=outR2;
				4'b0011: outBus=outR3;
				4'b0100: outBus=outR4;
				4'b0101: outBus=outR5;
				4'b0110: outBus=outR6;
				4'b0111: outBus=outR7;
				4'b1000: outBus=outR8;
				4'b1001: outBus=outR9;
				4'b1010: outBus=outR10;
				4'b1011: outBus=outR11;
				4'b1100: outBus=outR12;
				4'b1101: outBus=outR13;
				4'b1110: outBus=outR14;
				4'b1111: outBus=outR15;
	endcase
endmodule

module decoder4to16( input [3:0] destReg, output reg [15:0] decOut);
	always@(destReg)
	case(destReg)
			4'b0000: decOut=16'b0000000000000001; 
			4'b0001: decOut=16'b0000000000000010;
			4'b0010: decOut=16'b0000000000000100;
			4'b0011: decOut=16'b0000000000001000;
			4'b0100: decOut=16'b0000000000010000;
			4'b0101: decOut=16'b0000000000100000;
			4'b0110: decOut=16'b0000000001000000;
			4'b0111: decOut=16'b0000000010000000;
			4'b1000: decOut=16'b0000000100000000; 
			4'b1001: decOut=16'b0000001000000000;
			4'b1010: decOut=16'b0000010000000000;
			4'b1011: decOut=16'b0000100000000000;
			4'b1100: decOut=16'b0001000000000000;
			4'b1101: decOut=16'b0010000000000000;
			4'b1110: decOut=16'b0100000000000000;
			4'b1111: decOut=16'b1000000000000000;
	endcase
endmodule
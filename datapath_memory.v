module D_ff_Mem (input clk, input reset, input regWrite, input decOut1b,input init, input d, output reg q);
	always @ (negedge clk)
	if(reset==1)
		q=init;
	else
		if(regWrite == 1 && decOut1b==1) q=d;
endmodule

module register_Mem(input clk,input reset,input regWrite,input decOut1b,input [31:0]init, input [31:0] d_in, output [31:0] q_out);
	
	D_ff_Mem dMem[31:0] (clk,reset,regWrite,decOut1b,init,d_in,q_out);
	
endmodule

module Mem(input clk, input reset,input memWrite,input memRead, input [31:0] pc, input [31:0] dataIn,
	output [31:0] IR );
	
	wire [31:0] Qout0, Qout1, Qout2, Qout3, Qout4, Qout5, Qout6, Qout7,
	Qout8, Qout9, Qout10, Qout11, Qout12, Qout13, Qout14, Qout15;
	wire [15:0] decOut;
	
	decoder4to16 dec0( pc[5:2], decOut);
	
	/*  instruction ref
		addi 	- 32'b 00100_000_00000000 	//(Rd, Offset)
		sub		- 32'b 00011_01_000_000_000 //(Rm, Rn, Rd)
		shft	- 32'b 01000_01000_000_000 	//(Rm, Rd)
		cmp		- 32'b 01000_00001_000_000 	//(Rm, Rd)
		
		lw		- 32'b 10001_00000_000_000 	//(Offset, Rn, Rd)
		sw 		- 32'b 10000_00000_000_000 	//(Offset, Rn, Rd)
		jmp 	- 32'b 11100_00000000000 	//(Offset)
		bneq	- 32'b 11010_000_00000000	//(Offset)
	*/
	
	
	/* ------- BRANCH, JUMP AND INVALID INSTR TESTS --------*/
	//addi $0, lw			$0 = 10
	register_Mem r0(clk,reset,memWrite,decOut[0],	32'b 00100_000_00001010__10001_00011_001_001,	dataIn,Qout0);

	//sub, br 16			$0 = 10
	register_Mem r1(clk,reset,memWrite,decOut[1],	32'b 00011_01_010_000_000__11010_000_00010000,	dataIn,Qout1);
	
	//nop, nop
	register_Mem r2(clk,reset,memWrite,decOut[2],	32'b 0000000000000000__0000000000000000,		dataIn,Qout2);

	//addi $1, 2 - jump 10			$1 = 2
	register_Mem r3(clk,reset,memWrite,decOut[3],	32'b 00100_001_00000010__11100_00000001100,		dataIn,Qout3);
		
	//nop, nop
	register_Mem r4(clk,reset,memWrite,decOut[4],	32'b 0000000000000000__0000000000000000,		dataIn,Qout4);
	
	//nop, nop
	register_Mem r5(clk,reset,memWrite,decOut[5],	32'b 0000000000000000__0000000000000000,		dataIn,Qout5);
	
	//shift $1, $1 - lw	0, $3, $4	$1 = 2<<2 = 8
	register_Mem r6(clk,reset,memWrite,decOut[6],	32'b 01000_01000_001_001__10001_00000_011_100,	dataIn,Qout6);
	
	//cmp $1, $0, sw			$0 - $1 => n flag se
	register_Mem r7(clk,reset,memWrite,decOut[7],	32'b 01000_00001_000_001__10000_00000_000_001,	dataIn,Qout7);
	
	//sub, branch 
	register_Mem r8(clk,reset,memWrite,decOut[8],	32'b 00011_01_000_001_000__11010_000_00000100,	dataIn,Qout8);	
	
	//nop, nop
	register_Mem r9(clk,reset,memWrite,decOut[9],	32'b 0000000000000000__0000000000000000,		dataIn,Qout9);
	
	//nop, nop
	register_Mem r10(clk,reset,memWrite,decOut[10],	32'b 0000000000000000__0000000000000000,		dataIn,Qout10);
	
	//addi $r0, 6, nop
	register_Mem r11(clk,reset,memWrite,decOut[11],	32'b 00100_000_00000110__0000000000000000,		dataIn,Qout11);
	
	//addi, invalid
	register_Mem r12(clk,reset,memWrite,decOut[12],	32'b 00100_001_00000010__100000000000001,		dataIn,Qout12);

	//addi $r0, -1, nop // added this to test branch (n flag set) and jmp
	register_Mem r13(clk,reset,memWrite,decOut[13],	32'b 00100_000_11111111__0000000000000000,		dataIn,Qout13);
	
	//nop, nop
	register_Mem r14(clk,reset,memWrite,decOut[14],	32'b 0000000000000000__0000000000000000,		dataIn,Qout14);
	
	//nop, nop
	register_Mem r15(clk,reset,memWrite,decOut[15],	32'b 0000000000000000__0000000000000000,		dataIn,Qout15);
	
	
	
	/* -------Load use hazard--------
	//addi $0, lw			$0 = 10
	register_Mem r0(clk,reset,memWrite,decOut[0],	32'b 00100_000_00001010__10001_00011_001_001,	dataIn,Qout0);

	//sub, br 16			$0 = 10
	register_Mem r1(clk,reset,memWrite,decOut[1],	32'b 00011_01_010_001_000__11010_000_00010000,	dataIn,Qout1);
	
	//nop, nop
	register_Mem r2(clk,reset,memWrite,decOut[2],	32'b 0000000000000000__0000000000000000,		dataIn,Qout2);

	//addi $1, 2 - jump 10			$1 = 2
	register_Mem r3(clk,reset,memWrite,decOut[3],	32'b 00100_001_00000010__11100_00000001100,		dataIn,Qout3);
		
		*/
		
		
	/* --------- individual instruction test set -------------
	//addi $0, 10 - nop			$0 = 10
	register_Mem r0(clk,reset,memWrite,decOut[0],	32'b 00100_000_00001010__0000000000000000,	dataIn,Qout0);
	
	//nop, br 16
	register_Mem r1(clk,reset,memWrite,decOut[1],	32'b 0000000000000000__11010_000_00010000,	dataIn,Qout1);
	
	//nop, nop
	register_Mem r2(clk,reset,memWrite,decOut[2],	32'b 0000000000000000__0000000000000000,	dataIn,Qout2);
	
	//addi $1, 2 - nop			$1 = 2
	register_Mem r3(clk,reset,memWrite,decOut[3],	32'b 00100_001_00000010__0000000000000000,	dataIn,Qout3);
	
	//sub $0, $1, $0 - nop		$0 = -8
	register_Mem r4(clk,reset,memWrite,decOut[4],	32'b 00011_01_000_001_000__0000000000000000,dataIn,Qout4);
	
	//shift $1, $1, $1 - nop	$1 = 2<<2 = 8
	register_Mem r5(clk,reset,memWrite,decOut[5],	32'b 01000_01000_001_001__0000000000000000,	dataIn,Qout5);
	
	//cmp $1, $0, nop			$0 - $1 => n flag set
	register_Mem r6(clk,reset,memWrite,decOut[6],	32'b 01000_00001_001_000__0000000000000000,	dataIn,Qout6);
	
	//nop, lw 0, $1, $0
	register_Mem r7(clk,reset,memWrite,decOut[7],	32'b 0000000000000000__10001_00000_100_000,	dataIn,Qout7);
	
	//nop, sw 0, $0, $0
	register_Mem r8(clk,reset,memWrite,decOut[8],	32'b 0000000000000000__10000_00000_000_000,	dataIn,Qout8);
	
	//nop, jmp 0
	register_Mem r9(clk,reset,memWrite,decOut[9],	32'b 0000000000000000__11100000_00000000,	dataIn,Qout9);
	
	//nop, nop
	register_Mem r10(clk,reset,memWrite,decOut[10],	32'b 0000000000000000__0000000000000000,	dataIn,Qout10);

	//addi $r0, -1, nop // added this to test branch (n flag set) and jmp
	register_Mem r11(clk,reset,memWrite,decOut[11],	32'b 00100_000_11111111__0000000000000000,	dataIn,Qout11);
	
	//nop, br 1
	register_Mem r12(clk,reset,memWrite,decOut[12],	32'b 0000000000000000__11010_000_00000010,	dataIn,Qout12);
	
	//nop, nop
	register_Mem r13(clk,reset,memWrite,decOut[13],	32'b 0000000000000000__0000000000000000,	dataIn,Qout13);
	
	//addi $r0, 6, nop // added this to test branch
	register_Mem r14(clk,reset,memWrite,decOut[14],	32'b 00100_000_00000110__0000000000000000,	dataIn,Qout14);
	
	//nop, nop
	register_Mem r15(clk,reset,memWrite,decOut[15],	32'b 0000000000000000__0000000000000000,	dataIn,Qout15);
	*/
	
	/* OVERFLOW TEST SET
	//addi $0, lw			$0 = 10
	register_Mem r0(clk,reset,memWrite,decOut[0],	32'b 00100_001_00001010__10001_00011_000_000,	dataIn,Qout0);
	
	//addi $0, nop	
	register_Mem r1(clk,reset,memWrite,decOut[1],	32'b 00100_000_00000001__00000_00000_000_000,	dataIn,Qout1);
	
	//nop, nop
	register_Mem r2(clk,reset,memWrite,decOut[2],	32'b 00000_000_00000000__00000_00000000000,		dataIn,Qout2);
	
	//overflow data
	register_Mem r3(clk,reset,memWrite,decOut[3],	32'b 0111111111111111__1111111111111111,		dataIn,Qout3);
	
	//nop, nop
	register_Mem r4(clk,reset,memWrite,decOut[4],	32'b 0000000000000000__0000000000000000,		dataIn,Qout4);
	
	//shift $1, $1, lw	$1 = 2<<2 = 8
	register_Mem r5(clk,reset,memWrite,decOut[5],	32'b 01000_01000_001_001__10001_00000_000_000,	dataIn,Qout5);
	*/
	
	mux16to1 mMem (Qout0,Qout1,Qout2,Qout3,Qout4,Qout5,Qout6,Qout7,Qout8,Qout9,Qout10,Qout11,Qout12,Qout13,Qout14,Qout15,pc[5:2],IR);

endmodule

module mux16to1( input [31:0] outR0,outR1,outR2,outR3,outR4,outR5,outR6,outR7,outR8,outR9,outR10,outR11,outR12,outR13,outR14,outR15, input [3:0] Sel, output reg [31:0] outBus );
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
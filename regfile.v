
module D_ff( input clk, input reset, input regWrite1, input regWrite2, input decOut1b1, input decOut1b2, input d1, input d2, output reg q);

		always @ (posedge clk)
			begin
				if(reset==1)
					q=0;
				else
				   if(regWrite1 == 1 && decOut1b1==1)
						begin
									q=d1;
						end
					if(regWrite2 == 1 && decOut1b2==1)
						begin
									q=d2;
						end
			end

endmodule



module register32bit_registerfile( input clk, input reset, input regWrite1, input regWrite2, input decOut1b1, input decOut1b2, input [31:0] writeData1, input [31:0] writeData2,
output [31:0] outR );

D_ff d0(clk, reset, regWrite1,regWrite2, decOut1b1, decOut1b2, writeData1[0], writeData2[0], outR[0]);
D_ff d1(clk, reset, regWrite1,regWrite2, decOut1b1, decOut1b2, writeData1[1], writeData2[1], outR[1]);
D_ff d2(clk, reset, regWrite1,regWrite2, decOut1b1, decOut1b2, writeData1[2], writeData2[2], outR[2]);
D_ff d3(clk, reset, regWrite1,regWrite2, decOut1b1, decOut1b2, writeData1[3], writeData2[3], outR[3]);
D_ff d4(clk, reset, regWrite1,regWrite2, decOut1b1, decOut1b2, writeData1[4], writeData2[4], outR[4]);
D_ff d5(clk, reset, regWrite1,regWrite2, decOut1b1, decOut1b2, writeData1[5], writeData2[5], outR[5]);
D_ff d6(clk, reset, regWrite1,regWrite2, decOut1b1, decOut1b2, writeData1[6], writeData2[6], outR[6]);
D_ff d7(clk, reset, regWrite1,regWrite2, decOut1b1, decOut1b2, writeData1[7], writeData2[7], outR[7]);
D_ff d8(clk, reset, regWrite1,regWrite2, decOut1b1, decOut1b2, writeData1[8], writeData2[8], outR[8]);
D_ff d9(clk, reset, regWrite1,regWrite2, decOut1b1, decOut1b2, writeData1[9], writeData2[9], outR[9]);
D_ff d10(clk, reset, regWrite1,regWrite2, decOut1b1, decOut1b2, writeData1[10], writeData2[10], outR[10]);
D_ff d11(clk, reset, regWrite1,regWrite2, decOut1b1, decOut1b2, writeData1[11], writeData2[11], outR[11]);
D_ff d12(clk, reset, regWrite1,regWrite2, decOut1b1, decOut1b2, writeData1[12], writeData2[12], outR[12]);
D_ff d13(clk, reset, regWrite1,regWrite2, decOut1b1, decOut1b2, writeData1[13], writeData2[13], outR[13]);
D_ff d14(clk, reset, regWrite1,regWrite2, decOut1b1, decOut1b2, writeData1[14], writeData2[14], outR[14]);
D_ff d15(clk, reset, regWrite1,regWrite2, decOut1b1, decOut1b2, writeData1[15], writeData2[15], outR[15]);
D_ff d16(clk, reset, regWrite1,regWrite2, decOut1b1, decOut1b2, writeData1[16], writeData2[16], outR[16]);
D_ff d17(clk, reset, regWrite1,regWrite2, decOut1b1, decOut1b2, writeData1[17], writeData2[17], outR[17]);
D_ff d18(clk, reset, regWrite1,regWrite2, decOut1b1, decOut1b2, writeData1[18], writeData2[18], outR[18]);
D_ff d19(clk, reset, regWrite1,regWrite2, decOut1b1, decOut1b2, writeData1[19], writeData2[19], outR[19]);
D_ff d20(clk, reset, regWrite1,regWrite2, decOut1b1, decOut1b2, writeData1[20], writeData2[20], outR[20]);
D_ff d21(clk, reset, regWrite1,regWrite2, decOut1b1, decOut1b2, writeData1[21], writeData2[21], outR[21]);
D_ff d22(clk, reset, regWrite1,regWrite2, decOut1b1, decOut1b2, writeData1[22], writeData2[22], outR[22]);
D_ff d23(clk, reset, regWrite1,regWrite2, decOut1b1, decOut1b2, writeData1[23], writeData2[23], outR[23]);
D_ff d24(clk, reset, regWrite1,regWrite2, decOut1b1, decOut1b2, writeData1[24], writeData2[24], outR[24]);
D_ff d25(clk, reset, regWrite1,regWrite2, decOut1b1, decOut1b2, writeData1[25], writeData2[25], outR[25]);
D_ff d26(clk, reset, regWrite1,regWrite2, decOut1b1, decOut1b2, writeData1[26], writeData2[26], outR[26]);
D_ff d27(clk, reset, regWrite1,regWrite2, decOut1b1, decOut1b2, writeData1[27], writeData2[27], outR[27]);
D_ff d28(clk, reset, regWrite1,regWrite2, decOut1b1, decOut1b2, writeData1[28], writeData2[28], outR[28]);
D_ff d29(clk, reset, regWrite1,regWrite2, decOut1b1, decOut1b2, writeData1[29], writeData2[29], outR[29]);	
D_ff d30(clk, reset, regWrite1,regWrite2, decOut1b1, decOut1b2, writeData1[30], writeData2[30], outR[30]);
D_ff d31(clk, reset, regWrite1,regWrite2, decOut1b1, decOut1b2, writeData1[31], writeData2[31], outR[31]);

endmodule


module registerSet( input clk, input reset, input regWrite1, input regWrite2, input [7:0] decOut1, input [7:0] decOut2, input [31:0] writeData1, input [31:0] writeData2,
output [31:0] outR0, output [31:0] outR1, output [31:0] outR2, output [31:0] outR3, output [31:0] outR4,
output [31:0] outR5, output [31:0] outR6, output [31:0] outR7);
		
		register32bit_registerfile r0 (clk, reset, regWrite1, regWrite2, decOut1[0], decOut2[0], writeData1, writeData2 , outR0 );
		register32bit_registerfile r1 (clk, reset, regWrite1, regWrite2, decOut1[1], decOut2[1], writeData1, writeData2 , outR1 );
		register32bit_registerfile r2 (clk, reset, regWrite1, regWrite2, decOut1[2], decOut2[2], writeData1, writeData2 , outR2 );
		register32bit_registerfile r3 (clk, reset, regWrite1, regWrite2, decOut1[3], decOut2[3], writeData1, writeData2 , outR3 );
		register32bit_registerfile r4 (clk, reset, regWrite1, regWrite2, decOut1[4], decOut2[4], writeData1, writeData2 , outR4 );
		register32bit_registerfile r5 (clk, reset, regWrite1, regWrite2, decOut1[5], decOut2[5], writeData1, writeData2 , outR5 );
		register32bit_registerfile r6 (clk, reset, regWrite1, regWrite2, decOut1[6], decOut2[6], writeData1, writeData2 , outR6 );
		register32bit_registerfile r7 (clk, reset, regWrite1, regWrite2, decOut1[7], decOut2[7], writeData1, writeData2 , outR7 );

endmodule


module decoder3to8( input [2:0] destReg, output reg [7:0] decOut);
	always@(destReg)
	case(destReg)
	
				3'b000: decOut=8'b00000001;
				3'b001: decOut=8'b00000010;
				3'b010: decOut=8'b00000100;
				3'b011: decOut=8'b00001000;
				3'b100: decOut=8'b00010000;
				3'b101: decOut=8'b00100000;
				3'b110: decOut=8'b01000000;
				3'b111: decOut=8'b10000000;
			
			endcase
endmodule


module mux2to1_3bits(input [2:0] in1, input [2:0] in2, input sel, output reg [2:0] muxout);

//Write your code here
	always @(in1 or in2 or sel)
		case(sel)
				
				1'b0: muxout=in1;
				1'b1: muxout=in2;
	
		endcase	

endmodule


module mux8to1( input [31:0] outR0,outR1,outR2,outR3,outR4,outR5,outR6,outR7, input [2:0] Sel, output reg [31:0] outBus );
	always@(outR0 or outR1 or outR2 or outR3 or outR4 or outR5 or outR6 or outR7 or Sel)
	case (Sel)
				3'b000 : outBus=outR0;
				3'b001 : outBus=outR1;
				3'b010 : outBus=outR2;
				3'b011 : outBus=outR3;
				3'b100 : outBus=outR4;
				3'b101 : outBus=outR5;
				3'b110 : outBus=outR6;
				3'b111 : outBus=outR7;
	endcase
endmodule

module D_ff_flag (input clk, input reset, input regWrite, input decOut1b, input d, output reg q);
	always @ (negedge clk)
	begin
	if(reset==1'b1)
		q=0;
	else
		if(regWrite == 1'b1 && decOut1b==1'b1) begin q=d; end
	end
endmodule

module flagRegisterSet(input clk, input reset, input p3_n_flag, input p3_z_flag, input p3_c_flag, input p3_o_flag, input flagWrite1, input flagWrite2, output n, output z, output c, output o);
	D_ff_flag n_flag(clk, reset, flagWrite1 | flagWrite2, 1'b1, p3_n_flag, n);
	D_ff_flag z_flag(clk, reset, flagWrite1 | flagWrite2, 1'b1, p3_z_flag, z);
	D_ff_flag c_flag(clk, reset, flagWrite1, 1'b1, p3_c_flag, c);
	D_ff_flag o_flag(clk, reset, flagWrite1, 1'b1, p3_o_flag, q);
endmodule

module registerFile(input clk, input reset, input regWrite1, input regWrite2, input [2:0] storeDataSel, input [2:0] loadStoreAdd,input [2:0] cmpShift,input [2:0] cmpShiftSub, input [2:0] subSrc ,input [2:0] addSrc, 
input [2:0] destReg1,input [2:0] destReg2,  input [31:0] writeData1, input [31:0] writeData2, output [31:0] outBus1, output [31:0] outBus2,output [31:0] outBus3,
output [31:0] outBus4,output [31:0] outBus5,output [31:0] outBus6);

	wire [7:0] decOut1;
	wire [7:0] decOut2;
	wire [31:0] outR0, outR1, outR2, outR3, outR4, outR5, outR6, outR7;
		//decoder3to8( input [2:0] destReg, output reg [7:0] decOut);
		decoder3to8 dec1(destReg1, decOut1);
		decoder3to8 dec2(destReg2, decOut2);
//module registerSet( input clk, input reset, input regWrite1, input regWrite2, input [7:0] decOut1, input [7:0] decOut2, input [31:0] writeData1, input [31:0] writeData2,
//output [31:0] outR0, output [31:0] outR1, output [31:0] outR2, output [31:0] outR3, output [31:0] outR4,
//output [31:0] outR5, output [31:0] outR6, output [31:0] outR7);
		registerSet regSet( clk, reset, regWrite1, regWrite2, decOut1, decOut2, writeData1, writeData2, outR0, outR1, outR2, outR3, outR4, outR5, outR6, outR7);
//module mux8to1( input [31:0] outR0,outR1,outR2,outR3,outR4,outR5,outR6,outR7, input [2:0] Sel, output reg [31:0] outBus );
		mux8to1 muxStoreData( outR0,outR1,outR2,outR3,outR4,outR5,outR6,outR7, storeDataSel, outBus1 );
		mux8to1 muxLoadStoreAdd( outR0,outR1,outR2,outR3,outR4,outR5,outR6,outR7, loadStoreAdd, outBus2 );
		mux8to1 muxcmpShift( outR0,outR1,outR2,outR3,outR4,outR5,outR6,outR7, cmpShift, outBus3 );
		mux8to1 muxcmpShiftSub( outR0,outR1,outR2,outR3,outR4,outR5,outR6,outR7, cmpShiftSub, outBus4 );
		mux8to1 muxSubSrc( outR0,outR1,outR2,outR3,outR4,outR5,outR6,outR7, subSrc, outBus5 );
		mux8to1 muxAddSrc(outR0,outR1,outR2,outR3,outR4,outR5,outR6,outR7, addSrc, outBus6 );
endmodule

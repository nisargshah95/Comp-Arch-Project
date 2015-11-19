module D_ff (input clk, input reset, input regWrite, input decOut1b, input d, output reg q);
	always @ (negedge clk)
	begin
	if(reset==1'b1)
		q=0;
	else
		if(regWrite == 1'b1 && decOut1b==1'b1) begin q=d; end
	end
endmodule

module register16bit( input clk, input reset, input regWrite, input decOut1b, input [15:0] writeData, output  [15:0] outR );
	D_ff d0(clk, reset, regWrite, decOut1b, writeData[0], outR[0]);
	D_ff d1(clk, reset, regWrite, decOut1b, writeData[1], outR[1]);
	D_ff d2(clk, reset, regWrite, decOut1b, writeData[2], outR[2]);
	D_ff d3(clk, reset, regWrite, decOut1b, writeData[3], outR[3]);
	D_ff d4(clk, reset, regWrite, decOut1b, writeData[4], outR[4]);
	D_ff d5(clk, reset, regWrite, decOut1b, writeData[5], outR[5]);
	D_ff d6(clk, reset, regWrite, decOut1b, writeData[6], outR[6]);
	D_ff d7(clk, reset, regWrite, decOut1b, writeData[7], outR[7]);
	D_ff d8(clk, reset, regWrite, decOut1b, writeData[8], outR[8]);
	D_ff d9(clk, reset, regWrite, decOut1b, writeData[9], outR[9]);
	D_ff d10(clk, reset, regWrite, decOut1b, writeData[10], outR[10]);
	D_ff d11(clk, reset, regWrite, decOut1b, writeData[11], outR[11]);
	D_ff d12(clk, reset, regWrite, decOut1b, writeData[12], outR[12]);
	D_ff d13(clk, reset, regWrite, decOut1b, writeData[13], outR[13]);
	D_ff d14(clk, reset, regWrite, decOut1b, writeData[14], outR[14]);
	D_ff d15(clk, reset, regWrite, decOut1b, writeData[15], outR[15]);
endmodule

module register32bit( input clk, input reset, input regWrite, input decOut1b, input [31:0] writeData, output  [31:0] outR );
	D_ff d0(clk, reset, regWrite, decOut1b, writeData[0], outR[0]);
	D_ff d1(clk, reset, regWrite, decOut1b, writeData[1], outR[1]);
	D_ff d2(clk, reset, regWrite, decOut1b, writeData[2], outR[2]);
	D_ff d3(clk, reset, regWrite, decOut1b, writeData[3], outR[3]);
	D_ff d4(clk, reset, regWrite, decOut1b, writeData[4], outR[4]);
	D_ff d5(clk, reset, regWrite, decOut1b, writeData[5], outR[5]);
	D_ff d6(clk, reset, regWrite, decOut1b, writeData[6], outR[6]);
	D_ff d7(clk, reset, regWrite, decOut1b, writeData[7], outR[7]);
	D_ff d8(clk, reset, regWrite, decOut1b, writeData[8], outR[8]);
	D_ff d9(clk, reset, regWrite, decOut1b, writeData[9], outR[9]);
	D_ff d10(clk, reset, regWrite, decOut1b, writeData[10], outR[10]);
	D_ff d11(clk, reset, regWrite, decOut1b, writeData[11], outR[11]);
	D_ff d12(clk, reset, regWrite, decOut1b, writeData[12], outR[12]);
	D_ff d13(clk, reset, regWrite, decOut1b, writeData[13], outR[13]);
	D_ff d14(clk, reset, regWrite, decOut1b, writeData[14], outR[14]);
	D_ff d15(clk, reset, regWrite, decOut1b, writeData[15], outR[15]);
	D_ff d16(clk, reset, regWrite, decOut1b, writeData[16], outR[16]);
	D_ff d17(clk, reset, regWrite, decOut1b, writeData[17], outR[17]);
	D_ff d18(clk, reset, regWrite, decOut1b, writeData[18], outR[18]);
	D_ff d19(clk, reset, regWrite, decOut1b, writeData[19], outR[19]);
	D_ff d20(clk, reset, regWrite, decOut1b, writeData[20], outR[20]);
	D_ff d21(clk, reset, regWrite, decOut1b, writeData[21], outR[21]);
	D_ff d22(clk, reset, regWrite, decOut1b, writeData[22], outR[22]);
	D_ff d23(clk, reset, regWrite, decOut1b, writeData[23], outR[23]);
	D_ff d24(clk, reset, regWrite, decOut1b, writeData[24], outR[24]);
	D_ff d25(clk, reset, regWrite, decOut1b, writeData[25], outR[25]);
	D_ff d26(clk, reset, regWrite, decOut1b, writeData[26], outR[26]);
	D_ff d27(clk, reset, regWrite, decOut1b, writeData[27], outR[27]);
	D_ff d28(clk, reset, regWrite, decOut1b, writeData[28], outR[28]);
	D_ff d29(clk, reset, regWrite, decOut1b, writeData[29], outR[29]);
	D_ff d30(clk, reset, regWrite, decOut1b, writeData[30], outR[30]);
	D_ff d31(clk, reset, regWrite, decOut1b, writeData[31], outR[31]);	
endmodule


module register4bit( input clk, input reset, input regWrite, input decOut1b, input [3:0] writeData, output  [3:0] outR );
	D_ff d0(clk, reset, regWrite, decOut1b, writeData[0], outR[0]);
	D_ff d1(clk, reset, regWrite, decOut1b, writeData[1], outR[1]);
	D_ff d2(clk, reset, regWrite, decOut1b, writeData[2], outR[2]);
	D_ff d3(clk, reset, regWrite, decOut1b, writeData[3], outR[3]);
endmodule

//Register 1 bit
module register1bit( input clk, input reset, input regWrite, input decOut1b, input writeData, output outR );
	D_ff d0(clk, reset, regWrite, decOut1b, writeData, outR);
endmodule

//Register 2 bits
module register2bit( input clk, input reset, input regWrite, input decOut1b, input [1:0]writeData, output [1:0] outR );
	D_ff d0(clk, reset, regWrite, decOut1b, writeData[0], outR[0]);
	D_ff d1(clk, reset, regWrite, decOut1b, writeData[1], outR[1]);
endmodule

module register3bit( input clk, input reset, input regWrite, input decOut1b, input [2:0]writeData, output [2:0] outR );
	D_ff d0(clk, reset, regWrite, decOut1b, writeData[0], outR[0]);
	D_ff d1(clk, reset, regWrite, decOut1b, writeData[1], outR[1]);
	D_ff d2(clk, reset, regWrite, decOut1b, writeData[2], outR[2]);

endmodule


module IF_ID(input clk, input reset,input IF_Write, input decOut1b,input flush,input [15:0] instr_set1,input [15:0] instr_set2,input [31:0] pc, 
output [15:0] p0_intr1,output [15:0] p0_intr2,output [15:0] p0_pc);
	
	register16bit set1( clk, reset||flush, IF_Write, decOut1b, instr_set1, p0_intr1 );
	register16bit set2( clk, reset||flush, IF_Write, decOut1b, instr_set2, p0_intr2 );
	register32bit pc_pipe( clk, reset||flush, IF_Write, decOut1b, pc, p0_pc );
	
endmodule

module ID_EX(input clk, input reset,input ID_Write, input decOut1b,
input [2:0] storeDataSel, input [2:0] loadStoreAddSel,input [2:0] cmpShiftSel,input [2:0] cmpShiftSubSel, 
input [2:0] subSrcSel ,input [2:0] addSrcSel, 

input [31:0] storeData, 
input [31:0] loadStoreAdd,input [31:0] cmpShift,
input [31:0] cmpShiftSub, input [31:0] subSrc ,input [31:0] addSrc,
input [31:0] sExtOut_loadstore,input [31:0] sExtOut_add,
input [31:0] p0_pc,
input [2:0] rd_add,input [2:0] rd_load,input [2:0] rd_remain,
  input [1:0]ctr_aluSrcA,input [1:0]ctr_aluSrcB,input [1:0] ctr_aluOp,  
  input ctr_g1regDst, input ctr_memRead, input ctr_memWrite,input ctr_regWrite1,input ctr_regWrite2,input cause,
  input invalid, 
  output [2:0] p1_storeDataSel, output [2:0] p1_loadStoreAddSel,
  output [2:0] p1_cmpShiftSel,output [2:0] p1_cmpShiftSubSel, 
  output [2:0] p1_subSrcSel ,output [2:0] p1_addSrcSel, 
  output [31:0] p1_storeData, output [31:0] p1_loadStoreAdd,output [31:0] p1_cmpShift,
  output [31:0] p1_cmpShiftSub, output [31:0] p1_subSrc ,output [31:0] p1_addSrc,
  output [31:0] p1_sExtOut_loadstore,output [31:0] p1_sExtOut_add,output [2:0] p1_rd_add,output [2:0] p1_rd_load,output [2:0] p1_rd_remain,
  output [1:0] p1_ctr_aluSrcA,output [1:0] p1_ctr_aluSrcB,output [1:0] p1_ctr_aluOp,  
  output p1_ctr_g1regDst, output p1_ctr_memRead, output p1_ctr_memWrite,
  output p1_ctr_regWrite1,output p1_ctr_regWrite2,output p1_cause,output p1_invalid,output [31:0] p1_pc 
  );
	
register32bit r1(  clk,  reset,  ID_Write,  decOut1b, storeData,p1_storeData );
register32bit r2(  clk,  reset,  ID_Write,  decOut1b,loadStoreAdd,p1_loadStoreAdd);
register32bit r3(  clk,  reset,  ID_Write,  decOut1b, cmpShift,  p1_cmpShift );
register32bit r4(  clk,  reset,  ID_Write,  decOut1b, cmpShiftSub,p1_cmpShiftSub);
register32bit r5(  clk,  reset,  ID_Write,  decOut1b,subSrc ,  p1_subSrc );
register32bit r6(  clk,  reset,  ID_Write,  decOut1b, addSrc, p1_addSrc );
register32bit r7(  clk,  reset,  ID_Write,  decOut1b, sExtOut_loadstore,p1_sExtOut_loadstore );
register32bit r8(  clk,  reset,  ID_Write,  decOut1b, sExtOut_add,  p1_sExtOut_add);
		
register3bit r9( clk, reset,  ID_Write, decOut1b, rd_add,  p1_rd_add );
register3bit r10(  clk,  reset,  ID_Write,  decOut1b, rd_load,  p1_rd_load );
register3bit r11(  clk,  reset,  ID_Write,  decOut1b, rd_remain,  p1_rd_remain );
		
register2bit r12(  clk,  reset,  ID_Write,  decOut1b, ctr_aluSrcA,  p1_ctr_aluSrcA1 );
register2bit r13(  clk,  reset,  ID_Write,  decOut1b, ctr_aluSrcB,  p1_ctr_aluSrcB );
register2bit r14(  clk,  reset,  ID_Write,  decOut1b, ctr_aluOp,  p1_ctr_aluOp );		
		
register1bit r15(  clk,  reset, ID_Write,  decOut1b,  ctr_g1regDst, p1_ctr_g1regDst );
register1bit r16(  clk, reset, ID_Write,  decOut1b,  ctr_memRead,p1_ctr_memRead);

register1bit r17(  clk, reset, ID_Write,  decOut1b,  ctr_memWrite,p1_ctr_memWrite);
register1bit r18(  clk, reset, ID_Write,  decOut1b,  ctr_regWrite1,p1_ctr_regWrite1);
register1bit r19(  clk, reset, ID_Write,  decOut1b,  ctr_regWrite2,p1_ctr_regWrite2);
register1bit r20(  clk, reset, ID_Write,  decOut1b,  cause,p1_cause1);
register1bit r21(  clk, reset, ID_Write,  decOut1b,  invalid,p1_invalid1);

//used for forwarding circuit

register3bit r22( clk, reset,  ID_Write, decOut1b, storeDataSel,  p1_storeDataSel );
register3bit r23(  clk,  reset,  ID_Write,  decOut1b, loadStoreAddSel,  p1_loadStoreAddSel );
register3bit r24(  clk,  reset,  ID_Write,  decOut1b, cmpShiftSel,  p1_cmpShiftSel );
register3bit r25(  clk,  reset,  ID_Write,  decOut1b, cmpShiftSubSel,  p1_cmpShiftSubSel );
register3bit r26(  clk,  reset,  ID_Write,  decOut1b, subSrcSel,  p1_subSrcSel );
register3bit r27(  clk,  reset,  ID_Write,  decOut1b, addSrcSel,  p1_addSrcSel );

//writing pc for epc

register32bit r28(  clk,  reset,  ID_Write,  decOut1b, p0_pc,p1_pc );
		
endmodule	


module EX_MEM(input clk, input reset,input EX_MEMregWrite, input decOut1b,
   input [31:0] aluOut,input [31:0] adder,input [31:0] p1_storeData,input [2:0] g1destreg,input [2:0] p1_rd_load,input p1_memRead, input p1_memWrite,
   input p1_regWrite1,input p1_regWrite2
   input g1z_flag,input g1c_flag,input g1n_flag,input g1o_flag,input p1_g1z_write,input p1_g1c_write,input p1_g1n_write,input p1_g1o_write,
	output [31:0] p2_aluOut,output [31:0] p2_adder,
	output [31:0] p2_storeData,output[2:0] p2_g1destreg,output[2:0] p2_rd_load,output p2_memRead, output p2_memWrite,
	output p2_regWrite1,output p2_regWrite2,output p2_g1z_flag,output p2_g1c_flag,output p2_g1n_flag,output p2_g1o_flag,
	output p2_g1z_write,output p2_g1c_write,output p2_g1n_write,output p2_g1o_write);
	
	register32bit r1 ( clk, reset,  EX_MEMregWrite, decOut1b,  aluOut,  p2_aluOut );
	register32bit r2 ( clk, reset,  EX_MEMregWrite, decOut1b,  adder,  p2_adder );//address calculation for load store
	register32bit r3 ( clk, reset,  EX_MEMregWrite, decOut1b,  p1_storeData,  p2_storeData );
	
	register3bit  r4( clk,  reset,  EX_MEMregWrite,  decOut1b, g1destreg,p2_g1destreg );
	register3bit  r5( clk,  reset,  EX_MEMregWrite,  decOut1b, p1_rd_load,p2_rd_load);
	
	register1bit r6( clk, reset, EX_MEMregWrite, decOut1b, p1_memRead, p2_memRead );
	register1bit r7( clk, reset, EX_MEMregWrite, decOut1b, p1_memWrite, p2_memWrite );
	register1bit r8( clk, reset, EX_MEMregWrite, decOut1b, p1_regWrite1, p2_regWrite1 );
	register1bit r9( clk, reset, EX_MEMregWrite, decOut1b, p1_regWrite2, p2_regWrite2 );
	//flags
	register1bit r10( clk, reset, EX_MEMregWrite, decOut1b, g1z_flag, p2_g1z_flag );
	register1bit r11( clk, reset, EX_MEMregWrite, decOut1b, g1c_flag, p2_g1c_flag );
	register1bit r12( clk, reset, EX_MEMregWrite, decOut1b, g1n_flag, p2_g1n_flag );
	register1bit r13( clk, reset, EX_MEMregWrite, decOut1b, g1o_flag, p2_g1o_flag );
	
	//flag writing signals

	register1bit r14( clk, reset, EX_MEMregWrite, decOut1b, p1_g1z_write, p2_g1z_write );
	register1bit r15( clk, reset, EX_MEMregWrite, decOut1b, p1_g1c_write, p2_g1c_write);
	register1bit r16( clk, reset, EX_MEMregWrite, decOut1b, p1_g1n_write, p2_g1n_write );
	register1bit r17( clk, reset, EX_MEMregWrite, decOut1b, p1_g1o_write, p2_g1o_write);
	

endmodule
	
module adder(input [31:0] in1, input [31:0] in2, output reg [31:0] adder_out);
	always@(in1 or in2)
		adder_out = in1 +in2;
endmodule



module pipelineTestBench;
	reg clk;
	reg reset;
	wire [15:0] Result;
	pipeline uut (.clk(clk), .reset(reset), .Result(Result));

	always
	#5 clk=~clk;
	
	initial
	begin
		clk=0; reset=1;
		#10  reset=0;	
		
		#210 $finish; 
	end
endmodule

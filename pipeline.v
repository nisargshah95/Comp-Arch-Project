module D_ff_pipeline (input clk, input reset, input regWrite, input d, output reg q);
	always @ (negedge clk)
	begin
	if(reset==1'b1)
		q=0;
	else
		if(regWrite == 1'b1) begin q=d; end
	end
endmodule

module register16bit( input clk, input reset, input regWrite, input [15:0] writeData, output  [15:0] outR );
  
  // Short Hand Notation
	D_ff_pipeline d[15:0] (clk, reset, regWrite, writeData, outR);

endmodule

module register32bit( input clk, input reset, input regWrite, input [31:0] writeData, output  [31:0] outR );
  
  // Short Hand Notation
	D_ff_pipeline d[31:0] (clk, reset, regWrite, writeData, outR);
	
endmodule


module register4bit( input clk, input reset, input regWrite, input [3:0] writeData, output  [3:0] outR );
	
	// Short Hand Notation
	D_ff_pipeline d[3:0](clk, reset, regWrite, writeData, outR);

endmodule

//Register 1 bit
module register1bit( input clk, input reset, input regWrite, input writeData, output outR );
  
	D_ff_pipeline d0(clk, reset, regWrite, writeData, outR);
	
endmodule

//Register 2 bits
module register2bit( input clk, input reset, input regWrite, input [1:0]writeData, output [1:0] outR );
  
  // Short Hand Notation
	D_ff_pipeline d[1:0](clk, reset, regWrite, writeData, outR);	
	
endmodule

module register3bit( input clk, input reset, input regWrite, input [2:0]writeData, output [2:0] outR );
  
  // Short Hand Notation
	D_ff_pipeline d[2:0](clk, reset, regWrite, writeData, outR);

endmodule


module IF_ID(input clk, input reset,input IF_Write, input flush,
  input [15:0] instr_set1,input [15:0] instr_set2,input [31:0] pc, 
  output [15:0] p0_intr1,output [15:0] p0_intr2,output [31:0] p0_pc);
	
	register16bit set1( clk, reset||flush, IF_Write,  instr_set1, p0_intr1 ); // Stores The 1st Instruction
	register16bit set2( clk, reset||flush, IF_Write,  instr_set2, p0_intr2 ); // Stores The 2nd Instruction
	register32bit pc_pipe( clk, reset||flush, IF_Write,  pc, p0_pc ); // Stores The PC
	
endmodule

module ID_EX(input clk, input reset,input ID_Write, input [2:0] loadStoreAddSel, input [2:0] cmpShiftSubSel, input [2:0] subSrcSel,
  input [31:0] storeData, input [31:0] loadStoreAdd,input [31:0] cmpShift, input [31:0] cmpShiftSub, input [31:0] subSrc ,input [31:0] addSrc,
  input [31:0] sExtOut_loadstore,input [31:0] sExtOut_add, input [31:0] p0_pc, input [2:0] rd_add,input [2:0] rd_load,input [2:0] rd_remain, 
  input [1:0]ctr_aluSrcA,input [1:0]ctr_aluSrcB,input [1:0] ctr_aluOp, input ctr_g1regDst, input ctr_memRead,
  input ctr_memWrite,input ctr_regWrite1,input ctr_regWrite2,input cause, input invalid, input ctr_flagWrite1, input ctr_flagWrite2,
  
  output [2:0] p1_loadStoreAddSel, output [2:0] p1_cmpShiftSubSel, output [2:0] p1_subSrcSel, output [2:0] p1_addSrcSel,
  output [31:0] p1_storeData, output [31:0] p1_loadStoreAdd, output [31:0] p1_cmpShift, output [31:0] p1_cmpShiftSub, output [31:0] p1_subSrc ,
  output [31:0] p1_addSrc, output [31:0] p1_sExtOut_loadstore, output [31:0] p1_sExtOut_add, output [2:0] p1_rd_add, output [2:0] p1_rd_load, 
  output [2:0] p1_rd_remain, output [1:0] p1_aluSrcA, output [1:0] p1_aluSrcB, output [1:0] p1_aluOp, output p1_g1regDst, output p1_memRead, 
  output p1_memWrite, output p1_regWrite1, output p1_regWrite2, output p1_cause, output p1_invalid, output [31:0] p1_pc,
  output p1_flagWrite1, output p1_flagWrite2);
	
	//register output and signExt
	register32bit r1(  clk,  reset,  ID_Write, storeData, p1_storeData );
	register32bit r2(  clk,  reset,  ID_Write, loadStoreAdd, p1_loadStoreAdd);
	register32bit r3(  clk,  reset,  ID_Write, cmpShift,  p1_cmpShift );
	register32bit r4(  clk,  reset,  ID_Write, cmpShiftSub, p1_cmpShiftSub);
	register32bit r5(  clk,  reset,  ID_Write, subSrc ,  p1_subSrc );
	register32bit r6(  clk,  reset,  ID_Write, addSrc, p1_addSrc );
	register32bit r7(  clk,  reset,  ID_Write, sExtOut_loadstore, p1_sExtOut_loadstore );
	register32bit r8(  clk,  reset,  ID_Write, sExtOut_add, p1_sExtOut_add);
	
	//register select lines and writeback lines
	register3bit r9( clk, reset,  ID_Write, rd_add,  p1_rd_add );
	register3bit r10(  clk,  reset,  ID_Write, rd_load,  p1_rd_load );
	register3bit r11(  clk,  reset,  ID_Write, rd_remain,  p1_rd_remain );
	register3bit r12(  clk,  reset,  ID_Write, loadStoreAddSel,  p1_loadStoreAddSel );
	register3bit r13(  clk,  reset,  ID_Write, cmpShiftSubSel,  p1_cmpShiftSubSel );
	register3bit r14(  clk,  reset,  ID_Write, subSrcSel,  p1_subSrcSel );		
	
	//alu signals
	register2bit r15(  clk,  reset,  ID_Write, ctr_aluSrcA,  p1_aluSrcA );
	register2bit r16(  clk,  reset,  ID_Write, ctr_aluSrcB,  p1_aluSrcB );
	register2bit r17(  clk,  reset,  ID_Write, ctr_aluOp,  p1_aluOp );		
	
	//destination register select
	register1bit r18(  clk,  reset, ID_Write, ctr_g1regDst, p1_g1regDst );
	
	//mem control
	register1bit r19(  clk,  reset, ID_Write,  ctr_memRead,p1_memRead);
	register1bit r20(  clk,  reset, ID_Write,  ctr_memWrite, p1_memWrite);
	
	//register control
	register1bit r21(  clk,  reset, ID_Write,  ctr_regWrite1, p1_regWrite1);
	register1bit r22(  clk,  reset, ID_Write,  ctr_regWrite2, p1_regWrite2);
	register1bit r23(  clk,  reset, ID_Write,  ctr_flagWrite1, p1_flagWrite1);
	register1bit r24(  clk,  reset, ID_Write,  ctr_flagWrite2, p1_flagWrite2);
	
	//exception control
	register1bit r25(  clk,  reset, ID_Write,  cause, p1_cause1);
	register1bit r26(  clk,  reset, ID_Write,  invalid, p1_invalid1);

	//writing pc for epc
	register32bit r27( clk,  reset,  ID_Write, p0_pc, p1_pc );
		
endmodule	


module EX_MEM( input clk, input reset, input EX_MEMregWrite, input [31:0] aluOut,input [31:0] adder,input [31:0] p1_storeData,
   input [2:0] g1destreg, input [2:0] p1_rd_load, input p1_memRead, input p1_memWrite, input p1_regWrite1, input p1_regWrite2,
   input g1z_flag,input g1c_flag,input g1n_flag,input g1o_flag, input p1_flagWrite1, input p1_flagWrite2, 
   
   output [31:0] p2_aluOut,output [31:0] p2_adder, output [31:0] p2_storeData, output[2:0] p2_g1destreg,output[2:0] p2_rd_load,
   output p2_memRead, output p2_memWrite, output p2_regWrite1, output p2_regWrite2, output p2_g1z_flag, output p2_g1c_flag, 
   output p2_g1n_flag,output p2_g1o_flag, output p2_flagWrite1, output p2_flagWrite2);
	
	register32bit r1(clk, reset, EX_MEMregWrite, aluOut, p2_aluOut);
	register32bit r2(clk, reset, EX_MEMregWrite, adder, p2_adder); //address calculation for load store
	register32bit r3(clk, reset, EX_MEMregWrite, p1_storeData, p2_storeData);
	
	//destination registers
	register3bit  r4(clk, reset, EX_MEMregWrite, g1destreg, p2_g1destreg);
	register3bit  r5(clk, reset, EX_MEMregWrite, p1_rd_load, p2_rd_load);
	
	//mem controls
	register1bit r6(clk, reset, EX_MEMregWrite, p1_memRead, p2_memRead);
	register1bit r7(clk, reset, EX_MEMregWrite, p1_memWrite, p2_memWrite);
	
	
	//flags
	register1bit r8(clk, reset, EX_MEMregWrite, g1z_flag, p2_g1z_flag);
	register1bit r9(clk, reset, EX_MEMregWrite, g1c_flag, p2_g1c_flag);
	register1bit r10(clk, reset, EX_MEMregWrite, g1n_flag, p2_g1n_flag);
	register1bit r11(clk, reset, EX_MEMregWrite, g1o_flag, p2_g1o_flag);
	
	//register controls
	register1bit r12(clk, reset, EX_MEMregWrite, p1_regWrite1, p2_regWrite1);
	register1bit r13(clk, reset, EX_MEMregWrite, p1_regWrite2, p2_regWrite2);
	register1bit r14(clk, reset, EX_MEMregWrite, p1_flagWrite1, p2_flagWrite1);
	register1bit r15(clk, reset, EX_MEMregWrite, p1_flagWrite2, p2_flagWrite2);
	

endmodule

module MEM_WB(input clk, input reset, input MEM_WBregWrite, input [31:0] p2_aluOut, input [31:0] loadData,
   input [2:0] p2_g1destreg, input [2:0] p2_rd_load, input p2_regWrite1, input p2_regWrite2, input p2_g1z_flag, input p2_g1c_flag,
   input p2_g1n_flag, input p2_g1o_flag, input p2_flagWrite1, input p2_flagWrite2,  
   
   output [31:0] p3_aluOut, output [31:0] p3_loadData, output [2:0] p3_g1destreg, output[2:0] p3_rd_load,
   output p3_regWrite1, output p3_regWrite2, output p3_g1z_flag, output p3_g1c_flag, output p3_g1n_flag, output p3_g1o_flag,
   output p3_flagWrite1, output p3_flagWrite2);
	
	register32bit r1(clk, reset, MEM_WBregWrite, p2_aluOut, p3_aluOut);
	register32bit r2(clk, reset, MEM_WBregWrite, loadData, p3_loadData);
	
	//flags
	register1bit r3(clk, reset, MEM_WBregWrite, p2_g1z_flag, p3_g1z_flag);
	register1bit r4(clk, reset, MEM_WBregWrite, p2_g1c_flag, p3_g1c_flag);
	register1bit r5(clk, reset, MEM_WBregWrite, p2_g1n_flag, p3_g1n_flag);
	register1bit r6(clk, reset, MEM_WBregWrite, p2_g1o_flag, p3_g1o_flag);
	
	//register controls
	register1bit r7(clk, reset, MEM_WBregWrite, p2_regWrite1, p3_regWrite1);
	register1bit r8(clk, reset, MEM_WBregWrite, p2_regWrite2, p3_regWrite2);
	register1bit r9(clk, reset, MEM_WBregWrite, p2_flagWrite1, p3_flagWrite1);
	register1bit r10(clk, reset, MEM_WBregWrite, p2_flagWrite2, p3_flagWrite2);
	
	//destination registers
	register3bit r11(clk, reset, MEM_WBregWrite, p2_g1destreg, p3_g1destreg);
	register3bit r12(clk, reset, MEM_WBregWrite, p2_rd_load, p3_rd_load);
	
endmodule
 
module adder(input [31:0] in1, input [31:0] in2, output reg [31:0] adder_out);
	always@(in1 or in2)
		adder_out = in1 +in2;
endmodule


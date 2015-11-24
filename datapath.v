module dataPath(input clk, input reset, output [31:0] Result1, output [31:0] Result2, output [31:0] aluOut);
  
  //pc wires
  wire [31:0] pc_in, pc_out, p0_pc, p1_pc;
  
  //pc possible input
  wire [31:0] new_pc_value, jumpAddress, branchAddress, osAddress;
  
  //instruction from memory
  wire [31:0] instr32;
  
  //instructions in id_stage
  wire [15:0] p0_intr1, p0_intr2;
  
  //hazard detection and cache miss outputs
  wire PCWrite, IF_Write, IF_flush, id_ex_flush;
  
  wire [31:0] store_data, loadStore_address, add_value, sub_rm_value, subCmpShift_value, cmpShift_value;
  wire [31:0] aluSrc1_out, aluSrc2_out, aluSrc1_out_new, aluSrc2_out_new, loadStore_address_new, store_data_new;
  
  //controls
  wire regWrite1, regWrite2, regWrite1_out, regWrite2_out, p1_regWrite1, p1_regWrite2, p2_regWrite1,
		p2_regWrite2, p3_regWrite1, p3_regWrite2, flagWrite1, flagWrite2,
       flagWrite1_out, flagWrite2_out, p1_flagWrite1, p1_flagWrite2, p2_flagWrite1, p2_flagWrite2,
	   p3_flagWrite1, p3_flagWrite2,
       memRd, memWr, memRd_out, memWr_out, p1_memRd, p1_memWr, p2_memRd, p2_memWr;
  
  wire [1:0] frwrd_aluSrc1_sel, frwrd_aluSrc2_sel, frwrd_lw_sw_address_sel, frwrd_store_data_sel;
  wire sel_n_flag;
  
  wire [31:0] load_data;
  wire n, z, c, o ;
  wire g1DstReg,  p1_g1DstReg;
  wire [1:0] aluSrc1, aluSrc2, aluOp, p1_aluSrc1, p1_aluSrc2, p1_aluOp, finalaluOp;
  wire n_flag, z_flag, c_flag, o_flag, n_flag_out, p2_n_flag, p2_z_flag, p2_c_flag, p2_o_flag, n_flag2,
	z_flag2, p3_n_flag, p3_z_flag, p3_c_flag, p3_o_flag;
  wire branch, jump;
  wire cause, invalid, p1_cause, p1_invalid;
  wire [31:0] signExtforlw_sw, signExtforadd, signExtforbranch;
  wire [31:0] leftShiftforlw_sw, leftShiftforbranch;
  wire [11:0] leftShiftforjump;
  wire [2:0] p1_loadStoreAddSel, p1_cmpShiftSubSel, p1_subSrcSel, p1_rd_add, p1_rd_load, p1_rd_remain;
  wire [31:0] p1_store_data, p1_loadStore_address, p1_cmpShift_value, p1_subCmpShift_value, p1_sub_rm_value,
	p1_add_value, p1_signExtforlw_sw, p1_signExtforadd;
  wire [1:0] to_pc_sel;
  wire [2:0] g1destreg, p2_g1destreg, p2_rd_load, p3_g1destreg, p3_rd_load;
 
  wire real_cause, cause_out;
 
  wire[31:0] /*aluOut,*/ p2_aluOut, p2_address_lw_sw, p2_storeData, p3_aluOut, p3_load_data, epc_out, address_lw_sw;
  
  //mux sel signal for pc
  prio_Enc p_enc(invalid|o_flag, branch&n_flag_out /*and with n*/, jump, to_pc_sel);
  
  //mux for pc
  mux_4_1_32_bit mux_pc(new_pc_value, jumpAddress, branchAddress, 32'd1603, to_pc_sel, pc_in);
  
  register32bit pc(clk, reset, PCWrite, pc_in, pc_out);
  
  Mem IM(clk, reset, 1'b0, 1'b1, pc_out, 32'd0, instr32);
  
  adder increment_pc(pc_out, 32'd4, new_pc_value);
  
  //if_id pipeline
  IF_ID if_id(clk, reset, invalid | o_flag, IF_Write, instr32[31:16], instr32[15:0], new_pc_value, p0_intr1,
	p0_intr2, p0_pc);
  
  //register file
  registerFile regF(clk, reset, p3_regWrite1, p3_regWrite2, p0_intr2[2:0], p0_intr2[5:3], p0_intr1[10:8],
	p0_intr1[8:6], 
  p0_intr1[5:3], p0_intr1[2:0], p3_g1destreg, p3_rd_load, p3_aluOut, p3_load_data,
  store_data, loadStore_address, add_value, sub_rm_value, subCmpShift_value, cmpShift_value);
  
  //flag registers
  flagRegisterSet frs(clk, reset, p3_n_flag, p3_z_flag, p3_c_flag, p3_o_flag, p3_flagWrite1, p3_flagWrite2, n,
	z, c, o);
  
  mux_2_1_1_bit mux_n_flag(n, p2_n_flag, sel_n_flag, n_flag_out);
  //hazard detection
  hazard_detection_ckt hdc(p0_intr2, p0_intr1, p1_memRd, p2_memRd, p1_flagWrite1, p1_rd_load, p2_n_flag,
	                         PCWrite, IF_Write, id_ex_flush);
  
  //control circuit
  CtrlCkt ckt(p0_intr1[15:9], p0_intr2[15:11], regWrite1, regWrite2, g1DstReg, aluSrc1, aluSrc2, aluOp, memRd,
	memWr, branch, jump,
          flagWrite1, flagWrite2, invalid, cause);
  
  signExt_lw_sw s_lw_sw(p0_intr2[10:6], signExtforlw_sw);

  signExt_add_branch s_add(p0_intr1[7:0], signExtforadd);

  signExt_add_branch s_branch(p0_intr2[7:0], signExtforbranch);

  left_shift_2bit ls21(signExtforlw_sw, leftShiftforlw_sw);


  left_shift_1bit_branch ls12(signExtforbranch, leftShiftforbranch);
  adder adderforbranch(p0_pc, leftShiftforbranch, branchAddress);
 
  left_shift_1bit_jump ls11(p0_intr2[10:0], leftShiftforjump); 
  concat con_jump(leftShiftforjump, p0_pc[31:12], jumpAddress);
  
  mux_2_1_1_bit mux1(regWrite1, 1'b0, id_ex_flush | invalid, regWrite1_out);
  mux_2_1_1_bit mux2(regWrite2, 1'b0, id_ex_flush | invalid, regWrite2_out);
  mux_2_1_1_bit mux3(flagWrite1, 1'b0, id_ex_flush | invalid, flagWrite1_out);
  mux_2_1_1_bit mux4(flagWrite2, 1'b0, id_ex_flush | invalid, flagWrite2_out);
  mux_2_1_1_bit mux5(memRd, 1'b0, id_ex_flush | invalid, memRd_out);
  mux_2_1_1_bit mux6(memWr, 1'b0, id_ex_flush | invalid, memWr_out);
  
  ID_EX id_ex(clk, reset, o_flag, 1'b1, p0_intr2[5:3], p0_intr1[5:3], p0_intr1[8:6], store_data, loadStore_address, cmpShift_value,
              subCmpShift_value, sub_rm_value, add_value, leftShiftforlw_sw, signExtforadd, p0_pc, p0_intr1[10:8],
              p0_intr2[2:0], p0_intr1[2:0], aluSrc1, aluSrc2, aluOp, g1DstReg, memRd_out, memWr_out, regWrite1_out,
              regWrite2_out, cause, invalid, flagWrite1_out, flagWrite2_out, p1_loadStoreAddSel, p1_cmpShiftSubSel, 
              p1_subSrcSel, p1_store_data, p1_loadStore_address, p1_cmpShift_value, p1_subCmpShift_value, p1_sub_rm_value,
              p1_add_value, p1_signExtforlw_sw, p1_signExtforadd, p1_rd_add, p1_rd_load, p1_rd_remain,
              p1_aluSrc1, p1_aluSrc2, p1_aluOp, p1_g1DstReg, p1_memRd, p1_memWr, p1_regWrite1, p1_regWrite2,
              p1_cause, p1_invalid, p1_pc, p1_flagWrite1, p1_flagWrite2);
  
  mux_4_1_32_bit mux_alusrc1(p1_add_value, p1_subCmpShift_value, p1_cmpShift_value, 32'd0, p1_aluSrc1, aluSrc1_out);
  mux_4_1_32_bit mux_alusrc2(p1_sub_rm_value, p1_subCmpShift_value, p1_signExtforadd, 32'd0, p1_aluSrc2, aluSrc2_out);
  mux_4_1_32_bit mux_alusrc1_new(aluSrc1_out, p2_aluOut, p3_aluOut, p3_load_data, frwrd_aluSrc1_sel, aluSrc1_out_new);
  mux_4_1_32_bit mux_alusrc2_new(aluSrc2_out, p2_aluOut, p3_aluOut, p3_load_data, frwrd_aluSrc2_sel, aluSrc2_out_new);
  mux_4_1_32_bit mux_lw_sw_address(p1_loadStore_address, p2_aluOut, p3_aluOut, p3_load_data, frwrd_lw_sw_address_sel, loadStore_address_new);
  mux_4_1_32_bit mux_store_data(p1_store_data, p2_aluOut, p3_aluOut, p3_load_data, frwrd_store_data_sel, store_data_new);
  
  mux_2_1_3_bit mux_dest_reg(p1_rd_add, p1_rd_remain, p1_g1DstReg, g1destreg);
  
  mux_2_1_1_bit mux_cause(1'b0, 1'b1, invalid, real_cause);
  
  register32bit epc(clk, reset, 1'b1, p1_pc, epc_out);
  register1bit cause_register(clk, reset, 1'b1, real_cause, cause_out);
  
  alu_ctrl_ckt alu_ctrl(p1_aluOp, p1_rd_add[1], finalaluOp);
  alu ALU( finalaluOp, aluSrc1_out_new, aluSrc2_out_new, aluOut, n_flag, z_flag, c_flag, o_flag);
  adder address(loadStore_address_new, p1_signExtforlw_sw, address_lw_sw);
  
  //forwarding circuit
forwarding forward( p1_rd_load, p1_loadStoreAddSel, p1_rd_add, p1_subSrcSel, p1_cmpShiftSubSel, p1_rd_remain, p2_g1destreg, p3_g1destreg, p3_rd_load, 
					p2_regWrite1, p3_regWrite1, p3_regWrite2, p1_aluSrc1, p1_aluSrc2, p2_flagWrite1, p2_flagWrite2, p2_n_flag, sel_n_flag, 
					frwrd_aluSrc1_sel, frwrd_aluSrc2_sel, frwrd_store_data_sel, frwrd_lw_sw_address_sel);
  
  EX_MEM ex_mem(clk, reset, o_flag/*ex_mem flush*/, 1'b1, aluOut, address_lw_sw, store_data_new, g1destreg, p1_rd_load, 
                p1_memRd, p1_memWr, p1_regWrite1, p1_regWrite2, z_flag, c_flag, n_flag, o_flag, p1_flagWrite1, 
                p1_flagWrite2, p2_aluOut, p2_address_lw_sw, p2_storeData, p2_g1destreg, p2_rd_load, p2_memRd, p2_memWr,
                p2_regWrite1,  p2_regWrite2, p2_z_flag, p2_c_flag, p2_n_flag,p2_o_flag, p2_flagWrite1, p2_flagWrite2);
   
   
  Mem DM(clk,reset,p2_memWr, p2_memRd, p2_address_lw_sw, p2_storeData, load_data);
  
  setflag setFlag(load_data, memRd, z_flag2, n_flag2);
   
  MEM_WB mem_wb(clk, reset, 1'b0/*mem_wb flush*/, 1'b1, p2_aluOut, load_data, p2_g1destreg, p2_rd_load, p2_regWrite1, 
                p2_regWrite2, p2_z_flag || z_flag2, p2_c_flag, p2_n_flag || n_flag2, p2_o_flag, p2_flagWrite1, p2_flagWrite2,  
                p3_aluOut, p3_load_data, p3_g1destreg, p3_rd_load, p3_regWrite1, p3_regWrite2, p3_z_flag, p3_c_flag, p3_n_flag,
                p3_o_flag, p3_flagWrite1, p3_flagWrite2);


endmodule

module pipelineTestBench;
    reg clk;
    reg reset;
    wire [31:0] Result1, Result2,aluOut;
    dataPath uut (.clk(clk), .reset(reset), .Result1(Result1),.Result2(Result2),.aluOut(aluOut));

    always
    #5 clk=~clk;
    
    initial
    begin
        clk=0; reset=1;
        #12  reset=0;    
        
        #210 $finish; 
    end
endmodule


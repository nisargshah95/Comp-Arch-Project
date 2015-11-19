module forwarding(input [2:0] rs1, input [2:0] rs2, input [2:0] rs3, input [2:0] rs4,
	input [2:0] rs5, input [2:0] rs6, input [2:0] rd11, input [2:0] rd21, input [2:0] rd22, 
	input regWrite11, input regWrite21, input regWrite22, input [1:0] src1, input [1:0] src2,
	input flagWrite11, input flagWrite21, input flagWrite22, output [1:0] sel_n_flag, 
	output reg [1:0] sel_src1, output reg [1:0] sel_src2, output reg [1:0] sel_rs1, output reg [1:0] sel_rs2);
	
	//rs1 = storedatasel, rs2 = load/store address, rs3 = add, rs4 = sub, rs5 = sub/shift/cmp, rs6 = shift/cmp
	//rd11 = write address of set1 instruction in ex/mem, rd12 = set2
	//rd21 = write address of set1 instruction in mem/wb, rd22 = set2
	//regWrite11 = regWrite of set1 instruction in ex/mem, regWrite12 = set2
	//regWrite21 = regWrite of set1 instruction in mem/wb, regWrite22 = set2
	//src1 = alusrc1 signal generated by ctrlckt, src2 = alusrc2
	
	always @(rs1 or rs2 or rs3 or rs4 or rs5 or rs6 or rd11 or rd12 or rd21 or rd22 or src1 or src2 or flagWrite11 or flagWrite21 or flagWrite22 or regWrite11 or regWrite21 or regWrite22)
	begin
		sel_src1 = 2'b00;
		sel_src2 = 2'b00;
		sel_rs1 = 2'b00;
		sel_rs2 = 2'b00;
		sel_n_flag = 2'b00;
		
		if((regWrite11==1'b1) && (rd11==rs1)) sel_rs1 = 2'b01;// ex/mem1--storedata
		else
		begin
			if((regWrite21==1'b1) && (rd21==rs1)) sel_rs1 = 2'b10;// mem/wb1--storedata
			if((regWrite22==1'b1) && (rd22==rs1)) sel_rs1 = 2'b11;// mem/wb2--storedata
		end
		
		if((regWrite11==1'b1) && (rd11==rs2)) sel_rs2 = 2'b01;// ex/mem1--store/load address
		else
		begin
			if((regWrite21==1'b1) && (rd21==rs2)) sel_rs2 = 2'b10;// mem/wb1--store/load address
			if((regWrite22==1'b1) && (rd22==rs2)) sel_rs2 = 2'b11;// mem/wb2--store/load address
		end
		
		if((regWrite11==1'b1) && ((src1==2'b00 && rd11==rs3) || (src1==2'b01 && rd11==rs5) || (src1==2'b10 && rd11==rs6))) sel_src1 = 2'b01;// ex/mem1--alusrc1
		else
		begin
			if((regWrite21==1'b1) && ((src1==2'b00 && rd21==rs3) || (src1==2'b01 && rd21==rs5) || (src1==2'b10 && rd21==rs6))) sel_src1 = 2'b10;// mem/wb1--alusrc1
			if((regWrite22==1'b1) && ((src1==2'b00 && rd22==rs3) || (src1==2'b01 && rd22==rs5) || (src1==2'b10 && rd22==rs6))) sel_src1 = 2'b11;// mem/wb2--alusrc1
		end
		
		if((regWrite11==1'b1) && ((src2==2'b00 && rd11==rs4) || (src2==2'b01 && rd11==rs5))) sel_src2 = 2'b01;// ex/mem1--alusrc2
		else
		begin
			if((regWrite21==1'b1) && ((src2==2'b00 && rd21==rs4) || (src2==2'b01 && rd21==rs5))) sel_src2 = 2'b10;// mem/wb1--alusrc2
			if((regWrite22==1'b1) && ((src2==2'b00 && rd22==rs4) || (src2==2'b01 && rd22==rs5))) sel_src2 = 2'b11;// mem/wb2--alusrc2
		end
		
		if(flagWrite11==1'b1) sel_n_flag = 2'b01;
		else
		begin
			if(flagWrite21==1'b1 || flagWrite22==1'b1) sel_n_flag = 2'b10;
		end
		
		
	end
endmodule
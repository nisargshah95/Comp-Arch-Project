module CtrlCkt(input [6:0] opcode1, input [4:0] opcode2, output reg regWrite1, output reg regWrite2,
               output reg g1DstReg, output reg [1:0] aluSrc1, output reg [1:0] aluSrc2, output reg [1:0] aluOp, 
               output reg memRd, output reg memWr, output reg branch, output reg jump, output reg flagWrite1, output reg flagWrite2,  
               output reg invalid, output reg cause);
	//src1 --> 00-add[10:8], 01-sub[5:3], 10-cmp/shift[2:0]
	//src2 --> 00-sub[8:6], 01-cmp/shift[5:3], 10-addSignExt
		
	always @ (opcode1)
	begin
		//muxfor2 = 1'b1;
		//muxfor1 = 1'b1;
		invalid = 1'b0;
		cause = 1'b1;
		case(opcode1[6:2])
			5'b00100: //add
			begin
				regWrite1 = 1'b1;
				flagWrite1 = 1'b1;
				g1DstReg = 1'b0;
				aluSrc1 = 2'b00; //add reg
				aluSrc2 = 2'b10; //signExt
				aluOp = 2'b01;
			end
			
			5'b00011: //sub
			begin
				regWrite1 = 1'b1;
				flagWrite1 = 1'b1;
				g1DstReg = 1'b1;
				aluSrc1 = 2'b01; //sub reg1
				aluSrc2 = 2'b00; //sub reg2/cmp/shift reg1
				aluOp = 2'b10;
			end
			
			5'b01000: //cmp/shift
			begin
				regWrite1 = 1'b0; //cmp
				if(opcode1[1:0]==2'b01) //shift
				begin
					regWrite1 = 1'b1;
				end
				flagWrite1 = 1'b1;
				g1DstReg = 1'b1;
				aluSrc1 = 2'b10; //sub reg2/cmp/shift reg1
				aluSrc2 = 2'b01; //cmp/shift reg2
				aluOp = 2'b11;
			end
			
			5'b00000:
			begin
				regWrite1 = 1'b0;
				flagWrite1 = 1'b0;
				aluSrc1 = 2'b00;
				aluSrc2 = 2'b00;
				aluOp = 2'b00;
			end
			
			default:
			begin
				regWrite1 = 1'b0;
				flagWrite1 = 1'b0;
				invalid = 1'b1;
				cause = 1'b0;
				//muxfor2 = 1'b0;
				//to be decided
			end
		endcase
	end
	always @ (opcode2)
	begin
		//muxfor1 = 1'b1;
		//muxfor2 = 1'b1;
		invalid = 1'b0;
		cause = 1'b1;
		case(opcode2)
			5'b10001:
			begin
				regWrite2 = 1'b1;
				flagWrite2 = 1'b1;
				memRd = 1'b1;
				memWr = 1'b0;
				branch = 1'b0;
				jump = 1'b0;		
			end
			
			5'b10000:
			begin
				regWrite2 = 1'b0;
				flagWrite2 = 1'b0;
				memRd = 1'b0;
				memWr = 1'b1;
				branch = 1'b0;
				jump = 1'b0;
				//invalid = 1'b0;
				//cause = 1'b1;
			end
			
			5'b11100:
			begin
				regWrite2 = 1'b0;
				flagWrite2 = 1'b0;
				memRd = 1'b0;
				memWr = 1'b0;
				branch = 1'b0;
				jump = 1'b1;
				//invalid = 1'b0;
				//cause = 1'b1;
			end
			
			5'b11010:
			begin
				regWrite2 = 1'b0;
				flagWrite2 = 1'b0;
				memRd = 1'b0;
				memWr = 1'b0;
				branch = 1'b1;
				jump = 1'b0;
				//invalid = 1'b0;
				//cause = 1'b1;
			end
			
			5'b00000:
			begin
				regWrite2 = 1'b0;
				flagWrite2 = 1'b0;
				memWr = 1'b0;
				memRd = 1'b0;
				branch = 1'b0;
				jump = 1'b0;
				//invalid = 1'b0;
				//cause = 1'b1;
			end
			
			default:
			begin
				regWrite2 = 1'b0;
				flagWrite2 = 1'b0;
				memWr = 1'b0;
				memRd = 1'b0;
				invalid = 1'b1;
				cause = 1'b0;
				//muxfor1 = 1'b0;  //for making regwrite1 for in
			end
		endcase
	end
endmodule

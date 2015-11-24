//module encoder_pc_mux(input jump, )

module mux_4_1_32_bit(input [31:0] in1, in2, in3, in4, input [1:0] sel, output reg [31:0] muxout);
  always @ (in1 or in2 or in3 or in4 or sel)
  begin
    case(sel)
      2'b00: muxout = in1;
      2'b01: muxout = in2;
      2'b10: muxout = in3;
      2'b11: muxout = in4;
    endcase
  end
endmodule

module prio_Enc(input invalid_overflow,input branch,input jump,output reg [1:0] to_pc_sel);
  
  always @(invalid_overflow, branch, jump)
  begin
			if(invalid_overflow==1'b1)	
				to_pc_sel=2'b11;
				
			else if(branch==1'b1)
					to_pc_sel=2'b10;
					
			else if(jump==1'b1)
					to_pc_sel=2'b01;	

			else
				to_pc_sel=2'b00;	

    
    end  
  endmodule
  
module setflag(input [31:0] loadData, input memRd, output reg z_flag2, output reg n_flag2);
  always @(loadData, memRd)
  begin
    if(memRd==0)
    begin
        n_flag2 = 1'b0;
        z_flag2 = 1'b0;
    end
    else
    begin
        n_flag2 = loadData[31];
      if(loadData == 32'd0) z_flag2 = 1'b1;
    end 
  end
endmodule

module mux_2_1_1_bit(input in1, input in2, input sel, output reg muxout);
  always @(in1 or in2 or sel)
  begin
    case(sel)
      1'b0: muxout = in1;
      1'b1: muxout = in2;
    endcase
  end
endmodule

module mux_2_1_3_bit(input [2:0] in1, input [2:0] in2, input sel, output reg [2:0] muxout);
  always @(in1 or in2 or sel)
  begin
    case(sel)
      1'b0: muxout = in1;
      1'b1: muxout = in2;
    endcase
  end
endmodule

module signExt_lw_sw(input [4:0] in, output reg [31:0] out);
  always @ (in)
    out = {{27{in[4]}}, in};
endmodule

module signExt_add_branch(input [7:0] in, output reg [31:0] out);
  always @ (in)
    out = {{24{in[7]}}, in};
endmodule

module signExt_jump(input [10:0] in, output reg [31:0] out);
  always @ (in)
    out = {{21{in[10]}}, in};
endmodule

module left_shift_2bit(input [31:0] in, output reg [31:0] out);
  always @(in)
    out = in << 2;
endmodule

module left_shift_1bit_branch(input [31:0] in, output reg [31:0] out);
  always @(in)
    out = in << 1;
endmodule

module left_shift_1bit_jump(input [10:0] in, output reg [11:0] out);
  always @ (in)
    out = {in[10:0], 1'b0};
endmodule

module concat(input [11:0] in1, input [19:0] in2, output reg [31:0] out);
  always @ (in1 or in2)
    out = {in2, in1};
endmodule
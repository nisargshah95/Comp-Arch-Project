module D_ff_Cache (input clk, input reset, input regWrite, input decOut1b, input d, output reg q);
	always @ (negedge clk)
	begin
	if(reset==1'b1)
		q=0;
	else
		if(regWrite == 1'b1 && decOut1b==1'b1) begin q=d; end
	end
endmodule

// Used For Valid-Invalid
module register1bit_Cache (input clk,input reset, input regWrite, input decOut1b,input data,input outR);
  
  D_ff_Cache d (clk,reset,regWrite,decOut1b,data,outR);
  
endmodule

// Register 3 bit for LRU
module register3bits_Cache (input clk,input reset,input regWrite, input decOut1b , input [2:0] data, output [2:0] outR);
  
  D_ff_Cache d[2:0] (clk,reset,regWrite,decOut1b,data,outR);

endmodule

// Used For 1 Byte
module register8bits_Cache (input clk,input reset,input regWrite, input decOut1b , input [7:0] data, output [7:0] outR);
  
  D_ff_Cache d[7:0] (clk,reset,regWrite,decOut1b,data,outR);

endmodule

// Used For Tag Bits
module register25bits_Cache (input clk,input reset,input regWrite, input decOut1b , input [24:0] data, output [24:0] outR);
  
  D_ff_Cache d[24:0] (clk,reset,regWrite,decOut1b,data,outR);

endmodule


module register32bits_Cache (input clk, input reset, input regWrite, input decOut1b, input [31:0] data, output [31:0] outR);
  
  register8bits_Cache r0 (clk,reset,regWrite,decOut1b,data[31:24],outR[31:24]);
  register8bits_Cache r1 (clk,reset,regWrite,decOut1b,data[23:16],outR[23:16]);
  register8bits_Cache r2 (clk,reset,regWrite,decOut1b,data[15:8],outR[15:8]);
  register8bits_Cache r3 (clk,reset,regWrite,decOut1b,data[7:0],outR[7:0]); 

endmodule


// Since Our Cache Line Size is 8 Bytes, This Register Will Be The Data In The Cache

module register64bits_Cache (input clk,input reset,input regWrite,input offset_MSB,input decOut1b,
  input [63:0] data, output [63:0] outR);

  register32bits_Cache r0 (clk,reset,regWrite,decOut1b&offset_MSB,data[63:32],outR[63:32]);
  register32bits_Cache r1 (clk,reset,regWrite,decOut1b&(~offset_MSB),data[31:0],outR[31:0]);
   
endmodule

module mux2to1_3bits (input [2:0] in1,in2,input select,output reg [2:0] outR);
  always@ (in1,in2,select)
  begin
    if (select == 1'b0)
      outR = in1;
    else
      outR = in2;
  end
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


module block_Cache (input clk,input reset,input cache_memWrite,input regWrite,input decOut1b,input offset_MSB, input valid,
                    input [24:0] tag,input [63:0] data,output valid_out,output [24:0] tag_out,output [63:0] data_out);
   
  register1bit_Cache valid_bit (clk,reset,cache_memWrite,decOut1b,valid,valid_out);
  
  register25bits_Cache tag_bits (clk,reset,cache_memWrite,decOut1b,tag,tag_out);
  
  register64bits_Cache data_bits (clk,reset,regWrite||cache_memWrite,offset_MSB,decOut1b,data,data_out);
  
endmodule

module cache_Mux_16to1_64bits(input [63:0] in0,in1,in2,in3,in4,in5,in6,in7,in8,in9,in10,in11,in12,in13,in14,in15,
							  input [3:0] select,output reg [63:0] mux_out);
             
	always@ (in0,in1,in2,in3,in4,in5,in6,in7,in8,in9,in10,in11,in12,in13,in14,in15,select)
        begin       
            case (select)
                4'b0000 : mux_out = in0;
                4'b0001 : mux_out = in1;
                4'b0010 : mux_out = in2;
                4'b0011 : mux_out = in3;
                4'b0100 : mux_out = in4;
                4'b0101 : mux_out = in5;
                4'b0110 : mux_out = in6;
                4'b0111 : mux_out = in7;
                4'b1000 : mux_out = in8;
                4'b1001 : mux_out = in9;
                4'b1010 : mux_out = in10;
                4'b1011 : mux_out = in11;
                4'b1100 : mux_out = in12;
                4'b1101 : mux_out = in13;
                4'b1110 : mux_out = in14;
                4'b1111 : mux_out = in15;
            endcase       
        end
endmodule


module cache_Mux_16to1_25bits(input [24:0] in0,in1,in2,in3,in4,in5,in6,in7,in8,in9,in10,in11,in12,in13,in14,in15,
							  input [3:0] select,output reg [24:0] mux_out);
             
	always@ (in0,in1,in2,in3,in4,in5,in6,in7,in8,in9,in10,in11,in12,in13,in14,in15,select)
        begin       
            case (select)
                4'b0000 : mux_out = in0;
                4'b0001 : mux_out = in1;
                4'b0010 : mux_out = in2;
                4'b0011 : mux_out = in3;
                4'b0100 : mux_out = in4;
                4'b0101 : mux_out = in5;
                4'b0110 : mux_out = in6;
                4'b0111 : mux_out = in7;
                4'b1000 : mux_out = in8;
                4'b1001 : mux_out = in9;
                4'b1010 : mux_out = in10;
                4'b1011 : mux_out = in11;
                4'b1100 : mux_out = in12;
                4'b1101 : mux_out = in13;
                4'b1110 : mux_out = in14;
                4'b1111 : mux_out = in15;
            endcase   
        end
endmodule


module cache_Mux_16to1_1bit(input in0,in1,in2,in3,in4,in5,in6,in7,in8,in9,in10,in11,in12,in13,in14,in15,
							input [3:0] select,output reg mux_out);
           
	always@ (in0,in1,in2,in3,in4,in5,in6,in7,in8,in9,in10,in11,in12,in13,in14,in15,select)
        begin       
            case (select)
                4'b0000 : mux_out = in0;
                4'b0001 : mux_out = in1;
                4'b0010 : mux_out = in2;
                4'b0011 : mux_out = in3;
                4'b0100 : mux_out = in4;
                4'b0101 : mux_out = in5;
                4'b0110 : mux_out = in6;
                4'b0111 : mux_out = in7;
                4'b1000 : mux_out = in8;
                4'b1001 : mux_out = in9;
                4'b1010 : mux_out = in10;
                4'b1011 : mux_out = in11;
                4'b1100 : mux_out = in12;
                4'b1101 : mux_out = in13;
                4'b1110 : mux_out = in14;
                4'b1111 : mux_out = in15;
            endcase   
        end
endmodule

// Comparator

module compare_tag(input [24:0] in1,in2,output reg hit);
  
	always@ (in1,in2)
	begin
		if (in1 == in2)
			hit = 1'b1;
		else
			hit = 1'b0;        
	end
endmodule
                                     
// ctrl_select Is Given By The Cache Control Circuit
// It Is To Enable The Block When Cache Miss Happens And We Have To Write Back
// Given Separately Because When Miss Happens (decOut[0]&&comp_out0) will be 0 due to comp_out0

module mux2to1_1bit (input control_offsetMSB,input offset_MSB,input hit_or_miss,output reg outR);
	always@ (control_offsetMSB,offset_MSB,hit_or_miss)
	begin
	if (hit_or_miss == 1'b0)
		outR = control_offsetMSB;
	else
		outR = offset_MSB;
	end
endmodule

module cache_column (input clk,input reset,input cache_memWrite,input regWrite, input signal,input hit,input [15:0] decOut,input [3:0] index,
                  input ctrl_offset_msb,input offset_MSB,input valid,input [24:0] tag,input [63:0] data_in,input lru_dec_out1b,
                  output reg hit_or_miss,output [63:0] data);
  
 // module block_Cache (input clk,input reset,input regWrite,input decOut1b,input offset_MSB,input valid,input [24:0] tag,
 // input [63:0] data,
 //  output valid_out,output [24:0] tag_out,output [63:0] data_out);
 
 
 
 wire [63:0] out0,out1,out2,out3,out4,out5,out6,out7,out8,out9,out10,out11,out12,out13,out14,out15;
 wire [24:0] tag_out0,tag_out1,tag_out2,tag_out3,tag_out4,tag_out5,tag_out6,tag_out7,tag_out8,tag_out9,tag_out10,tag_out11,tag_out12,tag_out13,tag_out14,tag_out15;
 wire valid_out0,valid_out1,valid_out2,valid_out3,valid_out4,valid_out5,valid_out6,valid_out7,valid_out8,valid_out9,valid_out10,valid_out11,valid_out12,valid_out13,valid_out14,valid_out15;
 
	wire actual_offsetMSB;
	mux2to1_1bit select_which_offsetMSB (ctrl_offset_msb,offset_MSB,hit_or_miss,actual_offsetMSB);
	
	//mux2to1_1bit select_columnn ((lru_dec_out1b&(~hit))||(hit_or_miss&hit)), 
	
	
 block_Cache b0 (clk,reset,cache_memWrite,regWrite,decOut[0]&&((lru_dec_out1b&(~hit))||(hit_or_miss&hit)),actual_offsetMSB,1'b1,tag,data_in,valid_out0,tag_out0,out0);         
 block_Cache b1 (clk,reset,cache_memWrite,regWrite,decOut[1]&&((lru_dec_out1b&(~hit))||(hit_or_miss&hit)),actual_offsetMSB,1'b1,tag,data_in,valid_out1,tag_out1,out1);                 
 block_Cache b2 (clk,reset,cache_memWrite,regWrite,decOut[2]&&((lru_dec_out1b&(~hit))||(hit_or_miss&hit)),actual_offsetMSB,1'b1,tag,data_in,valid_out2,tag_out2,out2);
 block_Cache b3 (clk,reset,cache_memWrite,regWrite,decOut[3]&&((lru_dec_out1b&(~hit))||(hit_or_miss&hit)),actual_offsetMSB,1'b1,tag,data_in,valid_out3,tag_out3,out3);
 block_Cache b4 (clk,reset,cache_memWrite,regWrite,decOut[4]&&((lru_dec_out1b&(~hit))||(hit_or_miss&hit)),actual_offsetMSB,1'b1,tag,data_in,valid_out4,tag_out4,out4);
 block_Cache b5 (clk,reset,cache_memWrite,regWrite,decOut[5]&&((lru_dec_out1b&(~hit))||(hit_or_miss&hit)),actual_offsetMSB,1'b1,tag,data_in,valid_out5,tag_out5,out5);
 block_Cache b6 (clk,reset,cache_memWrite,regWrite,decOut[6]&&((lru_dec_out1b&(~hit))||(hit_or_miss&hit)),actual_offsetMSB,1'b1,tag,data_in,valid_out6,tag_out6,out6);
 block_Cache b7 (clk,reset,cache_memWrite,regWrite,decOut[7]&&((lru_dec_out1b&(~hit))||(hit_or_miss&hit)),actual_offsetMSB,1'b1,tag,data_in,valid_out7,tag_out7,out7);

 block_Cache b8 (clk,reset,cache_memWrite,regWrite,decOut[8]&&((lru_dec_out1b&(~hit))||(hit_or_miss&hit)),actual_offsetMSB,1'b1,tag,data_in,valid_out8,tag_out8,out8);         
 block_Cache b9 (clk,reset,cache_memWrite,regWrite,decOut[9]&&((lru_dec_out1b&(~hit))||(hit_or_miss&hit)),actual_offsetMSB,1'b1,tag,data_in,valid_out9,tag_out9,out9);                 
 block_Cache b10 (clk,reset,cache_memWrite,regWrite,decOut[10]&&((lru_dec_out1b&(~hit))||(hit_or_miss&hit)),actual_offsetMSB,1'b1,tag,data_in,valid_out10,tag_out10,out10);
 block_Cache b11 (clk,reset,cache_memWrite,regWrite,decOut[11]&&((lru_dec_out1b&(~hit))||(hit_or_miss&hit)),actual_offsetMSB,1'b1,tag,data_in,valid_out11,tag_out11,out11);
 block_Cache b12 (clk,reset,cache_memWrite,regWrite,decOut[12]&&((lru_dec_out1b&(~hit))||(hit_or_miss&hit)),actual_offsetMSB,1'b1,tag,data_in,valid_out12,tag_out12,out12);
 block_Cache b13 (clk,reset,cache_memWrite,regWrite,decOut[13]&&((lru_dec_out1b&(~hit))||(hit_or_miss&hit)),actual_offsetMSB,1'b1,tag,data_in,valid_out13,tag_out13,out13);
 block_Cache b14 (clk,reset,cache_memWrite,regWrite,decOut[14]&&((lru_dec_out1b&(~hit))||(hit_or_miss&hit)),actual_offsetMSB,1'b1,tag,data_in,valid_out14,tag_out14,out14);
 block_Cache b15 (clk,reset,cache_memWrite,regWrite,decOut[15]&&((lru_dec_out1b&(~hit))||(hit_or_miss&hit)),actual_offsetMSB,1'b1,tag,data_in,valid_out15,tag_out15,out15);


 wire [24:0] tag_out;
 
cache_Mux_16to1_25bits mux_tag (tag_out0,tag_out1,tag_out2,tag_out3,tag_out4,tag_out5,tag_out6,tag_out7,
                          tag_out8,tag_out9,tag_out10,tag_out11,tag_out12,tag_out13,tag_out14,tag_out15,
                          index,tag_out);
  
cache_Mux_16to1_1bit mux_valid (valid_out0,valid_out1,valid_out2,valid_out3,valid_out4,valid_out5,valid_out6,valid_out7,
                          valid_out8,valid_out9,valid_out10,valid_out11,valid_out12,valid_out13,valid_out14,valid_out15,
                          index,valid_out);

cache_Mux_16to1_64bits mux_data (out0,out1,out2,out3,out4,out5,out6,out7,
                          out8,out9,out10,out11,out12,out13,out14,out15,
                          index,data);              
                  
                          
 wire tag_match;
 compare_tag c (tag_out,tag,tag_match);
 
 always @(tag_match, valid_out)
 
 if (tag_match && valid_out && signal)
    hit_or_miss = 1'b1;
 else
    hit_or_miss = 1'b0;

endmodule

module D_ff_cnt(input reset,input d,output reg q);
	always@(reset, d)
	 if(reset)
	     q=1'b0;
	  else   
		  q=d;
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

//comparator in LRU
module comparator_3bit(input [2:0] counter_value, input [2:0] mux_value, output reg comparator_out1b);
	
	always @(counter_value or mux_value)
	begin
		if(counter_value > mux_value) comparator_out1b = 1'b1;
		else comparator_out1b = 1'b0;
	end
	
endmodule

//counter in LRU
module counter(input clk,input reset,input dec_out,input comparator_out1b, input change_counter, output [2:0] cnt);
  
	reg [2:0] tmp_cnt;
	
	// TODO: convert to shorthand
	 
	always@ (negedge clk, reset)
		begin
		 if(reset)
		    tmp_cnt=3'b000;
		  else if (dec_out == 1'b1 && change_counter==1'b1)
				tmp_cnt=3'b111;
			else if(comparator_out1b == 1'b1 && change_counter==1'b1)
				tmp_cnt=cnt-3'b001;
			else tmp_cnt = cnt;
		end

  D_ff_cnt count0(reset,tmp_cnt[0], cnt[0]);
	D_ff_cnt count1(reset,tmp_cnt[1], cnt[1]);
	D_ff_cnt count2(reset,tmp_cnt[2], cnt[2]);
 


endmodule

module mux8to1_3bits (input[2:0] in0,in1,in2,in3,in4,in5,in6,in7,input [2:0] select,output reg [2:0] outR);
  
  always@ (in0,in1,in2,in3,in4,in5,in6,in7,select)
  begin
    case (select)
      3'b000 : outR = in0;
      3'b001 : outR = in1;
      3'b010 : outR = in2;
      3'b011 : outR = in3;
      3'b100 : outR = in4;
      3'b101 : outR = in5;
      3'b110 : outR = in6;
      3'b111 : outR = in7;
    endcase
    
end
endmodule


module encoder8to3_3bits (input reset,input [2:0] in0,in1,in2,in3,in4,in5,in6,in7,output reg [2:0] outR);
  
  always@ (in0,in1,in2,in3,in4,in5,in6,in7,reset)
  begin
    
  if (reset == 1'b1)
    outR = 3'b000; 
       
  if (in0 == 3'b000)
    outR = 3'b000;
  else if (in1 == 3'b000)
    outR = 3'b001;
  else  if (in2 == 3'b000)
    outR = 3'b010;
  else if (in3 == 3'b000)
    outR = 3'b011;
  else   if (in4 == 3'b000)
    outR = 3'b100;
  else   if (in5 == 3'b000)
    outR = 3'b101;
  else  if (in6 == 3'b000)
    outR = 3'b110;
  else 
    outR = 3'b111;
    
  end
endmodule

/*module mux2to1_3bits (input [2:0] in1,in2,input select,output reg [2:0] outR);
  always@ (in1,in2,select)
  begin
    if (select == 1'b0)
      outR = in1;
    else
      outR = in2;
  end
endmodule*/
    

module LRU (input clk,input reset,input decOut1b,input change_counter,input [2:0] select_set,input hit,
    output [2:0] LRUWay);
            
	wire [7:0] dec_out;
	wire [2:0] c0_out,c1_out,c2_out,c3_out,c4_out,c5_out,c6_out,c7_out;
	wire [7:0] comparator_out1b;
	wire [2:0] mux_out, mux_value;
	
	mux2to1_3bits mux123456(LRUWay, select_set, hit, mux_out);  
	
	decoder3to8 dec123456(mux_out,dec_out);
				
	// Initialise 8 Counters                
   
	counter c0 (clk,reset,dec_out[0],comparator_out1b[0],decOut1b&change_counter&(hit),c0_out);   
	counter c1 (clk,reset,dec_out[1],comparator_out1b[1],decOut1b&change_counter&(hit),c1_out);  
	counter c2 (clk,reset,dec_out[2],comparator_out1b[2],decOut1b&change_counter&(hit),c2_out);  
	counter c3 (clk,reset,dec_out[3],comparator_out1b[3],decOut1b&change_counter&(hit),c3_out);  
	counter c4 (clk,reset,dec_out[4],comparator_out1b[4],decOut1b&change_counter&(hit),c4_out);  
	counter c5 (clk,reset,dec_out[5],comparator_out1b[5],decOut1b&change_counter&(hit),c5_out);  
	counter c6 (clk,reset,dec_out[6],comparator_out1b[6],decOut1b&change_counter&(hit),c6_out);  
	counter c7 (clk,reset,dec_out[7],comparator_out1b[7],decOut1b&change_counter&(hit),c7_out);
	
	mux8to1_3bits mux813(c0_out, c1_out, c2_out, c3_out, c4_out, c5_out, c6_out, c7_out, mux_out, mux_value);
	
	comparator_3bit comparator0(c0_out, mux_value, comparator_out1b[0]);
	comparator_3bit comparator1(c1_out, mux_value, comparator_out1b[1]);
	comparator_3bit comparator2(c2_out, mux_value, comparator_out1b[2]);
	comparator_3bit comparator3(c3_out, mux_value, comparator_out1b[3]);
	comparator_3bit comparator4(c4_out, mux_value, comparator_out1b[4]);
	comparator_3bit comparator5(c5_out, mux_value, comparator_out1b[5]);
	comparator_3bit comparator6(c6_out, mux_value, comparator_out1b[6]);
	comparator_3bit comparator7(c7_out, mux_value, comparator_out1b[7]);
	
	encoder8to3_3bits enc123456(reset, c0_out, c1_out, c2_out, c3_out, c4_out, c5_out, c6_out, c7_out, LRUWay);
          
endmodule

module mux2to1_32bits (input [31:0] in1,in2,input select,output reg [31:0] outR);
  always@ (in1,in2,select)
  begin
    if (select == 1'b0)
      outR = in1;
    else
      outR = in2;
  end
endmodule

module encoder8to3_1bit (input in0,in1,in2,in3,in4,in5,in6,in7,output reg [2:0] out);
  
  always@ (in0,in1,in2,in3,in4,in5,in6,in7)
  begin
    
  if (in0 == 1'b1)
    out = 3'b000;
  else if (in1 == 1'b1)
    out = 3'b001;
  else if (in2 == 1'b1)
    out = 3'b010;
  else if (in3 == 1'b1)
    out = 3'b011;
  else if (in4 == 1'b1)
    out = 3'b100;
  else if (in5 == 1'b1)
   out = 3'b101;
  else if (in6 == 1'b1)
    out = 3'b110;
  else
    out = 3'b111;
         
  end
  
endmodule

module mux8to1_64bits(input [63:0] in0, input [63:0] in1, input [63:0] in2, input [63:0] in3, input [63:0] in4, 
  input [63:0] in5, input [63:0] in6, input [63:0] in7, input [2:0] select, output reg [63:0] muxout);
  always@ (in0,in1,in2,in3,in4,in5,in6,in7,select)
  begin
  case(select)
      3'd0: muxout = in0;
      3'd1: muxout = in1;
      3'd2: muxout = in2;
      3'd3: muxout = in3;
      3'd4: muxout = in4;
      3'd5: muxout = in5;
      3'd6: muxout = in6;
      3'd7: muxout = in7;
  endcase
  end
endmodule

module cache_control (input clk,input hit,input memRead,input memWrite,input [3:0] index,
					  output reg cache_memWrite,output reg select_data,output reg change_counter);
	
	always@ (hit,memRead,memWrite,index)
	begin
	
		change_counter = 1'b0;
		cache_memWrite = 1'b0;
		select_data = 1'b0;
		
		if (memRead == 1'b1 || memWrite == 1'b1)
		begin
			change_counter = 1'b1;
			if (hit == 1'b0)
			begin
				cache_memWrite  = 1'b1;
				select_data = 1'b1;
				
			end
		end
	end
endmodule

module mux16_1_3bit(input [2:0] in1, in2, in3, in4, in5, in6, in7, in8,
					in9, in10, in11, in12, in13, in14, in15, in16, input [3:0] sel, output reg [2:0] LRUWay_final);
	
	always@(in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, sel)
	begin
		case(sel)
		4'b0000: LRUWay_final = in1;
		4'b0001: LRUWay_final = in2;
		4'b0010: LRUWay_final = in3;
		4'b0011: LRUWay_final = in4;
		4'b0100: LRUWay_final = in5;
		4'b0101: LRUWay_final = in6;
		4'b0110: LRUWay_final = in7;
		4'b0111: LRUWay_final = in8;
		4'b1000: LRUWay_final = in9;
		4'b1001: LRUWay_final = in10;
		4'b1010: LRUWay_final = in11;
		4'b1011: LRUWay_final = in12;
		4'b1100: LRUWay_final = in13;
		4'b1101: LRUWay_final = in14;
		4'b1110: LRUWay_final = in15;
		4'b1111: LRUWay_final = in16;
		endcase
	end
endmodule

module mispreserve(input clk, input hit, output reg hit_out);
	always @(negedge clk)
	begin
		if(hit==1'b0) 
      hit_out = hit;
		else
      hit_out = 1'b1;
	end
endmodule
	
module cache (input clk,input reset,input memWrite,input memRead,input signal,input [31:0] addr,input [31:0] data,input [31:0] mem_input,input ctrl_offset_msb,
  output hit,output [31:0] data_out);  
    
  /* Whenever An Address Comes To The Cache Module, It Will Decode The Index and Give It To Each Cache Column
     The Cache Column Will Tell If That Particular Tag Is Present In It
     If Present Then hit = 1, and We Can Directly Read Or Write Into It
     The Hit Signal Goes To The LRU along with the Encoder Output and Index (Which Tells Which Block Has Been Accessed)
     LRU Does Its Job And Happily Ever After..!
  */
  
  wire [15:0] dec_index_out;
  wire hit_out;
  wire [2:0] LRUWay_final;
  // addr [6:3] Is Where Index Is Present
  decoder4to16 dec_index (addr[6:3],dec_index_out);
  
  // Making 8 Cache Columns
  // The Inputs valid,tag,data_in Are Only Used When We Are Using STORE Word Or There Is A Cache Miss
  // regWrite Input To Each Column Should Be 1, When It is SW or a Cache Miss
  
  
  wire cache_memWrite; // Set By Cache Control Ciruit
  //wire  ctrl_select; // Set By Cache Control Ciruit
  
//module cache_column (input clk,input reset,input regWrite, input hit,input [15:0] decOut,input [3:0] index,
    //              input ctrl_offset_msb,input offset_MSB,input valid,input [24:0] tag,input [63:0] data_in,input lru_dec_out1b,
     //             output reg hit_or_miss,output [63:0] data);

  // Valid Bits Is Hard-Coded To 1'b1 Because Whenever WE Write We Assume That We Are Writing Valid Data
 // Data Coming In To The Cache Can Come From Memory Or Processor. So We Need A Mux To Select This
  
  wire select_data; // Set By Cache Control Ciruit
  wire [31:0] data_to_write;
  
  mux2to1_32bits data_in (data,mem_input,select_data,data_to_write);
  
  wire [7:0] column_hit;
  wire [63:0] data_out0,data_out1,data_out2,data_out3,data_out4,data_out5,data_out6,data_out7;
  wire [7:0] lru_dec_out;
  
  cache_column c0 (clk,reset,cache_memWrite,memWrite,signal,hit&hit_out,dec_index_out,addr[6:3],
                    ctrl_offset_msb,addr[2],(ctrl_offset_msb || hit&hit_out),addr[31:7],
					{2{data_to_write}},lru_dec_out[0],column_hit[0],data_out0);
                    
  cache_column c1 (clk,reset,cache_memWrite,memWrite,signal,hit&hit_out,dec_index_out,addr[6:3],
                    ctrl_offset_msb,addr[2],(ctrl_offset_msb || hit&hit_out),addr[31:7],
					{2{data_to_write}},lru_dec_out[1],column_hit[1],data_out1);
                    
  cache_column c2 (clk,reset,cache_memWrite,memWrite,signal,hit&hit_out,dec_index_out,addr[6:3],
                    ctrl_offset_msb,addr[2],(ctrl_offset_msb || hit&hit_out),addr[31:7],
					{2{data_to_write}},lru_dec_out[2],column_hit[2],data_out2);    
                    
  cache_column c3 (clk,reset,cache_memWrite,memWrite,signal,hit,dec_index_out,addr[6:3],
                    ctrl_offset_msb,addr[2],(ctrl_offset_msb || hit),addr[31:7],
					{2{data_to_write}},lru_dec_out[3],column_hit[3],data_out3);
                    
  cache_column c4 (clk,reset,cache_memWrite,memWrite,signal,hit&hit_out,dec_index_out,addr[6:3],
                    ctrl_offset_msb,addr[2],(ctrl_offset_msb || hit&hit_out),addr[31:7],
					{2{data_to_write}},lru_dec_out[4],column_hit[4],data_out4);
                    
  cache_column c5 (clk,reset,cache_memWrite,memWrite,signal,hit&hit_out,dec_index_out,addr[6:3],
                    ctrl_offset_msb,addr[2],(ctrl_offset_msb || hit&hit_out),addr[31:7],
					{2{data_to_write}},lru_dec_out[5],column_hit[5],data_out5);
                    
  cache_column c6 (clk,reset,cache_memWrite,memWrite,signal,hit&hit_out,dec_index_out,addr[6:3],
                   ctrl_offset_msb, addr[2],(ctrl_offset_msb || hit&hit_out),addr[31:7],
				   {2{data_to_write}},lru_dec_out[6],column_hit[6],data_out6);
                    
  cache_column c7 (clk,reset,cache_memWrite,memWrite,signal,hit&hit_out,dec_index_out,addr[6:3],
                   ctrl_offset_msb, addr[2],(ctrl_offset_msb || hit&hit_out),addr[31:7],
				   {2{data_to_write}},lru_dec_out[7],column_hit[7],data_out7);
  
  wire [2:0] enc_out;
  encoder8to3_1bit enc_which_column (column_hit[0],column_hit[1],column_hit[2],
					column_hit[3],column_hit[4],column_hit[5],column_hit[6],column_hit[7],enc_out);            
  
  wire [63:0] data_out64;
  mux8to1_64bits mux_data_out (data_out0,data_out1,data_out2,data_out3,data_out4,data_out5,data_out6,data_out7,enc_out,data_out64);
  
  mux2to1_32bits data_mux (data_out64[31:0],data_out64[63:32],addr[2],data_out);
  
  or o1(hit,column_hit[0],column_hit[1],column_hit[2],column_hit[3],column_hit[4],column_hit[5],column_hit[6],column_hit[7]);
  
  wire [2:0] LRUWay0, LRUWay1, LRUWay2, LRUWay3, LRUWay4, LRUWay5, LRUWay6, LRUWay7, 
			 LRUWay8, LRUWay9, LRUWay10,LRUWay11, LRUWay12, LRUWay13, LRUWay14, LRUWay15;
  
  wire change_counter;
  
  decoder3to8 lruway_Decoder (LRUWay_final,lru_dec_out );
  
  LRU lru1 (clk,reset,dec_index_out[0],change_counter, enc_out, hit,LRUWay0);
  LRU lru2 (clk,reset,dec_index_out[1],change_counter, enc_out, hit,LRUWay1);
  LRU lru3 (clk,reset,dec_index_out[2],change_counter, enc_out, hit,LRUWay2);
  LRU lru4 (clk,reset,dec_index_out[3],change_counter, enc_out, hit,LRUWay3);
  LRU lru5 (clk,reset,dec_index_out[4],change_counter, enc_out, hit,LRUWay4);
  LRU lru6 (clk,reset,dec_index_out[5],change_counter, enc_out, hit,LRUWay5);
  LRU lru7 (clk,reset,dec_index_out[6],change_counter, enc_out, hit,LRUWay6);
  LRU lru8 (clk,reset,dec_index_out[7],change_counter, enc_out, hit,LRUWay7);
  LRU lru9 (clk,reset,dec_index_out[8],change_counter, enc_out, hit,LRUWay8);
  LRU lru10 (clk,reset,dec_index_out[9],change_counter, enc_out, hit,LRUWay9);
  LRU lru11 (clk,reset,dec_index_out[10],change_counter, enc_out, hit,LRUWay10);
  LRU lru12 (clk,reset,dec_index_out[11],change_counter, enc_out, hit,LRUWay11);
  LRU lru13 (clk,reset,dec_index_out[12],change_counter, enc_out, hit,LRUWay12);
  LRU lru14 (clk,reset,dec_index_out[13],change_counter, enc_out, hit,LRUWay13);
  LRU lru15 (clk,reset,dec_index_out[14],change_counter, enc_out, hit,LRUWay14);
  LRU lru16 (clk,reset,dec_index_out[15],change_counter, enc_out, hit,LRUWay15);
  
  mux16_1_3bit mux1613b12345(LRUWay0, LRUWay1, LRUWay2, LRUWay3, LRUWay4, LRUWay5, LRUWay6, LRUWay7, 
			 LRUWay8, LRUWay9, LRUWay10,LRUWay11, LRUWay12, LRUWay13, LRUWay14, LRUWay15, addr[6:3], LRUWay_final);
  
  cache_control cache_ckt(clk,hit&hit_out,memRead,memWrite,addr[6:3],cache_memWrite,select_data,change_counter);
  
  mispreserve mississippi(clk, hit, hit_out);

  
endmodule

/*
module cache (input clk,input reset,input memWrite,input memRead,input [31:0] addr,input [31:0] data,input [31:0] mem_input,
input ctrl_offset_msb,
  output hit,output [31:0] data_out);  
  */
module cache_testbench;
  
  reg clk, reset, memWrite, memRead, ctrl_offset_msb, signal;
  reg [31:0] addr, data, mem_input;
  wire hit;
  wire [31:0] data_out;
  
    always
    begin
      #5 clk = ~clk;
    end
    
    cache c(.clk(clk), .reset(reset), .memWrite(memWrite), .memRead(memRead), .signal(signal),.addr(addr), .data(data), .mem_input(mem_input), .ctrl_offset_msb(ctrl_offset_msb), .hit(hit), .data_out(data_out));
    
    initial
    begin
    clk=0;  
    reset = 1'b1;
	  signal=1'b1;
	  mem_input = 32'b10000000_00000000_00000000_00000011;
	  memRead   = 1'b1;
    memWrite  = 1'b0;
    #2 reset = 0;
    
    #8
	  data      = 32'b10000000_00000000_00000000_00000001;
   	addr      = 32'b10000000_00000000_00000000_00000000;
    ctrl_offset_msb = 1'b0;
    #10 ctrl_offset_msb = 1'b1;
    #10 ctrl_offset_msb = 1'b0;
    #10
    memWrite = 1'b1;
    memRead = 1'b0;
    data      = 32'b10000000_00000000_00000000_00000001; 
    //ctrl_offset_msb = 1'b1;
    #10 ctrl_offset_msb = 1'b1;

    #10 ctrl_offset_msb = 1'b0;
    
    #10
    memWrite = 1'b1;
    memRead = 1'b0;
    data      = 32'b10000000_00000000_00000000_00000001; 
   	addr      =32'b11111111_00000000_00000000_00000000;
    //ctrl_offset_msb = 1'b1;
    #10 ctrl_offset_msb = 1'b1;

    end
endmodule    
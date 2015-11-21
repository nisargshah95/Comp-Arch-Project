// D Flip-Flop Required For Register File.
// It Is Declared Posedge Because So That Read Is Only Done After Write 
module D_ff_registers( input clk, input reset, input regWrite1, input regWrite2, input decOut1b1, input decOut1b2, input d1, input d2, output reg q);

		always @ (posedge clk)
			begin						  
				if(reset==1)
					q=0;
				else
				   if(regWrite1 == 1 && decOut1b1==1)
									q=d1;
					if(regWrite2 == 1 && decOut1b2==1)
									q=d2;
			 end
endmodule
// End Of D_ff Design

// A 32  Bit Register In The Register File
module register32bit_registerfile( input clk, input reset, input regWrite1, input regWrite2,
 input decOut1b1, input decOut1b2, input [31:0] writeData1, input [31:0] writeData2,
 output [31:0] outR );

  // Short Hand Notation For Declaring The 32 Registers Simultaneously
  D_ff_registers d[31:0](clk, reset, regWrite1,regWrite2, decOut1b1, decOut1b2, writeData1, writeData2, outR);

endmodule
// End Of Register File Design

// A Set Of Registers Which Are A Part Of The Register File
// There Are 2 regWrites And 2 decOuts Are We Are Reading and Writing 2 Data At Once
module registerSet( input clk, input reset, input regWrite1, input regWrite2, input [7:0] decOut1,
  input [7:0] decOut2, input [31:0] writeData1, input [31:0] writeData2,
  output [31:0] outR0, output [31:0] outR1, output [31:0] outR2, output [31:0] outR3,
  output [31:0] outR4, output [31:0] outR5, output [31:0] outR6, output [31:0] outR7);
		
		register32bit_registerfile r0 (clk, reset, regWrite1, regWrite2, decOut1[0], decOut2[0], writeData1, writeData2 , outR0 );
		register32bit_registerfile r1 (clk, reset, regWrite1, regWrite2, decOut1[1], decOut2[1], writeData1, writeData2 , outR1 );
		register32bit_registerfile r2 (clk, reset, regWrite1, regWrite2, decOut1[2], decOut2[2], writeData1, writeData2 , outR2 );
		register32bit_registerfile r3 (clk, reset, regWrite1, regWrite2, decOut1[3], decOut2[3], writeData1, writeData2 , outR3 );
		register32bit_registerfile r4 (clk, reset, regWrite1, regWrite2, decOut1[4], decOut2[4], writeData1, writeData2 , outR4 );
		register32bit_registerfile r5 (clk, reset, regWrite1, regWrite2, decOut1[5], decOut2[5], writeData1, writeData2 , outR5 );
		register32bit_registerfile r6 (clk, reset, regWrite1, regWrite2, decOut1[6], decOut2[6], writeData1, writeData2 , outR6 );
		register32bit_registerfile r7 (clk, reset, regWrite1, regWrite2, decOut1[7], decOut2[7], writeData1, writeData2 , outR7 );

endmodule
// End Of Register Set Design


// Decoder Used For Choosing Among The 8 Registers
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
// End Of Decoder Design

module mux2to1_3bits(input [2:0] in1, input [2:0] in2, input sel, output reg [2:0] muxout);

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

// Flip Flop Used For Flag Register
module D_ff_flag (input clk, input reset, input regWrite, input d, output reg q);
	always @ (posedge clk)
	begin
	if(reset==1'b1)
		q=0;
	else
		if(regWrite == 1'b1)
		 begin
		  q=d;
		 end
	end
endmodule
// End Of Flag Register Flip Flop

// Flag Register
module flagRegisterSet(input clk, input reset, input p3_n_flag, input p3_z_flag, input p3_c_flag, input p3_o_flag, input flagWrite1, input flagWrite2, output n, output z, output c, output o);
	
	D_ff_flag n_flag(clk, reset, flagWrite1 | flagWrite2, p3_n_flag, n);
	D_ff_flag z_flag(clk, reset, flagWrite1 | flagWrite2, p3_z_flag, z);
	D_ff_flag c_flag(clk, reset, flagWrite1, p3_c_flag, c);
	D_ff_flag o_flag(clk, reset, flagWrite1, p3_o_flag, q);
	
endmodule
// End OF Flag Register

// Register File
module registerFile(input clk, input reset, input regWrite1, input regWrite2,
  input [2:0] storeDataSel, input [2:0] loadStoreAdd,input [2:0] cmpShift,input [2:0] cmpShiftSub, input [2:0] subSrc ,input [2:0] addSrc, 
  input [2:0] destReg1,input [2:0] destReg2,  input [31:0] writeData1, input [31:0] writeData2,
  output [31:0] outBus1,output [31:0] outBus2,output [31:0] outBus3,
  output [31:0] outBus4,output [31:0] outBus5,output [31:0] outBus6);

	  wire [7:0] decOut1;
	  wire [7:0] decOut2;
	  wire [31:0] outR0, outR1, outR2, outR3, outR4, outR5, outR6, outR7;
		
		decoder3to8 dec1(destReg1, decOut1);
				
		// Below Line Was Not There In Design
		decoder3to8 dec2(destReg2, decOut2);

		registerSet regSet( clk, reset, regWrite1, regWrite2, decOut1, decOut2, writeData1, writeData2, outR0, outR1, outR2, outR3, outR4, outR5, outR6, outR7);
		
		mux8to1 muxStoreData( outR0,outR1,outR2,outR3,outR4,outR5,outR6,outR7, storeDataSel, outBus1 );
		mux8to1 muxLoadStoreAdd( outR0,outR1,outR2,outR3,outR4,outR5,outR6,outR7, loadStoreAdd, outBus2 );
		mux8to1 muxcmpShift( outR0,outR1,outR2,outR3,outR4,outR5,outR6,outR7, cmpShift, outBus3 );
		mux8to1 muxcmpShiftSub( outR0,outR1,outR2,outR3,outR4,outR5,outR6,outR7, cmpShiftSub, outBus4 );
		mux8to1 muxSubSrc( outR0,outR1,outR2,outR3,outR4,outR5,outR6,outR7, subSrc, outBus5 );
		mux8to1 muxAddSrc(outR0,outR1,outR2,outR3,outR4,outR5,outR6,outR7, addSrc, outBus6 );
		
endmodule

 module test_registerFile( );
   
   // Inputs
   reg clk,reset,regWrite1,regWrite2;
   reg [2:0] in0,in1,in2,in3,in4,in5;
   reg [2:0] dest1,dest2;
   reg [31:0] writeData1,writeData2;
   
   // Outputs
   
   wire[31:0] o0,o1,o2,o3,o4,o5;
   
   // Instantiation
   registerFile uut (clk,reset,regWrite1,regWrite2,
                     in0,in1,in2,in3,in4,in5,
                     dest1,dest2,
                     writeData1,writeData2,
                     o0,o1,o2,o3,o4,o5);
    
    
    // Now The Testing Begins
        
    always
    begin
      #5 clk = ~clk;
    end
    
    initial
    begin
      clk=0;reset=1;regWrite1=1;regWrite2=1;
      in0=3'b0;in1=3'b0;in2=3'b0;in3=3'b0;in4=3'b0;in5=3'b0;
      dest1=3'b0;dest2=3'b1;
      writeData1=16'd0;writeData2=16'd1;
      
    #10 reset=0;
       in0=3'd0;in1=3'd1;in2=3'd2;in3=3'd3;in4=3'd4;in5=3'd5;
       dest1=3'd0;dest2=3'd1;
       writeData1=16'd0;writeData2=16'd1;
    #10
       dest1=3'd2;dest2=3'd3;
       writeData1=16'd2;writeData2=16'd3;
       
    #10
       dest1=3'd4;dest2=3'd5;
       writeData1=16'd4;writeData2=16'd5;          
      
    end
    
endmodule
                     
   
   


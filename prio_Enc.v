module prio_Enc(input invalid_overflow,input branch,input jump,output reg [1:0] to_pc_sel);
  
  always @(pcsrc)
  
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

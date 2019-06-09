module ALU_Ctrl( funct_i, ALUOp_i, ALU_operation_o, FURslt_o );

//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALU_operation_o;  
output     [2-1:0] FURslt_o;
     
//Internal Signals
wire		[4-1:0] ALU_operation_o;
wire		[2-1:0] FURslt_o;

//Main function
/*your code here*/
reg        [4-1:0] ALU_operation_os;
reg        [2-1:0] FURslt_os;

assign ALU_operation_o= ALU_operation_os;
assign FURslt_o=FURslt_os;
always @ ( funct_i or ALUOp_i) begin
case (ALUOp_i)
    4'b0001 : ALU_operation_os = 4'b1101; //Branch on equal
	4'b0101 : ALU_operation_os = 4'b1110; //Branch on not equal
	4'b0010 : //R-type
	begin
	FURslt_os=2'b00;
	case (funct_i)
		6'b010010 : ALU_operation_os = 4'b0010; //Add unsigned
		6'b010000 : ALU_operation_os = 4'b0110; //Subtract unsigned
		6'b010100 : ALU_operation_os = 4'b0000; //Bitwise and
		6'b010110 : ALU_operation_os = 4'b0001; //Bitwise or
		6'b010101 : ALU_operation_os = 4'b0011; //Bitwise nor
		6'b100000 : ALU_operation_os = 4'b0111; //Set on less than
		6'b000000 : 
		  begin
		  ALU_operation_os = 4'b1000; //Shift left arithmetic
		  FURslt_os=2'b01;
		  end
		6'b000010 : 
		  begin
          ALU_operation_os = 4'b1001; //Shift left arithmetic
          FURslt_os=2'b01;
          end
	endcase
	end
	
	4'b0110 : ////Add immediate
	begin 
	FURslt_os=2'b00;
	ALU_operation_os = 4'b0010; 
	end
	
	4'b1100 : //Load upper immediate
	begin 
	FURslt_os=2'b00;
	ALU_operation_os = 4'b1100; 
	end
	
	default : ALU_operation_os = 4'b1111;
	
endcase
end

endmodule      

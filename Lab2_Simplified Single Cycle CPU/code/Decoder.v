module Decoder( instr_op_i, RegWrite_o,	ALUOp_o, ALUSrc_o, RegDst_o );
     
//I/O ports
input	[6-1:0] instr_op_i;

output			RegWrite_o;
output	[3-1:0] ALUOp_o;
output			ALUSrc_o;
output			RegDst_o;
 
//Internal Signals
wire	[3-1:0] ALUOp_o;
wire			ALUSrc_o;
wire			RegWrite_o;
wire			RegDst_o;

//Main function
/*your code here*/
reg	[3-1:0] ALUOp_os;
reg			ALUSrc_os;
reg			RegWrite_os;
reg			RegDst_os;

assign ALUOp_o=ALUOp_os;
assign ALUSrc_o=ALUSrc_os;
assign RegWrite_o=RegWrite_os;
assign RegDst_o=RegDst_os;

always @(instr_op_i)
begin
	case(instr_op_i)
		6'b111111 : begin //R-type
                RegWrite_os <= 1'b1;
                ALUOp_os <= 3'b010;
                ALUSrc_os <= 1'b0; 
                RegDst_os <= 1'b1; 
                
            end
		6'b110111 : begin //Add immediate
                RegWrite_os = 1'b1; 
                ALUOp_os = 3'b110;
                ALUSrc_os = 1'b1; 
                RegDst_os = 1'b0; //don't care
            end
		6'b110000 : begin //Load upper immediate
                RegWrite_os = 1'b1;
                ALUOp_os = 3'b100;
                ALUSrc_os = 1'b1; 
                RegDst_os = 1'b0; //don't care
           end
		
		default : begin 
                RegWrite_os = 1'b0;
                ALUOp_os = 3'b000;
                ALUSrc_os = 1'b0;
                RegDst_os = 1'b0;
                
            end
	endcase
end

endmodule
   
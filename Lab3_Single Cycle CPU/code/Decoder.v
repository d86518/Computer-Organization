module Decoder( instr_op_i, instr_op_i2,RegWrite_o,	ALUOp_o, ALUSrc_o, RegDst_o, Branch_o, Branch_oy, Jump_o, MemRead_o, MemWrite_o, MemtoReg_o );
     
//I/O ports
input	[6-1:0] instr_op_i;
input	[6-1:0] instr_op_i2;
output			RegWrite_o;
output	[4-1:0] ALUOp_o;
output			ALUSrc_o;
output			RegDst_o;
output         Branch_o;
output         Branch_oy;
output         Jump_o;
output        MemRead_o;
output        MemWrite_o;
output        MemtoReg_o;
//Internal Signals
wire	[4-1:0] ALUOp_o;
wire			ALUSrc_o;
wire			RegWrite_o;
wire			RegDst_o;
wire         Branch_o;
wire         Branch_oy;
wire         Jump_o;
wire        MemRead_o;
wire         MemWrite_o;
wire         MemtoReg_o;
//Main function
/*your code here*/
reg	[4-1:0] ALUOp_os;
reg			ALUSrc_os;
reg			RegWrite_os;
reg			RegDst_os;
reg         Branch_os;
reg         Branch_oys;
reg         Jump_os;
reg        MemRead_os;
reg         MemWrite_os;
reg         MemtoReg_os;

assign ALUOp_o=ALUOp_os;
assign ALUSrc_o=ALUSrc_os;
assign RegWrite_o=RegWrite_os;
assign RegDst_o=RegDst_os;
assign Branch_o=Branch_os;
assign Jump_o=Jump_os;
assign MemRead_o=MemRead_os;
assign MemWrite_o=MemWrite_os;
assign MemtoReg_o=MemtoReg_os;


always @(instr_op_i or instr_op_i2)
begin
	case(instr_op_i)
		6'b111111 : begin //R-type
		if(instr_op_i2==6'b001000)
		  begin
		  RegWrite_os <= 1'b0;
		  ALUOp_os <= 4'b0010;
          ALUSrc_os <= 1'b0; 
          RegDst_os <= 1'b1; 
          Branch_os <= 1'b0;
          Jump_os <= 1'b0;
          MemRead_os <= 1'b0;
          MemWrite_os <= 1'b0;
          MemtoReg_os <= 1'b0;
          end
          
         else begin
                RegWrite_os <= 1'b1;
                ALUOp_os <= 4'b0010;
                ALUSrc_os <= 1'b0; 
                RegDst_os <= 1'b1; 
                Branch_os <= 1'b0;
                Jump_os <= 1'b0;
                MemRead_os <= 1'b0;
                MemWrite_os <= 1'b0;
                MemtoReg_os <= 1'b0;
                end
                
            end
		6'b110111 : begin //Add immediate
                RegWrite_os = 1'b1; 
                ALUOp_os = 4'b0110;
                ALUSrc_os = 1'b1; 
                RegDst_os = 1'b0; //don't care
                Branch_os = 1'b0;
                Jump_os <= 1'b0;                                    
                MemRead_os <= 1'b0;                                    
                MemWrite_os <= 1'b0;
                MemtoReg_os <= 1'b0;
            end
		6'b110000 : begin //Load upper immediate
                RegWrite_os = 1'b1;
                ALUOp_os = 4'b0100;
                ALUSrc_os = 1'b1; 
                RegDst_os = 1'b0; //don't care
                Branch_os = 1'b0;
                Jump_os <= 1'b0;                                    
                MemRead_os <= 1'b0;                                    
                MemWrite_os <= 1'b0;
                MemtoReg_os <= 1'b0;
           end
		6'b100001 : begin //load word
                           RegWrite_os <= 1'b1;
                           ALUOp_os <= 4'b0110;
                           ALUSrc_os <= 1'b1; 
                           RegDst_os <= 1'b0; 
                           Branch_os <= 1'b0;
                           Jump_os <= 1'b0;
                           MemRead_os <= 1'b1;
                           MemWrite_os <= 1'b0;
                           MemtoReg_os <= 1'b1;
                       end
        6'b100011 : begin //store word
                    RegWrite_os <= 1'b0;
                    ALUOp_os <= 4'b0110;
                    ALUSrc_os <= 1'b1;                                     
                    RegDst_os <= 1'b0;                                     
                    Branch_os <= 1'b0;                                    
                    Jump_os <= 1'b0;                                    
                    MemRead_os <= 1'b0;                                    
                    MemWrite_os <= 1'b1;
                    MemtoReg_os <= 1'b0;
                                   end
        6'b111011 : begin //Branch on equal
                    RegWrite_os = 1'b0; 
                    ALUOp_os = 4'b0001;
                    ALUSrc_os = 1'b0; 
                    RegDst_os = 1'b0; //don't care
                    Branch_os = 1'b1;
                    Jump_os <= 1'b0;                                    
                    MemRead_os <= 1'b0;                                    
                    MemWrite_os <= 1'b0;
                    MemtoReg_os <= 1'b0;
                    end
        6'b100101 : begin //Branch on not equal 
                    RegWrite_os = 1'b0;
                    ALUOp_os = 4'b0101;
                    ALUSrc_os = 1'b0; 
                    RegDst_os = 1'b0; //don't care
                    Branch_os = 1'b1;
                    Jump_os <= 1'b0;                                    
                    MemRead_os <= 1'b0;                                    
                    MemWrite_os <= 1'b0;
                    MemtoReg_os <= 1'b0;
                    end   
        6'b100010 : begin //jump
                    RegWrite_os <= 1'b0;
                    ALUOp_os <= 4'b0000;
                    ALUSrc_os <= 1'b0; 
                    RegDst_os <= 1'b0; 
                                    Branch_os <= 1'b0;
                                    Jump_os <= 1'b1;
                                    MemRead_os <= 1'b0;
                                    MemWrite_os <= 1'b0;
                                    MemtoReg_os <= 1'b0;
                   end   
        6'b100111 : begin //jump and link
                   RegWrite_os <= 1'b1;
                   ALUOp_os <= 4'b0000;     
                   ALUSrc_os <= 1'b0; 
                   RegDst_os <= 1'b0; 
                                   Branch_os <= 1'b0;
                                   Jump_os <= 1'b1;
                                   MemRead_os <= 1'b0;
                                   MemWrite_os <= 1'b0;
                                   MemtoReg_os <= 1'b0;
                               end                            
		default : begin 
                RegWrite_os = 1'b0;
                ALUOp_os = 4'b0000;
                ALUSrc_os = 1'b0;
                RegDst_os = 1'b0;
                Branch_os = 1'b0;
                                Jump_os <= 1'b0;                                    
                                MemRead_os <= 1'b0;                                    
                                MemWrite_os <= 1'b0;
                                MemtoReg_os <= 1'b0;
            end
	endcase
end

endmodule
   
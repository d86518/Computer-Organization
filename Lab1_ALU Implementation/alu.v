`timescale 1ns/1ps

//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    15:15:11 03/21/2019
// Design Name:
// Module Name:    alu
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
//0610016 _0413118
module alu(
           rst_n,         // negative reset            (input)
           src1,          // 32 bits source 1          (input)
           src2,          // 32 bits source 2          (input)
           ALU_control,   // 4 bits ALU control input  (input)
		 //bonus_control, // 3 bits bonus control input(input) 
           result,        // 32 bits result            (output)
           zero,          // 1 bit when the output is 0, zero must be set (output)
           cout,          // 1 bit carry out           (output)
           overflow       // 1 bit overflow            (output)
           );


input           rst_n;
input   [32-1:0] src1;
input   [32-1:0] src2;
input   [4-1:0] ALU_control;
//input   [3-1:0] bonus_control; 

output [32-1:0] result;
output          zero;
output          cout;
output          overflow;
wire             zero;
reg signed[31:0]src1temp;
reg signed[31:0]src2temp;
reg [0:0] zerotemp;
reg  [32:0] overflowdetect;
reg [0:0] overflowflag;
reg   [32-1:0] result;
wire          cout;
reg    [0:0]  coutdect;
wire          overflow;
//assign zero = (((src1 - src2) == 0) ^ (ALU_control == 4'b1110));
assign zero =zerotemp;
assign overflow =overflowflag;
assign cout =coutdect;

always @ (src1 or src2 or ALU_control) begin
    src1temp=src1;
    src2temp=src2;
    
	case (ALU_control)//alu控制指令
		4'b0000 : result= src1 & src2;
		4'b0001 : result= src1 | src2;
		4'b0010 : result= src1 + src2;
		4'b0110 : result= src1 - src2;
		4'b0111 : result=(src1temp < src2temp)? 1'b1 : 1'b0;//slt
		4'b1100 : result=  ~(src1 | src2);
		4'b1101 : result= ~(src1 & src2);
		default :  result= 0;//假如alu職不再上述範疇，回傳值0
	endcase
	case (ALU_control)
            
            4'b0010 : overflowdetect= src1 + src2;
            4'b0110 : overflowdetect= src1 - src2;
            
            default :  overflowdetect= 0;
            endcase
	if(result==0) zerotemp=1;
	else zerotemp=0;
	//32'b01111111111111111111111111111111
	if((((overflowdetect[31]==1&&src1[31]==0&&src2[31]==0)||(overflowdetect[31]==0&&src1[31]==1&&src2[31]==1))&&ALU_control==4'b0010)||
	   (((overflowdetect[31]==1&&src1[31]==0&&src2[31]==1)||(overflowdetect[31]==0&&src1[31]==1&&src2[31]==0))&&ALU_control==4'b0110)) overflowflag=1;
          else overflowflag=0;



                
     if( (((result[0]==0&&src1[0]==1)||
          (result[1]==0&&src1[1]==1)||
          (result[2]==0&&src1[2]==1)||
          (result[3]==0&&src1[3]==1)||
          (result[4]==0&&src1[4]==1)||
          (result[5]==0&&src1[5]==1)||
          (result[6]==0&&src1[6]==1)||
          (result[7]==0&&src1[7]==1)||
          (result[8]==0&&src1[8]==1)||
          (result[9]==0&&src1[9]==1)||
          (result[10]==0&&src1[10]==1)||
          (result[11]==0&&src1[11]==1)||
          (result[12]==0&&src1[12]==1)||
          (result[13]==0&&src1[13]==1)||
          (result[14]==0&&src1[14]==1)||
          (result[15]==0&&src1[15]==1)||
          (result[16]==0&&src1[16]==1)||
          (result[17]==0&&src1[17]==1)||
          (result[18]==0&&src1[18]==1)||
          (result[19]==0&&src1[19]==1)||
          (result[20]==0&&src1[20]==1)||
          (result[21]==0&&src1[21]==1)||
          (result[22]==0&&src1[22]==1)||
          (result[23]==0&&src1[23]==1)||
          (result[24]==0&&src1[24]==1)||
          (result[25]==0&&src1[25]==1)||
          (result[26]==0&&src1[26]==1)||
          (result[27]==0&&src1[27]==1)||
          (result[28]==0&&src1[28]==1)||
          (result[29]==0&&src1[29]==1)||
          (result[30]==0&&src1[30]==1)
                    
          )&&  ALU_control==4'b0010)   ||
                 (  (   (result[0]==1&&src1[0]==0)||
                        (result[1]==1&&src1[1]==0)||
                        (result[2]==1&&src1[2]==0)||
                        (result[3]==1&&src1[3]==0)||
                        (result[4]==1&&src1[4]==0)||
                        (result[5]==1&&src1[5]==0)||
                        (result[6]==1&&src1[6]==0)||
                        (result[7]==1&&src1[7]==0)||
                        (result[8]==1&&src1[8]==0)||
                        (result[9]==1&&src1[9]==0)||
                        (result[10]==1&&src1[10]==0)||
                        (result[11]==1&&src1[11]==0)||
                        (result[12]==1&&src1[12]==0)||
                        (result[13]==1&&src1[13]==0)||
                        (result[14]==1&&src1[14]==0)||
                        (result[15]==1&&src1[15]==0)||
                        (result[16]==1&&src1[16]==0)||
                        (result[17]==1&&src1[17]==0)||
                        (result[18]==1&&src1[18]==0)||
                        (result[19]==1&&src1[19]==0)||
                        (result[20]==1&&src1[20]==0)||
                        (result[21]==1&&src1[21]==0)||
                        (result[22]==1&&src1[22]==0)||
                        (result[23]==1&&src1[23]==0)||
                        (result[24]==1&&src1[24]==0)||
                        (result[25]==1&&src1[25]==0)||
                        (result[26]==1&&src1[26]==0)||
                        (result[27]==1&&src1[27]==0)||
                        (result[28]==1&&src1[28]==0)||
                        (result[29]==1&&src1[29]==0)||
                        (result[30]==1&&src1[30]==0)  )&&
                        ALU_control==4'b0110           )         ) coutdect=1;
                        else coutdect=0;        
end
endmodule

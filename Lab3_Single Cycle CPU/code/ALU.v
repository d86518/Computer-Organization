module ALU( aluSrc1, aluSrc2, ALU_operation_i, result, zero, overflow );

//I/O ports 
input	[32-1:0] aluSrc1;
input	[32-1:0] aluSrc2;
input	 [4-1:0] ALU_operation_i;

output	[32-1:0] result;
output			 zero;
output			 overflow;

//Internal Signals
wire			 zero;

wire			 overflow;

wire	[32-1:0] result;



//Main function
/*your code here*/
reg              zeros;
reg			     overflows;
reg     [32-1:0] results;
reg signed [32-1:0] alut1;
reg signed [32-1:0] alut2;
assign zero = zeros;
assign overflow = overflows;
assign result = results;

always @ (aluSrc1 or aluSrc2 or ALU_operation_i) begin
    alut1=aluSrc1;
    alut2=aluSrc2;
	case (ALU_operation_i)
		4'b0000 : results <= aluSrc1 & aluSrc2;
		4'b0001 : results <= aluSrc1 | aluSrc2;
		4'b0011 : results <= ~(aluSrc1 | aluSrc2);
		4'b0010 : results <= aluSrc1 + aluSrc2;
		4'b0110 : results <= aluSrc1 - aluSrc2;
		4'b0111 : results <= alut1 < alut2 ? 1'b1 : 1'b0;
		4'b1000 : results <= $signed(aluSrc2) <<<aluSrc1 ; //Shift right arithmetic
		4'b1001 : results <= $signed(aluSrc2) >>>aluSrc1; //Shift right arithmetic 
		4'b1100 : results <= aluSrc2 <<< 32'd16;
		4'b1101 : begin
                  results <= aluSrc1 - aluSrc2; //Branch on equal
                  zeros <= ((aluSrc1 - aluSrc2) == 0);
        end
        4'b1110 : begin
                  results <= aluSrc1 - aluSrc2; //Branch on equal
                  zeros <= ((aluSrc1 - aluSrc2) != 0);
        end
                
		default : results <= 0;
	endcase
        
    if((((results[31]==1&& aluSrc1[31]==0&& aluSrc2[31]==0)||(results[31]==0&& aluSrc1[31]==1&& aluSrc2[31]==1))&&ALU_operation_i==4'b0010)||
               (((results[31]==1&& aluSrc1[31]==0&& aluSrc2[31]==1)||(results[31]==0&& aluSrc1[31]==1&& aluSrc2[31]==0))&&ALU_operation_i==4'b0110)) overflows=1;
                  else overflows=0;
end
endmodule

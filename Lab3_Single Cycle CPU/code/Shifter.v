module Shifter( result, leftRight, shamt, sftSrc );

//I/O ports 
output	[32-1:0] result;

input	 [4-1:0] leftRight;
input	[5-1:0] shamt;
input	[32-1:0] sftSrc ;

//Internal Signals
wire	[32-1:0] result;

//Main function
/*your code here*/
reg 	[32-1:0] results;
reg 	[5-1:0] shamts;
assign result= results;
always @ ( leftRight or sftSrc) begin
    shamts ={{27{shamt[4]}}, shamt[4:0]};
    if(leftRight ==4'b1000)
    results <= $signed(sftSrc) <<< shamts;
    else if(leftRight ==4'b1001)
    results <= $signed(sftSrc) >>> shamts;
end

endmodule
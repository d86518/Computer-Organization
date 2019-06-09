module Mux2to1( data0_i, data1_i, select_i, data_o );

parameter size = 32;			   
			
//I/O ports               
input wire	[size-1:0] data0_i;          
input wire	[size-1:0] data1_i;
input wire	select_i;
output wire	[size-1:0] data_o; 
//Main function
/*your code here*/
reg     [size-1:0] data_os;
assign data_o = data_os;
always @ (data0_i or data1_i or select_i) begin
    if(select_i) data_os = data1_i;
	else data_os = data0_i;
end


endmodule   
    
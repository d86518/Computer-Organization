module Mux3to1( data0_i, data1_i, data2_i, select_i, data_o );

parameter size = 32;			   
			
//I/O ports               
input wire	[size-1:0] data0_i;          
input wire	[size-1:0] data1_i;
input wire	[size-1:0] data2_i;
input wire	[2-1:0] select_i;
output wire	[size-1:0] data_o; 

//Main function
/*your code here*/
reg     [size-1:0] data_os;
assign data_o = data_os;
always @ (data0_i or data1_i or select_i or data2_i) begin
    case(select_i) 
    2'b00 :data_os = data0_i;
	2'b01 :data_os =data1_i;
	2'b10 :data_os = data2_i;
	endcase
end
endmodule         

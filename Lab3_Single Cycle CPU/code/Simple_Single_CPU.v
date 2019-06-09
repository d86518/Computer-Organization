module Simple_Single_CPU( clk_i, rst_n );

//I/O port
input         clk_i;
input         rst_n;

//Internal Signles
wire [31:0] pc_in;
wire [31:0] pc_out, pc_next,pc_2,pc_3,pc_4;
wire [31:0] instruction;
wire RegDst;
wire Branch,Branchtype;
wire [4:0] reg_write1,reg_write12; 
wire [31:0]write_data,datastore,datamemoryo,write_datapop;
wire RegWrite;
wire[31:0]read_data_1;
wire[31:0]read_data_2;
wire[2:0] aluop;
wire alusrc;
wire[3:0]ALUoperation;
wire[1:0] FURslto;
wire[31:0]signextend,zerofilled;
wire [31:0] ALU_input,aluresult,shifterresult,Shift_Left_Two_32,branch_dst;
wire zero,overflow,zeroflop,MUX_zero;
wire Jump;
wire MemRead;
wire MemWrite;
wire MemtoReg;
wire [31:0] Jump_address,pcshifterresult;
//modules
Program_Counter PC(
        .clk_i(clk_i),      
	    .rst_n(rst_n),     
	    .pc_in_i(pc_4) ,   
	    .pc_out_o(pc_out) 
	    );
	
Adder Adder1(
        .src1_i(pc_out),     
	    .src2_i(32'd4),
	    .sum_o(pc_in)    
	    );
	
Instr_Memory IM(
        .pc_addr_i(pc_out),  
	    .instr_o(instruction)    
	    );
Shifter shifterfirst( 
                   .result(pcshifterresult), 
                   .leftRight(4'b1000),
                   .shamt(5'b00010),
                   .sftSrc({{6'b000000}, instruction[25:0]}) 
                   );
assign Jump_address = {pc_in[31:28], pcshifterresult[27:0]};

Shifter shiftersecond( 
                   .result(Shift_Left_Two_32), 
                   .leftRight(4'b1000),
                   .shamt(5'b00010),
                   .sftSrc(signextend) 
                   );
Adder Adder2(.src1_i(pc_in), 
             .src2_i(Shift_Left_Two_32), 
             .sum_o(branch_dst));
             
assign	MUX_zero = zero & Branch;
              
Mux2to1 #(.size(32))firstselect(
             .data0_i(pc_in),
             .data1_i(branch_dst),
             .select_i(MUX_zero),
             .data_o(pc_2)
              );   
              
Mux2to1 #(.size(32)) secondselect(
             .data0_i(pc_2),
             .data1_i(Jump_address),
             .select_i(Jump),
             .data_o(pc_3)
              );   
Mux2to1 #(.size(32)) thirdselect(
                           .data0_i(pc_3),
                           .data1_i(read_data_1),
                           .select_i(instruction == 32'b11111111111000000000000000001000),
                           .data_o(pc_4)
                            );
//Mux3to1 #(.size(32)) secondselecte(
//                      .data0_i(pc_2),
//                      .data1_i(Jump_address),
//                      .data2_i(aluresult),
//                      .select_i(FURslto),
//                      .data_o(pc_3)
//                      );
                      
Mux2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instruction[20:16]),
        .data1_i(instruction[15:11]),
        .select_i(RegDst),
        .data_o(reg_write12)
        );	
Mux2to1 #(.size(32)) jalselect(
                     .data0_i(reg_write12),
                     .data1_i(5'b11111),
                     .select_i(instruction[31:26] == 6'b100111),
                     .data_o(reg_write1)
                      );   		
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_n(rst_n) ,     
        .RSaddr_i(instruction[25:21]) ,  
        .RTaddr_i(instruction[20:16]) ,  
        .RDaddr_i(reg_write1) ,  
        .RDdata_i(write_data)  , 
        .RegWrite_i(RegWrite),//
        .RSdata_o(read_data_1) ,  
        .RTdata_o(read_data_2)   
        );
	
Decoder Decoder(
        .instr_op_i(instruction[31:26]), 
        .instr_op_i2(instruction[5:0]),
	    .RegWrite_o(RegWrite), //
	    .ALUOp_o(aluop),   
	    .ALUSrc_o(alusrc),   
	    .RegDst_o(RegDst) , 
	    .Branch_o(Branch), 
	    .Branch_oy(Branchtype), 
	    .Jump_o(Jump), 
	    .MemRead_o(MemRead), 
	    .MemWrite_o(MemWrite), 
	    .MemtoReg_o(MemtoReg) 
		);

ALU_Ctrl AC(
        .funct_i(instruction[5:0]),   
        .ALUOp_i(aluop),   
        .ALU_operation_o(ALUoperation),
		.FURslt_o(FURslto)
        );
	
Sign_Extend SE(
        .data_i(instruction[15:0]),
        .data_o(signextend)
        );

Zero_Filled ZF(
        .data_i(instruction[15:0]),
        .data_o(zerofilled)
        );
		
Mux2to1 #(.size(32)) ALU_src2Src(
        .data0_i(read_data_2),
        .data1_i(signextend),
        .select_i(alusrc),
        .data_o(ALU_input)
        );	
		
ALU ALU(
		.aluSrc1(read_data_1),
	    .aluSrc2(ALU_input),
	    .ALU_operation_i(ALUoperation),
		.result(aluresult),
		.zero(zero),
		.overflow(overflow)
	    );
assign zeroflop = zero;   
                		
Shifter shifter( 
		.result(shifterresult), 
		.leftRight(ALUoperation),
		.shamt(instruction[10:6]),
		.sftSrc(ALU_input) 
		);
		
Mux3to1 #(.size(32)) RDdata_Source(
        .data0_i(aluresult),
        .data1_i(shifterresult),
		.data2_i(zerofilled),
        .select_i(FURslto),
        .data_o(datastore)
        );			

Data_Memory DM(.clk_i(clk_i), 
.addr_i(datastore), 
.data_i(read_data_2), 
.MemRead_i(MemRead), 
.MemWrite_i(MemWrite), 
.data_o(datamemoryo));

Mux2to1 #(.size(32)) writedtaselect(
                .data0_i(datastore),
                .data1_i(datamemoryo),
                .select_i(MemtoReg),
                .data_o(write_datapop)
                );   
Mux2to1 #(.size(32)) jal_write_data(
                .data0_i(write_datapop),
                 .data1_i(pc_in),
                  .select_i(instruction[31:26] ==  6'b100111),
                   .data_o(write_data));
                

endmodule




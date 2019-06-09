module Simple_Single_CPU( clk_i, rst_n );

//I/O port
input         clk_i;
input         rst_n;

//Internal Signles
wire [31:0] pc_in;
wire [31:0] pc_out, pc_next;
wire [31:0] instruction;
wire RegDst;
wire Branch;
wire [4:0] reg_write1; 
wire [31:0]write_data;
wire RegWrite;
wire[31:0]read_data_1;
wire[31:0]read_data_2;
wire[2:0] aluop;
wire alusrc;
wire[3:0]ALUoperation;
wire[1:0] FURslto;
wire[31:0]signextend,zerofilled;
wire [31:0] ALU_input,aluresult,shifterresult;
wire zero,overflow;
//modules
Program_Counter PC(
        .clk_i(clk_i),      
	    .rst_n(rst_n),     
	    .pc_in_i(pc_in) ,   
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

Mux2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instruction[20:16]),
        .data1_i(instruction[15:11]),
        .select_i(RegDst),
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
	    .RegWrite_o(RegWrite), //
	    .ALUOp_o(aluop),   
	    .ALUSrc_o(alusrc),   
	    .RegDst_o(RegDst)   
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
        .data_o(write_data)
        );			

//modules
//Program_Counter PC(
//        .clk_i(clk_i),      
//	    .rst_n(rst_n),     
//	    .pc_in_i() ,   
//	    .pc_out_o() 
//	    );
	
//Adder Adder1(
//        .src1_i(),     
//	    .src2_i(),
//	    .sum_o()    
//	    );
	
//Instr_Memory IM(
//        .pc_addr_i(),  
//	    .instr_o()    
//	    );

//Mux2to1 #(.size(5)) Mux_Write_Reg(
//        .data0_i(),
//        .data1_i(),
//        .select_i(),
//        .data_o()
//        );	
		
//Reg_File RF(
//        .clk_i(clk_i),      
//	    .rst_n(rst_n) ,     
//        .RSaddr_i() ,  
//        .RTaddr_i() ,  
//        .RDaddr_i() ,  
//        .RDdata_i()  , 
//        .RegWrite_i(),
//        .RSdata_o() ,  
//        .RTdata_o()   
//        );
	
//Decoder Decoder(
//        .instr_op_i(), 
//	    .RegWrite_o(), 
//	    .ALUOp_o(),   
//	    .ALUSrc_o(),   
//	    .RegDst_o()   
//		);

//ALU_Ctrl AC(
//        .funct_i(),   
//        .ALUOp_i(),   
//        .ALU_operation_o(),
//		.FURslt_o()
//        );
	
//Sign_Extend SE(
//        .data_i(),
//        .data_o()
//        );

//Zero_Filled ZF(
//        .data_i(),
//        .data_o()
//        );
		
//Mux2to1 #(.size(32)) ALU_src2Src(
//        .data0_i(),
//        .data1_i(),
//        .select_i(),
//        .data_o()
//        );	
		
//ALU ALU(
//		.aluSrc1(),
//	    .aluSrc2(),
//	    .ALU_operation_i(),
//		.result(),
//		.zero(),
//		.overflow()
//	    );
		
//Shifter shifter( 
//		.result(), 
//		.leftRight(),
//		.shamt(),
//		.sftSrc() 
//		);
		
//Mux3to1 #(.size(32)) RDdata_Source(
//        .data0_i(),
//        .data1_i(),
//		.data2_i(),
//        .select_i(),
//        .data_o()
//        );			

endmodule




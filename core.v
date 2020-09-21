`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:44:40 11/01/2019 
// Design Name: 
// Module Name:    core 
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
`include "define.v"

module core(
	input clk,
	input rst,
	input wire [3:0] gpi_in,
    output wire [3:0] gpo_out,
	output wire [31:0] wb_instr,
	input wire uart_rx,
	output wire uart_tx,
	output [31:0]wb_pc
	    );


	
	


wire [63:0] if_instr;

wire [31:0] ex_instr;
wire [31:0] mem_instr;
wire [31:0] id_instr_2;
wire [31:0] id_instr_1;


wire [4:0] dec_srcreg1_num_1;
wire [4:0] dec_srcreg2_num_1;
wire [4:0] dec_dstreg_num_1;
wire [31:0] dec_imm_1;
wire [5:0] dec_alucode_1;
wire [1:0] dec_aluop1_type_1;
wire [1:0] dec_aluop2_type_1;
wire dec_reg_we_1;
wire dec_is_load_1;
wire dec_is_store_1;

wire [4:0] dec_srcreg1_num_2;
wire [4:0] dec_srcreg2_num_2;
wire [4:0] dec_dstreg_num_2;
wire [31:0] dec_imm_2;
wire [5:0] dec_alucode_2;
wire [1:0] dec_aluop1_type_2;
wire [1:0] dec_aluop2_type_2;
wire dec_reg_we_2;
wire dec_is_load_2;
wire dec_is_store_2;


wire [31:0] dec_r0_val;
wire [31:0] dec_r1_val;
wire [31:0] dec_r2_val;
wire [31:0] dec_r3_val;

wire [31:0] r0_val;
wire [31:0] r1_val;


wire [31:0] pc;
wire [31:0] id_pc;
wire [31:0] ex_pc;
wire [31:0] mem_pc;

wire [31:0] ex_store_value;

wire [4:0] ex_srcreg1_num;
wire [4:0] ex_srcreg2_num;
wire [4:0] ex_dstreg_num;
wire [5:0] ex_alucode;
wire [31:0] ex_imm;
wire [1:0] ex_aluop1_type;
wire [1:0] ex_aluop2_type;
wire [4:0] mem_srcreg1_num;
wire [4:0] mem_srcreg2_num;
wire [4:0] mem_dstreg_num;
wire [5:0] mem_alucode;
wire [1:0] mem_aluop1_type;
wire [1:0] mem_aluop2_type;
wire ex_reg_we;
wire ex_is_load;
wire ex_is_store;
wire [31:0] ex_alu_result;
wire [31:0] mem_alu_result;
wire [31:0] mem_load_value;
wire ex_br_taken;
wire [31:0] wb_dstreg_value;
wire [4:0] wb_dstreg_num;
wire [31:0] reg_wb_dstreg_value;
wire [4:0] reg_wb_dstreg_num;


wire [6:0] dec_opcode_1;
wire [6:0] dec_opcode_2;
wire [6:0] ex_opcode;
wire [6:0] mem_opcode;
wire [6:0] opcode_1;
wire [6:0] opcode_2;
// gpio
wire [7:0] gpi_data_in;
wire [7:0] gpi_data_out;
wire [31:0] gpi_value;
wire gpo_we;
wire [7:0] gpo_data_in;
wire [7:0] gpo_data_out;
wire [31:0] gpo_value;
wire [31:0] hc_value;
// UART TX
    wire uart_we;
    wire [7:0] uart_data_in;
    wire uart_data_out;

    // UART RX
    wire uart_rd_en;
    wire [7:0] uart_rd_data;


  assign gpi_data_in = {4'd0, gpi_in};  
    assign gpo_data_in = ex_store_value[7:0];
    assign gpo_we = ((ex_alu_result == `GPO_ADDR) && ex_is_store) ? `ENABLE : `DISABLE;
    assign gpo_out = gpo_data_out[3:0];  
    assign gpi_value = {28'd0, gpi_data_out[3:0]};
    assign gpo_value = {28'd0, gpo_data_out[3:0]};


// UART
    assign uart_data_in = ex_store_value[7:0];
    assign uart_we = ((ex_alu_result == `UART_TX_ADDR) && ex_is_store) ? `ENABLE : `DISABLE;
    assign uart_tx = uart_data_out;

//forward 
wire [1:0] a_forward_1;
wire [1:0] b_forward_1;
wire [1:0] c_forward_1;
wire [1:0] a_forward_2;
wire [1:0] b_forward_2;
wire [1:0] c_forward_2;
//stall
wire stall_branch;
wire stall_raw_1;
wire stall_raw_2;


wire [6:0] opcode;

wire wb_reg_we;
wire reg_wb_reg_we;
reg [31:0]out1;
reg [31:0]out2;
reg [31:0]out3;
reg [31:0]out4;
wire out;


wire [31:0] ex_br_addr;
hardware_counter hardware_counter_0 (
        .clk(clk),
        .rst_n(rst),
        .hc_out(hc_value)
    );


    uart uart_0 (
        .clk(clk),
        .rst_n(rst),
        .wr_data(uart_data_in),
        .wr_en(uart_we),
        .uart_tx(uart_data_out)
    );

    uart_rx uart_rx_0 (
        .clk(clk),
        .rst_n(rst),
        .uart_rx(uart_rx),
        .rd_data(uart_rd_data),
        .rd_en(uart_rd_en)
    );
   
   gpi gpi_0 (
		.clk(clk),
		.rst_n(rst),
		.wr_data(gpi_data_in),
		.gpi_out(gpi_data_out)
    );

    gpo gpo_0 (
		.clk(clk),
		.rst_n(rst),
		.we(gpo_we),
		.wr_data(gpo_data_in),
		.gpo_out(gpo_data_out)
    );

assign reg_wb_reg_we=wb_reg_we;
assign reg_wb_dstreg_num=wb_dstreg_num;
assign reg_wb_dstreg_value=wb_dstreg_value;

wire [4:0] reg_dec_srcreg1_num_1;
wire [4:0] reg_dec_srcreg2_num_1;
wire [4:0] reg_dec_srcreg1_num_2;
wire [4:0] reg_dec_srcreg2_num_2;

assign reg_dec_srcreg1_num_1=dec_srcreg1_num_1;
assign reg_dec_srcreg2_num_1=dec_srcreg2_num_1;
assign reg_dec_srcreg1_num_2=dec_srcreg1_num_2;
assign reg_dec_srcreg2_num_2=dec_srcreg2_num_2;


riscv_regfile regf(
	.clk(clk),
	.we(reg_wb_reg_we),
    .rd0(reg_dec_srcreg1_num_1),
    .rd1(reg_dec_srcreg2_num_1),
	.rd2(reg_dec_srcreg1_num_2),
	.rd3(reg_dec_srcreg2_num_2),
    .dreg_num(reg_wb_dstreg_num),
    .dreg_val(reg_wb_dstreg_value),
    .r0_val(dec_r0_val),
    .r1_val(dec_r1_val),
	.r2_val(dec_r2_val),
	.r3_val(dec_r3_val)
);

fetch fetch(
        .clk(clk),
        .rst(rst),
		.stall_flow(stall_flow),
		.stall_raw(stall_raw),
		.ex_br_taken(ex_br_taken),
		.branch_pc(ex_br_addr),
		.instr(if_instr),
		.PC(pc)
    );
	

decode decode1(
		.clk(clk),
		.rst(rst),
		.if_instr(if_instr[63:32]),
		.pc(pc),
		//output
		.id_instr(id_instr_1),
        .dec_srcreg1_num(dec_srcreg1_num_1),
        .dec_srcreg2_num(dec_srcreg2_num_1),
        .dec_dstreg_num(dec_dstreg_num_1),
        .dec_imm(dec_imm_1),
        .dec_alucode(dec_alucode_1),
        .dec_aluop1_type(dec_aluop1_type_1),
        .dec_aluop2_type(dec_aluop2_type_1),
        .dec_reg_we(dec_reg_we_1),
        .dec_is_load(dec_is_load_1),
        .dec_is_store(dec_is_store_1),
		.id_pc(id_pc)	,
		.opcode(opcode_1),
		.dec_opcode(dec_opcode_1)
    );
	
	decode decode2(
		.clk(clk),
		.rst(rst),
		.if_instr(if_instr[31:0]),
		.pc(pc),
		//output
		.id_instr(id_instr_2),
        .dec_srcreg1_num(dec_srcreg1_num_2),
        .dec_srcreg2_num(dec_srcreg2_num_2),
        .dec_dstreg_num(dec_dstreg_num_2),
        .dec_imm(dec_imm_2),
        .dec_alucode(dec_alucode_2),
        .dec_aluop1_type(dec_aluop1_type_2),
        .dec_aluop2_type(dec_aluop2_type_2),
        .dec_reg_we(dec_reg_we_2),
        .dec_is_load(dec_is_load_2),
        .dec_is_store(dec_is_store_2),
		.id_pc(id_pc_2)	,
		.opcode(opcode_2),
		.dec_opcode(dec_opcode_2)

    );
	
	flow_control flow(
	.clk(clk),
	.rst(rst),
	//ID1 input 
	.id_instr1(id_instr_1),
	.dec_opcode_1(dec_opcode_1),
	.dec_srcreg1_num_1(dec_srcreg1_num_1),
    .dec_srcreg2_num_1(dec_srcreg2_num_1),
    .dec_dstreg_num_1(dec_dstreg_num_1),
    .dec_imm_1(dec_imm_1),
    .dec_alucode_1(dec_alucode_1),
    .dec_aluop1_type_1(dec_aluop1_type_1),
    .dec_aluop2_type_1(dec_aluop2_type_1),
	.out1(out1),
	.out2(out2),
    .dec_reg_we_1(dec_reg_we_1),
    .dec_is_load_1(dec_is_load_1),
    .dec_is_store_1(dec_is_store_1),
	
	//ID2 input 
	.id_instr2(id_instr_2),
	.dec_opcode_2(dec_opcode_2),
	.dec_srcreg1_num_2(dec_srcreg1_num_2),
    .dec_srcreg2_num_2(dec_srcreg2_num_2),
    .dec_dstreg_num_2(dec_dstreg_num_2),
    .dec_imm_2(dec_imm_2),
    .dec_alucode_2(dec_alucode_2),
    .dec_aluop1_type_2(dec_aluop1_type_2),
    .dec_aluop2_type_2(dec_aluop2_type_2),
	.out3(out3),
	.out4(out4),

    .dec_reg_we_2(dec_reg_we_2),
    .dec_is_load_2(dec_is_load_2),
    .dec_is_store_2(dec_is_store_2),
	//ex input
	.ex_br_taken(ex_br_taken),
	//MEM input 
    .mem_opcode(mem_opcode),
	.mem_br_taken(mem_br_taken),

	//output
	.ex_instr(ex_instr),
    .ex_opcode(ex_opcode),
	.ex_srcreg1_num(ex_srcreg1_num),
    .ex_srcreg2_num(ex_srcreg2_num),
    .ex_dstreg_num(ex_dstreg_num),
    .ex_imm(ex_imm),
    .ex_alucode(ex_alucode),
    .ex_aluop1_type(ex_aluop1_type),
    .ex_aluop2_type(ex_aluop2_type),
	.r0_val(r0_val),
	.r1_val(r1_val),
    .ex_reg_we(ex_reg_we),
    .ex_is_load(ex_is_load),
    .ex_is_store(ex_is_store),
	
    .stall(stall_flow)
	);
	
	
	/*	
assign	id_instr = out ? id_instr_2 : id_instr_1 ;
assign	dec_srcreg1_num= out  ? dec_srcreg1_num_2 : dec_srcreg1_num_1;
assign	dec_srcreg2_num = out ? dec_srcreg2_num_2 : dec_srcreg2_num_1;
assign	dec_dstreg_num= out ? dec_dstreg_num_2 : dec_dstreg_num_1;
assign	dec_imm= out  ? dec_imm_2 : dec_imm_1 ;
assign	dec_alucode= out  ? dec_alucode_2 : dec_alucode_1 ;
assign	dec_aluop1_type= out  ? dec_aluop1_type_2 : dec_aluop1_type_1;
assign	dec_aluop2_type= out  ? dec_aluop2_type_2 : dec_aluop2_type_1;
assign	dec_reg_we= out  ? dec_reg_we_2 : dec_reg_we_1;
assign	dec_is_load= out  ? dec_is_load_2 : dec_is_load_1;
assign	dec_is_store= out  ? dec_is_store_2 : dec_is_store_1;

assign dec_opcode= out  ? dec_opcode_2 : dec_opcode_1;

	
assign	id_instr = id_instr_1 ;
assign	dec_srcreg1_num= dec_srcreg1_num_1;
assign	dec_srcreg2_num =  dec_srcreg2_num_1;
assign	dec_dstreg_num=  dec_dstreg_num_1;
assign	dec_imm=  dec_imm_1 ;
assign	dec_alucode= dec_alucode_1 ;
assign	dec_aluop1_type= dec_aluop1_type_1;
assign	dec_aluop2_type= dec_aluop2_type_1;
assign	dec_reg_we= dec_reg_we_1;
assign	dec_is_load=  dec_is_load_1;
assign	dec_is_store= dec_is_store_1;

assign dec_opcode=  dec_opcode_1;
	*/	
	
exec exec(
        .clk(clk),
        .rst(rst),
	 //input
	    .id_pc(id_pc),
	    .ex_instr(ex_instr),
		.ex_r0_val(r0_val),
		.ex_r1_val(r1_val),
		.ex_imm(ex_imm),
		.ex_opcode(ex_opcode),
	    .ex_srcreg1_num(ex_srcreg1_num),
        .ex_srcreg2_num(ex_srcreg2_num),
        .ex_dstreg_num(ex_dstreg_num),
        .ex_alucode(ex_alucode),
        .ex_aluop1_type(ex_aluop1_type),
        .ex_aluop2_type(ex_aluop2_type),
        .ex_reg_we(ex_reg_we),
        .ex_is_load(ex_is_load),
        .ex_is_store(ex_is_store),
			//outputs
		.alu_result(ex_alu_result),
		.ex_store_value(ex_store_value),
		.br_taken(ex_br_taken),
		.ex_br_addr(ex_br_addr),
		.ex_PC(ex_pc)
    );

mem_access mem_access(.clk(clk),
		.rst(rst),
		.ex_instr(ex_instr),
		.ex_srcreg1_num(ex_srcreg1_num),
        .ex_srcreg2_num(ex_srcreg2_num),
        .ex_dstreg_num(ex_dstreg_num),
        .ex_alucode(ex_alucode),
        .ex_aluop1_type(ex_aluop1_type),
        .ex_aluop2_type(ex_aluop2_type),
        .ex_reg_we(ex_reg_we),
        .ex_is_load(ex_is_load),
        .ex_is_store(ex_is_store),
		.ex_PC(ex_pc),
		.ex_alu_result(ex_alu_result),
		.ex_store_value(ex_store_value),
		.gpi_value(gpi_value),
		.gpo_value(gpo_value),
		.uart_rd_data(uart_rd_data),
		.hc_value(hc_value),
		.ex_br_taken(ex_br_taken),
		.ex_opcode(ex_opcode),
		//outputs
		.mem_instr(mem_instr),
	    .mem_srcreg1_num(mem_srcreg1_num),
        .mem_srcreg2_num(mem_srcreg2_num),
        .mem_dstreg_num(mem_dstreg_num),
        .mem_alucode(mem_alucode),
        .mem_aluop1_type(mem_aluop1_type),
        .mem_aluop2_type(mem_aluop2_type),
        .mem_reg_we(mem_reg_we),
        .mem_is_store(mem_is_store),
		.mem_PC(mem_pc),
		.mem_alu_result(mem_alu_result),
		.mem_load_value(mem_load_value),
		.mem_is_load(mem_is_load),
		.mem_br_taken(mem_br_taken),
		.mem_opcode(mem_opcode)
		
		);
		
		
write_back write_back (
	.clk(clk),
	.rst(rst),
	.mem_instr(mem_instr),
	.mem_pc(mem_pc),
	.mem_dstreg_num(mem_dstreg_num),
	.mem_alucode(mem_alucode),
	.mem_alu_result(mem_alu_result),
	.mem_reg_we(mem_reg_we),
	.mem_is_load(mem_is_load),
	.mem_load_value(mem_load_value),
	.wb_instr(wb_instr),
	.wb_dstreg_num(wb_dstreg_num),
	.wb_dstreg_value(wb_dstreg_value),
	.wb_pc(wb_pc),
	.wb_reg_we(wb_reg_we)
	);
	

forward_unit forward (
	.dec_dstreg_num_1(dec_dstreg_num_1),
	.dec_srcreg1_num_1(dec_srcreg1_num_1),
	.dec_srcreg2_num_1(dec_srcreg2_num_1),
	.dec_alucode_1(dec_alucode_1),
	.dec_dstreg_num_2(dec_dstreg_num_2),
	.dec_srcreg1_num_2(dec_srcreg1_num_2),
	.dec_srcreg2_num_2(dec_srcreg2_num_2),
	.dec_alucode_2(dec_alucode_2),
	.ex_dstreg_num(ex_dstreg_num),
	.ex_srcreg1_num(ex_srcreg1_num),
	.ex_srcreg2_num(ex_srcreg2_num),
	.ex_alucode(ex_alucode),
	.mem_dstreg_num(mem_dstreg_num),
	.mem_srcreg1_num(mem_srcreg1_num),
	.mem_srcreg2_num(mem_srcreg2_num),
	.mem_alucode(mem_alucode),
	.wb_dstreg_num(wb_dstreg_num),
	.a_forward_1(a_forward_1),
	.b_forward_1(b_forward_1),
	.c_forward_1(c_forward_1),
	.a_forward_2(a_forward_2),
	.b_forward_2(b_forward_2),
	.c_forward_2(c_forward_2)
	);

	
	
stall_gen stall_gen(	
	.ex_dstreg_num(ex_dstreg_num),
	.dec_srcreg1_num_1(dec_srcreg1_num_1),
	.dec_srcreg2_num_1(dec_srcreg2_num_1),
	.dec_srcreg1_num_2(dec_srcreg1_num_2),
	.dec_srcreg2_num_2(dec_srcreg2_num_2),
	.ex_alucode(ex_alucode),
	.stall_raw_1(stall_raw_1),
	.stall_raw_2(stall_raw_2)
	);
	
	always @(*)  begin
	if (a_forward_1)begin
	case (a_forward_1)
         2'b01 : out1 <= ex_alu_result;
         2'b10 : out2 <= ex_alu_result;
         2'b11 : out1 <= ex_alu_result && out2 <= ex_alu_result;
      endcase
	
	end
	 if (b_forward_1 && (b_forward_1 !=a_forward_1))begin
	case (b_forward_1)
         2'b01 : out1 <= mem_is_load? mem_load_value : mem_alu_result;
         2'b10 : out2 <= mem_is_load ? mem_load_value : mem_alu_result;
         2'b11 : out1<= mem_is_load ? mem_load_value : mem_alu_result && out2 <= mem_is_load ? mem_load_value : mem_alu_result;
      endcase
	end
	 if (c_forward_1 && (c_forward_1 !=a_forward_1)&& (c_forward_1 !=b_forward_1))begin
	case (c_forward_1)
         2'b01 : out1 <= wb_dstreg_value;
         2'b10 : out2 <= wb_dstreg_value;
         2'b11 : out1<= wb_dstreg_value && out2 <= wb_dstreg_value;
      endcase
	end 
	if (a_forward_1==0 && b_forward_1==0 && c_forward_1==0 ) begin
	out1<= dec_r0_val;
	out2<= dec_r1_val;
	end
	end
	
	always @(*)  begin
	if (a_forward_2)begin
	case (a_forward_2)
         2'b01 : out3 <= ex_alu_result;
         2'b10 : out4 <= ex_alu_result;
         2'b11 : out3 <= ex_alu_result && out4 <= ex_alu_result;
      endcase
	
	end
	 if (b_forward_2  && (b_forward_2 !=a_forward_2))begin
	case (b_forward_2)
         2'b01 : out3 <= mem_is_load? mem_load_value : mem_alu_result;
         2'b10 : out4 <= mem_is_load ? mem_load_value : mem_alu_result;
         2'b11 : out3<= mem_is_load ? mem_load_value : mem_alu_result && out4 <= mem_is_load ? mem_load_value : mem_alu_result;
      endcase
	end
	 if (c_forward_2 && (c_forward_2 !=a_forward_2) && (c_forward_2 !=b_forward_2))begin
	case (c_forward_2)
         2'b01 : out3 <= wb_dstreg_value;
         2'b10 : out4 <= wb_dstreg_value;
         2'b11 : out3<= wb_dstreg_value && out4 <= wb_dstreg_value;
      endcase
	end 
	if (a_forward_2==0 && b_forward_2==0 && c_forward_2==0 )  begin
	out3<= dec_r2_val;
	out4<= dec_r3_val;
	end
	end
	
	
	
	
	
     
	
	
	
	
	
		endmodule

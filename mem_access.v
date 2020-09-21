`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:24:32 11/09/2019 
// Design Name: 
// Module Name:    mem_access 
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

module mem_access(
input clk,
input rst,
input [31:0]ex_instr,
input [4:0] ex_srcreg1_num,
input [4:0] ex_srcreg2_num,
input [4:0] ex_dstreg_num,
input [5:0]ex_alucode,
input [1:0]ex_aluop1_type,
input [1:0]ex_aluop2_type,
input ex_reg_we,
input ex_is_load,
input ex_is_store,
input [31:0]ex_PC,
input [31:0]ex_alu_result,
input [31:0] ex_store_value,
input [31:0]gpi_value,
input [31:0]gpo_value,
input [7:0] uart_rd_data,
input  [31:0] hc_value,
input ex_br_taken,
input [6:0] ex_opcode,

		//outputs
output reg 	[31:0]mem_instr,
output reg	[4:0]mem_srcreg1_num,
output reg  [4:0]mem_srcreg2_num,
output reg  [4:0]mem_dstreg_num,
output reg  [5:0]mem_alucode,
output reg  [1:0]mem_aluop1_type,
output reg  [1:0]mem_aluop2_type,
output reg      mem_reg_we,
output reg      mem_is_store,
output reg	[31:0]mem_PC,
output reg	[31:0]mem_alu_result,
output  [31:0] mem_load_value, 
output reg      mem_is_load,
output reg mem_br_taken,
output reg [6:0] mem_opcode
    );
	
	
	wire [31:0] mem_dmem_addr;
	reg [31:0]  mem_store_value;
    wire [3:0] dmem_we;
    wire [7:0] dmem_wr_data [3:0]; 
    wire [7:0] dmem_rd_data [3:0];
	wire[31:0] uart_value;
	   
	   assign uart_value = {24'd0, uart_rd_data};

always @(posedge clk)
begin
mem_instr<=ex_instr;
mem_srcreg1_num<=ex_srcreg1_num;
mem_srcreg2_num<=ex_srcreg2_num;
mem_dstreg_num<=ex_dstreg_num;
mem_alucode<=ex_alucode;
mem_aluop1_type<=ex_aluop1_type;
mem_aluop2_type<=ex_aluop2_type;
mem_reg_we<=ex_reg_we;
mem_is_load<=ex_is_load;
mem_is_store<=ex_is_store;
mem_PC<=ex_PC;
mem_alu_result<=ex_alu_result;

mem_store_value <=ex_store_value;

mem_br_taken<=ex_br_taken;
mem_opcode<=ex_opcode;
end

assign mem_dmem_addr = mem_alu_result ;

function [3:0] dmem_we_sel(
        input is_store,
        input [5:0] alucode,
        input [1:0] alu_result
    );
        
        begin
            if (is_store) begin
                case (alucode)
                    `ALU_SW: dmem_we_sel = 4'b1111;
                    `ALU_SH: begin
                        case (alu_result)
                            2'b00: dmem_we_sel = 4'b0011;
                            2'b01: dmem_we_sel = 4'b0110;
                            2'b10: dmem_we_sel = 4'b1100;
                            default: dmem_we_sel = 4'b0000;
                        endcase
                    end
                    `ALU_SB: begin
                        case (alu_result)
                            2'b00: dmem_we_sel = 4'b0001;
                            2'b01: dmem_we_sel = 4'b0010;
                            2'b10: dmem_we_sel = 4'b0100;
                            2'b11: dmem_we_sel = 4'b1000;
                        endcase
                    end                    
                    default: dmem_we_sel = 4'b0000;
                endcase
            end else begin
                dmem_we_sel = 4'b0000;
            end
        end
        
    endfunction
	
	
	function [31:0] dmem_wr_data_sel(
        input is_store,
        input [5:0] alucode,
        input [1:0] alu_result,
        input [31:0] store_value
    );
        
        begin
            if (is_store) begin
                case (alucode)
                    `ALU_SW: dmem_wr_data_sel = store_value;
                    `ALU_SH: begin
                        case (alu_result)
                            2'b00: dmem_wr_data_sel = {16'd0, store_value[15:0]};
                            2'b01: dmem_wr_data_sel = {8'd0, store_value[15:0], 8'd0};
                            2'b10: dmem_wr_data_sel = {store_value[15:0], 16'd0};
                            default: dmem_wr_data_sel = {16'd0, store_value[15:0]};
                        endcase
                    end
                    `ALU_SB: begin
                        case (alu_result)
                            2'b00: dmem_wr_data_sel = {24'd0, store_value[7:0]};
                            2'b01: dmem_wr_data_sel = {16'd0, store_value[7:0], 8'd0};
                            2'b10: dmem_wr_data_sel = {8'd0, store_value[7:0], 16'd0};
                            2'b11: dmem_wr_data_sel = {store_value[7:0], 24'd0};
                        endcase
                    end                    
                    default: dmem_wr_data_sel = store_value;
                endcase
            end else begin
                dmem_wr_data_sel = 32'd0;
            end
        end
        
    endfunction

	  // ?????????????????

    assign dmem_we = (mem_dmem_addr <= `DMEM_SIZE) ? dmem_we_sel(mem_is_store, mem_alucode, mem_alu_result[1:0]) : 4'd0;
    assign {dmem_wr_data[3], dmem_wr_data[2], dmem_wr_data[1], dmem_wr_data[0]} = dmem_wr_data_sel(mem_is_store, mem_alucode, mem_alu_result[1:0], mem_store_value);

dmem #(.byte_num(2'b00)) dmem_0 (
        .clk(clk),
        .we(dmem_we[0]),
        .addr(mem_dmem_addr),
        .wr_data(dmem_wr_data[0]),
        .rd_data(dmem_rd_data[0])
    );
    
    dmem #(.byte_num(2'b01)) dmem_1 (
        .clk(clk),
        .we(dmem_we[1]),
        .addr(mem_dmem_addr),
        .wr_data(dmem_wr_data[1]),
        .rd_data(dmem_rd_data[1])
    );
    
    dmem #(.byte_num(2'b10)) dmem_2 (
        .clk(clk),
        .we(dmem_we[2]),
        .addr(mem_dmem_addr),
        .wr_data(dmem_wr_data[2]),
        .rd_data(dmem_rd_data[2])
    );
    
    dmem #(.byte_num(2'b11)) dmem_3 (
        .clk(clk),
        .we(dmem_we[3]),
        .addr(mem_dmem_addr),
        .wr_data(dmem_wr_data[3]),
        .rd_data(dmem_rd_data[3])
    );	
	
	function [31:0] load_value_sel(
        input is_load,
        input [5:0] alucode,
        input [31:0] alu_result,
        input [7:0] dmem_rd_data_0, dmem_rd_data_1, dmem_rd_data_2, dmem_rd_data_3,
        input [31:0] gpi_value,
        input [31:0] gpo_value,
		 input [31:0] uart_value,
		 input [31:0] hc_value
		 
    );
        
        begin
            if (is_load) begin
                case (alucode)
                    `ALU_LW: begin
					 if (alu_result == `HARDWARE_COUNTER_ADDR) begin
                            load_value_sel = hc_value;
                        end else if (alu_result == `UART_RX_ADDR) begin
                            load_value_sel = uart_value;
                       end else if (alu_result == `GPI_ADDR) begin
                            load_value_sel = gpi_value;
                        end else if (alu_result == `GPO_ADDR) begin
                            load_value_sel = gpo_value;
                        end else begin
                            load_value_sel = {dmem_rd_data_3, dmem_rd_data_2, dmem_rd_data_1, dmem_rd_data_0};
                        end
                    end
                    `ALU_LH: begin
                        case (alu_result[1:0])
                            2'b00: load_value_sel = {{16{dmem_rd_data_1[7]}}, dmem_rd_data_1, dmem_rd_data_0};
                            2'b01: load_value_sel = {{16{dmem_rd_data_2[7]}}, dmem_rd_data_2, dmem_rd_data_1};
                            2'b10: load_value_sel = {{16{dmem_rd_data_3[7]}}, dmem_rd_data_3, dmem_rd_data_2};
                            default: load_value_sel = {{16{dmem_rd_data_1[7]}}, dmem_rd_data_1, dmem_rd_data_0};
                        endcase
                    end
                    `ALU_LB: begin
                        case (alu_result[1:0])
                            2'b00: load_value_sel = {{24{dmem_rd_data_0[7]}}, dmem_rd_data_0};
                            2'b01: load_value_sel = {{24{dmem_rd_data_1[7]}}, dmem_rd_data_1};
                            2'b10: load_value_sel = {{24{dmem_rd_data_2[7]}}, dmem_rd_data_2};
                            2'b11: load_value_sel = {{24{dmem_rd_data_3[7]}}, dmem_rd_data_3};
                        endcase
                    end
                    `ALU_LHU: begin
                        case (alu_result[1:0])
                            2'b00: load_value_sel = {16'd0, dmem_rd_data_1, dmem_rd_data_0};
                            2'b01: load_value_sel = {16'd0, dmem_rd_data_2, dmem_rd_data_1};
                            2'b10: load_value_sel = {16'd0, dmem_rd_data_3, dmem_rd_data_2};
                            default: load_value_sel = {16'd0, dmem_rd_data_1, dmem_rd_data_0};
                        endcase
                    end
                    `ALU_LBU: begin
                        case (alu_result[1:0])
                            2'b00: load_value_sel = {24'd0, dmem_rd_data_0};
                            2'b01: load_value_sel = {24'd0, dmem_rd_data_1};
                            2'b10: load_value_sel = {24'd0, dmem_rd_data_2};
                            2'b11: load_value_sel = {24'd0, dmem_rd_data_3};
                        endcase
                    end 
                    default: load_value_sel = {dmem_rd_data_3, dmem_rd_data_2, dmem_rd_data_1, dmem_rd_data_0};
                endcase
            end else begin
                load_value_sel = 32'd0;
            end
        end
        
    endfunction

    assign mem_load_value = load_value_sel(mem_is_load, mem_alucode, mem_alu_result, dmem_rd_data[0],
                                          dmem_rd_data[1], dmem_rd_data[2], dmem_rd_data[3],  gpi_value, gpo_value,uart_value , hc_value);
	
	
	
	
	
	
	
	
	
endmodule

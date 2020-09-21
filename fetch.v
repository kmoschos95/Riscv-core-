`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:48:11 10/31/2019 
// Design Name: 
// Module Name:    fetch 
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
module fetch(
	input wire clk,
	input wire rst,
	input wire stall_flow,
	input wire stall_raw,
	input wire ex_br_taken,
	input [31:0] branch_pc,
	output [63:0]instr,
	output reg [31:0] PC
    );


wire [63:0] dout;
wire [31:0] addr; 
wire [31:0] next_pc;
assign instr=rst? 0 : dout;
assign clk_o=clk;


always @(posedge clk ) begin
        if (rst) begin
            PC <= 32'd0;
        end 
		else begin
            
				PC <= stall_flow ? PC : ex_br_taken ? branch_pc: PC+8;
        end
    end
assign addr = PC>>3;

i_Memory imem(
	.clk(clk),
	
	.addr(addr),
	.dout(dout)
	);
	

endmodule

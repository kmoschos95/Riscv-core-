`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:25:59 11/15/2019 
// Design Name: 
// Module Name:    gpi 
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
module gpi (
    input wire clk,
    input wire rst_n,
    input wire [7:0] wr_data,
    output reg [7:0] gpi_out
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
	        gpi_out <= 8'b00000000;
        end else begin
	        gpi_out <= wr_data;
        end
    end

endmodule 
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:27:09 11/15/2019 
// Design Name: 
// Module Name:    gpo 
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
module gpo (
    input wire clk,
    input wire rst_n,
    input wire we,
    input wire [7:0] wr_data,
    output reg [7:0] gpo_out
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
	        gpo_out <= 8'b00000000;
        end else begin
            if (we) begin
	            gpo_out <= wr_data;
            end
        end
    end

endmodule


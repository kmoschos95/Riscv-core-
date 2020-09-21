`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:05:34 11/22/2019 
// Design Name: 
// Module Name:    harware_counter 
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
module hardware_counter (
    input wire clk,
    input wire rst_n,
    output wire [31:0] hc_out
);

    reg [31:0] cycles;

    assign hc_out = cycles;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cycles <= 32'd0;
        end else begin
            cycles <= cycles + 1;
        end
    end

endmodule 
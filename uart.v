`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:33:30 11/22/2019 
// Design Name: 
// Module Name:    uart 
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
`include "define.vh"

module uart (
   input wire clk,
   input wire rst_n,
   input wire [7:0] wr_data,
   input wire wr_en,
   output reg uart_tx
);

    // UART??????????
    wire uart_clk;
    reg [28:0] val;
    wire [28:0] next_val;
    wire [28:0] delta;

    // ?????????
    reg [3:0] bit_count;
    reg [8:0] shift_reg;
    wire en_seq;
  
    // ?????????UART????????
    assign delta = val[28] ? (`BAUD_RATE) : (`BAUD_RATE - `SYSCLK_FREQ);  
    assign next_val = val + delta;
    
    assign uart_clk = ~val[28];  // 1????????????????UART?????
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            val <= 29'b0;
        end else begin
            val <= next_val;
        end
    end

    // ???????
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_count <= 4'd0;
        end else begin
            if (wr_en && (!en_seq)) begin
                bit_count <= 4'd11;  // ???? 1bit + ??? 8bit + ???? 2bit ? ?? 11bit
            end else if (uart_clk && en_seq) begin
                bit_count <= bit_count - 4'd1;
            end
        end
    end

    assign en_seq = (bit_count != 4'd0);  // ?????0????????

    // ???????
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 9'd0;
        end else begin
            if (wr_en && (!en_seq)) begin
                shift_reg <= {wr_data[7:0], 1'd0};  // ??????????????????
            end else if (uart_clk && en_seq) begin
                shift_reg <= {1'd1, shift_reg[8:1]};
            end
        end
    end

    // ?????
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            uart_tx <= 1'b1;
        end else begin
            if (uart_clk && en_seq) begin
                uart_tx <= shift_reg[0];
            end
        end
    end

endmodule 
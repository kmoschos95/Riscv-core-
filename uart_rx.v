`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:35:00 11/22/2019 
// Design Name: 
// Module Name:    uart_rx 
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
//
// uart_rx
//


`include "define.vh"

module uart_rx(
    input wire clk,
    input wire rst_n,
    input wire uart_rx,
    output reg [7:0] rd_data,
    output reg rd_en
);

    // UART??????????
    wire uart_clk;
    reg [28:0] val;
    wire [28:0] next_val;
    wire [28:0] delta;

    // ??????????????
    reg [2:0] edge_shift_reg;

    // ??????
    wire rd_begin;

    // ?????????????
    reg [3:0] bit_count;
    wire en_seq;

    // SerDes????????
    reg [10:0] shift_reg;

    // ????????????
    reg reception;
    wire data_valid;


    // ?????????UART????????
    assign delta = val[28] ? (`BAUD_RATE) : (`BAUD_RATE - `SYSCLK_FREQ);  
    assign next_val = val + delta;
    
    assign uart_clk = ~val[28];  // 1????????????????UART?????
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            val <= 29'b0;
        end else if (rd_begin) begin
            val <= -`SYSCLK_FREQ_HALF;  // ????????????????????
        end else if (en_seq) begin
            val <= next_val;
        end else begin
            val <= 29'b0;
        end
    end

    // ???????(???????)??
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            edge_shift_reg[2:0] <= 3'd0;
        end else begin
            edge_shift_reg[2:0] <= {edge_shift_reg[1:0], uart_rx};
        end
    end

    assign rd_begin = ((edge_shift_reg[2:1] == 2'b10) && (en_seq == 1'b0));

    // ???????
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_count <= 4'd0;
        end else begin
            if (rd_begin && (!en_seq)) begin
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
            shift_reg <= 11'd0;  // 1??
        end else if (uart_clk && en_seq) begin
            shift_reg <= {edge_shift_reg[2], shift_reg[10:1]};  // ??????????????
        end
    end

    // ??????
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reception <= 1'b0;
        end else if (uart_clk && en_seq) begin
            if (bit_count == 4'd1) begin
                reception <= 1'b1;
            end else begin
                reception <= 1'b0;
            end
        end
    end

    assign data_valid = ((shift_reg[0] == 1'b0) && (shift_reg[10:9] == 2'b11));  // ????/???????????

    // ?????
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_data <= 8'd0;
        end else if (reception && data_valid) begin
            rd_data <= shift_reg[8:1];  // ????????????????????????????
        end else begin     
            rd_data <= rd_data;
        end
    end

    // ????????
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_en <= 1'b0;
        end else if (reception && data_valid) begin
            rd_en <= 1'b1;  // ?????????????????????????
        end else begin
            rd_en <= 1'b0;        
        end
    end

endmodule
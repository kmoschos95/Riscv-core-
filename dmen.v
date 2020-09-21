`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:02:38 11/07/2019 
// Design Name: 
// Module Name:    dmen 
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

module dmem #(parameter byte_num = 2'b00) (
    input wire clk,
    input wire we,
    input wire [31:0] addr,
    input wire [7:0] wr_data,
    output wire [7:0] rd_data
);

    reg [7:0] mem [0:16383];  // 64KiB(16bit??????)
    reg [13:0] addr_sync;  // 64KiB????????14bit????(??2bit??????????)
    
    initial begin
        case (byte_num)
            2'b00: $readmemh({`MEM_DATA_PATH, "data0.hex"}, mem);
            2'b01: $readmemh({`MEM_DATA_PATH, "data1.hex"}, mem);
            2'b10: $readmemh({`MEM_DATA_PATH, "data2.hex"}, mem);
            2'b11: $readmemh({`MEM_DATA_PATH, "data3.hex"}, mem);
        endcase
    end      
   
    always @(posedge clk) begin
        if (we) mem[addr[15:2]] <= wr_data;  // ??????????????????????BRAM?
        addr_sync <= addr[15:2];  // ???????????????????????BRAM?
    end

    assign rd_data = mem[addr_sync];

endmodule
endmodule

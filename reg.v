module riscv_regfile
(
    // Inputs
    input clk,
	input wire  we,
    input wire [4:0]  rd0,
    input wire [4:0]  rd1,
	input wire [4:0] rd2,
    input wire [4:0] rd3,
    input wire [4:0] dreg_num,
    input wire [31:0] dreg_val,
    output wire[ 31:0]  r0_val,
    output wire [ 31:0]  r1_val,
	output wire[ 31:0]  r2_val,
	output wire[ 31:0]  r3_val
);
 reg [31:0] regfile [0:31]; 
 integer i;
 initial  begin
		for(i = 0; i < 32; i=i+1) begin 
			regfile[i] <= 32'h0;
			end
			end
always @(posedge clk)
	begin
        if (we) regfile[dreg_num] <= dreg_val;
    end
	
    assign r0_val = (rd0 == 5'd0) ? 32'd0 : regfile[rd0];
	assign r1_val = (rd1 == 5'd0) ? 32'd0 : regfile[rd1];
	assign r2_val = (rd2 == 5'd0) ? 32'd0 : regfile[rd2];
	assign r3_val = (rd3 == 5'd0) ? 32'd0 : regfile[rd3];

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:28:58 11/24/2019 
// Design Name: 
// Module Name:    forward_unit 
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
module forward_unit(
input [4:0]dec_dstreg_num_1,
input [4:0]dec_srcreg1_num_1,
input [4:0]dec_srcreg2_num_1,
input [5:0]dec_alucode_1,
input [4:0]dec_dstreg_num_2,
input [4:0]dec_srcreg1_num_2,
input [4:0]dec_srcreg2_num_2,
input [5:0]dec_alucode_2,
input [4:0]ex_dstreg_num,
input [4:0]ex_srcreg1_num,
input [4:0]ex_srcreg2_num,
input [5:0]ex_alucode,
input [4:0]mem_dstreg_num,
input [4:0]mem_srcreg1_num,
input [4:0]mem_srcreg2_num,
input [5:0]mem_alucode,
input [4:0]wb_dstreg_num,
output reg [1:0] a_forward_1,
output reg  [1:0] b_forward_1,
output reg [1:0] c_forward_1,
output reg [1:0] a_forward_2,
output reg  [1:0] b_forward_2,
output reg [1:0] c_forward_2
    );
	
	//ID1
	 always @(*) begin 
	 //ex
		 if ( dec_srcreg1_num_1==ex_dstreg_num && dec_srcreg2_num_1 !=ex_dstreg_num && ex_dstreg_num!=0) begin
		 a_forward_1=1;
		 end
		 if ( dec_srcreg2_num_1==ex_dstreg_num && dec_srcreg1_num_1!=ex_dstreg_num && ex_dstreg_num!=0) begin
		 a_forward_1=2;
		 end
		  if ( dec_srcreg2_num_1==ex_dstreg_num && dec_srcreg1_num_1 == ex_dstreg_num && ex_dstreg_num!=0) begin
		 a_forward_1=3;
		 end
		 if ( (dec_srcreg2_num_1 != ex_dstreg_num && dec_srcreg1_num_1 !=ex_dstreg_num )|| ex_dstreg_num==0 ) begin
		 a_forward_1=0;
		 end 
	//mem
		 if ( dec_srcreg1_num_1==mem_dstreg_num && dec_srcreg2_num_1 !=mem_dstreg_num && mem_dstreg_num!=0 ) begin
		 b_forward_1=1;
		 end
		 if ( dec_srcreg2_num_1==mem_dstreg_num && dec_srcreg1_num_1!=mem_dstreg_num && mem_dstreg_num!=0) begin
		 b_forward_1=2;
		 end
		 if ( dec_srcreg2_num_1==mem_dstreg_num && dec_srcreg1_num_1 == mem_dstreg_num && mem_dstreg_num!=0) begin
		 b_forward_1=3;
		 end
		 if  ((dec_srcreg2_num_1 != mem_dstreg_num && dec_srcreg1_num_1 !=mem_dstreg_num )|| mem_dstreg_num==0) begin
		 b_forward_1=0;
		 end
	//WB
		  if ( dec_srcreg1_num_1==wb_dstreg_num && dec_srcreg2_num_1 !=wb_dstreg_num && wb_dstreg_num!=0 ) begin
		 c_forward_1=1;
		 end
		 if ( dec_srcreg2_num_1==wb_dstreg_num && dec_srcreg1_num_1!=wb_dstreg_num && wb_dstreg_num!=0) begin
		 c_forward_1=2;
		 end
		 if ( dec_srcreg2_num_1==wb_dstreg_num && dec_srcreg1_num_1 == wb_dstreg_num && wb_dstreg_num!=0) begin
		 c_forward_1=3;
		 end
		 if  ((dec_srcreg2_num_1 != wb_dstreg_num && dec_srcreg1_num_1 !=wb_dstreg_num )|| wb_dstreg_num==0) begin
		 c_forward_1=0;
		 end
		 
		
	 end
	 
	 
	 //ID2
	 always @(*) begin 
	 //ex
		 if ( dec_srcreg1_num_2==ex_dstreg_num && dec_srcreg2_num_2 !=ex_dstreg_num && ex_dstreg_num!=0) begin
		 a_forward_2=1;
		 end
		 if ( dec_srcreg2_num_2==ex_dstreg_num && dec_srcreg1_num_2!=ex_dstreg_num && ex_dstreg_num!=0) begin
		 a_forward_2=2;
		 end
		  if ( dec_srcreg2_num_2==ex_dstreg_num && dec_srcreg1_num_2 == ex_dstreg_num && ex_dstreg_num!=0) begin
		 a_forward_2=3;
		 end
		 if ( (dec_srcreg2_num_2 != ex_dstreg_num && dec_srcreg1_num_2 !=ex_dstreg_num )|| ex_dstreg_num==0 ) begin
		 a_forward_2=0;
		 end 
	//mem
		 if ( dec_srcreg1_num_2==mem_dstreg_num && dec_srcreg2_num_2 !=mem_dstreg_num && mem_dstreg_num!=0 ) begin
		 b_forward_2=1;
		 end
		 if ( dec_srcreg2_num_2==mem_dstreg_num && dec_srcreg1_num_2!=mem_dstreg_num && mem_dstreg_num!=0) begin
		 b_forward_2=2;
		 end
		 if ( dec_srcreg2_num_2==mem_dstreg_num && dec_srcreg1_num_2 == mem_dstreg_num && mem_dstreg_num!=0) begin
		 b_forward_2=3;
		 end
		 if  ((dec_srcreg2_num_2 != mem_dstreg_num && dec_srcreg1_num_2 !=mem_dstreg_num )|| mem_dstreg_num==0) begin
		 b_forward_2=0;
		 end
	//WB
		  if ( dec_srcreg1_num_2==wb_dstreg_num && dec_srcreg2_num_2 !=wb_dstreg_num && wb_dstreg_num!=0 ) begin
		 c_forward_2=1;
		 end
		 if ( dec_srcreg2_num_2==wb_dstreg_num && dec_srcreg1_num_2!=wb_dstreg_num && wb_dstreg_num!=0) begin
		 c_forward_2=2;
		 end
		 if ( dec_srcreg2_num_2==wb_dstreg_num && dec_srcreg1_num_2 == wb_dstreg_num && wb_dstreg_num!=0) begin
		 c_forward_2=3;
		 end
		 if  ((dec_srcreg2_num_2 != wb_dstreg_num && dec_srcreg1_num_2 !=wb_dstreg_num )|| wb_dstreg_num==0) begin
		 c_forward_2=0;
		 end
		 
		
	 end
	 
	 

endmodule

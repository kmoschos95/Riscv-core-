`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:33:42 11/02/2019 
// Design Name: 
// Module Name:    tb 
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

`timescale 1ns/1ps
`define clock_period 10

module tb;
integer   i;
reg       clock, reset;    // Clock and reset signals
wire [3:0] gpo_out;
wire [31:0] wb_instr;
reg [31:0] gpi_in;
reg uart_rx;
wire uart_tx;
// Instantiate CPU
core core0(.clk(clock), .rst(reset),.gpi_in(gpi_in),.gpo_out(gpo_out),.wb_instr(wb_instr),.uart_rx(uart_rx),.uart_tx(uart_tx));

// Initialization and signal generation
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

initial  
  begin 
   clock = 1'b0;       
   reset = 1'b1; 
gpi_in=1; 
uart_rx=1;  // Apply reset for a few cycles
   #(3.75*`clock_period) reset = 1'b0;
  end
     
always 
   #(`clock_period / 2) clock = ~clock;  // Clock generation 


//initial begin  // Ta statements apo ayto to begin mexri to "end" einai seiriaka

  // Initialize Register File with "random" numbers
//  for (i = 0; i < 32; i = i+1)
  //  core0.decode.regf.regfile[i] = i;   // Note that R0 = 0 in MIPS 

  // Initialize Data Memory 
  //$readmemh("program.hex", core0.fetch.imem.data);

  // Edw, to "memory.hex" einai ena arxeio pou prepei na brisketai sto 
  // directory pou trexete th Verilog kai na einai ths morfhs:
  
  // @0    00000000
  // @4    20100009
  // @8    00000000
  // @C    00000000
  // ...
  
  // H aristerh sthlh, meta to @, exei th dieythynsh ths mnhmhs (hex),
  // kai h deksia sthlh ta dedomena sth dieythynsh ayth (pali hex).
  // Sto paradeigma pio panw, oi lekseis stis dieythynseis 0, 8 kai 12
  // einai 0, kai sth dieythynsh 4 exei thn timh 32'h20100009. An o PC
  // diabasei thn dieythynsh 4, h timh ekei exei thn entolh
  //   addi $16 <- $0 + 9

  // To deytero orisma ths $readmemh einai pou akribws brisketai h mnhmh
  // pou tha arxikopoihthei. Sto paradeigma, to "dat0" einai to onoma pou
  // dwsame sto instance tou datapath. To "mem" einai to onoma pou exei
  // to instance ths mnhmhs MESA sto datapath, kai to "data" einai to 
  // onoma pou exei to pragmatiko array ths mhnhs mesa sto module ths.
  // An exete dwsei diaforetika onomata, allakste thn $readmemh.

  // Enallaktika, an sas boleyei perissotero, yparxei h entolh $readmemb
  // me thn akribws idia syntaksh. H aristerh sthlh tou arxeiou exei
  // thn idia morfh (dieythynseis se hex), alla h deksia sthlh exei
  // ta dedomena sto dyadiko. Etsi h add mporouse na einai:

  // @4    00100000000100000000000000001001

  // ... h kai akoma kalytera:
  
  // @4    001000_00000_10000_0000000000001001

  // (h Verilog epitrepei diaxwristika underscores).


  // Termatismos ekteleshs:
  // $finish;

//end 

endmodule

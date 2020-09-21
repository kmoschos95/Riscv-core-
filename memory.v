module i_Memory (
  input wire clk,
  input wire  [31:0] addr,
  output wire [63:0] dout


   );
   
  reg [63:0] data[0:16];
initial begin
  $readmemh("program.hex", data);
end
     assign dout = data[addr[9:0]];

endmodule 
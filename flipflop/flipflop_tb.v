// Testbench Code Goes here
module flipflop_tb;

reg clock;
reg [2:0]d;
wire [2:0]q;

initial begin
  $dumpfile("flipflop.vcd");
  $dumpvars(0, flipflop_tb);
  $monitor ("%g\t   clock = %b     d = %b      q = %b", 
    $time, clock, d, q);
  clock = 0;
  d = 3'b101;
  #3 d = 3'b110;
  #5 $finish;
end

// Clock generator
always begin
  #2 clock = ~clock; // Toggle clock every 5 ticks
end

flipflop U0 (
d,
q, 
clock
);

endmodule
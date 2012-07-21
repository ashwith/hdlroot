module bytegen();
  reg [63:0] randseed;

  task get_byte(output [7:0] data);
    data = $random;
  endtask
endmodule

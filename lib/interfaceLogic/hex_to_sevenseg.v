module hex_to_sevenseg(
  input [3:0] IN,
  output [7:0] OUT
);

  reg [7:0] out_reg;

  always @ (IN) begin
    case(IN)
      4'h0: out_reg = 8'b01000000;
      4'h1: out_reg = 8'b01111001;
      4'h2: out_reg = 8'b00100100;
      4'h3: out_reg = 8'b00110000;
      4'h4: out_reg = 8'b00011001;
      4'h5: out_reg = 8'b00010010;
      4'h6: out_reg = 8'b00000010;
      4'h7: out_reg = 8'b01111000;
      4'h8: out_reg = 8'b00000000;
      4'h9: out_reg = 8'b00010000;
      4'ha: out_reg = 8'b10001000;
      4'hb: out_reg = 8'b10000000;
      4'hc: out_reg = 8'b11000110;
      4'hd: out_reg = 8'b11000000;
      4'he: out_reg = 8'b10000110;
      4'hf: out_reg = 8'b10001110;
    default: out_reg = 8'b11111111;
    endcase
  end
  
  assign OUT = out_reg;

endmodule

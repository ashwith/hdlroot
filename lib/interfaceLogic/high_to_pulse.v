`timescale 1ns / 1ps

module high_to_pulse(
  input CLK,
  input IN,
  output OUT
);
    
    reg toggle_en;
    reg out_reg;
    
    always @(posedge CLK) begin
      if(IN == 1'b1 & out_reg == 1'b0) begin
        out_reg <= 1'b1 & toggle_en;
        toggle_en <= 1'b0;
      end
      else if(IN == 1'b0) begin
        toggle_en <= 1'b1;
      end
      else begin
        out_reg <= 1'b0;
      end
    end
    
    assign OUT = out_reg;

endmodule

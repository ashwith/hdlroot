`timescale 1ns / 1ps

module debounce(
  input CLK,
  input IN,
  output OUT
);
    
    (*S="TRUE"*) reg [15:0] cntr;
    reg out_val;
    reg out_reg;
    
    //Counter logic
    always @ (posedge CLK) begin
      if(out_val != IN) begin
        if(cntr == 16'hff) begin
          cntr <= 0;
        end
        else begin
          cntr <= cntr + 1'b1;
        end
      end
      else begin
        cntr <= 0;
      end
    end
    
    always @(posedge CLK) begin
      if(cntr == 16'hff) begin
        out_val <= ~out_val;
      end
    end

    assign OUT = out_val;

endmodule

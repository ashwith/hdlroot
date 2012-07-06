`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Programmed By: Ashwith Jerome Rego
// Pin Description:
//            CLKIN : Input clock. Must be 100MHz
//            RST   : Active high module reset.
//            BAUD  : Baud rate select. The following are the valid values.
//                    Any other values for BAUD will default to the 9600 baud 
//                    clock.
//                    +-----+-------------+
//                    |BAUD |clock rate   |
//                    +-----+-------------+
//                    |4'h0 |   300 bauds |
//                    |4'h1 |   600 bauds |
//                    |4'h2 |  1200 bauds |
//                    |4'h3 |  2400 bauds |
//                    |4'h4 |  4800 bauds |
//                    |4'h5 |  9600 bauds |
//                    |4'h6 | 19200 bauds |
//                    |4'h7 | 38400 bauds |
//                    |4'h8 | 57600 bauds |
//                    |4'h9 |115200 bauds |
//                    +-----+-------------+
//            CLKOUT: divided output clock.
//////////////////////////////////////////////////////////////////////////////////
module clk_div(
    input CLKIN,
    input RST,
    input [3:0] BAUD,
    output CLKOUT
    );
    
    //Counter roll over values for different baud rates.
    parameter B300    = 19'b1010001011000010100;
    parameter B600    = 19'b0101000101100001010;
    parameter B1200   = 19'b0010100010110000100;
    parameter B2400   = 19'b0001010001011000010;
    parameter B4800   = 19'b0000101000101100000;
    parameter B9600   = 19'b0000010100010110000;
    parameter B19200  = 19'b0000001010001010111;
    parameter B38400  = 19'b0000000101000101011;
    parameter B57600  = 19'b0000000011011000111;
    parameter B115200 = 19'b0000000001101100011; 
     

    //clock divider counter;
    reg [19:0] clk_cntr;

    //roll over value.
    reg [19:0] baud_rate;


    //output clock register
    reg out_clk;
    

    //Set roll over value if module is resetted or baud is changed.
    always @ (BAUD, RST) begin
      if(RST == 1'b1) begin
        baud_rate <= B9600;
      end
      else begin
        case(BAUD)
          4'h0    : baud_rate <= B300;
          4'h1    : baud_rate <= B600;
          4'h2    : baud_rate <= B1200;
          4'h3    : baud_rate <= B2400;
          4'h4    : baud_rate <= B4800;
          4'h5    : baud_rate <= B9600;
          4'h6    : baud_rate <= B19200;
          4'h7    : baud_rate <= B38400;
          4'h8    : baud_rate <= B57600;
          4'h9    : baud_rate <= B115200;
          default : baud_rate <= B9600;
        endcase   
      end
    end


    //clock divider
    always @ (posedge CLKIN) begin
      if(RST == 1'b1) begin
        clk_cntr <= 0;
        out_clk <= 0;
      end
      else if(clk_cntr == baud_rate) begin
        clk_cntr <= 0;
        out_clk <= ~out_clk;
      end
      else begin
        clk_cntr <= clk_cntr + 1'b1;
      end
    end

   assign CLKOUT = out_clk; 
    
    

endmodule

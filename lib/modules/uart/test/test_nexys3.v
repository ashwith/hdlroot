`timescale 1ns / 1ps

module uart_test(

  input clk,
  input rst,
  input [7:0] sw,
  input rx,
  input write,
  input read,
  input speed_up,
  input speed_down,
  output tx,
  output rdy,
  output full,
  output [7:0]seg,
  output [3:0] an
  );

  
  reg [3:0] baud;
  wire up, down, reset;
  wire up_pulse, down_pulse;
  wire write_pulse, read_pulse;
  
  always @ (posedge clk) begin
    if(reset == 1'b1) begin
      baud <= 4'h5;
    end
    else if(up_pulse == 1'b1) begin
      if (baud < 4'h9) begin
        baud <= baud + 1'b1;
      end
      else begin
        baud <= baud;
      end
    end
    else if(down_pulse == 1'b1) begin
      if(baud > 4'h0) begin
        baud <= baud - 1'b1;
      end
      else begin
        baud <= baud;
      end
    end
    else begin
      baud <= baud;
    end
  end
	
  
  high_to_pulse htp_up(
                        .CLK(clk),
                        .IN(up),
                        .OUT(up_pulse)
                      );
                      
  high_to_pulse htp_down(
                          .CLK(clk),
                          .IN(down),
                          .OUT(down_pulse)
                         );
                         
  high_to_pulse htp_write(
                          .CLK(clk),
                          .IN(write),
                          .OUT(write_pulse)
                         );
  high_to_pulse htp_read(
                          .CLK(clk),
                          .IN(read),
                          .OUT(read_pulse)
                         );
  
	uart_ctrl uart(
                  .CLK(clk),
                  .RST(reset),
                  .EN(1'b1),
                  .BAUD(baud),
                  .TXEN(1'b1),
                  .RXEN(1'b1),
                  .TX(tx),
                  .RX(rx),
                  .WRITE(write_pulse),
                  .WRDATA(sw),
                  .ISFULL(full),
                  .READ(read_pulse),
                  .RDDATA(seg),
                  .DATARDY(rdy)
                );

  
  debounce debounce_speed_up(
                            .CLK(clk),
                            .IN(speed_up),
                            .OUT(up)
                            );
                            
  debounce debounce_speed_down(
                            .CLK(clk),
                            .IN(speed_down),
                            .OUT(down)
                            );
  
  debounce debounce_reset(
                          .CLK(clk),
                          .IN(rst),
                          .OUT(reset)
                          );
                          
  
                             
endmodule


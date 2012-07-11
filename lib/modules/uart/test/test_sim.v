`timescale 1ns / 1ps

module test_sim();

  reg clk;
  reg rst;
  reg [3:0] baud;
  reg tx_en;
  reg rx_en;
  wire tx;
  reg rx;
  reg write;
  reg [7:0] wrdata;
  wire full;
  reg read;
  reg rddata;
  wire rdy;

  parameter PERIOD = 5;  
  
  uart_ctrl uart(
                  .CLK(clk),
                  .RST(rst),
                  .EN(1'b1),
                  .BAUD(baud),
                  .TXEN(1'b1),
                  .RXEN(1'b1),
                  .TX(tx),
                  .RX(rx),
                  .WRITE(write_pulse),
                  .WRDATA(data),
                  .ISFULL(full),
                  .READ(read),
                  .RDDATA(rddata),
                  .DATARDY(rdy)
                );

  initial begin
    clk = 0;
  end

  forever begin
    #PERIOD clk = ~clk;
  end

  task pause(input integer n);
    repeat(n) @(posedge clk);
  endtask

  task reset();
    rst = 1'b1;
    pause(1);
    rst = 1'b0;
  endtask

endmodule


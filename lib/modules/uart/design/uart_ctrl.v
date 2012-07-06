`timescale 1ns / 1ps

module uart_ctrl(
    input CLK,
    input RST,
    input EN,
    input [3:0] BAUD,
    input TXEN,
    input RXEN,
    output TX,
    input RX,
    input WRITE,
    input [7:0] WRDATA,
    output ISFULL,
    input READ,
    output [7:0] RDDATA,
    output DATARDY
    );
    
    wire uart_clk;
    wire uart_tx_read;
    wire uart_tx_data;
    reg uart_tx_empty;
    wire uart_tx_datardy;
    
    clk_div clk_div_inst(
      .CLKIN(CLK),
      .RST(RST),
      .BAUD(BAUD),
      .CLKOUT(uart_clk)
    );

    assign TX = uart_clk;
    
   
    circular_buff buff_tx(
      .CLK(CLK),
      .RST(RST),
      .WRITE(WRITE),
      .WRDATA(WRDATA),
      .READ(uart_tx_read),
      .RDDATA(uart_tx_data),
      .ISFULL(ISFULL),
      .ISEMPTY(uart_tx_empty)
    );
    assign uart_tx_datardy = ~uart_tx_empty;
    
    circular_buff buff_rx(
      .CLK(CLK),
      .RST(RST),
      .WRITE(uart_rx_write),
      .WRDATA(uart_rx_data),
      .READ(READ),
      .RDDATA(RDDATA),
      .ISFULL(uart_rx_full),
      .ISEMPTY(uart_rx_empty)
    );
    
    uart_tx tx(
      .CLK(uart_clk),
      .RST(RST),
      .DATA(uart_tx_data),
      .DATARDY(uart_tx_datardy),
      .READ(uart_tx_read),
      .TX(TX)
    );
    
    uart_rx rx(
      .CLK(uart_clk),
      .RST(RST),
      .RX(RX),
      .ISFULL(uart_rx_full),
      .WRITE(uart_rx_write),
      .DATA(uart_rx_data)
    );

endmodule

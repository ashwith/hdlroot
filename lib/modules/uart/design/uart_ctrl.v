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
    wire [7:0] uart_tx_data;
    wire uart_tx_datardy;
    wire uart_tx_empty;

    wire uart_rx_write;
    wire [7:0] uart_rx_data;
    wire uart_rx_full;
    wire uart_rx_empty;
    
    wire tx_en;
    wire rx_en;
    
    
    clk_div clk_div_inst(
      .CLKIN(CLK),
      .RST(RST),
      .BAUD(BAUD),
      .CLKOUT(uart_clk)
    );
   
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
    
    assign DATARDY = ~uart_rx_empty;
    uart_tx tx(
      .CLK(uart_clk),
      .RST(RST),
      .EN(tx_en),
      .DATA(uart_tx_data),
      .DATARDY(uart_tx_datardy),
      .READ(uart_tx_read),
      .TX(TX)
    );
    
    uart_rx rx(
      .CLK(uart_clk),
      .RST(RST),
      .EN(rx_en),
      .RX(RX),
      .ISFULL(uart_rx_full),
      .WRITE(uart_rx_write),
      .DATA(uart_rx_data)
    );
    
    assign tx_en = EN ? TXEN ? 1'b1 : 1'b0 : 1'b0;
    assign rx_en = EN ? RXEN ? 1'b1 : 1'b0 : 1'b0;
endmodule

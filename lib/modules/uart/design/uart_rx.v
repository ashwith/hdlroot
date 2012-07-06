`timescale 1ns / 1ps

module uart_rx(
  input                       CLK,
  input                       RST,
  input                       EN,
  input                       RX,
  input                       ISFULL,
  output                      WRITE,
  output  [DATAWIDTH - 1 : 0] DATA
);

  parameter DATAWIDTH = 8;
  parameter IDLE      = 4'h0;
  parameter START     = 4'h1;
  parameter BIT_RX    = 4'h2;
  parameter STOP      = 4'h3;

  reg                     write_reg;
  reg [DATAWIDTH - 1 : 0] data_reg;
  reg [1:0]               curr_state;
  reg [1:0]               next_state;
  reg [2:0]               bit_cnt;

  always @ (posedge CLK) begin
    if(RST == 1) begin
      curr_state  <=  IDLE;
      next_state  <=  IDLE;
      write_reg   <=  1'h0;
      data_reg    <=  8'h0;
      bit_cnt     <=  3'h0;
    end
    else begin
      case(curr_state)
        IDLE: begin
          write_reg <= 1'b0;
          bit_cnt <= 3'h0;
          if((EN == 1'b1) && (RX == 1'b0) && (ISFULL == 1'b0)) begin
            next_state <= BIT_RX;
          end
          else begin
            next_state <= IDLE;
          end
        end
        BIT_RX: begin
          data_reg[bit_cnt] <= RX;
          write_reg <= 'b0;

          if(bit_cnt == 3'h7) begin
            bit_cnt <= 8'h0;
            next_state <= STOP;
          end
          else begin
            bit_cnt <= bit_cnt + 1'b1;
          end
        end
        STOP: begin
          write_reg <= 1'b1;
          bit_cnt <= 3'h0;
          if(RX <= 1'b1) begin
            next_state <= IDLE;
          end
          else begin
            next_state <= BIT_RX;
          end
        end
        default: begin
          bit_cnt <= 3'h0;
          next_state <= IDLE;
          data_reg <= data_reg;
          write_reg <= 1'b0;
        end
      endcase
      curr_state <= next_state;
    end
  end

  assign DATA = data_reg;
  assign WRITE = write_reg;

endmodule

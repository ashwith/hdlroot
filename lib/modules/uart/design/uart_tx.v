`timescale 1ns / 1ps

module uart_tx(
  input                       CLK,
  input                       RST,
  input   [DATAWIDTH - 1 : 0] DATA,
  input                       DATARDY,
  output                      READ,
  output                      TX
);

  parameter DATAWIDTH = 8;
  parameter IDLE      = 4'h0;
  parameter START     = 4'h1;
  parameter BIT_TX    = 4'h2;
  parameter STOP      = 4'h3;

  reg       read_reg;
  reg       tx_reg;
  reg [1:0] curr_state;
  reg [1:0] next_state;
  reg [2:0] bit_cnt;

  always @ (posedge CLK) begin
    if(RST == 1) begin
      tx_reg <= 1;
      next_state <= IDLE;
      curr_state <= IDLE;
      bit_cnt <= 3'h0;
    end
    else begin
      case(curr_state)
        IDLE: begin
          tx_reg <= 1'b1;
          if(DATARDY == 1'b1) begin
            read_reg <= 1;
            next_state <= START;
          end
          else begin
            read_reg <= 0;
            next_state <= IDLE;
          end
        end
        START: begin
          tx_reg <= 1'b0;
          read_reg <= 1'b0;
          next_state <= BIT_TX;
        end
        BIT_TX: begin
          tx_reg <= DATA[bit_cnt];
          if(bit_cnt == 3'h7) begin
            bit_cnt <= 3'h0;
            next_state <= STOP;
          end
          else begin
            bit_cnt <= bit_cnt + 1'b1;
            next_state <= BIT_TX;
          end
        end
        STOP: begin
          tx_reg = 1'b1;
          if(DATARDY == 1'b1) begin
            read_reg <= 1'b1;
            next_state <= START;
          end
          else begin
            next_state <= IDLE;
          end
        end
        default: begin
          tx_reg <= 1'b1;
          next_state <= IDLE;
        end
      endcase
      curr_state <= next_state;
    end
  end


  assign READ = read_reg;
  assign TX = tx_reg;

endmodule

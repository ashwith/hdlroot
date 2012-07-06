`timescale 1ns / 1ps

module circular_buff(
  input                       CLK,
  input                       RST,
  input                       WRITE,
  input   [DATAWIDTH - 1 : 0] WRDATA,
  input                       READ,
  output  [DATAWIDTH - 1 : 0] RDDATA,
  output                      ISFULL,
  output                      ISEMPTY
);

  parameter DATAWIDTH = 8;
  parameter BUFFSIZE  = 8;
  parameter PTRSIZE   = 3;
  
  //Number of elements in the buffer.
  reg [PTRSIZE : 0] buff_count;

  reg [PTRSIZE - 1 : 0] wrptr;
  reg [PTRSIZE - 1 : 0] rdptr;

  wire [PTRSIZE - 1 : 0] wraddr;
  wire [PTRSIZE - 1 : 0] rdaddr;
  reg wren;

  memory mem(
              .CLK(CLK),
              .WREN(wren),
              .WRADDR(wraddr),
              .WRDATA(WRDATA),
              .RDADDR(rdaddr),
              .RDDATA(RDDATA)
            );

  always @ (posedge CLK) begin
    if(RST == 1'b1) begin
      wrptr <= 0;
      rdptr <= 0;
      buff_count <= 0;
      wren <= 0;
    end
    else begin
      case({READ,WRITE})
        01: begin
          if(buff_count < BUFFSIZE) begin
            wren <= 1;
            wrptr <= wrptr + 1;
            buff_count <= buff_count + 1;
          end
          else begin
            wren <= 0;
            wrptr <= wrptr;
            buff_count <= buff_count;
          end
        end
        10: begin
          wren <= 0;
          if(buff_count > 0) begin
            rdptr <= rdptr + 1;
            buff_count <= buff_count - 1;
          end
          else begin
            rdptr <= rdptr;
            buff_count <= buff_count;
          end
        end
        11: begin
          if((buff_count > 0) && (buff_count < BUFFSIZE)) begin
            wren <= 1;
            wrptr <= wrptr + 1;
            rdptr <= rdptr + 1;
            buff_count <= buff_count;
          end
          else if(buff_count == 0) begin
            wren <= 1;
            wrptr <= wrptr + 1;
            buff_count <= buff_count + 1;
          end
          else if(buff_count == BUFFSIZE) begin
            wren <= 1;
            wrptr <= wrptr + 1;
            rdptr <= rdptr + 1;
            buff_count <= buff_count;
          end
          else begin
            wren <= wren;
            wrptr <= wrptr;
            rdptr <= rdptr;
            buff_count <= buff_count;
          end
        end
        default: begin
          wren <= wren;
          wrptr <= wrptr;
          rdptr <= rdptr;
          buff_count <= buff_count;
        end
      endcase
    end
  end

  assign ISEMPTY = (buff_count == 'b0) ? 1'b1 : 1'b0;
  assign ISFULL = (buff_count == BUFFSIZE) ? 1'b1 : 1'b0;

endmodule

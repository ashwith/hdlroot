`timescale 1ns / 1ps

module memory (
  input                       CLK,
  input                       WREN,
  input   [ADDRWIDTH - 1 : 0] WRADDR,
  input   [DATAWIDTH - 1 : 0] WRDATA,
  input   [ADDRWIDTH - 1 : 0] RDADDR,
  output  [DATAWIDTH - 1 : 0] RDDATA                
);

  parameter DATAWIDTH = 8;
  parameter ADDRWIDTH = 3;
  parameter MEMSIZE   = 8;
  
  reg [DATAWIDTH - 1 : 0] mem [MEMSIZE - 1 : 0];
  reg [DATAWIDTH - 1 : 0] rddata_reg;

  always @ (posedge CLK) begin
    if(WREN == 1'b1) begin
      mem[WRADDR] <= WRDATA;
    end
    else begin
      mem[WRADDR] <= mem[WRADDR];
    end
  end

  always @ (posedge CLK) begin
    rddata_reg <= mem[RDADDR];
  end

  assign RDDATA = rddata_reg;

endmodule

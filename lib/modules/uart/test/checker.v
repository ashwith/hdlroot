module checker (input clk);
  
  parameter DATASIZE = 8;
  parameter BUFFSIZE = 1024;
  parameter ADDRSIZE = 10;
  parameter STRRSIZE = 8*50;

  parameter NOTFULL = 0;
  parameter FULL = 1;
  parameter ALMOSTFULL = 2;
  parameter FILLINGUP = 3;

  reg [DATASIZE : 0] got [BUFFSIZE - 1 : 0];
  reg [DATASIZE : 0] exp [BUFFSIZE - 1 : 0];
  
  integer nGot;
  integer nExp;

  reg [ADDRSIZE - 1 : 0] gotRdPtr;
  reg [ADDRSIZE - 1 : 0] gotWrPtr;
  reg [ADDRSIZE - 1 : 0] expRdPtr;
  reg [ADDRSIZE - 1 : 0] expWrPtr;

  reg[STRRSIZE : 1] name;

  task new(input reg[STRRSIZE : 1] inName);
    begin
      name      = inName;
      nGot      = 0;
      nExp      = 0;
      gotRdPtr  = 0;
      gotWrPtr  = 0;
      expRdPtr  = 0;
      expWrPtr  = 0;
    end
  endtask

  function [1:0] addGot(input reg [DATASIZE - 1 : 0] data);
    if(nGot == 1024) begin
      addGot = FULL;
    end
    else if(nGot == 1023) begin
      addGot = ALMOSTFULL;
    end
    else if (nGot == 1014) begin
      addGot = FILLINGUP;
    end
    else begin
      got[nGot] = data;
      nGot = nGot + 1;
      gotWrPtr = gotWrPtr + 1;
      addGot = NOTFULL;
    end
  endfunction

  function [1:0] addExp(input reg [DATASIZE - 1 : 0] data);
    if(nExp == 1024) begin
      addExp = FULL;
    end
    else if(nExp == 1023) begin
      addExp = ALMOSTFULL;
    end
    else if (nExp == 1014) begin
      addExp = FILLINGUP;
    end
    else begin
      exp[nExp] = data;
      nExp = nExp + 1;
      expWrPtr = expWrPtr + 1;
      addExp = NOTFULL;
    end
  endfunction

  task checkAll;
    integer i;

    begin
      if(nGot !== nExp) begin
        $write("ERROR: %0s: Count Mismatch Got %0d bytes. Expected $0d\n", name, nGot, nExp);
      end
      else begin
        for(i = 0; i < nGot; i = 0) begin
          if(got[i] !== exp[i]) begin
            $write("ERROR: %0s: Byte mismatch at index: %0d Got: %0h Expected: %0h", name, i, got[i], exp[i]);
          end
        end
        nGot = 0;
        nExp = 0;
        gotRdPtr = 0;
        gotWrPtr = 0;
        expRdPtr = 0;
        expWrPtr = 0;
      end
    end
  endtask


  task check;
    while(1) begin
      if(nGot > 0 && nExp > 0) begin
      
      end
    end
  endtask

endmodule

package FIFO_transaction_pkg;

  // Declare FIFO width parameter
  parameter int FIFO_WIDTH = 16;

  class FIFO_transaction;
    parameter FIFO_WIDTH = 16;
    rand logic [FIFO_WIDTH-1:0] data_in;
    rand logic  rst_n, wr_en, rd_en;
    logic clk;
    logic [FIFO_WIDTH-1:0] data_out;
    logic wr_ack, overflow;
    logic full, empty, almostfull, almostempty, underflow;
    integer RD_EN_ON_DIST ,  WR_EN_ON_DIST  ;
    function new(int rd_dst = 30 , wr_dst = 70 );
        this.RD_EN_ON_DIST=rd_dst;
        this.WR_EN_ON_DIST=wr_dst;
    endfunction //new()
    constraint rando{
        rst_n dist {1:=90,0:=10};
        wr_en dist {1:=(WR_EN_ON_DIST),0:=(100-WR_EN_ON_DIST)};
        rd_en dist {1:=(RD_EN_ON_DIST),0:=(100-RD_EN_ON_DIST)};
    }
endclass //
endpackage
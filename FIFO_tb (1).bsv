// Import necessary packages
import FIFO_transaction_pkg::*;
import FIFO_scoreboard_pkg::*;
import FIFO_coverage_pkg::*;
import shared_pkg::*;
 // Correct import statement

module FIFO_tb(fifo_if.TB ic);

  FIFO_transaction tr1=new();
  FIFO_scoreboard tr2=new();
  initial begin 
     ic.rst_n=0;
     ic.data_in=0;
     ic.wr_en=0;
     ic.rd_en=0;
     repeat(2)
     @ (negedge ic.clk);
     ic.rst_n=1;
     tr1.rand_mode(0);
     tr1.data_in.rand_mode(1);
     tr1.constraint_mode(0);
     repeat(5000) begin
         ic.wr_en=1;
         ic.rd_en=0;
         repeat(9) begin
             assert (tr1.randomize);
             ic.data_in=tr1.data_in;
             @(negedge ic.clk);
         end
         ic.wr_en=0;
         ic.rd_en=1;
         repeat(9) begin
             @(negedge ic.clk);
         end
     end
     tr1.rand_mode(0);
     tr1.rand_mode(1);
     tr1.constraint_mode(1);
     repeat (5000) begin
         assert (tr1.randomize);
         ic.wr_en=tr1.wr_en;
         ic.rd_en=tr1.rd_en;
         ic.data_in=tr1.data_in;
         ic.rst_n=tr1.rst_n;
         @(negedge ic.clk);
     end
     tr2.test_finished=1;
 end
endmodule
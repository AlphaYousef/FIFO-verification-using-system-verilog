module top ();
  bit clk;
  initial begin
      forever begin
          #10;
          clk=!clk;
      end
  end
  fifo_if fifo_if(clk);
  FIFO_corrected DUT (fifo_if);
  FIFO_tb TB(fifo_if);
  FIFO_monitor MONITOR (fifo_if);
endmodule
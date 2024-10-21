
    import FIFO_transaction_pkg::*;  // Import the transaction package
    import FIFO_coverage_pkg::*;     // Import coverage package
    import FIFO_scoreboard_pkg::*;   // Import scoreboard package

    // Declare a class for the monitor
    module FIFO_monitor(fifo_if.MONITOR ic);

        FIFO_transaction tr;         // Transaction object
        FIFO_coverage fifo_cvg;      // Coverage instance
        FIFO_scoreboard fifo_sb;     // Scoreboard instance  // Declare interface as virtual to use within the class

         always @(*) begin
        tr.rst_n=ic.rst_n;
            tr.data_in=ic.data_in;
            tr.wr_en=ic.wr_en;
            tr.rd_en=ic.rd_en;
            tr.data_out=ic.data_out;
            tr.full=ic.full;
            tr.almostfull=ic.almostfull;
            tr.empty=ic.empty;
            tr.almostempty=ic.almostempty;
            tr.wr_ack=ic.wr_ack;
            tr.overflow=ic.overflow;
            tr.underflow=ic.underflow;
    end
    initial begin
        tr=new();
        fifo_sb=new();
        fifo_cvg=new();
        forever begin
            @(negedge ic.clk);
            fork
                //sample
                begin
                   fifo_cvg.sample_data(tr); 
                end
                begin
                    fifo_sb.check_data(tr);
                end
            join
            if (fifo_sb.test_finished) begin
                $display("error_count=%0d ,  right_count=%0d",fifo_sb.error_count,fifo_sb.right_count);
                $stop;
            end
        end
    end
endmodule
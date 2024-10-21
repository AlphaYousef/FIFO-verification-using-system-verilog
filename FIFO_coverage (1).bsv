package FIFO_coverage_pkg;
   import FIFO_transaction_pkg::*;
   FIFO_transaction f_cvg_txn=new();
   class FIFO_coverage;

      
      covergroup cvr_status;
         rd_enable: coverpoint f_cvg_txn.rd_en iff(f_cvg_txn.rst_n);
         wr_enable: coverpoint f_cvg_txn.wr_en iff(f_cvg_txn.rst_n);
         overflow_w: coverpoint f_cvg_txn.overflow iff(f_cvg_txn.rst_n);
         underflow_w: coverpoint f_cvg_txn.underflow iff(f_cvg_txn.rst_n);
         wr_acknowledge: coverpoint f_cvg_txn.wr_ack iff(f_cvg_txn.rst_n);
         full_l: coverpoint f_cvg_txn.full iff(f_cvg_txn.rst_n);
         almostfull_l: coverpoint f_cvg_txn.almostfull iff(f_cvg_txn.rst_n);
         empty_y: coverpoint f_cvg_txn.empty iff(f_cvg_txn.rst_n);
         almostempty_y: coverpoint f_cvg_txn.almostempty iff(f_cvg_txn.rst_n);
         rd_enable_with_empty:cross rd_enable,empty_y;
            rd_enable_with_almostempty:cross rd_enable,almostempty_y;
            rd_enable_with_underflow : cross rd_enable,underflow_w {
                option.cross_auto_bin_max=0;
                bins rd_on_under_off = binsof(rd_enable) intersect {1} && binsof(underflow_w) intersect {0};
                bins rd_off_under_off = binsof(rd_enable) intersect {0} && binsof(underflow_w) intersect {0};
                bins rd_on_under_on = binsof(rd_enable) intersect {1} && binsof(underflow_w) intersect {1};
            }
            wr_enable_with_full : cross wr_enable,full_l;
            wr_enable_with_almostfull : cross wr_enable,almostfull_l;
            wr_enable_with_overflow : cross wr_enable,overflow_w{
                option.cross_auto_bin_max=0;
                bins wr_on_over_off = binsof(wr_enable) intersect {1} && binsof(overflow_w) intersect {0};
                bins wr_off_over_off = binsof(wr_enable) intersect {0} && binsof(overflow_w) intersect {0};
                bins wr_on_over_on = binsof(wr_enable) intersect {1} && binsof(overflow_w) intersect {1};
            }
            wr_enable_with_wr_acknowledge : cross wr_enable,wr_acknowledge{
                option.cross_auto_bin_max=0;
                bins wr_on_wr_acknowledge_off = binsof(wr_enable) intersect {1} && binsof(wr_acknowledge) intersect {0};
                bins wr_off_wr_acknowledge_off = binsof(wr_enable) intersect {0} && binsof(wr_acknowledge) intersect {0};
                bins wr_on_wr_acknowledge_on = binsof(wr_enable) intersect {1} && binsof(wr_acknowledge) intersect {1};
            }
        endgroup

        function new();
            cvr_status=new();
        endfunction 

        function void sample_data(FIFO_transaction f_txn);
            f_cvg_txn=f_txn;
            cvr_status.sample();
        endfunction
        
    endclass 
    
endpackage
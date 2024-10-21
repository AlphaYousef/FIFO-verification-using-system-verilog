package FIFO_scoreboard_pkg;
   import FIFO_transaction_pkg::*;

   class FIFO_scoreboard;
     parameter FIFO_WIDTH = 16;
     logic [FIFO_WIDTH-1:0] data_out_ref;
     logic wr_ack_ref, overflow_ref;
     logic full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;
     static integer error_count=0 , right_count=0 , size ;
     logic [FIFO_WIDTH-1:0] data_mem [$] ;
     static bit test_finished;
     bit next_write,next_read;
     task check_data (FIFO_transaction trans1);
         reference_model(trans1);
         if (!trans1.rst_n) begin
             if (trans1.wr_ack!=wr_ack_ref || trans1.overflow!=overflow_ref || trans1.full != full_ref || trans1.empty != empty_ref || trans1.almostfull != almostfull_ref || trans1.almostempty != almostempty_ref) begin
             error_count=error_count+1;
             $display("error at reset");
             if (trans1.wr_ack!=wr_ack_ref) begin
             $display("wr_ack=%0b , wr_ack_ref=%0b at %0t",trans1.wr_ack,wr_ack_ref,$time);    
             end
             if (trans1.overflow!=overflow_ref) begin
               $display("overflow=%0b , overflow_ref=%0b at %0t",trans1.overflow,overflow_ref,$time);    
             end
             if (trans1.full!=full_ref) begin
             $display("full=%0b , full_ref=%0b at %0t",trans1.full,full_ref,$time);    
             end
             if (trans1.empty!=empty_ref) begin
             $display("empty=%0b , empty_ref=%0b at %0t",trans1.empty,empty_ref,$time);    
             end
             if (trans1.almostfull!=almostfull_ref) begin
             $display("full=%0b , full=%0b at %0t",trans1.full,full_ref,$time);    
             end
             if (trans1.almostempty!=almostempty_ref) begin
             $display("almostempty=%0b , almostempty_ref=%0b at %0t",trans1.almostempty,almostempty_ref,$time);    
             end
         end
         else begin
             right_count = right_count+1;
         end
         end
         else begin
             if (trans1.wr_ack!=wr_ack_ref || trans1.overflow!=overflow_ref || trans1.data_out!=data_out_ref || trans1.full != full_ref || trans1.empty != empty_ref || trans1.almostfull != almostfull_ref || trans1.almostempty != almostempty_ref) begin
             error_count=error_count+1;
             $display("error at no reset");
             if (trans1.wr_ack!=wr_ack_ref) begin
             $display("wr_ack=%0b , wr_ack_ref=%0b , size=%0d at %0t",trans1.wr_ack,wr_ack_ref,data_mem.size(),$time);    
             end
             if (trans1.overflow!=overflow_ref) begin
             $display("overflow=%0b , overflow_ref=%0b at %0t",trans1.overflow,overflow_ref,$time);    
             end
             if (trans1.data_out!=data_out_ref) begin
             $display("dataout=%0d , dataout_ref=%0d, size=%0d at %0t",trans1.data_out,data_out_ref,data_mem.size(),$time);    
             end
             if (trans1.full!=full_ref) begin
             $display("full=%0b , full_ref=%0b at %0t",trans1.full,full_ref,$time);    
             end
             if (trans1.empty!=empty_ref) begin
             $display("empty=%0b , empty_ref=%0b , size=%0d at %0t",trans1.empty,empty_ref,data_mem.size(),$time);    
             end
             if (trans1.almostfull!=almostfull_ref) begin
             $display("almostfull=%0b , almostfull_ref=%0b at %0t",trans1.almostfull,almostfull_ref,$time);    
             end
             if (trans1.almostempty!=almostempty_ref) begin
             $display("almostempty=%0b , almostempty_ref=%0b , size=%0d at %0t",trans1.almostempty,almostempty_ref,data_mem.size(),$time);    
             end
         end
         else begin
             right_count = right_count+1;
         end
         end
     endtask

     task reference_model(FIFO_transaction trans2);
     if (!trans2.rst_n) begin
         full_ref=0;
         almostfull_ref=0;
         empty_ref=1;
         almostempty_ref=0;
         overflow_ref=0;
         underflow_ref=0;
         data_mem.delete();
         wr_ack_ref=0;
         next_read=0;
         next_write=0;
     end
     else
     begin
         size=data_mem.size();
         // read
         if (trans2.rd_en && size>0) begin
             data_out_ref=data_mem.pop_front();
         end

          if (trans2.wr_en && size<8) begin
             data_mem.push_back(trans2.data_in);
             wr_ack_ref=1;
         end
         else
         begin
             wr_ack_ref=0;
         end
         if(trans2.wr_en&&next_write)
         begin
             overflow_ref=1;
         end
         else begin
             overflow_ref=0;
         end
         if(trans2.rd_en&&next_read)
         begin
            underflow_ref=1;
          end
         else begin
             underflow_ref=0;
         end
         if (data_mem.size==7) begin
             almostfull_ref=1;
         end
         else begin
             almostfull_ref=0;
         end
         if (data_mem.size==8) begin
             full_ref=1;
             next_write=1;
         end
         else begin
             full_ref=0;
             next_write=0;
         end
         if (data_mem.size==0) begin
             empty_ref=1;
             next_read=1;
         end
         else begin
             empty_ref=0;
             next_read=0;
         end
         if (data_mem.size==1) begin
             almostempty_ref=1;
         end
         else begin
             almostempty_ref=0;
         end
     end   
     endtask
  endclass //
  endpackage
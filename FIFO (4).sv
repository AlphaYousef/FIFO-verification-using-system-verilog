////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO_corrected(fifo_if.DUT ic);
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8; 
localparam max_fifo_addr = $clog2(FIFO_DEPTH);
reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];
reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge ic.clk or negedge ic.rst_n) begin
	if (!ic.rst_n) begin
		wr_ptr <= 0;
		//
		ic.overflow <= 0;
		ic.wr_ack <= 0;
	end
	else if (ic.wr_en && count < FIFO_DEPTH) begin
		mem[wr_ptr] <= ic.data_in;
		ic.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
		//
		ic.overflow <= 0;
	end
	else begin 
		ic.wr_ack <= 0; 
		if (ic.full && ic.wr_en) begin
			ic.overflow <= 1;
		end
			
		else begin
			ic.overflow <= 0;
		end
			
	end
end

always @(posedge ic.clk or negedge ic.rst_n) begin
	if (!ic.rst_n) begin
		rd_ptr <= 0;
		//
		ic.underflow <= 0;
	end
	else if (ic.rd_en && count != 0) begin
		ic.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
		//
		ic.underflow <= 0;
	end
	//
	else begin 
		if (ic.empty && ic.rd_en) begin
			ic.underflow <= 1;
		end
			
		else begin
			ic.underflow <= 0;
		end
			
	end
end

always @(posedge ic.clk or negedge ic.rst_n) begin
	if (!ic.rst_n) begin
		count <= 0;
	end
	else begin
		//
		if (({ic.wr_en, ic.rd_en} == 2'b11)) begin
			if (ic.full) begin
				count<=count-1;
			end
			if (ic.empty) begin
				count<=count+1;
			end
		end
		else begin
			if	( ({ic.wr_en, ic.rd_en} == 2'b10) && !ic.full) 
			count <= count + 1;
		else if ( ({ic.wr_en, ic.rd_en} == 2'b01) && !ic.empty)//
			count <= count - 1;
		end
	end
end
//

assign ic.full = (count == FIFO_DEPTH)? 1 : 0;
assign ic.empty = (count == 0)? 1 : 0;
assign ic.almostfull = (count == FIFO_DEPTH-1)? 1 : 0; //
assign ic.almostempty = (count == 1)? 1 : 0;
///////////////////////////////////////////////////////
`ifdef assertion
always_comb begin : blockName
	if (!ic.rst_n) begin
		RESET:assert final(count==3'b0 && !ic.full && ic.empty && !ic.almostempty && !ic.almostfull && !rd_ptr && !wr_ptr && !ic.overflow && !ic.underflow );
	end
end
WR_ACK : assert property (@(posedge ic.clk) disable iff(!ic.rst_n) ic.wr_en==1'b1 && !ic.full |=> ic.wr_ack==1);
full : assert property (@(posedge ic.clk) disable iff(!ic.rst_n) (count)==FIFO_DEPTH |-> ic.full==1'b1);
empty : assert property (@(posedge ic.clk) disable iff(!ic.rst_n) (count)==3'b0 |-> ic.empty==1'b1);
almostfull : assert property (@(posedge ic.clk) disable iff(!ic.rst_n) (count)==FIFO_DEPTH-1'b1 |-> ic.almostfull==1'b1);
almostempty : assert property (@(posedge ic.clk) disable iff(!ic.rst_n) (count)==3'b1 |-> ic.almostempty==1);
COUNTER_UP : assert property (@(posedge ic.clk) disable iff(!ic.rst_n) ic.wr_en==1'b1 && ic.rd_en==1'b0 && !ic.full |=> count==$past(count)+1'b1);
COUNTER_DOWN : assert property (@(posedge ic.clk) disable iff(!ic.rst_n) ic.wr_en==1'b0 && ic.rd_en==1'b1 && !ic.empty |=> count==$past(count)-1'b1);
COUNTER_FULL : assert property (@(posedge ic.clk) disable iff(!ic.rst_n) ic.wr_en==1'b1 && ic.rd_en==1'b1 && ic.full |=> count==$past(count)-1'b1);
COUNTER_EMPTY : assert property (@(posedge ic.clk) disable iff(!ic.rst_n) ic.wr_en==1'b1 && ic.rd_en==1'b1 && ic.empty |=> count==$past(count)+1'b1);
OVERFLOW : assert property (@(posedge ic.clk) disable iff(!ic.rst_n) ic.wr_en==1'b1 && ic.full |=> ic.overflow==1);
UNDERFLOW : assert property (@(posedge ic.clk) disable iff(!ic.rst_n) ic.rd_en==1'b1 && ic.empty |=> ic.underflow==1);
RD_POINTER : assert property (@(posedge ic.clk) disable iff(!ic.rst_n) ic.rd_en==1'b1 && count != 1'b0 |=> rd_ptr==$past(rd_ptr)+1'b1);
WR_POINTER : assert property (@(posedge ic.clk) disable iff(!ic.rst_n) ic.wr_en==1'b1 && count < FIFO_DEPTH |=> wr_ptr==$past(wr_ptr)+1'b1);
`endif 
endmodule

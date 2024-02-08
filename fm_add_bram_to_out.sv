`timescale 1ps/1ps
module fm_add_bram_to_out #(
    parameter BRAM_DATA_WIDTH = 64 * 4,
    parameter BRAM_DEPTH = 64,
    parameter BRAM_ADDR_WIDTH = clog2(BRAM_DEPTH),
    parameter MAX = 5
)
(
    input clk,
    input rst,
    input init_calib_complete,
    
    input module_en,
    output module_done,

    input [BRAM_ADDR_WIDTH - 1 : 0] bram_begin_addr,
    input rd_wr, //0: read, 1: write
    input bram_sel,//0: bram0, 1: bram1
    
    input [BRAM_DATA_WIDTH - 1 : 0] bram0_dout,
    input [BRAM_DATA_WIDTH - 1 : 0] bram1_dout,
    output [BRAM_DATA_WIDTH - 1 : 0] bram0_din,
    output [BRAM_DATA_WIDTH - 1 : 0] bram1_din,
    output bram0_en,
    output bram1_en,
    output bram0_we,
    output bram1_we,
    output [BRAM_ADDR_WIDTH - 1 : 0] bram0_addr,
    output [BRAM_ADDR_WIDTH - 1 : 0] bram1_addr
);

localparam IDLE = 2'b00;
localparam RD = 2'b01;
localparam WR = 2'b10;

reg [1:0] state;
reg [1:0] nxt_state;

reg [6:0] rd_cmd_cnt;
reg [6:0] rd_data_cnt;
reg [6:0] wr_cmd_cnt;
wire [6:0] wr_data_cnt;

reg bram0_en_r;
reg bram1_en_r;

reg [BRAM_ADDR_WIDTH - 1 : 0] bram0_addr_r;
reg [BRAM_ADDR_WIDTH - 1 : 0] bram1_addr_r;

reg bram0_we_r;
reg bram1_we_r;

reg [BRAM_DATA_WIDTH - 1 : 0] bram0_din_r;
reg [BRAM_DATA_WIDTH - 1 : 0] bram1_din_r;

reg module_done_r;

assign bram0_din = bram0_din_r;
assign bram1_din = bram1_din_r;

always @(posedge clk) begin
    if (rst | ~init_calib_complete) begin
        bram0_din_r <= 0;
    end else if (state == WR & (wr_cmd_cnt < MAX - 1) & bram0_en) begin
        bram0_din_r <= bram0_din_r + 5;
    end else if (state != WR & (state != nxt_state)) begin
        bram0_din_r <= 0;
    end
end

always @(posedge clk) begin
    if (rst | ~init_calib_complete) begin
        bram1_din_r <= 0;
    end else if (state == WR & (wr_cmd_cnt < MAX - 1) & bram1_en) begin
        bram1_din_r <= bram1_din_r + 5;
    end else if (state != WR & (state != nxt_state)) begin
        bram1_din_r <= 0;
    end
end


assign bram0_we = bram0_we_r;
assign bram1_we = bram1_we_r;

always @(posedge clk) begin
    if (rst | ~init_calib_complete) begin
        bram0_we_r <= 0;
    end else if (state == IDLE & (nxt_state == WR) & bram0_en) begin
        bram0_we_r <= 1;
    end else if (state == WR & (wr_cmd_cnt == MAX - 1) & bram0_en) begin
        bram0_we_r <= 0;
    end
end

always @(posedge clk) begin
    if (rst | ~init_calib_complete) begin
        bram1_we_r <= 0;
    end else if (state == IDLE & (nxt_state == WR) & bram1_en) begin
        bram1_we_r <= 1;
    end else if (state == WR & (wr_cmd_cnt == MAX - 1) & bram1_en) begin
        bram1_we_r <= 0;
    end
end

assign bram0_addr = bram0_addr_r;
assign bram1_addr = bram1_addr_r;

always @(posedge clk) begin
    if (rst | ~init_calib_complete) begin
        bram0_addr_r <= 0;
    end else if (state == IDLE & module_en & !bram_sel) begin
        bram0_addr_r <= bram_begin_addr;
    end else if (state == RD & (rd_cmd_cnt < MAX - 1) & bram0_en) begin
        bram0_addr_r <= bram0_addr_r + 1;
    end else if (state == RD & (state != nxt_state)) begin
        bram0_addr_r <= 0;
    end else if (state == WR & (wr_cmd_cnt < MAX - 1) & bram0_en) begin
        bram0_addr_r <= bram0_addr_r + 1;
    end else if (state == WR & (state != nxt_state)) begin
        bram0_addr_r <= 0;
    end
end

always @(posedge clk) begin
    if (rst | ~init_calib_complete) begin
        bram1_addr_r <= 0;
    end else if (state == IDLE & module_en & bram_sel) begin
        bram1_addr_r <= bram_begin_addr;
    end else if (state == RD & (rd_cmd_cnt < MAX - 1) & bram1_en) begin
        bram1_addr_r <= bram1_addr_r + 1;
    end else if (state == RD & (state != nxt_state)) begin
        bram1_addr_r <= 0;
    end else if (state == WR & (wr_cmd_cnt < MAX - 1) & bram1_en) begin
        bram1_addr_r <= bram1_addr_r + 1;
    end else if (state == WR & (state != nxt_state)) begin
        bram1_addr_r <= 0;
    end
end


//bram_addr


assign bram0_en = bram0_en_r;
assign bram1_en = bram1_en_r;

always @(posedge clk) begin
    if (rst | ~init_calib_complete) begin
        bram0_en_r <= 0;
    end else if (state == IDLE & module_en & !bram_sel) begin
        bram0_en_r <= 1;
    end else if (state != IDLE & (state != nxt_state)) begin
        bram0_en_r <= 0;
    end
end

always @(posedge clk) begin
    if (rst | ~init_calib_complete) begin
        bram1_en_r <= 0;
    end else if (state == IDLE & module_en & bram_sel) begin
        bram1_en_r <= 1;
    end else if (state != IDLE & (state != nxt_state)) begin
        bram1_en_r <= 0;
    end
end

always @(posedge clk) begin
    if (rst | ~init_calib_complete) begin
        rd_cmd_cnt <= 0;
    end else if (state == RD & (rd_cmd_cnt < MAX - 1)) begin
        rd_cmd_cnt <= rd_cmd_cnt + 1;
    end else if (state == RD & (nxt_state != state)) begin
        rd_cmd_cnt <= 0;
    end
end

//rd data cnt delays rd_cmd_cnt by 1 cycle 
always @(posedge clk) begin
    if (rst | ~init_calib_complete) begin
        rd_data_cnt <= 0;
    end else if (state == RD & (state != nxt_state))begin
        rd_data_cnt <= 0;
    end else begin
        rd_data_cnt <= rd_cmd_cnt;
    end
end

always @(posedge clk) begin
    if (rst | ~init_calib_complete) begin
        wr_cmd_cnt <= 0;
    end else if (state == WR & (wr_cmd_cnt < MAX - 1)) begin
        wr_cmd_cnt <= wr_cmd_cnt + 1;
    end else if (state == WR & (nxt_state != state)) begin
        wr_cmd_cnt <= 0;
    end
end

assign wr_data_cnt = wr_cmd_cnt;


always @(posedge clk) begin
    if (rst | ~init_calib_complete) begin
        nxt_state <= IDLE;
    end else if (module_en & (state == IDLE) & !rd_wr) begin
        nxt_state <= RD;
    end else if (state == RD & (rd_data_cnt == MAX - 1)) begin
        nxt_state <= IDLE;
    end else if (module_en & (state == IDLE) & rd_wr) begin
        nxt_state <= WR;
    end else if (state == WR & (wr_data_cnt == MAX - 1)) begin
        nxt_state <= IDLE;
    end
end

always @(posedge clk) begin
    if (rst | ~init_calib_complete) begin
        state <= IDLE;
    end else begin
        state <= nxt_state;
    end

end

assign module_done = module_done_r;

always @(posedge clk) begin
    if (rst | ~init_calib_complete) begin
        module_done_r <= 0;
    end else if (state == RD & (nxt_state != state)) begin
        module_done_r <= 1;
    end else if (state == WR & (nxt_state != state)) begin
        module_done_r <= 1;
    end else begin
        module_done_r <= 0;
    end
end

endmodule
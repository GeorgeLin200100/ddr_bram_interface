`timescale 1ps/1ps
module fm_add_ddr_to_out #(
    parameter APP_DATA_WIDTH = 64,
    parameter APP_ADDR_WIDTH = 32,
    parameter APP_MASK_WIDTH = 8,
    parameter DDR_ADDR_STRIDE = 4'b1000,
    parameter MAX = 20
)
(
    input clk,
    input rst,
    input init_calib_complete,
    input module_en,
    input rd_wr, //0: read, 1: write
    input [APP_ADDR_WIDTH - 1 : 0] ddr_begin_addr,
    output module_done,

    output [APP_ADDR_WIDTH - 1 : 0] app_addr,
    output [2:0] app_cmd,
    output app_en,
    output [APP_DATA_WIDTH - 1 : 0] app_wdf_data,
    output app_wdf_end,
    output [APP_MASK_WIDTH - 1 : 0] app_wdf_mask,
    output app_wdf_wren,
    input [APP_DATA_WIDTH - 1 : 0] app_rd_data,
    input app_rd_data_end,
    input app_rd_data_valid,
    input app_rdy,
    input app_wdf_rdy
);
    localparam WR_CMD = 3'b000;
    localparam RD_CMD = 3'b001;

    //state
    localparam IDLE = 2'b00;
    localparam WR = 2'b01;
    localparam RD = 2'b10;

    
    reg [1:0] state;
    reg [1:0] nxt_state;

    reg wr_en;      
    reg cmd_en;

    reg [6:0] rd_data_cnt;
    reg [6:0] rd_cmd_cnt;

    //rd_data_cnt
    always @(posedge clk) begin
        if (rst | ~init_calib_complete) begin
            rd_data_cnt <= 0;
        end else if (state == RD & (rd_data_cnt < MAX - 1) & app_rd_data_valid) begin
            rd_data_cnt <= rd_data_cnt + 1;
        end else if (state == RD & (nxt_state != state)) begin
            rd_data_cnt <= 0;
        end
    end

    //rd_cmd_cnt
    always @(posedge clk) begin
        if (rst | ~init_calib_complete) begin
            rd_cmd_cnt <= 0;
        end else if (state == RD & (rd_cmd_cnt < MAX - 1) & cmd_en & app_rdy) begin
            rd_cmd_cnt <= rd_cmd_cnt + 1;
        end else if (state == RD & (nxt_state != state)) begin
            rd_cmd_cnt <= 0;
        end
    end



    //wr_data_cnt
    reg [6:0] wr_data_cnt;
    always @(posedge clk) begin
        if (rst | ~init_calib_complete) begin
            wr_data_cnt <= 0;
        end else if (state == WR & (wr_data_cnt < MAX - 1) & app_wdf_rdy & wr_en) begin
            wr_data_cnt <= wr_data_cnt + 1;
        end else if (state == WR & (nxt_state != state)) begin
            wr_data_cnt <= 0;
        end
    end

    //wr_cmd_cnt
    reg [6:0] wr_cmd_cnt;
    always @(posedge clk) begin
        if (rst | ~init_calib_complete) begin
            wr_cmd_cnt <= 0;
        end else if (state == WR & (wr_cmd_cnt < MAX - 1) & cmd_en & app_rdy) begin
            wr_cmd_cnt <= wr_cmd_cnt + 1;
        end else if (state == WR & (nxt_state != state)) begin
            wr_cmd_cnt <= 0;
        end
    end

    //nxt_state
    always @(posedge clk) begin
        if (rst | ~init_calib_complete) begin
            nxt_state <= IDLE;
        end else if (module_en & rd_wr) begin
            nxt_state <= WR;
        end else if (wr_cmd_cnt == MAX - 1) begin
            nxt_state <= IDLE;
        end else if (module_en & ~rd_wr) begin
            nxt_state <= RD;
        end else if (rd_data_cnt == MAX - 1) begin
            nxt_state <= IDLE;
        end 
    end

    //state
    always @(posedge clk) begin
        state <= nxt_state;
    end

    //app_addr
    reg [APP_ADDR_WIDTH - 1 : 0] app_addr_r;
    assign app_addr = app_addr_r;
    always @(posedge clk) begin
        if (rst | ~init_calib_complete) begin
            app_addr_r <= 0;
        end else if (state == IDLE & (nxt_state != state)) begin
            app_addr_r <= ddr_begin_addr;   
        end else if (state == WR & (wr_cmd_cnt < MAX - 1) & cmd_en & app_rdy) begin
            app_addr_r <= app_addr_r + DDR_ADDR_STRIDE;
        end else if (state == WR & (nxt_state != state)) begin
            app_addr_r <= 0;
        end else if (state == RD & (rd_cmd_cnt < MAX - 1) & cmd_en & app_rdy) begin
            app_addr_r <= app_addr_r + DDR_ADDR_STRIDE;
        end else if (state == RD & (nxt_state != state)) begin
            app_addr_r <= 0;
        end
    end

    //app_cmd
    reg [2:0] app_cmd_r;
    assign app_cmd = app_cmd_r;
    always @(posedge clk) begin
        if (rst | ~init_calib_complete) begin
            app_cmd_r <= 0;
        end else if (nxt_state == WR) begin
            app_cmd_r <= WR_CMD;
        end else if (state == WR & (nxt_state != state)) begin
            app_cmd_r <= 0;
        end else if (nxt_state == RD) begin
            app_cmd_r <= RD_CMD;
        end else if (state == RD & (nxt_state != state)) begin
            app_cmd_r <= 0;
        end
    end

    //app_en
    assign app_en = cmd_en & app_rdy;

    //app_wdf_data
    reg [APP_DATA_WIDTH - 1 : 0] app_wdf_data_r;
    assign app_wdf_data = app_wdf_data_r;
    always @(posedge clk) begin
        if (rst | ~init_calib_complete) begin
            app_wdf_data_r <= 0;
        end else if (state == WR & (wr_data_cnt < MAX - 1) & app_wdf_rdy & wr_en) begin
            app_wdf_data_r <= app_wdf_data_r + 1;
        end else if (state == WR & (nxt_state != state)) begin
            app_wdf_data_r <= 0;
        end
    end

    //app_wdf_end
    assign app_wdf_end = wr_en & app_wdf_rdy;

    //app_wdf_mask
    assign app_wdf_mask = 0;

    //app_wdf_wren
    assign app_wdf_wren = wr_en & app_wdf_rdy;

    //module_done
    reg module_done_r;
    always @(posedge clk) begin
        if (rst) begin
            module_done_r <= 0;
        end else if (state == WR & (nxt_state != state)) begin
            module_done_r <= 1;
        end else if (state == RD & (nxt_state != state)) begin
            module_done_r <= 1;
        end else begin
            module_done_r <= 0;
        end
    end
    assign module_done = module_done_r;

    //wr_en

    always @(posedge clk) begin
        if (rst | ~init_calib_complete) begin
            wr_en <= 0;
        end else if (state == WR & (wr_data_cnt < MAX - 1)) begin
            wr_en <= 1;
        end else if (state == WR & (wr_data_cnt == MAX - 1)) begin
            if (app_wdf_rdy & wr_en) begin
                wr_en <= 0;
            end else begin
                wr_en <= wr_en;
            end
        end
    end

    //cmd_en

    always @(posedge clk) begin
        if (rst | ~init_calib_complete) begin
            cmd_en <= 0;
        end else if (state == WR & (wr_cmd_cnt < MAX - 1)) begin
            cmd_en <= 1;
        end else if (state == WR & (wr_cmd_cnt == MAX - 1)) begin
            if (app_rdy & cmd_en) begin
                cmd_en <= 0;
            end else begin
                cmd_en <= cmd_en;
            end 
        end else if (state == RD & (rd_cmd_cnt < MAX - 1)) begin
            cmd_en <= 1;
        end else if (state == RD & (rd_cmd_cnt == MAX - 1)) begin
            if (app_rdy & cmd_en) begin
                cmd_en <= 0;
            end else begin
                cmd_en <= cmd_en;
            end 
        end
    end

endmodule
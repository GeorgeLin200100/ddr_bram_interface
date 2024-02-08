`timescale 1ps/1ps
module fm_add_top #(
    parameter DDR_ADDR_WIDTH = 32,
    parameter DDR_DATA_WIDTH = 64,
    parameter DDR_DATA_WIDTH_BYTE = DDR_DATA_WIDTH / 8,
    parameter FM_COL = 4,
    parameter FM_ROW = 5,
    parameter BRAM_DATA_WIDTH = FM_COL * DDR_DATA_WIDTH,
    parameter BRAM_DEPTH = 64,
    parameter BRAM_ADDR_WIDTH = $clog2(BRAM_DEPTH),
    parameter DDR_BEGIN_ADDR = 0,
    parameter BRAM_BEGIN_ADDR = 0
);

reg module_en_d2o_r;
reg rd_wr_d2o_r;
wire [DDR_ADDR_WIDTH - 1 : 0] ddr_begin_addr_d2o;

reg module_en_db_r;


reg bram_cs;

reg rd_wr_db_r;


wire bram0_en_b2o;
wire bram1_en_b2o;
wire bram0_we_b2o;
wire bram1_we_b2o;
wire [BRAM_ADDR_WIDTH - 1 : 0] bram0_addr_b2o;
wire [BRAM_ADDR_WIDTH - 1 : 0] bram1_addr_b2o;
wire [BRAM_DATA_WIDTH - 1 : 0] bram0_din_b2o;
wire [BRAM_DATA_WIDTH - 1 : 0] bram1_din_b2o;
wire [BRAM_DATA_WIDTH - 1 : 0] bram0_dout_b2o;
wire [BRAM_DATA_WIDTH - 1 : 0] bram1_dout_b2o;
wire module_en_b2o;
wire module_done_b2o;
wire rd_wr_b2o;
wire bram_sel_b2o;
wire [BRAM_ADDR_WIDTH - 1 : 0] bram_begin_addr_b2o;

reg module_en_b2o_r;
reg rd_wr_b2o_r;
reg bram_sel_b2o_r;

assign module_en_b2o = module_en_b2o_r;
assign rd_wr_b2o = rd_wr_b2o_r;
assign bram_sel_b2o = bram_sel_b2o_r;




wire [DDR_ADDR_WIDTH - 1 : 0] app_addr;
wire [2:0] app_cmd;
wire app_en;
wire [DDR_DATA_WIDTH - 1 : 0] app_wdf_data;
wire app_wdf_end;
wire [DDR_DATA_WIDTH_BYTE - 1 : 0] app_wdf_mask;
wire app_wdf_wren;
wire [DDR_DATA_WIDTH - 1 : 0] app_rd_data;
wire app_rd_data_end;
wire app_rd_data_valid;
wire app_rdy;
wire app_wdf_rdy;

wire bram0_en;
wire bram1_en;
wire bram0_we;
wire bram1_we;
wire [BRAM_ADDR_WIDTH - 1 : 0] bram0_addr;
wire [BRAM_ADDR_WIDTH - 1 : 0] bram1_addr;
wire [BRAM_DATA_WIDTH - 1 : 0] bram0_din;
wire [BRAM_DATA_WIDTH - 1 : 0] bram1_din;
wire [BRAM_DATA_WIDTH - 1 : 0] bram0_dout;
wire [BRAM_DATA_WIDTH - 1 : 0] bram1_dout;

wire bram_en_db;
wire bram_we_db;
wire [BRAM_ADDR_WIDTH - 1 : 0] bram_addr_db;
wire [BRAM_DATA_WIDTH - 1 : 0] bram_din_db;

wire [DDR_DATA_WIDTH - 1 : 0] bram0_din_p0;
wire [DDR_DATA_WIDTH - 1 : 0] bram0_din_p1;
wire [DDR_DATA_WIDTH - 1 : 0] bram0_din_p2;
wire [DDR_DATA_WIDTH - 1 : 0] bram0_din_p3;

wire [DDR_DATA_WIDTH - 1 : 0] bram1_din_p0;
wire [DDR_DATA_WIDTH - 1 : 0] bram1_din_p1;
wire [DDR_DATA_WIDTH - 1 : 0] bram1_din_p2;
wire [DDR_DATA_WIDTH - 1 : 0] bram1_din_p3;

assign bram0_din_p0 = bram0_din[DDR_DATA_WIDTH * 0 +: DDR_DATA_WIDTH];
assign bram0_din_p1 = bram0_din[DDR_DATA_WIDTH * 1 +: DDR_DATA_WIDTH];
assign bram0_din_p2 = bram0_din[DDR_DATA_WIDTH * 2 +: DDR_DATA_WIDTH];
assign bram0_din_p3 = bram0_din[DDR_DATA_WIDTH * 3 +: DDR_DATA_WIDTH];

assign bram1_din_p0 = bram1_din[DDR_DATA_WIDTH * 0 +: DDR_DATA_WIDTH];
assign bram1_din_p1 = bram1_din[DDR_DATA_WIDTH * 1 +: DDR_DATA_WIDTH];
assign bram1_din_p2 = bram1_din[DDR_DATA_WIDTH * 2 +: DDR_DATA_WIDTH];
assign bram1_din_p3 = bram1_din[DDR_DATA_WIDTH * 3 +: DDR_DATA_WIDTH];

wire [BRAM_DATA_WIDTH - 1 : 0] bram_dout_db;

wire [DDR_DATA_WIDTH - 1 : 0] bram0_dout_p0;
wire [DDR_DATA_WIDTH - 1 : 0] bram0_dout_p1;
wire [DDR_DATA_WIDTH - 1 : 0] bram0_dout_p2;
wire [DDR_DATA_WIDTH - 1 : 0] bram0_dout_p3;

wire [DDR_DATA_WIDTH - 1 : 0] bram1_dout_p0;
wire [DDR_DATA_WIDTH - 1 : 0] bram1_dout_p1;
wire [DDR_DATA_WIDTH - 1 : 0] bram1_dout_p2;
wire [DDR_DATA_WIDTH - 1 : 0] bram1_dout_p3;

assign bram0_dout_p0 = bram0_dout[DDR_DATA_WIDTH * 0 +: DDR_DATA_WIDTH];
assign bram0_dout_p1 = bram0_dout[DDR_DATA_WIDTH * 1 +: DDR_DATA_WIDTH];
assign bram0_dout_p2 = bram0_dout[DDR_DATA_WIDTH * 2 +: DDR_DATA_WIDTH];
assign bram0_dout_p3 = bram0_dout[DDR_DATA_WIDTH * 3 +: DDR_DATA_WIDTH];

assign bram1_dout_p0 = bram1_dout[DDR_DATA_WIDTH * 0 +: DDR_DATA_WIDTH];
assign bram1_dout_p1 = bram1_dout[DDR_DATA_WIDTH * 1 +: DDR_DATA_WIDTH];
assign bram1_dout_p2 = bram1_dout[DDR_DATA_WIDTH * 2 +: DDR_DATA_WIDTH];
assign bram1_dout_p3 = bram1_dout[DDR_DATA_WIDTH * 3 +: DDR_DATA_WIDTH];

wire clk;
wire rst;
wire init_calib_complete;
wire module_en_d2o;
wire module_done_d2o;
wire [DDR_ADDR_WIDTH - 1 : 0] app_addr_d2o;
wire [2:0] app_cmd_d2o;
wire app_en_d2o;
wire [DDR_DATA_WIDTH - 1 : 0] app_wdf_data_d2o;
wire app_wdf_end_d2o;
wire [DDR_DATA_WIDTH_BYTE - 1 : 0] app_wdf_mask_d2o;
wire app_wdf_wren_d2o;
wire [DDR_DATA_WIDTH - 1 : 0] app_rd_data_d2o;
wire app_rd_data_end_d2o;
wire app_rd_data_valid_d2o;
wire app_rdy_d2o;
wire app_wdf_rdy_d2o;

wire module_en_db;
wire rd_wr_db;
wire [DDR_ADDR_WIDTH - 1 : 0] ddr_begin_addr_db;
wire [BRAM_ADDR_WIDTH - 1 : 0] bram_begin_addr_db;
wire module_done_db;
wire [DDR_ADDR_WIDTH - 1 : 0] app_addr_db;
wire [2:0] app_cmd_db;
wire app_en_db;
wire [DDR_DATA_WIDTH - 1 : 0] app_wdf_data_db;
wire app_wdf_end_db;
wire [DDR_DATA_WIDTH_BYTE - 1 : 0] app_wdf_mask_db;
wire app_wdf_wren_db;
wire [DDR_DATA_WIDTH - 1 : 0] app_rd_data_db;
wire app_rd_data_end_db;
wire app_rd_data_valid_db;
wire app_rdy_db;
wire app_wdf_rdy_db;

assign module_en_d2o = module_en_d2o_r;
assign module_en_db = module_en_db_r;
assign rd_wr_db = rd_wr_db_r;
assign rd_wr_d2o = rd_wr_d2o_r;

initial begin
    // initialize
    wait (rst);
    wait (!rst);
    wait (init_calib_complete);
    module_en_d2o_r = 0;
    rd_wr_d2o_r = 0;
    module_en_db_r = 0;
    rd_wr_db_r = 0;
    bram_cs = 0;
    module_en_b2o_r = 0;
    rd_wr_b2o_r = 0;
    bram_sel_b2o_r = 0;

    //outside --> ddr
    repeat (10) @(posedge clk);
    module_en_d2o_r = 1;
    rd_wr_d2o_r = 1;
    @(posedge clk);
    module_en_d2o_r = 0;
    wait (module_done_d2o);

    //ddr --> bram0
    @(posedge clk);
    rd_wr_db_r = 0;
    bram_cs = 0;
    module_en_db_r = 1;
    @(posedge clk);
    module_en_db_r = 0;
    wait (module_done_db);

    //bram0 --> outside
    repeat (5) @(posedge clk);
    module_en_b2o_r = 1;
    bram_sel_b2o_r = 0;
    rd_wr_b2o_r = 0;
    @(posedge clk);
    module_en_b2o_r = 0;
    wait (module_done_b2o);

    //outside --> bram1
    @(posedge clk);
    module_en_b2o_r = 1;
    bram_sel_b2o_r = 1;
    rd_wr_b2o_r = 1;
    bram_cs = 1;
    @(posedge clk);
    module_en_b2o_r = 0;
    wait (module_done_b2o);

    //bram1 --> ddr
    @(posedge clk);
    module_en_db_r = 1;
    rd_wr_db_r = 1;
    bram_cs = 1;
    @(posedge clk);
    module_en_db_r = 0;
    wait (module_done_db);

    //ddr --> outside
    @(posedge clk);
    module_en_d2o_r = 1;
    rd_wr_d2o_r = 0;
    @(posedge clk);
    module_en_d2o_r = 0;
    wait (module_done_d2o);

    //end
    repeat (5) @(posedge clk);


    $finish;
end




reg module_cs_d2o;
always @(posedge clk) begin
    if (rst) begin
        module_cs_d2o <= 1'b0;
    end else if (module_en_d2o) begin
        module_cs_d2o <= 1'b1;
    end else if (module_done_d2o) begin
        module_cs_d2o <= 1'b0;
    end
end

reg module_cs_db;
always @(posedge clk) begin
    if (rst) begin
        module_cs_db <= 1'b0;
    end else if (module_en_db) begin
        module_cs_db <= 1'b1;
    end else if (module_done_db) begin
        module_cs_db <= 1'b0;
    end
end

reg module_cs_b2o;
always @(posedge clk) begin
    if (rst) begin
        module_cs_b2o <= 1'b0;
    end else if (module_en_b2o) begin
        module_cs_b2o <= 1'b1;
    end else if (module_done_b2o) begin
        module_cs_b2o <= 1'b0;
    end
end



assign app_addr = (module_cs_d2o)  ? app_addr_d2o : 
                  (module_cs_db)        ? app_addr_db       :  0;
assign app_cmd = (module_cs_d2o)   ? app_cmd_d2o : 
                 (module_cs_db)         ? app_cmd_db       :  0;
assign app_en = (module_cs_d2o)    ? app_en_d2o :
                (module_cs_db)          ? app_en_db       :  0;
assign app_wdf_data = (module_cs_d2o) ? app_wdf_data_d2o : 
                      (module_cs_db)       ? app_wdf_data_db       :  0;
assign app_wdf_end = (module_cs_d2o)  ? app_wdf_end_d2o :
                        (module_cs_db)        ? app_wdf_end_db       :  0;
assign app_wdf_mask = (module_cs_d2o) ? app_wdf_mask_d2o :
                        (module_cs_db)        ? app_wdf_mask_db       :  0;
assign app_wdf_wren = (module_cs_d2o) ? app_wdf_wren_d2o :
                        (module_cs_db)        ? app_wdf_wren_db       :  0;

assign app_rd_data_d2o = module_cs_d2o ? app_rd_data : 0;
assign app_rd_data_db = module_cs_db ? app_rd_data : 0;
assign app_rd_data_end_d2o = module_cs_d2o ? app_rd_data_end : 0;
assign app_rd_data_end_db = module_cs_db ? app_rd_data_end : 0;
assign app_rd_data_valid_d2o = module_cs_d2o ? app_rd_data_valid : 0;
assign app_rd_data_valid_db = module_cs_db ? app_rd_data_valid : 0;
assign app_rdy_d2o = module_cs_d2o ? app_rdy : 0;
assign app_rdy_db = module_cs_db ? app_rdy : 0;
assign app_wdf_rdy_d2o = module_cs_d2o ? app_wdf_rdy : 0;
assign app_wdf_rdy_db = module_cs_db ? app_wdf_rdy : 0;




assign bram0_en = (module_cs_db & ~bram_cs) ? bram_en_db : 
                    (module_cs_b2o & ~bram_cs) ? bram0_en_b2o : 0;
assign bram1_en = (module_cs_db & bram_cs) ? bram_en_db : 
                    (module_cs_b2o & bram_cs) ? bram1_en_b2o: 0;
assign bram0_we = (module_cs_db & ~bram_cs) ? bram_we_db :
                    (module_cs_b2o & ~bram_cs) ? bram0_we_b2o : 0;
assign bram1_we = (module_cs_db & bram_cs) ? bram_we_db : 
                    (module_cs_b2o & bram_cs) ? bram1_we_b2o : 0;
assign bram0_addr = (module_cs_db & ~bram_cs) ? bram_addr_db : 
                    (module_cs_b2o & ~bram_cs) ? bram0_addr_b2o : 0;
assign bram1_addr = (module_cs_db & bram_cs) ? bram_addr_db : 
                    (module_cs_b2o & bram_cs) ? bram1_addr_b2o : 0;
assign bram0_din = (module_cs_db & ~bram_cs) ? bram_din_db : 
                    (module_cs_b2o & ~bram_cs) ? bram0_din_b2o : 0;
assign bram1_din = (module_cs_db & bram_cs) ? bram_din_db : 
                    (module_cs_b2o & bram_cs) ? bram1_din_b2o : 0;

assign bram_dout_db = (module_cs_db & bram_cs) ? bram1_dout : 
                        (module_cs_db & ~bram_cs) ? bram0_dout : 0;
assign bram0_dout_b2o = (module_cs_b2o & ~bram_cs) ? bram0_dout : 0;

assign bram1_dout_b2o = (module_cs_b2o & bram_cs) ? bram1_dout : 0;

assign ddr_begin_addr_d2o = DDR_BEGIN_ADDR;
assign ddr_begin_addr_db = DDR_BEGIN_ADDR;
assign bram_begin_addr_db = BRAM_BEGIN_ADDR;
assign bram_begin_addr_b2o = BRAM_BEGIN_ADDR;




fm_add_ddr_to_out #(
    .APP_DATA_WIDTH(DDR_DATA_WIDTH),
    .APP_ADDR_WIDTH(DDR_ADDR_WIDTH),
    .APP_MASK_WIDTH(DDR_DATA_WIDTH_BYTE),
    .DDR_ADDR_STRIDE(DDR_DATA_WIDTH_BYTE),
    .MAX(FM_COL * FM_ROW)
)
fm_add_ddr_to_out_inst
(
    .clk(clk),
    .rst(rst),
    .init_calib_complete(init_calib_complete),
    .module_en(module_en_d2o),
    .rd_wr(rd_wr_d2o),
    .ddr_begin_addr(ddr_begin_addr_d2o),
    .module_done(module_done_d2o),

    .app_addr(app_addr_d2o),
    .app_cmd(app_cmd_d2o),
    .app_en(app_en_d2o),
    .app_wdf_data(app_wdf_data_d2o),
    .app_wdf_end(app_wdf_end_d2o),
    .app_wdf_mask(app_wdf_mask_d2o),
    .app_wdf_wren(app_wdf_wren_d2o),
    .app_rd_data(app_rd_data_d2o),
    .app_rd_data_end(app_rd_data_end_d2o),
    .app_rd_data_valid(app_rd_data_valid_d2o),
    .app_rdy(app_rdy_d2o),
    .app_wdf_rdy(app_wdf_rdy_d2o)
);



fm_add_bram_wr_rd #(
    .BRAM_DATA_WIDTH(BRAM_DATA_WIDTH),
    .BRAM_DEPTH(BRAM_DEPTH),
    .BRAM_ADDR_WIDTH(BRAM_ADDR_WIDTH)
)
fm_add_bram_wr_rd_inst
(
    .clk(clk),
    .bram0_en(bram0_en),
    .bram0_we(bram0_we),
    .bram0_addr(bram0_addr),
    .bram0_din(bram0_din),
    .bram0_dout(bram0_dout),
    .bram1_en(bram1_en),
    .bram1_we(bram1_we),
    .bram1_addr(bram1_addr),
    .bram1_din(bram1_din),
    .bram1_dout(bram1_dout)
);




fm_add_ddr_to_bram #(
    .APP_DATA_WIDTH(DDR_DATA_WIDTH),
    .APP_MASK_WIDTH(DDR_DATA_WIDTH_BYTE),
    .APP_ADDR_WIDTH(DDR_ADDR_WIDTH),
    .FM_COL(FM_COL),
    .FM_ROW(FM_ROW),
    .BRAM_DATA_WIDTH(BRAM_DATA_WIDTH),
    .BRAM_DEPTH(BRAM_DEPTH),
    .BRAM_ADDR_WIDTH(BRAM_ADDR_WIDTH)
)
fm_add_ddr_to_bram_inst
(
    .clk(clk),
    .rst(rst),
    .init_calib_complete(init_calib_complete),

    .module_en(module_en_db),
    .rd_wr(rd_wr_db),
    .ddr_begin_addr(ddr_begin_addr_db),
    .bram_begin_addr(bram_begin_addr_db),
    .module_done(module_done_db),

    .app_addr(app_addr_db),
    .app_cmd(app_cmd_db),
    .app_en(app_en_db),
    .app_wdf_data(app_wdf_data_db),
    .app_wdf_end(app_wdf_end_db),
    .app_wdf_mask(app_wdf_mask_db),
    .app_wdf_wren(app_wdf_wren_db),
    .app_rd_data(app_rd_data_db),
    .app_rd_data_end(app_rd_data_end_db),
    .app_rd_data_valid(app_rd_data_valid_db),
    .app_rdy(app_rdy_db),
    .app_wdf_rdy(app_wdf_rdy_db),

    .bram_en(bram_en_db),
    .bram_we(bram_we_db),
    .bram_addr(bram_addr_db),
    .bram_din(bram_din_db),
    .bram_dout(bram_dout_db)
);

fm_add_bram_to_out #(
    .BRAM_DATA_WIDTH(BRAM_DATA_WIDTH),
    .BRAM_DEPTH(BRAM_DEPTH),
    .BRAM_ADDR_WIDTH(BRAM_ADDR_WIDTH),
    .MAX(FM_ROW)
)
fm_add_bram_to_out_inst
(
    .clk(clk),
    .rst(rst),
    .init_calib_complete(init_calib_complete),
    .module_en(module_en_b2o),
    .module_done(module_done_b2o),

    .bram_begin_addr(bram_begin_addr_b2o),
    .rd_wr(rd_wr_b2o),
    .bram_sel(bram_sel_b2o),

    .bram0_dout(bram0_dout_b2o),
    .bram1_dout(bram1_dout_b2o),
    .bram0_din(bram0_din_b2o),
    .bram1_din(bram1_din_b2o),
    .bram0_en(bram0_en_b2o),
    .bram1_en(bram1_en_b2o),
    .bram0_we(bram0_we_b2o),
    .bram1_we(bram1_we_b2o),
    .bram0_addr(bram0_addr_b2o),
    .bram1_addr(bram1_addr_b2o)
);


fm_add_ddr_wrapper_top #(
    .APP_ADDR_WIDTH(DDR_ADDR_WIDTH),
    .APP_DATA_WIDTH(DDR_DATA_WIDTH),
    .APP_MASK_WIDTH(DDR_DATA_WIDTH_BYTE)
)
fm_add_ddr_wrapper_top_inst
(
    .app_addr(app_addr),
    .app_cmd(app_cmd),
    .app_en(app_en),
    .app_wdf_data(app_wdf_data),
    .app_wdf_end(app_wdf_end),
    .app_wdf_mask(app_wdf_mask),
    .app_wdf_wren(app_wdf_wren),
    .app_rd_data(app_rd_data),
    .app_rd_data_end(app_rd_data_end),
    .app_rd_data_valid(app_rd_data_valid),
    .app_rdy(app_rdy),
    .app_wdf_rdy(app_wdf_rdy),

    .clk(clk),
    .rst(rst),
    .init_calib_complete(init_calib_complete)
);


endmodule
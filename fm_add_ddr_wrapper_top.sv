`timescale 1ps/1ps

module fm_add_ddr_wrapper_top #(
    parameter APP_ADDR_WIDTH = 32,
    parameter APP_DATA_WIDTH = 64,
    parameter APP_MASK_WIDTH = APP_DATA_WIDTH / 8
)
(
    input [APP_ADDR_WIDTH - 1 : 0] app_addr,
    input [2:0] app_cmd,
    input app_en,
    input [APP_DATA_WIDTH - 1 : 0] app_wdf_data,
    input app_wdf_end,
    input [APP_MASK_WIDTH - 1 : 0] app_wdf_mask,
    input app_wdf_wren,
    output [APP_DATA_WIDTH - 1 : 0] app_rd_data,
    output app_rd_data_end,
    output app_rd_data_valid,
    output app_rdy,
    output app_wdf_rdy,
    output clk,
    output rst,
    output init_calib_complete
);

    wire sys_rst; //Common port for all controllers

    wire                c0_init_calib_complete;
    wire                c0_data_compare_error;
    wire                c0_sys_clk_p;
    wire                c0_sys_clk_n;
    wire                c0_ddr4_act_n;
    wire [16:0]          c0_ddr4_adr;
    wire [1:0]            c0_ddr4_ba;
    wire [1:0]            c0_ddr4_bg;
    wire [0:0]            c0_ddr4_cke;
    wire [0:0]            c0_ddr4_odt;
    wire [0:0]            c0_ddr4_cs_n;
    wire [0:0]                 c0_ddr4_ck_t;
    wire [0:0]                c0_ddr4_ck_c;
    wire                  c0_ddr4_reset_n;
    wire  [0:0]            c0_ddr4_dm_dbi_n;
    wire  [7:0]            c0_ddr4_dq;
    wire  [0:0]            c0_ddr4_dqs_t;
    wire  [0:0]            c0_ddr4_dqs_c;



    ddr4_0 u_ddr4_0
    (
        .sys_rst           (sys_rst),

        .c0_sys_clk_p                   (c0_sys_clk_p),
        .c0_sys_clk_n                   (c0_sys_clk_n),
        .c0_init_calib_complete (init_calib_complete),
        .c0_ddr4_act_n          (c0_ddr4_act_n),
        .c0_ddr4_adr            (c0_ddr4_adr),
        .c0_ddr4_ba             (c0_ddr4_ba),
        .c0_ddr4_bg             (c0_ddr4_bg),
        .c0_ddr4_cke            (c0_ddr4_cke),
        .c0_ddr4_odt            (c0_ddr4_odt),
        .c0_ddr4_cs_n           (c0_ddr4_cs_n),
        .c0_ddr4_ck_t           (c0_ddr4_ck_t),
        .c0_ddr4_ck_c           (c0_ddr4_ck_c),
        .c0_ddr4_reset_n        (c0_ddr4_reset_n),

        .c0_ddr4_dm_dbi_n       (c0_ddr4_dm_dbi_n),
        .c0_ddr4_dq             (c0_ddr4_dq),
        .c0_ddr4_dqs_c          (c0_ddr4_dqs_c),
        .c0_ddr4_dqs_t          (c0_ddr4_dqs_t),

        .c0_ddr4_ui_clk                (clk),
        .c0_ddr4_ui_clk_sync_rst       (rst),
        .dbg_clk                                    (dbg_clk),

        .c0_ddr4_app_addr              (app_addr),
        .c0_ddr4_app_cmd               (app_cmd),
        .c0_ddr4_app_en                (app_en),
        .c0_ddr4_app_hi_pri            (1'b0),
        .c0_ddr4_app_wdf_data          (app_wdf_data),
        .c0_ddr4_app_wdf_end           (app_wdf_end),
        .c0_ddr4_app_wdf_mask          (app_wdf_mask),
        .c0_ddr4_app_wdf_wren          (app_wdf_wren),
        .c0_ddr4_app_rd_data           (app_rd_data),
        .c0_ddr4_app_rd_data_end       (app_rd_data_end),
        .c0_ddr4_app_rd_data_valid     (app_rd_data_valid),
        .c0_ddr4_app_rdy               (app_rdy),
        .c0_ddr4_app_wdf_rdy           (app_wdf_rdy),
        
        // Debug Port
        .dbg_bus         (dbg_bus)                                             
     );

     fm_add_ddr_wrapper u_fm_add_ddr_wrapper (
        .sys_rst(sys_rst),
        .c0_sys_clk_p(c0_sys_clk_p),
        .c0_sys_clk_n(c0_sys_clk_n),
        .c0_ddr4_dq(c0_ddr4_dq),
        .c0_ddr4_dqs_c(c0_ddr4_dqs_c),
        .c0_ddr4_dqs_t(c0_ddr4_dqs_t),
        .c0_ddr4_adr(c0_ddr4_adr),
        .c0_ddr4_ba(c0_ddr4_ba),
        .c0_ddr4_bg(c0_ddr4_bg),
        .c0_ddr4_reset_n(c0_ddr4_reset_n),
        .c0_ddr4_act_n(c0_ddr4_act_n),
        .c0_ddr4_ck_t(c0_ddr4_ck_t),
        .c0_ddr4_ck_c(c0_ddr4_ck_c),
        .c0_ddr4_cke(c0_ddr4_cke),
        .c0_ddr4_cs_n(c0_ddr4_cs_n),
        .c0_ddr4_dm_dbi_n(c0_ddr4_dm_dbi_n),
        .c0_ddr4_odt(c0_ddr4_odt)
     );

endmodule
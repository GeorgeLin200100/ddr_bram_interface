`timescale 1ps/1ps
module fm_add_bram_wr_rd #(
    parameter BRAM_DATA_WIDTH = 64,
    parameter BRAM_DEPTH = 64,
    parameter BRAM_ADDR_WIDTH = clog2(BRAM_DEPTH)
)
(
    input clk,
    input bram0_en,
    input bram0_we,
    input [BRAM_ADDR_WIDTH - 1 : 0] bram0_addr,
    input [BRAM_DATA_WIDTH - 1 : 0] bram0_din,
    output [BRAM_DATA_WIDTH - 1 : 0] bram0_dout,
    input bram1_en,
    input bram1_we,
    input [BRAM_ADDR_WIDTH - 1 : 0] bram1_addr,
    input [BRAM_DATA_WIDTH - 1 : 0] bram1_din,
    output [BRAM_DATA_WIDTH - 1 : 0] bram1_dout
);

    fm_add_BRAM_x #(
        .BRAM_ADDR_WIDTH(BRAM_ADDR_WIDTH),
        .BRAM_DATA_WIDTH(BRAM_DATA_WIDTH),
        .BRAM_DEPTH(BRAM_DEPTH)
    )
    bram0
    (
        .clk(clk),
        .we(bram0_we),
        .en(bram0_en),
        .addr(bram0_addr),
        .din(bram0_din),
        .dout(bram0_dout)
    );

    fm_add_BRAM_x #(
        .BRAM_ADDR_WIDTH(BRAM_ADDR_WIDTH),
        .BRAM_DATA_WIDTH(BRAM_DATA_WIDTH),
        .BRAM_DEPTH(BRAM_DEPTH)
    )
    bram1
    (
        .clk(clk),
        .we(bram1_we),
        .en(bram1_en),
        .addr(bram1_addr),
        .din(bram1_din),
        .dout(bram1_dout)
    );

endmodule


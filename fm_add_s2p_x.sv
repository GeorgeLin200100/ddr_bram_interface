`timescale 1ps/1ps

module fm_add_s2p_x #(
        parameter SEQ_CNT = 5,
        parameter APP_DATA_WIDTH = 64
    )
    (
        input clk,
        input rst,
        input seq_en,
        input [APP_DATA_WIDTH - 1 : 0] seq,
        output [APP_DATA_WIDTH * SEQ_CNT - 1 : 0] par,
        output par_valid
    );

    reg [APP_DATA_WIDTH * SEQ_CNT - 1 : 0] par_r;
    assign par = par_r;
    always @(posedge clk) begin
        if (rst) begin
            par_r <= 0;
        end else if (seq_en) begin
            par_r <= {seq, par_r[APP_DATA_WIDTH * SEQ_CNT - 1 : APP_DATA_WIDTH]};
        end
    end

    reg [5:0] cnt;
    always @(posedge clk) begin
        if (rst) begin
            cnt <= 0;
        end else if (seq_en & (cnt < SEQ_CNT - 1)) begin
            cnt <= cnt + 1;
        end else if (seq_en & (cnt == SEQ_CNT - 1)) begin
            cnt <= 0;
        end
    end

    reg seq_en_r;
    always @(posedge clk) begin
        seq_en_r <= seq_en;
    end
    assign par_valid = (cnt == 0) & seq_en_r;

endmodule
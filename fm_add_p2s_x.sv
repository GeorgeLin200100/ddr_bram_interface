`timescale 1ps/1ps

module fm_add_p2s_x #(
        parameter SEQ_CNT = 5,
        parameter APP_DATA_WIDTH = 64
    )
    (
        input clk,
        input rst,
        input par_en,
        input [APP_DATA_WIDTH * SEQ_CNT - 1 : 0] par,
        output [APP_DATA_WIDTH - 1 : 0] seq,
        output seq_valid,
        output seq_last
    );

    reg [5:0] cnt;

    reg [APP_DATA_WIDTH * SEQ_CNT - 1 : 0] par_r;
    always @(posedge clk) begin
        if (rst) begin
            par_r <= 0;
        end else if (par_en) begin
            par_r <= par;
        end else begin
            par_r <= 0;
        end
    end



    reg cnt_en;
    always @(posedge clk) begin
        if (rst) begin
            cnt_en <= 0;
        end else if (par_en) begin
            cnt_en <= 1;
        end else if (cnt == SEQ_CNT - 1) begin
            cnt_en <= 0;
        end
    end

    
    always @(posedge clk) begin
        if (rst) begin
            cnt <= 0;
        end else if (cnt_en & (cnt < SEQ_CNT - 1)) begin
            cnt <= cnt + 1;
        end else if (cnt_en & (cnt == SEQ_CNT - 1)) begin
            cnt <= 0;
        end
    end

    assign seq_valid = cnt_en;
    assign seq_last = (cnt == SEQ_CNT - 1);

    assign seq = par_r[cnt * APP_DATA_WIDTH +: APP_DATA_WIDTH];

endmodule

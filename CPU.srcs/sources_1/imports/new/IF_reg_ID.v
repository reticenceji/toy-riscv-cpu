module IF_reg_ID (
    input clk_IFID,                 //寄存器时钟
    input rst_IFID,                 //寄存器复位
    input en_IFID,                  //寄存器使能
    input [31:0] PC_in_IFID,        //PC输入
    input [31:0] inst_in_IFID,      //指令输入

    output reg [31:0] PC_out_IFID,  //PC输出
    output reg [31:0] inst_out_IFID //指令输出
);
    always @(posedge clk_IFID or posedge rst_IFID) begin
        if (rst_IFID==1) begin
            PC_out_IFID <= 0;
            inst_out_IFID <= 0;
        end
        else begin
            PC_out_IFID <=  PC_in_IFID;
            inst_out_IFID <= inst_in_IFID;
        end
    end
endmodule //IF_reg_ID
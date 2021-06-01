module Pipeline_IF(
    input clk_IF,               //时钟
    input rst_IF,               //复位
    input en_IF,                //使能
    input [31:0] PC_in_IF,      //取指令PC输入
    input PCSrc,                //PC输入选择

    output [31:0] PC_out_IF //PC输出
);
    wire [31:0] PC_current,PC_next;
    MUX2T1_32 MUX2T1_32_1(
        .s(PCSrc),     
        .I0(PC_current+4),     
        .I1(PC_in_IF),          

        .o(PC_next)
    );

    // PC Register, set PC=PC_next when clk posedge
    REG32 REG321(
        .clk(clk_IF),
        .rst(rst_IF),
        .CE(en_IF),   //enable
        .D(PC_next),

        .Q(PC_current)
    );

    assign PC_out_IF = PC_current;
endmodule
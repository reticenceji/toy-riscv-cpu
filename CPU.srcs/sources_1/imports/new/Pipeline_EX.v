/*执行是指对获取的操作数进行指令所指定的算数或逻辑运算
 */
module Pipeline_EX (
    input[31:0] PC_in_EX,       //PC输入
    input[31:0] Rs1_in_EX,      //操作数1输入
    input[31:0] Rs2_in_EX,      //操作数2输入
    input[31:0] Imm_in_EX ,     //立即数输入
    input ALUSrc_B_in_EX ,      //ALU B选择
    input[2:0] ALU_control_in_EX,   //ALU选择控制

    output [31:0] PC_out_EX,    //PC输出
    output [31:0] PC4_out_EX,   //PC+4输出
    output zero_out_EX,         //ALU判0输出
    output [31:0] ALU_out_EX,   //ALU计算输出
    output [31:0] Rs2_out_EX    //操作数2输出
);
    //选择ALU的第二个加数
    wire [31:0] ALU_add2;
    MUX2T1_32 MUX2T1_32_0(
        .s(ALUSrc_B_in_EX),
        .I0(Rs2_in_EX),
        .I1(Imm_in_EX),

        .o(ALU_add2)
    );
    ALU ALU1(
        .A(Rs1_in_EX),
        .B(ALU_add2),
        .ALU_operation(ALU_control_in_EX),

        .res(ALU_out_EX),   
        .zero(zero_out_EX)
    );

    assign PC_out_EX = PC_in_EX;
    assign PC4_out_EX = PC_in_EX + 4;
    assign Rs2_out_EX = ALU_add2;
endmodule //Pipeline_EX
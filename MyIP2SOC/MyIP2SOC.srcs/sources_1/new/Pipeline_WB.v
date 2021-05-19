`timescale 1ns / 1ps
/* 写回是指将指令执行的结果写回寄存器堆的过程；
 * 如果是普通运算指令，该结果值来源于‘执行’阶段计算的结果；
 * 如果是LOAD指令，该结果来源于‘访存’阶段从存储器读取出来的数据；
 * 如果是跳转指令，该结果来源于PC+4
 */
module Pipeline_WB (
    input[31:0] PC4_in_WB,      //PC+4输入
    input[31:0] ALU_in_WB,      //ALU结果输出
    input[31:0] Dmem_data_WB,   //存储器数据输入
    input[1:0] MemtoReg_in_WB,  //写回选择控制

    output [31:0] Data_out_WB   //写回数据输出
);

    MUX4T1_32 MUX4T1_32_1(
        .s(Data_out_WB),
        .I0(ALU_in_WB),
        .I1(Dmem_data_WB),
        .I2(PC4_in_WB),
        .I3(PC4_in_WB),

        .o(Data_out_WB)
    );
endmodule //Pipeline_WB
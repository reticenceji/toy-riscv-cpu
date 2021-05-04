`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2021 12:23:13 PM
// Design Name: 
// Module Name: DataPath
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module DataPath(
    input wire clk,
    input wire rst,
    input wire [31:0] inst_field,
    input wire [31:0] Data_in,
    input wire [2:0] ALU_Control,
    input wire [1:0] ImmSel,
    input wire [1:0] MentoReg,
    input wire ALUSrc_B,
    input wire Jump,
    input wire Branch,
    input wire RegWrite,
    
    output wire[31:0] PC_out,
    output wire[31:0] Data_out,
    output wire[31:0] ALU_out,
    
    output wire [31:0] ra  ,
    output wire [31:0] sp  ,
    output wire [31:0] gp  ,
    output wire [31:0] tp  ,
    output wire [31:0] t0  ,
    output wire [31:0] t1  ,
    output wire [31:0] t2  ,
    output wire [31:0] s0  ,
    output wire [31:0] s1  ,
    output wire [31:0] a0  ,
    output wire [31:0] a1  ,
    output wire [31:0] a2  ,
    output wire [31:0] a3  ,
    output wire [31:0] a4  ,
    output wire [31:0] a5  ,
    output wire [31:0] a6  ,
    output wire [31:0] a7  ,
    output wire [31:0] s2  ,
    output wire [31:0] s3  ,
    output wire [31:0] s4  ,
    output wire [31:0] s5  ,
    output wire [31:0] s6  ,
    output wire [31:0] s7  ,
    output wire [31:0] s8  ,
    output wire [31:0] s9  ,
    output wire [31:0] s10 ,
    output wire [31:0] s11 ,
    output wire [31:0] t3  ,
    output wire [31:0] t4  ,
    output wire [31:0] t5  ,
    output wire [31:0] t6  
    );
    
    // 产生立即数
    wire [31:0] Immediate_number;
    ImmGen ImmGen1(
        .ImmSel(ImmSel),
        .inst_field(inst_field),
    
        .Imm_out(Immediate_number)
        );

    // 从寄存器中读取内容
    wire [31:0]Reg_read1,Reg_read2,Reg_write;
    regs regs1 (
        .clk(clk),
        .rst(rst),
        .RegWrite(RegWrite),
        .Rs1_addr(inst_field[19:15]),
        .Rs2_addr(inst_field[24:20]),
        .Wt_addr(inst_field[11:7]),    
        .Wt_data(Reg_write),     //选的: Mem/ALU/跳转

        .Rs1_data(Reg_read1),
        .Rs2_data(Reg_read2),
        
        .ra (ra ),
        .sp (sp ),
        .gp (gp ),
        .tp (tp ),
        .t0 (t0 ),
        .t1 (t1 ),
        .t2 (t2 ),
        .s0 (s0 ),
        .s1 (s1 ),
        .a0 (a0 ),
        .a1 (a1 ),
        .a2 (a2 ),
        .a3 (a3 ),
        .a4 (a4 ),
        .a5 (a5 ),
        .a6 (a6 ),
        .a7 (a7 ),
        .s2 (s2 ),
        .s3 (s3 ),
        .s4 (s4 ),
        .s5 (s5 ),
        .s6 (s6 ),
        .s7 (s7 ),
        .s8 (s8 ),
        .s9 (s9 ),
        .s10(s10),
        .s11(s11),
        .t3 (t3 ),
        .t4 (t4 ),
        .t5 (t5 ),
        .t6 (t6 )
    );
    //选择ALU的 加数
    wire [31:0] ALU_add2;
    MUX2T1_32 MUX2T1_32_0(
        .s(ALUSrc_B),
        .I0(Reg_read2),
        .I1(Immediate_number),

        .o(ALU_add2)
    );

    //ALU
    wire ALU_zero;
    wire [31:0] ALU_Result;
    ALU ALU1(
        .A(Reg_read1),
        .B(ALU_add2),
        .ALU_operation(ALU_Control),

        .res(ALU_Result),   
        .zero(ALU_zero)
    );

    // PC
    wire [31:0] PC_current,PC_next;
    REG32 REG321(
        .clk(clk),
        .rst(rst),
        .CE(1),   //enable
        .D(PC_next),

        .Q(PC_current)
    );

    //判断是否需要branch/jal
    wire Is_branch;
    wire [31:0] PC_next_1;
    assign Is_branch = Branch & ALU_zero;
    MUX2T1_32 MUX2T1_32_1(
        .s(Branch),     
        .I0(PC_current+4),     
        .I1(PC_current+Immediate_number), //可以这么写吗

        .o(PC_next_1)
    );
    MUX2T1_32 MUX2T1_32_2(
        .s(Jump),
        .I0(PC_next_1),
        .I1(PC_current+Immediate_number), 

        .o(PC_next)
    );

    MUX4T1_32 MUX4T1_32_1(
        .s(MentoReg),
        .I0(ALU_Result),
        .I1(Data_in),
        .I2(PC_current+4),
        .I3(PC_current+4),

        .o(Reg_write)
    );
    //输出
    assign ALU_out = ALU_Result;
    assign PC_out = PC_current;
    assign Data_out = Reg_read2;    
endmodule

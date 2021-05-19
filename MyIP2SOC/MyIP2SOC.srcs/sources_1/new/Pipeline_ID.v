`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2021 03:05:02 PM
// Design Name: 
// Module Name: Pipeline_ID
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


module Pipeline_ID(
    input clk_ID,                       //时钟
    input rst_ID,                       //复位
    input [31:0] Inst_in_ID,            //指令输入
    
    input RegWrite_in_ID,               //寄存器堆使能
    input [4:0] Wt_addr_ID,             //写目的地址输入
    input [31:0] Wt_data_ID,            //写数据输入
    //=================================================
    output [4:0] Wt_addr_out_ID,        //写目的地址输出

    output [31:0] Rs1_out_ID,           //操作数1输出
    output [31:0] Rs2_out_ID,           //操作数2输出
    
    output [31:0] Imm_out_ID,           //立即数输出
    
    output ALUSrc_B_ID,                 //ALU B端输入选择
    output [2:0] ALU_control_ID,        //ALU控制
    output [3:0]Branch_ID,              //Branch控制
    output MemRW_ID,                    //存储器读写
    output Jump_ID,                     //Jal控制
    output [1:0] MemtoReg_ID,           //寄存器写回选择
    output RegWrite_out_ID,             //寄存器堆读写

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

    wire [1:0] ctrl_ImmSel;
    SCPU_ctrl SCPU_ctrl_ins(
        .OPcode(Inst_in_ID[6:2]),       //Instruction[6:2]
        .Fun3(Inst_in_ID[14:12]),       //Instruction[14:12]
        .Fun7(Inst_in_ID[30]),          //Instruction[30]
        .MIO_ready(),                   // ignore
        .Fun_ecall(Inst_in_ID[22:20]),  //Instruction[22:20]
        .Fun_mret(Inst_in_ID[29:28]),   

        .ImmSel(ctrl_ImmSel),           // 不是输出
        .ALU_Control(ALU_control_ID),
        .MemtoReg(MemtoReg_ID),
        .ALU_src_B(ALUSrc_B_ID),   
        .Jump(Jump_ID),
        .Branch(Branch_ID),
        .MemRW(MemRW_ID),
        .RegWrite(RegWrite_out_ID),
        .CPU_MIO(),                     // ignore 
        .Ecall(),                       
        .Mret(),
        .Ill_instr()
    );

    wire [31:0] Immediate_number;
    ImmGen ImmGen1(
        .ImmSel(ctrl_ImmSel),
        .Inst_in_ID(Inst_in_ID),
    
        .Imm_out(Imm_out_ID)            // 输出
        );
    
    regs regs1 (
        .clk(clk_ID),
        .rst(rst_ID),
        .RegWrite(RegWrite_in_ID),      // 注意，不是当前的信号，是WB输入的信号
        .Rs1_addr(Inst_in_ID[19:15]),   // 读取是当前的信号
        .Rs2_addr(Inst_in_ID[24:20]),
        .Wt_addr(Wt_addr_ID),    
        .Wt_data(Wt_data_ID),           

        .Rs1_data(Rs1_out_ID),
        .Rs2_data(Rs1_out_ID),          // 这两个是输出
        
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

    assign Wt_addr_out_ID = Inst_in_ID[11:7];
endmodule

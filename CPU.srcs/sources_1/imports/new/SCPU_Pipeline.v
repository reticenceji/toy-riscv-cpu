`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2021 04:26:30 PM
// Design Name: 
// Module Name: SCPU_Pipeline
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependenciefiles: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Pipeline_CPU(
    input clk,                  //时钟
    input rst,                  //复位
    input[31:0] Data_in,        //存储器数据输入
    input[31:0] inst_IF,        //取指阶段指令

    output [31:0] PC_out_IF,    //取指阶段PC输出，读取ROM
    output [31:0] PC_out_ID,    //译码阶段PC输出
    output [31:0] inst_ID,      //译码阶段指令
    output [31:0] PC_out_Ex,    //执行阶段PC输出
    output [31:0] MemRW_Ex,     //执行阶段存储器读写
    output [31:0] MemRW_Mem,    //访存阶段存储器读写，读取RAM
    output [31:0] Addr_out,     //地址输出，写入RAM的地址
    output [31:0] Data_out,     //CPU数据输出，写入RAM
    output [31:0] Data_out_WB,  //写回数据输出
    
    output wire [31:0] ra  ,    //寄存器
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

    wire PCSrc_MEM;
    wire [31:0] PC_out_EXMem; //PC输出
    wire en_IF;
    Pipeline_IF Instruction_Fetch(
        .clk_IF(clk),               //时钟
        .rst_IF(rst),               //复位
        .en_IF(en_IF),                //使能
        .PC_in_IF(PC_out_EXMem),      //取指令PC输入
        .PCSrc(PCSrc_MEM),                //PC输入选择

        .PC_out_IF(PC_out_IF) //PC输出
    );

    wire NOP_IFID,NOP_IDEX,NOP_EXMEM,en_IFID;
    wire [31:0] inst_out_IFID,PC_out_IFID;
    IF_reg_ID IF_ID(
        .clk_IFID(clk),
        .rst_IFID(rst),
        .en_IFID(en_IFID),
        .NOP_IFID(NOP_IFID),
        .PC_in_IFID(PC_out_IF),        //PC输入
        .inst_in_IFID(inst_IF),      //指令输入

        .PC_out_IFID(PC_out_IFID),  //PC输出
        .inst_out_IFID(inst_out_IFID) //指令输出
    );

    wire [4:0] Wt_addr_out_ID;
    wire [4:0] Wt_addr_out_MemWB; //写目的地址输出
    wire RegWrite_out_MemWB; //寄存器堆读写);

    wire [31:0] Imm_out_ID,Rs1_out_ID,Rs2_out_ID;
    wire [3:0] Branch_ID;
    wire [2:0] ALU_control_ID;
    wire [1:0] MemtoReg_ID;
    wire ALUSrc_B_ID,MemRW_ID,Jump_ID,RegWrite_out_ID;
    wire [4:0] Rs1_addr_ID,Rs2_addr_ID;
    wire Rs1_used_ID,Rs2_used_ID;
    Pipeline_ID Instruction_Decode(
        .clk_ID(clk),
        .rst_ID(rst),
        .Inst_in_ID(inst_out_IFID),
        .RegWrite_in_ID(RegWrite_out_MemWB),
        .Wt_addr_ID(Wt_addr_out_MemWB),
        .Wt_data_ID(Data_out_WB),

        .Rs1_addr_ID(Rs1_addr_ID),         //译码阶段寄存器读地址1
        .Rs2_addr_ID(Rs2_addr_ID),         //译码阶段寄存器读地址2
        .Rs1_used(Rs1_used_ID),                 //Rs1被使用
        .Rs2_used(Rs2_used_ID),                 //Rs2被使用
        .Wt_addr_out_ID(Wt_addr_out_ID),
        .Rs1_out_ID(Rs1_out_ID),
        .Rs2_out_ID(Rs2_out_ID),
        .Imm_out_ID(Imm_out_ID),
        .ALUSrc_B_ID(ALUSrc_B_ID),
        .ALU_control_ID(ALU_control_ID),
        .Branch_ID(Branch_ID),
        .MemRW_ID(MemRW_ID),
        .Jump_ID(Jump_ID),
        .MemtoReg_ID(MemtoReg_ID),
        .RegWrite_out_ID(RegWrite_out_ID),
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

    wire [31:0] PC_out_IDEX;      //PC输出
    wire [4:0] Wt_addr_out_IDEX;   //目的地址输出
    wire [31:0] Rs1_out_IDEX;      //操作数1输出
    wire [31:0] Rs2_out_IDEX;      //操作数2输出
    wire [31:0] Imm_out_IDEX;     //立即数输出
    wire  ALUSrc_B_out_IDEX;      //ALU B选择
    wire [2:0] ALU_control_out_IDEX; //ALU控制
    wire  [3:0] Branch_out_IDEX;   //Beq
    wire  MemRW_out_IDEX;          //存储器读写
    wire  Jump_out_IDEX;           //Jal
    wire  [1:0] MemtoReg_out_IDEX; //写回
    wire  RegWrite_out_IDEX;        //寄存器堆读写

    ID_reg_EX ID_EX(
        .clk_IDEX(clk),
        .rst_IDEX(rst),
        .en_IDEX(1),
        .NOP_IDEX(NOP_IDEX),
        .PC_in_IDEX(PC_out_IFID),
        .Wt_addr_IDEX(Wt_addr_out_ID),
        .Rs1_in_IDEX(Rs1_out_ID),
        .Rs2_in_IDEX(Rs2_out_ID),
        .Imm_in_IDEX(Imm_out_ID),
        .ALUSrc_B_in_IDEX(ALUSrc_B_ID),
        .ALU_control_in_IDEX(ALU_control_ID),
        .Branch_in_IDEX(Branch_ID),
        .MemRW_in_IDEX(MemRW_ID),
        .Jump_in_IDEX(Jump_ID),
        .MemtoReg_in_IDEX(MemtoReg_ID),
        .RegWrite_in_IDEX(RegWrite_out_ID),

        .PC_out_IDEX(PC_out_IDEX),
        .Wt_addr_out_IDEX(Wt_addr_out_IDEX),
        .Rs1_out_IDEX(Rs1_out_IDEX),
        .Rs2_out_IDEX(Rs2_out_IDEX),
        .Imm_out_IDEX(Imm_out_IDEX),
        .ALUSrc_B_out_IDEX(ALUSrc_B_out_IDEX),
        .ALU_control_out_IDEX(ALU_control_out_IDEX),
        .Branch_out_IDEX(Branch_out_IDEX),
        .MemRW_out_IDEX(MemRW_out_IDEX),
        .Jump_out_IDEX(Jump_out_IDEX),
        .MemtoReg_out_IDEX(MemtoReg_out_IDEX),
        .RegWrite_out_IDEX(RegWrite_out_IDEX)
    );

    wire [31:0] PC_out_EX;    //PC输出
    wire [31:0] PC4_out_EX;   //PC+4输出
    wire zero_out_EX;         //ALU判0输出
    wire [31:0] ALU_out_EX;   //ALU计算输出
    wire [31:0] Rs2_out_EX;    //操作数2输出
    Pipeline_EX Excecute(
        .PC_in_EX(PC_out_IDEX),
        .Rs1_in_EX(Rs1_out_IDEX),
        .Rs2_in_EX(Rs2_out_IDEX),
        .Imm_in_EX(Imm_out_IDEX),
        .ALUSrc_B_in_EX(ALUSrc_B_out_IDEX),
        .ALU_control_in_EX(ALU_control_out_IDEX),

        .PC_out_EX(PC_out_EX),
        .PC4_out_EX(PC4_out_EX),
        .zero_out_EX(zero_out_EX),
        .ALU_out_EX(ALU_out_EX),
        .Rs2_out_EX(Rs2_out_EX)
    );

    wire [31:0] PC4_out_EXMem; //PC+4输出
    wire [4:0] Wt_addr_out_EXMem; //写目的寄存器输出
    wire zero_out_EXMem; //zero
    wire [31:0] ALU_out_EXMem; //ALU输出
    wire [31:0] Rs2_out_EXMem; //操作数2输出
    wire [3:0] Branch_out_EXMem; //Branch
    wire MemRW_out_EXMem; //存储器读写
    wire Jump_out_EXMem; //Jal
    wire [1:0] MemtoReg_out_EXMem; //写回
    wire RegWrite_out_EXMem; //寄存器堆读写
    EX_reg_MEM EX_MEM(
        .clk_EXMem(clk),
        .rst_EXMem(rst),
        .en_EXMem(1),
        .NOP_EXMem(NOP_EXMEM),
        .PC_in_EXMem(PC_out_EX),
        .PC4_in_EXMem(PC4_out_EX),
        .Wt_addr_EXMem(Wt_addr_out_IDEX),
        .zero_in_EXMem(zero_out_EX),
        .ALU_in_EXMem(ALU_out_EX),
        .Rs2_in_EXMem(Rs2_out_EX),
        .Branch_in_EXMem(Branch_out_IDEX),
        .MemRW_in_EXMem(MemRW_out_IDEX),
        .Jump_in_EXMem(Jump_out_IDEX),
        .MemtoReg_in_EXMem(MemtoReg_out_IDEX),
        .RegWrite_in_EXMem(RegWrite_out_IDEX),

        .PC_out_EXMem(PC_out_EXMem),
        .PC4_out_EXMem(PC4_out_EXMem),
        .Wt_addr_out_EXMem(Wt_addr_out_EXMem),
        .zero_out_EXMem(zero_out_EXMem),
        .ALU_out_EXMem(ALU_out_EXMem),
        .Rs2_out_EXMem(Rs2_out_EXMem),          // 要向Ram中写的数据
        .Branch_out_EXMem(Branch_out_EXMem),
        .MemRW_out_EXMem(MemRW_out_EXMem),
        .Jump_out_EXMem(Jump_out_EXMem),
        .MemtoReg_out_EXMem(MemtoReg_out_EXMem),
        .RegWrite_out_EXMem(RegWrite_out_EXMem)
    );


    Pipeline_MEM Memory_Access(
        .zero_in_Mem(zero_out_EXMem),
        .sign_in_Mem(ALU_out_EXMem[31]),
        .Branch_in_Mem(Branch_out_EXMem),
        .Jump_in_Mem(Jump_out_EXMem),

        .PCSrc(PCSrc_MEM)
    );

    wire [31:0] PC4_out_MemWB; //PC+4输出
    wire [31:0] ALU_out_MemWB; //ALU输出
    wire [31:0] DMem_data_out_MemWB; //存储器数据输出
    wire [1:0] MemtoReg_out_MemWB; //写回

    MEM_reg_WB MEM_WB(
        .clk_MemWB(clk),
        .rst_MemWB(rst),
        .en_MemWB(1),
        .PC4_in_MemWB(PC4_out_EXMem),
        .Wt_addr_MemWB(Wt_addr_out_EXMem),
        .ALU_in_MemWB(ALU_out_EXMem),
        .Dmem_data_MemWB(Data_in),
        .MemtoReg_in_MemWB(MemtoReg_out_EXMem),
        .RegWrite_in_MemWB(RegWrite_out_EXMem),

        .PC4_out_MemWB(PC4_out_MemWB),
        .Wt_addr_out_MemWB(Wt_addr_out_MemWB),
        .ALU_out_MemWB(ALU_out_MemWB),
        .DMem_data_out_MemWB(DMem_data_out_MemWB),
        .MemtoReg_out_MemWB(MemtoReg_out_MemWB),
        .RegWrite_out_MemWB(RegWrite_out_MemWB)
    );
    Pipeline_WB Write_Back(
        .PC4_in_WB(PC4_out_MemWB),
        .ALU_in_WB(ALU_out_MemWB),
        .Dmem_data_WB(DMem_data_out_MemWB),
        .MemtoReg_in_WB(MemtoReg_out_MemWB),

        .Data_out_WB(Data_out_WB)
    );

    stall race(
        .rst_stall(rst),                //复位
        .RegWrite_out_IDEX(RegWrite_out_IDEX),        //执行阶段寄存器写控制
        .Rd_addr_out_IDEX(Wt_addr_out_IDEX),    //执行阶段寄存器写地址
        .RegWrite_out_EXMem(RegWrite_out_EXMem),       //访存阶段寄存器写控制
        .Rd_addr_out_EXMem(Wt_addr_out_EXMem),   //访存阶段寄存器写地址
        .Rs1_addr_ID(Rs1_addr_ID),         //译码阶段寄存器读地址1
        .Rs2_addr_ID(Rs2_addr_ID),         //译码阶段寄存器读地址2
        .Rs1_used(Rs1_used_ID),                 //Rs1被使用
        .Rs2_used(Rs2_used_ID),                 //Rs2被使用
    
        .PCSrc_MEMWB(PCSrc_MEM),

        .en_IF(en_IF),                   //流水线寄存器的使能及NOP信号
        .en_IFID(en_IFID),         
        .NOP_IFID(NOP_IFID),
        .NOP_IDEX(NOP_IDEX),
        .NOP_EXMEM(NOP_EXMEM)
    );

    // assign PC_out_IF = PC_out_IF;
    assign PC_out_ID = PC_out_IFID;
    assign inst_ID = inst_out_IFID;
    assign PC_out_Ex = PC_out_EX;
    assign MemRW_Ex = MemRW_out_IDEX;
    assign MemRW_Mem = MemRW_out_EXMem;
    assign Addr_out = ALU_out_EXMem;
    assign Data_out = Rs2_out_EXMem;
    // assign Data_out_WB = Data_out_WB; 
endmodule

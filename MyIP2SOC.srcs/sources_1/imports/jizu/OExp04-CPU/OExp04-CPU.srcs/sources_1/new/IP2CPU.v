`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/22/2021 03:31:32 PM
// Design Name: 
// Module Name: IP2CPU
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


module SCPU(
    input wire clk,rst,
    input wire MIO_ready,
    input wire [31:0] Data_in,
    input wire [31:0] inst_in,

    output wire [31:0] Addr_out,
    output wire [31:0] Data_out,
    output wire [31:0] PC_out,
    output wire MemRW,
    output wire CPU_MIO,
    
    // for debug
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

    wire ctrl_Jump,ctrl_Branch,ctrl_MemRW,ctrl_RegWrite,ctrl_CPU_MIO,ctrl_ALU_src_B;
    wire [1:0] ctrl_MemtoReg;
    wire [1:0] ctrl_ImmSel;
    wire [2:0] ctrl_ALU_Control;
    
    SCPU_ctrl SCPU_ctrl_ins(
        .OPcode(inst_in[6:2]),     //Instruction[6:2]
        .Fun3(inst_in[14:12]),       //Instruction[14:12]
        .Fun7(inst_in[30]),             //Instruction[30]
        .MIO_ready(MIO_ready),
    
        .ImmSel(ctrl_ImmSel),
        .ALU_Control(ctrl_ALU_Control),
        .MemtoReg(ctrl_MemtoReg),
        .ALU_src_B(ctrl_ALU_src_B),   
        .Jump(ctrl_Jump),
        .Branch(ctrl_Branch),
        .MemRW(ctrl_MemRW),
        .RegWrite(ctrl_RegWrite),
        .CPU_MIO(ctrl_CPU_MIO)
    );

    DataPath DataPath_ins(
        .ALUSrc_B   (ctrl_ALU_src_B),
        .ALU_Control(ctrl_ALU_Control),
        .Branch     (ctrl_Branch),
        .ImmSel     (ctrl_ImmSel),
        .Jump       (ctrl_Jump),
        .MentoReg   (ctrl_MemtoReg),
        .RegWrite   (ctrl_RegWrite),
        .clk(clk),      .rst(rst),
        .Data_in    (Data_in),
        .inst_field (inst_in),

        .ALU_out(Addr_out),
        .Data_out(Data_out),
        .PC_out(PC_out),
        
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
    
    assign MemRW = ctrl_MemRW;
endmodule

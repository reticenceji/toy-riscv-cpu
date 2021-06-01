`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/30/2021 10:49:09 AM
// Design Name: 
// Module Name: stall
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


module stall(
    input rst_stall,                //复位
    
    input RegWrite_out_IDEX,        //执行阶段寄存器写控制
    input [4:0]Rd_addr_out_IDEX,    //执行阶段寄存器写地址
    input RegWrite_out_EXMem,       //访存阶段寄存器写控制
    input [4:0]Rd_addr_out_EXMem,   //访存阶段寄存器写地址
    input [4:0]Rs1_addr_ID,         //译码阶段寄存器读地址1
    input [4:0]Rs2_addr_ID,         //译码阶段寄存器读地址2
    input Rs1_used,                 //Rs1被使用
    input Rs2_used,                 //Rs2被使用
    
    input PCSrc_MEMWB,
//    input Branch_ID,                //译码阶段beq
//    input Jump_ID,                  //译码阶段jal
//    input Branch_out_IDEX,          //执行阶段beq
//    input Jump_out_IDEX,            //执行阶段jal
//    input Branch_out_EXMem,         //访存阶段beq
//    input Jump_out_EXMem,           //访存阶段jal
    
    output reg en_IF,                   //流水线寄存器的使能及NOP信号
    output reg en_IFID,         
    output reg NOP_IFID,
    output reg NOP_IDEX,
    output reg NOP_EXMEM
    );
    
    always @(*) begin
        if (rst_stall) begin
            NOP_IFID = 0;
            NOP_IDEX = 0;
            NOP_EXMEM = 0;
            en_IF = 1;
            en_IFID = 1;
        end else
        // 控制冒险,我简单的假设跳转不发生.一旦发生跳转，把之后的三个周期执行的指令清空。ex,if,id都不会产生影响
        if (PCSrc_MEMWB == 1) begin
            NOP_IFID = 1;
            NOP_IDEX = 1;
            NOP_EXMEM = 1;
            en_IF = 1;
            en_IFID = 1;
        // 数据冒险，要观察EX和MEM阶段是不是要写我们即将在ID阶段读取的寄存器，当然x0不用考虑
        end else if ((RegWrite_out_IDEX==1 && Rs1_used==1 && Rs1_addr_ID!=0 && Rs1_addr_ID==Rd_addr_out_IDEX )
                    || (RegWrite_out_IDEX==1 && Rs2_used==1 && Rs2_addr_ID!=0 && Rs2_addr_ID==Rd_addr_out_IDEX ) 
                    || (RegWrite_out_EXMem == 1 && Rs1_used==1 && Rs1_addr_ID!=0 && Rs1_addr_ID==Rd_addr_out_EXMem)
                    || (RegWrite_out_EXMem == 1 && Rs1_used==1 && Rs1_addr_ID!=0 && Rs1_addr_ID==Rd_addr_out_EXMem)) begin
            NOP_IFID = 0;
            NOP_IDEX = 1;
            NOP_EXMEM = 0;
            en_IF = 0;
            en_IFID = 0;
        end else begin
            NOP_IFID = 0;
            NOP_IDEX = 0;
            NOP_EXMEM = 0;
            en_IF = 1;
            en_IFID = 1;
        end
    end
            
endmodule

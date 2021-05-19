`timescale 1ns / 1ps
/* 存储器访问是指存储器访问指令将数据从存储器读出，或者写入存储器的过程
 * 但是实际上由于SRAM是单独的一个模块，所以说功能没有在下面体现
 */
module Pipeline_MEM (
    input zero_in_Mem,          //zero
    input sign_in_Mem,          //ALU[31]
    input [3:0] Branch_in_Mem,  //branch
    input Jump_in_Mem,          //jal

    output PCSrc                //PC选择控制输出
);
    parameter                   // for B_opcode
        BEQ_choose = 3'b000,
        BNE_choose = 3'b001,
        BLT_choose = 3'b100,
        BGE_choose = 3'b101;

    assign PCSrc =  Jump_in_Mem == 1 ? 1 :
                    Branch_in_Mem[3] == 0 ? 0 : 
                    Branch_in_Mem[2:0] == BEQ_choose ? zero_in_Mem :
                    Branch_in_Mem[2:0] == BNE_choose ? ~zero_in_Mem :
                    Branch_in_Mem[2:0] == BLT_choose ? sign_in_Mem :
                    Branch_in_Mem[2:0] == BGE_choose ? ~sign_in_Mem : 
                    0 ;

endmodule //Pipeline_MEM

module MEM_reg_WB (
    input clk_MemWB, //寄存器时
    input rst_MemWB, //寄存器复位
    input en_MemWB, //寄存器使能

    input[31:0] PC4_in_MemWB, //PC+4输入
    input[4:0] Wt_addr_MemWB, //写目的地址输入
    input[31:0] ALU_in_MemWB, //ALU输入
    input[31:0] Dmem_data_MemWB, //存储器数据输入
    input[1:0] MemtoReg_in_MemWB, //写回
    input RegWrite_in_MemWB, //寄存器堆读写

    output [31:0] PC4_out_MemWB, //PC+4输出
    output [4:0] Wt_addr_out_MemWB, //写目的地址输出
    output [31:0] ALU_out_MemWB, //ALU输出
    output [31:0] DMem_data_out_MemWB, //存储器数据输出
    output [1:0] MemtoReg_out_MemWB, //写回
    output RegWrite_out_MemWB //寄存器堆读写);
);
    assign PC4_out_MemWB        = rst_MemWB==1? 0 : PC4_in_MemWB        ;
    assign Wt_addr_out_MemWB    = rst_MemWB==1? 0 : Wt_addr_MemWB       ;
    assign ALU_out_MemWB        = rst_MemWB==1? 0 : ALU_in_MemWB        ;
    assign DMem_data_out_MemWB  = rst_MemWB==1? 0 : Dmem_data_MemWB     ;
    assign MemtoReg_out_MemWB   = rst_MemWB==1? 0 : MemtoReg_in_MemWB   ;
    assign RegWrite_out_MemWB   = rst_MemWB==1? 0 : RegWrite_in_MemWB   ;
endmodule //MEM_reg_WB
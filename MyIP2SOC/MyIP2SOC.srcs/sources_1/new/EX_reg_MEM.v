module EX_reg_MEM (
    input clk_EXMem, //寄存器时钟
    input rst_EXMem, //寄存器复位
    input en_EXMem, //寄存器使能

    input[31:0] PC_in_EXMem, //PC输入
    input[31:0] PC4_in_EXMem, //PC+4输入
    input [4:0] Wt_addr_EXMem, //写目的寄存器地址输入
    input zero_in_EXMem, //zero
    input[31:0] ALU_in_EXMem, //ALU输入
    input[31:0] Rs2_in_EXMem, //操作数2输入
    input [3:0] Branch_in_EXMem, //Branch
    input MemRW_in_EXMem, //存储器读写
    input Jump_in_EXMem, //Jal
    input [1:0] MemtoReg_in_EXMem, //写回
    input RegWrite_in_EXMem, //寄存器堆读写

    output reg[31:0] PC_out_EXMem, //PC输出
    output reg[31:0] PC4_out_EXMem, //PC+4输出
    output reg[4:0] Wt_addr_out_EXMem, //写目的寄存器输出
    output reg zero_out_EXMem, //zero
    output reg[31:0] ALU_out_EXMem, //ALU输出
    output reg[31:0] Rs2_out_EXMem, //操作数2输出
    output reg [3:0] Branch_out_EXMem, //Branch
    output reg MemRW_out_EXMem, //存储器读写
    output reg Jump_out_EXMem, //Jal
    output reg MemtoReg_out_EXMem, //写回
    output reg RegWrite_out_EXMem //寄存器堆读写
);

    always @(posedge clk_EXMem or posedge rst_EXMem) begin
        if (rst_EXMem==1) begin
            PC_out_EXMem <= 0;
            PC4_out_EXMem <= 0;
            Wt_addr_out_EXMem <= 0;
            zero_out_EXMem <= 0;
            ALU_out_EXMem <= 0;
            Rs2_out_EXMem <= 0;
            Branch_out_EXMem <= 0;
            MemRW_out_EXMem <= 0;
            Jump_out_EXMem <= 0;
            MemtoReg_out_EXMem <= 0;
            RegWrite_out_EXMem <= 0;
        end 
        else begin
            PC_out_EXMem <= PC_in_EXMem;
            PC4_out_EXMem <= PC4_in_EXMem;
            Wt_addr_out_EXMem <= Wt_addr_EXMem;
            zero_out_EXMem <= zero_in_EXMem;
            ALU_out_EXMem <= ALU_in_EXMem;
            Rs2_out_EXMem <= Rs2_in_EXMem;
            Branch_out_EXMem <= Branch_in_EXMem;
            MemRW_out_EXMem <= MemRW_in_EXMem;
            Jump_out_EXMem <= Jump_in_EXMem;
            MemtoReg_out_EXMem <= MemtoReg_in_EXMem;
            RegWrite_out_EXMem <= RegWrite_in_EXMem;
        end
    end
endmodule //EX_reg_MEM
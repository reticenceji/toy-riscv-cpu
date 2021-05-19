`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2021 03:53:02 PM
// Design Name: 
// Module Name: SCPU_tb
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


module SCPU_tb(    
    output [1:0] ImmSel,
    output [2:0] ALU_Control,
    output [1:0] MemtoReg,
    output ALU_src_B,   //
    output Jump,Branch,MemRW,RegWrite,CPU_MIO
    );
    reg [4:0] OPcode;
    reg [2:0] Fun3;
    reg [2:0] Fun_ecall;
    reg [1:0] Fun_mret;
    reg Fun7;
    reg MIO_ready;
    initial begin
        // Initialize Inputs
        OPcode = 0;
        Fun3 = 0;
        Fun7 = 0;
        MIO_ready = 0;
        #40;
        // Wait 40 ns for global reset to finish。以上是测试模板代码。
        // Add stimulus here
        //检查输出信号和关
        OPcode = 5'b11100;
        Fun_ecall = 3'b000;
        #20;
        OPcode = 5'b11100;
        Fun_ecall = 3'b010;
        Fun_mret = 3'b11;
        #20;
        OPcode = 5'b11111;
        #20;
        OPcode = 5'b01100; //ALU指令，检查 ALUop=2'b00; RegWrite=1
        Fun3 = 3'b000; Fun7 = 1'b0;//add,检查ALU_Control=3'b010
        #20;
        Fun3 = 3'b000; Fun7 = 1'b1;//sub,检查ALU_Control=3'b110
        #20;
        Fun3 = 3'b111; Fun7 = 1'b0;//and,检查ALU_Control=3'b000
        #20;
        Fun3 = 3'b110; Fun7 = 1'b0;//or,检查ALU_Control=3'b001
        #20;
        Fun3 = 3'b010; Fun7 = 1'b0 ;//slt,检查ALU_Control=3'b111
        #20;
        Fun3 = 3'b101; Fun7 = 1'b0;//srl,检查ALU_Control=3'b101
        #20;
        Fun3 = 3'b100; Fun7 = 1'b0;//xor,检查ALU_Control=3'b011
        #20;
        Fun3 = 3'b111; Fun7 = 1'b1; //间隔
        #20;
        OPcode = 5'b00000;//load指令，检查 ALUop=2'b01,
        #20; // ALUSrc_B=1, MemtoReg=1, RegWrite=1
        OPcode = 5'b01000;
        #20; //store指令，检查ALUop=2'b10, MemRW=1, ALUSrc_B=1
        OPcode = 5'b11000;//beq指令，检查 ALUop=2'b11, Branch=1
        #20;
        OPcode = 5'b11011;//jump指令，检查 Jump=1
        OPcode = 5'b00100; //I指令，检查 ALUop=2'b01; RegWrite=1
        #20;
        Fun3 = 3'b000; //addi,检查ALU_Control=3'b010
        #20;
        OPcode = 5'h1f; //间隔
        Fun3 = 3'b000; Fun7 = 1'b0; //间隔
    end

    SCPU_ctrl SCPU_C(
        .OPcode(OPcode),
        .Fun7(Fun7),
        .Fun3(Fun3),
        .MIO_ready(MIO_ready),
        .Fun_mret(Fun_mret),
        .Fun_ecall(Fun_ecall),
        
        .ImmSel(ImmSel),
        .ALU_Control(ALU_Control),
        .MemtoReg(MemtoReg),
        .ALU_src_B(ALU_src_B),  
        .Jump(Jump),
        .Branch(Branch),
        .MemRW(MemRW),
        .RegWrite(RegWrite),
        .CPU_MIO(CPU_MIO)
    );
    
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2021 02:43:28 PM
// Design Name: 
// Module Name: SCPU_ctrl
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


module SCPU_ctrl(
    input [4:0] OPcode,     //Instruction[6:2]
    input [2:0] Fun3,       //Instruction[14:12]
    input Fun7,             //Instruction[30]
    input MIO_ready,
    
    output reg [1:0] ImmSel,
    output reg [2:0] ALU_Control,
    output reg [1:0] MemtoReg,
    output reg ALU_src_B,   //
    output reg Jump,Branch,MemRW,RegWrite,CPU_MIO
    );
    
    parameter 
        B_opcode=5'b11000,      //beq,bne,bge
        R_opcode=5'b01100,      //add,sub.or,and,xor
        S_opcode=5'b01000,      //sd,sw,
        L_opcode=5'b00000,      //ld,lw
        JAL_opcode=5'b11011,    //jal
        I_opcode = 5'b00100;    //addi,slti,xori,ori,andi
    parameter                   // for ALU_SrcB
        REG_choose = 0,
        IMM_choose = 1;
    parameter                   // for ALU_Control
        AND_choose = 3'b000,
        OR_choose  = 3'b001,
        ADD_choose = 3'b010,
        SUB_choose = 3'b110,
        SLTI_choose =3'b111,
        NOR_choose = 3'b100,
        SRL_choose = 3'b101,
        XOR_choose = 3'b011; 

    always @(*) begin
        case (OPcode)
            L_opcode: ImmSel <= 2'b00;
            I_opcode: ImmSel <= 2'b00;
            S_opcode: ImmSel <= 2'b01;
            B_opcode: ImmSel <= 2'b10;
            JAL_opcode: ImmSel <= 2'b11;
            //R_opcode: don't care
            default: ImmSel <= 2'b00;
        endcase
        
        // case
        case (OPcode)
            B_opcode: ALU_Control <= SUB_choose;
            S_opcode: ALU_Control <= ADD_choose;
            L_opcode: ALU_Control <= ADD_choose;
            I_opcode:
                case (Fun3)
                    3'b000: ALU_Control <= ADD_choose;
                    3'b010: ALU_Control <= SLTI_choose;
                    3'b100: ALU_Control <= XOR_choose;
                    3'b110: ALU_Control <= OR_choose;
                    3'b111: ALU_Control <= AND_choose;
                    3'b101: ALU_Control <= SRL_choose;
                    default: ALU_Control <= ADD_choose;
                endcase
            R_opcode:
                case (Fun3)
                    3'b000: ALU_Control <= (Fun7==0)?ADD_choose:SUB_choose;
                    3'b010: ALU_Control <= SLTI_choose;
                    3'b100: ALU_Control <= XOR_choose;
                    3'b110: ALU_Control <= OR_choose;
                    3'b111: ALU_Control <= AND_choose;
                    3'b101: ALU_Control <= SRL_choose;
                    default: ALU_Control <= ADD_choose;
                endcase
            //JAL_opcode:  don't care
            default: ALU_Control <= ADD_choose;
        endcase

        MemtoReg <= (OPcode == JAL_opcode)?2:((OPcode==L_opcode)?1:0);
        ALU_src_B <= (OPcode==R_opcode || OPcode==B_opcode)?REG_choose:IMM_choose;   
        Jump <= (OPcode==JAL_opcode)?1:0;   
        Branch <= (OPcode == B_opcode)?1:0;     
        RegWrite <= (OPcode == I_opcode || OPcode == R_opcode || OPcode==L_opcode || OPcode==JAL_opcode)?1:0;
        MemRW <= (OPcode == S_opcode)?1:0; 
        CPU_MIO <= 0;    // not use
    end
    
endmodule

module Branch_ctrl(
    input wire [3:0] func,
    input wire sign,
    input wire zero,

    output wire is_branch 
    );
    parameter                   // for B_opcode
        BEQ_choose = 3'b000,
        BNE_choose = 3'b001,
        BLT_choose = 3'b100,
        BGE_choose = 3'b101;

    assign is_branch =  func[3] == 0 ? 0 : 
                        func[2:0] == BEQ_choose ? zero :
                        func[2:0] == BNE_choose ? ~zero :
                        func[2:0] == BLT_choose ? (sign==1?1:0) :
                        func[2:0] == BGE_choose ? (sign==0?1:0) : 
                        0 ;
endmodule

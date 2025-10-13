module BranchUnit(
    input  logic [31:0] ru_rs1,
    input  logic [31:0] ru_rs2,
    input  logic [4:0]  BrOp,
    output logic        NextPCsrc
);

    always @* begin
        
        NextPCsrc = 1'b0;

        casez (BrOp)
            5'b00???: NextPCsrc = 1'b0; // No branch

            5'b01000: NextPCsrc = (ru_rs1 == ru_rs2);                                  // BEQ
            5'b01001: NextPCsrc = (ru_rs1 != ru_rs2);                                  // BNE
            5'b01100: NextPCsrc = ($signed(ru_rs1) <  $signed(ru_rs2));                // BLT
            5'b01101: NextPCsrc = ($signed(ru_rs1) >= $signed(ru_rs2));                // BGE
            5'b01110: NextPCsrc = ($unsigned(ru_rs1) <  $unsigned(ru_rs2));            // BLTU
            5'b01111: NextPCsrc = ($unsigned(ru_rs1) >= $unsigned(ru_rs2));            // BGEU

            5'b1????: NextPCsrc = 1'b1; // Unconditional jump (JAL, JALR)

            default : NextPCsrc = 1'b0;
        endcase
    end

endmodule
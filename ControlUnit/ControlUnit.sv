module ControlUnit(
    input logic [6:0] OpCode,
    input logic [2:0] Funct3,
    input logic [6:0] Funct7,

    output logic       RUWr,
    output logic       ALUASrc,
    output logic       ALUBSrc,
    output logic [3:0] ALUOp,
    output logic [2:0] ImmSrc,
    output logic [4:0] BrOp,
    output logic       DMWr,
    output logic [2:0] DMCtrl,
    output logic [1:0] RUDataWrSrc
);

    // OpCode values
    localparam  R_TYPE_OPCODE  = 7'b0110011,
                I_TYPE_OPCODE  = 7'b0010011,
                L_TYPE_OPCODE  = 7'b0000011,
                JALR_OPCODE    = 7'b1100111,
                B_TYPE_OPCODE  = 7'b1100011,
                S_TYPE_OPCODE  = 7'b0100011,
                JAL_OPCODE     = 7'b1101111,
                LUI_OPCODE     = 7'b0110111,
                AUIPC_OPCODE   = 7'b0010111;

    // funct3 values
    localparam  FUNCT3_ADD_SUB = 3'b000,
                FUNCT3_SRL_SRA = 3'b101;

    // funct7 values
    localparam  FUNCT7_NORMAL = 7'b0000000,  // ADD, SRL
                FUNCT7_ALT    = 7'b0100000;  // SUB, SRA

    // ALUOp values
    localparam  ALU_ADD    = 4'b0000,
                ALU_SUB    = 4'b1000,
                ALU_SRL    = 4'b0101,
                ALU_SRA    = 4'b1101,
                ALU_PASS_B = 4'b1001;

    always @* begin
        // Default values to avoid latches
        RUWr        = 1'b0;
        ALUASrc     = 1'b0;
        ALUBSrc     = 1'b0;
        ALUOp       = ALU_ADD;
        ImmSrc      = 3'b000;
        BrOp        = 5'b00000;
        DMWr        = 1'b0;
        DMCtrl      = 3'b000;
        RUDataWrSrc = 2'b00;

        case (OpCode)
            R_TYPE_OPCODE: begin
                RUWr  = 1'b1;
                ALUOp = (Funct3 == FUNCT3_ADD_SUB) ? ((Funct7 == FUNCT7_NORMAL) ? ALU_ADD : ALU_SUB) :
                        (Funct3 == FUNCT3_SRL_SRA) ? ((Funct7 == FUNCT7_NORMAL) ? ALU_SRL : ALU_SRA) :
                        {1'b0, Funct3};
            end

            I_TYPE_OPCODE: begin
                RUWr    = 1'b1;
                ALUBSrc = 1'b1;
                ALUOp   = (Funct3 == FUNCT3_SRL_SRA && Funct7 == FUNCT7_ALT) ? ALU_SRA : {1'b0, Funct3};
            end

            L_TYPE_OPCODE: begin
                RUWr        = 1'b1;
                ALUBSrc     = 1'b1;
                RUDataWrSrc = 2'b01;
                DMCtrl      = Funct3;
            end

            JALR_OPCODE: begin
                RUWr        = 1'b1;
                ALUBSrc     = 1'b1;
                BrOp        = 5'b10000;
                RUDataWrSrc = 2'b10;
            end

            B_TYPE_OPCODE: begin
                ALUASrc = 1'b1;
                ALUBSrc = 1'b1;
                ImmSrc  = 3'b101;
                BrOp    = {2'b01, Funct3};
            end

            S_TYPE_OPCODE: begin
                ALUBSrc = 1'b1;
                DMWr    = 1'b1;
                ImmSrc  = 3'b001;
                DMCtrl  = Funct3;
            end

            JAL_OPCODE: begin
                RUWr        = 1'b1;
                ALUASrc     = 1'b1;
                ALUBSrc     = 1'b1;
                BrOp        = 5'b10000;
                RUDataWrSrc = 2'b10;
                ImmSrc      = 3'b110;
            end

            LUI_OPCODE: begin
                RUWr    = 1'b1;
                ALUBSrc = 1'b1;
                ALUOp   = ALU_PASS_B;
                ImmSrc  = 3'b010;
            end

            AUIPC_OPCODE: begin
                RUWr    = 1'b1;
                ALUASrc = 1'b1;
                ALUBSrc = 1'b1;
                ImmSrc  = 3'b010;
            end
        endcase
    end

endmodule
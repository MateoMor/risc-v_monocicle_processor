module ALU(
    input logic signed [31:0] A,
    input logic signed [31:0] B,

    input logic [3:0] ALUOp,

    output logic signed [31:0] ALURes = 0
);

    // ALUOp
    localparam  ALU_ADD = 4'b0000,
                ALU_SUB = 4'b1000,
                ALU_SLL = 4'b0001,
                ALU_SLT = 4'b0010,
                ALU_SLTU= 4'b0011,
                ALU_XOR = 4'b0100,
                ALU_SRL = 4'b0101,
                ALU_SRA = 4'b1101,
                ALU_OR  = 4'b0110,
                ALU_AND = 4'b0111;

    // It executes each time any input changes
    always @* begin
        case(ALUOp)
            ALU_ADD: ALURes = A + B; // ADD
            ALU_SUB: ALURes = A - B; // SUB
            ALU_SLL: ALURes = A << B; // SLL
            ALU_SLT: ALURes = A < B; // SLT
            ALU_SLTU: ALURes = $unsigned(A) < $unsigned(B); // SLTU
            ALU_XOR: ALURes = A ^ B; // XOR
            ALU_SRL: ALURes = A >> B; // SRL
            ALU_SRA: ALURes = A >>> B; // SRA
            ALU_OR: ALURes = A | B; // OR
            ALU_AND: ALURes = A & B; // AND
            4'b1001: ALURes = B;
        endcase
    end
endmodule
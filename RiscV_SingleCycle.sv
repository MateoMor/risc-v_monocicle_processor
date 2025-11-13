module RiscV_SingleCycle #(
    parameter IMEM_SIZE = 128,  // Number of instructions                         
    parameter PROGRAM_FILE = "test_programs/program.hex" // File to load
)(
    input logic clk,
    input logic reset
);

    // ========== Internal Wires ==========
    
    // Program Counter
    wire [31:0] PC;
    wire [31:0] NextPC;
    wire [31:0] PC_plus_4;
    
    // Instruction Memory
    wire [31:0] Instruction;
    
    // Instruction fields
    wire [6:0] OpCode;
    wire [4:0] rd, rs1, rs2;
    wire [2:0] Funct3;
    wire [6:0] Funct7;
    wire [24:0] InmediateBits;
    
    // Control Unit signals
    wire       RUWr;
    wire       ALUASrc;
    wire       ALUBSrc;
    wire [3:0] ALUOp;
    wire [2:0] ImmSrc;
    wire [4:0] BrOp;
    wire       DMWr;
    wire [2:0] DMCtrl;
    wire [1:0] RUDataWrSrc;
    
    // Register Unit
    wire [31:0] ru_rs1;
    wire [31:0] ru_rs2;
    wire [31:0] RU_DataWr;
    
    // Immediate Generator
    wire [31:0] ImmExt;
    
    // ALU inputs and output
    wire [31:0] ALU_A;
    wire [31:0] ALU_B;
    wire [31:0] ALURes;
    
    // Branch Unit
    wire NextPCsrc;
    
    // Data Memory
    wire [31:0] DataRd;
    
    
    // ========== Instruction Decoding ==========
    assign OpCode        = Instruction[6:0];
    assign rd            = Instruction[11:7];
    assign Funct3        = Instruction[14:12];
    assign rs1           = Instruction[19:15];
    assign rs2           = Instruction[24:20];
    assign Funct7        = Instruction[31:25];
    assign InmediateBits = Instruction[31:7];
    
    // PC + 4 calculation
    assign PC_plus_4 = PC + 32'd4;
    
    
    // ========== Module Instantiations ==========
    
    // Program Counter
    ProgramCounter pc_inst (
        .clk(clk),
        .reset(reset),
        .next_pc(NextPC),
        .pc(PC)
    );
    
    // Instruction Memory
    InstructionMemory #(
        .MEM_SIZE(IMEM_SIZE),
        .PROGRAM_FILE(PROGRAM_FILE)
    ) imem_inst (
        .address(PC),
        .instruction(Instruction)
    );
    
    // Control Unit
    ControlUnit control_inst (
        .OpCode(OpCode),
        .Funct3(Funct3),
        .Funct7(Funct7),
        .RUWr(RUWr),
        .ALUASrc(ALUASrc),
        .ALUBSrc(ALUBSrc),
        .ALUOp(ALUOp),
        .ImmSrc(ImmSrc),
        .BrOp(BrOp),
        .DMWr(DMWr),
        .DMCtrl(DMCtrl),
        .RUDataWrSrc(RUDataWrSrc)
    );
    
    // Register Unit
    RegistersUnit reg_unit_inst (
        .clk(clk),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .DataWR(RU_DataWr),
        .RUWr(RUWr),
        .ru_rs1(ru_rs1),
        .ru_rs2(ru_rs2)
    );
    
    // Immediate Generator
    ImmGen immgen_inst (
        .InmediateBits(InmediateBits),
        .ImmSrc(ImmSrc),
        .ImmExt(ImmExt)
    );
    
    // ALU Input A Multiplexer
    ALUA mux_alua_inst (
        .ALUAsrc(ALUASrc),
        .PC(PC),
        .ru_rs1(ru_rs1),
        .A(ALU_A)
    );
    
    // ALU Input B Multiplexer
    ALUB mux_alub_inst (
        .ALUBsrc(ALUBSrc),
        .ru_rs2(ru_rs2),
        .ImmExt(ImmExt),
        .B(ALU_B)
    );
    
    // ALU
    ALU alu_inst (
        .A(ALU_A),
        .B(ALU_B),
        .ALUOp(ALUOp),
        .ALURes(ALURes)
    );
    
    // Branch Unit
    BranchUnit branch_inst (
        .ru_rs1(ru_rs1),
        .ru_rs2(ru_rs2),
        .BrOp(BrOp),
        .NextPCsrc(NextPCsrc)
    );
    
    // Data Memory
    DataMemory dmem_inst (
        .Address(ALURes),
        .DataWr(ru_rs2),
        .DMWr(DMWr),
        .DMCtrl(DMCtrl),
        .DataRd(DataRd)
    );
    
    // Register Write Data Multiplexer
    RUDataWr mux_ru_data_inst (
        .RUDataWrSrc(RUDataWrSrc),
        .PC_with_offset(PC_plus_4),
        .DataRd(DataRd),
        .ALURes(ALURes),
        .DataWr(RU_DataWr)
    );
    
    // Next PC Multiplexer
    NextPC mux_nextpc_inst (
        .NextPCsrc(NextPCsrc),
        .PC_with_offset(PC_plus_4),
        .ALURes(ALURes),
        .NextPC(NextPC)
    );

endmodule

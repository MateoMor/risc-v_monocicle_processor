`timescale 1ns/1ps

module ControlUnit_tb;

    logic [6:0] OpCode;
    logic [2:0] Funct3;
    logic [6:0] Funct7;

    logic       RUWr;
    logic       ALUASrc;
    logic       ALUBSrc;
    logic [3:0] ALUOp;
    logic [2:0] ImmSrc;
    logic [4:0] BrOp;
    logic       DMWr;
    logic [2:0] DMCtrl;
    logic [1:0] RUDataWrSrc;

    ControlUnit dut (
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

    // OpCode values
    localparam logic [6:0]
        R_TYPE_OPCODE  = 7'b0110011,
        I_TYPE_OPCODE  = 7'b0010011,
        L_TYPE_OPCODE  = 7'b0000011,
        JALR_OPCODE    = 7'b1100111,
        B_TYPE_OPCODE  = 7'b1100011,
        S_TYPE_OPCODE  = 7'b0100011,
        JAL_OPCODE     = 7'b1101111,
        LUI_OPCODE     = 7'b0110111,
        AUIPC_OPCODE   = 7'b0010111;

    // funct3 values for R-type and I-type
    localparam logic [2:0]
        FUNCT3_ADD_SUB = 3'b000,
        FUNCT3_SLL     = 3'b001,
        FUNCT3_SLT     = 3'b010,
        FUNCT3_SLTU    = 3'b011,
        FUNCT3_XOR     = 3'b100,
        FUNCT3_SRL_SRA = 3'b101,
        FUNCT3_OR      = 3'b110,
        FUNCT3_AND     = 3'b111;

    // funct3 values for Branch
    localparam logic [2:0]
        FUNCT3_BEQ  = 3'b000,
        FUNCT3_BNE  = 3'b001,
        FUNCT3_BLT  = 3'b100,
        FUNCT3_BGE  = 3'b101,
        FUNCT3_BLTU = 3'b110,
        FUNCT3_BGEU = 3'b111;

    // funct3 values for Load/Store
    localparam logic [2:0]
        FUNCT3_B  = 3'b000,  // Byte
        FUNCT3_H  = 3'b001,  // Halfword
        FUNCT3_W  = 3'b010,  // Word
        FUNCT3_BU = 3'b100,  // Byte Unsigned
        FUNCT3_HU = 3'b101;  // Halfword Unsigned

    // funct7 values
    localparam logic [6:0]
        FUNCT7_NORMAL = 7'b0000000,
        FUNCT7_ALT    = 7'b0100000;

    // ALUOp values
    localparam logic [3:0]
        ALU_ADD    = 4'b0000,
        ALU_SUB    = 4'b1000,
        ALU_SLL    = 4'b0001,
        ALU_SLT    = 4'b0010,
        ALU_SLTU   = 4'b0011,
        ALU_XOR    = 4'b0100,
        ALU_SRL    = 4'b0101,
        ALU_SRA    = 4'b1101,
        ALU_OR     = 4'b0110,
        ALU_AND    = 4'b0111,
        ALU_PASS_B = 4'b1001;

    int error_count;

    task automatic check_control_signals(
        input string label,
        input logic [6:0] opcode,
        input logic [2:0] funct3,
        input logic [6:0] funct7,
        input logic       exp_RUWr,
        input logic       exp_ALUASrc,
        input logic       exp_ALUBSrc,
        input logic [3:0] exp_ALUOp,
        input logic [2:0] exp_ImmSrc,
        input logic [4:0] exp_BrOp,
        input logic       exp_DMWr,
        input logic [2:0] exp_DMCtrl,
        input logic [1:0] exp_RUDataWrSrc
    );
        begin
            OpCode = opcode;
            Funct3 = funct3;
            Funct7 = funct7;
            #1;

            if (RUWr !== exp_RUWr || ALUASrc !== exp_ALUASrc || ALUBSrc !== exp_ALUBSrc ||
                ALUOp !== exp_ALUOp || ImmSrc !== exp_ImmSrc || BrOp !== exp_BrOp ||
                DMWr !== exp_DMWr || DMCtrl !== exp_DMCtrl || RUDataWrSrc !== exp_RUDataWrSrc) begin
                
                $error("❌ %s FALLÓ", label);
                if (RUWr !== exp_RUWr)
                    $error("   RUWr: %b (esperado %b)", RUWr, exp_RUWr);
                if (ALUASrc !== exp_ALUASrc)
                    $error("   ALUASrc: %b (esperado %b)", ALUASrc, exp_ALUASrc);
                if (ALUBSrc !== exp_ALUBSrc)
                    $error("   ALUBSrc: %b (esperado %b)", ALUBSrc, exp_ALUBSrc);
                if (ALUOp !== exp_ALUOp)
                    $error("   ALUOp: %04b (esperado %04b)", ALUOp, exp_ALUOp);
                if (ImmSrc !== exp_ImmSrc)
                    $error("   ImmSrc: %03b (esperado %03b)", ImmSrc, exp_ImmSrc);
                if (BrOp !== exp_BrOp)
                    $error("   BrOp: %05b (esperado %05b)", BrOp, exp_BrOp);
                if (DMWr !== exp_DMWr)
                    $error("   DMWr: %b (esperado %b)", DMWr, exp_DMWr);
                if (DMCtrl !== exp_DMCtrl)
                    $error("   DMCtrl: %03b (esperado %03b)", DMCtrl, exp_DMCtrl);
                if (RUDataWrSrc !== exp_RUDataWrSrc)
                    $error("   RUDataWrSrc: %02b (esperado %02b)", RUDataWrSrc, exp_RUDataWrSrc);
                error_count++;
            end else begin
                $display("✅ %s", label);
            end
        end
    endtask

    initial begin
        $dumpfile("ControlUnit_tb.vcd");
        $dumpvars(0, ControlUnit_tb);

        OpCode = '0;
        Funct3 = '0;
        Funct7 = '0;
        error_count = 0;

        $display("\n=== Testing R-Type Instructions ===");
        check_control_signals("ADD",  R_TYPE_OPCODE, FUNCT3_ADD_SUB, FUNCT7_NORMAL, 
            1'b1, 1'b0, 1'b0, ALU_ADD, 3'b000, 5'b00000, 1'b0, 3'b000, 2'b00);
        
        check_control_signals("SUB",  R_TYPE_OPCODE, FUNCT3_ADD_SUB, FUNCT7_ALT, 
            1'b1, 1'b0, 1'b0, ALU_SUB, 3'b000, 5'b00000, 1'b0, 3'b000, 2'b00);
        
        check_control_signals("SLL",  R_TYPE_OPCODE, FUNCT3_SLL, FUNCT7_NORMAL, 
            1'b1, 1'b0, 1'b0, ALU_SLL, 3'b000, 5'b00000, 1'b0, 3'b000, 2'b00);
        
        check_control_signals("SLT",  R_TYPE_OPCODE, FUNCT3_SLT, FUNCT7_NORMAL, 
            1'b1, 1'b0, 1'b0, ALU_SLT, 3'b000, 5'b00000, 1'b0, 3'b000, 2'b00);
        
        check_control_signals("SLTU", R_TYPE_OPCODE, FUNCT3_SLTU, FUNCT7_NORMAL, 
            1'b1, 1'b0, 1'b0, ALU_SLTU, 3'b000, 5'b00000, 1'b0, 3'b000, 2'b00);
        
        check_control_signals("XOR",  R_TYPE_OPCODE, FUNCT3_XOR, FUNCT7_NORMAL, 
            1'b1, 1'b0, 1'b0, ALU_XOR, 3'b000, 5'b00000, 1'b0, 3'b000, 2'b00);
        
        check_control_signals("SRL",  R_TYPE_OPCODE, FUNCT3_SRL_SRA, FUNCT7_NORMAL, 
            1'b1, 1'b0, 1'b0, ALU_SRL, 3'b000, 5'b00000, 1'b0, 3'b000, 2'b00);
        
        check_control_signals("SRA",  R_TYPE_OPCODE, FUNCT3_SRL_SRA, FUNCT7_ALT, 
            1'b1, 1'b0, 1'b0, ALU_SRA, 3'b000, 5'b00000, 1'b0, 3'b000, 2'b00);
        
        check_control_signals("OR",   R_TYPE_OPCODE, FUNCT3_OR, FUNCT7_NORMAL, 
            1'b1, 1'b0, 1'b0, ALU_OR, 3'b000, 5'b00000, 1'b0, 3'b000, 2'b00);
        
        check_control_signals("AND",  R_TYPE_OPCODE, FUNCT3_AND, FUNCT7_NORMAL, 
            1'b1, 1'b0, 1'b0, ALU_AND, 3'b000, 5'b00000, 1'b0, 3'b000, 2'b00);

        $display("\n=== Testing I-Type Instructions ===");
        check_control_signals("ADDI",  I_TYPE_OPCODE, FUNCT3_ADD_SUB, FUNCT7_NORMAL, 
            1'b1, 1'b0, 1'b1, ALU_ADD, 3'b000, 5'b00000, 1'b0, 3'b000, 2'b00);
        
        check_control_signals("SLTI",  I_TYPE_OPCODE, FUNCT3_SLT, FUNCT7_NORMAL, 
            1'b1, 1'b0, 1'b1, ALU_SLT, 3'b000, 5'b00000, 1'b0, 3'b000, 2'b00);
        
        check_control_signals("SLTIU", I_TYPE_OPCODE, FUNCT3_SLTU, FUNCT7_NORMAL, 
            1'b1, 1'b0, 1'b1, ALU_SLTU, 3'b000, 5'b00000, 1'b0, 3'b000, 2'b00);
        
        check_control_signals("XORI",  I_TYPE_OPCODE, FUNCT3_XOR, FUNCT7_NORMAL, 
            1'b1, 1'b0, 1'b1, ALU_XOR, 3'b000, 5'b00000, 1'b0, 3'b000, 2'b00);
        
        check_control_signals("ORI",   I_TYPE_OPCODE, FUNCT3_OR, FUNCT7_NORMAL, 
            1'b1, 1'b0, 1'b1, ALU_OR, 3'b000, 5'b00000, 1'b0, 3'b000, 2'b00);
        
        check_control_signals("ANDI",  I_TYPE_OPCODE, FUNCT3_AND, FUNCT7_NORMAL, 
            1'b1, 1'b0, 1'b1, ALU_AND, 3'b000, 5'b00000, 1'b0, 3'b000, 2'b00);
        
        check_control_signals("SLLI",  I_TYPE_OPCODE, FUNCT3_SLL, FUNCT7_NORMAL, 
            1'b1, 1'b0, 1'b1, ALU_SLL, 3'b000, 5'b00000, 1'b0, 3'b000, 2'b00);
        
        check_control_signals("SRLI",  I_TYPE_OPCODE, FUNCT3_SRL_SRA, FUNCT7_NORMAL, 
            1'b1, 1'b0, 1'b1, ALU_SRL, 3'b000, 5'b00000, 1'b0, 3'b000, 2'b00);
        
        check_control_signals("SRAI",  I_TYPE_OPCODE, FUNCT3_SRL_SRA, FUNCT7_ALT, 
            1'b1, 1'b0, 1'b1, ALU_SRA, 3'b000, 5'b00000, 1'b0, 3'b000, 2'b00);

        $display("\n=== Testing Load Instructions ===");
        check_control_signals("LB",  L_TYPE_OPCODE, FUNCT3_B, 7'b0, 
            1'b1, 1'b0, 1'b1, ALU_ADD, 3'b000, 5'b00000, 1'b0, FUNCT3_B, 2'b01);
        
        check_control_signals("LH",  L_TYPE_OPCODE, FUNCT3_H, 7'b0, 
            1'b1, 1'b0, 1'b1, ALU_ADD, 3'b000, 5'b00000, 1'b0, FUNCT3_H, 2'b01);
        
        check_control_signals("LW",  L_TYPE_OPCODE, FUNCT3_W, 7'b0, 
            1'b1, 1'b0, 1'b1, ALU_ADD, 3'b000, 5'b00000, 1'b0, FUNCT3_W, 2'b01);
        
        check_control_signals("LBU", L_TYPE_OPCODE, FUNCT3_BU, 7'b0, 
            1'b1, 1'b0, 1'b1, ALU_ADD, 3'b000, 5'b00000, 1'b0, FUNCT3_BU, 2'b01);
        
        check_control_signals("LHU", L_TYPE_OPCODE, FUNCT3_HU, 7'b0, 
            1'b1, 1'b0, 1'b1, ALU_ADD, 3'b000, 5'b00000, 1'b0, FUNCT3_HU, 2'b01);

        $display("\n=== Testing Store Instructions ===");
        check_control_signals("SB",  S_TYPE_OPCODE, FUNCT3_B, 7'b0, 
            1'b0, 1'b0, 1'b1, ALU_ADD, 3'b001, 5'b00000, 1'b1, FUNCT3_B, 2'b00);
        
        check_control_signals("SH",  S_TYPE_OPCODE, FUNCT3_H, 7'b0, 
            1'b0, 1'b0, 1'b1, ALU_ADD, 3'b001, 5'b00000, 1'b1, FUNCT3_H, 2'b00);
        
        check_control_signals("SW",  S_TYPE_OPCODE, FUNCT3_W, 7'b0, 
            1'b0, 1'b0, 1'b1, ALU_ADD, 3'b001, 5'b00000, 1'b1, FUNCT3_W, 2'b00);

        $display("\n=== Testing Branch Instructions ===");
        check_control_signals("BEQ",  B_TYPE_OPCODE, FUNCT3_BEQ, 7'b0, 
            1'b0, 1'b1, 1'b1, ALU_ADD, 3'b101, {2'b01, FUNCT3_BEQ}, 1'b0, 3'b000, 2'b00);
        
        check_control_signals("BNE",  B_TYPE_OPCODE, FUNCT3_BNE, 7'b0, 
            1'b0, 1'b1, 1'b1, ALU_ADD, 3'b101, {2'b01, FUNCT3_BNE}, 1'b0, 3'b000, 2'b00);
        
        check_control_signals("BLT",  B_TYPE_OPCODE, FUNCT3_BLT, 7'b0, 
            1'b0, 1'b1, 1'b1, ALU_ADD, 3'b101, {2'b01, FUNCT3_BLT}, 1'b0, 3'b000, 2'b00);
        
        check_control_signals("BGE",  B_TYPE_OPCODE, FUNCT3_BGE, 7'b0, 
            1'b0, 1'b1, 1'b1, ALU_ADD, 3'b101, {2'b01, FUNCT3_BGE}, 1'b0, 3'b000, 2'b00);
        
        check_control_signals("BLTU", B_TYPE_OPCODE, FUNCT3_BLTU, 7'b0, 
            1'b0, 1'b1, 1'b1, ALU_ADD, 3'b101, {2'b01, FUNCT3_BLTU}, 1'b0, 3'b000, 2'b00);
        
        check_control_signals("BGEU", B_TYPE_OPCODE, FUNCT3_BGEU, 7'b0, 
            1'b0, 1'b1, 1'b1, ALU_ADD, 3'b101, {2'b01, FUNCT3_BGEU}, 1'b0, 3'b000, 2'b00);

        $display("\n=== Testing Jump Instructions ===");
        check_control_signals("JALR", JALR_OPCODE, 3'b0, 7'b0, 
            1'b1, 1'b0, 1'b1, ALU_ADD, 3'b000, 5'b10000, 1'b0, 3'b000, 2'b10);
        
        check_control_signals("JAL",  JAL_OPCODE, 3'b0, 7'b0, 
            1'b1, 1'b1, 1'b1, ALU_ADD, 3'b110, 5'b10000, 1'b0, 3'b000, 2'b10);

        $display("\n=== Testing Upper Immediate Instructions ===");
        check_control_signals("LUI",   LUI_OPCODE, 3'b0, 7'b0, 
            1'b1, 1'b0, 1'b1, ALU_PASS_B, 3'b010, 5'b00000, 1'b0, 3'b000, 2'b00);
        
        check_control_signals("AUIPC", AUIPC_OPCODE, 3'b0, 7'b0, 
            1'b1, 1'b1, 1'b1, ALU_ADD, 3'b010, 5'b00000, 1'b0, 3'b000, 2'b00);

        // Summary
        $display("\n=====================================");
        if (error_count == 0)
            $display("🎉 Todos los casos pasaron correctamente");
        else
            $display("⚠️ Total de fallos: %0d", error_count);
        $display("=====================================\n");

        #2;
        $finish;
    end

endmodule

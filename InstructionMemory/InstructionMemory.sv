module InstructionMemory #(
    parameter MEM_SIZE = 128,                          // Memory size in number of 32-bit instructions
    parameter PROGRAM_FILE = "program.hex"             // Path to the hex file containing the program
)(
    input  logic [31:0] address,                       // 32-bit address input
    output logic [31:0] instruction                    // 32-bit instruction output
);
    logic [31:0] mem [0:MEM_SIZE-1];                   // Memory array: MEM_SIZE registers of 32 bits each
    localparam ADDR_WIDTH = $clog2(MEM_SIZE);         // Calculate the number of bits needed to address all memory locations

    initial begin
        // Initialize entire memory with NOPs (No Operation instructions)
        for (int i = 0; i < MEM_SIZE; i = i + 1) begin
            mem[i] = 32'h00000013;  // NOP: addi x0, x0, 0
        end
        
        // Load the program from the file into memory (overwrites NOPs)
        //$readmemh(PROGRAM_FILE, mem); // Hexadecimal format
        //$readmemb(PROGRAM_FILE, mem);  // Binary format

        // Hardcoded RISC-V program for testing InstructionMemory
        mem[0]  = 32'b00000000000000000000000000010011; // addi x0, x0, 0   (NOP)
        mem[1]  = 32'b00000000010000000000010000010011; // addi x8, x0, 4
        mem[2]  = 32'b00000000110000000000010010010011; // addi x9, x0, 12
        mem[3]  = 32'b00000000100101000000100100110011; // add  x18, x8, x9
        mem[4]  = 32'b00000001001000000010000000100011; // sw   x18, 0(x0)
        mem[5]  = 32'b00000000000000000010010100000011; // lw   x10, 0(x0)
        
        // Codigo para instrucciones tipo B
        mem[6]  = 32'b00000000101000000000011010010011; // addi x13, x0, 10  (x13 = 10, initial value)
        mem[7]  = 32'b00000000010000000000010110010011; // addi x11, x0, 4   (x11 = 4)
        mem[8]  = 32'b00000000010000000000011000010011; // addi x12, x0, 4   (x12 = 4)
        mem[9]  = 32'b00000000110001011000010001100011; // beq  x11, x12, 4  (branch if x11==x12)
        mem[10] = 32'b00000000010100000000011010010011; // addi x13, x0, 5   (SKIPPED if beq taken)
        mem[11] = 32'b00000001010000000000011110010011; // addi x15, x0, 20  (target after branch)
        mem[12] = 32'b00000001111000000000100000010011; // addi x16, x0, 30
        
        // Codigo para instrucciones tipo J
        mem[13] = 32'b00000000101000000000101000010011; // addi x20, x0, 10        (x20 = 10)
        mem[14] = 32'b00000000110000000000000011101111; // jal x1, 12               (jump to mem[17])
        mem[15] = 32'b00000000000000000000100001100011; // beq x0, x0, 16           (SKIPPED por JAL)
        mem[16] = 32'b00000001111000000000101000010011; // addi x20, x0, 30         (SKIPPED por JAL)
        mem[17] = 32'b00000000010100000000101100010011; // addi x22, x0, 5          (Target de JAL)
        mem[18] = 32'b00000000000000001000101111100111; // jalr x0, x1, 0           (Salta a x1)
        mem[19] = 32'b00000000000000000000000000010011; // addi x0, x0, 0           (NOP - fin)

        // Display initialization information
        $display("✅ InstructionMemory initialized (HARDCODED PROGRAM):");
        $display("   Size: %0d instructions (%0d bytes)", MEM_SIZE, MEM_SIZE*4);
        $display("   Address width: %0d bits", ADDR_WIDTH);
        $display("   Max address: 0x%08h", (MEM_SIZE-1)*4);
        $display("   Program loaded: 20 instructions");
    end

    // Address alignment: remove the 2 least significant bits (word alignment for 32-bit instructions)
    wire [31:0] aligned_addr = address[31:2];
    
    // Out-of-bounds protection: check if the aligned address is within valid memory range
    wire address_valid = (aligned_addr < MEM_SIZE);
    
    // Output instruction: return memory value if address is valid, otherwise return NOP for safety
    assign instruction = address_valid ? mem[aligned_addr] : 32'h00000013;

endmodule
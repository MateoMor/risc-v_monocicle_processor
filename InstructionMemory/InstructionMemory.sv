module InstructionMemory (
    input  logic [31:0] address,
    output logic [31:0] instruction
);
    logic [31:0] mem [0:127]; // 128 instructions of 32 bits each

    initial begin
        $readmemh("program.hex", mem); // Load instructions from a hex file
    end

    assign instruction = mem[address[31:2]]; // Discard the 2 least significant bits for instruction alignment
endmodule
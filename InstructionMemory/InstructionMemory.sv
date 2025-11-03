module InstructionMemory #(
    parameter MEM_SIZE = 128,
    parameter PROGRAM_FILE = "program.hex"
)(
    input  logic [31:0] address,
    output logic [31:0] instruction
);
    logic [31:0] mem [0:MEM_SIZE-1]; 

    initial begin
        $readmemh(PROGRAM_FILE, mem); // Load instructions from a hex file
    end

    assign instruction = mem[address[31:2]]; // Discard the 2 least significant bits for instruction alignment
endmodule
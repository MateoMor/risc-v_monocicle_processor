module ProgramCounter (
    input  logic        clk,      // clock signal
    input  logic        reset,    // reset signal
    input  logic [31:0] next_pc,  // next PC address
    output logic [31:0] pc        // current PC address
);
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            pc <= 32'b0;          // on reset, go back to the start of the program
        else
            pc <= next_pc;        // on each cycle, load the next address
    end
endmodule

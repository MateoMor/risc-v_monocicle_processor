module NextPC(
    input logic NextPCsrc,
    input logic [31:0] PC_with_offset,
    input logic [31:0] ALURes,
    output logic [31:0] NextPC
);
always @* begin
    NextPC = (NextPCsrc) ? ALURes : PC_with_offset;
end
endmodule


    
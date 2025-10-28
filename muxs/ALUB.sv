module ALUB(
    input logic        ALUBsrc,
    input logic [31:0] ru_rs2,
    input logic [31:0] ImmExt,
    output logic [31:0] B
);
always @* begin
    B = (ALUBsrc) ? ImmExt : ru_rs2;
end
endmodule

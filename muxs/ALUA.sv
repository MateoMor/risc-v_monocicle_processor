module ALUA(
    input logic        ALUAsrc,
    input logic [31:0] PC,
    input logic [31:0] ru_rs1,
    output logic [31:0] A
);
always @* begin
    A = (ALUAsrc) ? PC : ru_rs1;
end
endmodule


    
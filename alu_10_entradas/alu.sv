module alu(
	input logic [3:0] A,
	input logic [3:0] B,
	input logic [1:0] ALUOp,
	output logic [9:0] ALURes
);
	
	
always_comb
begin

	case(ALUOp)
		2'b00: ALURes = A + B; // ADD
      2'b01: ALURes = A - B; // SUB
      2'b10: ALURes = A | B; // OR
      2'b11: ALURes = A & B; // AND
	endcase


end 
endmodule
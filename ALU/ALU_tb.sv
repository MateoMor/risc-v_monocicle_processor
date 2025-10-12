`timescale 1ns/1ps

module alu_tb;

  logic signed [31:0] A, B;
  logic [3:0] ALUOp;
  logic signed [31:0] ALURes;

  ALU dut (
    .A(A),
    .B(B),
    .ALUOp(ALUOp),
    .ALURes(ALURes)
  );

  initial begin
    $dumpfile("alu_tb.vcd");
    $dumpvars(0, alu_tb);

    // ADD (3 + 2 = 5)
    A = 32'd3;  B = 32'd13;  ALUOp = 4'b0000;  #1;
    $display("ADD: A=%0d B=%0d -> %0d", A, B, ALURes);

    // SUB (8 - 5 = 3)
    A = 32'd8;  B = 32'd12;  ALUOp = 4'b1000;  #1;
    $display("SUB: A=%0d B=%0d -> %0d", A, B, ALURes);

    // SLL (1 << 2 = 4) — desplazamiento lógico a la izquierda
    A = 32'b01;  B = 32'b010;  ALUOp = 4'b0001;  #1;
    $display("SLL: %0d << %0d -> %0d", A, B, ALURes);

    // SLT (-1 < 2 → 1) — comparación con signo
    A = -32'd1; B = 32'd2;  ALUOp = 4'b0010;  #1;
    $display("SLT: %0d < %0d -> %0d", A, B, ALURes);

    // SLTU (0xFFFFFFFF < 2 → 0) — comparación sin signo
    A = 32'hFFFFFFFF; B = 32'd2; ALUOp = 4'b0011; #1;
    $display("SLTU: %0d < %0d (unsigned) -> %0d", A, B, ALURes);

    // XOR (10 ^ 5 = 15)
    A = 32'd10; B = 32'd5; ALUOp = 4'b0100; #1;
    $display("XOR: %0d ^ %0d -> %0d", A, B, ALURes);

    // SRL (8 >> 1 = 4) — desplazamiento lógico a la derecha
    A = 32'd8;  B = 32'd1;  ALUOp = 4'b0101;  #1;
    $display("SRL: %0d >> %0d -> %0d", A, B, ALURes);

    // SRA (-8 >>> 1 = -4) — desplazamiento aritmético a la derecha
    A = -32'd8; B = 32'd1;  ALUOp = 4'b1101;  #1;
    $display("SRA: %0d >>> %0d -> %0d", A, B, ALURes);

    // OR (01010 | 0100 = 1110)
    A = 32'b01010; B = 32'b0100; ALUOp = 4'b0110; #1;
    $display("OR: %0b | %0b -> %0b", A, B, ALURes);

    // AND (1100 & 1010 = 1000)
    A = 32'b1100; B = 32'b1010; ALUOp = 4'b0111; #1;
    $display("AND: %0b & %0b -> %0b", A, B, ALURes);

    // PASS B (B = 15 → 15)
    A = 32'b0000;  B = 32'b1111; ALUOp = 4'b1001; #1;
    $display("PASS B: B=%0b -> %0b", B, ALURes);

    #2;
    $finish;
  end

endmodule

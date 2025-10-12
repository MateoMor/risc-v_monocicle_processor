`timescale 1ns/1ps 

module alu_tb;

  
  logic [3:0] A;
  logic [3:0] B;
  logic [1:0] ALUOp;

  logic [9:0] ALURes;

  alu dut (
    .A(A),
    .B(B),
    .ALUOp(ALUOp),
    .ALURes(ALURes)
  );

  initial begin
    $dumpfile("alu_tb.vcd");   
    $dumpvars(0, alu_tb);      
  end

  // TEST CASES
  initial begin
    A = 4'b0011;  B = 4'b0010;  ALUOp = 2'b00; #1; // ADD  (3 + 2)
    A = 4'b1000;  B = 4'b0101;  ALUOp = 2'b01; #1; // SUB  (8 - 5)
    A = 4'b1010;  B = 4'b0110;  ALUOp = 2'b10; #1; // OR   (1010 | 0110)
    A = 4'b1100;  B = 4'b1010;  ALUOp = 2'b11; #1; // AND  (1100 & 1010)
    A = 4'b1111;  B = 4'b1111;  ALUOp = 2'b00; #1; // ADD overflow (1111 + 1111)
    #20;
    $finish;
  end

endmodule

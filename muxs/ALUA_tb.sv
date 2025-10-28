`timescale 1ns/1ps

module ALUA_tb;

    logic        ALUAsrc;
    logic [31:0] PC;
    logic [31:0] ru_rs1;
    logic [31:0] A;

    ALUA dut (
        .ALUAsrc(ALUAsrc),
        .PC(PC),
        .ru_rs1(ru_rs1),
        .A(A)
    );

    initial begin
        $dumpfile("ALUA_tb.vcd");
        $dumpvars(0, ALUA_tb);

        // case 1: select ru_rs1
        ALUAsrc = 1'b0;
        PC = 32'h0000_1234;
        ru_rs1 = 32'hAAAA_5555;
        #1;
        if (A !== ru_rs1) begin
            $error("❌ ALUAsrc=0 FAIL: A=0x%08h (expected 0x%08h)", A, ru_rs1);
        end else begin
            $display("✅ ALUAsrc=0 PASS: A=0x%08h", A);
        end

        // case 2: select PC
        ALUAsrc = 1'b1;
        #1;
        if (A !== PC) begin
            $error("❌ ALUAsrc=1 FAIL: A=0x%08h (expected 0x%08h)", A, PC);
        end else begin
            $display("✅ ALUAsrc=1 PASS: A=0x%08h", A);
        end

        #1;
        $finish;
    end

endmodule

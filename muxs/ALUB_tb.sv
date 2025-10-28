`timescale 1ns/1ps

module ALUB_tb;

    logic        ALUBsrc;
    logic [31:0] ru_rs2;
    logic [31:0] ImmExt;
    logic [31:0] B;

    ALUB dut (
        .ALUBsrc(ALUBsrc),
        .ru_rs2(ru_rs2),
        .ImmExt(ImmExt),
        .B(B)
    );

    initial begin
        $dumpfile("ALUB_tb.vcd");
        $dumpvars(0, ALUB_tb);

        // case 1: select ru_rs2
        ALUBsrc = 1'b0;
        ru_rs2 = 32'h1234_5678;
        ImmExt = 32'hDEAD_BEEF;
        #1;
        if (B !== ru_rs2) begin
            $error("❌ ALUBsrc=0 FAIL: B=0x%08h (esperado 0x%08h)", B, ru_rs2);
        end else begin
            $display("✅ ALUBsrc=0 PASS: B=0x%08h", B);
        end

        // case 2: select ImmExt
        ALUBsrc = 1'b1;
        #1;
        if (B !== ImmExt) begin
            $error("❌ ALUBsrc=1 FAIL: B=0x%08h (esperado 0x%08h)", B, ImmExt);
        end else begin
            $display("✅ ALUBsrc=1 PASS: B=0x%08h", B);
        end

        #1;
        $finish;
    end

endmodule

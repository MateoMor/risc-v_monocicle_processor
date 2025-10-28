`timescale 1ns/1ps

module NextPC_tb;

    logic        NextPCsrc;
    logic [31:0] PC_with_offset;
    logic [31:0] ALURes;
    logic [31:0] NextPC;

    NextPC dut (
        .NextPCsrc(NextPCsrc),
        .PC_with_offset(PC_with_offset),
        .ALURes(ALURes),
        .NextPC(NextPC)
    );

    initial begin
        $dumpfile("NextPC_tb.vcd");
        $dumpvars(0, NextPC_tb);

        // case 1: select PC_with_offset
        NextPCsrc = 1'b0;
        PC_with_offset = 32'h0000_1234;
        ALURes = 32'hAAAA_5555;
        #1;
        if (NextPC !== PC_with_offset) begin
            $error("❌ NextPCsrc=0 FAIL: NextPC=0x%08h (esperado 0x%08h)", NextPC, PC_with_offset);
        end else begin
            $display("✅ NextPCsrc=0 PASS: NextPC=0x%08h", NextPC);
        end

        // case 2: select ALURes
        NextPCsrc = 1'b1;
        #1;
        if (NextPC !== ALURes) begin
            $error("❌ NextPCsrc=1 FAIL: NextPC=0x%08h (esperado 0x%08h)", NextPC, ALURes);
        end else begin
            $display("✅ NextPCsrc=1 PASS: NextPC=0x%08h", NextPC);
        end

        #1;
        $finish;
    end

endmodule
`timescale 1ns/1ps

module ProgramCounter_tb;

    // Signals
    logic clk, reset;
    logic [31:0] next_pc, pc;

    // Device under test
    ProgramCounter dut (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(pc)
    );

    // Clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // TEST SEQUENCE
    initial begin
        $dumpfile("ProgramCounter_tb.vcd");
        $dumpvars(0, ProgramCounter_tb);

        // initialize
        next_pc = 32'h0000_0000;
        reset   = 1'b1;

        // Hold reset for a couple of clock edges
        repeat (2) @(posedge clk);
        reset = 1'b0;
        @(posedge clk); #1;

        // Check reset effect
        if (pc !== 32'h0000_0000)
            $error("❌ After reset, PC = %h (expected 0)", pc);
        else
            $display("✅ After reset, PC = %h (expected 0)", pc);

        // Test normal operation: update next_pc and sample at posedge
        next_pc = 32'h0000_0004;
        @(posedge clk); #1;
        if (pc !== 32'h0000_0004)
            $error("❌ After 1st update, PC = %h (expected 4)", pc);
        else
            $display("✅ After 1st update, PC = %h (expected 4)", pc);

        next_pc = 32'h0000_0008;
        @(posedge clk); #1;
        if (pc !== 32'h0000_0008)
            $error("❌ After 2nd update, PC = %h (expected 8)", pc);
        else
            $display("✅ After 2nd update, PC = %h (expected 8)", pc);

        // Test asynchronous reset during operation
        reset = 1'b1; #1; // async assert
        if (pc !== 32'h0000_0000)
            $error("❌ After async reset assert, PC = %h (expected 0)", pc);
        else
            $display("✅ After async reset assert, PC = %h (expected 0)", pc);

        // release reset and verify next updates still work
        reset = 1'b0;
        next_pc = 32'h0000_000C;
        @(posedge clk); #1;
        if (pc !== 32'h0000_000C)
            $error("❌ After release, PC = %h (expected 12)", pc);
        else
            $display("✅ After release, PC = %h (expected 12)", pc);

        $finish;
    end
endmodule
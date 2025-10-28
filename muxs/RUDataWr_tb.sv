`timescale 1ns/1ps

module RUDataWr_tb;

    logic [1:0]  RUDataWrSrc;
    logic [31:0] PC_with_offset;
    logic [31:0] DataRd;
    logic [31:0] ALURes;
    logic [31:0] DataWr;

    NextPC dut (
        .RUDataWrSrc(RUDataWrSrc),
        .PC_with_offset(PC_with_offset),
        .DataRd(DataRd),
        .ALURes(ALURes),
        .DataWr(DataWr)
    );

    localparam [1:0]
        ALURES        = 2'b00,
        DATARD        = 2'b01,
        PC_WITH_OFFSET = 2'b10,
        DEFAULT_SRC   = 2'b11;

    int error_count;

    initial begin
        $dumpfile("RUDataWr_tb.vcd");
        $dumpvars(0, RUDataWr_tb);

        error_count = 0;

        PC_with_offset = 32'h0000_0040;
        DataRd         = 32'hCAFEBABE;
        ALURes         = 32'h1234_5678;

        RUDataWrSrc = ALURES;
        #1;
        if (DataWr !== ALURes) begin
            $error("❌ ALURES: DataWr=0x%08h (esperado 0x%08h)", DataWr, ALURes);
            error_count++;
        end else begin
            $display("✅ ALURES: DataWr=0x%08h", DataWr);
        end

        RUDataWrSrc = DATARD;
        #1;
        if (DataWr !== DataRd) begin
            $error("❌ DATARD: DataWr=0x%08h (esperado 0x%08h)", DataWr, DataRd);
            error_count++;
        end else begin
            $display("✅ DATARD: DataWr=0x%08h", DataWr);
        end

        RUDataWrSrc = PC_WITH_OFFSET;
        #1;
        if (DataWr !== PC_with_offset) begin
            $error("❌ PC_WITH_OFFSET: DataWr=0x%08h (esperado 0x%08h)", DataWr, PC_with_offset);
            error_count++;
        end else begin
            $display("✅ PC_WITH_OFFSET: DataWr=0x%08h", DataWr);
        end

        RUDataWrSrc = DEFAULT_SRC;
        #1;
        if (DataWr !== 32'h0000_0000) begin
            $error("❌ DEFAULT: DataWr=0x%08h (esperado 0x00000000)", DataWr);
            error_count++;
        end else begin
            $display("✅ DEFAULT: DataWr=0x%08h", DataWr);
        end

        if (error_count == 0)
            $display("🎉 RUDataWr mux passed all checks");
        else
            $display("⚠️ RUDataWr mux failures: %0d", error_count);

        #1;
        $finish;
    end

endmodule

`timescale 1ns/1ps

module ImmGen_tb;

    logic [24:0] InmediateBits;
    logic [2:0]  ImmSrc;
    logic [31:0] ImmExt;

    ImmGen dut (
        .InmediateBits(InmediateBits),
        .ImmSrc(ImmSrc),
        .ImmExt(ImmExt)
    );

    initial begin
        $dumpfile("ImmGen_tb.vcd");
        $dumpvars(0, ImmGen_tb);

    // I-type (addi x1, x2, -4)
    InmediateBits = '0;
    InmediateBits[24:13] = 12'b111111111100; // immediate = -4
        ImmSrc = 3'b000;
        #1;
        if (ImmExt !== 32'b11111111111111111111111111111100) begin
            $error("❌ I-type: ImmExt = %032b (esperado %032b)", ImmExt, 32'b11111111111111111111111111111100);
        end else begin
            $display("✅ I-type: ImmExt = %032b", ImmExt);
        end

    // S-type (sw x5, 8(x1))
    InmediateBits = '0;
    InmediateBits[24:18] = 7'b0100000; // ImmExt[11:5]
    InmediateBits[4:0]   = 5'b01000;   // ImmExt[4:0]
        ImmSrc = 3'b001;
        #1;
        if (ImmExt !== 32'b00000000000000000000010000001000) begin
            $error("❌ S-type: ImmExt = %032b (esperado %032b)", ImmExt, 32'b00000000000000000000010000001000);
        end else begin
            $display("✅ S-type: ImmExt = %032b", ImmExt);
        end

        // B-type (beq offset +16)
        InmediateBits = '0;
        InmediateBits[4] = 1'b1; // ImmExt[4]
        InmediateBits[23] = 1'b1; // ImmExt[10]
        InmediateBits[0] = 1'b1; // ImmExt[11]
        ImmSrc = 3'b101;
        #1;
        if (ImmExt !== 32'b00000000000000000000110000010000) begin
            $error("❌ B-type: ImmExt = %032b (esperado %032b)", ImmExt, 32'b00000000000000000000110000010000);
        end else begin
            $display("✅ B-type: ImmExt = %032b", ImmExt);
        end

        // U-type (lui con valor 0x12345)
        InmediateBits = {20'b00010010001101000101, 5'b10000};
        ImmSrc = 3'b010;
        #1;
        if (ImmExt !== 32'b00010010001101000101000000000000) begin
            $error("❌ U-type: ImmExt = %032b (esperado %032b)", ImmExt, 32'b00010010001101000101000000000000);
        end else begin
            $display("✅ U-type: ImmExt = %032b", ImmExt);
        end

        // J-type (jal offset 0x100)
        InmediateBits = '0;
        InmediateBits[21] = 1'b1; // ImmExt[8]
        InmediateBits[23] = 1'b1; // ImmExt[10]
        InmediateBits[5] = 1'b1; // ImmExt[12]
        InmediateBits[13] = 1'b1; // ImmExt[11]
        ImmSrc = 3'b011;
        #1;
        if (ImmExt !== 32'b00000000000000000001110100000000) begin
            $error("❌ J-type: ImmExt = %032b (esperado %032b)", ImmExt, 32'b00000000000000000001110100000000);
        end else begin
            $display("✅ J-type: ImmExt = %032b", ImmExt);
            $display("Original: %032b", InmediateBits);
        end

        $finish;
    end

endmodule
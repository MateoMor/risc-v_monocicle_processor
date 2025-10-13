`timescale 1ns/1ps

module BranchUnit_tb;

	logic [31:0] ru_rs1;
	logic [31:0] ru_rs2;
	logic [4:0]  BrOp;
	logic        NextPCsrc;

	BranchUnit dut (
		.ru_rs1(ru_rs1),
		.ru_rs2(ru_rs2),
		.BrOp(BrOp),
		.NextPCsrc(NextPCsrc)
	);


	task automatic expect_next(
		input logic [31:0] a,
		input logic [31:0] b,
		input logic [4:0]  op,
		input logic        expected,
		input string       label
	);
	begin
		ru_rs1 = a;
		ru_rs2 = b;
		BrOp   = op;
		#1;
		if (NextPCsrc !== expected) begin
			$error("❌ %s: rs1=%0d rs2=%0d BrOp=%05b -> %b (esperado %b)",
			       label, $signed(ru_rs1), $signed(ru_rs2), BrOp, NextPCsrc, expected);
		end else begin
			$display("✅ %s: rs1=%0d rs2=%0d BrOp=%05b -> %b", label, $signed(ru_rs1), $signed(ru_rs2), BrOp, NextPCsrc);
		end
	end
	endtask

	initial begin
		$dumpfile("BranchUnit_tb.vcd");
		$dumpvars(0, BranchUnit_tb);

		// No branch (00xxx)
		expect_next(32'd10, 32'd20, 5'b00000, 1'b0, "No branch 00000");
		expect_next(32'd5,  32'd5,  5'b00101, 1'b0, "No branch 00101");

		// BEQ (01000)
		expect_next(32'd42, 32'd42, 5'b01000, 1'b1, "BEQ taken");
		expect_next(32'd42, 32'd7,  5'b01000, 1'b0, "BEQ not taken");

		// BNE (01001)
		expect_next(32'd10, 32'd7,  5'b01001, 1'b1, "BNE taken");
		expect_next(32'd10, 32'd10, 5'b01001, 1'b0, "BNE not taken");

		// BLT (signed)
		expect_next($signed(-5), $signed(3), 5'b01100, 1'b1, "BLT taken");
		expect_next($signed(5),  $signed(-3),5'b01100, 1'b0, "BLT not taken");

		// BGE (signed)
		expect_next($signed(-2), $signed(-2), 5'b01101, 1'b1, "BGE equal");
		expect_next($signed(-4), $signed(1),  5'b01101, 1'b0, "BGE not taken");

		// BLTU (unsigned)
		expect_next(32'd1,        32'd5,        5'b01110, 1'b1, "BLTU taken");
		expect_next(32'hFFFF_FFFF,32'd5,        5'b01110, 1'b0, "BLTU not taken");

		// BGEU (unsigned)
		expect_next(32'hFFFF_FFFF,32'd1,        5'b01111, 1'b1, "BGEU taken");
		expect_next(32'd1,        32'hFFFF_FFFE,5'b01111, 1'b0, "BGEU not taken");

		// Unconditional branch/jump (1xxxx)
		expect_next(32'd0, 32'd0, 5'b10000, 1'b1, "Jump base");
		expect_next(32'd0, 32'd0, 5'b11111, 1'b1, "Jump all 1s");

		#2;
		$finish;
	end

endmodule

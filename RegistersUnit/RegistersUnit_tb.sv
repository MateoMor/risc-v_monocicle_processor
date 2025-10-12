`timescale 1ns/1ps

module RegistersUnit_tb;

	// Signals
	logic clk;
	logic [4:0] rs1, rs2, rd;
	logic [31:0] DataWR;
	logic RUWr;
	logic [31:0] ru_rs1, ru_rs2;

	// Device under test
	RegistersUnit dut (
		.clk(clk),
		.rs1(rs1),
		.rs2(rs2),
		.rd(rd),
		.DataWR(DataWR),
		.RUWr(RUWr),
		.ru_rs1(ru_rs1),
		.ru_rs2(ru_rs2)
	);

	// Clock
	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end

	// TEST SEQUENCE
	initial begin
		$dumpfile("RegistersUnit_tb.vcd");
		$dumpvars(0, RegistersUnit_tb);

		// default
		rs1 = '0; rs2 = '0; rd = '0; DataWR = '0; RUWr = 1'b0;

		// 1. x0 must read zero (force rs1 before sample)
		rs1 = 5'd0; #1;
		if (ru_rs1 !== 32'd0) $error("x0 should read 0, got %h", ru_rs1);

		// 2. write x5 = 4 (synchronous) and read back
		write_reg(5'd5, 32'h4);
		rs1 = 5'd5; #1;
		if (ru_rs1 !== 32'h4) $error("Read after write mismatch for x5: %h", ru_rs1);

		// 3. forwarding: prepare read index, then assert write signals briefly
		rs2 = 5'd7; // prepare read address
		trigger_forwarding(5'd7, 32'd13); // should make ru_rs2 == 13 while RUWr asserted
		if (ru_rs2 !== 32'd13) $error("Forwarding failed for x7: %h", ru_rs2);

		// commit the value for subsequent checks
		write_reg(5'd7, 32'd13);

		// 4. dual read
		rs1 = 5'd5; rs2 = 5'd7; #1;
		if ((ru_rs1 !== 32'h4) || (ru_rs2 !== 32'd13))
			$error("Dual read mismatch: rs1=%h rs2=%h", ru_rs1, ru_rs2);

		$display("RegistersUnit_tb completed successfully");
		$finish;
	end

	// synchronous write: set signals during low phase and keep until after posedge
	task automatic write_reg(input logic [4:0] dest, input logic [31:0] value);
		@(negedge clk);
		RUWr = 1'b1; rd = dest; DataWR = value;
		@(posedge clk);
		#1; // allow DUT to update outputs
		RUWr = 1'b0; rd = '0; DataWR = '0;
	endtask

	// forwarding: assert RUWr/rd/DataWR briefly (no commit) and let combinational path settle
	task automatic trigger_forwarding(input logic [4:0] dest, input logic [31:0] value);
		@(negedge clk);
		RUWr = 1'b1; rd = dest; DataWR = value;
		#1; // sample forwarding
		RUWr = 1'b0; rd = '0; DataWR = '0;
	endtask

endmodule

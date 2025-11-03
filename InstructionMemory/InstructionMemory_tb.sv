`timescale 1ns/1ps

module InstructionMemory_tb #(
	parameter PROGRAM_FILE = "program.hex"
);

	logic [31:0] address;
	logic [31:0] instruction;
	integer error_count;

	InstructionMemory #(
		.PROGRAM_FILE(PROGRAM_FILE)
	) dut (
		.address(address),
		.instruction(instruction)
	);

	// ========== TASK: Generic instruction test ==========
	task test_instruction(
		input string label,
		input logic [31:0] test_addr,
		input logic [31:0] expected_instr
	);
		begin
			address = test_addr;
			#1;
			if (instruction !== expected_instr) begin
				$error("❌ %s | PC=0x%08h -> 0x%08h (expected 0x%08h)", 
					   label, test_addr, instruction, expected_instr);
				error_count = error_count + 1;
			end else begin
				$display("✅ %s | PC=0x%08h -> 0x%08h", label, test_addr, instruction);
			end
		end
	endtask

	// ========== TASK: Out-of-bounds test ==========
	task test_out_of_bounds(
		input string label,
		input logic [31:0] test_addr
	);
		begin
			address = test_addr;
			#1;
			if (instruction !== 32'h0000_0013) begin
				$error("❌ %s | PC=0x%08h -> 0x%08h (expected NOP 0x00000013)", 
					   label, test_addr, instruction);
				error_count = error_count + 1;
			end else begin
				$display("✅ %s | PC=0x%08h -> NOP (protection active)", label, test_addr);
			end
		end
	endtask

	// ========== TASK: Print section header ==========
	task print_section(
		input string title
	);
		begin
			$display("\n========== %s ==========", title);
		end
	endtask

	// ========== TASK: Print summary ==========
	task print_summary;
		begin
			$display("\n╔════════════════════════════════════════╗");
			$display("║              Test Summary              ║");
			$display("╚════════════════════════════════════════╝");
			$display("Total errors: %0d", error_count);
			if (error_count == 0) begin
				$display("✅ All tests passed successfully!");
			end else begin
				$display("❌ %0d test(s) failed!", error_count);
			end
		end
	endtask

	initial begin
		$dumpfile("instruction_memory_tb.vcd");
		$dumpvars(0, InstructionMemory_tb);

		error_count = 0;

		print_section("Basic instruction tests");
		test_instruction("NOP", 32'h0000_0000, 32'h0000_0013);
		test_instruction("ADDI x1, x0, 4", 32'h0000_0004, 32'h0040_0093);
		test_instruction("ADDI x2, x0, 12", 32'h0000_0008, 32'h00C0_0113);
		test_instruction("ADD x3, x1, x2", 32'h0000_000C, 32'h0020_81B3);
		test_instruction("SW x3, 0(x2)", 32'h0000_0010, 32'h0031_2023);

		print_section("Misaligned address test");
		test_instruction("Misaligned address", 32'h0000_0003, 32'h0000_0013);

		print_section("End-of-program test");
		test_instruction("Last instruction (JALR)", 32'h0000_0014, 32'h0000_8067);

		print_section("Out-of-bounds access tests");
		test_out_of_bounds("First out-of-bounds (low)", 32'h0000_0200);
		test_out_of_bounds("Very high address", 32'h7FFF_FFFC);
		test_out_of_bounds("Maximum 32-bit address", 32'hFFFF_FFFC);
		test_out_of_bounds("Just-beyond-boundary", 32'h0000_0200);

		print_section("Boundary test");
		test_instruction("Last valid address (127*4)", 32'h0000_01FC, 32'h0000_0013);

		print_summary;

		#2;
		$finish;
	end

endmodule

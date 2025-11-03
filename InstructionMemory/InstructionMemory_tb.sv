`timescale 1ns/1ps

module InstructionMemory_tb #(
	parameter PROGRAM_FILE = "program.hex"
);

	logic [31:0] address;
	logic [31:0] instruction;

	InstructionMemory #(
		.PROGRAM_FILE(PROGRAM_FILE)
	) dut (
		.address(address),
		.instruction(instruction)
	);

		localparam int TEST_CASE_COUNT = 5;
		logic [31:0] test_addresses [0:TEST_CASE_COUNT-1];
		logic [31:0] expected_instructions [0:TEST_CASE_COUNT-1];

	initial begin
		$dumpfile("instruction_memory_tb.vcd");
		$dumpvars(0, InstructionMemory_tb);

			test_addresses[0] = 32'h0000_0000; expected_instructions[0] = 32'h0000_0013; // NOP
			test_addresses[1] = 32'h0000_0004; expected_instructions[1] = 32'h0040_0093; // addi x1, x0, 4
			test_addresses[2] = 32'h0000_0008; expected_instructions[2] = 32'h00C0_0113; // addi x2, x0, 12
			test_addresses[3] = 32'h0000_000C; expected_instructions[3] = 32'h0020_81B3; // add  x3, x1, x2
			test_addresses[4] = 32'h0000_0010; expected_instructions[4] = 32'h0031_2023; // sw   x3, 0(x2)

		// Asegurarse de que la memoria se cargó antes de aplicar direcciones
		#1;

		for (int i = 0; i < TEST_CASE_COUNT; i++) begin
				address = test_addresses[i]; // Change address to see if the instruction is loaded
			#1;
				if (instruction !== expected_instructions[i]) begin
				$error("❌ PC=0x%08h -> 0x%08h (esperado 0x%08h)",
								 address, instruction, expected_instructions[i]);
			end else begin
				$display("✅ PC=0x%08h -> instrucción 0x%08h", address, instruction);
			end
		end

		// Probar dirección desalineada y la siguiente palabra
		address = 32'h0000_0003;
		#1;
        if (instruction !== 32'h0000_0013) begin
            $error("❌ Dirección desalineada PC=0x00000003 -> 0x%08h (esperado 0x00000013)", instruction);
        end
        else
            $display("✅ Dirección desalineada PC=0x00000003 -> instrucción 0x%08h", instruction);

		address = 32'h0000_0014; // load the last word in the file + 4 bytes
		#1;

		// Asegurarse de que la instrucción final concuerda con el archivo
		if (instruction !== 32'h0000_8067) begin
			$error("❌ PC=0x00000014 -> 0x%08h (esperado 0x00008067)", instruction);
		end
        else
            $display("✅ PC=0x00000014 -> instrucción 0x%08h", instruction);

		#2;
		$finish;
	end

endmodule

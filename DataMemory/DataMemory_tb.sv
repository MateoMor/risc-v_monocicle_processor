`timescale 1ns/1ps

module DataMemory_tb;

	logic [31:0] Address;
	logic [31:0] DataWr;
	logic        DMWr;
	logic [2:0]  DMCtrl;
	logic [31:0] DataRd;

	DataMemory dut (
		.Address(Address),
		.DataWr(DataWr),
		.DMWr(DMWr),
		.DMCtrl(DMCtrl),
		.DataRd(DataRd)
	);

	localparam [2:0]
		LB   = 3'b000,
		LH   = 3'b001,
		LW   = 3'b010,
		LB_U = 3'b100,
		LH_U = 3'b101,
		SB   = 3'b000,
		SH   = 3'b001,
		SW   = 3'b010;

	int error_count;

	task automatic write_data(input logic [31:0] addr,
							  input logic [31:0] data,
							  input logic [2:0]  ctrl);
		begin
			Address = addr;
			DataWr  = data;
			DMCtrl  = ctrl;
			#1;
			DMWr = 1'b1; #1;
			DMWr = 1'b0; #1;
		end
	endtask

	task automatic check_read(input string label,
							   input logic [31:0] addr,
							   input logic [2:0]  ctrl,
							   input logic [31:0] expected);
		begin
			Address = addr;
			DMCtrl  = ctrl;
			#1;
			if (DataRd !== expected) begin
				$error("❌ %s @0x%0h -> 0x%08h (esperado 0x%08h)",
						label, addr, DataRd, expected);
				error_count++;
			end else begin
				$display("✅ %s @0x%0h -> 0x%08h", label, addr, DataRd);
			end
		end
	endtask

	initial begin
		$dumpfile("data_memory_tb.vcd");
		$dumpvars(0, DataMemory_tb);

		Address = '0;
		DataWr  = '0;
		DMWr    = 1'b0;
		DMCtrl  = LB;
		error_count = 0;

		// Caso 1: escribir palabra completa y leerla
		write_data(32'd0, 32'hDEADBEEF, SW);
		check_read("LW", 32'd0, LW, 32'hDEADBEEF);

		// Caso 2: escribir halfword con signo
		write_data(32'd8, 32'h0000ABCA, SH);
		check_read("LH", 32'd8, LH, 32'hFFFFABCA);
		check_read("LHU", 32'd8, LH_U, 32'h0000ABCA);

		// Caso 3: escribir byte y verificar sign/zero extend
		write_data(32'd16, 32'h00000080, SB);
		check_read("LB",  32'd16, LB,   32'hFFFFFF80);
		check_read("LBU", 32'd16, LB_U, 32'h00000080);

		// Caso 4: comprobar orden little-endian de palabra previa
		check_read("LBU", 32'd3,  LB_U, 32'h000000DE);

		if (error_count == 0)
			$display("🎉 Todos los casos pasaron correctamente");
		else
			$display("⚠️ Total de fallos: %0d", error_count);

		#2;
		$finish;
	end

endmodule

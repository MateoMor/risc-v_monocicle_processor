`timescale 1ns/1ps

module RiscV_SingleCycle_tb;

    // DUT signals
    logic clk;
    logic reset;
    
    // Instantiate the processor
    RiscV_SingleCycle #(
        .IMEM_SIZE(16),
        .PROGRAM_FILE("test_programs/program.hex")
    ) dut (
        .clk(clk),
        .reset(reset)
    );
    
    // Clock generator (50 MHz = 20ns period)
    initial clk = 0;
    always #10 clk = ~clk;
    
    // Monitoring variables
    integer cycle_count;
    integer error_count;
    logic program_finished;
    
    // Task to print processor state
    task print_state;
        input string label;
        begin
            $display("\n========== %s ==========", label);
            $display("Cycle: %0d | Time: %0t", cycle_count, $time);
            $display("PC       = 0x%08h", dut.PC);
            $display("Instr    = 0x%08h", dut.Instruction);
            $display("OpCode   = 0b%07b", dut.OpCode);
            $display("ALURes   = 0x%08h (%0d)", dut.ALURes, dut.ALURes);
            $display("NextPC   = 0x%08h", dut.NextPC);
            $display("\nRegisters:");
            $display("  x1  = 0x%08h (%0d)", dut.reg_unit_inst.ru[1], $signed(dut.reg_unit_inst.ru[1]));
            $display("  x2  = 0x%08h (%0d)", dut.reg_unit_inst.ru[2], $signed(dut.reg_unit_inst.ru[2]));
            $display("  x3  = 0x%08h (%0d)", dut.reg_unit_inst.ru[3], $signed(dut.reg_unit_inst.ru[3]));
            $display("  x4  = 0x%08h (%0d)", dut.reg_unit_inst.ru[4], $signed(dut.reg_unit_inst.ru[4]));
            $display("  x5  = 0x%08h (%0d)", dut.reg_unit_inst.ru[5], $signed(dut.reg_unit_inst.ru[5]));
            $display("\nControl Signals:");
            $display("  RUWr      = %b", dut.RUWr);
            $display("  ALUASrc   = %b", dut.ALUASrc);
            $display("  ALUBSrc   = %b", dut.ALUBSrc);
            $display("  ALUOp     = 0b%04b", dut.ALUOp);
            $display("  BrOp      = 0b%05b", dut.BrOp);
            $display("  NextPCsrc = %b", dut.NextPCsrc);
            $display("  DMWr      = %b", dut.DMWr);
        end
    endtask
    
    // Task to verify a register value
    task check_register;
        input int reg_num;
        input logic [31:0] expected;
        input string name;
        begin
            if (dut.reg_unit_inst.ru[reg_num] !== expected) begin
                $error("❌ %s (x%0d) = 0x%08h, expected 0x%08h", 
                       name, reg_num, dut.reg_unit_inst.ru[reg_num], expected);
                error_count = error_count + 1;
            end else begin
                $display("✅ %s (x%0d) = 0x%08h", name, reg_num, expected);
            end
        end
    endtask

        task check_data_memory;
        input logic [31:0] addr;
        input logic [31:0] expected;
        begin
            // DataMemory es byte-addressable, así que debemos leer 4 bytes
            logic [31:0] read_value;
            read_value = {dut.dmem_inst.dm[addr+3], 
                         dut.dmem_inst.dm[addr+2], 
                         dut.dmem_inst.dm[addr+1], 
                         dut.dmem_inst.dm[addr]};
            
            if (read_value !== expected) begin
                $error("❌ DataMemory[0x%08h] = 0x%08h, expected 0x%08h", 
                       addr, read_value, expected);
                error_count = error_count + 1;
            end else begin
                $display("✅ DataMemory[0x%08h] = 0x%08h", addr, expected);
            end
        end
    endtask

    // Main test sequence
    initial begin
        $dumpfile("riscv_tb.vcd");
        $dumpvars(0, RiscV_SingleCycle_tb);
        
        // Initialization
        cycle_count = 0;
        error_count = 0;
        program_finished = 0;
        
        $display("\n");
        $display("╔═══════════════════════════════════════════════════════════╗");
        $display("║         RISC-V Single Cycle Processor Testbench          ║");
        $display("╚═══════════════════════════════════════════════════════════╝");
        
        // Initial reset
        $display("\n🔄 Applying reset...");
        reset = 1;
        repeat(3) @(posedge clk);
        reset = 0;
        
        print_state("Initial state (after reset)");
        
        // Execute the program instruction by instruction
        $display("\n");
        $display("╔═══════════════════════════════════════════════════════════╗");
        $display("║                  Executing program                        ║");
        $display("╚═══════════════════════════════════════════════════════════╝");
        
        // Execute up to 20 cycles or until program ends
        for (int i = 0; i < 20; i = i + 1) begin
            if (!program_finished) begin
                @(posedge clk);
                cycle_count = cycle_count + 1;
                
                // Print state every 5 cycles
                if (cycle_count % 5 == 0) begin
                    print_state($sformatf("Cycle %0d", cycle_count));
                end
                
                // Detect end of program (infinite NOP loop)
                if (dut.Instruction == 32'h00000013 && cycle_count > 5) begin
                    $display("\n⚠️  End of program detected (infinite NOP)");
                    program_finished = 1;
                end
            end
        end
        
        // Final state
        print_state("Final state");
        
        // Verification (adjust according to your program)
        $display("\n");
        $display("╔═══════════════════════════════════════════════════════════╗");
        $display("║                  Result verification                      ║");
        $display("╚═══════════════════════════════════════════════════════════╝");
        
        
        check_register(8, 32'd4, "x8");
        check_register(9, 32'd12, "x9");
        check_register(18, 32'd16, "x18");
        check_data_memory(32'd00, 32'd16);
        //check_data_memory(32'd20, 32'd0);
        check_register(10, 32'd16, "x10");

        // Summary
        $display("\n");
        $display("╔═══════════════════════════════════════════════════════════╗");
        $display("║                        Summary                            ║");
        $display("╚═══════════════════════════════════════════════════════════╝");
        $display("Total cycles executed: %0d", cycle_count);
        $display("Total errors: %0d", error_count);
        
        if (error_count == 0) begin
            $display("\n✅ All tests passed successfully!");
        end else begin
            $display("\n❌ Found %0d errors", error_count);
        end
        
        #100;
        $finish;
    end
    
    // Continuous monitoring (optional - comment if it generates too much output)
    /*
    initial begin
        $display("\n=== Continuous monitoring (each cycle) ===");
        $monitor("Time=%0t | Cycle=%0d | PC=0x%08h | Instr=0x%08h | x1=%0d x2=%0d x3=%0d", 
                 $time, cycle_count, dut.PC, dut.Instruction,
                 $signed(dut.reg_unit_inst.ru[1]),
                 $signed(dut.reg_unit_inst.ru[2]),
                 $signed(dut.reg_unit_inst.ru[3]));
    end
    */
    
    // Safety timeout
    initial begin
        #10000;  // 10 microseconds
        $error("⏱️  TIMEOUT: Testbench took too long");
        $finish;
    end

endmodule
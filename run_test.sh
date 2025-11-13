#!/bin/bash
# filepath: risc-v_single_cycle_processor/run_test.sh

echo "🔨 Compiling RISC-V Single Cycle Processor..."

iverilog -g2012 -o riscv_sim \
    RiscV_SingleCycle.sv \
    RiscV_SingleCycle_tb.sv \
    ProgramCounter/ProgramCounter.sv \
    InstructionMemory/InstructionMemory.sv \
    ControlUnit/ControlUnit.sv \
    RegistersUnit/RegistersUnit.sv \
    ImmGen/ImmGen.sv \
    ALU/ALU.sv \
    BranchUnit/BranchUnit.sv \
    DataMemory/DataMemory.sv \
    muxs/ALUA.sv \
    muxs/ALUB.sv \
    muxs/NextPC.sv \
    muxs/RUDataWr.sv

if [ $? -eq 0 ]; then
    echo "✅ Compilation successful"
    echo "▶️  Running simulation..."
    echo ""
    vvp riscv_sim
else
    echo "❌ Compilation failed"
    exit 1
fi
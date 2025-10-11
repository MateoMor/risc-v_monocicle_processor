# RISC-V Single-Cycle Processor

This repository contains the source code of a single-cycle RISC-V processor written in SystemVerilog. Each processor module lives in its own folder to keep navigation, synthesis, and simulation straightforward.

## Project Organization

- **Module folders**: every directory groups a functional block of the processor. Each module uses `modulo.sv` as its main file and `modulo_tb.sv` as the associated testbench.
- **Simulation artifacts**: testbenches generate the dump file `alu_tb.out`, capturing signal activity for later inspection.
- **Quartus files (`.qpf` and `.qsf`)**: `alu.qpf` defines the Quartus project, while `alu.qsf` holds FPGA device settings, pin assignments, and compilation options. Use them to prepare the design for an Intel Quartus FPGA workflow.

## Simulation and Waveforms

1. **Compile and run**: use `iverilog` to build and simulate the modules. For example:

```powershell
iverilog -g2012 -o alu_tb.out alu_10_entradas/alu_tb.sv alu_10_entradas/alu.sv
vvp alu_tb.out
```

1. **Inspect signals**: open the generated VCD with the WaveTrace extension for VS Code or any waveform viewer you prefer.

## FPGA Flow

To deploy the design to hardware, open the project in Intel Quartus with `alu.qpf`. Configure options and pin assignments in `alu.qsf`, run synthesis, and program the target FPGA.

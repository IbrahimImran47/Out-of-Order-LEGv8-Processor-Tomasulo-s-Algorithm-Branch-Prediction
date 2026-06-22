# LEGv8 Out-of-Order Processor — Tomasulo's Algorithm + Branch Prediction

*Status: in progress*

An out-of-order LEGv8/ARMv8 processor in SystemVerilog, built on top of the in-order pipeline from [EE469](https://github.com/IbrahimImran47/EE469-Labs) at the University of Washington. Implements Tomasulo's algorithm — reservation stations, a common data bus, dynamic register renaming — plus a reorder buffer for clean misprediction recovery and a global-history branch predictor.

## Why this exists

EE469 builds a 5-stage in-order pipelined LEGv8 CPU. This project takes that further: real out-of-order execution, speculative branch prediction, and a performance evaluation comparing the two designs head-to-head. 

## What's being built

- **Reservation stations** — instructions issue out of program order, executing as soon as their operands are ready instead of waiting their turn
- **Common Data Bus (CDB)** — broadcasts results to every waiting reservation station and the register file simultaneously
- **Register Status Table** — tracks whether each register's value is ready, or still pending from some in-flight instruction
- **Reorder Buffer** — buffers speculative results until they're confirmed safe to commit, so a branch misprediction is just a discard, not a register-file repair job
- **Branch predictor** — global-history based, not the simple 4-state FSM version
- **Performance evaluation** — IPC, misprediction rate, and a direct comparison against the EE469 baseline pipeline

## Structure (built lab-by-lab, EE469-style)

 Deliverable |
|---|---|
| 1 | Issue-stage decoder (instruction classification + routing) |
| 2 | Register Status Table |
| 3 | ALU reservation station + CDB + issue loop |
| 4 | Load/store buffers |
| 5 | Branch RS (non-speculative) |
| 6 | Branch predictor + speculation + reorder buffer recovery |
| 7 | Performance evaluation |
| 8 | DE1-SoC deployment (stretch goal) |

**Current status:** Lab 1, in progress.

## Reused from prior work

`regfile.sv`, `alu.sv` (+ `aluOneBitSlice.sv`), `branch.sv`, `flags.sv`, `extend.sv`, and the mux/`D_FF`/`Decoder`/`register64bit` support modules are reused as-is from [EE469-Labs](https://github.com/IbrahimImran47/EE469-Labs). `control.sv` is reused as a starting template, extended significantly for the new instruction set and routing logic. The pipeline control logic (`cpu.sv`, `forwarding_unit.sv`) is fully discarded — out-of-order execution needs a different control structure entirely.

## Tools

SystemVerilog, Icarus Verilog + GTKWave for simulation, Quartus II + ModelSim for the eventual FPGA build, targeting a DE1-SoC board.

## License

MIT

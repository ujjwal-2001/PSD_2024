# Design and Implementation of a 16-bit Multi-Cycle Processor

**Author**: Ujjwal Chaudhary, 22577  
**Date**: Sept-2024

## Table of Contents
- [Introduction](#introduction)
- [Processor Design](#processor-design)
  - [Instructions](#instructions)
  - [Data-Path Design](#data-path-design)
  - [Finite State Machine (FSM) Design](#finite-state-machine-fsm-design)
- [Implementation](#implementation)
  - [Test Bench](#test-bench)
  - [Reports](#reports)
- [Conclusion](#conclusion)

## Introduction

This assignment aimed to design and implement a 16-bit multi-cycle processor using the Digilent BASYS3 FPGA Board. Based on a RISC (Reduced Instruction Set Computer) architecture, the processor operates within a 16-bit address space and supports a minimal set of arithmetic, logic, and branch instructions. The design employs a multi-cycle approach, where each instruction is broken down into several stages: fetch, decode, execute, and write-back, each occurring in distinct cycles.

An Instruction Prefetch Register (IPR) was utilized to enhance the processor's efficiency, enabling the concurrent fetching of the next instruction while the current instruction is being processed. By overlapping the instruction fetch stage with the execution of the current instruction, the overall throughput is improved, reducing idle cycles.

The design was tested by implementing an algorithm to find the maximum number from a set of ten random numbers. This report outlines the processor's datapath and finite state machine (FSM) designs, timing analysis, and resource utilization on the Xilinx Artix-7 XC7A35T-1CPG236C FPGA. The test results confirm the processor's ability to perform the required tasks efficiently.

## Processor Design

### Instructions

The instruction set supported by the processor is a limited subset, sufficient for basic arithmetic, logical operations, and control flow mechanisms like branching. 

#### Instruction Format
<img src="/Assignment 01/Assets/instruction format.pdf" alt="Instruction Format" width="500"/>

The ALU control inputs for different instructions, based on their ALUOp and operation types, are listed in Table 1.

#### Table 1: ALU Control Signals for Instructions

| Instruction | ALUOp  | Operation | ALU Control Input |
| ----------- | ------ | --------- | ----------------- |
| ADD         | 00     | Addition  | 010               |
| SUB         | 01     | Subtract  | 110               |
| AND         | 10     | AND       | 000               |
| OR          | 10     | OR        | 001               |
| SLT         | 10     | Set on Less Than | 111        |

### Data-Path Design

The datapath design for the 16-bit processor was constructed using a multi-cycle approach. This means that each instruction is executed over multiple clock cycles, with each stage of execution happening in a distinct phase. 

#### Level 0 Data-path Schematic
<img src="path-to-your-image/level-0-datapath.png" alt="Level 0 Data-path" width="500"/>

#### Level 1 Data-path Schematic
<img src="path-to-your-image/level-1-datapath.png" alt="Level 1 Data-path" width="500"/>

### Finite State Machine (FSM) Design

The Finite State Machine (FSM) design controls the sequence of operations that occur within the datapath during instruction execution.

#### FSM State Diagram
<img src="path-to-your-image/fsm-state-diagram.png" alt="FSM State Diagram" width="500"/>

## Implementation

### Test Bench

The testbench developed for this processor verifies its correct operation by simulating a set of instructions that find the maximum value from an array of ten numbers stored in memory. The instructions governing the algorithm are outlined in Table 2.

#### Table 2: Test Program Instructions

| Address | Instruction         | Remark                           | 16-bit Representation |
| ------- | ------------------- | --------------------------------- | --------------------- |
| 0x00    | LD R0, R1, 50        | R1 ← M[R0 + 50]                   | 001 000 001 0110010    |
| 0x01    | ADDi R0, R2, 1       | R2 ← R0 + 1                       | 101 000 010 0000001    |
| 0x02    | ADDi R0, R5, 10      | R5 ← R0 + 10                      | 101 000 101 0001010    |
| 0x03    | LD R2, R3, 50        | R3 ← M[R2 + 50]                   | 001 010 011 0110010    |
| 0x04    | SLT R1, R3, R4       | R4 ← R1 < R3                      | 000 001 011 100 0111   |
| 0x05    | BEQ R4, R0, 0x02     | If R4 == R0; PC ← PC + 1          | 011 100 000 0000001    |
| 0x06    | ADD R0, R3, R1       | R1 ← R3 + R0                      | 000 000 011 001 0010   |
| 0x07    | ADDi R2, R2, 1       | R2 ← R2 + 1                       | 101 010 010 0000001    |
| 0x08    | SLT R2, R5, R4       | R4 ← R2 < R5                      | 000 010 101 100 0111   |
| 0x09    | BEQ R4, R0, 0x03     | If R4 == R0; PC ← PC + 1          | 011 100 000 0000001    |
| 0x0A    | J 0x04               | PC ← 0x04                         | 100 0000000000100      |
| 0x0B    | END                  | End of program                    | 111 0000000000000      |

### Reports

The timing report from the FPGA synthesis tool confirmed that all setup and hold times were met, and there were no timing violations at 10ns clock period.

#### Figure 7: Timing Report
<img src="./Assets/" alt="Timing Report" width="500"/>

#### Figure 8: Power Report
<img src="path-to-your-image/power-report.png" alt="Power Report" width="500"/>

## Conclusion

This project demonstrates the successful implementation of a 16-bit multi-cycle processor on the Digilent BASYS3 FPGA board. Future work could expand the instruction set to support additional operations, such as multiplication and division, and incorporate optimizations like branch prediction to improve performance further.

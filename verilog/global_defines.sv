// ALU Modes
`define ALU_NON 8'h00 // No operation
`define ALU_ADD 8'h01 // ADD A + B
`define ALU_SUB 8'h02 // SUB A - B
`define ALU_AND 8'h03 // AND A & BS
`define ALU_OR  8'h04 // OR A | B
`define ALU_XOR 8'h05 // XOR A ^ B
`define ALU_NOT 8'h06 // NOT ~A
`define ALU_SHL 8'h07 // SHL A << 1
`define ALU_SHR 8'h08 // SHR A >> 1

// Opcodes
`define NOP 8'h00
`define HALT 8'h01

`define LDAI 8'h02
`define LDA 8'h03
`define STA 8'h04

`define LDBI 8'h05
`define LDB 8'h06
`define STB 8'h07

`define ADDI 8'h08 // Not implemented
`define ADD 8'h09

`define SUBI 8'h0A // Not implemented
`define SUB 8'h0B 

`define ANDI 8'h0C // Not implemented
`define AND 8'h0D 

`define ORI 8'h0E // Not implemented
`define OR 8'h0F 

`define XORI 8'h10 // Not implemented
`define XOR 8'h11

`define NOT 8'h12 // NOT Not implemented

`define SHLI 8'h13 // Not implemented
`define SHL 8'h14

`define SHRI 8'h15 // Not implemented
`define SHR 8'h16

`define JMP 8'h17
`define JZ 8'h18
`define JC 8'h19 // Not implemented
`define JNZ 8'h1A
`define JNC 8'h1B // Not implemented


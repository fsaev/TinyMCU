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
`define LDA_HL 8'h03
`define STA_HL 8'h04

`define LDBI 8'h05
`define LDB_HL 8'h06
`define STB_HL 8'h07

`define LDLI 8'h08
`define LDHI 8'h09

`define ADDI 8'h0A // Not implemented
`define ADD 8'h0B

`define SUBI 8'h0C // Not implemented
`define SUB 8'h0D 

`define ANDI 8'h0E // Not implemented
`define AND 8'h0F 

`define ORI 8'h10 // Not implemented
`define OR 8'h11 

`define XORI 8'h12 // Not implemented
`define XOR 8'h13

`define NOT 8'h14 // NOT Not implemented

`define SHLI 8'h15 // Not implemented
`define SHL 8'h16

`define SHRI 8'h17 // Not implemented
`define SHR 8'h18

`define JMP 8'h19
`define JZ 8'h1A
`define JC 8'h1B // Not implemented
`define JNZ 8'h1C
`define JNC 8'h1D // Not implemented

`define MOV_AB 8'h1E
`define MOV_AH 8'h1F
`define MOV_AL 8'h20

`define MOV_BA 8'h21
`define MOV_BH 8'h22
`define MOV_BL 8'h23

`define MOV_HA 8'h24
`define MOV_HB 8'h25
`define MOV_HL 8'h26

`define MOV_LA 8'h27
`define MOV_LB 8'h28
`define MOV_LH 8'h29

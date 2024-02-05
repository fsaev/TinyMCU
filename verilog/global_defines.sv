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
`define LDA_RAM 8'h04
`define STA_HL 8'h05
`define STA_RAM 8'h06

`define LDBI 8'h07
`define LDB_HL 8'h08
`define LDB_RAM 8'h09
`define STB_HL 8'h0A
`define STB_RAM 8'h0B

`define LDLI 8'h0C
`define LDHI 8'h0D

`define ADDI 8'h0E // Not implemented
`define ADD 8'h0F

`define SUBI 8'h10 // Not implemented
`define SUB 8'h11

`define ANDI 8'h12 // Not implemented
`define AND 8'h13

`define ORI 8'h14 // Not implemented
`define OR 8'h15

`define XORI 8'h16 // Not implemented
`define XOR 8'h17

`define NOT 8'h18 // NOT Not implemented

`define SHLI 8'h19 // Not implemented
`define SHL 8'h1A

`define SHRI 8'h1B // Not implemented
`define SHR 8'h1C

`define JMP 8'h1D
`define JZ 8'h1E
`define JC 8'h1F // Not implemented
`define JNZ 8'h20
`define JNC 8'h21 // Not implemented

`define MOV_AB 8'h22
`define MOV_AH 8'h23
`define MOV_AL 8'h24

`define MOV_BA 8'h25
`define MOV_BH 8'h26
`define MOV_BL 8'h27

`define MOV_HA 8'h28
`define MOV_HB 8'h29
`define MOV_HL 8'h2A

`define MOV_LA 8'h2B
`define MOV_LB 8'h2C
`define MOV_LH 8'h2D

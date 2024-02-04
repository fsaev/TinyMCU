# TinyMCU
A tiny custom made 8-bit processor with MMIO peripherals, made for Xilinx FPGA

## Compile
Install verilator and make
Run "make" and "make toptrace.vcd"
Open toptrace.vcd with gtkwave

## Status
This project is still a work in progress. The CPU works, you can have some fun by doing some assembly level programming in simple_ram.sv.

### CPU
Implemented
NOP, HALT, LDAI, LDA, STA, LDBI, LDB, STB, ADD, SUB, AND, OR, XOR, NOT, SHL, SHR, JMP, JZ, JNZ

TODO
ADDI, SUBI, ANDI, ORI, XORI, SHLI, SHRI, JC, JNC

### RAM
Work in progress, support for block RAM and external memory

### UART
Work in progress

### SPI
TODO

### I2C
TODO

### Timer
Work in progress

### VGA w/hardware rendering
Wishlist

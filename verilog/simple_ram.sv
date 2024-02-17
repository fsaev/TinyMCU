/* verilator lint_off UNUSED */
/* verilator lint_off UNDRIVEN*/
/* verilator lint_off DECLFILENAME*/
/* verilator lint_off PINMISSING */

`include "global_defines.sv"

module simple_ram(
    input [2:0] device_select,
    input clk,
    input [15:0] addr_in,
    input we,
    input oe,
    input [7:0] data_in,
    output reg [7:0] data_out
    );

    parameter device_address = 3'b001;

    reg [7:0] mem [0:255];

    initial begin
        mem[0] = `NOP;
        mem[1] = `LDAI;
        mem[2] = 8'h03; // Enable RX and TX
        mem[3] = `STA_RAM;
        mem[4] = 8'hF0; // On UART CR
        mem[5] = 8'h00;

        mem[6] = `LDHI;
        mem[7] = 8'h00;
        mem[8] = `LDLI;
        mem[9] = 8'h80; // Start of string in HL

        // START OF LOOP
        mem[10] = `LDBI;
        mem[11] = 8'h00; // Load B with 0x00
        mem[12] = `LDA_HL; // Read character at HL into A
        mem[13] = `XOR; // XOR with 0x00 to check for null
        mem[14] = `JZ; // If null, jump to end of program
        mem[15] = 8'h00; //
        mem[16] = 8'h28; //

        // WAIT FOR TXR
        mem[17] = `LDA_RAM; // Load A
        mem[18] = 8'hF0; // On UART CR
        mem[19] = 8'h01; // SR register
        mem[20] = `LDBI;
        mem[21] = 8'h02; // Load B with 0x02 // TXR mask
        mem[22] = `AND; // AND with 0x02
        mem[23] = `JZ; // If null, jump to WAIT FOR TXR
        mem[24] = 8'h00; //
        mem[25] = 8'h10; // Back to 17

        mem[26] = `STA_RAM; // Store A
        mem[27] = 8'hF0; // On UART
        mem[28] = 8'h05; // DO register

        mem[29] = `MOV_LA; // Load A with L
        mem[30] = `LDBI;
        mem[31] = 8'h01; // Load B with 0x01
        mem[32] = `ADD; // Add 1 to A
        mem[33] = `MOV_AL; // Load L with A
        mem[34] = `JNC; // If no carry, jump to START OF LOOP
        mem[35] = 8'h00; //
        mem[36] = 8'h0A; //

        mem[37] = `MOV_HA; // Load A with H
        mem[38] = `ADD; // Add 1 to A
        mem[39] = `MOV_AH; // Load H with A
        mem[40] = `JMP; // Jump to START OF LOOP
        mem[41] = 8'h00; //
        mem[42] = 8'h0A; //


        // END OF PROGRAM
        mem[40] = `HALT;

        mem[128] = "H";
        mem[129] = "e";
        mem[130] = "l";
        mem[131] = "l";
        mem[132] = "o";
        mem[133] = " ";
        mem[134] = "W";
        mem[135] = "o";
        mem[136] = "r";
        mem[137] = "l";
        mem[138] = "d";
        mem[139] = "!";
        mem[140] = "\n";
        mem[141] = "\r";
        mem[140] = 8'h00;

    end

    assign data_out = (oe && (device_address == device_select)) ? mem[addr_in[7:0]] : 8'hZZ;

    always @(posedge clk)
    begin
        if (we && (device_address == device_select))
            mem[addr_in[7:0]] <= data_in;
    end
endmodule

/* verilator lint_off UNUSED */
/* verilator lint_off UNDRIVEN*/
/* verilator lint_off DECLFILENAME*/

`include "global_defines.sv"

`define RESET_REGISTERS \
    areg_load = 0; \
    areg_out = 0; \
    breg_load = 0; \
    breg_out = 0; \
    hreg_load = 0; \
    hreg_out = 0; \
    lreg_load = 0; \
    lreg_out = 0; \
    mreg_l_load = 0; \
    mreg_h_load = 0; \
    ireg_load = 0; \
    ireg_reset = 0; \
    ram_write = 0; \
    ram_read_pc = 0; \
    ram_read_mreg = 0; \
    oreg_load = 0; \
    freg_load = 0; \
    alu_out = 0; \
    alu_mode = 8'h00; \
    cnt_en = 0; \
    cnt_wr = 0; \
    halt = 0;

module controller(input clk, input reset, input wire [7:0] opcode, input alu_carry, input alu_zero,
                    output reg areg_load, output reg areg_out, output reg breg_load, output reg breg_out,
                    output reg hreg_load, output reg hreg_out, output reg lreg_load, output reg lreg_out,
                    output reg mreg_l_load, output reg mreg_h_load, output reg ireg_load, output reg ireg_reset,
                    output reg ram_write, output reg ram_read_pc, output reg ram_read_mreg, output reg oreg_load, 
                    output reg freg_load, output reg alu_out, output reg [7:0] alu_mode, output reg cnt_en, output reg cnt_l_out, 
                    output reg cnt_h_out, output reg cnt_wr, output reg halt,
                    // Informative outputs
                    output wire [3:0] stage_no
                    );


    // Pipeline stage counter
    reg [3:0] stage;
    assign stage_no = stage;

    //Pipeline control
    always_ff @(posedge clk)
    begin
        if (reset) begin
            stage <= 4'b0000; //Reset stage
        end else if (ireg_reset) begin
            stage <= 4'b0000; //Reset stage
        end else begin
            stage <= stage + 4'h1; //Increment stage
        end
    end

    // Instructions
    always_comb
    begin
        `RESET_REGISTERS
    
        case (opcode)
            `NOP: begin // NOP
                if (stage == 0) begin // Fetch next instruction
                    ireg_load = 1;
                    ireg_reset = 1;
                    ram_read_pc = 1;
                    cnt_en = 1;
                end
            end
            `HALT: begin // HALT
                if (stage == 0) begin
                    halt = 1;
                end
            end
            `LDAI: begin // LDA (Immediate)
                if (stage == 0) begin // Load into A
                    areg_load = 1;
                    ram_read_pc = 1;
                    cnt_en = 1;
                end else if (stage == 1) begin // Fetch next instruction
                    ireg_load = 1;
                    ireg_reset = 1;
                    ram_read_pc = 1;
                    cnt_en = 1;
                end
            end
            `LDA_HL: begin // LDA (HL)
                if (stage == 0) begin // Load into MREG_H
                    mreg_h_load = 1;
                    hreg_out = 1;
                end else if (stage == 1) begin // Load into MREG_L
                    mreg_l_load = 1;
                    lreg_out = 1;
                end else if (stage == 2) begin // Read from RAM into A using MREG as address 
                    areg_load = 1;
                    ram_read_mreg = 1;
                end else if (stage == 3) begin // Get next instruction
                    ireg_load = 1;
                    ireg_reset = 1;
                    ram_read_pc = 1;
                    cnt_en = 1;
                end
            end
            `STA_HL: begin // STA (HL)
                if (stage == 0) begin // Load into MREG_H
                    mreg_h_load = 1;
                    hreg_out = 1;
                end else if (stage == 1) begin // Load into MREG_L
                    mreg_l_load = 1;
                    lreg_out = 1;
                end else if (stage == 2) begin // Write to RAM from A using MREG as address 
                    areg_out = 1;
                    ram_write = 1;
                end else if (stage == 3) begin // Get next instruction
                    ireg_load = 1;
                    ireg_reset = 1;
                    ram_read_pc = 1;
                    cnt_en = 1;
                end
            end
            `LDBI: begin // LDB (Immediate)
                if (stage == 0) begin // Load into A
                    breg_load = 1;
                    ram_read_pc = 1;
                    cnt_en = 1;
                end else if (stage == 1) begin // Fetch next instruction
                    ireg_load = 1;
                    ireg_reset = 1;
                    ram_read_pc = 1;
                    cnt_en = 1;
                end
            end
            `LDB_HL: begin // LDB (HL)
                if (stage == 0) begin // Load into MREG_H
                    mreg_h_load = 1;
                    hreg_out = 1;
                end else if (stage == 1) begin // Load into MREG_L
                    mreg_l_load = 1;
                    lreg_out = 1;
                end else if (stage == 2) begin // Read from RAM into A using MREG as address 
                    breg_load = 1;
                    ram_read_mreg = 1;
                end else if (stage == 3) begin // Get next instruction
                    ireg_load = 1;
                    ireg_reset = 1;
                    ram_read_pc = 1;
                    cnt_en = 1;
                end
            end
            `STB_HL: begin // STB (HL)
                if (stage == 0) begin // Load into MREG_H
                    mreg_h_load = 1;
                    hreg_out = 1;
                end else if (stage == 1) begin // Load into MREG_L
                    mreg_l_load = 1;
                    lreg_out = 1;
                end else if (stage == 2) begin // Write to RAM from A using MREG as address 
                    breg_out = 1;
                    ram_write = 1;
                end else if (stage == 3) begin // Get next instruction
                    ireg_load = 1;
                    ireg_reset = 1;
                    ram_read_pc = 1;
                    cnt_en = 1;
                end
            end
            `ADD: begin // ADD
                if (stage == 0) begin // Prepare ALU
                    alu_mode = `ALU_ADD;
                end else if (stage == 1) begin // ADD A + B
                    areg_load = 1;
                    alu_out = 1;
                end else if (stage == 2) begin // Fetch next instruction
                    ireg_load = 1;
                    ireg_reset = 1;
                    ram_read_pc = 1;
                    cnt_en = 1;
                end
            end
            `SUB: begin // SUB
                if (stage == 0) begin // Prepare ALU
                    alu_mode = `ALU_SUB;
                end else if (stage == 1) begin // ADD A + B
                    areg_load = 1;
                    alu_out = 1;
                end else if (stage == 2) begin // Fetch next instruction
                    ireg_load = 1;
                    ireg_reset = 1;
                    ram_read_pc = 1;
                    cnt_en = 1;
                end
            end
            `AND: begin // AND
                if (stage == 0) begin // Load into MREG_H
                    alu_mode = `ALU_AND;
                end else if (stage == 1) begin // Load into MREG_L
                    areg_load = 1;
                    alu_out = 1;
                end else if (stage == 2) begin // Write to RAM from A using MREG as address 
                    ireg_load = 1;
                    ireg_reset = 1;
                    ram_read_pc = 1;
                    cnt_en = 1;
                end
            end
            `OR: begin // OR
                if (stage == 0) begin // Load into MREG_H
                    alu_mode = `ALU_OR;
                end else if (stage == 1) begin // Load into MREG_L
                    areg_load = 1;
                    alu_out = 1;
                end else if (stage == 2) begin // Write to RAM from A using MREG as address 
                    ireg_load = 1;
                    ireg_reset = 1;
                    ram_read_pc = 1;
                    cnt_en = 1;
                end
            end
            `XOR: begin // XOR
                if (stage == 0) begin // Load into MREG_H
                    alu_mode = `ALU_XOR;
                end else if (stage == 1) begin // Load into MREG_L
                    areg_load = 1;
                    alu_out = 1;
                end else if (stage == 2) begin // Write to RAM from A using MREG as address 
                    ireg_load = 1;
                    ireg_reset = 1;
                    ram_read_pc = 1;
                    cnt_en = 1;
                end
            end
            `NOT: begin // NOT
                if (stage == 0) begin // Load into MREG_H
                    alu_mode = `ALU_NOT;
                end else if (stage == 1) begin // Load into MREG_L
                    areg_load = 1;
                    alu_out = 1;
                end else if (stage == 2) begin // Write to RAM from A using MREG as address 
                    ireg_load = 1;
                    ireg_reset = 1;
                    ram_read_pc = 1;
                    cnt_en = 1;
                end
            end
            `SHL: begin // SHL
                if (stage == 0) begin // Load into MREG_H
                    alu_mode = `ALU_SHL;
                end else if (stage == 1) begin // Load into MREG_L
                    areg_load = 1;
                    alu_out = 1;
                end else if (stage == 2) begin // Write to RAM from A using MREG as address 
                    ireg_load = 1;
                    ireg_reset = 1;
                    ram_read_pc = 1;
                    cnt_en = 1; 
                end
            end
            `SHR: begin // SHR
                if (stage == 0) begin // Load into MREG_H
                    alu_mode = `ALU_SHR;
                end else if (stage == 1) begin // Load into MREG_L
                    areg_load = 1;
                    alu_out = 1;
                end else if (stage == 2) begin // Write to RAM from A using MREG as address 
                    ireg_load = 1;
                    ireg_reset = 1;
                    ram_read_pc = 1;
                    cnt_en = 1; 
                end
            end
            `JMP: begin // JMP (ADDR_H ADDR_L)
                if (stage == 0) begin // Load into MREG_H
                    mreg_h_load = 1;
                    ram_read_pc = 1;
                    cnt_en = 1;
                end else if (stage == 1) begin // Load into MREG_L
                    mreg_l_load = 1;
                    ram_read_pc = 1;
                    cnt_en = 1;
                end else if (stage == 2) begin // Write MREG_H + MREG_L to PC
                    cnt_wr = 1;
                end else if (stage == 3) begin // Fetch next instruction
                    ireg_load = 1;
                    ireg_reset = 1;
                    ram_read_pc = 1;
                    cnt_en = 1;
                end
            end
            `JZ: begin // JZ (ADDR_H ADDR_L)
                if (stage == 0) begin // Test if alu_zero is set
                    if(!alu_zero) begin // If not, fetch next instruction
                        ireg_load = 1;
                        ireg_reset = 1;
                        ram_read_pc = 1;
                        cnt_en = 1;
                    end
                end else if (stage == 1) begin // Load into MREG_H
                    mreg_h_load = 1;
                    ram_read_pc = 1;
                    cnt_en = 1;
                end else if (stage == 2) begin // Load into MREG_L
                    mreg_l_load = 1;
                    ram_read_pc = 1;
                    cnt_en = 1;
                end else if (stage == 3) begin // Write MREG_H + MREG_L to PC if zero flag is set
                    cnt_wr = 1;
                end else if (stage == 4) begin // Fetch next instruction
                    ireg_load = 1;
                    ireg_reset = 1;
                    ram_read_pc = 1;
                    cnt_en = 1;
                end
            end
            `JNZ: begin // JNZ (ADDR_H ADDR_L)
                if (stage == 0) begin // Test if alu_zero is set
                    if(alu_zero) begin // If it is, fetch next instruction
                        ireg_load = 1;
                        ireg_reset = 1;
                        ram_read_pc = 1;
                        cnt_en = 1;
                    end
                end else if (stage == 1) begin // Load into MREG_H
                    mreg_h_load = 1;
                    ram_read_pc = 1;
                    cnt_en = 1;
                end else if (stage == 2) begin // Load into MREG_L
                    mreg_l_load = 1;
                    ram_read_pc = 1;
                    cnt_en = 1;
                end else if (stage == 3) begin // Write MREG_H + MREG_L to PC if zero flag is set
                    cnt_wr = 1;
                end else if (stage == 4) begin // Fetch next instruction
                    ireg_load = 1;
                    ireg_reset = 1;
                    ram_read_pc = 1;
                    cnt_en = 1;
                end
            end
            `MOV_AB: begin // MOV A -> B
                if (stage == 0) begin // Load into B
                    areg_out = 1;
                    breg_load = 1;
                end else if (stage == 1) begin // Fetch next instruction
                    ireg_load = 1;
                    ireg_reset = 1;
                    ram_read_pc = 1;
                    cnt_en = 1;
                end
            end
            `MOV_AH: begin // MOV A -> H
                if (stage == 0) begin // Load into H
                    areg_out = 1;
                    hreg_load = 1;
                end else if (stage == 1) begin // Fetch next instruction
                    ireg_load = 1;
                    ireg_reset = 1;
                    ram_read_pc = 1;
                    cnt_en = 1;
                end
            end
            `MOV_AL: begin // MOV A -> L
                if (stage == 0) begin // Load into L
                    areg_out = 1;
                    lreg_load = 1;
                end else if (stage == 1) begin // Fetch next instruction
                    ireg_load = 1;
                    ireg_reset = 1;
                    ram_read_pc = 1;
                    cnt_en = 1;
                end
            end
            `MOV_BA: begin // MOV B -> A
                if (stage == 0) begin // Load into A
                    breg_out = 1;
                    areg_load = 1;
                end else if (stage == 1) begin // Fetch next instruction
                    ireg_load = 1;
                    ireg_reset = 1;
                    ram_read_pc = 1;
                    cnt_en = 1;
                end
            end
            `MOV_BH: begin // MOV B -> H
                if (stage == 0) begin // Load into H
                    breg_out = 1;
                    hreg_load = 1;
                end else if (stage == 1) begin // Fetch next instruction
                    ireg_load = 1;
                    ireg_reset = 1;
                    ram_read_pc = 1;
                    cnt_en = 1;
                end
            end
            `MOV_BL: begin // MOV B -> L
                if (stage == 0) begin // Load into L
                    breg_out = 1;
                    lreg_load = 1;
                end else if (stage == 1) begin // Fetch next instruction
                    ireg_load = 1;
                    ireg_reset = 1;
                    ram_read_pc = 1;
                    cnt_en = 1;
                end
            end
            `MOV_HA: begin // MOV H -> A
                if (stage == 0) begin // Load into A
                    hreg_out = 1;
                    areg_load = 1;
                end else if (stage == 1) begin // Fetch next instruction
                    ireg_load = 1;
                    ireg_reset = 1;
                    ram_read_pc = 1;
                    cnt_en = 1;
                end
            end
            `MOV_HB: begin // MOV H -> B
                if (stage == 0) begin // Load into B
                    hreg_out = 1;
                    breg_load = 1;
                end else if (stage == 1) begin // Fetch next instruction
                    ireg_load = 1;
                    ireg_reset = 1;
                    ram_read_pc = 1;
                    cnt_en = 1;
                end
            end
            `MOV_HL: begin // MOV H -> L
                if (stage == 0) begin // Load into L
                    hreg_out = 1;
                    lreg_load = 1;
                end else if (stage == 1) begin // Fetch next instruction
                    ireg_load = 1;
                    ireg_reset = 1;
                    ram_read_pc = 1;
                    cnt_en = 1;
                end
            end
            'MOV_LA: begin // MOV L -> A
                if (stage == 0) begin // Load into A
                    lreg_out = 1;
                    areg_load = 1;
                end else if (stage == 1) begin // Fetch next instruction
                    ireg_load = 1;
                    ireg_reset = 1;
                    ram_read_pc = 1;
                    cnt_en = 1;
                end
            end
            `MOV_LB: begin // MOV L -> B
                if (stage == 0) begin // Load into B
                    lreg_out = 1;
                    breg_load = 1;
                end else if (stage == 1) begin // Fetch next instruction
                    ireg_load = 1;
                    ireg_reset = 1;
                    ram_read_pc = 1;
                    cnt_en = 1;
                end
            end
            `MOV_LH: begin // MOV L -> H
                if (stage == 0) begin // Load into H
                    lreg_out = 1;
                    hreg_load = 1;
                end else if (stage == 1) begin // Fetch next instruction
                    ireg_load = 1;
                    ireg_reset = 1;
                    ram_read_pc = 1;
                    cnt_en = 1;
                end
            end
            default: begin
                // Reset all signals
                `RESET_REGISTERS
            end
        endcase
    end

endmodule

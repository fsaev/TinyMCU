/* verilator lint_off UNUSED */
/* verilator lint_off UNDRIVEN*/
/* verilator lint_off DECLFILENAME*/

`include "global_defines.sv"

module alu(input clk, input reset, input wire [7:0] a, input wire [7:0] b, input wire [7:0] mode, output [7:0] out, output reg carry, output reg zero);

    // ALU mode is persistent until pipeline resets at the beginning of a new ALU operation
    // This persistence is used for when doing conditional jumps
    reg [8:0] sum_reg; // Append 1 bit for carry
    reg [7:0] alu_mode;

    assign out = sum_reg[7:0];

    always_ff @(posedge clk) begin
        if(mode != `ALU_NON)
            alu_mode <= mode;
        if(reset)
            alu_mode <= `ALU_NON;
    end

    always_comb
    begin
        case (alu_mode)
            `ALU_ADD: begin // ADD
                sum_reg = a + b;
                carry = (sum_reg[8] == 1'b1);
                zero = (out == 8'h00);
            end
            `ALU_SUB: begin // SUB
                sum_reg = a - b;
                carry = (sum_reg[8] == 1'b1);
                zero = (out == 8'h00);
            end
            `ALU_AND: begin // AND
                sum_reg[8] = 1'b0;
                sum_reg[7:0] = a & b;
                carry = 1'b0;
                zero = (out == 8'h00);
            end
            `ALU_OR: begin // OR
                sum_reg[8] = 1'b0;
                sum_reg[7:0] = a | b;
                carry = 1'b0;
                zero = (out == 8'h00);
            end
            `ALU_XOR: begin // XOR
                sum_reg[8] = 1'b0;
                sum_reg[7:0] = a ^ b;
                carry = 1'b0;
                zero = (out == 8'h00);
            end
            `ALU_NOT: begin // NOT
                sum_reg[8] = 1'b0;
                sum_reg[7:0] = ~a;
                carry = 1'b0;
                zero = (out == 8'h00);
            end
            `ALU_SHL: begin // SHL
                sum_reg[8] = 1'b0;
                sum_reg[7:0] = a << 1;
                carry = sum_reg[8];
                zero = (out == 8'h00);
            end
            `ALU_SHR: begin // SHR
                sum_reg[8] = 1'b0;
                sum_reg[7:0] = a >> 1;
                carry = a[0]; 
                zero = (out == 8'h00);
            end
            default: begin
                sum_reg = 9'h000;
                carry = 1'b0;
                zero = 1'b0;
            end
        endcase
    end
endmodule

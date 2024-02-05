/* verilator lint_off UNUSED */
/* verilator lint_off UNDRIVEN*/
/* verilator lint_off DECLFILENAME*/
/* verilator lint_off PINMISSING */

module cpu(input clk_in, input reset_in, 
        input wire [7:0] data_in, output wire [7:0] data_out,
        output wire [15:0] addr_out,
        output wire ram_wr, output wire ram_oe, output wire [3:0] stage_no);

// Also stop clk when reset is high
wire clk_ctrl;
assign clk_ctrl = (reset_in || halt) ? 1'b0 : clk_in;

wire [15:0] addr;
wire [7:0] data;

wire alu_carry, alu_zero, alu_out,
     areg_load, areg_out, breg_load, breg_out,
     hreg_load, hreg_out, lreg_load, lreg_out,
     mreg_l_load, mreg_h_load, ireg_load, ireg_reset, ram_write,
     ram_read_pc, ram_read_mreg, oreg_load, oreg_out, freg_load,
     cnt_en, cnt_l_out, cnt_h_out, cnt_wr, halt;

assign ram_oe = (ram_read_pc || ram_read_mreg) ? 1'b1 : 1'b0; // RAM output enable
assign ram_wr = ram_write; // RAM write enable

wire [7:0] opcode;
wire [7:0] alu_mode;

controller controller(.clk(clk_ctrl), .reset(reset_in), .opcode(opcode), 
                      .areg_out(areg_out), .areg_load(areg_load),
                      .breg_out(breg_out), .breg_load(breg_load), .hreg_out(hreg_out), .hreg_load(hreg_load),
                      .lreg_out(lreg_out), .lreg_load(lreg_load), .mreg_h_load(mreg_h_load), .mreg_l_load(mreg_l_load),
                      .ireg_load(ireg_load), .ireg_reset(ireg_reset), .ram_write(ram_write), .ram_read_pc(ram_read_pc),
                      .ram_read_mreg(ram_read_mreg), .oreg_load(oreg_load), .freg_load(freg_load),
                      .alu_out(alu_out), .alu_mode(alu_mode),
                      .alu_carry(alu_carry), .alu_zero(alu_zero), .cnt_en(cnt_en), .cnt_l_out(cnt_l_out),
                      .cnt_h_out(cnt_h_out), .cnt_wr(cnt_wr), .halt(halt), .stage_no(stage_no));

wire [7:0] areg_data_out;
register areg(.clk(clk_ctrl), .we(areg_load), .data_in(data), .data_out(areg_data_out));
wire [7:0] breg_data_out;
register breg(.clk(clk_ctrl), .we(breg_load), .data_in(data), .data_out(breg_data_out));
wire [7:0] hreg_data_out;
register hreg(.clk(clk_ctrl), .we(hreg_load), .data_in(data), .data_out(hreg_data_out)); // H + L are used as a 16-bit register
wire [7:0] lreg_data_out;
register lreg(.clk(clk_ctrl), .we(lreg_load), .data_in(data), .data_out(lreg_data_out));

wire [7:0] ireg_data_out;
register ireg(.clk(clk_ctrl), .we(ireg_load), .data_in(data), .data_out(ireg_data_out)); // Instruction register
assign opcode = ireg_data_out;

//Memory registers are in front of the PC, so PC is not connected to the main bus, but the inputs of mregs are
//      -----
//   -->| H | ----
//  |   -----     |
//  |             |
//DATA             ---> PC (16-bit) ---> ADDR (16-bit) ---> RAM
//  |             |
//  |   -----     |
//   -->| L | ----
//      -----
wire [7:0] mreg_h_data_out;
register mreg_h(.clk(clk_ctrl), .we(mreg_h_load), .data_in(data), .data_out(mreg_h_data_out));
wire [7:0] mreg_l_data_out;
register mreg_l(.clk(clk_ctrl), .we(mreg_l_load), .data_in(data), .data_out(mreg_l_data_out));

wire [15:0] pc_data_out;
counter pc(.clk(clk_ctrl), .load(cnt_wr), .enable(cnt_en), .data_in_h(mreg_h_data_out), .data_in_l(mreg_l_data_out), .data_out(pc_data_out));

wire [7:0] alu_data_out;
alu alu_inst(.clk(clk_ctrl), .reset(reset_in), .a(areg_data_out), .b(breg_data_out), .mode(alu_mode), .out(alu_data_out), .carry(alu_carry), .zero(alu_zero));
// Manage bus access
assign data = areg_out ? areg_data_out : // A on bus
              breg_out ? breg_data_out : // B on bus
              hreg_out ? hreg_data_out : // H on bus
              lreg_out ? lreg_data_out : // L on bus
              alu_out ? alu_data_out : // ALU output on bus
              cnt_l_out ? pc_data_out[7:0] : // Lower 8 bits of PC on bus
              cnt_h_out ? pc_data_out[15:8] : // Higher 8 bits of PC on bus
              (ram_read_pc || ram_read_mreg) ? data_in : 8'bz; // Data from RAM on bus

assign data_out = ram_write ? data : 8'bz; // Put data_out as zero when not writing RAM

// Manage bus access
// If we ram_write or ram_read_mreg, MREG is controlling the bus, otherwise pc is controlling the bus
assign addr[7:0] = (ram_write || ram_read_mreg) ? mreg_l_data_out : pc_data_out[7:0];
assign addr[15:8] = (ram_write || ram_read_mreg) ? mreg_h_data_out : pc_data_out[15:8];

assign addr_out = (ram_read_pc || ram_read_mreg || ram_write) ? addr : 16'bz;

always_comb begin
   if (halt) begin
       $finish;
   end
end

endmodule

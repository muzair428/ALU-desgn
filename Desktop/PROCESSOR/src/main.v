module processor (
    input clk,
    input reset
);

    wire [31:0] pc, pc_next;
    wire [31:0] instruction;
    wire [31:0] result, read1, read2 , word_align_address;
    wire [31:0] write_data, alu_result;
    wire [31:0] immediate;
    wire [31:0] mem_out;
    wire [4:0] rs1, rs2, rd;
    wire [6:0] op, funct7;
    wire [2:0] funct3, alu_control;
    wire [1:0] pc_src, alu_op, imm_src;
    wire reg_write, mem_write, result_src, alu_src, selA ,branch, branch_alu;

    
    PC u_PC (
        .clk(clk),
        .reset(reset),
        .pc_next(pc_next),
        .instr(instruction),         
        .programCounter(pc) ,
        .WAA(word_align_address)         
    );



    assign op = instruction[6:0];
    assign rd = instruction[11:7];
    assign funct3 = instruction[14:12];
    assign rs1 = instruction[19:15];
    assign rs2 = instruction[24:20];
    assign funct7 = instruction[31:25];
    


    decoder u_decoder (
        // .zero(pc_src),        
        .op(op),
        .reg_write(reg_write),
        .mem_write(mem_write),
        .result_src(result_src),
        .alu_src(alu_src),
        .pc_src(pc_src),
        .alu_op(alu_op),
        .imm_src(imm_src),
        .selA(selA),
        .branch(branch)
        
    );

    
    immediate_gen u_immediate_gen (
        .instruction(instruction),
        .imm_src(imm_src),
        .immediate(immediate)
    );


    register_file u_register_file (
    .clk(clk),
    .reset(reset),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .write(write_data),
    .reg_write(reg_write),
    .read1(read1),
    .read2(read2)
);


    
    alu_decoder u_alu_decoder (
        .aluop(alu_op),
        .funct3(funct3),
        .funct7(funct7[5]),
        .alu_control(alu_control)
    );


    ALU u_ALU (
        .A((selA) ? pc : read1),
        .B(alu_src ? immediate : read2), 
        .control_signal(alu_control),
        .result(alu_result),
        .branch(branch_alu)
    );

    
    data_mem u_data_mem (
        .clk(clk),
        .write_enable(mem_write),
        .A(alu_result),
        .write_data(read2),
        .rd(mem_out)
    );

assign write_data = (result_src) ? mem_out : alu_result;
assign pc_next = (pc_src == 2'b01) ? alu_result : (pc_src == 2'b10 & branch_alu == 1'b1 & branch) ? pc + immediate : (pc + 4);

endmodule

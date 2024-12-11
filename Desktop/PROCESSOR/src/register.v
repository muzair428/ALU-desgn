module register_file(
     input clk, 
     input reset,
     input [4:0] rs1, 
     input [4:0] rs2, 
     input [4:0] rd, 
     input [31:0] write, 
     input reg_write, 
     output [31:0] read1, 
     output [31:0] read2
     
    );

    reg [31:0] register[31:0];
    integer i;

    assign read1 = register[rs1];
    assign read2 = register[rs2];

    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1) begin
                register[i] = 32'd0; // Reset all registers to 0
            end
        end else if (reg_write && rd!= 5'd0) begin
            // Write to the register only if reg_write is high and rd is not x0 (to preserve $zero register)
            register[rd] = write;
        end
    end
endmodule


module data_mem(
    input clk,                  
    input write_enable,         
    input [31:0] A,             // Address or PC
    input [31:0] write_data,    // Data to write
    input [3:0] mask,           // Load/store mask
    input [31:0] imm_data,      // Immediate value
    input u_type_enable,        // Enables U-type instructions (LUI/AUIPC)
    input j_type_enable,        // Enables J-type instructions (JAL/JALR)
    input auipc_enable,         // Specifically enables AUIPC
    input jalr_enable,          // Specifically enables JALR
    input r_type_enable,        // Enables R-type instructions
    input [31:0] rs1,           // Source register 1
    input [31:0] rs2,           // Source register 2
    input [2:0] funct3,         // R-type operation selector (add, sub, etc.)
    input [6:0] funct7,         // Additional R-type operation bits
    output reg [31:0] rd        // Data read or computed result
);

    reg [31:0] data_mem [1023:0]; // Memory array
    wire [9:0] address_index = A[11:2];

    always @(*) begin
        if (u_type_enable) begin
            // LUI: Load Upper Immediate (imm_data << 12)
            rd = imm_data;
        end else if (auipc_enable) begin
            // AUIPC: PC + (imm_data << 12)
            rd = A + (imm_data << 12);
        end else if (j_type_enable) begin
            // JAL: Store return address (PC + 4) and target address is (PC + imm_data)
            rd = A + imm_data; // Target address
        end else if (jalr_enable) begin
            // JALR: Store return address (PC + 4), compute target as (A + imm_data) with LSB cleared
            rd = (A + imm_data) & ~32'b1; // Target address with LSB cleared
        end else if (r_type_enable) begin
            // R-type computation
            case (funct3)
                3'b000: rd = (funct7 == 7'b0000000) ? (rs1 + rs2) : // ADD
                        (funct7 == 7'b0100000) ? (rs1 - rs2) : // SUB
                        32'b0; // Default case
                3'b001: rd = rs1 << rs2[4:0]; // SLL (Shift Left Logical)
                3'b010: rd = ($signed(rs1) < $signed(rs2)) ? 1 : 0; // SLT (Set Less Than)
                3'b011: rd = (rs1 < rs2) ? 1 : 0; // SLTU (Set Less Than Unsigned)
                3'b100: rd = rs1 ^ rs2; // XOR
                3'b101: rd = (funct7 == 7'b0000000) ? (rs1 >> rs2[4:0]) : // SRL (Shift Right Logical)
                          (funct7 == 7'b0100000) ? ($signed(rs1) >>> rs2[4:0]) : // SRA (Shift Right Arithmetic)
                          32'b0; // Default case
                3'b110: rd = rs1 | rs2; // OR
                3'b111: rd = rs1 & rs2; // AND
                default: rd = 32'b0;
            endcase
        end else if (!write_enable) begin
            // Memory Read
            case (mask)
                3'b000: begin 
                    case (write_data[1:0])
                        2'b00: rd = {{24{data_mem[address_index][7]}}, data_mem[address_index][7:0]};
                        2'b01: rd = {{24{data_mem[address_index][15]}}, data_mem[address_index][15:8]};
                        2'b10: rd = {{24{data_mem[address_index][23]}}, data_mem[address_index][23:16]};
                        2'b11: rd = {{24{data_mem[address_index][31]}}, data_mem[address_index][31:24]};
                        default: rd = 32'b0;
                    endcase
                end
                3'b001: begin 
                    case (write_data[1])
                        1'b0: rd = {{16{data_mem[address_index][15]}}, data_mem[address_index][15:0]};
                        1'b1: rd = {{16{data_mem[address_index][31]}}, data_mem[address_index][31:16]};
                        default: rd = 32'b0;
                    endcase
                end
                3'b010: rd = data_mem[address_index]; // Full word
                3'b100: begin 
                    case (write_data[1:0])
                        2'b00: rd = {24'b0, data_mem[address_index][7:0]};
                        2'b01: rd = {24'b0, data_mem[address_index][15:8]};
                        2'b10: rd = {24'b0, data_mem[address_index][23:16]};
                        2'b11: rd = {24'b0, data_mem[address_index][31:24]};
                        default: rd = 32'b0;
                    endcase
                end
                3'b101: begin 
                    case (write_data[1])
                        1'b0: rd = {16'b0, data_mem[address_index][15:0]};
                        1'b1: rd = {16'b0, data_mem[address_index][31:16]};
                        default: rd = 32'b0;
                    endcase
                end
                default: rd = 32'b0; 
            endcase
        end else begin
            rd = 32'b0; 
        end
    end

    always @(posedge clk) begin
        if (write_enable) begin
            // Memory Write
            case (mask)
                3'b000: begin 
                    case (write_data[1:0])
                        2'b00: data_mem[address_index][7:0] = write_data[7:0];
                        2'b01: data_mem[address_index][15:8] = write_data[7:0];
                        2'b10: data_mem[address_index][23:16] = write_data[7:0];
                        2'b11: data_mem[address_index][31:24] = write_data[7:0];
                    endcase
                end
                3'b001: begin 
                    case (write_data[1])
                        1'b0: data_mem[address_index][15:0] = write_data[15:0];
                        1'b1: data_mem[address_index][31:16] = write_data[15:0];
                    endcase
                end
                3'b010: data_mem[address_index] = write_data; 
                default: ; 
            endcase
        end
    end

endmodule

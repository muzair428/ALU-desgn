module alu_decoder (
    input [1:0] aluop,        
    input [2:0] funct3,       
    input funct7,             
    output reg [2:0] alu_control 
);

    always @(*) begin
        case (aluop)
            2'b00: begin
                
                alu_control = 3'b000; 
            end
            2'b01: begin     
                case (funct3)
                    3'b000: alu_control = 3'b111; 
                    // 3'b001: alu_control = 3'b010; 
                    // 3'b100: alu_control = 3'b001; 
                    // 3'b101: alu_control = 3'b010; 
                    // 3'b110: alu_control = 3'b001; 
                    // 3'b111: alu_control = 3'b001; 
                endcase
            end
            2'b10: begin
                
                case (funct3)
                    3'b000: alu_control = (funct7 == 1'b1) ? 3'b001 : 3'b000; // SUB or ADD
                    3'b111: alu_control = 3'b100; // AND
                    3'b110: alu_control = 3'b011; // OR
                    3'b010: alu_control = 3'b101; // SLT (Set Less Than)
                    default: alu_control = 3'b000; // Default to Add
                endcase
            end
            2'b11: begin
                
                alu_control = 3'b000; 
            end
            default: alu_control = 3'b000;
        endcase
    end

endmodule

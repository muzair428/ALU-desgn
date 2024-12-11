module immediate_gen (
    input [31:0] instruction,  
    input [1:0] imm_src,       
    output reg [31:0] immediate 
);

    always @(*) begin
        case (imm_src)
            2'b00: begin 
                immediate = {instruction[31:20]};
            end
            2'b01: begin
                immediate = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
            end
            2'b10: begin 
                immediate = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
            end
            2'b11: begin 
                immediate = {instruction[31:12], 12'b0};
            end
            default: begin 
                immediate = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};
                // immediate[0]=1'b0;
            end
            
        endcase
    end

endmodule

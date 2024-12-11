module WriteBack(
    input  [31:0] A, 
    input  [31:0] B, 
    input  [31:0] C,
    input  [1:0] writeback_sel,	
    output reg [31:0] write_data  
);

    always @(*) begin
        case (writeback_sel)
            2'b00: write_data = A;  
            2'b01: write_data = B;  
            2'b10: write_data = C;  
            default: write_data = 32'b0;  
        endcase
    end
endmodule

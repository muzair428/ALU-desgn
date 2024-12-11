module ALU(
    input [31:0] A,
    input [31:0] B,
    input [2:0] control_signal,
    output logic [31:0] result,
    output wire branch
);

always @(*) begin
    case(control_signal)

    0:result=A+B;
    1:result=A-B;
    2:result=A/B;
    3:result=A&B;
    4:result=A^B;
    5:result=A|B;
    6:result=~(A|B);
    // 7:result= (A == B) ? 32'd1 : 32'd0;
    default: result=32'b0;
    endcase
    
end
   assign branch = (A == B) ? 1'b1 : 1'b0;

endmodule
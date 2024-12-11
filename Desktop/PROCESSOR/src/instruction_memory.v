module instruction_mem(
    input [31:0]A,
    input reset,
    output[31:0]rd
);
    reg [31:0]mem[0:31];

    assign rd=(reset==1'b0)? 32'b0000000: mem[A[4:0]];
    


endmodule
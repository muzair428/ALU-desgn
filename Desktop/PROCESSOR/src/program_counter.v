module PC (
    input clk,
    input reset,
    input [31:0] pc_next,
    output wire [31:0] instr,
    output reg [31:0] programCounter,
    output wire [31:0] WAA
);

    
    reg [31:0] mem [0:31];
    wire [31:0] pc;
    reg [4:0] address; 

    
    initial begin
        $readmemh("inst.mem", mem); 
    end

    
    reg [31:0] pc_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc_reg <= 32'b0; 
        end else begin
            pc_reg <= pc_next; 
        end
    end
        assign pc = pc_reg;
        assign WAA = pc[6:2];
        assign instr = mem[pc[6:2]]; 

    always @(*) begin
        programCounter = pc;
    end

endmodule

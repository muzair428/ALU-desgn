 module main_tb();
    reg clk;
    reg reset;

    processor u_processor(
        .clk(clk),
        .reset(reset)
    );

    always 
    #5 
    clk = ~clk;

    initial begin

        clk = 0;
        reset = 0;
        #10;
        reset = 1;
        #15 reset = 0;
        #800;
        $finish;

    end

    initial begin
        $dumpfile("./temp/main.vcd");
        $dumpvars(0,main_tb);
    end
    
endmodule

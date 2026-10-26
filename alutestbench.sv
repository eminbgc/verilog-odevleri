module tb_alu_4bit;
    logic [3:0] a;
    logic [3:0] b;
    logic [1:0] sel;
    logic [3:0] out;
    logic cout;

    alu_4bit uut (
        .a(a),
        .b(b),
        .sel(sel),
        .out(out),
        .cout(cout)
    );

    initial begin
        $monitor("Zaman=%0t ns | sel=%b | a=%b (%0d) , b=%b (%0d) | Çıkış out=%b (%0d)", 
                 $time, sel, a, a, b, b, out, out);

   
        a = 4'b0101; b = 4'b0011; sel = 2'b00; #10; // 5 + 3 = 8
        
        a = 4'b0111; b = 4'b0010; sel = 2'b01; #10; // 7 - 2 = 5
        
        a = 4'b1100; b = 4'b1010; sel = 2'b10; #10; // 12 & 10 = 8
        
        a = 4'b1100; b = 4'b0011; sel = 2'b11; #10; // 12 | 3 = 15

        $finish;
    end
endmodule

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
        $monitor("Zaman=%0t ns | sel=%b | a=%b (%0d) , b=%b (%0d) | Sonuç out=%b (%0d)", 
                 $time, sel, a, a, b, b, out, out);

        // 1. Toplama Testi (sel = 00)
        a = 4'b0101; b = 4'b0011; sel = 2'b00; #10; // 5 + 3 = 8
        
        // 2. Çıkarma Testi (sel = 01)
        a = 4'b0111; b = 4'b0010; sel = 2'b01; #10; // 7 - 2 = 5
        
        // 3. Çarpma Testi (sel = 10)
        a = 4'b0011; b = 4'b0010; sel = 2'b10; #10; // 3 * 2 = 6
        
        // 4. Bölme Testi (sel = 11)
        a = 4'b0110; b = 4'b0010; sel = 2'b11; #10; // 6 / 2 = 3

        $finish;
    end
endmodule
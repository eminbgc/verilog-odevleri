

module tb_adder_4bit;
    
    logic [3:0] a;
    logic [3:0] b;
    logic cin;
    logic [3:0] sum;
    logic cout;

    
    adder_4bit uut (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );

    initial begin
        
        $monitor("Zaman=%0t ns | a=%b (%0d) + b=%b (%0d) + cin=%b | Toplam sum=%b (%0d), cout=%b", 
                 $time, a, a, b, b, cin, sum, sum, cout);

        
        a = 4'b0000; b = 4'b0000; cin = 0; #10;
        a = 4'b0011; b = 4'b0101; cin = 0; #10; // 3 + 5 = 8
        a = 4'b1111; b = 4'b0001; cin = 0; #10; // 15 + 1 = 16 (taşma var)
        a = 4'b1010; b = 4'b0101; cin = 1; #10; // 10 + 5 + 1 = 16
        a = 4'b1100; b = 4'b1100; cin = 0; #10; // 12 + 12 = 24
        a = 4'b1111; b = 4'b1111; cin = 1; #10; // 15 + 15 + 1 = 31
        
        $finish;
    end
endmodule

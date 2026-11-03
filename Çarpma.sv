
module full_adder (
    input logic a,
    input logic b,
    input logic cin,
    output logic sum,
    output logic cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (cin & (a ^ b));
endmodule


module adder_subtractor_4bit (
    input logic [3:0] a,
    input logic [3:0] b,
    input logic sub, 
    output logic [3:0] result,
    output logic cout
);
    logic [3:0] b_mod;
    logic c1, c2, c3;

    assign b_mod = b ^ {4{sub}};

    full_adder fa0 (.a(a[0]), .b(b_mod[0]), .cin(sub), .sum(result[0]), .cout(c1));
    full_adder fa1 (.a(a[1]), .b(b_mod[1]), .cin(c1),  .sum(result[1]), .cout(c2));
    full_adder fa2 (.a(a[2]), .b(b_mod[2]), .cin(c2),  .sum(result[2]), .cout(c3));
    full_adder fa3 (.a(a[3]), .b(b_mod[3]), .cin(c3),  .sum(result[3]), .cout(cout));
endmodule


module multiplier_4bit (
    input logic [3:0] a,
    input logic [3:0] b,
    output logic [3:0] out
);
    always_comb begin
        logic [7:0] product;
        product = 8'b0;
        // Donanımsal shift-and-add (kaydır ve topla) algoritması
        for (int i = 0; i < 4; i++) begin
            if (b[i]) begin
                product = product + ({4'b0, a} << i);
            end
        end
        out = product[3:0]; // Alt 4 bit çıkışa verilir
    end
endmodule

module divider_4bit (
    input logic [3:0] a,
    input logic [3:0] b,
    output logic [3:0] quotient,
    output logic [3:0] remainder
);
    always_comb begin
        logic [3:0] temp_q;
        logic [4:0] curr_rem;
        
        if (b == 4'b0000) begin
            quotient = 4'b1111; // Sıfıra bölünme hatası durumu
            remainder = 4'b0000;
        end else begin
            temp_q = 4'b0;
            curr_rem = 5'b0;
            
            for (int i = 3; i >= 0; i--) begin
                curr_rem = {curr_rem[3:0], a[i]};
                if (curr_rem >= {1'b0, b}) begin
                    curr_rem = curr_rem - {1'b0, b};
                    temp_q[i] = 1'b1;
                end else begin
                    temp_q[i] = 1'b0;
                end
            end
            quotient = temp_q;
            remainder = curr_rem[3:0];
        end
    end
endmodule


module mux_4x1_4bit (
    input logic [3:0] d0, // Toplama
    input logic [3:0] d1, // Çıkarma
    input logic [3:0] d2, // Çarpma
    input logic [3:0] d3, // Bölme
    input logic [1:0] sel,
    output logic [3:0] y
);
    always_comb begin
        case (sel)
            2'b00: y = d0;
            2'b01: y = d1;
            2'b10: y = d2;
            2'b11: y = d3;
            default: y = 4'b0000;
        endcase
    end
endmodule

module alu_4bit (
    input logic [3:0] a,
    input logic [3:0] b,
    input logic [1:0] sel,
    output logic [3:0] out,
    output logic cout
);
    logic [3:0] add_res, sub_res, mul_res, div_res;
    logic add_cout, sub_cout;

    adder_subtractor_4bit adder_block (.a(a), .b(b), .sub(1'b0), .result(add_res), .cout(add_cout));
    adder_subtractor_4bit sub_block   (.a(a), .b(b), .sub(1'b1), .result(sub_res), .cout(sub_cout));
    multiplier_4bit       mul_block   (.a(a), .b(b), .out(mul_res));
    divider_4bit          div_block   (.a(a), .b(b), .quotient(div_res), .remainder());

    mux_4x1_4bit mux_block (
        .d0(add_res), .d1(sub_res), .d2(mul_res), .d3(div_res),
        .sel(sel), .y(out)
    );

    assign cout = (sel == 2'b00) ? add_cout : ((sel == 2'b01) ? sub_cout : 1'b0);

endmodule
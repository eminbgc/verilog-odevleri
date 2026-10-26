
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

module and_unit_4bit (
    input logic [3:0] a,
    input logic [3:0] b,
    output logic [3:0] result
);
    assign result = a & b;
endmodule

module or_unit_4bit (
    input logic [3:0] a,
    input logic [3:0] b,
    output logic [3:0] result
);
    assign result = a | b;
endmodule

module mux_4x1_4bit (
    input logic [3:0] d0, 
    input logic [3:0] d1, 
    input logic [3:0] d2, 
    input logic [3:0] d3, 
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
    logic [3:0] add_res, sub_res, and_res, or_res;
    logic add_cout, sub_cout;

    adder_subtractor_4bit adder_block (
        .a(a), .b(b), .sub(1'b0), .result(add_res), .cout(add_cout)
    );

   
    adder_subtractor_4bit sub_block (
        .a(a), .b(b), .sub(1'b1), .result(sub_res), .cout(sub_cout)
    );

  
    and_unit_4bit and_block (
        .a(a), .b(b), .result(and_res)
    );

   
    or_unit_4bit or_block (
        .a(a), .b(b), .result(or_res)
    );

    
    mux_4x1_4bit mux_block (
        .d0(add_res),
        .d1(sub_res),
        .d2(and_res),
        .d3(or_res),
        .sel(sel),
        .y(out)
    );

endmodule

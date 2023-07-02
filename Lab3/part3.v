module lab3part3(SW, KEY, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
    input [9:0] SW;
    output [9:0] LEDR;
    input [3:0] KEY;
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

    wire [7:0] ALUout;
    wire [3:0] A, B;

    assign A = SW[7:4];
    assign B = SW[3:0];

    part3 u0 (.A(A), .B(B), .Function(~KEY[2:0]), .ALUout(ALUout));
    hex_decoder HEXB (.c(B), .display(HEX0));
    hex_decoder HEX01 (.c(4'b0), .display(HEX1));
    hex_decoder HEXA (.c(A), .display(HEX2));
    hex_decoder HEX03 (.c(4'b0), .display(HEX3));
    hex_decoder HEXALU4 (.c(ALUout[3:0]), .display(HEX4));
    hex_decoder HEXALU5 (.c(ALUout[7:4]), .display(HEX5));
endmodule

module part3(A, B, Function, ALUout);
	input [7:4] A;
	input [3:0] B;
	input [2:0]	Function; 

	output reg [7:0] ALUout;
	wire [7:0] w0;
	
	part2 u0(.a(A[7:4]), .b(B[3:0]), .c_in(1'b0), .s(w0[3:0]), .c_out(w0[4]));

	always @(*)
		begin
        case (Function[2:0])
            0: ALUout = {3'b0, w0[4:0]};
            1: ALUout = {4'b0, A} + {4'b0, B};
            2: ALUout = {B[3], B[3], B[3], B[3], B};
            3: ALUout = {7'b0,|{A, B}};
            4: ALUout = {7'b0,&{A, B}};
            5: ALUout = {A, B};
            default: ALUout = 8'b0;
        endcase
	end

endmodule

module hex_decoder(c, display);

	input [3:0] c;
	output [6:0] display;
	
	assign display [0] = ~((c[3]|c[2]|c[1]|~c[0]) & (c[3]|~c[2]|c[1]|~c[0]) & (~c[3]|c[2]|~c[1]|~c[0]) & (~c[3]|~c[2]|c[1]|~c[0]));
	assign display [1] = ~((c[3]|~c[2]|c[1]|~c[0]) & (c[3]|~c[2]|~c[1]|c[0]) & (~c[3]|c[2]|~c[1]|~c[0]) & (~c[3]|~c[2]|c[1]|c[0]) & (~c[3]|~c[2]|~c[1]|c[0]) & (~c[3]|~c[2]|~c[1]|~c[0]));
	assign display [2] = ~((c[3]|c[2]|~c[1]|c[0]) & (~c[3]|~c[2]|c[1]|c[0]) & (~c[3]|~c[2]|~c[1]|c[0]) & (~c[3]|~c[2]|~c[1]|~c[0]));
	assign display [3] = ~((c[3]|c[2]|c[1]|~c[0]) & (c[3]|~c[2]|c[1]|c[0]) & (c[3]|~c[2]|~c[1]|~c[0]) & (~c[3]|c[2]|~c[1]|c[0]) & (~c[3]|~c[2]|~c[1]|~c[0]));
	assign display [4] = ~((c[3]|c[2]|c[1]|~c[0]) & (c[3]|c[2]|~c[1]|~c[0]) & (c[3]|~c[2]|c[1]|c[0]) & (c[3]|~c[2]|c[1]|~c[0]) & (c[3]|~c[2]|~c[1]|~c[0]) & (~c[3]|c[2]|c[1]|~c[0]));
	assign display [5] = ~((c[3]|c[2]|c[1]|~c[0]) & (c[3]|c[2]|~c[1]|c[0]) & (c[3]|c[2]|~c[1]|~c[0]) & (c[3]|~c[2]|~c[0]) & (~c[3]|~c[2]|c[1]|~c[0]));
	assign display [6] = ~((c[3]|c[2]|c[1]|c[0]) & (c[3]|c[2]|c[1]|~c[0]) & (c[3]|~c[2]|~c[1]|~c[0]) & (c[3]|c[2]|c[1]|c[0]) & (~c[3]|~c[2]|c[1]|c[0]));
	
endmodule

module fa(a, b, cin, s, cout);
	input a, b, cin;
	output s, cout;
	
	assign s = a^b^cin;
	assign cout = (a&b)|(a&cin)|(b&cin);
	
endmodule

module part2(a, b, c_in, s, c_out);
	input[3:0] a, b;
	input c_in;
	output[3:0] s;
   output [3:0] c_out;
	
	
	
	fa u0(a[0], b[0], c_in, s[0], c_out[0]);
	fa u1(a[1], b[1], c_out[0], s[1], c_out[1]);
	fa u2(a[2], b[2], c_out[1], s[2], c_out[2]);
	fa u3(a[3], b[3], c_out[2], s[3], c_out[3]);

endmodule

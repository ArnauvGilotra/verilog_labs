
module top(SW, LEDR);
	input [9:0] SW;
	output [9:0] LEDR;

	wire [3:0] c_out;

   part2 u0 (.a(SW[7:4]), .b(SW[3:0]), .c_in(SW[8]), .s(LEDR[3:0]), .c_out(c_out[3:0]));
   assign LEDR[9] = c_out[3];
	
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

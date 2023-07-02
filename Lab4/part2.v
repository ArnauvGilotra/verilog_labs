module part2(Clock ,Reset_b, Data, Function, ALUout);
	input [7:4] Data;
	input [2:0]	Function; 
	input Clock;
	input Reset_b;
	output reg [7:0] ALUout;
	wire [7:0] w0;
	wire [7:0] q_bits;
	wire [3:0] B;
	assign B = q_bits[3:0];
	wire [3:0] c_out;
	assign w0[4] = c_out[3];
	part u0(.a(Data[7:4]), .b(B[3:0]), .c_in(1'b0), .s(w0[3:0]), .c_out(c_out));
	register u1(.d(ALUout[7:0]), .Clock(~Clock), .Reset_b(Reset_b), .q(q_bits[7:0]));

	always @(*)
		begin
        case (Function[2:0])
            0: ALUout = {3'b0, w0[4:0]};
            1: ALUout = {4'b0, Data} + {4'b0, B};
            2: ALUout = {B[3], B[3], B[3], B[3], B};
            3: ALUout = {7'b0,|{Data, B}};
            4: ALUout = {7'b0,&{Data, B}};
            5: ALUout = B<<Data;
				6: ALUout = Data*B;
				7: ALUout = B;
            default: ALUout = 8'b0;
        endcase
	end

endmodule

module register(d,Clock,Reset_b,q);
	input [7:0] d;
	input Clock;
	input Reset_b;
	output reg [7:0] q;

	
	always @(posedge Clock) // triggered every time clock rises
	begin
	
		if (Reset_b == 1'b0)
			begin			// when Reset b is 0 (note this is tested on every rising clock edge)
			q <= 8'b0;
			
			end        // q is set to 0. Note that the assignment uses <=
		else          // when Reset b is not 0
			begin	
			q <= d;
		   	// value of d passes through to output q
			end	
	end
   
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

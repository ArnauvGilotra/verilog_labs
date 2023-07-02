module part3(clock, reset, ParallelLoadn, RotateRight, ASRight, Data_IN, Q);

	input clock, reset, ParallelLoadn, RotateRight, ASRight;
	input [7:0] Data_IN;
	output [7:0] Q;
	
	wire right;
	
	assign right = ASRight ? Q[7] : Q[0];
	
	sub u7(right, Q[6], RotateRight, Data_IN[7], ParallelLoadn, Q[7], reset, clock);
	sub u6(Q[7], Q[5], RotateRight, Data_IN[6], ParallelLoadn, Q[6], reset, clock);
	sub u5(Q[6], Q[4], RotateRight, Data_IN[5], ParallelLoadn, Q[5], reset, clock);
	sub u4(Q[5], Q[3], RotateRight, Data_IN[4], ParallelLoadn, Q[4], reset, clock);
	sub u3(Q[4], Q[2], RotateRight, Data_IN[3], ParallelLoadn, Q[3], reset, clock);
	sub u2(Q[3], Q[1], RotateRight, Data_IN[2], ParallelLoadn, Q[2], reset, clock);
	sub u1(Q[2], Q[0], RotateRight, Data_IN[1], ParallelLoadn, Q[1], reset, clock);
	sub u0(Q[1], Q[7], RotateRight, Data_IN[0], ParallelLoadn, Q[0], reset, clock);

endmodule


module sub(right, left, RotateRight, D, ParallelLoadn, Q, reset, clock);

	input right, left, RotateRight, D, ParallelLoadn, reset, clock;
	output Q;
	
	wire w0, w1;
	
	mux2to1 u0(left, right, RotateRight, w1);
	mux2to1 u1(D, w1, ParallelLoadn, w0);
	flipflop f0(w0, Q, clock, reset);

endmodule

module flipflop(D, Q, Clock, reset);

	input reset, Clock;
	input D;
	output Q;
	
	reg Q;

	always @(posedge Clock) // triggered every time clock rises
	begin
		if (reset) 				
			Q <= 0;			   
		else 						
			Q <= D; 				
	end

endmodule

module mux2to1(x, y, s, m);

    input x, y, s;
    output m;
  
	 
    assign m = s ? y : x;

endmodule


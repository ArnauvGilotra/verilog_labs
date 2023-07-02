
module topModule (input CLOCK_50, input [9:0] SW, output [3:0] HEX0);
	part2(.ClockIn(CLOCK_50), .Reset(SW[9]), .Speed(SW[1:0]), .CounterValue(HEX0[3:0]));
endmodule

module part2(ClockIn, Reset, Speed, CounterValue);
	input ClockIn;
	input Reset;
	input [1:0] Speed;
	output [3:0] CounterValue;
	
	wire w1; //enable
	
	RD r1 (.ClockIn(ClockIn), .Speed(Speed), .Reset(Reset), .Enable(w1));
	DC d1 (.ClockIn(ClockIn), .Reset(Reset), .Enable(w1), .q(CounterValue));
	
endmodule 

module DC(input ClockIn, Reset, Enable, output reg [3:0] q);

    always @(posedge ClockIn, posedge Reset)
    begin
        if (Reset) q <= 0;
        else if (Enable) 
				begin
					if (q == 4'b1111) q <= 0;
					else q <= q + 1;
				end
    end
endmodule 

module RD(input ClockIn, input [1:0] Speed, input Reset, output Enable);

	reg [10:0] counter;
	assign Enable = (counter == 0) ? 1 : 0; 
	reg [10:0] cMax;
	
	always @(*) 
		begin
			case (Speed[1:0])
				0: cMax = 0;
				1: cMax = 499;
				2: cMax = 999;
				3: cMax = 1999;
				default: cMax = 0;
			endcase	
		end
			
	always @(posedge ClockIn, posedge Reset)
    begin
        if (Reset) counter <= cMax;
        else if (Enable) counter <= cMax;
        else counter <= counter - 1;
    end
	 
endmodule 
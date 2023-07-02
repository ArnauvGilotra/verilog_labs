module top(SW, LEDR);
	input [9:0] SW;
	output [9:0] LEDR;

	part1 u1 (SW[6:0], SW[9:7], LEDR[0]);

endmodule

module part1(MuxSelect, Input, out);
    input[6:0] Input;
    input[2:0] MuxSelect;

    output reg out;
    always@(*)
        case(MuxSelect)
            3'b000 : out = Input[0];
            3'b001 : out = Input[1];
            3'b010 : out = Input[2];
            3'b011 : out = Input[3];
            3'b100 : out = Input[4];
            3'b101 : out = Input[5];
            3'b110 : out = Input[6];
            default : out = 1'b0;
        endcase
endmodule

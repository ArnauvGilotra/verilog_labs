module part3(ClockIn, Resetn, Start, Letter, DotDashOut, NewBitOut);
    input [2:0] Letter;
         input ClockIn, Resetn, Start;
    output NewBitOut, DotDashOut;

    reg [10:0] mcode;
        
    always @(*)
    begin
        case (Letter)
            0: mcode = 11'b10111000000;
            1: mcode = 11'b11101010100;
            2: mcode = 11'b11101011101;
            3: mcode = 11'b11101010000;
            4: mcode = 11'b10000000000;
            5: mcode = 11'b10101110100;
            6: mcode = 11'b11101110100;
            7: mcode = 11'b10101010000;
        endcase
    end

         countdown c0(.ClockIn(ClockIn), .Resetn(Resetn), .Start(Start), .Enable(NewBitOut));
         SR s0(.ClockIn(ClockIn), .Shift(NewBitOut), .Load(Start), .Resetn(Resetn), .Ldata(mcode), .q(DotDashOut));
        
endmodule

module countdown(input ClockIn, input Resetn, input Start, output Enable);
        reg [7:0] counter;
        assign Enable = (counter == 0) ? 1 : 0;
        reg [7:0] cMax;
        initial cMax = 249;
        reg [3:0] bits;
                        
        always @(posedge ClockIn) begin
        if (!Resetn) counter <= cMax;
        else if (bits == 0) counter <= cMax;
        else if (Enable) begin
            counter <= cMax;
            bits <= bits - 1;
        end
        else if (Start) begin
            counter <= cMax;
            bits <= 12;
        end
        else counter <= counter - 1;
    end
        
endmodule

module SR(input ClockIn, Shift, Load, Resetn, input [10:0] Ldata, output q);
    reg [10:0] mCode;
    assign q = mCode[10];

    always @(posedge ClockIn, negedge Resetn)
    begin
        if (!Resetn) mCode <= 0;
        else if (Shift) mCode <= mCode << 1;
        else if (Load) mCode <= Ldata;
    end

endmodule 
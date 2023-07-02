module part2(iResetn,iPlotBox,iBlack,iColour,iLoadX,iXY_Coord,iClock,oX,oY,oColour,oPlot,oDone);
   parameter X_SCREEN_PIXELS = 8'd160;
   parameter Y_SCREEN_PIXELS = 7'd120;
   
   input wire iResetn, iPlotBox, iBlack, iLoadX;
   input wire [2:0] iColour;
   input wire [6:0] iXY_Coord;
   input wire 	    iClock;
   output wire [7:0] oX;         // VGA pixel coordinates
   output wire [6:0] oY;
   
   output wire [2:0] oColour;     // VGA pixel colour (0-7)
   output wire 	     oPlot;       // Pixel draw enable
   output wire       oDone;       // goes high when finished drawing frame

   //
   // Your code goes here
   //
   wire loadX, loadY, loadOut, loadB;
   wire [3:0] counter;
   wire [7:0] blackX;
   wire [6:0] blackY;
	
   control C0(iClock, iResetn, iPlotBox, iLoadX, counter, iBlack,
    			X_SCREEN_PIXELS, blackX, Y_SCREEN_PIXELS, blackY,
	 			loadX, loadY, loadB, loadOut, oPlot, oDone);
   /*
 
   */
   datapath D0(iClock, iResetn, loadX, loadY, loadOut, loadB, iColour, 
   				iXY_Coord, iBlack, X_SCREEN_PIXELS, Y_SCREEN_PIXELS, 
				blackX, blackY, oX, oY, oColour, counter);

endmodule // part2

module control(input iClock, input iResetn, input iPlotBox, input iLoadX,input [3:0] counter, input iBlack,
				input [7:0] X_SCREEN_PIXELS, input [7:0] blackX, input [6:0] Y_SCREEN_PIXELS, input [6:0] blackY,
               	output reg loadX, output reg loadY, output reg loadB, output reg loadOut, output reg oPlot, output reg oDone);
    
    reg [3:0] current_state, next_state;
    localparam  S_LOAD_X        = 4'd0,
                S_LOAD_X_WAIT   = 4'd1,
                S_LOAD_Y        = 4'd2,
                S_LOAD_Y_WAIT   = 4'd3,
                S_DRAW          = 4'd4,
                S_DRAW_WAIT     = 4'd5,
				S_DRAW_DONE		= 4'd6,
				S_CLEAR			= 4'd7,
                S_CLEAR_WAIT    = 4'd8;

    // Next state logic aka our state table
    always @(*)
    begin: state_table
        case (current_state)
            S_LOAD_X: begin 
                        if (iLoadX) next_state = S_LOAD_X_WAIT;
                        else next_state = iBlack ? S_CLEAR_WAIT : S_LOAD_X;
                    end
            S_LOAD_X_WAIT: next_state = iLoadX ? S_LOAD_X_WAIT : S_LOAD_Y;
            S_LOAD_Y: next_state = iPlotBox ? S_LOAD_Y_WAIT : S_LOAD_Y;
            S_LOAD_Y_WAIT: next_state = iPlotBox ? S_LOAD_Y_WAIT : S_DRAW;
            S_DRAW: begin
                        if (counter == 4'd15) next_state = S_DRAW_WAIT;
                        else next_state = S_DRAW;
                    end
            S_DRAW_WAIT: next_state = S_DRAW_DONE;
			S_DRAW_DONE: next_state = S_LOAD_X;
            S_CLEAR_WAIT: next_state = iBlack ? S_CLEAR_WAIT : S_CLEAR;
			S_CLEAR: begin
						if(blackY == (Y_SCREEN_PIXELS - 1) && blackX == (X_SCREEN_PIXELS -1)) next_state = S_DRAW_DONE;
						else next_state = current_state;
					end
            default: next_state = S_LOAD_X;
        endcase
    end

    // Output logic aka all of our datapath control signals
    always @(*)
    begin
        loadX = 1'b0;
        loadY = 1'b0;
        loadOut = 1'b0;
		loadB = 1'b0;
		oDone = 1'b0;

        case (current_state)
            S_LOAD_X: begin
                loadX = 1'b1;
                oPlot = 1'b0;
            end
            S_LOAD_Y: begin
                loadY = 1'b1;
            end
            S_DRAW: begin
                loadOut = 1'b1;
                oPlot = 1'b1;
            end
			S_DRAW_DONE: begin
				oDone = 1'b1;
			end
			S_CLEAR: begin
				loadB = 1'b1;
				oPlot = 1'b1;
			end
        endcase
    end

    //current_state registers
    always @(posedge iClock)
    begin: state_FFs
        if (!iResetn) current_state <= S_LOAD_X;
        else current_state <= next_state;
    end
endmodule

module datapath(input iClock, input iResetn, input loadX, input loadY, input loadOut, input loadB, input [2:0] iColour, 
				input [6:0] iXY_Coord, input iBlack, input [7:0] X_SCREEN_PIXELS, input [6:0] Y_SCREEN_PIXELS, 
				output reg [7:0] blackX, output reg [6:0] blackY,
                output reg [7:0] oX, output reg [6:0] oY, output reg [2:0] oColour, output reg [3:0] counter);

    reg [7:0] xCord;
    reg [6:0] yCord;
    reg [2:0] colorcode;
    always @(posedge iClock)
    begin
        if (!iResetn) counter <= 4'd0;
        else if (counter == 4'd15) counter <= 4'd0;
        else if (loadOut) counter <= counter + 1;
    end

	always @(posedge iClock)
	begin
		if (!iResetn) 
		begin
			blackX <= 0;
			blackY <= 0;
		end
		else if (blackY == (Y_SCREEN_PIXELS - 1) && blackX == (X_SCREEN_PIXELS -1))
		begin
			blackX <= 0;
			blackY <= 0;
		end
		else if (blackX == (X_SCREEN_PIXELS -1)) 
		begin
			blackX <= 0;
			blackY <= blackY + 1;
		end
		else if (loadB) 
		begin
			blackX <= blackX + 1;	
		end
	end

    always @(posedge iClock)
    begin
        if (!iResetn)
        begin
            oX <= 0;
            oY <= 0;
            oColour <= 0;
        end
        else if (loadX)
        begin
            xCord <= {1'b0, iXY_Coord};
        end
        else if (loadY)
        begin
            yCord <= iXY_Coord;
            colorcode <= iColour;
        end
        else if (loadOut)
        begin
            oX <= xCord + counter[1:0];
            oY <= yCord + counter[3:2];
            oColour <= colorcode;
        end
		else if (loadB)
        begin
            oX <=  blackX;
            oY <=  blackY;
            oColour <= 0;
        end
    end
endmodule

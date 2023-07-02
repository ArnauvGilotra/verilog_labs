module mux2to1 (x, y, s, m)
					wire inverterToAnd, andToOrGate1, andToOrGate2;
					v7404 inverter1(.pin1(s), .pin2(inverterToAnd)); //Inverted S output
					//connect inverter S and X to one and gate and y and S to the other and gate
					v7408	andGate(.pin1(x), .pin2(inverterToAnd), .pin3(andToOrGate1), .pin4(y), pin5(s), .pin6(andToOrGate2));
					//connect the outputs of the and gates to the or gate 
					v7432 orGate(.pin1(andToOrGate1), .pin2(andToOrGate2), .pin3(m));
endmodule
		
//inverter with 6 inputs and 6 outputs 
module v7404(input pin1, pin3, pin5, pin9, pin11, pin13,
				output pin2, pin4, pin6, pin8, pin10, pin12);
					assign pin2 = !(pin1);
					assign pin3 = !(pin4);
					assign pin5 = !(pin6);
					assign pin8 = !(pin9);
					assign pin10 = !(pin11);
					assign pin12 = !(pin13);				
endmodule

//AND Gate with four 2 inputs 
module v7408(input pin1, pin2, pin4, pin5, pin13, pin12, pin10, pin9
				output pin3, pin6, pin11, pin8);
				assign pin3 = (pin1 & pin2);
				assign pin6 = (pin4 & pin5);
				assign pin8 = (pin9 & pin10);
				assign pin11 = (pin12 & pin13);
endmodule

//Or Gate with four 2 inputs
module v7432(input pin1, pin2, pin4, pin5, pin13, pin12, pin10, pin9
				output pin3, pin6, pin11, pin8);
				assign pin3 = (pin1 | pin2);
				assign pin6 = (pin4 | pin5);
				assign pin8 = (pin9 | pin10);
				assign pin11 = (pin12 | pin13);
endmodule

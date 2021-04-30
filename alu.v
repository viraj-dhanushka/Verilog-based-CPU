// Computer Architecture (CO224) - Lab 05
// Design: ALU of Simple Processor
`timescale  1ns/100ps

module alu(DATA1, DATA2, RESULT, SELECT, ZERO);

    //ports declaration
	input signed [7:0]DATA1;    // 8-bit input called DATA1
    input [7:0]DATA2;    // 8-bit input called DATA2  
    input [3:0]SELECT;   // 4-bit input called SELECT
    output reg [7:0]RESULT;     // 8-bit input called RESULT
    output ZERO; //1 if result is 0
	wire [7:0] RESULT1, RESULT2, RESULT3, RESULT4, RESULT5;
	reg [7:0] RESULT6, RESULT7, RESULT8, RESULT9;

	assign ZERO = ~| (RESULT);        //nor gate

	assign #1 RESULT1 = DATA2;     // loadi, mov, lwd, lwi, swd, swi
	assign #2 RESULT2 = DATA1 + DATA2;     // add
	assign #1 RESULT3 = DATA1 & DATA2;     // and
	assign #1 RESULT4 = DATA1 | DATA2;     // or

	assign #1 RESULT5 = $signed(DATA1) * $signed(DATA2);     // mult

	// always @ (*) begin		
	// 	if(SELECT == 4'b0000)
	// 	begin
	// 		#1 RESULT1 = DATA2;     // loadi, mov, lwd, lwi, swd, swi
	// 	end		
	// end

	// always @ (*) begin		
	// 	if(SELECT == 4'b0001)
	// 	begin
	// 		#2 RESULT2 = DATA1 + DATA2;     // add
	// 	end		
	// end
	
	// always @ (*) begin		
	// 	if(SELECT == 4'b0010)
	// 	begin
	// 		#1 RESULT3 = DATA1 & DATA2;     // and
	// 	end		
	// end

	// always @ (*) begin		
	// 	if(SELECT == 4'b0011)
	// 	begin
	// 		#1 RESULT4 = DATA1 | DATA2;     // or
	// 	end		
	// end		

	always @ (*) begin		// sll	RESULT6
		if(SELECT == 4'b0101)
			begin
				#1;
				case(DATA2)
					8'd0 : RESULT6 = DATA1;
					8'd1 : RESULT6 = {DATA1[6:0],1'b0};
					8'd2 : RESULT6 = {DATA1[5:0],2'b00};
					8'd3 : RESULT6 = {DATA1[4:0],3'b000};
					8'd4 : RESULT6 = {DATA1[3:0],4'b0000};
					8'd5 : RESULT6 = {DATA1[2:0],5'b00000};
					8'd6 : RESULT6 = {DATA1[1:0],6'b000000};
					8'd7 : RESULT6 = {DATA1[0],7'b0000000};
					8'd8 : RESULT6 = {8'b00000000};
					default : RESULT6 = 8'bXXXXXXXX;
				endcase
				
			end		
	end

	always @ (*) begin		// srl RESULT7
		if(SELECT == 4'b0110)
			begin
				#1;
				case(DATA2)
					8'd0 : RESULT7 = DATA1;
					8'd1 : RESULT7 = {1'b0, DATA1[7:1]};
					8'd2 : RESULT7 = {2'b00, DATA1[7:2]};
					8'd3 : RESULT7 = {3'b000, DATA1[7:3]};
					8'd4 : RESULT7 = {4'b0000, DATA1[7:4]};	
					8'd5 : RESULT7 = {5'b00000, DATA1[7:5]};		
					8'd6 : RESULT7 = {6'b000000, DATA1[7:6]};		
					8'd7 : RESULT7 ={7'b0000000, DATA1[0]};		
					8'd8 : RESULT7 = {8'b00000000};
					default : RESULT7 = 8'bXXXXXXXX;
				endcase
				
			end		
	end

	always @ (*) begin		// sra 		RESULT8
		if(SELECT == 4'b0111)
			begin
				#1;
				case(DATA2)
					8'd0 : RESULT8 = DATA1;
					8'd1 : RESULT8 = { { 1{DATA1[7]}}, DATA1[7:1]};
					8'd2 : RESULT8 = { { 2{DATA1[7]}}, DATA1[7:2]}; 
					8'd3 : RESULT8 = { { 3{DATA1[7]}}, DATA1[7:3]};
					8'd4 : RESULT8 = { { 4{DATA1[7]}}, DATA1[7:4]};	
					8'd5 : RESULT8 = { { 5{DATA1[7]}}, DATA1[7:5]};		
					8'd6 : RESULT8 = { { 6{DATA1[7]}}, DATA1[7:6]};		
					8'd7 : RESULT8 = { { 7{DATA1[7]}}, DATA1[7]};		
					8'd8 : RESULT8 = { { 8{DATA1[7]}} };
					default : RESULT8 = 8'bXXXXXXXX;
				endcase
				
			end 		
	end

	always @ (*) begin		// ror		RESULT9
		if(SELECT == 4'b1000)
			begin
				#1;
				case(DATA2)
					8'd0 : RESULT9 = DATA1;
					8'd1 : RESULT9 = { DATA1[0] , DATA1[7:1] };
					8'd2 : RESULT9 = { DATA1[1] ,DATA1[0] , DATA1[7:2] }; 
					8'd3 : RESULT9 = { DATA1[2] ,DATA1[1] ,DATA1[0] , DATA1[7:3] };
					8'd4 : RESULT9 = { DATA1[3] , DATA1[2] ,DATA1[1] ,DATA1[0] , DATA1[7:4] };	
					8'd5 : RESULT9 = { DATA1[4] , DATA1[3] , DATA1[2] ,DATA1[1] ,DATA1[0] , DATA1[7:5] };		
					8'd6 : RESULT9 = { DATA1[5] , DATA1[4] , DATA1[3] , DATA1[2] ,DATA1[1] ,DATA1[0] , DATA1[7:6] };		
					8'd7 : RESULT9 = { DATA1[6] , DATA1[5] , DATA1[4] , DATA1[3] , DATA1[2] ,DATA1[1] ,DATA1[0] , DATA1[7] };		
					8'd8 : RESULT9 = DATA1;
					default : RESULT9 = 8'bXXXXXXXX;
				endcase
				
			end     		
	end


    always @ (*)     // This always block gets executed whenever DATA1, DATA2, SELECT changes value
    begin
        case (SELECT)
            4'b0000 : RESULT = RESULT1;     // loadi, mov, lwd, lwi, swd, swi
            4'b0001 : RESULT = RESULT2;     // add 
            4'b0010 : RESULT = RESULT3;     // and
            4'b0011 : RESULT = RESULT4;     // or
            4'b0100 : RESULT = RESULT5; // mult
            4'b0101 : RESULT = RESULT6; // sll
            4'b0110 : RESULT = RESULT7; // srl
            4'b0111 : RESULT = RESULT8; // sra
            4'b1000 : RESULT = RESULT9; // ror
            default : RESULT = 8'bXXXXXXXX;       // If SELECT is anything else display 8 X s
        endcase
    end





endmodule

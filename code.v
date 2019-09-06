// In the name of God

`timescale 1us/1ns

module TestBench ();
  reg A , B , R , A_traffic , B_traffic , clock;
  wire [3:0] A_Time_L, A_Time_H, B_Time_L, B_Time_H; 
  wire A_Light, B_Light;
  finalModule MYMODULE(A_Time_L, A_Time_H, B_Time_L, B_Time_H, A_Light, B_Light, A, B, R, A_traffic, B_traffic, clock);
  initial
   begin
      clock = 1'b0;
      repeat (4000)
      #500000 clock = ~clock;
   end
  
  initial
    begin
      R = 1;
      #10000
        A = 0; B = 0; R = 0; A_traffic = 0; B_traffic = 0;
      #150000000
        A = 0; B = 0; R = 1;
      #1000000
        A = 0; B = 0; R = 0;
      #6000000
        A = 0; B = 1; R = 0;
      #3000000
        A = 1; B = 0; R = 0;
      #3000000
        A = 0; B = 0; R = 1;
      #10000
        A = 0; B = 0; R = 0;
      #3000000
        A = 1; B = 1; R = 0;
      #3000000
        A = 1; B = 1; R = 1;
      #3000000 $finish;
    end
  
  
endmodule


module counter5 (signalOut , clock , R, z1);
	
	input clock , R, z1;
	output signalOut;
	reg signalOut;
	reg [2:0]cur;
	
	always @ (posedge clock or R)
		if (R)
			begin
				cur = 3'b0;
				#(0.001) signalOut = 0;
			end
			
		else if (z1)
			begin
				cur = 3'b0;
				#(0.001) signalOut = 0;
			end
			
		else if (cur == 3'b100) 
			begin
				cur = 3'b0;
				#(0.001) signalOut = 1;
			end
				
		else
			begin
				cur = cur + 1; 
				#(0.001) signalOut = 0;
			end
				
endmodule

//////////////////////////////////	

module counter30 (signalOut , clock , R, z1);
	
	input clock , R, z1;
	output signalOut;
	reg signalOut;
	reg [4:0]cur;
	
	always @ (posedge clock or R)
		if (R)
			begin
				cur = 5'b0;
				#(0.001) signalOut = 0;
			end
			
		else if (z1)
			begin
				cur = 5'b0;
				#(0.001) signalOut = 0;
			end
				  
		else if (cur == 5'b11101) 
			begin
				cur = 5'b0;
				#(0.001) signalOut = 1;
			end
				
		else
			begin
				cur = cur + 1; 
				#(0.001) signalOut = 0;
			end
				

endmodule

//////////////////////////////////

module combCircuit1 (i1 , i2 , at , al , bt , bl);
	input at , al , bl , bt;
	output i1 , i2;
	assign i1 = (al & ~bl & at) | (~al & bl & bt);
	assign i2 = (al & ~bl & bt) | (~al & bl & at);
endmodule

/////////////////////////////////

module seqCircuit1 (out , in , clock, R);
  input in , clock, R;
  output out;
  reg out;
  reg [2:0] present;
  reg [2:0] next;
  
  parameter S0 = 3'b000 , S1 = 3'b001 , S2 = 3'b010 , S3 = 3'b011 , S4 = 3'b100 , S5 = 3'b101;
  
  always @ (posedge clock or R)
		if (R)
			begin 
				present = S0;
				out = 1'b0;
			end
		else present = next;
		
  always @ (present or in)
	 case (present)
		S0: if(~in) next = S1; 
			else next = S0;
			
		S1:	if(~in) next = S2;
			else next = S0;
			
		S2: if(~in) next = S3;
			else next = S0;
			
		S3: if(~in) next = S4;
			else next = S0;
			 
		S4: if(~in) next = S5;
			else next = S0;
			
		S5: if(~in) next = S5;
			else next = S0;
	endcase		
	
	always @ (present or in)
	  case (present)
			S0: #0.001 out = 1'b0;
			S1: #0.001 out = 1'b0;
			S2: #0.001 out = 1'b0;
			S3: #0.001 out = 1'b0;
			S4: #0.001 out = 1'b0;
		    S5: if(~in) #0.001 out = 1'b1;
			      else  #0.001 out = 1'b0;
	endcase		
	
endmodule 


module seqCircuit2 (out , in , clock, R);
	input [2:0]in;
	input clock, R;
	output [2:0]out;
	reg [2:0]out;
	reg [2:0]next;
	reg [2:0]present;
	parameter S0 = 3'b000 , S1 = 3'b001 , S2 = 3'b010 , S3 = 3'b011 , S4 = 3'b100 , S5 = 3'b101;
	
	always @ (posedge clock or R)
		if(R) present = S0;
		else present = next;
	/// for nextstate
	always @ (present or in)
		case (present)
			S0: begin
					if (in[0])
						next = S3;
					else if ((in == 3'b100) | (in == 3'b110))
						next = S1;
					else 
						next = S0;
				end
				
			S1: begin
					if (in[0])
						next = S3;
					else if ((in == 3'b000) | (in == 3'b010))
						next = S1;
					else if ((in == 3'b100) | (in == 3'b110))
						next = S2;
				end
				
			S2: begin
					if ((in == 3'b000) | (in == 3'b010))
						next = S2;
					else if ((in == 3'b100) | (in == 3'b110) | in[0])
						next = S3;
				end
				
			S3: begin
					if (in[1])
						next = S4;
					else 
						next = S3;
				end
				
			S4: begin
					if ((in == 3'b000) | (in == 3'b010))
						next = S4;
					else if ((in == 3'b100) | (in == 3'b110) | in[0])
						next = S5;
				end
				
			S5: begin
					if ((in[1]))
						next = S0;
					else
						next = S5;
				end
		
		endcase
	//// for output 
	always @ (present or in)
		case (present)
		
			S0: begin
			  #0.002 
					if (in[0])
						out = 3'b100;
					else if ((in == 3'b100) | (in == 3'b110))
						out = 3'b010;
					else if ((in == 3'b000) | (in == 3'b010))
						out = 3'b010;
						
				end
				
			S1: begin
			  #0.002 
					if (in[0])
						out = 3'b100;
					else if((in == 3'b000) | (in == 3'b010))
						out = 3'b010;
					else if ((in == 3'b100) | (in == 3'b110))
						out = 3'b010;
				end
				
			S2: begin
			  #0.009 
					if ((in == 3'b000) | (in == 3'b010))
						out = 3'b010;
					else if ((in == 3'b100) | (in == 3'b110) | in[0])
						out = 3'b100;
				end
				
			S3: begin
			  #0.009
					if (~in[1])
						out = 3'b000;
					else 
						out = 3'b101;
				end
				
			S4: begin
			  #0.002 
					if ((in == 3'b000) | (in == 3'b010))
						out = 3'b001;
					else if ((in == 3'b100) | (in == 3'b110) | in[0])
						out = 3'b100;
				end
				
			S5: begin
			  #0.002 
					if (~in[1])
						out = 3'b000;
					else
						out = 3'b110;
				end
		endcase
		
endmodule



module thirdComb (A_Time_L, A_Time_H, B_Time_L, B_Time_H, A_Light, B_Light, A, B, R, atl, ath, btl, bth, z2, z3);

	output [3:0]A_Time_L, A_Time_H, B_Time_L, B_Time_H;
	output A_Light, B_Light;
	reg [3:0]A_Time_L, A_Time_H, B_Time_L, B_Time_H;
	reg A_Light , B_Light;
	input A, B, R;
	input [3:0]atl, ath, btl, bth;
	input z2, z3;
	
	always @ (A or B or R or atl or ath or btl or bth or z2 or z3)
	
		if(R == 1) 
			begin
				  #0.005 A_Time_L = 4'b0;
				  #0.005 A_Time_H = 4'b0;
				  #0.005 B_Time_L = 4'b0;
				  #0.005 B_Time_H = 4'b0;
				  #0.005 A_Light = 1;
				  #0.005 B_Light = 0;
			end
			
		else if(A == 1) 
			begin
				  #0.005 A_Time_L = 4'b1111;
				  #0.005 A_Time_H = 4'b1111;
				  #0.005 B_Time_L = 4'b1111;
				  #0.005 B_Time_H = 4'b1111;
				  #0.005 A_Light = 1;
				  #0.005 B_Light = 0;
			end
			
		else if(B == 1) 
			begin
				  #0.005 A_Time_L = 4'b1111;
				  #0.005 A_Time_H = 4'b1111;
				  #0.005 B_Time_L = 4'b1111;
				  #0.005 B_Time_H = 4'b1111;
				  #0.005 A_Light = 0;
				  #0.005 B_Light = 1;
			end
			
		else
			begin
				  #0.005 A_Time_L = atl;
				  #0.005 A_Time_H = ath;
				  #0.005 B_Time_L = btl;
				  #0.005 B_Time_H = bth;
				  #0.005 A_Light = z2;
				  #0.005 B_Light = z3;
			end
			
endmodule


module counter2to0 (Q, clock, R, Z1,enable);
  input enable;	
	input clock,R,Z1;
	output [3:0]Q;
	reg [3:0]Q;
	reg [3:0]num = 4'b0010;
	
	
	always @ (posedge clock or R or Z1)
	#0.003
	  begin
	   	if(R | Z1)	num = 4'b0010;
	   	else if(enable)
			begin		
				if(num == 4'b0) 
					num = 4'b0010;
				else
				  num = num - 1;
			end
		
		  assign Q = num;
		end
		  
	
endmodule


module secondComb (atl, ath, btl, bth, c1, c2, c3, z2, z3);

	output [3:0]atl, ath, btl, bth;
	reg [3:0]atl, ath, btl, bth;
	input [3:0] c1, c2, c3;
	input z2, z3;
	
	always @ (c1 or c2 or c3 or z2 or z3)
	
		if(z2 == 0 & z3 == 0) 
			begin
				atl = 4'b0;
				ath = 4'b0;
				btl = 4'b0;
				bth = 4'b0;
			end
			
		else if(z2 == 0 & z3 == 1)
			begin
				atl = c1;
				ath = c3;
				btl = c1;
				bth = c3;
			end
			
		else if(z2 == 1 & z3 == 0)
			begin
				atl = c1;
				ath = c2;
				btl = c1;
				bth = c2;
			end
			
endmodule



module counter9to0 (Q, enable, clock, R, Z1);
	
	input clock,R,Z1;
	output [3:0]Q;
	output enable;
	reg enable;
	reg [3:0]Q;
	reg [3:0]num = 4'b1001;
	
	
	always @ (posedge clock or R or Z1)
	begin
		if(R | Z1)
			begin
				num = 4'b1001;
				#0.001 enable = 0;
			end
			
		else if(num == 4'b0)
			begin
				num = 4'b1001;
				#0.001 enable = 1;
			end
			
		else	
			begin
				num = num - 1;
				#0.001 enable = 0;
			end
		
		assign Q = num;
	end
endmodule
			
			


module counter8to0 (Q, clock, R, Z1, enable);
  input enable;
	input clock,R,Z1;
	output [3:0]Q;
	reg [3:0]Q;
	reg [3:0]num = 4'b1000;
	
	
	always @ (posedge clock or R or Z1)
	#0.003
	begin
		if(R | Z1)	num = 4'b1000;
		else if(enable)
			begin		
				if(num == 4'b0) 
					num = 4'b1000;
				else
				  num = num - 1;
			end
		
		assign Q = num;
	end
endmodule


module finalModule (A_Time_L, A_Time_H, B_Time_L, B_Time_H, A_Light, B_Light, A, B, R, A_trafic, B_trafic, clock);
  input A_trafic , B_trafic;
	output [3:0] A_Time_L, A_Time_H, B_Time_L, B_Time_H;
	output A_Light, B_Light;
	input A, B, R, clock;
	wire i1, i2;
	wire [2:0]z;
	wire [2:0]in;

	combCircuit1 cc1 (i1 , i2 , A_trafic , z[1] , B_trafic , z[0]);
	wire out;
	seqCircuit1 sc1 (out , i1 , clock, R);
	//and aa(in[0], i2, out);
	
	assign in[0] = A & ~A;
	//
	seqCircuit2 sc2 (z , in , clock, R);
	counter30 c30 (in[2] , clock , R, z[2]);
	counter5 c5 (in[1] , clock , R, z[2]);
	//
	wire enable;
	wire [3:0]c1, c2, c3;
	counter9to0 c90 (c1, enable, clock, R, z[2]);
	counter8to0 c80 (c2, clock, R, z[2], enable);
	counter2to0 c20 (c3, clock, R, z[2],enable);
	wire [3:0]atl, ath, btl, bth;
	secondComb cc2 (atl, ath, btl, bth, c1, c2, c3, z[1], z[0]);
	//
	thirdComb cc3 (A_Time_L, A_Time_H, B_Time_L, B_Time_H, A_Light, B_Light, A, B, R, atl, ath, btl, bth, z[1], z[0]);
	
endmodule


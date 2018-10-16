`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/27/2018 02:44:03 PM
// Design Name: 
// Module Name: ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module ALU (m, s1, s0, A, B, out, zFlag, oFlag);

input m, s1, s0;
input [3:0] A, B;

output reg [3:0] out;
output reg zFlag, oFlag; //additional output signals


always @ (m, s1, s0, A, B)
begin
    if (m == 1'b0) //logic operation
        case ({s1, s0})
            2'b00: out = ~A; //bitwise negation
            2'b01: out = A & B; //bitwise AND
            2'b10: out = A ^ B; //bitwise XOR
            default: out = A | B; //bitwise OR
        endcase
    else //arithmetic operation
        case ({s1, s0})
            2'b00: 
                begin 
                    out = A - 1; // decrement
                end
            2'b01: 
                begin
                    out = A + B; //addition
                end
            2'b10:  
                begin
                    out = A - B; //subtraction
                end
            default: 
                begin
                    out = A + 1; // increment
                end
        endcase
        
        
        if(out > 4'd15) 
          begin 
            oFlag = 1;
          end
        else
           begin
             oFlag = 0;
           end
          
        if (out == 4'd0)
            begin
                zFlag = 1;
            end
        else
            begin
                zFlag = 0;
            end
end

endmodule

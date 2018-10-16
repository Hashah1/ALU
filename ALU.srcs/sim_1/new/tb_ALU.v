`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/27/2018 04:08:48 PM
// Design Name: 
// Module Name: tb_ALU
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


module tb_ALU;
    reg [3:0] A,B;
    reg m,s1,s0; 
    
    wire [3:0] out;
    wire zFlag;
    wire oFlag;
    
    reg tb_exp_Out, oFlag_exp_Out, zFlag_exp_Out;
    ALU DUT(m,s1,s0,A,B,out,zFlag,oFlag);
    
    integer i,j,k;
    integer err = 0;
    integer oFlagError = 0;
    integer zFlagError = 0;
    
initial begin
    for (i = 0; i < 8; i = i + 1)
        begin
            for (j = 0; j < 16; j = j + 1)
                begin
                    for (k = 0; k < 16; k = k + 1)
                        begin
                            m = i[2];
                            s1 = i[1];
                            s0 = i[0];
                            A = j;
                            B = k;
                            if (m == 1'b0) //logic operation
                                    case ({s1, s0})
                                        2'b00: tb_exp_Out = ~A;
                                        2'b01: tb_exp_Out = A & B; //bitwise AND
                                        2'b10: tb_exp_Out = A ^ B; //bitwise XOR
                                        default: tb_exp_Out = A | B; //bitwise OR
                                    endcase
                            else //arithmetic operation
                                            case ({s1, s0})
                                                2'b00: 
                                                    begin 
                                                        tb_exp_Out = A - 1; // decrement
                                                    end
                                                2'b01: 
                                                    begin
                                                        tb_exp_Out = A + B; //addition
                                                    end
                                                2'b10:  
                                                    begin
                                                        tb_exp_Out = A - B; //subtraction
                                                    end
                                                default: 
                                                    begin
                                                        tb_exp_Out = A + 1; // increment
                                                    end
                                            endcase
                                            
                                    #5; //delay
                                    if (tb_exp_Out > 4'd15) 
                                        begin
                                            oFlag_exp_Out = 1;
                                        end
                                    else
                                        begin 
                                            oFlag_exp_Out = 0;
                                        end
                                    
                                    if (tb_exp_Out == 4'd0) 
                                        begin 
                                            zFlag_exp_Out = 1;
                                        end
                                    else 
                                        begin
                                            zFlag_exp_Out = 0;
                                        end

                                    if (tb_exp_Out != out)
                                        begin
                                            $display("error %d,%d,%d,%d, %d , %d out != expectedOut", out, tb_exp_Out, A,B,s1,s0);
                                            err = err+1;
                                        end 

                                    if (oFlag_exp_Out != oFlag)
                                        begin 
                                            $display("error %d oFlag", oFlag_exp_Out); 
                                            oFlagError = oFlagError + 1;
                                        end
                                    
                                    if (zFlag_exp_Out != zFlag) 
                                        begin 
                                            $display("error %d zFlag", zFlag_exp_Out); 
                                            zFlagError = zFlagError + 1;
                                        end
                                                                            #5; //delay

                        end
                end
        end    
end
endmodule

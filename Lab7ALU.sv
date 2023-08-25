`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CPE 233-01 Computer Design & Assembly Language Programming
// Engineer: Daryl Ng
// 
// Create Date: 04/27/2021 04:20:48 PM
// Module Name: Lab3alu
// Project Name: Experiment 3 ALU
// Target Devices: Basys 3 
// Description: ALU component for the RISC-V MCU
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Lab7ALU #(parameter n = 31)(
    input [n:0] op1,
    input [n:0] op2,
    input [3:0] alu_fun,
    output logic [n:0] Result
    );
    
    always @ (*)
    begin
           case(alu_fun)
                4'b0000: Result = op1 + op2;    //add = 0
                4'b1000: Result = op1 - op2;    //sub = 8
                4'b0110: Result = op1 | op2;    //or = 6
                4'b0111: Result = op1 & op2;    //and = 7
                4'b0100: Result = op1 ^ op2;   //xor = 4
                4'b0101: Result = op1 >> op2[4:0];   //srl = 5 - shift op1 right by lower 5-bits of op2 # of times
                4'b0001: Result = op1 << op2[4:0];   //sll = 1 - shift op1 left by lower 5-bits of op2 # of times
                4'b1101: Result = $signed(op1) >>> op2[4:0];  //sra = 13
                4'b0010:                        //slt = 2
                         if($signed(op1) < $signed(op2)) 
                             Result = 32'b1;
                         else
                             Result = 32'b0;    
                4'b0011:                        //sltu = 3
                         if($unsigned(op1) < $unsigned(op2)) 
                             Result = 32'b1;
                         else
                             Result = 32'b0;
                4'b1001:                        //lui = 9
                begin                        
                         Result = op1;
                end
                default: Result = 32'hDEADBEEF;
           endcase
    end    
endmodule

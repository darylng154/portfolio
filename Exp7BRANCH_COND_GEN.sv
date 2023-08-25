`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/23/2021 02:50:09 PM
// Design Name: 
// Module Name: Exp6BRANCH_COND_GEN 
// Description: 
// 
// Dependencies: 
// 
//////////////////////////////////////////////////////////////////////////////////


module Exp7BRANCH_COND_GEN #(parameter n = 32)(
    input [n-1:0] rs1,
    input [n-1:0] rs2,
    output br_eq,
    output br_lt,
    output br_ltu
    );
    
    assign br_eq = rs1 == rs2;
    assign br_lt = $signed(rs1) < $signed(rs2);
    assign br_ltu = $unsigned(rs1) < $unsigned(rs2);
    
endmodule

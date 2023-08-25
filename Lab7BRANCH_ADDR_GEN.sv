`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CPE 233-01 Computer Design & Assembly Language Programming
// Engineer: Daryl Ng
// 
// Create Date: 05/05/2021 05:53:44 PM
// Design Name: 
// Module Name: Lab4BRANCH_ADDR_GEN
// Description: 
//  Instantiation of Experiment 4 (BRANCH_ADDR_GEN) 
//////////////////////////////////////////////////////////////////////////////////


module Lab7BRANCH_ADDR_GEN #(parameter n = 32)(
    input [n-1:0] rs1,
    input [n-1:0] pc,
    input [n-1:0] i_type,
    input [n-1:0] j_type,
    input [n-1:0] b_type,
    output [n-1:0] jal,
    output [n-1:0] branch,
    output [n-1:0] jalr
    );
    
    assign jal = pc + j_type;
    assign branch = pc + b_type;
    assign jalr = rs1 + i_type;
    
endmodule

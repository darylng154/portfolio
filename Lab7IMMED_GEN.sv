`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CPE 233-01 Computer Design & Assembly Language Programming
// Engineer: Daryl Ng
// 
// Create Date: 05/05/2021 05:15:18 PM
// Design Name: 
// Module Name: Lab4IMMED_GEN
// Description: 
//  Instantiation of Experiment 4 (IMMED_GEN) 
//////////////////////////////////////////////////////////////////////////////////


module Lab7IMMED_GEN #(parameter n = 32)(
    input [n-1:7] ir,
    output [n-1:0] u_type,
    output [n-1:0] i_type,
    output [n-1:0] s_type,
    output [n-1:0] j_type,
    output [n-1:0] b_type
    );
    
    assign u_type = {ir[31:12] , 12'b000000000000 };
    assign i_type = {{21{ir[31]}}, ir[30:20]};
    assign s_type = {{21{ir[31]}}, ir[30:25], ir[11:7]};
    assign j_type = {{12{ir[31]}}, ir[19:12], ir[20], ir[30:21], 1'b0};
    assign b_type = {{20{ir[31]}}, {ir[7], {ir[30:25],{ir[11:8], 1'b0}}}};
    
endmodule

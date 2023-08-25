`timescale 1ns / 1ps
`default_nettype none

//////////////////////////////////////////////////////////////////////////////////
// Company: Ratner Surf Designs
// Engineer: James Ratner
// 
// Create Date: 10/23/2018 07:39:17 PM
// Design Name: 
// Module Name: mux_6t1_nb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 6:1 MUX with parametized data widths
//
//  USEAGE: (for 4-bit data instantiation)
//
//  mux_6t1_nb  #(.n(32)) my_6t1_mux  (
//       .SEL   (xxxx), 
//       .D0    (xxxx), 
//       .D1    (xxxx), 
//       .D2    (xxxx), 
//       .D3    (xxxx),
//       .D4    (xxxx),
//       .D5    (xxxx),
//       .D_OUT (xxxx) );  
// 
// Dependencies: 
// 
// Revision History:
// Revision 0.01 - File Created: 10-23-2018
//          1.01 - fixed default width error (10-28-2018)
//          1.02 - switched to non-blocking assignments
//          1.03 - switched to blockign assignments and 
//                 default value for sensitivity list
//                 switched to case statement
//          1.04 - (11-24-2019) added macros; edited format
//          1.05 - (10-09-2020) fixed error in code
//          1.06 - (12-08-2020) fixed default parameter position
//                              removed default case
//
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

   
 module Lab7mux_6t1_nb  #(parameter n=8) (
       input wire [2:0] SEL,       //pcSource
       input wire [n-1:0] D0, 
	   input wire [n-1:0] D1,      //jalr
	   input wire [n-1:0] D2,      //branch
	   input wire [n-1:0] D3,      //jal
	   input wire [n-1:0] D4,      //mtvec
	   input wire [n-1:0] D5,      //mepc
       output reg [n-1:0] D_OUT);  //pc[15:2]
 
        
       always @ (*)
       begin 
          case (SEL) 
          0:      D_OUT = D0;
          1:      D_OUT = D1;
          2:      D_OUT = D2;
          3:      D_OUT = D3;
          4:      D_OUT = D4;
          5:      D_OUT = D5;
          //default D_OUT = 0;
          endcase 
	   end
                
endmodule

`default_nettype wire

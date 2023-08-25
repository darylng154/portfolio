`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CPE 233-01 Computer Design & Assembly Language Programming
// Engineer: Daryl Ng
// 
// Create Date: 05/17/2021 04:21:18 PM
// Design Name: 
// Module Name: Exp6OTTER_MCU
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////


module Exp7OTTER_MCU #(parameter n = 32)(
    input RST,
    input intr,
    input clk,
    input [n-1:0] IOBUS_in,
    output [n-1:0] IOBUS_out,
    output [n-1:0] IOBUS_addr,
    output IOBUS_wr
    );
    
    logic [n-1:0] pc_in, pc;                                                //PC connections
    
    logic [n-1:0] ir, DOUT2;                                                //MEMORY connections
    
    logic [n-1:0] wd;                                                       //REG_FILE connections
    
    logic [n-1:0] i_imm, j_imm, b_imm, s_imm, u_imm, jal, branch, jalr;     //IMMED_GEN & BRANCH_ADDR_GEN connections
    
    logic [n-1:0] rs1, rs2, srcA, srcB, result;                             //ALU connections
    
    logic PCWrite, regWrite, memWE2, memRDEN1, memRDEN2, reset;             //CU_FSM connections
    
    logic [3:0] alu_fun;                                                    //CU_DCDR connections
    logic [1:0] alu_srcB, rf_wr_sel;
    logic [2:0] pcSource;
    logic alu_srcA;
    
    logic br_eq , br_lt, br_ltu;                                            //BRANCH_COND_GEN connections
    
    logic int_taken, csr_WE, csr_mie, csr_mie_and;                          //CSR connections
    logic [n-1:0] mtvec, mepc, RD;
    
    Lab7mux_6t1_nb #(.n(32)) MUX_PC (
        .SEL(pcSource), 
        .D0(pc + 32'd4), 
        .D1(jalr), 
        .D2(branch), 
        .D3(jal), 
        .D4(mtvec), 
        .D5(mepc), 
        .D_OUT(pc_in)    );
                             
    Lab7PC_MOD #(.n(32)) PC_MOD (
        .data_in  (pc_in), 
        .ld       (PCWrite), 
        .clk      (clk), 
        .clr      (reset), 
        .data_out (pc)    );                         
    
    Memory MEMORY (                
        .MEM_CLK (clk),
        .MEM_RDEN1 (memRDEN1),
        .MEM_RDEN2 (memRDEN2),
        .MEM_WE2   (memWE2),
        .MEM_ADDR1 (pc[15:2]),
        .MEM_ADDR2 (result),
        .MEM_DIN2  (rs2),
        .MEM_SIZE  (ir[13:12]),
        .MEM_SIGN  (ir[14]),
        .IO_IN     (IOBUS_in),
        .IO_WR     (IOBUS_wr),
        .MEM_DOUT1 (ir),
        .MEM_DOUT2 (DOUT2)    );
                                  
    RegFile REG_FILE (
        .wd   (wd),
        .clk  (clk), 
        .en   (regWrite),
        .adr1 (ir[19:15]),
        .adr2 (ir[24:20]),
        .wa   (ir[11:7]),
        .rs1  (rs1), 
        .rs2  (rs2)     );

    Lab7mux_4t1_nb #(.n(32)) MUX_REG (
        .SEL   (rf_wr_sel),
        .D0    (pc + 32'd4), 
        .D1    (RD), 
        .D2    (DOUT2), 
        .D3    (result), 
        .D_OUT (wd)    );                                                    
    
    Lab7IMMED_GEN #(.n(32)) IMMED_GEN (
        .ir     (ir[31:7]),
        .u_type (u_imm),
        .i_type (i_imm),
        .s_type (s_imm),
        .j_type (j_imm),
        .b_type (b_imm)    );
                                                                    
    Lab7BRANCH_ADDR_GEN #(.n(32)) BRANCH_ADDR_GEN (
        .rs1    (rs1),
        .pc     (pc),
        .i_type (i_imm),
        .j_type (j_imm),
        .b_type (b_imm),
        .jal    (jal),
        .branch (branch),
        .jalr   (jalr)    );
                                                  
    Lab7ALU  ALU (
        .alu_fun (alu_fun),
        .op1     (srcA),
        .op2     (srcB),
        .Result  (result)   );
                     
    Lab7mux_2t1_nb #(.n(32)) MUXA (
        .SEL   (alu_srcA),
        .D0    (rs1), 
        .D1    (u_imm), 
        .D_OUT (srcA)    ) ;                        
                     
    Lab7mux_4t1_nb #(.n(32)) MUXB (
        .SEL   (alu_srcB),
        .D0    (rs2), 
        .D1    (i_imm), 
        .D2    (s_imm), 
        .D3    (pc), 
        .D_OUT (srcB)    );                                                                        
                 
    Exp7CU_DCDR CU_DCDR (
        .br_eq     (br_eq), 
        .br_lt     (br_lt), 
        .br_ltu    (br_ltu),
        .opcode    (ir[6:0]),     //-  ir[6:0]
        .func7     (ir[30]),      //-  ir[30]
        .func3     (ir[14:12]),   //-  ir[14:12] 
        .alu_fun   (alu_fun),
        .pcSource  (pcSource),
        .alu_srcA  (alu_srcA),
        .alu_srcB  (alu_srcB), 
        .rf_wr_sel (rf_wr_sel),
        .int_taken (int_taken)    );
	
	Exp7CU_FSM CU_FSM (
        .intr     (csr_mie_and),
        .clk      (clk),
        .RST      (RST),
        .opcode   (ir[6:0]),        // ir[6:0]
        .pcWrite  (PCWrite),
        .regWrite (regWrite),
        .memWE2   (memWE2),
        .memRDEN1 (memRDEN1),
        .memRDEN2 (memRDEN2),
        .reset    (reset),
        .int_taken(int_taken),   
        .csr_WE   (csr_WE)    );
                       
    Exp7BRANCH_COND_GEN #(.n(32)) BRANCH_COND_GEN (
        .rs1   (rs1),
        .rs2   (rs2),
        .br_eq (br_eq),
        .br_lt (br_lt),
        .br_ltu(br_ltu)    );
    
    Exp7CSR CSR(
        .CLK       (clk),
        .RST       (reset),
        .INT_TAKEN (int_taken),           
        .ADDR      (ir[31:20]),
        .PC        (pc),
        .WD        (rs1),
        .WR_EN     (csr_WE),
        .RD        (RD),
        .CSR_MEPC  (mepc),  //- return from interrupt addr
        .CSR_MTVEC (mtvec), //- interrupt vector address  
        .CSR_MIE   (csr_mie)     );            
                       
    assign IOBUS_addr = result;
    assign IOBUS_out  = rs2;        
    assign csr_mie_and = csr_mie & intr;

endmodule

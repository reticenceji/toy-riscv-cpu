`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/03/2021 06:55:25 PM
// Design Name: 
// Module Name: CPU_SOC
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


module CPU_SOC(
    input clk_100mhz,
    input RSTN,
    input [3:0]BTN_y,
    input [15:0] SW,
    
    output HSYNC,
    output VSYNC,
    output [3:0]Red,
    output [3:0]Green,
    output [3:0]Blue
    );
    
    wire [3:0]BTN_OK; wire [15:0]SW_OK; wire rst;
    SAnti_jitter U9(
        .clk(clk_100mhz),
        .RSTN(RSTN),
        .Key_y(BTN_y),
        .readn(),   // NULL
        .SW(SW),

        .Key_x(),   // NULL
        .Key_out(), // NULL
        .Key_ready(),   // NULL
        .BTN_OK(BTN_OK),
        .SW_OK(SW_OK),
        .CR(),      // NULL
        .rst(rst),
        .pulse_out()
    );  // Check

    wire [31:0]clkdiv; wire Clk_CPU;
    clk_div U8(
        .clk(clk_100mhz),
        .rst(rst),
	    .SW2(SW_OK[2]),
		.SW8(SW_OK[8]),
		.STEP(BTN_OK[0]),
		
        .clkdiv(clkdiv),
		.Clk_CPU(Clk_CPU)
    );  //check

    wire [31:0]Peripheral_in; wire counter_we;
    wire counter0_OUT,counter1_OUT,counter2_OUT; wire [31:0] counter_out;
    Counter_x U10 (
        .clk(~Clk_CPU),
		.rst(rst),
		.clk0(clkdiv[6]),
		.clk1(clkdiv[9]),
		.clk2(clkdiv[11]),
		.counter_we(counter_we),
		.counter_val(Peripheral_in),
        .counter_ch(),

		.counter0_OUT(counter0_OUT),
		.counter1_OUT(counter1_OUT),
		.counter2_OUT(counter2_OUT),
		.counter_out(counter_out)
    );  //check

    wire [31:0] PC_out;
    wire [31:0] instruction;
    dist_mem_gen_0 U2(
        .a(PC_out[11:2]),

        .spo(instruction)
    );  //check

    wire [9:0] ram_addr;        //Memory Address signals
    wire data_ram_we;
    wire [31:0] ram_data_in;    //from CPU write to Memory
    wire [31:0] douta;
    RAM_B U3(
        .clka(~clk_100mhz),
        .wea(data_ram_we),      // TODO
        .addra(ram_addr),
        .dina(ram_data_in),

        .douta(douta)              
    );

    wire MemRW;
    wire [31:0] Cpu_data4bus;
    wire [31:0] Addr_out;
    wire [31:0] Data_out;
    wire [31:0] ra  ;
    wire [31:0] sp  ;
    wire [31:0] gp  ;
    wire [31:0] tp  ;
    wire [31:0] t0  ;
    wire [31:0] t1  ;
    wire [31:0] t2  ;
    wire [31:0] s0  ;
    wire [31:0] s1  ;
    wire [31:0] a0  ;
    wire [31:0] a1  ;
    wire [31:0] a2  ;
    wire [31:0] a3  ;
    wire [31:0] a4  ;
    wire [31:0] a5  ;
    wire [31:0] a6  ;
    wire [31:0] a7  ;
    wire [31:0] s2  ;
    wire [31:0] s3  ;
    wire [31:0] s4  ;
    wire [31:0] s5  ;
    wire [31:0] s6  ;
    wire [31:0] s7  ;
    wire [31:0] s8  ;
    wire [31:0] s9  ;
    wire [31:0] s10 ;
    wire [31:0] s11 ;
    wire [31:0] t3  ;
    wire [31:0] t4  ;
    wire [31:0] t5  ;
    wire [31:0] t6  ;

    SCPU U1(
        .MIO_ready(),// NULL
        .clk(Clk_CPU),
        .rst(rst),
        .Data_in(Cpu_data4bus),        // TODO
        .inst_in(instruction),
        .INT(SW_OK[1]),
        
        .CPU_MIO(),// NULL
        .MemRW(MemRW),
        .Addr_out(Addr_out),
        .Data_out(Data_out),
        .PC_out(PC_out),

        .ra (ra ),
        .sp (sp ),
        .gp (gp ),
        .tp (tp ),
        .t0 (t0 ),
        .t1 (t1 ),
        .t2 (t2 ),
        .s0 (s0 ),
        .s1 (s1 ),
        .a0 (a0 ),
        .a1 (a1 ),
        .a2 (a2 ),
        .a3 (a3 ),
        .a4 (a4 ),
        .a5 (a5 ),
        .a6 (a6 ),
        .a7 (a7 ),
        .s2 (s2 ),
        .s3 (s3 ),
        .s4 (s4 ),
        .s5 (s5 ),
        .s6 (s6 ),
        .s7 (s7 ),
        .s8 (s8 ),
        .s9 (s9 ),
        .s10(s10),
        .s11(s11),
        .t3 (t3 ),
        .t4 (t4 ),
        .t5 (t5 ),
        .t6 (t6 )
    );

    MIO_BUS U4(
        .clk(clk_100mhz),
        .rst(rst),
        .BTN(BTN_OK),
        .SW(SW_OK),
        .mem_w(MemRW),                      //MemRW from CPU
        .Cpu_data2bus(Data_out),		    //data from CPU
        .addr_bus(Addr_out),
        .ram_data_out(douta),
        .led_out(),         //NULL
        .counter_out(counter_out),
        .counter0_out(counter0_OUT),
        .counter1_out(counter1_OUT),
        .counter2_out(counter2_OUT),
        
        .Cpu_data4bus(Cpu_data4bus),			//write to CPU
        .ram_data_in(ram_data_in),				//from CPU write to Memory
        .ram_addr(ram_addr),					//Memory Address signals
        .data_ram_we(data_ram_we),
        .GPIOf0000000_we(),             //NULL
        .GPIOe0000000_we(),             //NULL
        .counter_we(counter_we),
        .Peripheral_in(Peripheral_in)
    );

    VGA U11(
        .clk_25m(clkdiv[1]),
        .clk_100m(clk_100mhz),
        .rst(rst),
        .pc(PC_out),
        .inst(instruction),
        .alu_res(Addr_out),
        .mem_wen(MemRW),
        .dmem_o_data(douta),
        .dmem_i_data(ram_data_in),
        .dmem_addr(Addr_out),
        .x0 (0),
        .ra (ra ),
        .sp (sp ),
        .gp (gp ),
        .tp (tp ),
        .t0 (t0 ),
        .t1 (t1 ),
        .t2 (t2 ),
        .s0 (s0 ),
        .s1 (s1 ),
        .a0 (a0 ),
        .a1 (a1 ),
        .a2 (a2 ),
        .a3 (a3 ),
        .a4 (a4 ),
        .a5 (a5 ),
        .a6 (a6 ),
        .a7 (a7 ),
        .s2 (s2 ),
        .s3 (s3 ),
        .s4 (s4 ),
        .s5 (s5 ),
        .s6 (s6 ),
        .s7 (s7 ),
        .s8 (s8 ),
        .s9 (s9 ),
        .s10(s10),
        .s11(s11),
        .t3 (t3 ),
        .t4 (t4 ),
        .t5 (t5 ),
        .t6 (t6 ),

        .hs(HSYNC),
        .vs(VSYNC),
        .vga_r(Red),
        .vga_g(Green),
        .vga_b(Blue)
    );
endmodule

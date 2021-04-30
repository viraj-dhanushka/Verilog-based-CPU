// Computer Architecture (CO224) - Lab 06
// Design: Testbench of Integrated CPU of Simple Processor

`timescale  1ns/100ps
module cpu_tb;

    reg CLK, RESET;
    wire [31:0] PC;
    wire BUSYWAIT;

    //data memory / cache
    wire [7:0] WRITEDATA;
    wire [7:0] ADDRESS;
    wire WRITE, READ;

    wire [7:0] READDATA;
    wire DATA_BUSYWAIT;
    
    wire [31:0] MEM_WRITEDATA;
    wire [5:0] MEM_ADDRESS;
    wire MEM_WRITE, MEM_READ;
    wire [31:0] MEM_READDATA;
    wire MEM_BUSYWAIT;

    //Instruction memory / cache
    wire [31:0] INSTRUCTION;

    wire INS_BUSYWAIT, INS_MEM_BUSYWAIT, INS_MEM_READ;
    wire [127:0] MEM_READINS;
    wire [5:0] INS_MEM_ADDRESS;
    
    instruction_memory instruction_memory(CLK, INS_MEM_READ, INS_MEM_ADDRESS, MEM_READINS, INS_MEM_BUSYWAIT);
    instruction_cache instructionCache(CLK, RESET, PC, PC[9:0], INSTRUCTION, INS_BUSYWAIT, MEM_READINS, INS_MEM_BUSYWAIT, INS_MEM_READ, INS_MEM_ADDRESS);
    cpu CPU(ADDRESS, WRITEDATA, READ, WRITE, PC,  INSTRUCTION, CLK, RESET, BUSYWAIT, READDATA);
    data_cache dataCache(CLK, RESET, READ, WRITE, ADDRESS, WRITEDATA, READDATA, DATA_BUSYWAIT, MEM_READDATA, MEM_BUSYWAIT, MEM_READ, MEM_WRITE, MEM_ADDRESS, MEM_WRITEDATA);
    data_memory data_memory(CLK, RESET, MEM_READ, MEM_WRITE, MEM_ADDRESS, MEM_WRITEDATA, MEM_READDATA, MEM_BUSYWAIT);

    orGate orBusyWait(BUSYWAIT, INS_BUSYWAIT, DATA_BUSYWAIT);

    initial
    begin
    
        // generate files needed to plot the waveform using GTKWave
        $dumpfile("cpu_wavedata.vcd");
		$dumpvars(0, cpu_tb);
        
        CLK = 1'b1;
        RESET = 1'b0;

        //Reset the CPU (by giving a pulse to RESET signal) to start the program execution
        #4 RESET = 1'b1;
        #4 RESET = 1'b0;
        
        //finish simulation after some time
        #4200
        $finish;
        
    end
    
    // clock signal generation
    always
        #4 CLK = ~CLK;
        

endmodule
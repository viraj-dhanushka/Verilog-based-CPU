`timescale  1ns/100ps
module instruction_cache(
	clock,
    reset,
    pc,
    address,
    instruction,
    busywait,

    mem_read_instruction,       
    mem_busywait,
    mem_read,   
    mem_address

);
input           clock;
input           reset;
input[31:0]     pc;    
input[9:0]      address;
output reg[31:0] instruction;
output reg      busywait;

input[127:0]     mem_read_instruction;
input            mem_busywait;
output reg       mem_read;        
output reg [5:0] mem_address;     

wire [31:0] read_inst;
reg read;

//Declare instruction cache array 8x128-bits 
reg [127:0] inst_cache_array [7:0];

//Declare tag array 8x3-bits 
reg [2:0] tag_array [7:0];

//Declare valid bit memory 8-bits 
reg valid_array [7:0];

//extract tag, index, offset from adderss
wire [2:0] addr_tag;     
wire [2:0] addr_index;  
wire [1:0] addr_offset;

assign addr_tag = address[9:7];    
assign addr_index = address[6:4];  
assign addr_offset = address[3:2]; 

wire tag, valid, hit;
reg [127:0] inst_cache_block;
wire [2:0] tag_out;

always @ (pc)
begin
    if (pc != -32'd4) begin
	    busywait = 1'b1; 
        read = 1'b1;   
    end
    else begin
	    busywait = 0;    
	    read = 0;    
    end
end

/*
Combinational part for indexing, tag comparison for hit deciding, etc.
*/

//add latency of #1 for data word indexing    
always @ (*) begin
    #1 inst_cache_block = inst_cache_array[addr_index];
end

assign #1 tag_out = tag_array[addr_index];
assign #1 valid = valid_array[addr_index];

//data word selection latency overlaps with tag comparison
assign #1 tag = (tag_out == addr_tag ? 1 : 0);
 
assign hit = valid && tag;  

//read data from cache
mux_read_instcache mux_readInst(read, inst_cache_block[31:0], inst_cache_block[63:32], inst_cache_block[95:64], inst_cache_block[127:96], addr_offset, read_inst); 

//update instruction / de-assert BUSYWAIT / reset read
always @(*) begin

    if(hit) begin
        instruction = read_inst;
        busywait = 0;
    end
end


/* Cache Controller FSM Start */

parameter IDLE_STATE = 2'b00, MEM_READ_STATE = 2'b01, CACHE_UPDATE_STATE = 2'b10;
reg [1:0] state, next_state;

// combinational next state logic
always @(*)
begin
    case (state)
        IDLE_STATE:
            begin
                if (read && !hit)  
                    next_state = MEM_READ_STATE;
                else
                    next_state = IDLE_STATE;
            end

        MEM_READ_STATE:
            begin
                if (!mem_busywait)
                    next_state = CACHE_UPDATE_STATE;
                else    
                    next_state = MEM_READ_STATE;
            end

        CACHE_UPDATE_STATE:
            next_state = IDLE_STATE;

    endcase
end


// combinational output logic
always @(*)
begin
    case(state)
        IDLE_STATE:
        begin
            mem_read = 0;
            mem_address = 6'dX;
        end
        
        MEM_READ_STATE: 
        begin
            mem_read = 1;
            mem_address = {addr_tag, addr_index};
        end

        CACHE_UPDATE_STATE: 
        begin
            //write the fetched data block into the indexed cache entry
            //and update the tag, valid arrays accordingly
            mem_read = 0;
            #1 
            inst_cache_array[addr_index] = mem_read_instruction;
            tag_array[addr_index] = addr_tag;
            valid_array[addr_index] = 1'b1;
        end

    endcase
end

integer k;

// sequential logic for state transitioning
always @(posedge clock, reset)
begin
    if(reset) begin

        // Reset memory
        for (k = 0; k < 8; k = k+1) begin
            inst_cache_array[k] = 128'd0;
        end
        for (k = 0; k < 8; k = k+1) begin
            tag_array[k] = 3'bXXX;
        end
        for (k = 0; k < 8; k = k+1) begin
            valid_array[k] = 1'b0;
        end               
        state = IDLE_STATE;  
        busywait = 1'b0;
   
    end        
    else
        state = next_state;
end

/* Cache Controller FSM End */


endmodule
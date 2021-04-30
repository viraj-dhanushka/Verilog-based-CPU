`timescale  1ns/100ps
module data_cache(
	clock,
    reset,
    read,
    write,
    address,
    writedata,
    readdata,
    busywait,

    mem_readdata,       
    mem_busywait,
    mem_read,   
    mem_write,    
    mem_address,  
    mem_writedata

);
input           clock;
input           reset;
input           read;
input           write;
input[7:0]      address;
input[7:0]      writedata;
output[7:0]     readdata;
output reg      busywait;

input [31:0]     mem_readdata;
input            mem_busywait;
output reg       mem_read;        
output reg       mem_write;        
output reg [5:0] mem_address;            
output reg [31:0]mem_writedata; 

// wire[7:0]     outdata;
//Declare data cache array 8x32-bits 
reg [31:0] dacache_array [7:0];

//Declare tag array 8x3-bits 
reg [2:0] tag_array [7:0];

//Declare valid bit memory 8-bits 
reg valid_array [7:0];

//Declare dirty bit memory 8-bits 
reg dirty_array [7:0];

//extract tag, index, offset from adderss
wire [2:0] addr_tag;     
wire [2:0] addr_index;  
wire [1:0] addr_offset;

assign addr_tag = address[7:5];    
assign addr_index = address[4:2];  
assign addr_offset = address[1:0]; 

wire tag, valid, dirty, hit;
// reg hit;
reg [31:0] data_cache_out;
wire [2:0] tag_out;

//Detecting an incoming memory access
always @ (read, write)
begin
	busywait = (read || write)? 1 : 0;
end

/*
Combinational part for indexing, tag comparison for hit deciding, etc.
*/

//add latency of #1 for data word indexing    
always @ (*) begin
    #1 data_cache_out = dacache_array[addr_index];
end

assign #1 tag_out = tag_array[addr_index];
assign #1 valid = valid_array[addr_index];
assign #1 dirty = dirty_array[addr_index];

//data word selection latency overlaps with tag comparison
assign #0.9 tag = (tag_out == addr_tag ? 1 : 0);
 
assign hit = valid && tag;  

//read data from cache
mux_readdata mux_read_cache(read, data_cache_out[7:0], data_cache_out[15:8], data_cache_out[23:16], data_cache_out[31:24], addr_offset, readdata); 

//write the data to cache at the positive edge of the clock
always @(posedge clock) begin
    if (hit && write) begin
        #1    
        case (addr_offset) 

            2'b00 : dacache_array[addr_index] [7:0] = writedata; 
            2'b01 : dacache_array[addr_index] [15:8] = writedata;
            2'b10 : dacache_array[addr_index] [23:16] = writedata;
            2'b11 : dacache_array[addr_index] [31:24] = writedata;

        endcase


    end
end

// de-assert the BUSYWAIT signal at the positive clock edge
//update dirty bit parallel to the writing operation
always @(posedge clock) begin

    if(hit) begin
        busywait = 0;
    end
    if (hit && write) begin
        #1 dirty_array[addr_index] = 1'b1;              
    end
end

/* Cache Controller FSM Start */

parameter IDLE_STATE = 2'b00, MEM_READ_STATE = 2'b01, MEM_WRITE_STATE = 2'b10, CACHE_UPDATE_STATE = 2'b11;
reg [1:0] state, next_state;

// combinational next state logic
always @(*)
begin
    case (state)
        IDLE_STATE:
            begin
                if ((read || write) && !dirty && !hit)  
                    next_state = MEM_READ_STATE;
                else if ((read || write) && dirty && !hit)
                    next_state = MEM_WRITE_STATE;
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

        MEM_WRITE_STATE:
            begin
                if(!mem_busywait)
                    next_state = MEM_READ_STATE;
                else 
                    next_state = MEM_WRITE_STATE;
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
            mem_write = 0;
            mem_address = 8'dX;
            mem_writedata = 32'dX;
            // busywait = 0;
        end
        
        MEM_READ_STATE: 
        begin
            mem_read = 1;
            mem_write = 0;
            mem_address = {addr_tag, addr_index};
            mem_writedata = 32'dx;
            // busywait = 1;
        end

        MEM_WRITE_STATE: 
        begin
            mem_read = 0;
            mem_write = 1;
            mem_address = {tag_out, addr_index};
            mem_writedata = data_cache_out;
            // busywait = 1;
        end

        CACHE_UPDATE_STATE: 
        begin
            //write the fetched data block into the indexed cache entry
            //and update the tag, valid and dirty arrays accordingly
            #1 
            mem_read = 0;
            mem_write = 0;
            dacache_array[addr_index] = mem_readdata;
            tag_array[addr_index] = addr_tag;
            valid_array[addr_index] = 1'b1;
            dirty_array[addr_index] = 0;
            // busywait = 1;
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
            dacache_array[k] = 32'd0;
        end
        for (k = 0; k < 8; k = k+1) begin
            tag_array[k] = 3'bXXX;
        end
        for (k = 0; k < 8; k = k+1) begin
            valid_array[k] = 1'b0;
        end        
        for (k = 0; k < 8; k = k+1) begin
            dirty_array[k] = 1'b0;
        end          
        state = IDLE_STATE;  
        busywait = 1'b0;
   
    end        
    else
        state = next_state;
end

/* Cache Controller FSM End */


endmodule
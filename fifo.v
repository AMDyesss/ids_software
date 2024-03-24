module my_ram_fifo 
#(
   parameter DATA_W = 64,        // Data width
   parameter DEPTH = 64          // Depth
)
(
   input clk,        // Clock
   input rstn,        // Active-low Synchronous Reset                      

    /* Enqueue side */                       
   input wen_input,        // Write Enable
   input  [63:0] wdata,        // Write-data                    
   output full_output,        // Full signal
    
    /* Dequeue side */   
   input ren_input,        // Read Enable
   output [63:0] rdata,        // Read-data                    
   output empty_output                   // Empty signal
);

///////////////Internal Signals///////////////////

reg [7 : 0] head_ptr;        // Write pointer
reg [7 : 0] tail_ptr;        // Read pointer
reg [7 : 0] nxt_tail_ptr;    // Next Read pointer
reg [7 : 0] rdaddr;          // Read-address to RAM

reg wen;         // Write Enable signal generated if FIFO is not full
reg ren;         // Read Enable signal generated if FIFO is not empty
reg full;        // Full signal
wire empty;      // Empty signal
reg empty_rg;    // Empty signal (registered)
reg state_rg;    // State

/////////instant. of RAM//////////////////

FIFO ram  
(
   .clka (clk),    
   .clkb (clk),    
   .wea (wen),

   .ADDRA (head_ptr),
   .DINA (wdata),

   .ADDRB (rdaddr),
   .DOUTB (rdata)
);

///////write and read logic//////////

always @ (posedge clk) begin
   
   // Reset
   if (!rstn) 
      begin      
         head_ptr <= 0;
         tail_ptr <= 0; 
         state_rg <= 1'b0;
      end

   else 
      begin     
         if (wen)   //FIFO write
         begin         
            if (head_ptr == 63) 
               head_ptr <= 0;        // Reset head pointer  
            else 
               head_ptr <= head_ptr + 1;        // Increment head pointer            
         end

         if (ren)       //FIFO read  
         begin         
            if (tail_ptr == 63) 
               tail_ptr <= 0;                   // Reset tail pointer

            else 
               tail_ptr <= tail_ptr + 1;        // tail pointer⬆     
         end
         
         if (state_rg == 1'b0)       // FIFO is emptied
         begin
            if (wen && !ren) 
               state_rg <= 1'b1 ;                        
         end
       
         else          // FIFO is filled
         begin
            if (!wen && ren) 
               state_rg <= 1'b0 ;            
         end

      // Empty signal registered
      empty_rg <= empty ;      

   end

end



////Continuous Assignments/////


// Full and Empty internal
assign full = (head_ptr == tail_ptr) && (state_rg == 1'b1);
assign empty = ((head_ptr == tail_ptr) && (state_rg == 1'b0));

// Write and Read Enables internal
assign wen = wen_input & !full;  
assign ren = ren_input & !empty & !empty_rg;

// Full and Empty to output
assign full_output = full;
assign empty_output = empty || empty_rg;

// Read-address to RAM
assign nxt_tail_ptr = (tail_ptr == DEPTH - 1) ? 'b0 : tail_ptr + 1;
assign rdaddr = ren ? nxt_tail_ptr : tail_ptr;
 

endmodule



// ************************* Description *********************** //
//  This module is implemented to:-                              //
//   -- generate read address in binary code                     //
//   -- generate empty flag to overcome fifo underflow           //
//   -- generate gray coded read pointer                         //
// ************************************************************* //

module fifo_rd #(
  parameter P_SIZE = 4                          // pointer width
)
  (
   input  wire                     r_clk,              // read domian operating clock
   input  wire                     r_rstn,             // read domian active low reset 
   input  wire                     r_inc,              // read control signal 
   input  wire   [P_SIZE-1:0]      sync_wr_ptr,        // synced gray coded write pointer         
   output wire   [P_SIZE-2:0]      rd_addr,            // generated binary read address
   output wire                     empty,              // fifo empty flag
   output reg    [P_SIZE-1:0]      gray_rd_ptr         // generated gray coded write address

);

reg [P_SIZE-1:0]  rd_ptr ;

// increment binary pointer
always @(posedge r_clk or negedge r_rstn)
 begin
  if(!r_rstn)
   begin
    rd_ptr <= 0 ;
   end
 else if (!empty && r_inc)
    rd_ptr <= rd_ptr + 1 ;
 end


// generation of read address
assign rd_addr = rd_ptr[P_SIZE-2:0] ;

// converting binary read pointer to gray coded
always @(posedge r_clk or negedge r_rstn)
begin
 if(!r_rstn)
   begin
    gray_rd_ptr <= 0 ;
   end
 else 
  begin
   case (rd_ptr)
   4'b0000: gray_rd_ptr <= 4'b0000 ;
   4'b0001: gray_rd_ptr <= 4'b0001 ;
   4'b0010: gray_rd_ptr <= 4'b0011 ;
   4'b0011: gray_rd_ptr <= 4'b0010 ;
   4'b0100: gray_rd_ptr <= 4'b0110 ;
   4'b0101: gray_rd_ptr <= 4'b0111 ;
   4'b0110: gray_rd_ptr <= 4'b0101 ;
   4'b0111: gray_rd_ptr <= 4'b0100 ;
   4'b1000: gray_rd_ptr <= 4'b1100 ;
   4'b1001: gray_rd_ptr <= 4'b1101 ;
   4'b1010: gray_rd_ptr <= 4'b1111 ;
   4'b1011: gray_rd_ptr <= 4'b1110 ;
   4'b1100: gray_rd_ptr <= 4'b1010 ;
   4'b1101: gray_rd_ptr <= 4'b1011 ;
   4'b1110: gray_rd_ptr <= 4'b1001 ;
   4'b1111: gray_rd_ptr <= 4'b1000 ;
   endcase
  end
 end


// generation of empty flag
assign empty = (sync_wr_ptr == gray_rd_ptr) ;

endmodule

/*
module binary_to_gray #(
    parameter N = 3  // Parameter to define the bit-width, default is 3)
    (
    input  [N-1:0] binary_in,  // N-bit binary input
    output [N-1:0] gray_out    // N-bit Gray code output
    );
    // Assigning the MSB directly as it remains the same
    assign gray_out[N-1] = binary_in[N-1];
    // Loop to calculate the Gray code output from binary
    genvar i;
    generate
        for (i = N-2; i >= 0; i = i - 1) begin : bin_to_gray
            assign gray_out[i] = binary_in[i+1] ^ binary_in[i];
        end
    endgenerate
 endmodule
*/
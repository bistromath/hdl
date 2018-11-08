//simple reset synchronizer to cross clock domains
module reset_synchronizer
            (input clk,
             input areset,
             output reg reset);
   reg q1;
   always @(posedge clk or posedge areset) begin
      if (areset) begin
         q1 <= 1;
         reset <= 1;
      end
      else begin
         q1 <= 0;
         reset <= q1;
      end
   end
endmodule

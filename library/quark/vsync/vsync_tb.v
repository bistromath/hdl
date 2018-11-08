module vsync_tb();
   reg clk, vclk;

   initial clk = 0;
   initial vclk = 0;
   always #20 clk = ~clk; //50mhz
   always #48 vclk = ~vclk; //21mhz

   reg framevalidbuf[0:900000];
   reg linevalidbuf[0:900000];
   reg [7:0] databuf[0:900000];
   initial $readmemh("/home/nick/dev/quark/tb/data.hex", databuf);
   //initial $readmemb("clock.bin", clock);
   initial $readmemb("/home/nick/dev/quark/tb/framevalid.bin", framevalidbuf);
   initial $readmemb("/home/nick/dev/quark/tb/linevalid.bin", linevalidbuf);

   reg [7:0] data;
   reg framevalid, linevalid;

   integer i;
   reg reset;
   initial begin
      linevalid <= 0;
      framevalid <= 0;
      data <= 8'd0;
      reset <= 1;
      repeat (10)
         @(posedge vclk);
      reset <= 0;
      repeat (10)
         @(posedge vclk);
      i <= 0;
      repeat (800000) begin
         @(posedge vclk) begin
            i <= i + 1;
            data <= databuf[i];
            framevalid <= framevalidbuf[i];
            linevalid <= linevalidbuf[i];
         end
      end
   end

   wire [7:0] m_axis_data_tdata;
   wire m_axis_data_tlast, m_axis_data_tuser, m_axis_data_tvalid, m_axis_data_tready;
   assign m_axis_data_tready = 1'b1;
   wire overflow;

   vsync inst_vsync(
      .vclk(vclk),
      .data(data),
      .framevalid(framevalid),
      .linevalid(linevalid),
      .clk(clk),
      .reset(reset),
      .m_axis_data_tdata(m_axis_data_tdata),
      .m_axis_data_tlast(m_axis_data_tlast),
      .m_axis_data_tvalid(m_axis_data_tvalid),
      .m_axis_data_tready(m_axis_data_tready),
      .m_axis_data_tuser(m_axis_data_tuser),
      .overflow(overflow)
   );

endmodule

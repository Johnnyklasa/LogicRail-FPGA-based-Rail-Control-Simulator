`timescale 1ns / 1ps

module TopVgaTB;

    logic clk, rst;
    wire vs, hs;
    wire [3:0] r, g, b;
    
    // Instantiation of the main module
    TopVga u_TopVga(
        .clk(clk),
        .rst(rst),
        .X_POS(12'd250), // Constant cursor position
        .Y_POS(12'd250),
        .Semafor1Signal(2'h1), // Forcing red light signal
        .vs(vs),
        .hs(hs),
        .r(r),
        .g(g),
        .b(b),
        .PS2Data(),
        .PS2Clk()
    );

    // 40 MHz clock for 800x600 resolution (25ns period)
    initial clk = 0;
    always #12.5 clk = ~clk;

    integer fd;
    logic frame_started = 0;

    wire vblnk = u_TopVga.vga_mouse.vblnk;
    wire hblnk = u_TopVga.vga_mouse.hblnk;

    initial begin
        rst = 1;
        #100; 
        rst = 0;

        // Writing to the fast local drive of the university server (bypassing network latency)
        fd = $fopen("/tmp/station_map.ppm", "w");
        if (fd) $display("PPM file opened successfully. Frame generation in progress...");
        $fwrite(fd, "P3\n800 600\n15\n");
    end

    always_ff @(posedge clk) begin
        if (!rst) begin
            // Wait to exit the initial blanking period
            if (!vblnk && !frame_started) begin
                frame_started <= 1;
            end

            // Record the pixel only within the visible display area
            if (frame_started && !vblnk && !hblnk) begin
                $fwrite(fd, "%0d %0d %0d\n", r, g, b);
            end

            // End of frame - close the file descriptor and terminate the simulation
            if (frame_started && vblnk) begin
                $fclose(fd);
                $display("Success :/ ");
                $finish;
            end
        end
    end
endmodule
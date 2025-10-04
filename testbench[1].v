`timescale 1ns/1ps  // Define the time scale for simulation (nano seconds)

module sequenceDetector_tb;
  // Testbench signals declaration
  reg clk;                // Clock signal
  reg asyncReset;         // Asynchronous reset signal
  reg dataIn;             // Data input signal
  wire detectOut;         // Detection output signal from the DUT

  // Test statistics counters
  integer i;              // Loop counter for test sequences

  // Instantiate the Device Under Test (DUT)
  sequenceDetector dut 
  (
    .clk(clk),               // Connect testbench clock to DUT
    .asyncReset(asyncReset), // Connect testbench reset to DUT
    .dataIn(dataIn),         // Connect testbench data input to DUT
    .detectOut(detectOut)    // Connect DUT output to testbench
  );

  // Clock generation - 10ns period (100MHz)
  initial begin
    clk = 0;                 // Initialize clock to 0
    forever #5 clk = ~clk;   // Toggle clock every 5ns (10ns period)
  end

  // VCD file dump for waveform viewing
  initial begin
    $dumpvars; // Dump all variables in the testbench
  end

  // Main test stimulus
  initial begin
    // Initialize signals
    asyncReset = 1;          // Start with reset asserted
    dataIn = 0;              // Initialise data input to 0

    // Apply reset for 20ns
    #20 asyncReset = 0;

    // Wait for design to stabilise
    for(i=0; i<2; i=i+1) @(posedge clk);


    // Check sequences 0101 and 1001
    #10 dataIn = 0; #10 dataIn = 1; #10 dataIn = 0; #10 dataIn = 1;
    #10 dataIn = 0; #10 dataIn = 1; #10 dataIn = 0; #10 dataIn = 1;
    // Reset
    #10 asyncReset = 1;
    #20 asyncReset = 0;
    // Check all 16 possible 4-bit combinations
    #10 dataIn = 0; #10 dataIn = 0; #10 dataIn = 0; #10 dataIn = 0; // 0000
    #10 dataIn = 1; #10 dataIn = 0; #10 dataIn = 0; #10 dataIn = 0; // 0001
    #10 dataIn = 0; #10 dataIn = 1; #10 dataIn = 0; #10 dataIn = 0; // 0010
    #10 dataIn = 1; #10 dataIn = 1; #10 dataIn = 0; #10 dataIn = 0; // 0011
    #10 dataIn = 0; #10 dataIn = 0; #10 dataIn = 1; #10 dataIn = 0; // 0100
    #10 dataIn = 1; #10 dataIn = 0; #10 dataIn = 1; #10 dataIn = 0; // 0101 password 1
    #10 dataIn = 0; #10 dataIn = 1; #10 dataIn = 1; #10 dataIn = 0; // 0110
    #10 dataIn = 1; #10 dataIn = 1; #10 dataIn = 1; #10 dataIn = 0; // 0111
    #10 dataIn = 0; #10 dataIn = 0; #10 dataIn = 0; #10 dataIn = 1; // 1000
    #10 dataIn = 1; #10 dataIn = 0; #10 dataIn = 0; #10 dataIn = 1; // 1001 password 2
    #10 dataIn = 0; #10 dataIn = 1; #10 dataIn = 0; #10 dataIn = 1; // 1010
    #10 dataIn = 1; #10 dataIn = 1; #10 dataIn = 0; #10 dataIn = 1; // 1011
    #10 dataIn = 0; #10 dataIn = 0; #10 dataIn = 1; #10 dataIn = 1; // 1100
    #10 dataIn = 1; #10 dataIn = 0; #10 dataIn = 1; #10 dataIn = 1; // 1101
    #10 dataIn = 0; #10 dataIn = 1; #10 dataIn = 1; #10 dataIn = 1; // 1110
    #10 dataIn = 1; #10 dataIn = 1; #10 dataIn = 1; #10 dataIn = 1; // 1111
    
    // End simulation
    #20 $finish;
  end
endmodule
module sequenceDetector
(
  input clk,         // Clock signal
  input asyncReset,  // Asynchronous reset
  input dataIn,      // 1-bit data input
  output reg detectOut  // Output. Digital lock unlocked when HIGH, locked when LOW
);
  // Declaring states - using binary encoding
  parameter S0 = 3'b000;  // Initial state
  parameter S1 = 3'b001;  // After receiving "0" from S0
  parameter S2 = 3'b010;  // After receiving "1" from S0
  parameter S3 = 3'b011;  // After receiving "01" from S1
  parameter S4 = 3'b100;  // After receiving "10" from S2
  parameter S5 = 3'b101;  // After receiving "010" from S3 or "100" from S4

  // State registers
  reg [2:0] currentState, nextState;

  // Shift register to store last 4 bits
  reg [3:0] shiftReg;

  // Counter to track number of bits processed
  reg [1:0] bitCounter;

  // Next state logic using case statement
  always @(*) begin
  /// First check if we've processed 4 bits
    if (bitCounter == 2'b11) begin
      // After receiving 4 bits total, go back to S0 regardless of current state
     nextState <= S0;
    end

    else begin
      // Normal state transition logic if we haven't processed 4 bits yet
      case(currentState)
        S0: if (dataIn == 1'b0) begin nextState = S1; end
            else begin nextState = S2; end

        S1: if (dataIn == 1'b1) begin nextState = S3; end
            else begin nextState = S1; end  // Stay in S1 if we see another 0

        S2: if (dataIn == 1'b0) begin nextState = S4; end
            else begin nextState = S2; end // Stay in S2 if we see another 1

        S3: if (dataIn == 1'b0) begin nextState = S5; end 
            else begin nextState = S3; end // Stay in S3 if we see another 1

        S4: if (dataIn == 1'b0) begin nextState = S5; end 
            else begin nextState = S4; end // Stay in S4 if we see another 1

        S5: begin nextState = S0; end // Go back to initial state

        default: nextState = S0;
      endcase
    end
  end

  // Sequential logic for state transitions and shift register
  always @(posedge clk or posedge asyncReset) 
    begin
    // If reset signal applied
    if (asyncReset) 
      begin
        currentState <= S0;  // Back to initial state
        shiftReg <= 4'b0000;  // Clear shift register
        detectOut <= 1'b0;  // Reset output
        bitCounter <= 2'b00;  // Reset bit counter
      end 

    else 
      begin
        // Update state
        currentState <= nextState;

        // Shift in new bit
        shiftReg <= {shiftReg[2:0], dataIn};

        // Counter management
        if (nextState == S0) begin
          // Reset counter when transitioning to S0
          bitCounter <= 2'b00;
          detectOut <= 0;
          // Reset reg
          shiftReg <= 4'b0000;
        end

        // Check for pattern detection - both 0101 and 1001
          if (currentState == S5 && dataIn == 1'b1) 
            begin
              // Detected 0101 or 1001
              detectOut <= 1'b1;
            end 
          // Keep output high for one additional clock cycle for easier detection
          else if (detectOut == 1'b1) 
            begin
             detectOut <= 1'b0;
            end
      end
    end

  // Increment bit-counter whenever input changes
  always@(dataIn)
    begin
      bitCounter <= bitCounter + 1'b1;
    end
endmodule
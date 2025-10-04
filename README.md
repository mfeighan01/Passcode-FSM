# Passcode-FSM
An FSM designed to detect two 4-bit sequences, 0101 or 1001.
Start in S0 (after reset).
The first input bit decides the path: if dataIn is 0 go to S1; if dataIn is 1 go to S2.
The FSM follows those paths to track partial patterns:
Path S1 → S3 → S5 corresponds to detecting the sequence 0101.
Path S2 → S4 → S5 corresponds to detecting the sequence 1001.
When the FSM reaches S5 and the last bit (dataIn == 1) is received, detectOut is asserted for one clock cycle.

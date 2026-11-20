# UART Protocol Design Using Verilog HDL

## Description
Designed a UART (Universal Asynchronous Receiver-Transmitter) communication system using Verilog HDL in Xilinx Vivado. The design includes a baud rate generator, transmitter, receiver, and top module. It transmits and receives 8-bit serial data.

## Features
- Baud rate generation for transmitter and receiver.
- 8-bit data transmission and reception.
- Start bit and stop bit handling.
- FSM-based transmitter and receiver.
- Busy and ready status indicators.
- Internal loopback communication.

## Modules Used

### 1. Baud Rate Generator
- Generates clock enable signals for transmitter and receiver.
- Uses counters to control transmission and reception timing.

### 2. Transmitter
- Accepts 8-bit parallel input data.
- Converts parallel data into serial data.
- Uses FSM to control transmission.
- Transmits start bit, 8 data bits, and stop bit.

### 3. Receiver
- Receives serial data.
- Converts serial data into 8-bit parallel data.
- Uses FSM for data reception.
- Generates a ready signal after receiving data.

### 4. UART Top Module
- Connects the baud rate generator, transmitter, and receiver.
- Provides internal loopback communication.

### 5. Testbench
- Generates a 100 MHz clock.
- Applies reset and input data.
- Tests transmission and reception of characters 'A' and 'V'.
- Checks the received data.

## Simulation Test Cases

| Character | Input (Hex) | Expected Output (Hex) |
|-----------|-------------|-----------------------|
| A         | 8'h41       | 8'h41                 |
| V         | 8'h56       | 8'h56                 |

## Tools Used
- Xilinx Vivado
- Verilog HDL

## Files Included
- `Baud_Rate_Generator.v`
- `Transmitter.v`
- `Receiver.v`
- `uart_top.v`
- `uart_top_tb.v`

## Key Concepts Used
- UART Communication Protocol
- Finite State Machine (FSM)
- Serial-to-Parallel Conversion
- Parallel-to-Serial Conversion
- Clock Enable Generation
- Verilog HDL Testbench and Simulation
-

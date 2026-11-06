# UART-IP-Design-and-Verification-in-Verilog
Synthesizable UART Transmitter and Receiver with 16x Oversampling, Glitch Rejection, and Self-Checking Testbench.


## 1. Project Overview
This project presents a complete RTL design and verification of a Universal Asynchronous Receiver-Transmitter (UART) IP core. The design is implemented in Verilog and verified using a robust, self-checking testbench methodology.

**Key Features:**
* **Baud Rate Generator:** Configurable parameters for clock frequency and baudrate.
* **Transmitter (TX):** FSM-based design with `tx_busy` flag.
* **Receiver (RX):** Features 16x oversampling to align data sampling at the center of the bit. Includes a 2-Flop Synchronizer to prevent metastability.
* **Error Detection:** Built-in Glitch Rejection (filters spikes < 7 ticks) and Framing Error detection.

## 2. System Architecture
C:\Users\ADMIN\Pictures\Screenshots\Ảnh chụp màn hình 2026-11-06 220013.png

The top module (`uart_top.v`) integrates three sub-modules:
1. `baud_rate_generator`
2. `Transmitter`
3. `Receiver`

## 3. Verification Strategy (The Highlights)
The IP was verified using a Bottom-Up approach:
* **Unit Testing:** Independent testbenches for TX and RX. 
* **Self-Checking Scoreboard:** Automated verification comparing `dout` against expected `$urandom()` data.
* **Negative & Corner Case Testing:**
  * **Glitch Injection:** Sent a false start bit shorter than 7 clock ticks; verified that RX returns to IDLE without asserting `rx_done_tick`.
  * **Framing Error Injection:** Sent a logic '0' instead of a logic '1' for the stop bit; verified that `framing_error` flag is asserted.
* **System Integration (Loopback):** Simulated a closed-loop system connecting TX directly to RX. Implemented event-based synchronization (`wait(tx_busy == 1'b0)`) to replace hardcoded delays, preventing race conditions.

## 4. Simulation Results
C:\Users\ADMIN\Pictures\Screenshots\Ảnh chụp màn hình 2026-11-06 212540.png
C:\Users\ADMIN\Pictures\Screenshots\Ảnh chụp màn hình 2026-11-06 212753.png
C:\Users\ADMIN\Pictures\Screenshots\Ảnh chụp màn hình 2026-11-06 213010.png
C:\Users\ADMIN\Pictures\Screenshots\Ảnh chụp màn hình 2026-11-06 214414.png

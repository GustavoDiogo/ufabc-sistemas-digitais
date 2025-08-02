# Sequence Recognizer: Mealy and Moore FSMs on DE10-Lite (VHDL)

This project implements and compares **Mealy** and **Moore** finite state machines (FSMs) that detect the binary sequence `1101`, entirely written in **VHDL** and adapted for the **Intel DE10-Lite FPGA development board**.

## 🧠 Project Overview

- Input sequence: `1101`
- Output: Activates a signal and displays `"FOI"` (Portuguese for "TRIGGERED") when the sequence is recognized
- FSM Models: Mealy and Moore
- Visualization: 7-segment displays and LEDs
- Testbenches included: Mealy and Moore simulation with GHDL and GTKWave

## 🔧 Board Interface (DE10-Lite)

- `SW(0)`: Bit input (UP = 1, DOWN = 0)
- `KEY(0)`: Clock pulse (advance FSM state)
- `KEY(1)`: Reset (active low)
- `LEDR(0)`: Output signal when the sequence is detected
- `HEX Displays`:
  - `HEX3, HEX2, HEX1`: Show `"FOI"` upon sequence detection
  - `HEX1, HEX0`: Show current FSM state as `"S0"` to `"S4"`

## ▶️ Simulation

Simulate each design with [GHDL](https://ghdl.github.io/ghdl/) and [GTKWave](http://gtkwave.sourceforge.net/):

```bash
# Compile
ghdl -a --std=08 seq_rec.vhd
ghdl -a --std=08 tb_seq_rec_mealy.vhd

# Elaborate
ghdl -e --std=08 tb_seq_rec_mealy

# Run and dump waveform
ghdl -r --std=08 tb_seq_rec_mealy --vcd=mealy.vcd

# View
gtkwave mealy.vcd
```

Repeat similarly for `seq_rec_moore.vhd` and `tb_seq_rec_moore.vhd`.

## 📁 Files

- `seq_rec.vhd`: FSM Mealy implementation
- `seq_rec_moore.vhd`: FSM Moore implementation
- `seq_rec_mealy_quartus.vhd`: Quartus-specific Mealy implementation
- `seq_rec_moore_quartus.vhd`: Quartus-specific Moore implementation
- `tb_seq_rec_mealy.vhd`: Mealy testbench
- `tb_seq_rec_moore.vhd`: Moore testbench
- `README.md`: Project overview
- `*.qsf`: Quartus project setup (optional)

## 📷 Display Output Example

```
Before: S0 S1 S2 S3 ...
When Sequence 1101 is completed:
+-----------+-----------+-----------+
|   HEX3    |   HEX2    |   HEX1    |
|    F      |    O      |    I      |
+-----------+-----------+-----------+
```

## 🛠 Tools

- Quartus Prime Lite
- GHDL (VHDL simulator)
- GTKWave (waveform viewer)
- Target board: DE10-Lite (Intel/Altera)

## 💡 What You'll Learn

- FSM design and modeling in VHDL
- Simulation and debugging with GHDL + GTKWave
- Practical adaptation of FSMs to physical FPGA I/O
- Differences between Mealy and Moore in real hardware

---

> Created as part of a digital systems course project. All logic and hardware implementation done in VHDL.  

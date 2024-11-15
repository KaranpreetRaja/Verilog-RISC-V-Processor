# Verilog RISC-V Proccessor Project

This project implements a RISC-V processor using Verilog. The design includes core modules for the RISC-V instruction set and supports basic arithmetic, logic, and control flow instructions. This README provides setup instructions, an overview of the project files, and a guide for simulation.

## Project Overview

### Main Modules

- **`mux.v`**: A parameterized multiplexer module.
- **`adder.v`**: A parameterized multi-bit adder module.
- **`arithmeticUnit.v`**: The main arithmetic unit module that performs addition if `control = 0` and subtraction if `control = 1`.

### Features

- **Parameterized Design**: The modules are parameterized to allow flexibility in bit-width.
- **Modular Architecture**: Each function is encapsulated in its own module, which promotes reusability and readability.
- **Configurable Testbenches**: Testbenches are kept separate from the main modules and are specified during compilation for easier testing.

## Project Structure

The project contains the following files:

- `mux.v`: Multiplexer module.
- `adder.v`: Adder module.
- `arithmeticUnit.v`: Arithmetic unit module for addition and subtraction.
- `run_filelist.txt`: File containing the list of main module files, excluding any testbenches.

## Requirements

- **Icarus Verilog**: An open-source Verilog simulation tool.
- **GTKWave** (optional): A waveform viewer for visualizing simulation output.

## Getting Started

### Step 1: Clone the Repository

Clone this repository or download the project files into a local directory.

```bash
git clone https://github.com/KaranpreetRaja/Verilog-RISC-V-Processor.git
cd Verilog-RISC-V-Processor
```

### Step 2: Install Icarus Verilog
If you haven't installed Icarus Verilog, you can install it on most Unix-based systems with:

```bash
# For Ubuntu or Debian-based systems
sudo apt-get install iverilog

# For MacOS (using Homebrew)
brew install icarus-verilog
```

### Step 3: Setup run_filelist.txt
The `run_filelist.txt` file should list only the main modules you want to compile every time, without any testbench files.

## How to Run the Project

### Compiling the Project with a Testbench
Use the 'run_filelist.txt' to compile all the main modules and add the testbench file directly in the command. This approach allows you to change the testbench without modifying `run_filelist.txt`.

```bash
iverilog -c run_filelist.txt testbench_file_name.v
```

### Running the Simulation
After compiling, run the simulation with the following command:

```bash
vvp a.out
```

# ARM32 Mini Command-Line Shell

A minimal interactive command-line shell implemented entirely in **ARM32 Assembly** for the **CO1020 – Computer Systems Programming** course at the **Department of Computer Engineering, University of Peradeniya**.

## 📌 Overview

This project implements a functional command-line shell using **ARM32 Assembly Language**. The shell continuously accepts user input, identifies commands, executes the corresponding functionality, and returns to the prompt until the user exits.

The project demonstrates fundamental low-level programming concepts including **system calls, memory management, string processing, command parsing, stack operations, register preservation, and error handling**.

## ✨ Features

- Interactive `shell>` command prompt
- Manual command parsing using string comparison
- Direct Linux ARM32 system calls
- 256-byte input buffer
- Input sanitization and newline removal
- Stack-based register preservation
- Error handling for invalid commands and arguments
- Decimal-to-hexadecimal conversion
- Average calculation for multiple numbers
- Tested using QEMU in an ARM32 Linux environment

## 💻 Supported Commands

| Command | Description |
|---------|-------------|
| `hello` | Prints `Hello World!` |
| `help` | Displays all available commands and usage information |
| `clear` | Clears the terminal screen |
| `exit` | Terminates the shell |
| `hex <number>` | Converts a decimal number to hexadecimal |
| `avg <n1> <n2> ...` | Calculates the arithmetic average of multiple numbers |

The four basic commands and the two custom commands `hex` and `avg` are the commands implemented in our project. :chatgpt-content-reference{index="0"}

## 🔢 Custom Commands

### `hex <number>`

Converts a decimal integer into its hexadecimal representation.

Example:

```text
shell> hex 16
0x10
```

The implementation performs:

- Command-line argument parsing
- ASCII-to-integer conversion
- Bit shifting and nibble extraction
- Hexadecimal character conversion
- Input validation and error handling

### `avg <n1> <n2> ...`

Calculates the arithmetic average of multiple space-separated numbers.

Example:

```text
shell> avg 18 18 18 18
Average: 18
```

The implementation parses multiple numbers, maintains a running sum and count, and performs integer division to calculate the result. :chatgpt-content-reference{index="1"}

## 🏗️ Project Architecture

The program follows the standard ARM32 Assembly memory structure.

### `.data`

Contains:

- Command strings
- Shell prompt
- Help messages
- Error messages
- ANSI escape sequences

### `.bss`

Contains runtime storage including:

- 256-byte user input buffer
- 64-byte temporary number-conversion buffer

### `.text`

Contains:

- Main executable code
- Shell loop
- Command handlers
- System-call routines
- Helper functions

## 🔄 Program Flow

```text
_start
   |
   v
Display "shell>" prompt
   |
   v
Read user input
   |
   v
Remove newline
   |
   v
Parse command
   |
   +----> hello
   +----> help
   +----> clear
   +----> hex
   +----> avg
   +----> exit
   |
   v
Execute command
   |
   v
Return to shell loop
```

The shell continues this process until the `exit` command is executed. :chatgpt-content-reference{index="2"}

## ⚙️ Technical Concepts

This project demonstrates:

- ARM32 Assembly programming
- Linux system calls
- Register management
- Stack operations
- Conditional branching
- String comparison
- Command parsing
- Manual memory management
- ASCII-to-integer conversion
- Integer-to-hexadecimal conversion
- Input validation
- Error handling
- Modular function design

## 🖥️ Linux System Calls

The shell directly interacts with Linux using ARM32 system calls.

| System Call | Number | Purpose |
|-------------|-------:|---------|
| `read` | 3 | Read user input |
| `write` | 4 | Display output |
| `exit` | 1 | Terminate the program |

The system call number is placed in register `r7`, while `r0-r2` contain the required arguments. :chatgpt-content-reference{index="3"}

## 🧪 Testing

The shell was tested using **QEMU with an ARM32 Linux environment**.

Testing included:

- Shell startup and loop behavior
- Basic command execution
- Custom command execution
- Decimal-to-hexadecimal conversion
- Average calculations
- Empty input handling
- Repeated command execution
- Register and stack stability
- Error handling

Testing confirmed that the shell remained responsive and stable during repeated command execution. :chatgpt-content-reference{index="4"} :chatgpt-content-reference{index="5"}

## 📁 Project Structure

```text
ARM32-Mini-Command-Line-Shell/
│
├── shell.s
└── README.md
```

## 👥 Team

**Group 83**

- **H.M.H.N. Abeyrathna** — E/22/001
- **M.A.N.P. Anawarathne** — E/22/027

Both team members contributed collaboratively to the design, implementation, testing, and debugging of the ARM32 shell.

## 👩‍💻 My Contribution

I contributed to the **core design and implementation** of the ARM32 command-line shell, including:

- Base shell architecture
- Memory section setup
- System-call integration
- Input handling
- Main shell control flow
- Command logic and command handlers
- Testing and debugging using QEMU
- Research and technical analysis for project documentation
- Screen recording for the project presentation

The coding, testing, and debugging were carried out collaboratively by both team members. :chatgpt-content-reference{index="6"}

## 🎓 Course Information

- **Course:** CO1020 – Computer Systems Programming
- **Department:** Department of Computer Engineering
- **University:** University of Peradeniya
- **Project:** ARM32 Mini Command-Line Shell
- **Group:** 83
- **Language:** ARM32 Assembly
- **Year:** 2025

## 📚 Key Learning Outcomes

Through this project, we gained practical experience in:

- Low-level programming
- ARM architecture
- Linux system calls
- Memory and register management
- Stack handling
- Command parsing
- Assembly-level debugging
- Building software without high-level language abstractions

## 📄 License

This repository contains academic coursework and is shared for **educational and portfolio purposes**.

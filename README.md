ARM32 Mini Command-Line Shell
A minimal interactive command-line shell implemented entirely in ARM32 Assembly for the CO1020 – Computer Systems Programming course at the Department of Computer Engineering, University of Peradeniya.
Overview
This project demonstrates low-level programming concepts by building a functional command-line interface without relying on high-level languages or standard libraries. The shell continuously accepts user input, parses commands, executes the corresponding routines, and returns to the prompt until the user exits.
The implementation focuses on ARM32 system calls, manual memory management, string processing, command parsing, stack discipline, register preservation, and error handling.
Features
- Continuous interactive shell> prompt
- Manual command parsing using string comparison
- Direct Linux ARM32 system calls for input/output and program termination
- 256-byte input buffer
- Newline removal and null termination
- Stack-based register preservation
- Unknown-command and missing-argument handling
- Custom numerical processing
- Tested using QEMU in an ARM32 Linux environment
Supported Commands
Command	Description
hello	Prints Hello World!
help	Displays the available commands and usage information
clear	Clears the terminal using ANSI escape sequences
exit	Exits the shell gracefully
hex <number>	Converts a decimal integer to hexadecimal
avg <n1> <n2> ...	Calculates the integer arithmetic average of multiple numbers


Custom Commands
hex <number>
Converts a decimal number to hexadecimal representation.
Example:
shell> hex 16
0x10
The implementation includes command-line argument parsing, ASCII-to-integer conversion, nibble extraction using bit shifting, hexadecimal character conversion, and validation for missing or invalid arguments.
avg <n1> <n2> ...
Calculates the arithmetic average of multiple space-separated numbers.
Example:
shell> avg 18 18 18 18
Average: 18
The command parses multiple numerical arguments, maintains a running sum and count, and performs safe integer division.
Project Architecture
The program is organized using the standard ARM32 assembly sections:
- .data – command strings, prompts, messages, constants, and ANSI escape sequences
- .bss – uninitialized runtime storage, including the 256-byte input buffer and temporary number-conversion buffer
- .text – executable code, shell loop, command handlers, system-call routines, and helper functions
Program Flow
_start
   |
   v
Display "shell>" prompt
   |
   v
Read user input
   |
   v
Remove newline / sanitize input
   |
   v
Parse command using string comparison
   |
   +--> hello
   +--> help
   +--> clear
   +--> hex
   +--> avg
   +--> exit
   |
   v
Execute matching handler
   |
   v
Return to shell loop
Low-Level Concepts Demonstrated
- ARM32 Assembly programming
- Linux system calls via SWI
- Register management
- Stack operations
- Conditional branching
- String comparison and parsing
- Manual buffer management
- ASCII-to-integer conversion
- Integer-to-hexadecimal conversion
- Arithmetic operations
- Modular function design
- Input validation and error handling
System Calls
The shell interacts directly with Linux ARM32 system calls:
System Call	Number	Purpose
read	3	Read user input
write	4	Print output
exit	1	Terminate the shell


The system call number is placed in r7, while r0-r2 contain the required arguments.
Testing
The shell was tested using QEMU with an ARM32 Linux environment. Testing covered:
- Shell startup and continuous loop behavior
- All four basic commands
- hex conversion and argument handling
- avg calculations with multiple inputs
- Empty input handling
- Repeated command execution
- Register and stack stability
- Error handling
Project Structure
ARM32-Mini-Command-Line-Shell/
├── shell.s
└── README.md
Team
Group 83
- H.M.H.N. Abeyrathna — E/22/001
- M.A.N.P. Anawarathne — E/22/027
Both team members contributed collaboratively to the design, coding, testing, and debugging of the ARM32 shell.
My Contribution
I contributed to the core implementation of the shell, including the base architecture, system-call integration, input handling, command logic, and command handlers. I also participated in testing and debugging the program using QEMU. For the project documentation, I contributed to researching and analyzing the technical material, and I handled screen recording for the project presentation.
Course Information
- Course: CO1020 – Computer Systems Programming
- Department: Department of Computer Engineering
- University: University of Peradeniya
- Project Type: Pair/Group Project
- Language: ARM32 Assembly
- Year: 2025
Key Learning Outcomes
This project strengthened our understanding of low-level programming, ARM architecture, direct operating-system interaction, memory and register management, command parsing, debugging, and building software without high-level abstractions.
License
This repository contains academic coursework and is shared for educational and portfolio purposes.

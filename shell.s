.data
    prompt:     .ascii "shell> "        @ Command prompt
    prompt_len = . - prompt
    
    newline:    .ascii "\n"             @ Newline character
    newline_len = . - newline
    
    hello_msg:  .ascii "Hello World!\n"
    hello_len = . - hello_msg
    
    help_msg:   .ascii "Available commands:\n  hello - Prints Hello World!\n  help  -Lists all commands available in shell \n  clear - Clear the shell screen\n  hex   - Convert decimal to hexadecimal (usage: hex <number>)\n  avg   - Calculate average of numbers (usage: avg <num1> <num2> ... <numN>)\n  exit  - Terminates the shell\n"
    help_len = . - help_msg
    
    exit_msg:   .ascii "Goodbye! Shell terminated.\n"
    exit_len = . - exit_msg
    
    clear_seq:  .ascii "\033[2J\033[H"  @ ANSI escape sequence to clear screen
    clear_len = . - clear_seq
    
    unknown_msg: .ascii "Unknown command. Type 'help' for available commands.\n"
    unknown_len = . - unknown_msg
    
    hex_prefix: .ascii "0x"
    hex_prefix_len = . - hex_prefix
    
    calc_result: .ascii "Average: "
    calc_result_len = . - calc_result
    
    error_msg:  .ascii "Error: Invalid input or operation\n"
    error_len = . - error_msg
    
    @ Command strings for comparison
    cmd_hello:  .ascii "hello"
    cmd_help:   .ascii "help"
    cmd_exit:   .ascii "exit"
    cmd_clear:  .ascii "clear"
    cmd_hex:    .ascii "hex"
    cmd_avg:    .ascii "avg"

.bss
    input_buffer:   .space 256     @ Buffer for user input
    temp_buffer:    .space 64      @ Temporary buffer for number conversion
    
.text
.global _start

_start:

main:
    @ Main shell loop
shell_loop:
    @ Print prompt
    mov r7, #4              @ sys_write
    mov r0, #1              @ stdout
    ldr r1, =prompt         @ prompt string
    mov r2, #prompt_len     @ length
    swi 0                   @ system call
    
    @ Read user input
    mov r7, #3              @ sys_read
    mov r0, #0              @ stdin
    ldr r1, =input_buffer   @ input buffer
    mov r2, #255            @ max bytes to read
    swi 0                   @ system call
    
    @ Remove newline from input
    ldr r1, =input_buffer
    bl remove_newline
    
    @ Parse and execute command
    ldr r0, =input_buffer
    bl parse_command
    
    @ Continue shell loop
    b shell_loop

@ Function to remove newline character from input
remove_newline:
    push {r0, r2, r3, lr}
    mov r0, r1              @ string address
    mov r2, #0              @ counter
    
remove_loop:
    ldrb r3, [r0, r2]       @ load byte
    cmp r3, #10             @ check for newline (ASCII 10)
    beq found_newline
    cmp r3, #0              @ check for null terminator
    beq remove_done
    add r2, r2, #1          @ increment counter
    b remove_loop
    
found_newline:
    mov r3, #0              @ null terminator
    strb r3, [r0, r2]       @ replace newline with null
    
remove_done:
    pop {r0, r2, r3, lr}
    bx lr

@ Function to parse and execute commands
parse_command:
    push {r1, r2, r3, lr}
    
    @ Check if empty command
    ldrb r1, [r0]
    cmp r1, #0
    beq parse_done
    
    @ Check for "hello" command
    ldr r1, =cmd_hello
    mov r2, #5              @ length of "hello"
    bl string_compare
    cmp r0, #1
    beq cmd_hello_handler
    
    @ Check for "help" command
    ldr r0, =input_buffer
    ldr r1, =cmd_help
    mov r2, #4              @ length of "help"
    bl string_compare
    cmp r0, #1
    beq cmd_help_handler
    
    @ Check for "exit" command
    ldr r0, =input_buffer
    ldr r1, =cmd_exit
    mov r2, #4              @ length of "exit"
    bl string_compare
    cmp r0, #1
    beq cmd_exit_handler
    
    @ Check for "clear" command
    ldr r0, =input_buffer
    ldr r1, =cmd_clear
    mov r2, #5              @ length of "clear"
    bl string_compare
    cmp r0, #1
    beq cmd_clear_handler
    
    @ Check for "hex" command
    ldr r0, =input_buffer
    ldr r1, =cmd_hex
    mov r2, #3              @ length of "hex"
    bl string_compare
    cmp r0, #1
    beq cmd_hex_handler
    
    @ Check for "avg" command
    ldr r0, =input_buffer
    ldr r1, =cmd_avg
    mov r2, #3              @ length of "avg"
    bl string_compare
    cmp r0, #1
    beq cmd_avg_handler
    
    @ Unknown command
    mov r7, #4
    mov r0, #1
    ldr r1, =unknown_msg
    mov r2, #unknown_len
    swi 0
    
parse_done:
    pop {r1, r2, r3, lr}
    bx lr

@ String comparison function
@ r0 = string1, r1 = string2, r2 = length
@ Returns 1 in r0 if equal, 0 if not equal
string_compare:
    push {r1, r2, r3, r4, lr}
    mov r3, #0              @ counter
    
compare_loop:
    cmp r3, r2              @ check if we've compared all characters
    beq strings_equal
    
    ldrb r4, [r0, r3]       @ load byte from string1
    ldrb r5, [r1, r3]       @ load byte from string2
    cmp r4, r5              @ compare bytes
    bne strings_not_equal
    
    add r3, r3, #1          @ increment counter
    b compare_loop
    
strings_equal:
    mov r0, #1              @ return 1 (equal)
    b compare_done
    
strings_not_equal:
    mov r0, #0              @ return 0 (not equal)
    
compare_done:
    pop {r1, r2, r3, r4, lr}
    bx lr

@ Command handlers
cmd_hello_handler:
    push {r0, r1, r2, r7, lr}
    mov r7, #4
    mov r0, #1
    ldr r1, =hello_msg
    mov r2, #hello_len
    swi 0
    pop {r0, r1, r2, r7, lr}
    b parse_done

cmd_help_handler:
    push {r0, r1, r2, r7, lr}
    mov r7, #4
    mov r0, #1
    ldr r1, =help_msg
    mov r2, #help_len
    swi 0
    pop {r0, r1, r2, r7, lr}
    b parse_done

cmd_clear_handler:
    push {r0, r1, r2, r7, lr}
    mov r7, #4
    mov r0, #1
    ldr r1, =clear_seq
    mov r2, #clear_len
    swi 0
    pop {r0, r1, r2, r7, lr}
    b parse_done

cmd_exit_handler:
    push {r0, r1, r2, r7, lr}
    mov r7, #4
    mov r0, #1
    ldr r1, =exit_msg
    mov r2, #exit_len
    swi 0
    mov r7, #1              @ sys_exit
    mov r0, #0              @ exit status
    swi 0

cmd_hex_handler:
    push {r0, r1, r2, r3, r4, r5, r7, lr}
    
    @ Skip "hex " to get to the number
    ldr r0, =input_buffer
    add r0, r0, #4          @ skip "hex "
    
    @ Skip any spaces after "hex"
    bl skip_spaces_inline
    
    @ Convert string to integer
    bl string_to_int
    mov r3, r0              @ store number in r3
    
    @ Print "0x" prefix
    mov r7, #4
    mov r0, #1
    ldr r1, =hex_prefix
    mov r2, #hex_prefix_len
    swi 0
    
    @ Convert number to hexadecimal and print
    mov r0, r3
    bl print_hex
    
    @ Print newline
    mov r7, #4
    mov r0, #1
    ldr r1, =newline
    mov r2, #newline_len
    swi 0
    
    pop {r0, r1, r2, r3, r4, r5, r7, lr}
    b parse_done

cmd_avg_handler:
    push {r0, r1, r2, r3, r4, r5, r6, r7, lr}
    
    @ Parse: avg <num1> <num2> ... <numN>
    ldr r6, =input_buffer
    add r6, r6, #4          @ skip "avg "
    
    @ Initialize counters
    mov r4, #0              @ sum
    mov r5, #0              @ count
    
avg_parse_loop:
    @ Skip spaces
    mov r0, r6
    bl skip_spaces_inline
    mov r6, r0              @ update pointer
    
    @ Check if we've reached the end
    ldrb r1, [r6]
    cmp r1, #0
    beq avg_calculate
    cmp r1, #10             @ check for newline
    beq avg_calculate
    
    @ Parse next number
    mov r0, r6
    bl string_to_int_simple
    add r4, r4, r0          @ add to sum
    add r5, r5, #1          @ increment count
    
    @ Skip to next space or end
    mov r0, r6
    bl skip_to_space_or_end
    mov r6, r0              @ update pointer
    b avg_parse_loop
    
avg_calculate:
    @ Check if we have any numbers
    cmp r5, #0
    beq avg_error
    
    @ Calculate average (sum / count)
    mov r0, r4              @ sum
    mov r1, r5              @ count
    bl divide_simple
    mov r3, r0              @ store average
    
    @ Print "Average: "
    mov r7, #4
    mov r0, #1
    ldr r1, =calc_result
    mov r2, #calc_result_len
    swi 0
    
    @ Print average
    mov r0, r3
    bl print_decimal
    
    @ Print newline
    mov r7, #4
    mov r0, #1
    ldr r1, =newline
    mov r2, #newline_len
    swi 0
    
    b avg_done
    
avg_error:
    @ Print error message
    mov r7, #4
    mov r0, #1
    ldr r1, =error_msg
    mov r2, #error_len
    swi 0
    
avg_done:
    pop {r0, r1, r2, r3, r4, r5, r6, r7, lr}
    b parse_done

@ Convert string to integer
@ r0 = string address, returns integer in r0
string_to_int:
    push {r1, r2, r3, lr}
    mov r1, #0              @ result
    mov r2, #10             @ base 10
    
convert_loop:
    ldrb r3, [r0], #1       @ load character and increment pointer
    cmp r3, #0              @ check for null terminator
    beq convert_done
    cmp r3, #' '            @ check for space (end of number)
    beq convert_done
    cmp r3, #'0'            @ check if digit
    blt convert_done
    cmp r3, #'9'
    bgt convert_done
    
    sub r3, r3, #'0'        @ convert ASCII to digit
    mul r4, r1, r2          @ multiply result by 10
    mov r1, r4              @ store back to r1
    add r1, r1, r3          @ add digit
    b convert_loop
    
convert_done:
    mov r0, r1              @ return result
    pop {r1, r2, r3, lr}
    bx lr

@ Print hexadecimal number (fixed version)
@ r0 = number to print
print_hex:
    push {r0, r1, r2, r3, r4, r5, r7, lr}
    ldr r1, =temp_buffer
    mov r2, #0              @ digit counter
    mov r4, r0              @ preserve original number
    
    @ Handle zero case
    cmp r4, #0
    bne hex_convert_start
    mov r3, #'0'
    strb r3, [r1, r2]
    add r2, r2, #1
    b hex_print_digits
    
hex_convert_start:
    mov r0, r4              @ restore number for conversion
hex_convert_loop:
    cmp r0, #0
    beq hex_print_digits
    
    and r3, r0, #15         @ get last 4 bits
    cmp r3, #10
    blt hex_digit
    add r3, r3, #'A' - 10   @ convert to A-F
    b hex_store
hex_digit:
    add r3, r3, #'0'        @ convert to 0-9
hex_store:
    strb r3, [r1, r2]
    add r2, r2, #1
    lsr r0, r0, #4          @ shift right by 4 bits
    b hex_convert_loop
    
hex_print_digits:
    @ Print digits in reverse order
    cmp r2, #0
    beq hex_print_done
    sub r2, r2, #1
hex_print_loop:
    ldrb r3, [r1, r2]
    ldr r5, =temp_buffer
    add r5, r5, #32         @ use different part of buffer
    strb r3, [r5]
    
    mov r7, #4
    mov r0, #1
    mov r1, r5
    push {r2}
    mov r2, #1
    swi 0
    pop {r2}
    
    ldr r1, =temp_buffer
    cmp r2, #0
    beq hex_print_done
    sub r2, r2, #1
    b hex_print_loop
    
hex_print_done:
    pop {r0, r1, r2, r3, r4, r5, r7, lr}
    bx lr

@ Convert string to integer (simple version for avg)
@ r0 = string address, returns integer in r0 but doesn't modify r0 pointer
string_to_int_simple:
    push {r1, r2, r3, r4, r5, lr}
    mov r1, #0              @ result
    mov r2, #10             @ base 10
    mov r5, r0              @ preserve original pointer
    
convert_simple_loop:
    ldrb r3, [r5]           @ load character
    cmp r3, #0              @ check for null terminator
    beq convert_simple_done
    cmp r3, #' '            @ check for space
    beq convert_simple_done
    cmp r3, #10             @ check for newline
    beq convert_simple_done
    cmp r3, #'0'            @ check if digit
    blt convert_simple_done
    cmp r3, #'9'
    bgt convert_simple_done
    
    sub r3, r3, #'0'        @ convert ASCII to digit
    mul r4, r1, r2          @ multiply result by 10
    mov r1, r4              @ store back to r1
    add r1, r1, r3          @ add digit
    add r5, r5, #1          @ increment pointer
    b convert_simple_loop
    
convert_simple_done:
    mov r0, r1              @ return result in r0
    pop {r1, r2, r3, r4, r5, lr}
    bx lr

@ Simple division for positive numbers
@ r0 = dividend, r1 = divisor
@ Returns quotient in r0
divide_simple:
    push {r1, r2, r3, r4, lr}
    mov r2, #0              @ quotient
    mov r3, r0              @ dividend copy
    mov r4, r1              @ divisor copy
    
    @ Check for division by zero
    cmp r4, #0
    beq divide_simple_error
    
divide_simple_loop:
    cmp r3, r4
    blt divide_simple_done
    sub r3, r3, r4
    add r2, r2, #1
    b divide_simple_loop
    
divide_simple_done:
    mov r0, r2              @ return quotient
    pop {r1, r2, r3, r4, lr}
    bx lr

divide_simple_error:
    mov r0, #0              @ return 0 for division by zero
    pop {r1, r2, r3, r4, lr}
    bx lr


@ Skip spaces in string (inline version that modifies r0)
skip_spaces_inline:
    push {r1, lr}
skip_spaces_loop:
    ldrb r1, [r0]
    cmp r1, #' '
    bne skip_spaces_done
    add r0, r0, #1
    b skip_spaces_loop
skip_spaces_done:
    pop {r1, lr}
    bx lr

@ Skip to next space or end of string
skip_to_space_or_end:
    push {r1, lr}
skip_to_space_loop:
    ldrb r1, [r0]
    cmp r1, #0              @ end of string
    beq skip_to_space_done
    cmp r1, #' '            @ space
    beq skip_to_space_done
    cmp r1, #10             @ newline
    beq skip_to_space_done
    add r0, r0, #1
    b skip_to_space_loop
skip_to_space_done:
    pop {r1, lr}
    bx lr

@ Print decimal number (fixed version)
@ r0 = number to print
print_decimal:
    push {r0, r1, r2, r3, r4, r5, r7, lr}
    ldr r1, =temp_buffer
    mov r2, #0              @ digit counter
    mov r4, r0              @ preserve original number
    
    @ Handle zero case
    cmp r4, #0
    bne dec_convert_start
    mov r3, #'0'
    strb r3, [r1, r2]
    add r2, r2, #1
    b dec_print_digits
    
dec_convert_start:
    mov r0, r4              @ restore number for conversion
dec_convert_loop:
    cmp r0, #0
    beq dec_print_digits
    
    mov r5, #10
    bl divide               @ divide r0 by 10, quotient in r0, remainder in r1
    add r3, r1, #'0'        @ convert remainder to ASCII
    ldr r1, =temp_buffer    @ restore buffer pointer
    strb r3, [r1, r2]
    add r2, r2, #1
    b dec_convert_loop
    
dec_print_digits:
    @ Print digits in reverse order
    cmp r2, #0
    beq dec_print_done
    sub r2, r2, #1
dec_print_loop:
    ldr r1, =temp_buffer
    ldrb r3, [r1, r2]
    ldr r5, =temp_buffer
    add r5, r5, #32         @ use different part of buffer
    strb r3, [r5]
    
    mov r7, #4
    mov r0, #1
    mov r1, r5
    push {r2}
    mov r2, #1
    swi 0
    pop {r2}
    
    cmp r2, #0
    beq dec_print_done
    sub r2, r2, #1
    b dec_print_loop
    
dec_print_done:
    pop {r0, r1, r2, r3, r4, r5, r7, lr}
    bx lr

@ Simple division function (fixed version)
@ r0 = dividend, r5 = divisor
@ Returns quotient in r0, remainder in r1
divide:
    push {r2, r3, r4, lr}
    mov r2, #0              @ quotient
    mov r3, r0              @ dividend copy
    mov r4, r5              @ divisor
    
div_loop:
    cmp r3, r4
    blt div_done
    sub r3, r3, r4
    add r2, r2, #1
    b div_loop
    
div_done:
    mov r0, r2              @ quotient
    mov r1, r3              @ remainder
    pop {r2, r3, r4, lr}
    bx lr
.text
.global _start
.intel_syntax noprefix

_start:
    mov rdi, 0x0      # file descriptor = stdin = 0
    lea rsi, [rsp+8]  # buffer = address to store the bytes read
    mov rdx, 0x2      # number of bytes to read
    mov rax, 0x0      # SYSCALL number for reading from STDIN
    syscall           # make the syscall

    xor rax, rax      # clear off rax
    mov rbx, [rsp+8]  # read the first byte read into rsp+8 by STDIN call to rbp
    sub rbx, 0x30     # Since this is read as a character, it is obtained as ASCII value, so subtract by 0x30 to get the number
    and rbx, 0xff     # This ensures that everything other than the last byte is set to 0 while the last byte is as is
    mov rax, rbx      # move this value to rax since we want to store the final result in rax
    shl rbx, 0x1      # We need to multiply this by 10 so that we can add up all the digits read so multiplying the number by 2 and then by 8 and adding them up, so multiply by 2 here
    shl rax, 0x3      # multiply by 8 here
    add rax, rbx      # add 8 times multiplied value with 2 times multiplied value to get 10 times multiplied value
    mov rbx, [rsp+9]  # now read the next byte (or digit)
    sub rbx, 0x30     # Again get the digit value from ASCII value of that digit's character
    and rbx, 0xff     # clear higher bytes
    add rax, rbx      # Add this to rax as unit's place value
    mov [rsp+8], rax  # Move the entire byte to rax
    mov rdi, 0x1      # file descriptor = stdout
    lea rsi, [rsp+8]  # buffer = address to write to console
    mov rdx, 0x1      # number of bytes to write
    mov rax, 0x1      # SYSCALL number for writing to STDOUT
    syscall           # make the syscall

    xor rax, rax      # clear off rax
    mov rax, 0xa      # move the new line character to rax
    mov [rsp+8], rax  # put this on the stack
    mov rdi, 0x1      # file descriptor = stdout
    lea rsi, [rsp+8]  # buffer = address to write to console
    mov rdx, 0x1      # number of bytes to write
    mov rax, 0x1      # SYSCALL number for writing to STDOUT
    syscall           # make the syscall

    mov rdi, 0        # set exit status = 0
    mov rax, 60       # SYSCALL number for EXIT
    syscall           # make the syscall

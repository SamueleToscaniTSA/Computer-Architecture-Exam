#-------------------TS PRINT SIGNED NUMBERS----------------#

#--------print signed numbers and carriage function--------#
# the function uses:
#   - argument register:
#       - a0: number to print
#   - temporary register t0, t1, t2, t3
#   - global symbol appPrint, carriage, plusPrint, minusPrint

#-----------constant-----------#
.global _start
    # system code interrupt
    .equ _SYS_WR, 64
    # constant
    .equ asciiOffset, 48

#-----------global symbol-----------#
.section .data
    appPrint: .byte '!'

.section .rodata
    carriage: .byte '\n'
    plusPrint: .byte '+'
    minusPrint: .byte '-'

#-----------code-----------#
.section .text

#--------print function--------#
print:
    li a0, 0        # code terminal
    # la a1, string
    # li a2, length
    li a7, _SYS_WR  # interrupt code
    ecall           # system call
    jr ra

# function to print signed numbers and final carriage
printSignedNumbersAndCarriage:
    addi sp, sp, -8
    sd ra, 0(sp)
    jal printSign
    jal printNumbers
    jal printCarriage
    ld ra, 0(sp)
    addi sp, sp, 8
    jr ra

# function that only print sign
printSign:
    bge a0, zero, major
        la a1, minusPrint
        sub a0, zero, a0
        beq zero, zero, sign
    major:
        la a1, plusPrint
    sign:
    li a2, 1
    addi sp, sp, -16
    sd ra, 0(sp)
    sd a0, 8(sp)
    jal print
    ld ra, 0(sp)
    ld a0, 8(sp)
    addi sp, sp, 16
    jr ra

# function that only print numbers
printNumbers:
    li t0, 10
    div t1, a0, t0
    mul t2, t1, t0
    sub t3, a0, t2
    addi sp, sp, -16
    sd ra, 0(sp)
    sd t3, 8(sp)
    blt t2, t0, exitPrintNumbers
        mv a0, t1
        jal printNumbers
    exitPrintNumbers:
        ld t0, 8(sp)
        addi t0, t0, asciiOffset
        la a1, appPrint
        sb t0, 0(a1)
        jal print
        ld ra, 0(sp)
        addi sp, sp, 16
        jr ra

# function that only print carriage
printCarriage:
    li a0, 0
    la a1, carriage
    li a2, 1
    li a7, _SYS_WR
    ecall
    jr ra

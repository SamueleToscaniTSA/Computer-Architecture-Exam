#-------------------TS SCAN SIGNED NUMBERS----------------#

#--------scan signed numbers and carriage function--------#
# the function uses:
#   - argument register:
#       - a0: address variable to allocate scan number
#   - temporary register t0, t1, t2, t3, t4, t5, t6, s0
#   - global symbol appScan, plusScan, minusScan

#-----------constant-----------#
.global _start
    # system code interrupt
    .equ _SYS_SC, 63
    # constant
    .equ asciiOffset, 48

#-----------global symbol-----------#
.section .data
    appScan: .byte '!', '!', '!', '!', '!'

.section .rodata
    plusScan: .byte '+'
    minusScan: .byte '-'

#-----------code-----------#
.section .text

#--------scan function--------#
scan:
    li a0, 0        # code terminal
    # la a1, string
    # li a2, length
    li a7, _SYS_SC  # interrupt code
    ecall           # system call
    jr ra

# function to print numbers and final carriage
scanSignedNumbersTilCarriage:
    addi sp, sp, -16
    sd ra, 0(sp)
    sd s0, 8(sp)
    mv s0, a0
    la a1, appScan
    li a2, 5
    jal scan
    jal scanNumbers
    ld ra, 0(sp)
    ld s0, 8(sp)
    addi sp, sp, 16
    jr ra

#--------scannumbers function--------#
scanNumbers:
    addi t3, a1, 1
    li t2, 0
    #--------forscannumbers--------#
    li t0, 0
    forScanNumbers:
        # user code
        lb t4, 0(t3)
        addi t4, t4, -asciiOffset
        addi t3, t3, 1
        li t5, 100
        li t6, 10
        #--------forpot--------#
        li t1, 0
        forPot:
            # user code
            beq t1, zero, pot0
                div t5, t5, t6
            pot0:
        # condition exit
        addi t1, t1, 1
        ble t1, t0, forPot
        mul t4, t4, t5
        add t2, t2, t4
    # condition exit
    li t4, 3
    addi t0, t0, 1
    blt t0, t4, forScanNumbers
    la t1, plusScan
    lb t1, 0(t1)
    lb t0, 0(a1)
    beq t0, t1, nop
        sub t2, zero, t2
    nop:
    sb t2, 0(s0)
    jr ra

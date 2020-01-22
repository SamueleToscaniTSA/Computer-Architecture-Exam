#-------------------PROGRAM TO CHECK SCAN AND PRINT FUNCTION FOR NUMBERS FROM TERMINAL----------------#

#-----------NUMBER AND MNEMONIC NAME REGISTER RISCV-----------#
# x0 -x4  #  zero, ra, sp, gp, tp
# x5 -x7  #  t0, t1, t2
# x8 -x9  #  fp/s0, s1
# x10-x17 #  a0, a1, a2, a3, a4, a5, a6, a7
# x18-x27 #  s2, s3, s4, s5, s6, s7, s8, s9, s10, s11
# x28-x31 #  t3, t4, t5, t6

#-------------------MODULE----------------#
.include "tsPrint.s"
.include "tsScan.s"
.include "mulConstVect.s"

#-----------constant-----------#
.global _start
    # system code interrupt
    .equ _SYS_EX, 93
    # constant

#-----------global symbol-----------#
.section .data
    vect: .space 4      # space to allocate 4 byte
    const: .byte 1        # multiplier setted 1
    res: .space 16      # space to allocate 16 byte

.section .rodata
    # message for terminal
    inVect: .string "Insert 4 numbers:\n"
    inConst: .string "Insert 1 multiplier:\n"
    outRes: .string "Result of operation is:\n"

#-----------code-----------#
.section .text

#--------main program--------#
_start:
    # call to print function for message
    la a1, inVect
    li a2, 18
    jal print

    # scan number input and allocate in data vector
    la s1, vect     # address of data vector
    #--------forscan--------#
    li s0, 0        # index for cycle
    forscan:
        # user code
        # prepare calling to function
        mv a0, s1
        jal scanSignedNumbersTilCarriage

        addi s1, s1, 1  # increment byte pointer
    # condition exit
    li t0, 4
    addi s0, s0, 1
    blt s0, t0, forscan

    jal printCarriage   # print one line empty



    # call to print function for message
    la a1, inConst
    li a2, 21
    jal print

    # scan number input and allocate in var multiplier
    # prepare calling to function
    la a0, const
    jal scanSignedNumbersTilCarriage
    
    jal printCarriage   # print one line empty



    # call to print function for message
    la a1, outRes
    li a2, 25
    jal print

    # operation on number and allocate in res vector
    # prepare calling to function
    la a0, res
    la a1, vect
    la a2, const
    li a3, 4
    jal MCV

    # print signed numbers and carriage function
    la s1, res      # address of data vector
    #--------forprint--------#
    li s0, 0        # index for cycle
    forprint:
        # user code
        # prepare calling to function
        lw a0, 0(s1)
        jal ra, printSignedNumbersAndCarriage

        addi s1, s1, 4  # increment word pointer
    # condition exit
    li t0, 4
    addi s0, s0, 1
    blt s0, t0, forprint
    
_end:
li a7, _SYS_EX
ecall

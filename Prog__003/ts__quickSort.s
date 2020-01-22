#-------------------PROGRAM TO ORDER WITH QUICK SORT ALGORITHM, NUMBERS FROM TERMINAL MONITOR----------------#

#-----------NUMBER AND MNEMONIC NAME REGISTER RISCV-----------#
# x0 -x4  #  zero, ra, sp, gp, tp
# x5 -x7  #  t0, t1, t2
# x8 -x9  #  fp/s0, s1
# x10-x17 #  a0, a1, a2, a3, a4, a5, a6, a7
# x18-x27 #  s2, s3, s4, s5, s6, s7, s8, s9, s10, s11
# x28-x31 #  t3, t4, t5, t6

#-------------------MODULE----------------#
.include "tsScan.s"
.include "tsPrint.s"
.include "tsQuickSort.s"

#-----------constant-----------#
.global _start
    # system code interrupt
    .equ _SYS_EX, 93
    # constant

#-----------global symbol-----------#
.section .data
    vector: .space 64

.section .rodata
    # message for terminal
    inVect: .string "Insert 8 numbers:\n"
    outVect: .string "Quick sort on vector:\n"

#-----------code-----------#
.section .text

#--------main program--------#
_start:
    # call to print function for message
    la a1, inVect
    li a2, 18
    jal print

    # scan number input and allocate in data vector
    la s1, vector     # address of vector
    #--------forscan--------#
    li s0, 0        # index for cycle
    forscan:
        # user code
        # prepare calling to function
        mv a0, s1
        jal scanSignedNumbersTilCarriage

        addi s1, s1, 8  # increment byte pointer
    # condition exit
    li t0, 8
    addi s0, s0, 1
    blt s0, t0, forscan

    jal printCarriage   # print one line empty


    # call to quick sort function to order vector 
    la a0, vector
    li a1, 0
    li a2, 7
    jal quickSort


    # call to print function for message
    la a1, outVect
    li a2, 22
    jal print

    # print signed numbers and carriage function
    la s1, vector       # address of data vector
    #--------forprint--------#
    li s0, 0            # index for cycle
    forprint:
        # user code
        # prepare calling to function
        lb a0, 0(s1)
        jal ra, printSignedNumbersAndCarriage

        addi s1, s1, 8  # increment double word pointer
    # condition exit
    li t0, 8
    addi s0, s0, 1
    blt s0, t0, forprint
    
_end:
li a7, _SYS_EX
ecall

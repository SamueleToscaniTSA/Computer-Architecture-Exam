#-------------------TS QUICK SORT----------------#

#--------quick sort vector n element function--------#
# the function uses:
#   - argument register:
#       - a0: vector pointer
#       - a1: start index vector
#       - a2: end index vector
#   - temporary register t0, t1, t2, t3, t4, t5, t6
#   - saved register s0, s1, restored before main call

# function quick sort on array
quickSort:
    # condition to end recursion call
    bge a1, a2, pass
        # store on stack return address, and saved register
        addi sp, sp, -24
        sd ra, 0(sp)
        sd s0, 8(sp)
        sd s1, 16(sp)

        # saved value register a0, a2
        mv s0, a0
        mv s1, a2

        jal partition       # call to partition function
        mv t6, a0           # copy return register into app

        mv a0, s0           # restore a0 argument
        addi a2, t6, -1     # change end index
        jal quickSort       # call to partition function

        mv a0, s0           # restore a0 argument
        addi a1, t6, 1      # change start index
        mv a2, s1           # restore a2 argument
        jal quickSort       # call to partition function

        # load from stack return address, and saved register
        ld ra, 0(sp)
        ld s0, 8(sp)
        ld s1, 16(sp)
        addi sp, sp, 24
    pass:

    jr ra

# function partition on array
partition:
    slli t0, a1, 3
    add t0, t0, a0  # pointer index
    mv t1, t0       # partition index

    addi t5, a2, -1 # end index -1
    slli t5, t5, 3
    add t5, t5, a0  # length pointer vector

    ld t2, 8(t5)    # pivot

    #--------forpartition--------#
    forPartition:
        # user code
        ld t3, 0(t0)        # element [*]
        bgt t3, t2, next
            # swap
            ld t4, 0(t1)    # app = [partition index]
            sd t3, 0(t1)    # [partition index] = element [*]
            sd t4, 0(t0)    # [pointer index] = app
            addi t1, t1, 8
        next:
    # condition exit
    addi t0, t0, 8          # increment dword pointer
    ble t0, t5, forPartition

    # swap
    ld t4, 0(t1)    # app = [partition index]
    sd t2, 0(t1)    # [partition index] = pivot
    sd t4, 8(t5)    # [pivot pointer index] = app

    sub t1, t1, a0  # partition index - base pointer = offset pointer
    srli a0, t1, 3  # partition index / 8 = return index

    jr ra

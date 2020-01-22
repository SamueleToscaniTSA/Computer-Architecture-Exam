#-------------------TS MULTIPLIER CONSTANT-VECTOR----------------#

#--------multiplier constant-vector function--------#
# the function uses:
#   - argument register:
#       -a0: address vector result
#       -a1: address vector input
#       -a2: address variable multiplier
#       -a3: vector length
#   - temporary register t0, t1, t2, t3
    
MCV:
    slli t0, a3, 2      # multiply size and length
    add t0, t0, a0      # end of address
    lb t2, 0(a2)        # var

#--------forMCV--------#
    forMCV:
        # user code
        lb t1, 0(a1)    # data [*]
        mul t3, t1, t2
        sw t3, 0(a0)    # res [*] = data [*] * var
        addi a0, a0, 4  # increment word pointer
        addi a1, a1, 1  # increment byte pointer
    # condition exit
    blt a0, t0, forMCV
    
    jr ra

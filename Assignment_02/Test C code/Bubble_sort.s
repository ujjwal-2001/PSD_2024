    .data
arr:    .word 5, 2, 8, 7, 1, 3, 9, 4, 6, 10   # Array initialized in memory

    .text
    .globl _start

_start:
    # Load immediate 0 into x5 (i = 0)
    addi x5, x0, 0       # x5 = 0 (i)

    # Load base address of arr into x6
    addi x6, x0, 0       # x6 = base address of arr = 0x00

outer_loop:
    # Load immediate 0 into x7 (j = 0)
    addi x7, x0, 0       # x7 = 0 (j)

inner_loop:
    # Load immediate 10 into x8 (array size)
    addi x8, x0, 10      # x8 = 10

    # x8 = 10 - i
    sub x8, x8, x5       # x8 = 10 - i

    # Load immediate 1 into x9 (for decrement)
    addi x9, x0, 1       # x9 = 1

    # x8 = 10 - i - 1
    sub x8, x8, x9       # x8 = 10 - i - 1

    # Compare if j >= 10 - i - 1
    bge x7, x8, outer_loop_end  # if j >= 10 - i - 1, exit inner loop

    # Load arr[j] into x10
    slli x11, x7, 2      # x11 = j * 4 (word offset)
    add x12, x6, x11     # x12 = base address + offset
    lw x10, 0(x12)       # x10 = arr[j]

    # Load arr[j+1] into x13
    addi x11, x11, 4     # x11 = (j+1) * 4 (next word offset)
    add x12, x6, x11     # Adjust address for arr[j+1]
    lw x13, 0(x12)       # x13 = arr[j+1]

    # Compare arr[j] and arr[j+1]
    blt x10, x13, no_swap  # if arr[j] <= arr[j+1], skip swapping

    # Swap arr[j] and arr[j+1]
    sw x10, 0(x12)       # Store arr[j] in arr[j+1]
    sw x13, -4(x12)      # Store arr[j+1] in arr[j]

no_swap:
    # Increment j (x7 = j + 1)
    addi x7, x7, 1       # j = j + 1

    # Repeat inner loop
    jal x0, inner_loop

outer_loop_end:
    # Increment i (x5 = i + 1)
    addi x5, x5, 1       # i = i + 1

    # Check if outer loop is done (i < 10)
    addi x8, x0, 10      # x8 = 10
    blt x5, x8, outer_loop  # if i < 10, repeat outer loop

    # End of program
    ecall               # Exit program

R0 N
R1 i
R2 j
R3 k
S4 sum
R5 A-addr
R6 B-addr
R7 C-addr
R8 A val
R9 B val

matrix_mult:
    push {R4-R11}
    MOV R1, #0  //R1 = i
    LDR R0, =num_rows
    LDR R0, [R0] //N
    LDR R5, =A_array
    LDR R6, =B_array
    LDR R7, =C_array
loop_i:
    @ ADD R1, R1, #1
	@ //if i > N exit
    @ CMP R1, R0 
    @ BGE exit
    MOV R2, #0 //j
loop_j:
    @ ADD R2, R2, #1 //increment j
    @ CMP R2, R0 //if j > N branch first iter
    @ BGE first_iter
    ldr R8, =zero
    .word 0xED984B00 //D4 = sum
    MOV R3, #0 //k
loop_k:
    //load A[i][k] into R8, increment A address
    MOV R11, #8
    MUL R10, R0, R11 //N * 8
    MUL R10, R10, R1 //^ * i
    MUL R9, R3, R11 //8 * k
    add R8, R9, R10//add ^^ + ^
    add R8, R5, R8//add baseA ^
    .word 0xED980B00 //D0 = A[i][k] ?

    //load B[k][j] into R9
    MUL R10, R0, R11 //N * 8
    MUL R10, R10, R3 //^ * k
    MUL R9, R2, R11 //8 * j
    add R8, R9, R10//add ^^ + ^
    add R8, R6, R8//add baseA ^
    .word 0xED981B00 //D1 = B[k][j] ?
    //multiply D3 = D0 * D1
	.word 0xEE203B01
    //add D4 = D4 + D3
    .word 0xEE344B03
    //FSTD D4, [C[i][j] address] namely [C[i][j] = D4?
    MUL R10, R0, R11 //N * 8
    MUL R10, R10, R1 //^ * i
    MUL R9, R2, R11 //8 * j
    add R8, R9, R10 //add ^^ + ^
    add R8, R7, R8 //add baseC ^
    .word 0xED984B00

    ADD R3, R3, #1
    CMP R3, R0
    BLT loop_k

    ADD R2, R2, #1
    CMP R2, R0
    BLT loop_j

    ADD R1, R1, #1
    CMP R1, R0
    BLT loop_i

exit:
    pop {R4-R11}
    
zero:
    .double 0.0

num_rows:
    .word 0x3
A_array:
	//row 1
    .double 1.1
	.double 1.2
	.double 1.3
	//row 2 
	.double 2.1
	.double 2.2
	.double 2.3
B_array:
    .double 0.1
	.double 0.2
	.double 0.3
	.double 0.1
	.double 0.2
	.double 0.3
C_array:
    .double 0.0
	.double 0.0
	.double 0.0
	.double 0.0
	.double 0.0
	.double 0.0
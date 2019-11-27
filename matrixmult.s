R0 N
R1 i
R2 j
R3 k
R4 sum
R5 A-addr
R6 B-addr
R7 C-addr
R8 
R9

matrix_mult:
    push {R4-R7}
    MOV R1, #-1  //i
    MOV R0, num_rows
    LDR R0, [R0] //N
    MOV R5, A_array
    MOV R6, B_array
    MOV R7, C_array
first_iter:
    ADD R1, R1, #1
    //increment A_addr
    CMP R1, R0 //if i > N exit
    BGE exit
    MOV R2, #-1 //j
second_iter:
    ADD R2, R2, #1
    CMP R2, R0 //if j > N branch first iter
    BGE first_iter
    MOV R4, #0.0 //sum
    MOV R3, #-1
third_iter:
    ADD R3, R3, #1
    CMP R3, R0 //if k > N branch second iter
    BGE store
    //load A[i][k] into R5
    //load B[k][j] into R6
    ADD R4, R4, R5
    ADD R4, R4, R6
    B third_iter
store:
    //store R4 into C[i][j]
    B second_iter
exit:
    pop {R5-R7}
    
    
num_rows:
    .word 0x80
A_array:
    .fill 16384, 4, 0x0
B_array:
    .fill 16384, 4, 0x0
C_array:
    .fill 16384, 4, 0x1
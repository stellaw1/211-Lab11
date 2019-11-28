R0 N
R1 i
R2 j
R3 k
R4 sum
R5 A-addr
R6 B-addr
R7 C-addr
R8 A val
R9 B val

matrix_mult:
    push {R4-R7}
    MOV R1, #-1  //i
    MOV R0, num_rows
    LDR R0, [R0] //N
    LDR R5, =A_array
    LDR R6, =B_array
    LDR R7, =C_array
first_iter:
    ADD R1, R1, #1
	//if i > N exit
    CMP R1, R0 
    BGE exit
    MOV R2, #-1 //j
second_iter:
    ADD R2, R2, #1 //increment j
    CMP R2, R0 //if j > N branch first iter
    BGE first_iter
    MOV R4, #0.0 //sum
    MOV R3, #-1
third_iter:
    ADD R3, R3, #1
    CMP R3, R0 //if k > N branch second iter
    BGE store
    //load A[i][k] into R8, increment A address

    //load B[k][j] into R9

    //do calc
	ADD 
    B third_iter
store:
    //store R4 into C[i][j]
	STR R4, [R7]
    B second_iter
exit:
    pop {R5-R7}
    
    
num_rows:
    .word 0x80
A_array:
	//row 1
    .double 1.1
	.double 1.1
	.double 1.1
	//row 2 
	.double 2.1
	.double 2.1
	.double 2.1
B_array:
    .double 0.1
	.double 0.1
	.double 0.1
	.double 0.2
	.double 0.2
	.double 0.2
C_array:
    .double 0.0
	.double 0.0
	.double 0.0
	.double 0.0
	.double 0.0
	.double 0.0
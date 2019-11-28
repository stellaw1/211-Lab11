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
    push {R4-R7,lr}
    MOV R1, #-1  //initialize i
    MOV R0, num_rows
    LDR R0, [R0] //N
	LDR R5, =A_array
	SUB R5, R5, #8
	LDR R6, =B_array
    LDR R7, =C_array
	SUB R7, R7, #8
first_iter:
	ADD R5, R5, #8 //location A[i]
    ADD R1, R1, #1
	//if i > N exit
    CMP R1, R0 
    BGE exit
    MOV R2, #-1 //j
		second_iter:
		ADD R7, R7, #8 //location C[i][j]
		ADD R2, R2, #1 //increment j
		CMP R2, R0 //if j > N branch first iter
		BGE first_iter
		LDR R4, =double_zero //sum
		.word 0xED940B00 //FLDD D0, [R4] 
		MOV R3, #-1
		LDR R6, =B_array
		ADD R6, R2, LSL#3 
			third_iter:
			ADD R3, R3, #1
			CMP R3, R0 //if k > N branch second iter
			BGE store

			//calc addresses of arrays
			ADD R5, R5, R3, LSL#3 //location A[i][k]
			ADD R6, R6, R0, LSL#3 //add N*8

			//load A[i][k] into R8, increment A address. A[i][k] = &A + i*N*8 + k*8 (each iter through k adds 8)
			.word 0xED951BOO //FLDD D1, [R5]
			//load B[k][j] into R9 B[k][j] = &B +k*N*8 + j*8 (each iter through k adds N*8)
			.word 0xED962B00 //FLDD D2, [R6]
			//do calc
			.word 0xEE211B02 //FMULD D1, D1, D2
			.word 0xEE300B01 //FADDD D0, D0, D1

			//restore addresses to before loop
			SUB R5, R5, R3, LSL#3
			B third_iter
		store:
		//store D0 into C[i][j]
		.word 0xED970B00 //FSTD D0, [R7]
		B second_iter
exit:
    pop {R5-R7,lr}
	//MOV pc,lr
	HALT
    
    
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
	.double 2.1
	.double 2.1
	//row 3
	.double 3.1
	.double 3.1
	.double 3.1

B_array:
    .double 0.1
	.double 0.2
	.double 0.3
	.double 0.1
	.double 0.2
	.double 0.3
	.double 0.3
	.double 0.3
C_array:
    .double 0.0
	.double 0.0
	.double 0.0
	.double 0.0
	.double 0.0
	.double 0.0
	.double 0.0
	.double 0.0
	.double 0.0

double_zero:
	.double 0.0
//expected C_array : [0.66,0.66,0.66]
//					 [1.26,1.26,1.26]
//					 [1.86,1.86,1.86]
		@		Subhan, Ehram        CS130 Section 16255  11/15/2023
		@		Third Laboratory Assignment - Zeckendorf Number
		@		Simultaion - ARMSim# - The ARM Simulator Dept. of Computer Science
		MOV		R0,#33   @ this will be the value of k
		BL	   zeck
		MOV    R1,#0
		MOV    R0,#0x18
		SWI    #0x123456

.text
.global zeck
.global k_zero
.global k_invalid
.global zeck_loop
.global zeck_equal
.global fib
.global fib_loop
.global fib_done
.global fib_equal

.equ	FIB_SIZE, 31
.equ	FIB_MAX, 514229

		@		2 functions: Calc Zeck & Calc Fibonacci
zeck:
		CMP		R0, #0
		BEQ		k_zero @if k == 0
		CMP		R0, #0
		BLE		k_invalid @if k < 0
		LDR		R3, =FIB_MAX
		CMP		R0, R3
		BGE		k_invalid @if k > largest Fib
		MOV		R2, #0 @initialising Zeck to 0
		BL		fib
		BL		zeck_loop

		@		Return 0
k_zero:
		BX		LR

		@		Return 1
k_invalid:
		MOV		R0, #-1
		BX		LR
		
		@while(k	!= 0) use BNE (Branch if not equal)
		@{		k - Fib
		@		Zeck++ }
zeck_loop:
		@now we have proper k, need to keep subbing next k and increment zeck num
		SUB		R6, R6, #1
		LDR		R1, [R5, R6, LSL#2] @load next k value to R1
		SUB		R6, R6, #1
		SUB		R0, R0, R1 @ k - Fib
		ADD		R2, R2, #1 @ Zeck++
		CMP		R0, #1
		BGT		zeck_loop
		CMP		R0, #1
		BEQ		zeck_equal
		MOV		R0, R2
		BX		LR

zeck_equal:
		ADD		R2, R2, #1 @zeck++
		MOV		R0, R2
		BX	LR
		
		@return	Zeck
		
		


@ Get nearest Fib to k
fib:
		
		CMP		R0, #0
		BLE		fib_done

		LDR		R5, =fib_table @address of table
		MOV		R2, #0	@initalize index to 0

fib_loop:
		CMP		R1, R0
		BEQ		fib_equal
		CMP		R1, R0
		BGT		fib_done
		LDR		R1, [R5, R6, LSL#2] @store next fib number
		ADD		R6, R6, #1  @increment for fib
		B		fib_loop	

fib_done:
		SUB		R6, R6, #2
		LDR		R0, [R5, R6, LSL#2] @Load nearest Fib
		BX		LR

fib_equal:
		SUB R6, R6, #1
		BX LR

.data
fib_table:
	.word 0,1,1,2,3,5,8,13,21,34,55,89,144,233,377,610,987,1597,2584,4181,6765,10946,17711,28657,46368,75025,121393,196418,317811,514229

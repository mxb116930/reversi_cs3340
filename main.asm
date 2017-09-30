	.data
board:	.space 400
moves:	.space 400
pColor:	.word 0
colorPrompt: .asciiz "Pick W or B: "
white:	.asciiz " W "
black:  .asciiz " B "
empty:	.asciiz "   "
border: .asciiz "\n       _________________________________\n"
columns:.asciiz "\n         A   B   C   D   E   F   G   H"
bar:	.asciiz "|"
newLine: .asciiz "\n"
activeColor: .word 1

	.text
	.globl main
main:
	li $v0, 4
	la $a0, colorPrompt
	syscall
	
	li $v0, 12
	syscall
	
	sw $v0, pColor
	
	
	la $a0, board
	jal newBoard
		
	la $a0, board
	jal printBoard	
	
	la $a0, board
	lw $a1, activeColor
	jal movesAvailable
	
	
	
	#Exit
exit:	
	li $v0, 10
	syscall

movesAvailable:
	add $t0, $zero, $zero
	add $t5, $zero, $zero
	la $v0, moves
	mul $t7, $a1, -1
	add $sp, $sp, -8
	sw $ra, ($sp)
	sw $s0, 4($sp)
	add $s0, $zero, 1
	add $t3, $zero, 1
	
movesLoop:
	beq $t0, 100, movesExit
	sll $t1, $t0, 2
	add $t2, $a0, $t1
	add $t3, $v0, $t1
	lw $t4, ($t2)
	bne $t4, 2, noMove
	
	add $a2, $zero, -44
	add $a3, $zero, 1
	jal followMoves
	beq $v1, 1, movesAdd
	
	add $a2, $zero, -40
	add $a3, $zero, 1
	jal followMoves
	beq $v1, 1, movesAdd
	
	add $a2, $zero, -36 
	add $a3, $zero, 1
	jal followMoves
	beq $v1, 1, movesAdd	
	
	add $a2, $zero, -4
	add $a3, $zero, 1
	jal followMoves
	beq $v1, 1, movesAdd
	
	add $a2, $zero, 4
	add $a3, $zero, 1
	jal followMoves
	beq $v1, 1, movesAdd
				
	add $a2, $zero, 36
	add $a3, $zero, 1
	jal followMoves
	beq $v1, 1, movesAdd

	add $a2, $zero, 40
	add $a3, $zero, 1
	jal followMoves
	beq $v1, 1, movesAdd						

	add $a2, $zero, 44
	add $a3, $zero, 1
	jal followMoves
	beq $v1, 1, movesAdd
																																																		
noMove:
	sw $zero, ($t3)
	addi $t0, $t0, 1
	j movesLoop
movesAdd:
	sw $s0, ($t3)
	addi $t0, $t0, 1
	addi $t5, $t5, 1
	j movesLoop
	
movesExit:
	move $v1, $t5
	lw $s0, 4($sp)
	lw $ra, ($sp)
	add $sp, $sp, 8 
	jr $ra




followMoves:
	add $sp, $sp, -8
	sw $t5, 4($sp)
	sw $ra, ($sp)
	add $t6, $t2, $a2
	lw $t5, ($t6)
	beq $t5, 0, followFail	
	beq $t5, 2, followFail
	beq $t5, $t7, followContinue
	beq $t5, $a1, followCheck

followContinue:
	add $a3, $a3, 1
	add $t2, $a2, $t2
	jal followMoves
	j followStop
	
followCheck:
	bge $a3, 2, followSuccess 
	j followFail
	
followSuccess:
	add $v1, $zero, 1
	j followStop	
	
followFail:
	add $v1, $zero, $zero

followStop:
	lw $t5, 4($sp)
	lw $ra, ($sp)
	add $sp, $sp, 8
	jr $ra 




printBoard:
	la $t7, ($a0)
	la $t6, ($a0)
	addi $t0, $zero, 9
	addi $t5, $zero, 10
	addi $t4, $zero, 1
	li $v0, 4
	la $a0, columns
	syscall
printLoop:	
	bgt $t0, 89, printR
	lw $t2, ($t7)
	beq $t2, 1, printW
	beq $t2, 2, printEmpty
	beq $t2, -1, printB
	div $t0, $t5
	mfhi $t3
	bne $t3, $zero, printAdd
	blt $t0, 11, first
	li $v0, 4
	la $a0, bar
	syscall
 
first:	la $a0, border
 	syscall
 	li $v0, 4
	la $a0, empty
	syscall
 	la $a0, ($t4)
 	li $v0, 1
 	syscall
 	addi $t4, $t4, 1
	li $v0, 4
	la $a0, empty
	syscall
	j printAdd
printW:
	li $v0, 4
	la $a0, bar
	syscall
	la $a0, white
	syscall
	j printAdd
printB:
	li $v0, 4
	la $a0, bar
	syscall
	la $a0, black
	syscall
	j printAdd

printEmpty:	
	li $v0, 4
	la $a0, bar
	syscall
	la $a0, empty
	syscall
		
				
printAdd:
	
	addi, $t0, $t0, 1
	sll $t1, $t0, 2
	add $t7, $t1, $t6
	j printLoop
printR:
	la $a0, bar
	syscall
 	la $a0, border
 	syscall
	jr $ra



newBoard:
	la $t7, ($a0)
	add $t0, $zero, $zero
	addi $t6, $zero, 1
	addi $t5, $zero, 2
	addi $t4, $zero, -1
	addi $t3, $zero, 10
	
newBoardLoop: 
	beq $t0, 100, newBoardR
	
	slti $t2, $t0, 10
	beq $t2, 1, newBoardSetNull
	sgt $t2, $t0, 88
	beq $t2, 1, newBoardSetNull
	div $t0, $t3
	mfhi $t2
	beq $t2, 0, newBoardSetNull
	beq $t2, 9, newBoardSetNull
	beq $t0, 44, newBoardSetW
	beq $t0, 45, newBoardSetB
	beq $t0, 54, newBoardSetB
	beq $t0, 55, newBoardSetW
			
	sw $t5, ($t7)
	j newBoardAdd
	
newBoardSetW:
	sw $t6, ($t7)
	j newBoardAdd
	
newBoardSetB:
	sw $t4, ($t7)
	j newBoardAdd
	 	 
newBoardSetNull:
	sw $zero, ($t7)

newBoardAdd:
	addi $t0, $t0, 1
	sll $t1, $t0, 2
	add $t7, $t1, $a0
	j newBoardLoop

newBoardR:
	jr $ra

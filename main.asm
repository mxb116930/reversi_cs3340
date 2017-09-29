	.data
board:	.space 400
pColor:	.word
colorPrompt: .asciiz "Pick W or B"
activeColor: .word

	.text
	.globl main
main:
	li $v0, 4
	la $a0, colorPrompt
	syscall
	
	li $v0, 12
	syscall
	
	li $v0, 10
	syscall

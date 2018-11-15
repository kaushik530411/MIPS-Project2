.data
	buffer: .space 10000
	input_empty: .asciiz "Input is empty."
	input_invalid: .asciiz "Invalid base-35 number."
	input_long: .asciiz "Input is too long."

.text
exit:
	li $v0, 10 # end the program
	syscall
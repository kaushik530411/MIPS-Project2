.data
	buffer: .space 10000
	input_empty: .asciiz "Input is empty."
	input_invalid: .asciiz "Invalid base-35 number."
	input_long: .asciiz "Input is too long."

.text
main:
	li $v0, 8  #  Taking input stream
	la $a0, buffer  #  load byte space into address
	li $a1, 10000  #  allot the byte space for string
	syscall

exit:
	li $v0, 10 # end the program
	syscall
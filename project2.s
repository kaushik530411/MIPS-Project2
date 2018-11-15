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

	move $t0, $a0  #  move string to $t0
	move $t7, $a0  #  a copy of string in other register for future use

	check_empty:
	lb $a0, 0($t0)
	beq $a0, 10, is_empty
	j loop  #  if it is not empty then parse through the loop to check if there is any invalid characters
	
exit:
	li $v0, 10 # end the program
	syscall
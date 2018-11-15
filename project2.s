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

is_empty:
	li $v0, 4  #  system call code for printing string = 4
	la $a0, input_empty  # load address of string to be printed into $a0
	syscall
	j exit  #  exit if it is an empty string

	li $t2, 0  #  initializing $t1 to 0 inorder to later find the length of the valid string
	li $t4, 0  #  initializing $t1 to 0 later when a character is found will change to 1

loop:
	lb $a0, 0($t0)
	beq $a0, 10, start_conversion # last char is line feed ($a0 = 10) so exit the loop and start conversion

	addi $t0, $t0, 1  #  shifing the marker to the right by one byte

	slti $t1, $a0, 122 # if $a0 < 122 ($a0 = [0, 121]) ->  $t1 = 1, else $t0 = 0 ($a0 = [122, 127])
	beq $t1, $zero, is_invalid

	beq $a0, 32, is_space  #  skip the space char

	j loop
	
exit:
	li $v0, 10 # end the program
	syscall
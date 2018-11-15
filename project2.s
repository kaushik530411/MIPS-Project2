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
	
	slti $t1, $a0, 48  # if $a0 < 48 ($a0 = [0, 47] - 32) -> $t1 = 1, else $t0 = 0 ($a0 = [48, 121])
	bne $t1, $zero, is_invalid
	
	slti $t1, $a0, 58  #  if $a0 < 58 ($a0 = [48, 57]) -> $t1 = 1, else $t0 = 0 ($a0 = [58, 121])
	bne $t1, $zero, is_digit

	slti $t1, $a0, 65  #  if  $a0 < 65 ($a0 = [58, 64]) -> $t1 = 1, else $t0 = 0 ($a0 = [65, 121])
	bne $t1, $zero, is_invalid
	
	slti $t1, $a0, 90  #  if $a0 < 90 ($a0 = [65, 89]) -> $t1 = 1, else $t0 = 0 ($a0 = [90, 121])
	bne $t1, $zero, is_upper
	
	slti $t1, $a0, 97  #  if $a0 < 97 ($a0 = [90, 96]) -> $t1 = 1, else $t0 = 0 ($a0 = [97, 121])
	bne $t1, $zero, is_invalid
	
	slti $t1, $a0, 122  #if $a0 < 122 (#a0 = [97, 121]) -> $t1 = 1, else $t0 = 0 but max possible $a0 = 121, so 'else' not possible
	bne $t1, $zero, is_lower

	j loop

is_space:
	beq $t4, -1, loop  #  already found space between valid chars, leave $t4 = -1 (do noting)
	beq $t4, 1, space_seen_after_valid_char  #  previously seen a valid char
	j loop

space_seen_after_valid_char:
	li $t4, 0
	j loop

is_invalid:
	li $v0, 4  #  system call code for printing string = 4
	la $a0, input_invalid
	syscall
	j exit

is_digit:
	addi $t2, $t2, 1  #  increment for valid character count
	bne $t2, 1, check_prev  #  if valid char occered for multiple occurences check all prev char to be correct
	li $t4, 1  # only set if first valid char is seen
	j loop

is_upper:
	addi $t2, $t2, 1  #  increment for valid character count
	bne $t2, 1, check_prev
	li $t4, 1
	j loop

is_lower:
	addi $t2, $t2, 1  #  increment for valid character count
	bne $t2, 1, check_prev
	li $t4, 1
	j loop

check_prev:
	beq $t4, 0, space_between_valid_chars  #  space found between valid chars (ex. "A B")
	j loop

space_between_valid_chars:
	li $t4, -1  #  Space between valid chars found
	j loop

start_conversion:
	li $a1, 35  #  loading the base
	li $a2, 42875  #  (base * 3) -> Highest possible value for Most significant bit (MSB) if MSB is 1
	li $a3, 4  #  Max possible length of a valid char array
	li $t8, 0  #  initializing to get the final conversion sum
	
exit:
	li $v0, 10 # end the program
	syscall
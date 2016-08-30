# Parker Smith -- 2/1/16
# number_to_guess.asm -- A program that has a hard coded number that
#			the user has 5 attempts to guess.

# Registers used:
#	$s1	- used to hold the number of guesses the user has remaining.
#	$a0	- procedure and syscall parameters.
#	$v0	- syscall parameter and procedure return value.
#	$ra	- procedure return address.
#	$t0	- temporarily hold the value of numToGuess.


.data
	input_prompt: 		.asciiz		"Please enter a guess: "
	too_high_message:	.asciiz		"Your guess was too high."
	too_low_message:	.asciiz		"Your guess was too low."
	good_guess:		.asciiz		"Your guess was correct!"
	return:			.asciiz		"\n"
	guesses_left:		.asciiz		"Guesses remaining: "
	no_guesses:		.asciiz		"You are out of guesses."
	numToGuess:		.word		17
	
.text
	main:
		li	$s1, 5			# The number of guesses remaining.
		
		j 	user_input		
		
	user_input:
		la	$a0, input_prompt	# Load the address of the input prompt
		li	$v0, 4			# Prepare syscall to output prompt
		syscall
		
		li	$v0, 5			# Prepare syscall to read input
		syscall
		move	$a0, $v0		# Move input into $a0
		
		jal	evaluate_input		# Evaluate the user's input against $s0
		
		bnez	$v0, correct_guess	# The guess was correct, output success message.
		j	incorrect_guess		# The guess was incorrect.
		
	incorrect_guess:
		addi	$s1, $s1, -1		# Remaining guesses -= 1
		
		beqz	$s1, out_of_guesses	# The user is out of guesses
		
		la	$a0, guesses_left	# Load address of guesses_left message
		li	$v0, 4			# Prepare syscall to output message
		syscall
		
		move	$a0, $s1		# $a0 = $s1
		li	$v0, 1			# Prepare syscall to output $s1
		syscall
		
		la	$a0, return		# Load address of the return character.
		li	$v0, 4			# Prepare syscall to output character.
		syscall
		
		j	user_input
		
	out_of_guesses:
		la	$a0, no_guesses		# Load address of no_guesses message.
		li	$v0, 4			# Prepare syscall to output message.
		syscall
		
		j	Exit			# Move to the exit label.
		
	evaluate_input:
		lw	$t0, numToGuess		# Move numToGuess into $t0.
		bgt	$a0, $t0, too_high	# if ($a0 > $t0) goto: too_high
		blt	$a0, $t0, too_low	# else if ($a0 < $0) goto: too_low
		
		li	$v0, 1			# The guess was correct, return 1.
		jr	$ra
	
	too_high:
		la	$a0, too_high_message	# Load address of too_high prompt
		li	$v0, 4			# Prepare syscall to output message
		syscall
		
		la	$a0, return		# Load address of return character.
		li	$v0, 4			# Prepare syscall to output character
		syscall
		
		li	$v0, 0			# The guess was incorrect, return 0
		jr	$ra
		
	too_low:
		la	$a0, too_low_message	# Load address of too_low prompt
		li	$v0, 4			# Prepare syscall to output message
		syscall
		
		la	$a0, return		# Load address of return character.
		li	$v0, 4			# Prepare syscall to output character
		syscall
		
		li	$v0, 0			# The guess was incorrect, return 0
		jr	$ra
			
	
	correct_guess:
		la	$a0, good_guess		# Load address of good_guess message
		li	$v0, 4			# Prepare syscall to output the message.
		syscall
		
		j	Exit
		
	Exit:
		li	$v0, 10			# Prepare syscall to exit.
		syscall
		
# end of number_to_guess.asm
		
		
		
		
		
		
		
			
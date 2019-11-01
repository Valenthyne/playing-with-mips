# Title: Character Counter	Filename: charcount.asm
# Description: A file intended to count the number of occurrences of characters/symbols in an input
# Input: sample_text.dat
# Output: print to console

################# Data segment #####################
.data
input: .asciiz "sample_text.dat" 		# Input to be read
buffer: .space 256					# Allot 256 Bytes of buffer for file
.align 2
counter: .space 1024				# 1024 Bytes for Counter space
nl: .asciiz "\n"
colSpace: .asciiz ": "
intro: .asciiz "Counting Occurences of Characters in File sample_text.dat\n~~~\n"

# Note: ASCII table values for characters
# 65 - 90 (A - Z)
# 97 - 122 (a - z)

################# Code segment #####################
.text

la $a0, intro					  	# Loads address of inductory message
li $v0, 4						      # Loads syscall to print string
syscall

la $s1, counter						# Loads in $s1 the address for counter array
addi $s1, $s1, 128				# Adds 128 offset to counter address to start at "SPACE" for ASCII counting
la $s2, 380($s1)					# Cuts off counter array at ASCII value for tilde (126)
li $s4, 32						    # Initializes character at ASCII 32 for printing later

li $v0, 30						    # Loading system call for system time
syscall
move $s6, $a0						  # Moving the contents of the $a0 register into the $s7 register (start time)

# Open file for reading

li   $v0, 13						  # Loading system call used to open a file
la   $a0, input						# Loading input label as address for argument register $a0
li   $a1, 0           		# Loading flag for reading in argument register $a1
syscall              			# Execute system call
move $s0, $v0         		# Retain file description 

la $t2, counter						# Loads base address of counter

# reading from file just opened
Loop: 
	beq $v0, $zero, Print		# Change to Exit if Print is buggy
	li   $v0, 14       			# Loading system call used to read from a file
	move $a0, $s0       		# Moving file description
	la   $a1, buffer    		# Loading address of buffer used for file
	li   $a2,  1       			# Default buffer length
	syscall    

	lb $t1, buffer					# Loads character from buffer into $t1
	add $t6, $zero, $v0			# Does something real important
	
	# Store byte in counter array in its respective numeric position, incremented by 1

	sll $t1, $t1, 2					# Multiple value of character by 4
	add $t3, $t1, $t2  			# Add value of char*4 into base counter addrress			
	lw $t4, ($t3)					  # Load into $t4 the character at $t3
	addi $t4, $t4, 1				# Increments character $t4 by 1
	sw $t4, ($t3)					  # Store value of $t1 in $t2

	# Printing File Content
#	li  $v0, 4         			# Loading system call used to print strings
#	la  $a0, buffer     		# Memory buffer containing the values to be read
#	syscall             

	add $v0, $zero, $t6			# Also does something real important
	j Loop						      # Continue looping/reading through file

Print: 
	lw $s3, 0($s1)					# Load into $s3 word from counter address
	beq $s1, $s2, Exit			# Exits when end of counter array has been reached
	move $a0, $s3				  	# Moves count for current character into argument for printing
	li $v0, 1				      	# Load syscall for print integer
	syscall
	addiu $s1, $s1, 4				# Increment address of counter array by four for next count

	li $v0, 11				    	# Load syscall for printing character
	move $a0, $s4					  # Moves ASCII character value into argument register
	syscall		
	addiu $s4, $s4, 1				# Increment ASCII character value to print next character

	la $a0, colSpace				# Load address to prepare a ": " for print format
	li $v0, 4					      # Load syscall for printing a string
	syscall

	la $a0, nl			    		# Load address to prepare a "\n" for print format
	li $v0, 4				      	# Load syscall for printing a string
	syscall
j Print						      	# Continue printing process until condition to terminate is met

Exit:
	li $v0, 30					    # Loading system call for system time
	syscall
	move $s7, $a0					  # Moving the contents of the $a0 register into the $s7 register (end time)

	subu $s7, $s7, $s6			# Subtracting the end time from the start time in milliseconds

	li $v0, 1					      # Loading system call for printing integers
	move $a0, $s7			      # Moving the subtracted time different into register $a0
	syscall

	li $v0, 10      	      # Conclude the program
	syscall						      # Execute system call

## End of program ##

#=============================================================================================================
# Author: Kabeli Charles 202000679
# Email: kabeli.charles@gmail.com
# Phone: +26656243089
# Date:  October 12, 2022
# Functional description: This is the program that determines and prints the first 10 reversible prime squares
#=============================================================================================================
.data
	Title:    .asciiz "The First 10 Reversible Prime Squares:\n"
	number: .word 1   		# The number to be checked if it is prime, first initialised to 1 but will be incremented
	divisor: .word 0  		# A number to divide the incremented number to check its factors
	factors:	.word 0 	# this variable stores the number of factors found
	found:.word 0			# this variable determines the number of reversible prime squares found
	next_line:.asciiz  "\n"
	space:.asciiz ": "

.text
.globl main
.ent main

main:
	li $v0, 4               # prints the Title
	la $a0, Title
	syscall
	
	lw $t0 , number			# stores the number to checked if it is prime in the temporary variable $t0 
	lw $t1 , divisor		# stores the devisor in the temporary variable $t1
	lw $t2 , factors		# stores the number of factors of a number in the temporary variable $t2
	lw $t5, found			# stores the number of prime squares found in $t5
	
	
Loop1:
	move $a0 , $t0			# copy the contents of $t0, $t1 and $t2 in the 
	move $a1 , $t1			# variables $a0,$a1, and $a2
	move $a2 , $t2
	
	jal Is_Prime			# calls the function Is_Prime to check if the number is a prime
	
	
	beq $v0, 1, Prime		# Checks if the returned value of Is_Prime is true or false. if true jump to Prime
	add $t0, $t0, 1			# else increment the number to be check then
	j Loop1					# Jump to Loop1 to check the next prime

Prime:
	mul $a0, $t0, $t0		# store the squared value of prime hold by $t0 in the variable $a0 then
	
	jal Reverse           	# calls the reverse to returned value of the Squared Prime
	
	move $t3, $v0			# copy the reversed square value in the temporary variable $t3
	
	move $a0, $v0			# copy the contents of returned value in the Argument register
	mul $a1, $t0, $t0		# store the square of a number in the variable $t0 in $a1
	
	jal Is_Palindrome		# calls Is_Palindrome to check if the square number is a palindrome
	
	move $a0, $v0 			
	
	beq $a0, 1 , True		# if the square is a palindrome branch to True
	j Not_Palindrome		# otherwise go the Not_Palindrome
	
True:
	add $t0, $t0, 1			# if the Square is a palindrome increment the number and jump back to check the other prime
	j Loop1
	
Not_Palindrome:				
	move $a0, $t0
	
	jal Reverse				
	
	move $t4, $a0
	li $a1,0
	li $a2,0
	
	jal Is_Prime			# calls the function Is_Prime to check if the reverse is prime
	
	beq $a0, 1 , check_square	#if it is prime we brach to check is it is square
	j not_square				# else jump to not_square
	
check_square:
	move $a0, $t3
	move $a1, $t4
	
	jal CheckSquare			#calls the function that checks if a number is square
	
	bne $v0, 1, not_square	#if the number is not square branch to not_square
	j True4					# else jump to True4
	
not_square:
	add $t0, $t0, 1			# Increment the number to check other prime number
	j Loop1					# jump back to Loop1
	
True4:
	move $t3,$t0			# store the number that its square is reversible Prime Square in the temporary variable $t3 
	j Print					# jump to print the reversible Prime Square

## print the reversible Prime Square
Print:
	###for labeling of the numbers from 1 to 10
	add $t5,$t5,1			#increment the number of found prime squares
	move $a0, $t5
	li $v0,1
	syscall
	
	###for printing a space after the labeling
	li $v0, 4
	la $a0, space
	syscall
	
	### prints the reversible square primes
	mul $a0, $t3, $t3
	li $v0, 1
	move $a0,$a0
	syscall
	beq $t5, 10 ,Exit		# if 10 numbers have been printed Exit the program 
	add $t0, $t0,1			# otherwise increment the number
	
	###for skipping to the new line to print the next number
	li $v0,4
	la $a0, next_line
	syscall
	j Loop1 				## returns to the first loop to perform all the specified funtions on the new number
Exit:
li $v0, 10
syscall

.end main
	
#===================================================================================================
# THE IMPLIMANTATION OF THE FUNCTION `Is_Prime`.
# it checks if the number is prime and returns True, else return False

.globl Is_Prime
.ent Is_Prime

Is_Prime:

Loop2:
	bgt $a1,$a0, Next   #break the loop and brach to Next if the devisor is greater than the number
	add $a1, $a1, 1     #increment the devisor to find the next perfect devisor of a number
	rem $a3, $a0, $a1	# stores the remainder when deviding a number by each devisor in $a3
	beq $a3, 0, Loop3   # checks if a remaider==0. if it is True branch to Loop3
	
	j Loop2             #else restart the loop
	
Loop3:
	add $a2, $a2, 1     #increment the variable $a2 containing the number of factors
	bgt $a1, $a0, Next	#break the loop and brach to Next if the devisor is greater than the number
	j Loop2				#jump back to Loop2
	
Next:
	beq $a2, 2, True1  #checks if the number of devisors equal 0. if True branch to True1
	j False				#else jump to False
	
True1:				##returns True
	li $a0, 1
	move $v0, $a0
	jr $ra
	
False:				##returns False
	li $a0, 0
	move $v0, $a0
	jr $ra
	
.end Is_Prime


#===========================================================================
#THE IMPLIMANTATION OF THE FUNCTION `Reverse`.
#This function reverses the square of the value stored in $t0

.globl Reverse
.ent Reverse

Reverse:
	move $a0, $a0
	li $a1, 0     	#initialize variable reverse to 0
	
	
Loop4:
	beq $a0, 0, Return	#if break the loop and jump to Return if the number=0
	mul $a1, $a1, 10	#reverse*10
	rem $a2, $a0, 10	#number%10
	add $a1, $a1, $a2	#reverse = reverse*+number%10
	
	div $a0, $a0, 10	#number=number/10
	j Loop4				#repeats the loop until number=0
	
Return:					#returns the reverse of a number
	move $a0, $a1
	move $v0, $a0
	jr $ra

.end Reverse

#==========================================================================
#THE IMPLIMANTATION OF THE FUNCTION `Is_Palindrome`.
#This function checks if a number is a Is_Palindrome

.globl Is_Palindrome
.ent Is_Palindrome
Is_Palindrome:
Loop5:
	beq $a0, $a1, True2   #checks is the number and its reverse are equal. if that`s the case branch to True2
	j False1			#else jump to False1
	
True2:
	li $a0, 1			#if the number and its reverse are equal return True
	move $v0, $a0
	jr $ra
	
False1:
	li $a0, 0			#if the number and its reverse are not equal return False
	move $v0, $a0
	jr $ra
.end Is_Palindrome

#=============================================================================
#THE IMPLIMANTATION OF THE FUNCTION `CheckSquare`.
#This function performs three operations:
# 1) checks if the number is a square
# 2) if it is it finds its square root
# 3) checks if that square root is also a prime
# If all the conditions are met it returns True, else returns False.

.globl CheckSquare

CheckSquare:
	divu $t3, $a0, $a1
	beq $t3, $a1, SquareTrue 	#branch to SquareTrue if it is a square number
	j SquareFalse				# else jump to SquareFalse
	
	
SquareTrue:
	li $v0, 1   	#returns True if it is a square number
	
	jr $ra

SquareFalse:		#returns False if it is not a square number
	li $v0, 0
	jr $ra
.end CheckSquare
#==============================================================================
#								T H E  E N D
#==============================================================================
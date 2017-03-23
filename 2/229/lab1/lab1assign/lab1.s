#--------------------------------------------------------
#lab assignment1
#student: 	Yue YIN
#student 	ID: 1345121
#Unix ID:    	yyin
#lab Section	D05
#---------------------------------------------------------
# register used description:
#	$a0: used for syscall arguements
#	$v0: used for syscall arguements
#	$t0: refers to the input number 
#	$t1: refers to the first 2 bytes of the input number
#	$t2: refers to the second 2 bytes of the input number
#	$t3: refers to the third 2 bytes of the input number
#	$t4: refers to the forth 2 bytes of the input number
#-------------------------------------------------------

	.data
input:
	.asciiz "\nInput a number:"
output:
	.asciiz "The converted number is:"

	.text
main:	
	#print the input
	li	$v0, 4 		#system call code for print string	
	la	$a0, input	#address of input to print
	syscall

	#Read the number
	li 	$v0, 5
	syscall

	# Move number to $t0
	move	$t0, $v0

	# copy each byte
	andi	$t1, $t0, 0xFF000000
	andi	$t2, $t0, 0x00FF0000
	andi	$t3, $t0, 0x0000FF00
	andi	$t4, $t0, 0x000000FF
	
	# shift
	srl	$t1, $t1, 24
	srl	$t2, $t2, 8
	sll	$t3, $t3, 8
	sll	$t4, $t4, 24

	# modifing
	or	$t0, $t1, $t2
	or	$t0, $t0, $t3
	or	$t0, $t0, $t4

	#print output
	li	$v0, 4
	la	$a0, output
	syscall
			
	#print the modified number
	li	$v0, 1
	move	$a0, $t0
	syscall

	jr	$ra


#--------------------------------------------------------
#lab assignment2
#student: 	Yue YIN
#student 	ID: 1345121
#Unix ID:    	yyin
#lab Section	
#-----------------------------------------------------
#this may help for you to read the code:
#	A1----output1
#	...
#	An----outputn
#	...
#	A8----output8
#	they refer seperately.
#---------------------------------------------------------
#register used description:
#	$t0: used to have the address  of array 
#	$t1: used to represent the value of 0($a0)
#	$t2: used to deal with op code
#	$t3: used to deal with Reg s
#	$t4: used to deal with Reg t if possible
#	$t5: used to deal with offset
#	$t6: used to compare the op code and code of position of T register's
#-----------------------------------------------------------
	.data

A1:
	.asciiz "bgez $"	#space and "$" come with the term together
A2:
	.asciiz "bgezal $"
A3:
	.asciiz "bltz $"
A4:
	.asciiz "bltzal $"
A5:
	.asciiz "beq $"
A6:
	.asciiz	"bne $"
A7:
	.asciiz "blez $"
A8:
	.asciiz "bgtz $"
B0:
	.asciiz ", $"		#this is for beq or bne
B1:
	.asciiz ", "		# this is for others

	.text

disassembleBranch:
	move	$t0, $a0    		
	lw 	$t1, 0($a0)  		
	
	# musk out the  code
	andi 	$t2, $t1, 0xfc000000	#musk out op code to $t2
	andi	$t3, $t1, 0x03e00000	#musk out Reg s		
	andi	$t4, $t1, 0x001f0000	#musk out Reg t
	andi	$t5, $t1, 0x0000ffff	#musk out Offset
	andi	$t6, $t1, 0xfc1f0000	#musk out 1111 1100 0001 1111 0000 0000 0000 0000	

	srl	$t3, $t3, 21		#get the true value of Reg s
	srl	$t4, $t4, 16		#get the true value of Reg t 
	sll	$t5, $t5, 2		#multiply it by 4
	add	$t5, $t5, $t0		#PC+ offset
	addi	$t5, $t5, 4		#PC + offset + 4

	# check if it is a branch command
	beq	$t6, 0x04010000, output1#it is	bgez $s, offset
	beq	$t6, 0x04110000, output2#it is	bgezal $s, offset     
	beq	$t6, 0x04000000, output3#it is	bltz $s, offset
	beq	$t6, 0x04100000, output4#it is	bltzal $s, offset
	beq	$t6, 0x18000000, output7#it is	blez $s, offset
	beq	$t6, 0x1c000000, output8#it is	bgtz $s, offset
	beq	$t2, 0x14000000, output6#it is	bne $s, $t, offset
	beq	$t2, 0x10000000, output5#it is	beq $s, $t, offset
	j	exit			# if still no match, return
	# checking if it is a branch done

	#print  out the result
output1:
	li	$v0, 4
	la	$a0, A1
	syscall
	
	li	$v0, 1
	move	$a0, $t3
	syscall	

	li	$v0, 4
	la	$a0, B1
	syscall
	
	li	$v0, 1
	move	$a0, $t5
	syscall
	
	j	exit

output2:
	li	$v0, 4
	la	$a0, A2
	syscall
	
	li	$v0, 1
	move	$a0, $t3
	syscall

	li	$v0, 4
	la	$a0, B1
	syscall	
	
	li	$v0, 1
	move	$a0, $t5
	syscall
	
	j	exit

output3:
	li	$v0, 4
	la	$a0, A3
	syscall
	
	li	$v0, 1
	move	$a0, $t3
	syscall	

	li	$v0, 4
	la	$a0, B1
	syscall
	
	li	$v0, 1
	move	$a0, $t5
	syscall
	
	j	exit

output4:
	li	$v0, 4
	la	$a0, A4
	syscall
	
	li	$v0, 1
	move	$a0, $t3
	syscall	

	li	$v0, 4
	la	$a0, B1
	syscall
	
	li	$v0, 1
	move	$a0, $t5
	syscall
	
	j	exit

output5:
	li	$v0, 4
	la	$a0, A5
	syscall
	
	li	$v0, 1
	move	$a0, $t3
	syscall	

	li	$v0, 4
	la	$a0, B0
	syscall
	
	li	$v0,1
	move	$a0, $t4
	syscall
	
	li	$v0, 4
	la	$a0, B1
	syscall

	li	$v0, 1
	move	$a0, $t5
	syscall
	
	j	exit

output6:
	li	$v0, 4
	la	$a0, A6
	syscall
	
	li	$v0, 1
	move	$a0, $t3
	syscall	

	li	$v0, 4
	la	$a0, B0
	syscall
	
	li	$v0,1
	move	$a0, $t4
	syscall

	li	$v0, 4
	la	$a0, B1
	syscall
	
	li	$v0, 1
	move	$a0, $t5
	syscall
	
	j	exit

output7:
	li	$v0, 4
	la	$a0, A7
	syscall
	
	li	$v0, 1
	move	$a0, $t3
	syscall	

	li	$v0, 4
	la	$a0, B1
	syscall
	
	li	$v0, 1
	move	$a0, $t5
	syscall
	
	j	exit

output8:
	li	$v0, 4
	la	$a0, A8
	syscall
	
	li	$v0, 1
	move	$a0, $t3
	syscall	

	li	$v0, 4
	la	$a0, B1
	syscall
	
	li	$v0, 1
	move	$a0, $t5
	syscall
	
	j	exit

exit:
	jr	$ra
	
	
	

#-------------------------------
# Control Flow Lab - Student Testbed
# Author: Taylor Lloyd
# Date: July 19, 2012
#
#-------------------------------
.data
	.align 2
binary:  #Absolutely MUST be the first data defined, for jump correction
	.space 2052
noFileStr:
	.asciiz "Couldn't open specified file.\n"
blkCountStr:
	.asciiz " block(s) found.\n"
blkLeaderStr:
	.asciiz "Block Leader: "
sizeStr:
	.asciiz ", Size: "
nlStr:
	.asciiz "\n"
spaceStr:
	.asciiz " "
edgesStr:
	.asciiz "\nEdges:\n"
edgeSepStr:
	.asciiz " --> "
domsStr:
	.asciiz "\nDominator Bit Vectors:\n"
.text
main:
	lw	$a0 4($a1)	# Put the filename pointer into $a0
	li	$a1 0		# Read Only
	li	$a2 0		# No Mode Specified
	li	$v0 13		# Open File
	syscall
	bltz	$v0 main_err	# Negative means open failed

	move	$a0 $v0		#point at open file
	la	$a1 binary	# write into my binary space
	li	$a2 2048	# read a file of at max 2kb
	li	$v0 14		# Read File Syscall
	syscall
	la	$t0 binary
	add	$t0 $t0 $v0	#point to end of binary space

	li	$t1 0xFFFFFFFF	#Place ending sentinel
	sw	$t1 0($t0)

	#fix all jump instructions
	la	$t0 binary	#point at start of instructions
	move	$t1 $t0
	main_jumpFixLoop:
		lw	$t2 0($t0)
		srl	$t3 $t2 26	#primary opCode
		li	$t4 2
		beq	$t3 $t4 main_jumpFix
		li	$t4 3
		beq	$t3 $t4 main_jumpFix
		j	main_jfIncrem
		main_jumpFix:
			#Replace upper 10 bits of jump with binary address
			li	$t3 0xFC000FFF		#bitmask
			and	$t2 $t2 $t3		#clear bits
			la	$t4 binary
			srl	$t4 $t4 2		#align to instruction
			not	$t3 $t3
			and	$t4 $t4 $t3		#only get bits in field
			or	$t2 $t2 $t4		#combine back on the binary address
			sw	$t2 0($t0)		#place the modified instruction
		main_jfIncrem:
		addi	$t0 $t0 4
		li	$t4 -1
		bne	$t2 $t4 main_jumpFixLoop

	la	$a0 binary	#prepare pointer for assignment
	jal	getControlFlow

	#Retrieve stack values
	lw	$s1 0($sp)	#Block Pointer
	lw	$s3 4($sp)	#Edge Pointer
	lw	$s4 8($sp)	#Dominators Pointer
	addi	$sp $sp 8

	move	$s0 $v0		#Block Count
	move	$s2 $v1		#Edge Count

	move	$a0 $v0
	li	$v0 1
	syscall

	la	$a0 blkCountStr
	li	$v0 4
	syscall
	
	move	$t0 $s0
	addi	$sp $sp -4
	main_parseBlocks:
		beqz	$t0 main_doneBlocks
		sw	$t0 0($sp)
		la	$a0 blkLeaderStr
		li	$v0 4
		syscall

		lw	$a0 0($s1)
		jal	printHex

		la	$a0 sizeStr
		li	$v0 4
		syscall

		lw	$a0 4($s1)
		li	$v0 1
		syscall

		la	$a0 nlStr
		li	$v0 4
		syscall

		lw	$t0 0($sp)
		addi	$t0 $t0 -1
		addi	$s1 $s1 8

		j	main_parseBlocks
	main_doneBlocks:
		addi	$sp $sp 4
		la	$a0 edgesStr
		li	$v0 4
		syscall
	main_parseEdges:
		beqz	$s2 main_parseDoms

		lw	$a0 0($s3)
		jal	printHex

		la	$a0 edgeSepStr
		li	$v0 4
		syscall

		lw	$a0 4($s3)
		jal	printHex

		la	$a0 nlStr
		li	$v0 4
		syscall

		addi	$s2 $s2 -1
		addi	$s3 $s3 8

		j	main_parseEdges

	main_parseDoms:
		la	$a0 domsStr
		li	$v0 4
		syscall

		srl	$s5 $s0 5		# get number of words required
		sll	$t0 $s5 5
		beq	$s0 $t0 dominators_noAddCom
		addi	$s5 $s5 1		# add space for the dropped amount
		dominators_noAddCom:
		move	$t0 $s4			#Dominators pointer
		sll	$t1 $s5 2		#words to bytes
		li	$t3 0			#Block Counter
		main_printDomLoop:
			move	$t2 $t0
			add	$t2 $t2 $t1	#last word
			main_domWordLoop:
				beq	$t2 $t0 main_domWordDone
				addi	$t2 $t2 -4
				lw	$a0 0($t2)
				addi	$sp $sp -16
				sw	$t0 0($sp)
				sw	$t1 4($sp)
				sw	$t2 8($sp)
				sw	$t3 12($sp)
				
				jal	printBinary

				la	$a0 spaceStr
				li	$v0 4
				syscall			#add a space just in case

				lw	$t0 0($sp)
				lw	$t1 4($sp)
				lw	$t2 8($sp)
				lw	$t3 12($sp)
				addi	$sp $sp 16
				j	main_domWordLoop
			main_domWordDone:

			la	$a0 nlStr
			li	$v0 4
			syscall
			add	$t0 $t0 $t1	#Next dominator
			addi	$t3 $t3 1
			blt	$t3 $s0 main_printDomLoop

		j	main_done
		main_err:
		la	$a0 noFileStr
		li	$v0 4
		syscall
	main_done:
		li	$v0 10
		syscall


.data
prefix:
	.asciiz "0x"
hexChars:
	.ascii "0123456789ABCDEF"
.text
#-------------
# printHex
#
# ARGS: $a0 = number to print
#-------------
printHex:
	move	$a1 $a0
	la	$a0 prefix
	li	$v0 4
	syscall
	la	$t1 hexChars
	li	$v0 11
	li	$t2 8
	printHex_loop:
		beqz	$t2 printHex_done
		srl	$t0 $a1 28
		add	$t0 $t0 $t1
		lb	$a0 0($t0)
		syscall
		sll	$a1 $a1 4
		addi	$t2 $t2 -1
		j	printHex_loop
	printHex_done:
	jr	$ra

#-----------
# printBinary
# 
# Prints the binary value of a register
#
# ARGS: $a0 = the register to print
#-----------
printBinary:
	move	$t0 $a0
	li	$t2 0
	li	$t3 32
	j	printBinary_loop

	printBinary_space:
		srl	$t4 $t2 2
		sll	$t4 $t4 2
		bne	$t2 $t4 printBinary_loop
		
		#If we got here, print a space
		la	$a0 spaceStr
		li	$v0 4
		syscall

	printBinary_loop:
		srl	$a0 $t0 31
		sll	$t0 $t0 1
		li	$v0 1
		syscall
		addi	$t2 $t2 1
		bne	$t2 $t3 printBinary_space
	jr	$ra
########################## STUDENT CODE BEGINS HERE ############################
#register useage:
#$t9: 
#$t8: number (counter)of total edges, globle within this subfunction
#$a0: 24($sp) stores $a0 initialized address of code
#$t0: is current line of the code(in first loop)
#$t7: is current line's address(in first loop)
#$t6: is 2 array address(temperary)
#$t5: is 1 array address(temperary)current line of leader keeper array
#$t1: is size of block with CURRENT leader
.data
temp:
	.word 1000
.text
getControlFlow:
		li		$t9 0				#the first line of code must be a leader
		la		$t8 temp
		sw		$a0 0($t8)
		
		
		get_size:
				lw	$t0 0($a0)			#$t0 is first line of the code .$t7 is first line's address
				beq	$t0 0xffffffff create_array			#end of the code to test
				addi	$a0 $a0 4				#go to next line of code
				addi	$t9 $t9 2				#size increased by 
				j	get_size

		create_array:
				#creat two array, size of  $t9.array1 must be fully used. array2 is not necessary
				sll		$t9 $t9 2		#two lines in a record and 4 bytes for a code address mult by 4(1. leader address 2. block size)
				move		$a0 $t9
				li		$v0 9
				syscall
				sw		$v0 0($sp)			#allocate the  array1
				lw		$t5 0($sp)			#t5 is array1 address with size of $t9/4 (unit in word)
				
				sll		$t9 $t9 2		#two lines in a record and 4 bytes for a code address mult by 4(1.leader address of source block 2.leader address of target block)
				move		$a0 $t9
				li		$v0 9
				syscall
				sw		$v0 4($sp)			#allocate the  array2
				lw		$t6 4($sp)			#t6 is array2 address
				
				#initial the array1 in memory all words equal to 0 important
				srl		$t9 $t9 2				#t9 = t9/4 become the size of the array in word unit, each unit contain 2 words, a unit is going to match to one line code 
				li		$t0 0					#t0 now is a counter of word in array1
			initialize_loop:
					beq	$t0 $t9 start	#done the initialization of the array1 
					sw	$zero 0($t5)	#initialize both arrays
					sw	$zero 0($t6)	#....
					addi	$t5 $t5 4		#go to next line
					addi	$t0 $t0 1		#counter ++
					j	initialize_loop
					
		start:		
				la	$t8 temp
				lw	$a0 0($t8)		#renew the $a0 from $t8
	
				#reread the code in memory, and put necessary stuff in to the two arrays	
				li	$t8 0					#there is no leader right now(no code read yet) $t8 is counter for the code line
				#make a switch for checking if previous line of code is a branch or jump
				li	$t3 0					# closed at first since previous line is none (not branch orjump)
				
				
													
		record1_2:	
				lw	$t0 0($a0)				# check first,$t0 now is the current line again
				#check if this line is code for testing			
				beq	$t0 0xffffffff first2_done	#code is not empty is checked
				
				beq	$t8 0 save_first_immediteFollow_leader			#the first line of code must be a leader
				beq	$t3 1 save_first_immediteFollow_leader			#if previous is a branch or jump, go saving
			first_immediteFollow_leader_back:				#including every immeditely following those branch or jump ,and the first line of the whole code
				#selection (branch,jump,others) by op code	
				li	$t2 0xfc00				#create a mask $t2 for op code
				sll	$t2 $t2 16	
				and	$t2 $t0 $t2				#musk out op code to $t2
							
				#check if this line is a branch
				beq	$t2 0x10000000 branch_save	#beq $s, $t, offset
				beq	$t2 0x04000000 branch_save	#bgez $s, offset
				beq	$t2 0x04000000 branch_save	#bgezal $s, offse
				beq	$t2 0x1c000000 branch_save	#bgtz $s, offset
				
				beq	$t2 0x18000000 branch_save	#blez $s, offset
				beq	$t2 0x04000000 branch_save	#bltz $s, offset
				beq	$t2 0x04000000 branch_save	#bltzal $s, offset
				beq	$t2 0x14000000 branch_save	#bne $s, $t, offset
				#check if this line is a jump
				beq	$t2 0x08000000 jump_save		#j target
				beq	$t2 0x0c000000 jump_save		#jal target
				beq	$t2 0x00000000 super_jump_save		#jr $s
				#none of j or b, but the first line:
			BJ_back:
				#every each line of code reading ,we need to move to next
				addi	$a0 $a0 4			#go to next line for the code
				addi	$t5 $t5 8			#go to the next place for next leader
			
				j	record1_2
			branch_save:
					li	$t3 1					#open the switch for next line saving-------------------------------------------
					
					#SAVE THE TARGET CODE TO CORESPONDING PLACE
					sll	$t1 $t0 16
					srl	$t1 $t1 16		# let $t1 have the offset
					#cmputing the branch target address,store it to $t1
					sll	$t1 $t1 16
					sra	$t1 $t1 16
					sll	$t1 $t1 2
					addi	$t1 $t1 4
					add	$t1 $t1 $a0	
					
					#save target to position of 0(2*($t1-$a0)+$t5)that is 0(2*distanceInCodeMemory + address_of_current_line_in_array1)
					
					lw	$t2 0($t1)				# $t2 now is branch target code
					
					#cmputing where do we need to store the target code in array1
					sub	$t4 $t1 $a0
					sll	$t4 $t4 1				#mult by 2
					add	$t4 $t4 $t5
					sw	$t2 0($t4)				#Save the target code to the coresponding place in array1
					j	BJ_back
			jump_save:
					li	$t3 1					#open the switch for next line read
					#SAVE THE TARGET CODE TO CORESPONDING PLACE
					sll	$t0 $t0 6
					srl	$t0 $t0 6				# let $t0 have the offset
					sll	$t0 $t0 2
					#cmputing the target address for the jump
					srl	$t1 $a0 28
					sll	$t1 $t1 28				
					or	$t1 $t1 $t0				#t1 has the target address
					#save target to position of 0(2*($t1-$a0)+$t5)that is 0(2*distanceInCodeMemory + address_of_current_line_in_array1)
					
					lw	$t2 0($t1)				# $t2 now is branch target code
					
					#cmputing where do we need to store the target code in array1
					sub	$t4 $t1 $a0
					sll	$t4 $t4 1				#mult by 2
					add	$t4 $t4 $t5
					sw	$t2 0($t4)				#Save the target code to the coresponding place in array1
					j	BJ_back
					
			super_jump_save:		#this case does not need to cmput the target 
					li	$t3 1					#open the switch for next line read
					j	BJ_back
				
			save_first_immediteFollow_leader:   # whenever save a line of code is required, come here to take a record
					
					sw	$t0 0($t5)
					addi	$t8 $t8 1
					j	first_immediteFollow_leader_back
					
		first2_done:
		
			jr		$ra

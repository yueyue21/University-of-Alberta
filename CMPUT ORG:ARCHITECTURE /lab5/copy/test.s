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
#$t8: for temp 's address
#$a0: 24($sp) stores $a0 initialized address of code
#$t0: is current line of the code(in first loop)
#$t7: is current line's address(in first loop)
#$t6: is 2 array address(temperary)
#$t5: is 1 array address(temperary)current line of leader keeper array
#$t1: is size of block with CURRENT leader
.data
temp:
	.word 0:20 #0: original $a0    4: number of lines in code	8:size of array1 12: size of array2 
array1:
	.word 0:1600
array2:
	.word 0:3200
array3:
	.word 0:1000
.text
getControlFlow:
		li		$t9 0				#the first line of code must be a leader
		la		$t8 temp
		sw		$a0 0($t8)
		
		get_size:
				lw	$t0 0($a0)				#$t0 is first line of the code .$t7 is first line's address
				beq	$t0 0xffffffff create_array			#end of the code to test
				addi	$a0 $a0 4				#go to next line of code
				addi	$t9 $t9 1				#size increased by 1
				j	get_size
		
		create_array:
				sw	$t9 4($t8)				#save the size of code
				la	$t1 array1
				la	$t2 array2
				la	$t3 array3
				#initial the array1,array2,array3 in memory all words equal to 0 important
				li	$t0 0					#t0 now is a counter of word in array1
				sll	$t9 $t9 2
				initialize_loop:
					beq	$t0 $t9 start	#done the initialization of the array1 
					sw	$zero 0($t1)	#initialize both arrays
					sw	$zero 0($t2)	#....
					sw	$zero 0($t3)
					addi	$t1 $t1 4		#go to next line
					addi	$t2 $t2 4		#....
					addi	$t3 $t3 4
					addi	$t0 $t0 1		#counter ++
					j	initialize_loop
		start:		
				la	$t8 temp
				lw	$a0 0($t8)				#renew the $a0 from $t8
				la	$t5 array1
				la	$t6 array2
				li	$t7 0					#address of leader for the current block(for array2)
				#reread the code in memory, and put necessary stuff in to the two arrays	
				li	$t8 0					#there is no leader right now(no code read yet) $t8 is counter for the code line
				#make a switch for checking if previous line of code is a branch or jump
				li	$t3 0					# closed at first since previous line is none, not jump
				li	$t9 0					#closed at first since previous line is none, not branch
		record1_2:	
				lw	$t0 0($a0)				# check first,$t0 now is the current line again
				#check if this line is code for testing			
				beq	$t0 0xffffffff arrange_array1	#code is not empty is checked
				
				beq	$t8 0 save_first_immediteFollow_leader			#the first line of code must be a leader
				beq	$t3 1 save_follow_jump_leader			#if previous is a jump, go saving
				beq	$t9 1 save_follow_branch_leader		#if previous is a branch, go saving
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
				#if none of above then check if it is jr $s
				beq	$t2 0x00000000 further_check		#jr $s
				
			BJ_back:     #none of j or bafter checking the first line,previous line is j or b,DO NOTHING:
				#every each line of code reading ,we need to move to next
				addi	$a0 $a0 4				#go to next line for the code
				addi	$t5 $t5 8				#go to the next place for next leader
			
				j	record1_2
			branch_save:
					li	$t9 1					#open the switch for next line saving
					#SAVE THE TARGET CODE TO CORESPONDING PLACE
					#cmputing the branch target address,store it to $t1
					sll	$t1 $t0 16
					sra	$t1 $t1 16
					sll	$t1 $t1 2
					addi	$t1 $t1 4
					#sll	$t1 $t1 14
					#sra	$t1 $t1 14
					add	$t1 $t1 $a0	
					
					
					#save target to position of 0(2*($t1-$a0)+$t5)that is 0(2*distanceInCodeMemory + address_of_current_line_in_array1)
					
					#lw	$t2 0($t1)				# $t2 now is branch target code
					
					#cmputing where do we need to store the target code in array1
					sub	$t4 $t1 $a0
					sll	$t4 $t4 1				#mult by 2
					add	$t4 $t4 $t5
					
					sw	$t1 0($t4)				#Save the target address to the coresponding place in array1
					##sw	$a0 4($t4)
					move	$s1 $t1				#hold target address for next line of code comparision 
					j	target_next_check	
				target_next_check_back:
					
					sw	$t7 8($t6)				# 2 times for a branch. save address of current leader to 0(current_address_of_array2+8) 
					sw	$t1 12($t6)				# save to 0(current_address_of_array2+12)
					addi	$t8 $t8 1
					j	BJ_back
			jump_save:
					li	$t3 1					#open the switch for next line read
					#SAVE THE TARGET CODE TO CORESPONDING PLACE
					sll	$t0 $t0 6
					srl	$t0 $t0 6				# let $t0 have the offset
					sll	$t0 $t0 2
					#cmputing the target address for the jump
					addi	$t1 $a0 4
					srl	$t1 $t1 28
					sll	$t1 $t1 28				
					or	$t1 $t1 $t0				#t1 has the target address
					#save target to position of 0(2*($t1-$a0)+$t5)that is 0(2*distanceInCodeMemory + address_of_current_line_in_array1)
					
					lw	$t2 0($t1)				# $t2 now is branch target code
					
					#cmputing where do we need to store the target code in array1
					sub	$t4 $t1 $a0
					sll	$t4 $t4 1				#mult by 2
					add	$t4 $t4 $t5
					sw	$t1 0($t4)				#Save the target address to the coresponding place in array1
					sw	$t1 4($t6)				#only save the target address to the next
					addi	$t8 $t8 1
					j	BJ_back
					
			target_next_check:
					
					j	target_next_check_back
			further_check:
					sll	$t2 $t0 28 
					srl	$t2 $t2 28
					beq	$t2 8 super_jump_save		#if it is 8 on the last 4 digits,after checking op code is 0, itis jump to register
					j	BJ_back				#else jump back
			super_jump_save:						#this case does not need to cmput the target 
					li	$t3 1					#open the switch for next line read
					j	BJ_back
				
			save_first_immediteFollow_leader:   # whenever save a line of code is required, come here to take a record
					
					sw	$a0 0($t5)
					##sw	$a0 4($t5)
					sw	$a0 0($t6)		#save the first leader
					move	$t7 $a0		#store the address of current leader(hold it in $t7) 
					addi	$t8 $t8 1
					j	first_immediteFollow_leader_back	
			save_follow_branch_leader:   # whenever save a line of code is required, come here to take a record
					
					sw	$a0 0($t5)
					##sw	$a0 4($t5)
					sw	$a0 4($t6)		#take care the previous leader
					addi	$t6 $t6 16		#once 4 words change the frame pointer for array2
					move	$t7 $a0		#new leader becomes temp block leader (hold it in $t7)
					sw	$a0 0($t6)
					addi	$t8 $t8 1
					li	$t9 0
					j	first_immediteFollow_leader_back
					
			save_follow_jump_leader:   # whenever save a line of code is required, come here to take a record
					sw	$a0 0($t5)
					##sw	$a0 4($t5)
					addi	$t6 $t6 8		#once 2 words   change the frame pointer for array2
					move	$t7 $a0		#new leader becomes temp block leader (hold it in $t7)
					sw	$a0 0($t6)		
					addi	$t8 $t8 1
					li	$t3 0
					j	first_immediteFollow_leader_back	
					
					
		arrange_array1:
					la	$t1 array1
					sub	$t5 $t5 $t1
					srl	$t5 $t5 2			#get the size of code
					li	$t8 0				#counter for lines
					li	$t7 0 			#counter for leaders
					loop:
						beq	$t8 $t5 add_last
						lw	$t0 0($t1)
						beq	$t8 0 first_save_leader		#first line is not empty
						bne	$t0 0 save_leader			#not empty 
						beq	$t0 0 add_block_size		# empty
					add_block_size_back:
					save_leader_back:
					first_save_leader_back:	
						addi	$t1 $t1 8
						addi	$t8 $t8 2
						j	loop
					add_last:
						sw	$t2 4($t4)
						j	restart	
						
					save_leader:
						sw	$t2 4($t4)		#save previous block size
						add	$t4 $t4 8
						sw	$t0 0($t4)		#save current line to previous location
						sw	$0  0($t1)		#remove current line
						#move	$t4 $t1		#hold current position
						li	$t2 1			#reinitialize the current block size to 1
						addi	$t7 $t7 1		#add leader counter by 1
						j	save_leader_back
					add_block_size:
						addi	$t2 $t2 1		#increase the current block size by 1
						j	add_block_size_back
					first_save_leader:
						move	$t4 $t1		#hold current position
						sw	$t0 0($t4)		#save the first line
						li	$t2 1			#initialize the current block size to 1
						li	$t7 1			#counter for leaders
						j	first_save_leader_back
#-----------------------------------read the code again-------------------------------------------------------------------------------------
#store each leader's edge to array2
		restart:		
				la	$t8 temp
				sw	$t7 8($t8)				#save the number of leaders
				la	$t6 array2				#address of leader for the current block(for array2)
				la	$a0 array1				
				#reread the code in memory, and put necessary stuff in to the two arrays	
				li	$t8 0					# $t8 is counter for the code line
				li	$t3 0					#counter for edges
	
		record2:	
				#check if this line is code for testing
				beq	$t8 $t7 arrange_array2		#code is not empty is checked
				lw	$t9 0($a0)				# $t9 is the leader address in current block	
				lw	$t4 4($a0)				#size of block
				 
				sub	$t4 $t4 1
				sll	$t4 $t4 2
				add	$t9 $t4 $t9				#t9 now have the address of code at the end of current block in code
				lw	$t0 0($t9)				#$t0 the actual code (leader)
				
				#selection (branch,jump,others) by op code	
				li	$t2 0xfc00				#create a mask $t2 for op code
				sll	$t2 $t2 16	
				and	$t2 $t0 $t2				#musk out op code to $t2			
				
				#check if this line is a branch
				beq	$t2 0x10000000 branch_save2	#beq $s, $t, offset
				beq	$t2 0x04000000 branch_save2	#bgez $s, offset
				beq	$t2 0x04000000 branch_save2	#bgezal $s, offse
				beq	$t2 0x1c000000 branch_save2	#bgtz $s, offset
				
				beq	$t2 0x18000000 branch_save2	#blez $s, offset
				beq	$t2 0x04000000 branch_save2	#bltz $s, offset
				beq	$t2 0x04000000 branch_save2	#bltzal $s, offset
				beq	$t2 0x14000000 branch_save2	#bne $s, $t, offset
				#check if this line is a jump
				beq	$t2 0x08000000 jump_save2		#j target
				beq	$t2 0x0c000000 jump_save2		#jal target
				#if none of above then check if it is jr $s
				beq	$t2 0x00000000 further_check2		#jr $s
			else:
				#ELSE
				lw	$t9 0($a0)	
				sw	$t9 0($t6)				#save the address of first leader
				sw	$0 8($t6)
				sw	$0 12($t6)	
				addi	$t5 $t9 4
				sw	$t5 4($t6)
				addi	$t3 $t3 1				#edge increased by 1
			BJ_back2:     #none of j or bafter checking the first line,previous line is j or b,DO NOTHING:
				addi	$a0 $a0 8					#go to next line for the leaders
				addi	$t8 $t8 1
				addi	$t6 $t6 16					#move to next block in array2
				j	record2
					
			branch_save2:
					#cmputing the branch target address,store it to $t1
					sll	$t1 $t0 16
					sra	$t1 $t1 16
					sll	$t1 $t1 2
					addi	$t1 $t1 4
					add	$t1 $t1 $t9				#$t1 is the address of target code 
					addi	$t5 $t9 4				#$t5:current next 
					
					lw	$t9 0($a0)	
								
					beq	$t5 $t1 target_equal_branch_next		#if current's next == target save once
					blt	$t1 $t5 target_smaller_branch_next
					#ELSE target > branch next
					sw	$t9 8($t6)				# 2 times for a branch. save address of current leader to 0(current_address_of_array2+8) 
					sw	$t9 0($t6)				#save the address of first leader
					sw	$t1 12($t6)				# save to 0(current_address_of_array2+12)	
					sw	$t5 4($t6)				
					addi	$t3 $t3 2				#edge increased by 2
					j	BJ_back2
				target_equal_branch_next:
					sw	$t5 4($t6)
					sw	$t9 0($t6)				#save the address of first leader
					sw	$0 8($t6)
					sw	$0 12($t6)	
					addi	$t3 $t3 1				#edge increased by 1
					j	BJ_back2
				target_smaller_branch_next:
					sw	$t9 8($t6)	
					sw	$t9 0($t6)				#save the address of first leader			
					sw	$t1 4($t6)				#target at lower place
					sw	$t5 12($t6)				# current next at higher place
					addi	$t3 $t3 2				#edge increased by 2
					j	BJ_back2
				
			jump_save2:
					sll	$t0 $t0 6
					srl	$t0 $t0 6				# let $t0 have the offset
					sll	$t0 $t0 2
					#cmputing the target address for the jump
					addi	$t1 $a0 4
					srl	$t1 $t1 28
					sll	$t1 $t1 28				
					or	$t1 $t1 $t0				#t1 has the target address
					lw	$t9 0($a0)
					sw	$t9 0($t6)				#save the address of first leader
					sw	$t1 4($t6)				#only save the target address to the next
					sw	$0 8($t6)
					sw	$0 12($t6)
					addi	$t3 $t3 1				#edge increased by 1
					j	BJ_back2
					
			further_check2:
					sll	$t2 $t0 28 
					srl	$t2 $t2 28
					beq	$t2 8 BJ_back2		#if it is 8 on the last 4 digits,after checking op code is 0, itis jump to register
					j	else	
			
		arrange_array2:
					la	$t8 temp
					sw	$t3 12($t8)			#t3 still have the size of array2
					la	$t1 array2			#t1 is current address for array2
					li	$t6 0				#a switch for previous is 0 at first previous is not zero
					li	$t4 0				#counter for 2 word in array2 increased by 1 on successfully arranged an edge
					li	$t7 0				#counter for current place have a 0 word start
				loop2:
						beq	$t4  $t3 first2_done			#jump out loop
						lw	$t0 0($t1)					#$t0: current leader line
						beq	$t0 $0 save_current_address2
						#not zero then:
						bne	$t6 $0 resave_current_line		#if previous is not 0  pass 
						addi	$t4 $t4 1					#successfully arranged an edge add counter  by 1
				zero_back:
						addi	$t1 $t1 8
						j	loop2	
				save_current_address2:
						beq	$t6 1 zero_back				#already_met_zero
						move	$t5 $t1					#hold current address in $t5 avaiable to store
						li	$t6 1						
						j	zero_back	
				resave_current_line:					
						sw	$t0 0($t5)
						lw	$t0 4($t1)					#load the next line
						sw	$t0 4($t5)
						addi	$t5 $t5 8					#move to the next place
						addi	$t4 $t4 1					#successfully arranged an edge add counter  by 1
						j	zero_back					
#---------------------------------------------------------------------------------------------------------------------------------------					
		first2_done:
			li	 $t8 15
			addi		$t3 $t3 10
			la		$t8	temp
			lw		$t7   8($t8)
			lw		$t3	12($t8)
			#addi		$t3 $t3 10
			move		$v0	$t7
			move		$v1	$t3
		
			la		$t0	array1
			sw		$t0	0($sp)
			la		$t0	array2
			sw		$t0 	4($sp)
			jr		$ra
			
			
			
			
			

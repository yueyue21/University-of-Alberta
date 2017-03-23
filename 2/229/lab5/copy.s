		start:		
				#reread the code in memory, and put necessary stuff in to the two arrays	
				li	$t8 0					#there is no leader right now(no code read yet) $t8 is counter for the code line
				sw	$a0 68($sp)
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
					li	$v0, 1
					move	$a0, $t5
					syscall
					li	$v0 10
					syscall
					sw	$t0 0($t5)
					addi	$t8 $t8 1
					j	first_immediteFollow_leader_back
					
		first2_done:
		
			jr		$ra


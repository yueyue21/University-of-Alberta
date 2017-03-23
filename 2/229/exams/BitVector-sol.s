/*
 * BitVector.s
 * 
 *
 * Created by J. Nelson Amaral on 2012-10-15.
 * Copyright 2012 University of Alberta. All rights reserved.
 */

WordAddress receives a, the address of the first word where the bit vector 
is stored and a bit position k. It returns w, the address of the word that 
contains the bit k of the vector

Parameters:    $a0: a, the memory address of the first word of the bit vector
			   $a1: k, the position of a bit in the vector
Return value:  $v0: w, the address of the word the contains bit k
Examples:      WordAddress(0x8000 0000, 0)  = 0x8000 0000 
			   WordAddress(0x8000 0000, 31) = 0x8000 0000
			   WordAddress(0x8000 0000, 35) = 0x8000 0004
              
WordAddress:
				addi	$t0, $0, 32
				move	$v0, $a0				# $v0 <-- a
				blt		$a1, $t0, gotAddress	# if k < 32 goto gotAddress
nextWord:		addi	$a1, $a1, -32			# k <-- k - 32
				addi	$v0, $v0, 4				# a <-- a + 4
				bge		$a1, $t0, nextWord		# if k >= 32 foto next word
gotAddress:
				jr      $ra
				
---------------
Another, more elegant, solution --- thanks to some students for that --- is as follows:

WordAddress:
				srl		$t0, $a1, 5				# $t1 <-- k/32 = number of words before word with k
				sll		$t1, $t0, 2				# $t1 <-- number of bytes before word with k
				addi	$v0, $a0, $t1			# $v0 <-- address of word that has bit k
				jr		$ra
------------------------------------------------------------------------------
GenMask receives a bit position k and returns m, a mask with all zeros 
except for a 1 in the bit corresponding to the position of the bit k in 
the word that stores that bit. Bits within a word are numbered from 
the least significative to the most significative as follows:

31        27        23        19               7 6 5 4   3 2 1 0
 b b b b   b b b b   b b b b   b b b b  ....   b b b b   b b b b

Parameters:    $a0: k, the position of a bit in the vector
Return value:  $v0: m, bit mask for k at its word  
Examples:      GenMask(7)   = 0x0000 0080
               GenMask(35)  = 0x0000 0008
			   GenMask(128) = 0x0000 0001
			   
GenMask:
				addi	$t0, $0, 32            # $t0 <-- 32
				addi	$v0, $0, 1             # $v0 <-- 1
				blt		$a0, $t0, gotPosition  # if k<32 goto gotPosition
subAgain:		addi	$a0, $a0, -32          # k <-- k-32
				bge		$a0, $t0, subAgain     # if k >= 32 goto subAgain
gotPosition:    sllv	$v0, $v0, $a0          # mask <-- mask << k
				jr      $ra

----------------
Another, more elegant, solution --- thanks to some students for that --- is as follows:

GenMask:		
				sll		$t0, $a0, 27		   # $t0 <-- bbbb b000 .... 0000
				srl		$t1, $t0, 27		   # $t1 <-- k%32 (rest of division by 32)
				                               # this is the position of bit k within its word
				addi	$v0, $zero, 1		   # $v0 <-- 0x0000 0001
				sllv	$v0, $v0, $t1          # $v0 <-- mask with a 1 in position corresponding to bit k
				jr		$ra
				
There are many ways to compute k%32. One could use a mask:

GenMask:		
				addi	$t0, $zero, 0x001F	   # $t0 <-- 0000 0000 .... 1 1111
				and		$t1, $a0, t0		   # $t1 <-- k%32 (rest of division by 32)
				addi	$v0, $zero, 1		   # $v0 <-- 0x0000 0001
				sllv	$v0, $v0, $t1          # $v0 <-- mask with a 1 in position corresponding to bit k
				jr		$ra
				
Some used the div instruction (but many forgot that div takes two arguments and writes the result in registers hi and lo)

GenMask:		
				addi	$t0, $zero, 32         # $t0 <-- 32
				div		$a0, $t0			   # $lo <-- floor(k/32); $hi <-- k % 32
				mfhi	$t1					   # $t1 <-- k%32 (rest of division by 32)
				addi	$v0, $zero, 1		   # $v0 <-- 0x0000 0001
				sllv	$v0, $v0, $t1          # $v0 <-- mask with a 1 in position corresponding to bit k
				jr		$ra

-----------------------------------------------------------------------------
SetBit receives a, the address of a bit vector and k, a bit position and sets 
that bit to 1 leaving all other bits unmodified.

Parameters:   $a0: a, the address of a bit vector
			  $a1: k, the position of a bit in the vector
Return value: None
Execution:    May change the value of bit k in the bit vector.

SetBit:
				addi $sp, $sp, -16
				sw	 $s0, 0($sp)		# save $s0
				sw	 $s1, 4($sp)		# save $s1
				sw	 $s2, 8($sp)		# save $s2
				sw   $ra, 12($sp)       # save $ra
				move $s0, $a0			# $s0 <-- a
				move $s1, $a1			# $s1 <-- k
				jal  WordAddress  
				move $s2, $v0			# $s2 <-- WordAddress
				move $a0, $s1			# $a0 <-- k
				jal  GenMask
				lw	 $t0, 0($s2)		# $t0 <-- word to be modified
				or   $t1, $t0, $v0      # $t1 <-- word with bit set
				sw   $t1, 0($s2)		# write bit to vector a
				lw	 $s0, 0($sp)		# restore $s0
				lw	 $s1, 4($sp)		# restore $s1
				lw	 $s2, 8($sp)		# restore $s2
				lw   $ra, 12($sp)		# restore $ra
				addi $sp, $sp, 16
				jr $ra

----------------------------------------------------------------------------
BitwiseAnd receives a and b, the addresses of two bit vectors A and B of same 
length n and executes the following operation:

               A <-- A AND B

Parameters:   $a0: a, the address of a bit vector A
              $a1: b, the address of a bit vector B
			  $a2: n, lenght of bit vectors A and B
Return value: None
Execution:    Changes the value of bit vector A		
	   
BitwiseAnd:
				addi $sp, $sp, -12
				sw	 $s0, 0($sp)	# save $s0
				sw	 $s1, 4($sp)	# save $s1
				sw   $ra, 8($sp)    # save $ra
				move $s0, $a0		# $s0 <-- pa = a
				move $s1, $a1		# $s1 <-- pb = b
				move $a1, $a2
				jal  WordAddress
				move $t0, $v0		# $t0 <-- address of last word of vector a
next:			lw   $t1, 0($s0)	# $t1 <-- *pa
				lw   $t2, 0($s1)	# $t2 <-- *pb
				and  $t3, $t1, $t2	# $t3 <-- $t1 AND $t2
				sw   $t3, 0($s0)	# *pa <-- $t3
				addi $s0, $s0, 4	# pa++
				addi $s1, $s1, 4	# pb++
				ble  $s0, $t0, next	# if pa <= last word of vector a goto next
				lw	 $s0, 0($sp)	# restore $s0
				lw	 $s1, 4($sp)	# restore $s1
				lw   $ra, 8($ra)    # restore $ra
				addi $sp, $sp, 12				
				jr $ra

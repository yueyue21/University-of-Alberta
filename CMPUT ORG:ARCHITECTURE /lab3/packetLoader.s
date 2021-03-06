#--------------------------------------------------------
#lab assignment3
#student: 	Yue YIN
#student 	ID: 1345121
#Unix ID:    	yyin
#lab Section	D05
#---------------------------------------------------------
# register used description:
#	$a0: arguement, GLOBAL changed only twice, and get back at the first time
#	$v0,$v1: returned values
#	$t0: local, changed a lot 
#	$t1,$t2,$t3,$t4: local, changed a lot
#	$s0: refers to the computed check sum always,GLOBAL
#	$t8,$t9: two standard masks for upper and lower half of a word in check3
#	$t6: refers to the Packet Header Length alway in check3
#	$t7: refers to the number of lines that are added in check3
#	$t5: refers as a keeper of the Header Checksum in the given code
#-------------------------------------------------------

.data

packetFile:
.asciiz "./packet.in"
.align 2
packetData:
.space 200

.text
main:
#Open the packet file
	la	$a0 packetFile #filename
	li	$a1 0x00 #flags
	li	$a2 0x0644 #file mode
	li	$v0 13 
	syscall #file_open
#Read into buffer
	move 	$a0 $v0
	la	$a1 packetData
	li	$a2 200
	li	$v0 14
	syscall #file_read
#Close the reading file
	li	$v0 16
	syscall

#Run the appended solution
	la	$a0 packetData
	jal	handlePacket
################### Here the solution can be checked for accuracy #######
	

	li	$v0 10
	syscall
################### Student handlePacket code begins here ###############

handlePacket:
	move	$t7 $a0		#keep the value of a0 at t7
	lw	$t0 0($a0)	#get the line contain header length	
	sll	$t0 $t0 28
	srl	$t0 $t0 28	#$t0 have the header length
	move	$t9 $t0		#$t9 <- $t0 for later using
	li	$t8 1		#initialize the counter for loop at 1
loop:	#switch big endian to little endian
	beq	$t8 $t9 check	#go to check if we have switched all
				#the header length
	#creat 4 masks to get each byte
	addi	$t1 $t1 0x00ff
	addi	$t2 $t2 0x00ff
	addi	$t3 $t3 0x00ff
	addi	$t4 $t4 0x00ff
	sll	$t2 $t2 8
	sll	$t3 $t3 16
	sll	$t4 $t4 24
	#get each byte individually
	lw	$t0 0($a0)
	and	$t1 $t1 $t0
	and	$t2 $t2 $t0
	and	$t3 $t3 $t0
	and	$t4 $t4 $t0
	#shift
	sll	$t1 $t1 24
	sll	$t2 $t2 16
	srl	$t3 $t3 16
	srl	$t4 $t4 24
	#modify
	or	$t0 $t1 $t2
	or	$t0 $t0 $t3
	or	$t0 $t0 $t4
	#save
	sw	$t0 0($a0)
	addi	$a0 $a0 4	#add the initial address by 4
				#to get to the next line
	addi	$t8 $t8 1	#add counter by 1
	j	loop
check:
	move	$a0 $t7		#give back the original value of $a0
	#check1 if it is IPv4 version
	lw	$t0 0($a0)	#load the first line of the Packet
	srl	$t0 $t0 28
	bne	$t0 4 error1 	#branch to error1 if it is not IPv4

	#check2 if TTL is great than 1
	move	$t9 $a0	
	addi	$t9 $t9 8	#go to the 3 line
	lw	$t0 0($t9)	#$t0 = TTL line
	sll	$t2 $t0	8	#$t2 = everything beside TTL in current line
	srl	$t2 $t2 8	#make position in TTL become 0
	srl	$t0 $t0 24	#make $t0 = TTL
	slti	$t1 $t0 2
	beq	$t1 1 error2	#if TTL<2 go to error2
	addi	$t0 $t0 -1
	or	$t0 $t0 $t2	#combine these two segments in 0($t9)
	sw	$t0 0($t9)	#over write the TTL with TTL-1

	#check3 header checksum is vlid
	#$t6 <- header length (for start)
	lw	$t6 0($a0)
	sll	$t6 $t6 4
	srl	$t6 $t6 28	#get the header length to $t6
	#creat two masks t8(upper) and t9(lower)
	li	$t8 0xffff
	sll	$t8 $t8 16
	li	$t9 0xffff
	#say $s0 have the value of accumulator
	li	$t7 0		#set a counter for the times of addtions
	li	$s0 0		#initialize the $s0 to be 0
	move	$t0 $a0		#initialize $t0 as the original address
start:#done the first line's addition, and loop the following addition
	beq	$t7 $t6 compare	#addition complete,go to compare
	lw	$t1 0($t0)	#load the word of current address
	and	$t2 $t1 $t8	#$t2 <- upper of the word
	and	$t1 $t1 $t9	#$t1 <- lower of the word
	srl	$t2 $t2 16	#>> by 16 for the upper half
	#check if there is a carry
	srl	$t3 $t1 15	# srl the lower 15 bits
	srl	$t4 $t2 15	# srl the upper 15 bits
	beq	$t3 0 addimm 	#add immeditely if there is one 0
	beq	$t4 1 carry	#if the 1st bit of upper is 1,go to carry
	j	start
compare:
	beq	$s0 $t5 error3	#compare the number computed and given
	#reset the header code into original endian
	move	$t7 $a0		#keep the value of a0 at t7
	lw	$t0 0($a0)	#get the line contain header length	
	sll	$t0 $t0 4	#header length at position of 0x0f000000
	srl	$t0 $t0 24	#$t0 have the header length
	move	$t9 $t0		#$t9 <- $t0 for later using
	li	$t8 1		#initialize the counter for loop at 1
loop1:	#switch little endian to big endian
	beq	$t8 $t9 done	#go to done if we have switched all
				#the header 
	#creat 4 masks to get each byte
	addi	$t1 $t1 0x00ff
	addi	$t2 $t2 0x00ff
	addi	$t3 $t3 0x00ff
	addi	$t4 $t4 0x00ff
	sll	$t2 $t2 8
	sll	$t3 $t3 16
	sll	$t4 $t4 24
	#get each byte individually
	lw	$t0 0($a0)
	and	$t1 $t1 $t0
	and	$t2 $t2 $t0
	and	$t3 $t3 $t0
	and	$t4 $t4 $t0
	#shift
	sll	$t1 $t1 24
	sll	$t2 $t2 16
	srl	$t3 $t3 16
	srl	$t4 $t4 24
	#modify
	or	$t0 $t1 $t2
	or	$t0 $t0 $t3
	or	$t0 $t0 $t4
	#save
	sw	$t0 0($a0)
	addi	$a0 $a0 4	#add the initial address by 4
				#to get to the next line
	addi	$t8 $t8 1	#add counter by 1
	j	loop1
done:	#every thing done
	li	$v0 1		#return 1
	move	$v1 $t7		#give the original value of $a0 that was stored in $t7
exit:	
	jr	$ra
	
carry:#if there is a carry accumulator + 1
	addi	$s0 $s0 1
addimm:#add the two half words to $s0
	beq	$t7 2 special	#meet the Header Checksum line 
addimm1:#this label only for the special
	add	$t1 $t1 $t2
	add	$s0 $s0 $t1	# they all go to $s0
	addi	$t0 $t0 4	#plus the previous address by 4
	addi	$t7 $t7 1	#$t7 ++ (counter++)
	j	start
special:
	move	$t5 $t1		#keep the Header Checksum at $t5
	li	$t1 0		#set $t1 to 0
	j	addimm1
error1:#not a IPv4 version
	li	$v1 2
	li	$v0 0
	j	exit
error2:#TTL zeroed
	li	$v1 1
	li	$v0 0
	j	exit
error3:#Checksum fail
	li	$v1 0
	li	$v0 0
	j	exit

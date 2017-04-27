#-------------------------------
# Packet Forwarding Student Test Environment
# Author: Taylor Lloyd
# Date: June 4, 2012
#
# This code loads in a packet from a file named 
# packet.in and calls handlePacket with the 
# appropriate argument.
#
# Nothing is done with the returned values, it is up
# to the student to check them.
#
#-------------------------------

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
	lb	$t0 3($a0)
	sll	$t0 $t0 28
	srl	$t0 $t0 28	#$t0 have the header length
	move	$t9 $t0		#$t9 <- $t0
	li	$t8 1		#initialize the counter for loop at 1
	move	$t7 $a0		#keep the value of a0 at t7
loop:	#switch big endian to little endian
	beq	$t8 $t9 check	#go to check if we have switched all
				#the header length
	lb	$t0 0($a0)
	lb	$t1 1($a0)
	lb	$t2 2($a0)
	lb	$t3 3($a0)
	sb	$t3 0($a0)
	sb	$t2 1($a0)
	sb	$t1 2($a0)
	sb	$t0 3($a0)
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
	lb	$t0 0($t9)	#$t0 = TTL
	slti	$t1 $t0 2
	beq	$t1 1 error2	#if TTL<2 go to error2
	addi	$t0 $t0 -1
	sb	$t0 0($t9)	#over write the TTL with TTL-1

	#check3 header checksum is vlid
	#creat two masks t8(upper) and t9(lower)
	li	$t8 0xffff
	sll	$t8 $t8 4
	li	$t9 0xffff
	#say $s0 have the value of accumulator
	li	$s0 0		#initialize the $s0 to be 0
	move	$t0 $a0		#initialize $t0 as the original address
	li	$t7 0		#set a counter for the times of addtions
	lw	$t1 0($t0)	#load the first line
	and	$t1 $t1 $t9	#$t1 <- lower
	and	$t2 $t1 $t8	#$t2 <- upper
	srl	$t2 $t2 16	#>> by 16 for the upper half
	#check if there is a carry using $t3 $t4 for lower & upper and add
	srl	$t3 $t1 15	# srl the lower 15 bits
	srl	$t4 $t2 15	# srl the upper 15 bits
	beq	$t3 0 addimm 	#add immeditely if there is one 0
	beq	$t4 1 carry	#if the 1st bit of upper is 1,go to carry
	#$t6 <- header length 
	lb	$t6 0($a0)
	sll	$t6 $t6 28
	srl	$t6 $t6 28	#get the header length to $t6
	#change $t6 to the times of addition for the Header Checksum
	sll	$t6 $t6 2	# $t6 multiply by 2
	addi	$t6 $t6 -1	# number of total half word supposed to be 
				# add up is 2*header_length-1
				# using 2*header_length-1 is necessary for
				# branch to compare based on the 'skip',since
				# I need to add the counter by one in skip.
				# the actual number is 2*header_length-2
start:#done the first addition, and loop the following addition
	addi	$t0 $t0 2	#plus t0 by 2 byte
	beq	$t7 4 skip	#meet the Header Checksum with the 
				#initial address $t0 plus by 2
	lw	$t1 0($t0)	#load the word of current address
	and	$t1 $t1 $t9	#$t1 <- lower of the word
	move	$t2 $s0
	beq	$t7 $t6 compare	#branch to compare if 4 additions has been conducted
				#with having loaded the CheckSum to $t1 and total 
				#addition result moved to $t2
	#check if there is a carry
	srl	$t3 $t1 15	# srl the lower 15 bits
	srl	$t4 $t2 15	# srl the upper 15 bits
	beq	$t3 0 addimm 	#add immeditely if there is one 0
	beq	$t4 1 carry	#if the 1st bit of upper is 1,go to carry
	j	start
compare:
	beq	$t1 $t2 error3	#go to error3 if Checksum fail
	li	$v0 1
	move	$v1 $a0
exit:	
	jr	$ra

skip:#when meet the half word of Header Checksum, Skip it
	addi	$t7 $t7 1
	j	start
carry:#if there is a carry accumulator + 1
	addi	$s0 $s0 1
#	j	addimm
addimm:#add the two half words
	add	$s0 $t1 $t2
	addi	$t7 $t7 1	#$t7 ++ (counter++)
	j	start
	
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
	

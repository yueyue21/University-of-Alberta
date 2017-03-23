    .globl __eoth
__eoth:
    .globl Yesdisplay    #flag to indicate if a second passed

Yesdisplay:  .word 0
.data

next:
    .asciiz "\n"

    .text
    .globl __start
__start:
    li   $t2, 0
    li   $s8, 1
    li   $s7, 1
    li   $s6, 0
    li   $s4, 0
    li   $s5, 4
    li   $t5, 0
    li   $t6, 10
    li   $t7, 1
    li   $v0, 4
    li   $s3, 8
#################################################################
#Set my coprocessor register $11 to 100 so it will give a second#
#################################################################
    li   $s6, 100
    mtc0 $s6, $11
    #li   $s4, 0
#################################################################
#Set bit 0 in registry $12 to 1                                 #
#################################################################
    mfc0 $t9, $12
    ori  $t9, $t9, 0x08801
    mtc0 $t9, $12
#################################################################
#Set bit 1 in keyboard control register at 0xffff 0000 to 1     #
#################################################################
    #lw   $t0, 0xffff0000                                           
    #ori  $t0, $t0, 0x02                                              
    #sw   $t0, 0xffff0000      

    li $t5, 48
    sw   $t5, 0xffff000c


poll4:
    lw   $t1, 0xffff0008
    andi $t1, $t1, 0x0001
    bne  $t1, $t7, poll4
    li   $t5, 48
    sw   $t5, 0xffff000c

poll5:
    lw   $t1, 0xffff0008
    andi $t1, $t1, 0x0001
    bne  $t1, $t7, poll5
    li   $t5, 58
    sw   $t5, 0xffff000c

poll6:
    lw   $t1, 0xffff0008
    andi $t1, $t1, 0x0001
    bne  $t1, $t7, poll6
    li   $t5, 48
    sw   $t5, 0xffff000c

poll7:
    lw   $t1, 0xffff0008
    andi $t1, $t1, 0x0001
    bne  $t1, $t7, poll7
    li   $t5, 48
    sw   $t5, 0xffff000c

poll1:

intial_ended:

timer_inter:        
    addi $t5, $t5, 1                    #num
    addi $t7, $t5, 48
poll2:
    lw   $t1, 0xffff0008
    andi $t1, $t1, 0x00001
    bne  $t1, $s7, poll2
    sw   $s3, 0xffff000c  #backspace-1
poll3:
    lw   $t1, 0xffff0008
    andi $t1, $t1, 0x00001
    bne  $t1, $s7, poll3
    lw   $t1, Yesdisplay
    bne  $t1, $t2, poll3
    sw   $t7, 0xffff000c#$t7, 0xffff000c  #printing the first digit

    beq  $t5, $t6, tens_of_a_second 

    j timer_inter

tens_of_a_second:

poll9:
    lw   $t1, 0xffff0008
    andi $t1, $t1, 0x00001
    bne  $t1, $s7, poll9
    sw   $s3, 0xffff000c  #backspace-1

poll11:
    lw   $t1, 0xffff0008
    andi $t1, $t1, 0x00001
    bne  $t1, $s7, poll11
    sw   $s3, 0xffff000c  #backspace-1
    addi $t7, $s8, 48

poll10:
    lw   $t1, 0xffff0008
    andi $t1, $t1, 0x00001
    bne  $t1, $s7, poll10
    addi $t7, $s8, 48
    sw   $t7, 0xffff000c  #print the tens of a second 
    addi $s8, $s8, 1
    li   $t5, 0

    beq  $t5, $t6, minuts   

    j timer_inter

minuts:
poll12:
    lw   $t1, 0xffff0008
    andi $t1, $t1, 0x00001
    bne  $t1, $s7, poll12
    sw   $s3, 0xffff000c  #backspace-1


quite:
    li   $v0, 10
    syscall

    .kdata
s1: .word 0
s2: .word 0
s3: .word 0

    .ktext 0x80000180
    .set noat
    move $k1 $at
    .set at
    sw   $a0, s1
    sw   $v0, s2 
    sw   $t1, s3
    mfc0 $k0, $13
    srl  $a0, $k0, 2
    andi $a0, $a0, 0x01f
    bne  $a0, $zero, inter_eret
    lw   $a0, s1
    lw   $v0, s2 
    eret

inter_eret:
    andi $k1, $k0, 0x8000
    bne  $k1, $zero, timer_inter_eret
    lw   $a0, s1
    lw   $v0, s2 
    eret

timer_inter_eret:
    .set noat
    move $k1, $at
    .set at
    mtc0 $zero, $9
    eret



    addi $t1, $zero, 1
    sw   $t1, Yesdisplay 
    lw   $a0, s1
    lw   $v0, s2 
    lw   $t1, s3
    .set noat
    move $k1, $at
    .set at
    mtc0 $zero, $9
    eret

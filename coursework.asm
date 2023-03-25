main:

j proc

jr $ra


evalX:


li $t2 16

#x = (b/16 & 2d) * (a ^ 16d)

# b/16 & 2d

div $a1 $t2
mflo $t0

sll $t1 $a3 1	# 2d	shift 1 left
and $t0 $t0 $t1	# b/16 & 2d	store result in $t0


# a ^ 16d

sll $t1 $a3 4	#16d shift 4 left
xor $t1 $a0 $t1	#a ^ 16d	store result in $t1

#(b/16 & 2d) * (a ^ 16d)

mult $t0 $t1	# result is stored in LO
mflo $v0	# store result in $v0 and return


jr $ra


###################################################

evalY:
#y = (2a % (b - d))/16 * (3b * c/32)/2


li $t3 3
li $t4 16
li $t5 32
li $t6 2


# b-d
subu $t0 $a1 $a3

# (2a % (b - d))

sll $t1 $a0 1	# 2a shift 1 left
div $t1 $t0	# 2a MOD (b-d)
mfhi $t0	# store result in $t0

div $t0 $t4	#(2a % (b - d))/16
mflo $t0

#(3b * c/32)/2

mult $a1 $t3
mflo $t1

div $a2 $t5
mflo $t2

mult $t1 $t2
mflo $t1

div $t1 $t6
mflo $t1

mult $t0 $t1 
mflo $v0 

jr $ra

##################################################

proc:
# #x = (b/16 & 2d) * (a ^ 16d) #y = (2a % (b - d))/16 * (3b * c/32)/2
#(b, d, a, d, a, b, d, b, c) 9 length


# $a0 will store N
# $a1 starting address of input data
# $a2 starting address of output data

# STACK:
# 0	retrun addres
# 4	result of eval x
# 8 	result of eval y
# 12	numb1 result
# 16	numb2 result
# 20 	N
# 24	input address
# 28	output address
# 32	Count
# 36 	Stack Pointer



#STORE AWAY

addi $sp $sp -44
sw $ra 0($sp)
sw $s4 4($sp)
sw $s5 8($sp)
sw $s6 12($sp)
sw $s7 16($sp)
sw $s0 20($sp)
sw $s1 24($sp)
sw $s2 28($sp)
sw $s3 32($sp)
sw $sp 36($sp)

move $s0 $a0	# N
move $s1 $a1	# input address
move $s2 $a2	# Output address
li $s3 0 	# Count

again:

	lw $a0 8($s1)
	lw $a1 0($s1)
	lw $a2 32($s1)
	lw $a3 4($s1)
	
	
	jal evalX
	nop
	move $s4 $v0
	
	jal evalY
	nop
	move $s5 $v0
	
	move $a0 $s4
	move $a1 $s5
	
	jal numb1
	nop
	move $s6 $v0
	
	
	jal numb2
	nop
	move $s7 $v0
	
	addu $v0 $s6 $s7
	
	sb $v0 0($s2)	# store in output address
	
	addiu $s1 36 	#increment values
	addiu $s2 1
	addiu $s3 1
	
blt $s3 $s0 again
nop

# RESTORE


lw $ra 0($sp)	#store return address for main
lw $s4 4($sp)
lw $s5 8($sp)
lw $s6 12($sp)
lw $s7 16($sp)
lw $s0 20($sp)
lw $s1 24($sp)
lw $s2 28($sp)
lw $s3 32($sp)
lw $sp 36($sp)
addi $sp $sp 44

jr $ra 
nop


numb1:
     and    $v0, $a0, $a1 # Output is the bit-wise and of the inputs.
     jr     $ra
     nop


numb2:
     sub    $v0, $a0, $a1 # Output is the difference of the inputs.
     jr     $ra
     nop


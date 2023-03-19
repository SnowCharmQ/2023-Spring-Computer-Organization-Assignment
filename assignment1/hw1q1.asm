.macro closefile
	li $v0,16
    	move $a0,$s6 
    	syscall	
.end_macro

.macro printstring(%str)
	.data 
	pstr: .asciiz   %str     
	.text
	la $a0,pstr
	li $v0,4
	syscall
.end_macro

.macro end
	li $v0, 10
	syscall
.end_macro

.data
    filename: .space 100
    buffer: .space 40
    ip: .space 40
    result: .space 4
.text
main:
	la $a0, filename
	li $v0, 8
	li $a1, 18
	syscall
	li $v0, 13
	la $a0, filename
	jal stripnewline
	li $a1, 0 
	li $a2, 0
	syscall
	move $s6, $v0 
	li $v0, 14
	move $a0, $s6 
	la $a1, buffer 
	li $a2, 40
	syscall
	closefile
	
	la $t0, buffer
	la $t1, ip
	li $s0, 40
	
	loopconvert:
		lb $t2, ($t0)
		bgt $t2, 96, letterconvert
		addi $t2, $t2, -48
		j finishconvert
		letterconvert:
			addi $t2, $t2, -87
		finishconvert:
			sb $t2, ($t1)
		addi $t0, $t0, 1
		addi $t1, $t1, 1
		addi $s0, $s0, -1
		bgtz $s0, loopconvert
	
	la $t0, ip # ip addr
	la $t1, result # result addr
	li $s0, 0 # carry
	li $s1, 3 # i
	li $s7, 3 # 3
	loop1:
		move $s2, $s0 # sum
		li $s3, 0 # j
		loop2:
			sll $s4, $s3, 2
			add $s4, $s4, $s1
			add $s4, $s4, $t0 # index
			lb $s5, ($s4) # ip[index]
			add $s2, $s2, $s5
			addi $s3, $s3, 1
			blt $s3, 10, loop2
			
		sub $s6, $s7, $s1 
		add $s6, $s6, $t1 # result[3-i]
		andi $t3, $s2, 15 # sum % 16
		sb $t3, ($s6)
		srl $s0, $s2, 4
		addi $s1, $s1, -1
		bgez $s1, loop1
	
	la $t1, result # result addr
	li $s1, 3 # i
	li $s7, 3 # 3
	loop3:
		move $s2, $s0 # sum = carry
		sub $s6, $s7, $s1 
		add $s6, $s6, $t1 # result[3-i]
		lb $t2, ($s6)
		add $s2, $s2, $t2
		andi $s3, $s2, 15 # sum % 16
		
		sb $s3, ($s6)
		srl $s0, $s2, 4
		addi $s1, $s1, -1
		bgez $s1, loop3
	
	li $t0, 0 # sum
	la $t1, result # result addr
	li $t2, 0 # i
	li $s7, 15
	loopprint:
		add $t3, $t1, $t2
		lb $t4, ($t3)
		sub $t4, $s7, $t4 # result[i]
		li $t5, 1 # base
		li $t6, 0 # j
		beq $t6, $t2, basebreak
		loopbase:
			sll $t5, $t5, 4
			addi $t6, $t6, 1
			blt $t6, $t2, loopbase
		basebreak:
			mul $t5, $t5, $t4
			add $t0, $t0, $t5
			addi $t2, $t2, 1
			blt $t2, 4, loopprint
	move $a0, $t0
	jal printhex
	
	
		
end
stripnewline:
    	lb $t0, ($a0) 
    	beqz $t0, endstrip 
    	addi $t1, $a0, 1 
    	loopsn:
        	lb $t0, ($t1) 
        	beqz $t0, endstrip 
        	beq $t0, '\n', replace 
        	addi $t1, $t1, 1 
        	j loopsn
    	replace:
        	sb $zero, ($t1) 
        	j endstrip
endstrip:
    	jr $ra 
printhex:
	li $v0, 34
	syscall
	jr $ra
 

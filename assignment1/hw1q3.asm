.macro end
	li $v0, 10
	syscall
.end_macro	

.macro print_string(%str)
	.data 
		pstr: .asciiz   %str     
	.text
		la $a0,pstr
		li $v0,4
		syscall
.end_macro

.data  
	ascii: .space 6   
	bstr: .space 48   
.text
main:
	li $v0, 9
	li $a0, 10  
	syscall
	move $t0, $v0 
	
	li $v0, 8
	la $a0, ($t0) 
	li $a1, 10 
	syscall
	
	move $t1, $t0
	la $t2, ($t0)  
	la $t5, ascii
	la $t9, bstr

	loop:
  		lb $t3, ($t2)    
  		beq $t3, '\n', end_of_string  
  		beq $t3, '\0', end_of_string
  		sb $t3, ($t5)
  		addi $t2, $t2, 1 
  		addi $t5, $t5, 1
  		li $t6, 8
  	binloop:
  		andi $s0, $t3, 1
  		srl $t3, $t3, 1
  		addi $t6, $t6, -1
  		sub $t4, $t2, $t1
  		addi $t4, $t4, -1
  		sll $t4, $t4, 3
  		add $t4, $t4, $t6
  		add $t4, $t4, $t9
  		sb $s0, ($t4)
  		bgtz $t6, binloop
  		j loop
  	end_of_string:
  		sb $zero, ($t2)
		sub $t4, $t2, $t1  
		jal print_str
		
		sll $t1, $t4, 3 
		sll $s0, $t4, 2 
		la $t2, bstr
		li $t5, 0
	loopjudge:
		add $t6, $t5, $zero
		add $t6, $t6, $t2
		lb $t7, ($t6)
		
		sub $t6, $t1, $t5
		addi $t6, $t6, -1
		add $t6, $t6, $t2
		lb $t8, ($t6)
		
		bne $t7, $t8, non_polindrome
		
		addi $t5, $t5, 1
		blt $t5, $s0, loopjudge
		print_string(" is a binary palindrome\n")
		j printinfo
	non_polindrome:
		print_string(" is not a binary palindrome\n")
	printinfo:
		print_string("the ASCII code is ")
		la $s1, ascii
		li $s2, 0
		loopprint1:
			add $t5, $s1, $s2
			lb $t6, ($t5)
			move $a0, $t6
			jal print_int
			addi $s2, $s2, 1
			beq $s2, $t4, break1
			print_string("-")
			blt $s2, $t4, loopprint1
		break1:
		print_string("\nthe binary code is ")
		la $s1, bstr
		li $s2, 0
		loopprint2:
			add $t5, $s1, $s2
			lb $t6, ($t5)
			move $a0, $t6
			jal print_int
			addi $s2, $s2, 1
			beq $s2, $t1, break2
			andi $s3, $s2, 7
			
			beqz $s3, print_split
			
			blt $s2, $t1, loopprint2
		break2:
			end
		
print_int:
	li $v0, 1
	syscall
	jr $ra
print_str:
	li $v0, 4        
	move $a0, $t0   
	syscall        
	jr $ra  
print_split:
	print_string("-")
	blt $s2, $t1, loopprint2
	j break2

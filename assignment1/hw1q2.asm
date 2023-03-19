.macro end
	li $v0, 10
	syscall
.end_macro

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
	lb $t3, ($t2)  
	beq $t3, '\n', end_of_string 
	loop:
  		addi $t2, $t2, 1 
  		lb $t3, ($t2)    
  		beq $t3, '\n', end_of_string  
  		j loop
  		
  	end_of_string:
		sub $t4, $t2, $t1  
		
	la $t2, ($t0)
	lb $t3, ($t2)
	li $t5, 0
	loop_check:
		lb $t3, ($t2)
		beq $t3, '\n', print_result
		addi $t2, $t2, 1
		beq $t3, '1', add_1
		j loop_check
	add_1:
		addi $t5, $t5, 1
		j loop_check
print_result:
	beq $t4, 7, print_seven
	beq $t4, 8, print_eight
	print_seven:
		andi $t6, $t5, 1
		beq $t6, $zero, seven_even
		li $v0, 1
		li $a0, 1
		syscall
		end
		seven_even:
			li $v0, 1
			li $a0, 0
			syscall
			end
	print_eight:
		andi $t6, $t5, 1
		beq $t6, $zero, eight_even
		li $v0, 1
		li $a0, 0
		syscall
		end
		eight_even:
			li $v0, 1
			li $a0, 1
			syscall
			end
		
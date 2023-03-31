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
	num0: .float 0
	num1: .float 1
	num2: .float 2
	
.text
	lwc1 $f30, num0 # num=0
	lwc1 $f2, num1 # num=1
	lwc1 $f4, num2 # num=2

	li $v0, 6    
	syscall        
	mov.s $f6, $f0  # op
	syscall        
	mov.s $f8, $f0  # x
	
	mov.s $f10, $f30 # sin
	mov.s $f1, $f2 # i
	oloop:
		mul.s $f14, $f4, $f1
		sub.s $f14, $f14, $f2 # num
		mov.s $f16, $f2 # fac
		mov.s $f18, $f2 # j
		fac:
			mul.s $f16, $f16, $f18
			add.s $f18, $f18, $f2
			c.le.s $f18, $f14
			bc1t fac
		mov.s $f22, $f2 # pow
		mov.s $f18, $f2 # j
		pow:
			mul.s $f22, $f22, $f8
			add.s $f18, $f18, $f2
			c.le.s $f18, $f14
			bc1t pow

		cvt.w.s $f20, $f1
		mfc1 $t1, $f20
		andi $t2, $t1, 1 # j%2
		div.s $f24, $f22, $f16 # pow/fac
		beqz $t2, minus
		add.s $f10, $f10, $f24
		j judge
		minus:
			sub.s $f10, $f10, $f24
		judge:
			add.s $f1, $f1, $f2
			c.le.s $f1, $f6
			bc1t oloop
			li $v0, 2
			mov.s $f12, $f10
			syscall
			end
	
			
# #include "stdio.h"

# int main() {
#     float op;
#     float x;
#     scanf("%f%f", &op, &x);
#     float sin = 0;
#     for (float i = 1; i <= op; i++)
#     {
#         float num = 2 * i - 1;
#         float fac = 1;
#         for (float j = 1; j <= num; j++)
#         {
#             fac *= j;
#         }
#         float pow = 1;
#         for (float j = 1; j <= num; j++)
#         {
#             pow *= x;
#         }
#         int j = i;
#         printf("%f\n", pow/fac);
#         if (j % 2 == 0) {
#             sin -= (pow / fac); 
#         } else {
#             sin += (pow / fac);
#         }
#     }
#     printf("%f\n", sin);
# }
					
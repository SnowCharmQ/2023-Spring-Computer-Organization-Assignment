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
	precision: .double 0.000001 
    	num2: .double 2
.text
	li $v0, 7     
	syscall        
	mov.d $f14, $f0  # a
	syscall        
	mov.d $f16, $f0  # b
	syscall        
	mov.d $f18, $f0 # c
	
	ldc1 $f2, num2 # num=2
	ldc1 $f4, precision # precision
	
	mul.d $f22, $f2, $f14
	div.d $f22, $f16, $f22
	neg.d $f22, $f22 # val
	sub.d $f30, $f22, $f4 # x
	loop1:
		mul.d $f24, $f30, $f30
		mul.d $f24, $f24, $f14
		mul.d $f26, $f30, $f16
		add.d $f26, $f26, $f18
		add.d $f24, $f24, $f26 # fx
		abs.d $f26, $f24 #absfx
		c.le.d $f26, $f4
		bc1t break1
		mul.d $f28, $f2, $f14
		mul.d $f28, $f28, $f30
		add.d $f28, $f28, $f16
		div.d $f28, $f24, $f28 # tmp
		sub.d $f30, $f30, $f28
		j loop1
	break1:
		mov.d $f6, $f30
	add.d $f30, $f22, $f4
	loop2:
		mul.d $f24, $f30, $f30
		mul.d $f24, $f24, $f14
		mul.d $f26, $f30, $f16
		add.d $f26, $f26, $f18
		add.d $f24, $f24, $f26 # fx
		abs.d $f26, $f24 #absfx
		c.le.d $f26, $f4
		bc1t break2
		mul.d $f28, $f2, $f14
		mul.d $f28, $f28, $f30
		add.d $f28, $f28, $f16
		div.d $f28, $f24, $f28 # tmp
		sub.d $f30, $f30, $f28
		j loop2
	break2:
		mov.d $f8, $f30
	
	li $v0, 3
	mov.d $f12, $f6
	syscall
	printstring("\n")
	li $v0, 3
	mov.d $f12, $f8
	syscall
	end
	
	
# #include "stdio.h"
# #define precision 1e-6
# #define ABS(A) ((A) >= (0) ? (A) : (-(A)))

# int main()
# {
#     double a, b, c;
#     double xmin, xmax;
#     scanf("%lf%lf%lf", &a, &b, &c);
#     double val = -b / (2 * a);
#     double x = val - precision;
#     while (1)
#     {
#         double fx = a * x * x + b * x + c;
#         double absfx = ABS(fx);
#         if (absfx < precision)
#         {
#             xmin = x;
#             break;
#         }
#         double tmp = fx / (2 * a * x + b);
#         x -= tmp;
#     }
#     x = val + precision;
#     while (1)
#     {
#         double fx = a * x * x + b * x + c;
#         double absfx = ABS(fx);
#         if (absfx < precision)
#         {
#             xmax = x;
#             break;
#         }
#         double tmp = fx / (2 * a * x + b);
#         x -= tmp;
#     }
#     printf("%lf\n%lf", xmin, xmax);
# }
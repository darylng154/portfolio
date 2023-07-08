	.file	"lwp.c"
	.comm	lwp_ptable,960,32
	.globl	lwp_procs
	.bss
	.align 4
	.type	lwp_procs, @object
	.size	lwp_procs, 4
lwp_procs:
	.zero	4
	.globl	lwp_running
	.data
	.align 4
	.type	lwp_running, @object
	.size	lwp_running, 4
lwp_running:
	.long	-1
	.globl	og_esp
	.bss
	.align 8
	.type	og_esp, @object
	.size	og_esp, 8
og_esp:
	.zero	8
	.globl	scheduler
	.data
	.align 8
	.type	scheduler, @object
	.size	scheduler, 8
scheduler:
	.quad	round_robin
	.text
	.globl	new_lwp
	.type	new_lwp, @function
new_lwp:
.LFB2:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$56, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	%rdx, -56(%rbp)
	movq	$0, -32(%rbp)
	movl	$0, -20(%rbp)
	movl	lwp_procs(%rip), %eax
	cmpl	$30, %eax
	jle	.L2
	movl	$-1, %eax
	jmp	.L3
.L2:
	movl	lwp_procs(%rip), %ebx
	movl	$0, %eax
	call	lwp_getpid
	cltq
	movslq	%ebx, %rdx
	salq	$5, %rdx
	addq	$lwp_ptable, %rdx
	movq	%rax, (%rdx)
	movl	lwp_procs(%rip), %ebx
	movq	-56(%rbp), %rax
	salq	$2, %rax
	movq	%rax, %rdi
	call	malloc
	movslq	%ebx, %rdx
	salq	$5, %rdx
	addq	$lwp_ptable, %rdx
	movq	%rax, 8(%rdx)
	movl	lwp_procs(%rip), %eax
	cltq
	salq	$5, %rax
	leaq	lwp_ptable+16(%rax), %rdx
	movq	-56(%rbp), %rax
	movq	%rax, (%rdx)
	movl	lwp_procs(%rip), %eax
	movl	lwp_procs(%rip), %edx
	movslq	%edx, %rdx
	salq	$5, %rdx
	addq	$lwp_ptable, %rdx
	movq	8(%rdx), %rdx
	movq	-56(%rbp), %rcx
	salq	$3, %rcx
	addq	%rcx, %rdx
	cltq
	salq	$5, %rax
	addq	$lwp_ptable+16, %rax
	movq	%rdx, 8(%rax)
	movl	lwp_procs(%rip), %eax
	movslq	%eax, %rdx
	salq	$5, %rdx
	addq	$lwp_ptable+16, %rdx
	movq	8(%rdx), %rdx
	subq	$8, %rdx
	cltq
	salq	$5, %rax
	addq	$lwp_ptable+16, %rax
	movq	%rdx, 8(%rax)
	movl	lwp_procs(%rip), %eax
	cltq
	salq	$5, %rax
	addq	$lwp_ptable+16, %rax
	movq	8(%rax), %rax
	movq	-48(%rbp), %rdx
	movq	%rdx, (%rax)
	movl	lwp_procs(%rip), %eax
	movslq	%eax, %rdx
	salq	$5, %rdx
	addq	$lwp_ptable+16, %rdx
	movq	8(%rdx), %rdx
	subq	$8, %rdx
	cltq
	salq	$5, %rax
	addq	$lwp_ptable+16, %rax
	movq	%rdx, 8(%rax)
	movl	lwp_procs(%rip), %eax
	cltq
	salq	$5, %rax
	addq	$lwp_ptable+16, %rax
	movq	8(%rax), %rax
	movl	$lwp_exit, %edx
	movq	%rdx, (%rax)
	movl	lwp_procs(%rip), %eax
	movslq	%eax, %rdx
	salq	$5, %rdx
	addq	$lwp_ptable+16, %rdx
	movq	8(%rdx), %rdx
	subq	$8, %rdx
	cltq
	salq	$5, %rax
	addq	$lwp_ptable+16, %rax
	movq	%rdx, 8(%rax)
	movl	lwp_procs(%rip), %eax
	cltq
	salq	$5, %rax
	addq	$lwp_ptable+16, %rax
	movq	8(%rax), %rax
	movq	-40(%rbp), %rdx
	movq	%rdx, (%rax)
	movl	lwp_procs(%rip), %eax
	movslq	%eax, %rdx
	salq	$5, %rdx
	addq	$lwp_ptable+16, %rdx
	movq	8(%rdx), %rdx
	subq	$8, %rdx
	cltq
	salq	$5, %rax
	addq	$lwp_ptable+16, %rax
	movq	%rdx, 8(%rax)
	movl	lwp_procs(%rip), %eax
	cltq
	salq	$5, %rax
	addq	$lwp_ptable+16, %rax
	movq	8(%rax), %rax
	movq	%rax, -32(%rbp)
	movl	lwp_procs(%rip), %eax
	cltq
	salq	$5, %rax
	addq	$lwp_ptable+16, %rax
	movq	8(%rax), %rax
	movl	$3735928559, %esi
	movq	%rsi, (%rax)
	movl	$0, -20(%rbp)
	jmp	.L4
.L5:
	movl	lwp_procs(%rip), %eax
	movslq	%eax, %rdx
	salq	$5, %rdx
	addq	$lwp_ptable+16, %rdx
	movq	8(%rdx), %rdx
	subq	$8, %rdx
	cltq
	salq	$5, %rax
	addq	$lwp_ptable+16, %rax
	movq	%rdx, 8(%rax)
	movl	lwp_procs(%rip), %eax
	cltq
	salq	$5, %rax
	addq	$lwp_ptable+16, %rax
	movq	8(%rax), %rax
	movl	-20(%rbp), %edx
	addl	$10, %edx
	movslq	%edx, %rdx
	movq	%rdx, (%rax)
	addl	$1, -20(%rbp)
.L4:
	cmpl	$5, -20(%rbp)
	jle	.L5
	movl	lwp_procs(%rip), %eax
	movslq	%eax, %rdx
	salq	$5, %rdx
	addq	$lwp_ptable+16, %rdx
	movq	8(%rdx), %rdx
	subq	$8, %rdx
	cltq
	salq	$5, %rax
	addq	$lwp_ptable+16, %rax
	movq	%rdx, 8(%rax)
	movl	lwp_procs(%rip), %eax
	cltq
	salq	$5, %rax
	addq	$lwp_ptable+16, %rax
	movq	8(%rax), %rax
	movq	-32(%rbp), %rdx
	movq	%rdx, (%rax)
	movl	lwp_procs(%rip), %eax
	addl	$1, %eax
	movl	%eax, lwp_procs(%rip)
	movl	lwp_procs(%rip), %eax
	subl	$1, %eax
	cltq
	salq	$5, %rax
	addq	$lwp_ptable, %rax
	movq	(%rax), %rax
.L3:
	addq	$56, %rsp
	popq	%rbx
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	new_lwp, .-new_lwp
	.globl	lwp_getpid
	.type	lwp_getpid, @function
lwp_getpid:
.LFB3:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	call	getpid
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	lwp_getpid, .-lwp_getpid
	.globl	lwp_yield
	.type	lwp_yield, @function
lwp_yield:
.LFB4:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
#APP
# 96 "lwp.c" 1
	pushq %rax
# 0 "" 2
# 96 "lwp.c" 1
	pushq %rbx
# 0 "" 2
# 96 "lwp.c" 1
	pushq %rcx
# 0 "" 2
# 96 "lwp.c" 1
	pushq %rdx
# 0 "" 2
# 96 "lwp.c" 1
	pushq %rsi
# 0 "" 2
# 96 "lwp.c" 1
	pushq %rdi
# 0 "" 2
# 96 "lwp.c" 1
	pushq %r8
# 0 "" 2
# 96 "lwp.c" 1
	pushq %r9
# 0 "" 2
# 96 "lwp.c" 1
	pushq %r10
# 0 "" 2
# 96 "lwp.c" 1
	pushq %r11
# 0 "" 2
# 96 "lwp.c" 1
	pushq %r12
# 0 "" 2
# 96 "lwp.c" 1
	pushq %r13
# 0 "" 2
# 96 "lwp.c" 1
	pushq %r14
# 0 "" 2
# 96 "lwp.c" 1
	pushq %r15
# 0 "" 2
# 96 "lwp.c" 1
	pushq %rbp
# 0 "" 2
#NO_APP
	movl	lwp_running(%rip), %edx
#APP
# 97 "lwp.c" 1
	movq  %rsp,%rax
# 0 "" 2
#NO_APP
	movslq	%edx, %rdx
	salq	$5, %rdx
	addq	$lwp_ptable+16, %rdx
	movq	%rax, 8(%rdx)
	movq	scheduler(%rip), %rax
	call	*%rax
	movl	%eax, lwp_running(%rip)
	movl	lwp_running(%rip), %eax
	cltq
	salq	$5, %rax
	addq	$lwp_ptable+16, %rax
	movq	8(%rax), %rax
#APP
# 101 "lwp.c" 1
	movq  %rax,%rsp
# 0 "" 2
# 102 "lwp.c" 1
	popq  %rbp
# 0 "" 2
# 102 "lwp.c" 1
	popq  %r15
# 0 "" 2
# 102 "lwp.c" 1
	popq  %r14
# 0 "" 2
# 102 "lwp.c" 1
	popq  %r13
# 0 "" 2
# 102 "lwp.c" 1
	popq  %r12
# 0 "" 2
# 102 "lwp.c" 1
	popq  %r11
# 0 "" 2
# 102 "lwp.c" 1
	popq  %r10
# 0 "" 2
# 102 "lwp.c" 1
	popq  %r9
# 0 "" 2
# 102 "lwp.c" 1
	popq  %r8
# 0 "" 2
# 102 "lwp.c" 1
	popq  %rdi
# 0 "" 2
# 102 "lwp.c" 1
	popq  %rsi
# 0 "" 2
# 102 "lwp.c" 1
	popq  %rdx
# 0 "" 2
# 102 "lwp.c" 1
	popq  %rcx
# 0 "" 2
# 102 "lwp.c" 1
	popq  %rbx
# 0 "" 2
# 102 "lwp.c" 1
	popq  %rax
# 0 "" 2
# 102 "lwp.c" 1
	movq  %rbp,%rsp
# 0 "" 2
#NO_APP
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4:
	.size	lwp_yield, .-lwp_yield
	.globl	lwp_exit
	.type	lwp_exit, @function
lwp_exit:
.LFB5:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
#APP
# 112 "lwp.c" 1
	pushq %rax
# 0 "" 2
# 112 "lwp.c" 1
	pushq %rbx
# 0 "" 2
# 112 "lwp.c" 1
	pushq %rcx
# 0 "" 2
# 112 "lwp.c" 1
	pushq %rdx
# 0 "" 2
# 112 "lwp.c" 1
	pushq %rsi
# 0 "" 2
# 112 "lwp.c" 1
	pushq %rdi
# 0 "" 2
# 112 "lwp.c" 1
	pushq %r8
# 0 "" 2
# 112 "lwp.c" 1
	pushq %r9
# 0 "" 2
# 112 "lwp.c" 1
	pushq %r10
# 0 "" 2
# 112 "lwp.c" 1
	pushq %r11
# 0 "" 2
# 112 "lwp.c" 1
	pushq %r12
# 0 "" 2
# 112 "lwp.c" 1
	pushq %r13
# 0 "" 2
# 112 "lwp.c" 1
	pushq %r14
# 0 "" 2
# 112 "lwp.c" 1
	pushq %r15
# 0 "" 2
# 112 "lwp.c" 1
	pushq %rbp
# 0 "" 2
#NO_APP
	movl	lwp_running(%rip), %edx
#APP
# 113 "lwp.c" 1
	movq  %rsp,%rax
# 0 "" 2
#NO_APP
	movslq	%edx, %rdx
	salq	$5, %rdx
	addq	$lwp_ptable+16, %rdx
	movq	%rax, 8(%rdx)
	movl	$0, -4(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L10
.L11:
	movl	-4(%rbp), %eax
	leal	1(%rax), %edx
	movl	-4(%rbp), %eax
	cltq
	salq	$5, %rax
	addq	$lwp_ptable, %rax
	movslq	%edx, %rdx
	salq	$5, %rdx
	addq	$lwp_ptable, %rdx
	movq	(%rdx), %rcx
	movq	%rcx, (%rax)
	movq	8(%rdx), %rcx
	movq	%rcx, 8(%rax)
	movq	16(%rdx), %rcx
	movq	%rcx, 16(%rax)
	movq	24(%rdx), %rdx
	movq	%rdx, 24(%rax)
	addl	$1, -4(%rbp)
.L10:
	movl	lwp_procs(%rip), %eax
	subl	$1, %eax
	cmpl	-4(%rbp), %eax
	jg	.L11
	movl	lwp_procs(%rip), %eax
	subl	$1, %eax
	movl	%eax, lwp_procs(%rip)
	movl	lwp_procs(%rip), %eax
	testl	%eax, %eax
	jne	.L12
	movl	$0, %eax
	call	lwp_stop
	jmp	.L9
.L12:
	movl	lwp_running(%rip), %eax
	cltq
	salq	$5, %rax
	addq	$lwp_ptable+16, %rax
	movq	8(%rax), %rax
#APP
# 130 "lwp.c" 1
	movq  %rax,%rsp
# 0 "" 2
# 131 "lwp.c" 1
	popq  %rbp
# 0 "" 2
# 131 "lwp.c" 1
	popq  %r15
# 0 "" 2
# 131 "lwp.c" 1
	popq  %r14
# 0 "" 2
# 131 "lwp.c" 1
	popq  %r13
# 0 "" 2
# 131 "lwp.c" 1
	popq  %r12
# 0 "" 2
# 131 "lwp.c" 1
	popq  %r11
# 0 "" 2
# 131 "lwp.c" 1
	popq  %r10
# 0 "" 2
# 131 "lwp.c" 1
	popq  %r9
# 0 "" 2
# 131 "lwp.c" 1
	popq  %r8
# 0 "" 2
# 131 "lwp.c" 1
	popq  %rdi
# 0 "" 2
# 131 "lwp.c" 1
	popq  %rsi
# 0 "" 2
# 131 "lwp.c" 1
	popq  %rdx
# 0 "" 2
# 131 "lwp.c" 1
	popq  %rcx
# 0 "" 2
# 131 "lwp.c" 1
	popq  %rbx
# 0 "" 2
# 131 "lwp.c" 1
	popq  %rax
# 0 "" 2
# 131 "lwp.c" 1
	movq  %rbp,%rsp
# 0 "" 2
#NO_APP
.L9:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE5:
	.size	lwp_exit, .-lwp_exit
	.globl	lwp_start
	.type	lwp_start, @function
lwp_start:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	lwp_procs(%rip), %eax
	testl	%eax, %eax
	jne	.L15
	jmp	.L14
.L15:
#APP
# 145 "lwp.c" 1
	pushq %rax
# 0 "" 2
# 145 "lwp.c" 1
	pushq %rbx
# 0 "" 2
# 145 "lwp.c" 1
	pushq %rcx
# 0 "" 2
# 145 "lwp.c" 1
	pushq %rdx
# 0 "" 2
# 145 "lwp.c" 1
	pushq %rsi
# 0 "" 2
# 145 "lwp.c" 1
	pushq %rdi
# 0 "" 2
# 145 "lwp.c" 1
	pushq %r8
# 0 "" 2
# 145 "lwp.c" 1
	pushq %r9
# 0 "" 2
# 145 "lwp.c" 1
	pushq %r10
# 0 "" 2
# 145 "lwp.c" 1
	pushq %r11
# 0 "" 2
# 145 "lwp.c" 1
	pushq %r12
# 0 "" 2
# 145 "lwp.c" 1
	pushq %r13
# 0 "" 2
# 145 "lwp.c" 1
	pushq %r14
# 0 "" 2
# 145 "lwp.c" 1
	pushq %r15
# 0 "" 2
# 145 "lwp.c" 1
	pushq %rbp
# 0 "" 2
# 146 "lwp.c" 1
	movq  %rsp,%rax
# 0 "" 2
#NO_APP
	movq	%rax, og_esp(%rip)
	movq	scheduler(%rip), %rax
	call	*%rax
	movl	%eax, lwp_running(%rip)
	movl	lwp_running(%rip), %eax
	cltq
	salq	$5, %rax
	addq	$lwp_ptable+16, %rax
	movq	8(%rax), %rax
#APP
# 150 "lwp.c" 1
	movq  %rax,%rsp
# 0 "" 2
# 151 "lwp.c" 1
	popq  %rbp
# 0 "" 2
# 151 "lwp.c" 1
	popq  %r15
# 0 "" 2
# 151 "lwp.c" 1
	popq  %r14
# 0 "" 2
# 151 "lwp.c" 1
	popq  %r13
# 0 "" 2
# 151 "lwp.c" 1
	popq  %r12
# 0 "" 2
# 151 "lwp.c" 1
	popq  %r11
# 0 "" 2
# 151 "lwp.c" 1
	popq  %r10
# 0 "" 2
# 151 "lwp.c" 1
	popq  %r9
# 0 "" 2
# 151 "lwp.c" 1
	popq  %r8
# 0 "" 2
# 151 "lwp.c" 1
	popq  %rdi
# 0 "" 2
# 151 "lwp.c" 1
	popq  %rsi
# 0 "" 2
# 151 "lwp.c" 1
	popq  %rdx
# 0 "" 2
# 151 "lwp.c" 1
	popq  %rcx
# 0 "" 2
# 151 "lwp.c" 1
	popq  %rbx
# 0 "" 2
# 151 "lwp.c" 1
	popq  %rax
# 0 "" 2
# 151 "lwp.c" 1
	movq  %rbp,%rsp
# 0 "" 2
#NO_APP
.L14:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	lwp_start, .-lwp_start
	.globl	lwp_stop
	.type	lwp_stop, @function
lwp_stop:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
#APP
# 161 "lwp.c" 1
	pushq %rax
# 0 "" 2
# 161 "lwp.c" 1
	pushq %rbx
# 0 "" 2
# 161 "lwp.c" 1
	pushq %rcx
# 0 "" 2
# 161 "lwp.c" 1
	pushq %rdx
# 0 "" 2
# 161 "lwp.c" 1
	pushq %rsi
# 0 "" 2
# 161 "lwp.c" 1
	pushq %rdi
# 0 "" 2
# 161 "lwp.c" 1
	pushq %r8
# 0 "" 2
# 161 "lwp.c" 1
	pushq %r9
# 0 "" 2
# 161 "lwp.c" 1
	pushq %r10
# 0 "" 2
# 161 "lwp.c" 1
	pushq %r11
# 0 "" 2
# 161 "lwp.c" 1
	pushq %r12
# 0 "" 2
# 161 "lwp.c" 1
	pushq %r13
# 0 "" 2
# 161 "lwp.c" 1
	pushq %r14
# 0 "" 2
# 161 "lwp.c" 1
	pushq %r15
# 0 "" 2
# 161 "lwp.c" 1
	pushq %rbp
# 0 "" 2
#NO_APP
	movl	lwp_running(%rip), %edx
#APP
# 162 "lwp.c" 1
	movq  %rsp,%rax
# 0 "" 2
#NO_APP
	movslq	%edx, %rdx
	salq	$5, %rdx
	addq	$lwp_ptable+16, %rdx
	movq	%rax, 8(%rdx)
	movq	og_esp(%rip), %rax
#APP
# 164 "lwp.c" 1
	movq  %rax,%rsp
# 0 "" 2
# 165 "lwp.c" 1
	popq  %rbp
# 0 "" 2
# 165 "lwp.c" 1
	popq  %r15
# 0 "" 2
# 165 "lwp.c" 1
	popq  %r14
# 0 "" 2
# 165 "lwp.c" 1
	popq  %r13
# 0 "" 2
# 165 "lwp.c" 1
	popq  %r12
# 0 "" 2
# 165 "lwp.c" 1
	popq  %r11
# 0 "" 2
# 165 "lwp.c" 1
	popq  %r10
# 0 "" 2
# 165 "lwp.c" 1
	popq  %r9
# 0 "" 2
# 165 "lwp.c" 1
	popq  %r8
# 0 "" 2
# 165 "lwp.c" 1
	popq  %rdi
# 0 "" 2
# 165 "lwp.c" 1
	popq  %rsi
# 0 "" 2
# 165 "lwp.c" 1
	popq  %rdx
# 0 "" 2
# 165 "lwp.c" 1
	popq  %rcx
# 0 "" 2
# 165 "lwp.c" 1
	popq  %rbx
# 0 "" 2
# 165 "lwp.c" 1
	popq  %rax
# 0 "" 2
# 165 "lwp.c" 1
	movq  %rbp,%rsp
# 0 "" 2
#NO_APP
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	lwp_stop, .-lwp_stop
	.globl	round_robin
	.type	round_robin, @function
round_robin:
.LFB8:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	lwp_running(%rip), %eax
	addl	$1, %eax
	movl	%eax, lwp_running(%rip)
	movl	lwp_running(%rip), %edx
	movl	lwp_procs(%rip), %eax
	cmpl	%eax, %edx
	jge	.L19
	movl	lwp_running(%rip), %eax
	cmpl	$-1, %eax
	jne	.L20
.L19:
	movl	$0, lwp_running(%rip)
.L20:
	movl	lwp_running(%rip), %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	round_robin, .-round_robin
	.globl	lwp_set_scheduler
	.type	lwp_set_scheduler, @function
lwp_set_scheduler:
.LFB9:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	cmpq	$0, -8(%rbp)
	je	.L23
	movq	-8(%rbp), %rax
	movq	%rax, scheduler(%rip)
	jmp	.L22
.L23:
	movq	$round_robin, scheduler(%rip)
.L22:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	lwp_set_scheduler, .-lwp_set_scheduler
	.ident	"GCC: (GNU) 4.8.5 20150623 (Red Hat 4.8.5-44)"
	.section	.note.GNU-stack,"",@progbits

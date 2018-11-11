scheduler interface:

0x27		adresl save space for loading adress to stack
0x28		adresh save space for loading adress to stack
0x29 		save space for r0
0x2a		save space for Accu
0x2b		currently running process
0x2c		status console process
0x2d		status process a
0x2e		status process b
0x2f/30		next adress to execute for console process
0x31/32		next adress to execute for process a
0x33/34		next adress to execute for process b
0x35-0x4c	saved context console proess
0x4d-0x64	saved context proess a
0x65-0x7e	saved context proess b



0x18		adresl save space for loading adress to stack
0x19		adresh save space for loading adress to stack
0x1a 		save space for r0
0x1b		save space for Accu
0x1c		currently running process
0x1d		status console process
0x1e		status process a
0x1f		status process b
0x20		status process z
0x21/22		next adress to execute for console process
0x23/24		next adress to execute for process a
0x25/26		next adress to execute for process b
0x27/28		next adress to execute for process z
0x29-0x41	saved context console proess
0x42-0x5a	saved context proecss a
0x5b-0x73	saved context proecss b
0x74-0x8c	saved context proecss z


0x27				18
0x28				19
0x29 				1a
0x2a				1b
0x2b				1c
0x2c				1d
0x2d				1e
0x2e				1f
					20
0x2f/30				21/22
0x31/32				23/24
0x33/34				25/26
					27/28
0x35-0x4c			29-41
0x4d-0x64			42-5a
0x65-0x7e			5b-73
					74-8c



0x33 sp console
0x4c a
0x63 b
0x7b z





Offsets inside saved context's
0x00		r0
0x01		r1
0x02		r2
0x03		r3
0x04		r4
0x05		r5
0x06		r6
0x07		r7
0x08		a
0x09		b
0x0a		sp
0x0b		dpl
0x0c		dph
0x0e		psw
0x0f-0x20	stack

muss noch gemaht werden: serial port reservieren, wenn busy
scheduler interface:

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
0x8f		serial is busy flag

priorities: [values from 1-4] number of timeslots per rotation
0x90/91		priority cons
0x92/93		priority a
0x94/95		priority b
0x96/97		priority z


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

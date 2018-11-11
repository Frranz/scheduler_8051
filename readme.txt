scheduler interface:
0x54		adresl save space for loading adress to stack
0x55		adresh save space for loading adress to stack
0x56 		save space for r0
0x57		save space for Accu
0x58		currently running process
0x59		status console process
0x5a		status process a
0x5b		status process b
0x5c/5d		next adress to execute for console process
0x5e/5f		next adress to execute for process a
0x60/61		next adress to execute for process b
0x68-0x87	saved context console proess
0x88-0xa7	saved context proess a
0xa8-0xc7	saved context proess b

new:
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
0x65-0x7d	saved context proess b


manche register werden nicht vernünftig gesaved
schauen, dass a nur aufgerufen wird, wenn es soll, statusänderung








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
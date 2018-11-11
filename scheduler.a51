$NOMOD51
#include <Reg517a.inc>

NAME scheduler
PUBLIC scheduler
	
EXTRN CODE(consoleProcess)	
	
	;define timer1 interupt routine
	cseg at 001bh
	jmp tihandler	
	
schedulerSegment SEGMENT CODE
	RSEG schedulerSegment
	
scheduler:
	;define process status values
	statusNotRunning equ 0
	statusStartReq equ 1
	statusRunning equ 2
	
	;start
	org 0000h
	
	;enable all interrupts
	setb eal
	
	;configure timer1
	mov th1,#0
	mov tl1,#0
	
	;enable and start timer 1
	setb et1
	setb tr1
	
	;start console process
	call consoleProcess
	jmp endloop					;should not be reached
	
	
tihandler:
	
	;save accu and r0
	mov 0x1a,r0
	mov 0x1b,A
	
	;check priorites
	;if left timeslots are 0 reset them and change to the next processs
	mov A,0x1c
	xrl A,#0
	jz prioCons
	mov A,0x1c
	xrl A,#1
	jz prioA
	mov A,0x1c
	xrl A,#2
	jz prioB
	mov A,0x1c
	xrl A,#3
	jz prioZ
	
	prioCons:
		mov A,0x91
		jnz decPrioCons
		mov 0x91,0x90
		jmp changeProcess
		decPrioCons:
			mov A,0x91
			dec A
			mov 0x91,A
			jmp returnToProcess
	prioA:
		mov A,0x93
		jnz decPrioA
		mov 0x93,0x92
		jmp changeProcess
		decPrioA:
			mov A,0x93
			dec A
			mov 0x93,A
			jmp returnToProcess
	prioB:
		mov A,0x95
		jnz decPrioB
		mov 0x95,0x94
		jmp changeProcess
		decPrioB:
			mov A,0x95
			dec A
			mov 0x95,A
			jmp returnToProcess
		
	prioZ:
		mov A,0x97
		jnz decPrioZ
		mov 0x97,0x96
		jmp changeProcess
		decPrioZ:
			mov A,0x97
			dec A
			mov 0x97,A
			jmp returnToProcess
		
	
	returnToProcess:
		;reload r0 and acc from save area
		mov r0,0x1a
		mov a,0x1b
		reti
	
	changeProcess:
	
	;save next adress of interruped process
	;find next adress space for the process
	mov A,0x1c	;moves process id in a
	rl	A		;quick multiply A by two, because adress is 2 bits long
	add A,#21h	;add offset to beginning of next adress area
	
	;move adress from stack to calculated adress
	mov r0,A
	;first pop high
	inc r0
	pop ACC
	mov @r0,A
	;then low
	dec r0
	pop ACC
	mov @r0,A
	
	;save rest of context
	mov A,0x1c
	mov r0,0x1c
	
	;calculate offset in register safe (id * size of one register store[20])
	;using rl A for convenience of multiplaying by 2
	rl A
	rl A
	rl A
	rl A
	;adding stack size
	cjne r0,#0,is1or2
	jmp afterCalculatingOffset
	is1or2:
		add A,#8
		cjne r0,#1,is2or3
		jmp afterCalculatingOffset
		is2or3:
		add A,#8
		cjne r0,#2,is3
		jmp afterCalculatingOffset
		is3:
		add A,#8
	


	afterCalculatingOffset:	
	;add start adress of register safe
	add A,#29h
	mov r0,A
	
	;save registers
	mov @r0,0x1a ;r0 from register save space
	inc r0
	mov @r0,1
	inc r0
	mov @r0,2
	inc r0
	mov @r0,3
	inc r0
	mov @r0,4
	inc r0
	mov @r0,5
	inc r0
	mov @r0,6
	inc r0
	mov @r0,7
	inc r0
	mov @r0,0x1b ;reg A from save space
	inc r0
	mov @r0,b
	inc r0
	mov @r0,SP
	inc r0
	mov @r0,dpl
	inc r0
	mov @r0,dph
	inc r0
	mov @r0,psw
	inc r0
	
	;save stack
	mov r1,#7
	mov r2,SP
	inc r2
	;saves up from 7 until sp value is reached
	saveStack:	
		mov A,@r1
		mov @r0,A
		inc r1
		inc r0
		mov A,r1
		xrl A,r2 ;to act like compare equal
		jnz saveStack
	

	
	findNextProcess:
		;find next program to execute
		mov A,0x1c
		inc A
		
		;build modulo 4 (making 0 if its 4)
		cjne A,#4,justSkipTheLineBefore
		clr A
		
		justSkipTheLineBefore:
		;save new current process
		mov 0x1c,A
		
		;check if process has status running or start request
		add A,#1dh
		mov r0,A
		mov A,@r0
		xrl A,#statusNotRunning
		jz findNextProcess

	
	;load context of next process	
	
	;switch register bank to 2
	orl psw,#00010000b
	
	;get start adress of saved context
	mov A,0x1c
	mov r0,A
	rl A
	rl A
	rl A
	rl A
	;adding stack size
	cjne r0,#0,is1or2v2
	jmp afterCalculatingOffset2
	is1or2v2:
		add A,#8
		cjne r0,#1,is2or3v2
		jmp afterCalculatingOffset2
		is2or3v2:
		add A,#8
		cjne r0,#2,is3v2
		jmp afterCalculatingOffset2
		is3v2:
		add A,#8
	


	afterCalculatingOffset2:
	;adding start adress of register safe
	add A,#29h
	mov r0,A
	
	;restore registers
	mov 0,@r0
	inc r0
	mov 1,@r0
	inc r0
	mov 2,@r0
	inc r0
	mov 3,@r0
	inc r0
	mov 4,@r0
	inc r0
	mov 5,@r0
	inc r0
	mov 6,@r0
	inc r0
	mov 7,@r0
	inc r0
	mov A,@r0
	inc r0
	mov b,@r0
	inc r0
	mov sp,@r0
	inc r0
	mov dpl,@r0
	inc r0
	mov dph,@r0
	inc r0
	
	;resave A,0
	mov 0x1b,A
	
	;restore psw later to stay in register bank 2
	mov A,r0
	mov r2,A
	inc r0
	
	;if process is in status start request set sp manually #7
	mov A,0x1c
	add A,#1dh
	cjne A,#statusStartReq,beforeRestoreStack
	mov sp,#7	;set default for sp & change status
	add A,#1dh
	mov r1,A
	mov @r0,#statusRunning
	
	
	beforeRestoreStack:
	mov r4,sp
	mov r1,#7
	mov A,r1
	xrl A,r4 ;jump over in case stack didnt grow
	jz restoreStackComplete
	restoreStack:
		mov A,@r0
		mov @r1,A
		inc r1
		inc r0
		mov A,r1
		;check if r1 equals sp
		xrl A,r4
		jnz restoreStack
	
	restoreStackComplete:
	;push return adress onto stack				
	mov A,0x1c
	rl  A
	add A,#21h
	mov r0,A
	
	mov 0x18,@r0
	inc r0
	mov 0x19,@r0
	push 0x18
	push 0x19
	
	
	;restore psw to swtich back to reg-bank 0
	mov A,r2
	mov r0,A
	mov psw,@r0
	mov A,0x1b
	
	
	reti
	
endloop:
	nop
	setb wdt
	setb swdt
	jmp endloop

	end
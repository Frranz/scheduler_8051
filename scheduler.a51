$NOMOD51
#include <Reg517a.inc>

NAME scheduler
PUBLIC scheduler
	
EXTRN CODE(consoleProcess)	
	
	;define timer2 interupt routine
	cseg at 001bh
	jmp tihandler	
	
schedulerSegment SEGMENT CODE
	; switch to the created relocatable segment
	RSEG schedulerSegment
	
scheduler:
	;define process status values
	statusNotRunning equ 0
	statusStartReq equ 1
	statusRunning equ 2
	
	;start
	org 0000h
		
	mov dptr,#consoleProcess
	mov 0x21,dpl
	mov 0x22,dph
	
	;enable all interrupts
	setb eal
	mov th1,#0
	mov tl1,#0
	
	;enable and start timer 1
	setb et1
	setb tr1
	
	;start console process DELETE THIS
	call consoleProcess
	jmp endloop
	
	
tihandler:
	;do scheduelr stuff here
	
	;save old adress
	;put accu & r0 in save space to do some basic calc
	mov 0x1a,r0
	mov 0x1b,A
	
	;save next adress of interruped process
	;find next adress space for the process
	mov A,0x1c	;moves process id in a
	rl	A		;quick multiply A by two, because adress is 2 bits long
	add A,#21h	;add offset to beginning of next adress area
	
;	;move adress from stack to calculated adress					dont save return adress, cuz we save whole stack afterwards
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
	
	;calculate offset in register safe (id * size of one register store[32])
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
	
	;actually save registers
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
		
		;build modulo 3 (making 0 if its 3)
		cjne A,#4,justSkipTheLineBefore
		clr A
		
		justSkipTheLineBefore:
		;save new current process
		mov 0x1c,A
		
		;check if started
		add A,#1dh
		mov r0,A
		mov A,@r0
		xrl A,#statusNotRunning
		jz findNextProcess
;		mov r0,A
;		cjne @r0,#statusRunning,findNextProcess
	
	;load context of next process	
	;calc context adress
	;switch register bank to 2
	orl psw,#00010000b
;	mov A,0x58
;	rl  A
;	add A,#5ch
;	mov r0,A
	
	;get start adress of saved context
	mov A,0x1c
	mov r0,A
	rl A
	rl A
	rl A
	rl A
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
	
	;restore psw later to stay in register bank 3
	mov A,r0
	mov r2,A   ;r2 now has pointer to value of psw
;	mov psw,@r0
	inc r0
	
	
	;if process is in status start request make sp manually #7
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
	xrl A,r4 ;in case stack didnt grow
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
	;push return adress onto stack				probably not necessary, because stack is saved anyways
	mov A,0x1c
	rl  A
	add A,#21h
	mov r0,A
	
	mov 0x18,@r0
	inc r0
	mov 0x19,@r0
	push 0x18
	push 0x19
	
;	mov r0,A
;	mov dpl,@r0
;	push dpl
;	inc r0
;	mov dph,@r0
;	push dph
	
	;switch register bank back to 0
	mov A,r2
	mov r0,A
	mov psw,@r0
	mov A,0x1b
;	anl psw,#11100111b
	reti
	
	jmp realend
	
findNextProg:
;	cjne r0,statusRunning,
	
	reti
	
endloop:
	nop
	setb wdt
	setb swdt
	jmp endloop
	
realend:	

	end
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
	mov 0x5c,dpl
	mov 0x5e,dph
	
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
	;put accu in save space to do some basic calc
	mov 0x57,A
	
	;save next adress of interruped process
	;find next adress space for the process
	mov A,0x58	;moves process id in a
	rl	A		;quick multiply A by two, because adress is 2 bits long
	add A,#5ch	;add offset to beginning of next adress area
	
	;move adress from stack to calculated adress
	;first pop high
	mov r0,A
	inc r0
	pop ACC
	;then low
	mov @r0,A
	dec r0
	pop ACC
	mov @r0,A
	
	findNextProcess:
		;find next program to execute
		mov A,0x58
		inc A
		
		;build modulo 3 (making 0 if its 3)
		cjne A,#3,justSkipTheLineBefore
		clr A
		
		justSkipTheLineBefore:
		;save new current process
		mov 0x58,A
		
		;check if started
		add A,#59h
		mov r0,A
		cjne @r0,#statusRunning,findNextProcess
	
	;load context of next process
	;calc context adress
	mov A,0x58
	rl  A
	add A,#5ch
	
	;push it onto stack
	mov r0,A
	mov dpl,@r0
	push dpl
	inc r0
	mov dph,@r0
	push dph
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
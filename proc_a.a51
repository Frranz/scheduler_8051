$NOMOD51
#include <Reg517a.inc>

NAME processA
PUBLIC processA
	
processASegment SEGMENT CODE
	RSEG processASegment
	
	;define process status values
	statusNotRunning equ 0
	statusStartReq equ 1
	statusRunning equ 2
	
	;serial0 values
	serialNotBlocked equ 0
	serialBlocked equ 1
	
processA:
	;prepare counting up A from 117 => u
	mov r4,#117
	
	
sendloop:
	setb wdt
	setb swdt
	mov r3,A
	mov A,0x8f
	jnz sendloop			;wait till ser0 is free
	
	
	;block serial
	mov 0x8f,#serialBlocked

	;mov char to buffer
	mov A,r4
	mov s0buf,A
	
	clr ti0
	orl s0con,#00000001b

	mov r0,A
	waitNextSend:	
		;wait till bit is send
		mov A,s0con
		jnb acc.1,waitNextSend
		anl s0con,#11111100b			;reset transmitter and receiver interrupt flag
		mov 0x8f,#serialNotBlocked

	xch A,r0
	inc A
	mov r4,A
	cjne A,#123,sendloop				;increment until letter z + 1 = (#123)

	;mark proc_a as done
	mov 0x1e,#statusNotRunning
	mov 0x8f,#serialNotBlocked

endloop:
	nop
	setb wdt
	setb swdt
	jmp endloop
	
	
	end
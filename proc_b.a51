$NOMOD51
#include <Reg517a.inc>

NAME processB
PUBLIC processB
	
	;define process status values
	statusNotRunning equ 0
	statusStartReq equ 1
	statusRunning equ 2	
	
	;serial0 values
	serialNotBlocked equ 0
	serialBlocked equ 1
	
processBSegment SEGMENT CODE
 	RSEG processBSegment	
	
	org 0000h	
		
processB:

	;prepare timer
	setb eal
	
	;configuring timer for 0.75 seconds
	mov th0,#0
	mov tl0,#0
	
	mov r1,#0xa8

	;starting timer0
	setb tr0
	
	
checktf:
	setb wdt
	setb swdt
	jnb tf0,checktf		;wait till timer 0 overflows
	
	
	clr tf0
	djnz r1,checktf
	
	;wait for ser0 to be ready
	waitForSerial:
		mov A,0x8f
		jnz	waitForSerial
		mov 0x8f,#serialBlocked			;block ser0
		
	
	;push * sign to buffer
	mov s0buf,#42
	orl s0con,#00000001b
	
	waitNextSend:	
		;wait till byte is sent
		mov A,s0con
		jnb acc.0,waitNextSend
		anl s0con,#11111100b			;reset transmitter and receiver interrupt flag
		mov 0x8f,#serialNotBlocked
	
	
	jmp processB
	
	
endloop:
	nop
	setb wdt
	setb swdt
	jmp endloop
	
	ret

;tihandler:
;	dec r1
;	djnz r1,checktf
;	
;	mov r3,#11h	 	
	

	end
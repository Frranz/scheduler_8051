$NOMOD51
#include <Reg517a.inc>

NAME processB
PUBLIC processB
	
	;define process status values
	statusNotRunning equ 0
	statusStartReq equ 1
	statusRunning equ 2	
	
processBSegment SEGMENT CODE
	; switch to the created relocatable segment
 	RSEG processBSegment	
	
	org 0000h	
		
;do random stuff
processB:

	;prepare timer
	setb eal
;	setb et0
	
	;configuring timer for 0.75 seconds
	mov th0,#0
	mov tl0,#0
	
	;15 cuz on timer runs 0,065536s
	mov r1,#0xa8

	;starting timer
	setb tr0
	
	
checktf:
	setb wdt
	setb swdt
	jnb tf0,checktf
;	clr tf0
;	setb tr0
	clr tf0
	djnz r1,checktf
	
	mov s0buf,#42
	orl s0con,#00000001b
	waitNextSend:	
		;wartet bis bit abgesendet
		mov A,s0con
		jnb acc.1,waitNextSend
		anl s0con,#11111100b			;reset transmitter and receiver interrupt flag
	
	;mark proc_b as done
	jmp processB
;	mov 0x2e,#statusNotRunning
endloop:
	nop
	setb wdt
	setb swdt
	jmp endloop
	
	ret

tihandler:
	dec r1
	djnz r1,checktf
	
	mov r3,#11h	 	
	

	end
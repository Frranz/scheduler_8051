$NOMOD51
#include <Reg517a.inc>

NAME processB
PUBLIC processB
	
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
	mov th1,#0
	
	;15 cuz on timer runs 0,065536s
	mov r1,#0xfe

	;starting timer
	setb tr0
	
	
checktf:
	setb wdt
	setb swdt
	jnb tf0,checktf
;	setb tr0
	
	dec r1
	clr tf0
	djnz r1,checktf
	
	mov r3,#11h	
	
	mov s0buf,#'*'
	orl s0con,#00000001b

waitNextSend:
		;wartet bis abgesendet
		mov A,s0con
		jnb acc.1,waitNextSend
		anl s0con,#11111101b
	
	jmp checktf

tihandler:
	dec r1
	djnz r1,checktf
	
	mov r3,#11h	 	
	

	end
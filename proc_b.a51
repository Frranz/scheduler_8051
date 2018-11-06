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
	
	dec r1
	clr tf0
	djnz r1,checktf
	
	mov r3,#11h	 	
	
endloop:
	nop
	jmp endloop
	
	ret

tihandler:
	dec r1
	djnz r1,checktf
	
	mov r3,#11h	 	
	

	end
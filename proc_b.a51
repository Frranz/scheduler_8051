$NOMOD51
#include <Reg517a.inc>

NAME processB
PUBLIC processB
	
processBSegment SEGMENT CODE
	; switch to the created relocatable segment
	RSEG processBSegment
		
;do random stuff
processB:

	;prepare timer
	setb eal
	setb et0
	
	;configuring timer for 0.75 seconds
	mov th0,#0
	mov th1,#0
	
	;15 cuz on timer runs 0,065536s
	mov r1,#15

	setb tr0
	
checktf:
	jnb tf0,checktf
	jmp endloop
;	clr tf0
;	setb tr0
	
	dec r1
	djnz r1,checktf
	
	mov r3,#11h	 	
	
endloop:
	nop
	jmp endloop
	
	ret

	end
$NOMOD51
#include <Reg517a.inc>

NAME processB
PUBLIC processB
	
processBSegment SEGMENT CODE
	; switch to the created relocatable segment
	RSEG processBSegment
		
;do random stuff
processB:
	mov r1,#1
	mov r2,#2
	mov r3,#3
	end
$NOMOD51
#include <Reg517a.inc>

NAME processA
PUBLIC processA
	
processASegment SEGMENT CODE
	; switch to the created relocatable segment
	RSEG processASegment
		
;do random stuff
processA:
	mov r4,#4
	mov r5,#5
	mov r6,#6
	mov r7,#7
	end
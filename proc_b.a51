$NOMOD51
#include <Reg517a.inc>

NAME processA
PUBLIC processA
	
processASegment SEGMENT CODE
	; switch to the created relocatable segment
	RSEG processASegment
		
;do random stuff
processA:
	mov r1,#1
	mov r2,#2
	mov r3,#3
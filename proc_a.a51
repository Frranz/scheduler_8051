$NOMOD51
#include <Reg517a.inc>

NAME processA
PUBLIC processA
	
processASegment SEGMENT CODE
	; switch to the created relocatable segment
	RSEG processASegment
	
	;define process status values
	statusNotRunning equ 0
	statusStartReq equ 1
	statusRunning equ 2
	
;do random stuff
processA:
	;prep counting up A from 117 => u
	mov A,#117
	;send: 
	
sendloop:
	mov s0buf,A
	orl s0con,#00000001b

	mov r0,A
	waitNextSend:	
		;wartet bis bit abgesendet
		mov A,s0con
		jnb acc.1,waitNextSend
		anl s0con,#11111101b

	xch A,r0
	inc A
	cjne A,#123,sendloop

	;mark proc_a as done
	mov 0x5a,#statusNotRunning

endloop:
	nop
	setb wdt
	setb swdt
	jmp endloop
	
	
	end
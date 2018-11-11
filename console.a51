$NOMOD51
#include <Reg517a.inc>

NAME consoleProcess
PUBLIC consoleProcess

EXTRN CODE (processA,processB,fkt_text)

consoleSegment SEGMENT CODE
	; switch to the created relocatable segment
	RSEG consoleSegment
		
	;define process status values
	statusNotRunning equ 0
	statusStartReq equ 1
	statusRunning equ 2

consoleProcess:	

	;testing stuff
	mov r0,#17h
	mov r1,#58h
	mov r6,#33h
	mov r7,#19h
	mov A,#93h

;configure seriel port 0
	mov s0con,#01010000b
	mov adcon0,#11000000b
	mov s0relh,#00000011b
	mov s0rell,#11011001b

waitloop:
	;check if receive interrupt flag is set
	setb wdt
	setb swdt
	mov A,0x8f
	jnz waitloop			;wenn serial busy ist
	jnb RI0,waitloop
	mov r1,s0buf
	
	;check if input was a
	mov A,r1
	SUBB A,#97
	jz  inpIsA
	
	;check if input was b
	dec A
	jz  inpIsB
	
	;check if input was c
	dec A
	jz  inpIsC
	
	;check if input was z
	subb A,#23
	jz  inpIsZ
	jmp readMoreInput
	
	

inpIsA:
	;load status proc A in Reg A
	mov A,0x1e
	
	;check if A is not running already
	cjne A,#statusNotRunning,readMoreInput
	
	;queue in for start by changing status and setting start adress
	mov 0x1e,#statusStartReq
	mov dptr,#processA
	mov 0x23,dpl
	mov 0x24,dph
	mov 0x93,0x92
	
;	call processA
	jmp readMoreInput

inpIsB:
	;load status proc B in Reg A
	mov A,0x1f
	
	;check if b is not running already
	cjne A,#statusNotRunning,readMoreInput
	
	;queue in for start by changing status and setting start adress
	mov 0x1f,#statusStartReq
	mov dptr,#processB
	mov 0x25,dpl
	mov 0x26,dph
	mov 0x95,0x94
	
	;call process b
	jmp readMoreInput

inpIsC:
	;0x2e status of process b
	mov 0x1f,#statusNotRunning
	jmp readMoreInput

inpIsZ:
	;load status fkttext in Reg A
	mov A,0x20
	
	;check if fkt_Text is running already
	cjne A,#statusNotRunning,stopZ
	
	;queue in for start by changing status and setting start adress
	mov 0x20,#statusStartReq
	mov dptr,#fkt_text
	mov 0x27,dpl
	mov 0x28,dph
	mov 0x97,0x96
	jmp readMoreInput

stopZ:
	mov 0x20,#statusNotRunning
	jmp readMoreInput

readMoreInput:
	clr RI0
	jmp waitloop

endloop:
	nop
	setb wdt
	setb swdt
	jmp endloop
	end

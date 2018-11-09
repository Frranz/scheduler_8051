$NOMOD51
#include <Reg517a.inc>

NAME consoleProcess
PUBLIC consoleProcess

EXTRN CODE (processA,processB)

consoleSegment SEGMENT CODE
	; switch to the created relocatable segment
	RSEG consoleSegment
		
	;define process status values
	statusNotRunning equ 0
	statusStartReq equ 1
	statusRunning equ 2

consoleProcess:	

;configure seriel port 0
	mov s0con,#01010000b
	mov adcon0,#11000000b
	mov s0relh,#00000011b
	mov s0rell,#11011001b

waitloop:
	;check if receive interrupt flag is set
	setb wdt
	setb swdt
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
	add A,r1
	subb A,#122
	jz  inpIsZ
	
	

inpIsA:
	;load status proc A in Reg A
	mov A,0x60
	
	;check if A is not running already
	cjne A,#0,readMoreInput
	
	;check if A is not queued for being ready
	cjne A,#1,readMoreInput
	
	;change status to request starting
	mov 0x60,#2
	
;	call processA
	jmp readMoreInput

inpIsB:
	;load status proc A in Reg A
	mov A,0x61
	
	;check if A is not running already
	cjne A,#0,readMoreInput
	
	;check if A is not queued for being ready
	cjne A,#1,readMoreInput
	
	;change status to request starting
	mov 0x61,#2	
	
	;call process b
	jmp readMoreInput

inpIsC:
	jmp readMoreInput

inpIsZ:
	jmp readMoreInput

readMoreInput:
	clr RI0
	jmp endloop
	
endloop:
	nop
	setb wdt
	setb swdt
	jmp endloop
	end

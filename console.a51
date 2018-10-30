$NOMOD51
#include <Reg517a.inc>

EXTRN CODE (processA)

;configure seriel port 0
	mov s0con,#01010000b
	mov adcon0,#11000000b
	mov s0relh,#00000011b
	mov s0rell,#11011001b

waitloop:
	;check if receive interrupt flag is set
	jnb RI0,waitloop
	mov r1,s0buf
	
	;check if input was a
	mov A,r1
	SUBB A,#97
	jz  inpIsA
	
	;check if input was b
	inc A
	jz  inpIsB
	
	;check if input was c
	inc A
	jz  inpIsC
	
	;check if input was z
	add A,r1
	subb A,#122
	jz  inpIsZ
	
	

inpIsA:
	call processA
	jmp readMoreInput

inpIsB:
	call processA
	jmp readMoreInput

inpIsC:
	jmp readMoreInput

inpIsZ:
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
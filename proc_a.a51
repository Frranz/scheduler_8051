$NOMOD51
#include <Reg517a.inc>

NAME processA
PUBLIC processA
	
processASegment SEGMENT CODE
	RSEG processASegment
	
	;definiere Prozess-Statuswerte
	statusNotRunning equ 0
	statusStartReq equ 1
	statusRunning equ 2
	
	;serial0 Statuswerte
	serialNotBlocked equ 0
	serialBlocked equ 1
	
processA:
	;hochzählen vorbereiten 117 => u
	mov r4,#117
	
	
sendloop:
	setb wdt
	setb swdt
	mov r3,A
	mov A,0x8f
	jnz sendloop			;warten bis ser0 frei
	
	
	; serial blocken
	mov 0x8f,#serialBlocked

	;Zeichen in Buffer schieben
	mov A,r4
	mov s0buf,A
	
	clr ti0
	orl s0con,#00000001b

	mov r0,A
	waitNextSend:	
		;warten bis Byte gesendet
		mov A,s0con
		jnb acc.1,waitNextSend
		anl s0con,#11111100b			;resetten von Transmitter und Receiver Interrupt Flag
		mov 0x8f,#serialNotBlocked

	xch A,r0
	inc A
	mov r4,A
	cjne A,#123,sendloop				;erhöhen bis z + 1 = (#123)

	;Proc_A Status auf beendet
	mov 0x1e,#statusNotRunning
	mov 0x8f,#serialNotBlocked

endloop:
	nop
	setb wdt
	setb swdt
	jmp endloop
	
	
	end
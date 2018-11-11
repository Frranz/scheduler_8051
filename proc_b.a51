$NOMOD51
#include <Reg517a.inc>

NAME processB
PUBLIC processB
	
	;definiere Prozess-Statuswerte
	statusNotRunning equ 0
	statusStartReq equ 1
	statusRunning equ 2	
	
	;serial0 Statuswerte
	serialNotBlocked equ 0
	serialBlocked equ 1
	
processBSegment SEGMENT CODE
 	RSEG processBSegment	
	
	org 0000h	
		
processB:

	;Timer vorbereiten
	setb eal
	
	;Einstellen auf 0.75 Sekunden
	mov th0,#0
	mov tl0,#0
	
	mov r1,#0xa8

	;timer0 starten
	setb tr0
	
	
checktf:
	setb wdt
	setb swdt
	jnb tf0,checktf		;warten bis Timer 0 Überlauf
	
	
	clr tf0
	djnz r1,checktf
	
	;warten bis ser0 frei
	waitForSerial:
		mov A,0x8f
		jnz	waitForSerial
		mov 0x8f,#serialBlocked			;blockiere ser0
		
	
	;schreibe * in buffer
	mov s0buf,#42
	orl s0con,#00000001b
	
	waitNextSend:	
		;warten bis Byte gesendet
		mov A,s0con
		jnb acc.0,waitNextSend
		anl s0con,#11111100b			;resetten von Transmitter und Receiver Interrupt Flag
		mov 0x8f,#serialNotBlocked
	
	
	jmp processB
	
	
endloop:
	nop
	setb wdt
	setb swdt
	jmp endloop
	
	ret
	

	end
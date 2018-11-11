$NOMOD51
#include <Reg517a.inc>

NAME consoleProcess
PUBLIC consoleProcess

EXTRN CODE (processA,processB,fkt_text)


consoleSegment SEGMENT CODE
	RSEG consoleSegment
		
	;definiere Statuswerte
	statusNotRunning equ 0
	statusStartReq equ 1
	statusRunning equ 2

consoleProcess:	

;konfiguriere seriel port 0
	mov s0con,#01010000b
	mov adcon0,#11000000b
	mov s0relh,#00000011b
	mov s0rell,#11011001b

waitloop:
	;interupt flag überprüfen
	setb wdt
	setb swdt
	mov A,0x8f
	jnz waitloop			;warten bis ser0 nicht mehr geblockt
	jnb RI0,waitloop
	mov r1,s0buf
	
	;überprüfen ob a eingegeben
	mov A,r1
	SUBB A,#97
	jz  inpIsA
	
	;überprüfen ob b eingegeben
	dec A
	jz  inpIsB
	
	;überprüfen ob c eingegeben
	dec A
	jz  inpIsC
	
	;überprüfen ob z eingegeben
	subb A,#23
	jz  inpIsZ
	
	;sonstige Eingabe
	jmp readMoreInput
	
	

inpIsA:
	;lade Status von Proc_A in Akku
	mov A,0x1e
	
	;überprüfen ob Proc_A schon läuft
	cjne A,#statusNotRunning,readMoreInput
	
	;Status ändern, Startadresse eintragen, Sriorität setzen
	mov 0x1e,#statusStartReq
	mov dptr,#processA
	mov 0x23,dpl
	mov 0x24,dph
	mov 0x93,0x92
	
	
	jmp readMoreInput

inpIsB:
	;lade Status von Proc_B in Akku
	mov A,0x1f
	
	;überprüfen ob Proc_B schon läuft
	cjne A,#statusNotRunning,readMoreInput
	
	;Status ändern, Startadresse eintragen, Priorität setzen
	mov 0x1f,#statusStartReq
	mov dptr,#processB
	mov 0x25,dpl
	mov 0x26,dph
	mov 0x95,0x94
	
	
	jmp readMoreInput

inpIsC:
	;Status von b auf notrunning setzen
	mov 0x1f,#statusNotRunning
	jmp readMoreInput

inpIsZ:
	;lade Status von fkt_text in Akku
	mov A,0x20
	
	;überprüfen ob fkt_txt schon läuft
	cjne A,#statusNotRunning,stopZ
	
	;Status ändern, Startadresse eintragen, Priorität setzen
	mov 0x20,#statusStartReq
	mov dptr,#fkt_text
	mov 0x27,dpl
	mov 0x28,dph
	mov 0x97,0x96
	jmp readMoreInput

stopZ:
	;Status von fkt_text ändern
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

$NOMOD51
#include <Reg517a.inc>

;NAME init
;PUBLIC init
	
EXTRN CODE (scheduler,consoleProcess)
	
	
	;definiere Prozess Statuswerte
	statusNotRunning equ 0
	statusStartReq equ 1
	statusRunning equ 2
		
	;Werte für ser0 Status
	serialNotBlocked equ 0
	serialBlocked equ 1
		
	org 0
	jmp start
	
	programCode SEGMENT CODE
		RSEG programCode
	
start:	
	
;Standardwerte für Prozesskontrolle setzen
	
	;Konsole als Startprozess wählen
	mov 0x1c,#0	
	
	;Startadresse für Konsolenprozess setzen
	mov dptr,#consoleProcess
	mov 0x21,dpl
	mov 0x22,dph
	
	;Prozessstatus'	[cons,a,b]
	mov 0x1d,#statusRunning
	mov 0x1e,#statusNotRunning
	mov 0x1f,#statusNotRunning
	
	;nächsten Adreessen [cons,a,b] 2-byte jeweils
	mov 0x21,#0;
	mov 0x22,#0
	mov 0x23,#0	
	mov 0x24,#0	
	mov 0x25,#0	
	mov 0x26,#0	
	mov 0x27,#0
	mov 0x28,#0
		
	;Standardstackpointer auf 0x07
	mov 0x3f,#7
	mov 0x4b,#7
	mov 0x63,#7
	mov 0x7b,#7
	
	;Prioritäten
	mov 0x90,#3
	mov 0x92,#2
	mov 0x94,#2
	mov 0x96,#4
	
	;ser0 Status byte
	mov 0x8f,#serialNotBlocked
	
	call scheduler
	
	end
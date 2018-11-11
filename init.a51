$NOMOD51
#include <Reg517a.inc>

;NAME init
;PUBLIC init
	
EXTRN CODE (scheduler,consoleProcess)
	
	
	;define process status values
	statusNotRunning equ 0
	statusStartReq equ 1
	statusRunning equ 2
		
	;serial  values
	serialNotBlocked equ 0
	serialBlocked equ 1
		
	org 0
	jmp start
	
	programCode SEGMENT CODE
		RSEG programCode
	
start:	
	
;set default values for process control
	
	;set console as first process to start
	mov 0x1c,#0	;so the scheduler knows which process was running (console is started by hand as first)			;2+1%3 = 0 ==> id of console process
	
	;set start adress for console process
	mov dptr,#consoleProcess
	mov 0x21,dpl
	mov 0x22,dph
	
	;process status [cons,a,b]
	mov 0x1d,#statusRunning
	mov 0x1e,#statusNotRunning
	mov 0x1f,#statusNotRunning
	
	;next adress [cons,a,b]
	mov 0x21,#0;
	mov 0x22,#0
	mov 0x23,#0	
	mov 0x24,#0	
	mov 0x25,#0	
	mov 0x26,#0	
	mov 0x27,#0
	mov 0x28,#0
		
	;save area for registers
	;set default stack pointers to 0x07
	mov 0x3f,#7
	mov 0x4b,#7
	mov 0x63,#7; checken ob das passt, wegen doofer rechnung vorher
	mov 0x7b,#7
	
	;priorities
	mov 0x90,#3
	mov 0x92,#2
	mov 0x94,#2
	mov 0x96,#4
	
	;serialisbusy byte
	mov 0x8f,#serialNotBlocked
	
	call scheduler
	
	end
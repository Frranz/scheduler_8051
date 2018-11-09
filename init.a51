$NOMOD51
#include <Reg517a.inc>

;NAME init
;PUBLIC init
	
EXTRN CODE (scheduler)
	
	
	;define process status values
	statusNotRunning equ 0
	statusStartReq equ 1
	statusRunning equ 2
		
	org 0
	jmp start
	/*
		scheduler interface:
		
		0x57		save space for Accu
		0x58		currently running process
		0x59		status console process
		0x60		status process a
		0x61		status process b
		0x62/63		next adress to execute for console process
		0x64/65		next adress to execute for process a
		0x66/67		next adress to execute for process b
		0x68-0x??	saved context console proess
		0x??-0x??	saved context proess a
		0x??-0x??	saved context proess b
	*/
	
	programCode SEGMENT CODE
		RSEG programCode
	
start:	
	
	;set default values for process control
	;set console as first process to start
	mov 0x58,#0	;so the scheduler knows which process was running (console is started by hand as first)			;2+1%3 = 0 ==> id of console process
	
	;process status [cons,a,b]
	mov 0x59,#statusRunning
	mov 0x5a,#statusNotRunning
	mov 0x5b,#statusNotRunning
	
	;next adress [cons,a,b]
	mov 0x5c,#0;#consoleProcess causes improper fixup error
	mov 0x5d,#0
	mov 0x5e,#0	
	mov 0x5f,#0	
	mov 0x60,#0	
	mov 0x61,#0	
		
	;save area for registers
	;....
	
	call scheduler
	
	end
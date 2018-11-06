$NOMOD51
#include <Reg517a.inc>

EXTRN CODE (consoleProcess)
	
	;define timer2 interupt routine
	org 001bh
	jmp tihandler
	
	;start
	org 0000h
		
	;enable all interrupts
	setb eal
	mov th1,#0
	mov tl1,#0
	
	;enable and start timer 1
	setb et1
	setb tr1
	
	;start console process
	call consoleProcess
	jmp endloop
	
	
tihandler:
	mov r1,0
	
	reti
	
endloop:
	nop
	setb wdt
	setb swdt
	jmp endloop
	
	end
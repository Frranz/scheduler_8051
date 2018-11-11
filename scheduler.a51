$NOMOD51
#include <Reg517a.inc>

NAME scheduler
PUBLIC scheduler
	
EXTRN CODE(consoleProcess)	
	
	;definiere timer1 Interrupt-Routine
	cseg at 001bh
	jmp tihandler	
	
schedulerSegment SEGMENT CODE
	RSEG schedulerSegment
	
scheduler:
	;definiere Prozess-Statuswerte
	statusNotRunning equ 0
	statusStartReq equ 1
	statusRunning equ 2
	
	;start
	org 0000h
	
	;Interupts freischalten
	setb eal
	
	;Einstellen von Timer1
	mov th1,#0
	mov tl1,#0
	
	;aktivieren und starten von Timer1
	setb et1
	setb tr1
	
	;starte Consolenprocess
	call consoleProcess
	jmp endloop					;sollte nicht erreicht werden
	
	
tihandler:
	
	;sichere Akku und r0
	mov 0x1a,r0
	mov 0x1b,A
	
	;check Prioritäten
	;wenn übrige Zeitscheiben=0, reset und wechseln zu anderen Prozess
	mov A,0x1c
	xrl A,#0
	jz prioCons
	mov A,0x1c
	xrl A,#1
	jz prioA
	mov A,0x1c
	xrl A,#2
	jz prioB
	mov A,0x1c
	xrl A,#3
	jz prioZ
	
	prioCons:
		mov A,0x91
		jnz decPrioCons
		mov 0x91,0x90
		jmp changeProcess
		decPrioCons:
			mov A,0x91
			dec A
			mov 0x91,A
			jmp returnToProcess
	prioA:
		mov A,0x93
		jnz decPrioA
		mov 0x93,0x92
		jmp changeProcess
		decPrioA:
			mov A,0x93
			dec A
			mov 0x93,A
			jmp returnToProcess
	prioB:
		mov A,0x95
		jnz decPrioB
		mov 0x95,0x94
		jmp changeProcess
		decPrioB:
			mov A,0x95
			dec A
			mov 0x95,A
			jmp returnToProcess
		
	prioZ:
		mov A,0x97
		jnz decPrioZ
		mov 0x97,0x96
		jmp changeProcess
		decPrioZ:
			mov A,0x97
			dec A
			mov 0x97,A
			jmp returnToProcess
		
	
	returnToProcess:
		;Wiederherstellen von r0 und Akku aus Sicherungsbereich
		mov r0,0x1a
		mov a,0x1b
		reti
	
	changeProcess:
	
	;sichere nächste Adresse von unterbrochenem Prozess
	;berechne Bereich für nächste Adressse von Prozess
	mov A,0x1c	;moved process id in a
	rl	A		;multiplizieren * 2, weil Adresslänge=2byte
	add A,#21h	;addiere Offset des Beginnes des Sicherungsbereichs
	
	;Rücksprungadresse vom Stack zu berechneter Adresse schreiben
	mov r0,A
	;zuerst pop high
	inc r0
	pop ACC
	mov @r0,A
	;dann low
	dec r0
	pop ACC
	mov @r0,A
	
	;sichere den restlichen Kontext
	mov A,0x1c
	mov r0,0x1c
	
	;berechne Offset innerhalb der Registersicherung (id * größe eines Registerspeichers[20])
	;multipliziern mit 16 über rl a 16=2^4
	rl A
	rl A
	rl A
	rl A
	;Stackgröße hinzufügen
	cjne r0,#0,is1or2
	jmp afterCalculatingOffset
	is1or2:
		add A,#8
		cjne r0,#1,is2or3
		jmp afterCalculatingOffset
		is2or3:
		add A,#8
		cjne r0,#2,is3
		jmp afterCalculatingOffset
		is3:
		add A,#8
	


	afterCalculatingOffset:	
	;Startadresse des Sicherungsbereiches addieren
	add A,#29h
	mov r0,A
	
	;Register sichern
	mov @r0,0x1a ;r0 aus gesondertem Sicherungsbereich für r0
	inc r0
	mov @r0,1
	inc r0
	mov @r0,2
	inc r0
	mov @r0,3
	inc r0
	mov @r0,4
	inc r0
	mov @r0,5
	inc r0
	mov @r0,6
	inc r0
	mov @r0,7
	inc r0
	mov @r0,0x1b ;A aus gesondertem Sicherungsbereich für r0
	inc r0
	mov @r0,b
	inc r0
	mov @r0,SP
	inc r0
	mov @r0,dpl
	inc r0
	mov @r0,dph
	inc r0
	mov @r0,psw
	inc r0
	
	;sichere stack
	mov r1,#7
	mov r2,SP
	inc r2
	;sichert von 7 hoch, bis SP erreicht
	saveStack:	
		mov A,@r1
		mov @r0,A
		inc r1
		inc r0
		mov A,r1
		xrl A,r2 ; vergleich r1,r2 auf gleichheit
		jnz saveStack
	

	
	findNextProcess:
		;finde nächsten Prozess
		mov A,0x1c
		inc A
		
		; modulo 4 (macht 0 wenn =4)
		cjne A,#4,justSkipTheLineBefore
		clr A
		
		justSkipTheLineBefore:
		;sicheren des neuen aktuellen Prozesses
		mov 0x1c,A
		
		;überprüfen, dass Prozessstatus=Running oder ReqStart
		add A,#1dh
		mov r0,A
		mov A,@r0
		xrl A,#statusNotRunning
		jz findNextProcess

	
	;lade Kontext des nächsten Prozesses
	
	;wechsele Registerbank auf 2
	orl psw,#00010000b
	
	;Startadresse des gesicherten Kontext berechnen
	mov A,0x1c
	mov r0,A
	rl A
	rl A
	rl A
	rl A
	;Stack-Größe addieren
	cjne r0,#0,is1or2v2
	jmp afterCalculatingOffset2
	is1or2v2:
		add A,#8
		cjne r0,#1,is2or3v2
		jmp afterCalculatingOffset2
		is2or3v2:
		add A,#8
		cjne r0,#2,is3v2
		jmp afterCalculatingOffset2
		is3v2:
		add A,#8
	


	afterCalculatingOffset2:
	;Startadresse des Register-Sicherungsbereiches hinzufügen
	add A,#29h
	mov r0,A
	
	;Register wiederherstellen
	mov 0,@r0
	inc r0
	mov 1,@r0
	inc r0
	mov 2,@r0
	inc r0
	mov 3,@r0
	inc r0
	mov 4,@r0
	inc r0
	mov 5,@r0
	inc r0
	mov 6,@r0
	inc r0
	mov 7,@r0
	inc r0
	mov A,@r0
	inc r0
	mov b,@r0
	inc r0
	mov sp,@r0
	inc r0
	mov dpl,@r0
	inc r0
	mov dph,@r0
	inc r0
	
	;sichern von A,0
	mov 0x1b,A
	
	;sichere psw um in Registerbank 2 zu bleiben (PSW wird später ersetzt)
	mov A,r0
	mov r2,A
	inc r0
	
	;Wenn Prozessstatus 1 oder 2, SP manuel auf #7 setzen
 	mov A,0x1c
	add A,#1dh
	cjne A,#statusStartReq,beforeRestoreStack
	mov sp,#7	;set default for sp & change status
	add A,#1dh
	mov r1,A
	mov @r0,#statusRunning
	
	
	beforeRestoreStack:
	mov r4,sp
	mov r1,#7
	mov A,r1
	xrl A,r4 ;jump over in case stack didnt grow
	jz restoreStackComplete
	restoreStack:
		mov A,@r0
		mov @r1,A
		inc r1
		inc r0
		mov A,r1
		;check if r1 equals sp
		xrl A,r4
		jnz restoreStack
	
	restoreStackComplete:
	;Rücksprungadresse auf Stack legen				
	mov A,0x1c
	rl  A
	add A,#21h
	mov r0,A
	
	mov 0x18,@r0
	inc r0
	mov 0x19,@r0
	push 0x18
	push 0x19
	
	
	;psw auf Prozesswert ändern
	mov A,r2
	mov r0,A
	mov psw,@r0
	mov A,0x1b
	
	
	reti
	
endloop:
	nop
	setb wdt
	setb swdt
	jmp endloop

	end
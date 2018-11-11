$NOMOD51
#include <Reg517a.inc>

public	fkt_text

my_code	segment CODE
	rseg	my_code

fkt_text: ; Ausgabe auf Seriel 1 (S1BUF)
;------------------------------
; Serial Interface 1
; 8 Datenbits, variable Baudrate
;	-> Mode B
;	=> SM = 1
;	SETB	SM; geht nicht, s.o. 
; Empfang freigeben -> REN1 = 1
;	SETB	REN1; geht nicht, s.o.
; noch nichts empfangen -> TI1 =0 
;	CLR	TI1; geht nicht, s.o.
;	aber S1CON = SM|.|.|REN1|.|.|TI1|.
	MOV	A, S1CON
	ORL	A, #10010000B
	ANL	A, #1111$1101B
	MOV	S1CON, A
; Baudrate
;	Baudrate = XTAL /(32*(2^10-S1REL))
;	9600 1/s -> S1REL = 3B2h
;		=> S1RELH = 3
;		=> S1RELL = B2H
	MOV	S1RELH, # 3
	MOV	S1RELL, #0B2h
; senden bereit
 	ORL S1CON,#0000$0010B ;Set of TI1
;---------------------------------------
txt_init:
	mov	r7, #0xff;
txt_schleife:
	mov	r0, #0
	inc	r7
	anl	7, #0x0f	; eigendlich ANL R7, #0x0F; zum zählen bis 15
	;
	mov	a, r7
	call	Stelle6
	mov	a, r0
	rlc	a
	mov	r0, a	
	;
	mov	a, r7
	call	Stelle5
	mov	a, r0
	rlc	a
	mov	r0, a	
	;
	mov	a, r7
	call	Stelle4
	mov	a, r0
	rlc	a
	mov	r0, a	
	;
	mov	a, r7
	call	Stelle3
	mov	a, r0
	rlc	a
	mov	r0, a	
	;
	mov	a, r7
	call	Stelle2
	mov	a, r0
	rlc	a
	mov	r0, a	
	;
	mov	a, r7
	call	Stelle1
	mov	a, r0
	rlc	a
	mov	r0, a	
	; nach 
	mov	a, r0
	add	a, #64
	mov	r0, a	
	nop
txt_warten:
;	jbc TI0, txt_ausgabe
;	setb	wdt
;	setb	swdt
	; Warteschleife zur Zeitverzögerung
	mov	r3, #16
txt_R3:
	mov	r2, #0
txt_R2:
	mov	r1, #0
txt_R1:
	nop
	djnz	r1, txt_R1
	nop
	djnz	r2, txt_R2
	nop
	djnz	r3, txt_R3

;	jmp	txt_warten

txt_ser:
;test ob gesendet S1
	MOV A,S1CON
	JB ACC.1, txt_ausgabe_S1 ;TI1
	jmp	txt_ser
;-----------
txt_ausgabe_S1:
	ANL S1CON,#1111$1101B ;Resetting of TI1
	MOV	S1BUF, r0
	jmp	txt_schleife
;
	ret	; sollte nie erreicht werden
; ----------------------------------------------------

Stelle6:
	mov	c, acc.1
	anl	c, acc.2
	anl	c, /acc.3	
		mov	f1, c		; sichern
	mov	c, acc.3
	anl	c, /acc.2
		orl	c, f1		
		mov	f1, c		; sichern
	mov	c, acc.3
	anl	c, /acc.1
		orl	c, f1
	ret
Stelle5:
	mov	c, acc.0
	anl	c, acc.1
	anl	c, /acc.3	
		mov	f1, c		; sichern
	mov	c, acc.3
	anl	c, /acc.1
		orl	c, f1
		mov	f1, c
	mov	c, acc.1
	anl	c, acc.2
		orl	c, f1
		mov	f1, c
	mov	c, acc.0
	anl	c, acc.2
		orl	c, f1
	ret
Stelle4:
	mov	c, acc.0
	anl	c, /acc.1
	anl	c, /acc.2
	anl	c, /acc.3
		mov	f1, c
	mov	c, acc.1
	anl	c, acc.2
	anl	c, acc.3
		orl	c, f1
	ret
Stelle3:
	mov	c, acc.0
	anl	c, acc.1
	anl	c, /acc.3
		mov	f1, c
	mov	c, acc.0
	cpl	c
	anl	c, /acc.1
	anl	c, /acc.2
		orl	c, f1
		mov	f1, c
	mov	c, acc.3
	anl	c, /acc.2
	anl	c, /acc.0
		orl	c, f1
		mov	f1, c
	mov	c, acc.0
	anl	c, /acc.1
	anl	c, acc.3
		orl	c, f1
		mov	f1, c
	mov	c, acc.2
	anl	c, acc.1
		orl	c, f1
	ret
Stelle2:
	mov	c, acc.1
	anl	c, /acc.2
	anl	c, /acc.3
		mov	f1, c
	mov	c, acc.0
	anl	c, /acc.1
	anl	c, acc.2
	anl	c, /acc.3
		orl	c, f1
		mov	f1, c
	mov	c, acc.1
	anl	c, /acc.0
	anl	c, /acc.2
		orl	c, f1
		mov	f1, c
	mov	c, acc.3
	anl	c, acc.2
	anl	c, /acc.0
		orl	c, f1
		mov	f1, c
	mov	c, acc.1
	anl	c, acc.2
	anl	c, acc.3
		orl	c, f1
	ret
Stelle1:
	mov	c, acc.0
	anl	c, acc.2
	anl	c, /acc.3
		mov	f1, c
	mov	c, acc.1
	anl	c, acc.3
		orl	c, f1
		mov f1, c
	mov c, acc.0
	anl c, acc.1
		orl c, f1
	ret
end

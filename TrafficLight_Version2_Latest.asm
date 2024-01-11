		ORG	00H
		AJMP	MAIN

MAIN:		MOV	A,#00H
		MOV	P0,A	; Set Port 0 as output for Green Light and Red Light
		MOV	P1,A	; Set Port 0 as output for 7 Segment display
		MOV	P2,A	; Set Port 2 as output for Yellow Light
		MOV	DPTR,#SEG


START:		AJMP	TRAFFIC1	; Start the whole traffic from traffic 1

TRAFFIC1:	; G1 is on while other R is off
		; 10 01 01 01
		MOV	A,#95H
		ACALL	TRAFFIC_ROUTINE
		; G1 is off
		; 00 01 01 01
		MOV	A,#15H
		MOV	P0,A
		; YELLOW 1 is on
		; 1 0 0 0
		MOV	A,#08H
		ACALL	YELLOW_ROUTINE

TRAFFIC2:	; G2 is on while other R is off
		; 01 10 01 01
		MOV	A,#65H
		ACALL	TRAFFIC_ROUTINE
		; G2 is off
		; 01 00 01 01
		MOV	A,#45H
		MOV	P0,A
		; YELLOW 2 is on
		; 0 1 0 0
		MOV	A,#04H
		ACALL	YELLOW_ROUTINE

TRAFFIC3:	; G3 is on while other R is off
		; 01 01 10 01
		MOV	A,#59H
		ACALL	TRAFFIC_ROUTINE
		; G3 is off
		; 01 01 00 01
		MOV	A,#51H
		MOV	P0,A
		; YELLOW 3 is on
		; 0 0 1 0
		MOV	A,#02H
		ACALL	YELLOW_ROUTINE

TRAFFIC4:	; G4 is on while other R is off
		; 01 01 01 10
		MOV	A,#56H
		ACALL	TRAFFIC_ROUTINE
		; G4 is off
		; 01 01 01 00
		MOV	A,#54H
		MOV	P0,A
		; YELLOW 4 is on
		; 0 0 0 1
		MOV	A,#01H
		ACALL	YELLOW_ROUTINE

		AJMP	TRAFFIC1

TRAFFIC_ROUTINE:	MOV	P0,A
			ACALL	LONG_DELAY
			ACALL	COUNTDOWN5
			MOV	A,#00H
			MOV	P1,A	; clear countdown
			RET

YELLOW_ROUTINE:	MOV	P2,A
		ACALL	SHORT_DELAY
		ACALL	SHORT_DELAY
		MOV	A,#00H
		MOV	P2,A		; Clear Yellow Light output
		RET

LONG_DELAY:	ACALL	SHORT_DELAY
		ACALL	SHORT_DELAY
		ACALL	SHORT_DELAY
		ACALL	SHORT_DELAY
		RET

; Delay for about 1 second
SHORT_DELAY:	ACALL	DELAY
		ACALL	DELAY
		ACALL	DELAY
		ACALL	DELAY
		ACALL	DELAY
		ACALL	DELAY
		ACALL	DELAY
		RET

		; Function to delay
DELAY:		MOV 	R0,#0F0h
DELAY1: 	MOV 	R1,#0F0h
DELAY2:	 	DJNZ 	R1,DELAY2 ;Decrement register1 and jump to delay2 if it is not 0
		DJNZ    R0,DELAY1 ;Decrement register0 and jump to delay1 if it is not 0
		RET

COUNTDOWN5:	MOV	A,#4		; Set initial R5 point to digit 5
		MOV	R5,A
		ACALL	TIMER		; Count down
		ACALL	TIMER		; Count down
		ACALL	TIMER		; Count down
		ACALL	TIMER		; Count down

TIMER:	DEC	R5
	MOV	A,R5		;read input value of R5
	ACALL	SHORT_DELAY
	MOVC	A,@A+DPTR	;load value from table
	MOV	P1,A		;output value
	RET

	; Decoder to 7 display segment LED
SEG:	DB	3FH,06H,5BH,4FH,66H,6DH,7DH,07H,7FH,6FH,77H,7CH,39H,5EH,79H,71H
	END
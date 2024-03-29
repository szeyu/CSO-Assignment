	ORG	00H
	AJMP	MAIN

MAIN:	MOV	A,#00H
	MOV	P1,A	; Set Port 1 as output for Green Light and Red Light
	MOV	P2,A	; Set Port 2 as output for Yellow Light
	MOV	P3,A	; Set Port 3 as output for 7 segment display

	MOV	A,#00H	; RED,GREEN
	MOV	R1,A	; Set R1 initial state to 000 state
			; There will be 8 state in R1 from 000 to 111
			; Will be decoded to TRAFFIC signal

	MOV	A,#0F7H	; YELLOW
	MOV	R2,A	; Set R2 initial state to 0111 state
			; There will be 4 state in R2
			; Sequence:
			; 0111 => 1011 => 1101 => 1110 => 0111
			; Will be updated using Rotator function

	MOV	A,#8	; Set R5 initially point to 8th location of DPTR since there is only 1 DPTR available
	MOV	R5,A

	MOV	DPTR,#TRAFFIC_AND_SEG	; Data pointer for Traffic signal and 7 Segment Display together


START:	MOV	B,#0FFH
	MOV	P2,B		; Clear Yellow Light output

	ACALL	UPDATE_TRAFFIC	; Green Light and Red Light Signal
	;ACALL	DELAY		; Delay for Green Light and Red Light
	ACALL	COUNTDOWN5	; Countdown from 5
	MOV	A,#00H
	MOV	P3,A	; off 7 segment display

	ACALL	UPDATE_R1	; ACALL	UPDATE_R1 for next Traffic
	ACALL	UPDATE_TRAFFIC	; Off Green Light, and be ready for Yellow Signal

	ACALL	ROTATE_R2	; Call Yellow Light

	ACALL	UPDATE_R1	; ACALL	UPDATE_R1 for next Traffic

	AJMP	START


UPDATE_TRAFFIC:	; Function to update and output Traffic signal
		MOV	A,R1		; Selector input for decoder
		MOVC	A,@A+DPTR	; Decode to Traffic signal
		MOV	P1,A		; Traffic Light Signal
		RET

UPDATE_R1:	; Function to update R1
		MOV	A,R1
		INC	A			; Keep adding R1 by 1
		JB	A.3,UPDATE_R1_END	; Change back to 000 state if become 1000
		MOV	R1, A			; Update the value of R1
		RET


ROTATE_R2:	; Function to update R2
		; Follow the sequence: ROTATE RIGHT of '1', to let the '0' move
		MOV	A,R2
		MOV	P2,A
		RR	A ; 0111 => 1011 => 1101 => 1110 => 0111
		JNB	P2.0,UPDATE_R2_END;
		MOV	R2,A
		;ACALL	DELAY
		RET

		; Function to wrap around yellow light
UPDATE_R2_END:	MOV	A,#0F7H	; Wrap around 0111 => 1110
		MOV	R2, A	; Update the value of R2
		RET

		; Function to wrap around R&G light
UPDATE_R1_END:	MOV	A,#00H	; Wrap around 0-7 of A
		MOV	R1, A	; Update the value of R1
		RET

		; Function to delay for 1 seconds
DELAY:		MOV 	R0,#0FFh
DELAY1: 	MOV 	R1,#0F0h
DELAY2: 	DJNZ 	R1,DELAY2 ;Decrement register1 and jump to delay2 if it is not 0
		DJNZ    R0,DELAY1 ;Decrement register0 and jump to delay1 if it is not 0
		RET

COUNTDOWN5:	MOV	A,#14		; Set initial R5 point to digit 5
		MOV	R5,A
		ACALL	TIMER		; Count down
		ACALL	TIMER		; Count down
		ACALL	TIMER		; Count down
		ACALL	TIMER		; Count down

TIMER:	DEC	R5
	MOV	A,R5		;read input value of R5
	;ACALL	DELAY
	MOVC	A,@A+DPTR	;load value from table
	MOV	P3,A		;output value
	RET


	; Decoder to Green Light and Red Light Display for 4 Traffic
	; G1R1 G2R2 G3R3 G4R4
	; 0 means output
	; 1 means no output

	; Traffic 1
	; 01 10 10 10 => 6AH	G1 is turned on while other R keep turned on
	; 11 10 10 10 => 0EAH	G1 is turned off for Y while other R keep turned on

	; Traffic 2
	; 10 01 10 10 => 9AH	G2 is turned on while other R keep turned on
	; 10 11 10 10 => 0BAH	G2 is turned off for Y while other R keep turned on

	; Traffic 3
	; 10 10 01 10 => 0A6H	G3 is turned on while other R keep turned on
	; 10 10 11 10 => 0AEH	G3 is turned off for Y while other R keep turned on

	; Traffic 4
	; 10 10 10 01 => 0A9H	G4 is turned on while other R keep turned on
	; 10 10 10 11 => 0ABH	G4 is turned off for Y while other R keep turned on

;lookup table for 7-segment display pattern
TRAFFIC_AND_SEG:	DB	6AH,0EAH,9AH,0BAH,0A6H,0AEH,0A9H,0ABH,     3Fh,06h,5Bh,4Fh,66h,6Dh,7Dh,07h,7Fh,6Fh
		END

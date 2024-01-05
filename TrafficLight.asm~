	ORG	00H
	AJMP	MAIN

MAIN:	MOV	A,#00H
	MOV	P1,A	; Set Port 1 as output for Green Light and Red Light

	MOV	A,#00H
	MOV	P2,A	; Set Port 2 as output for Yellow Light

	MOV	A,#00H	; RED,GREEN
	MOV	R1,A	; Set R1 initial state to 000 state
			; There will be 8 state in R1 from 000 to 111
			; Will be decoded to TRAFFIC signal

	MOV	A,#0F7H	; YELLOW
	MOV	R2,A	; Set R2 initial state to 1000 state
			; There will be 4 state in R2
			; Sequence:
			; 1000 => 0100 => 0010 => 0001 => 1000
			; Will be updated using Rotator function

	MOV	DPTR,#TRAFFIC	; Data pointer for Traffic signal

START:	MOV	B,#0FFH
	MOV	P2,B		; Clear Yellow Light output

	
	ACALL	UPDATE_TRAFFIC	; Green Light and Red Light Signal

	;ACALL	DELAY		; Delay for Green Light and Red Light

	MOV	A,#0FFH		; Off Red and Green Light, and be ready for Yellow Signal
	MOV	P1,A		

	ACALL	ROTATE_R2	; Call Yellow Light

	;ACALL	COUNTDOWN	; Count down and Yellow Signal
	
	ACALL	UPDATE_R1	; ACALL	UPDATE_R1 for next Traffic
				
	AJMP	START

UPDATE_TRAFFIC:	; Function to update and output Traffic signal
		MOV	A,R1		; Selector input for decoder
		MOVC	A,@A+DPTR	; Decode to Traffic signal
		MOV	P1,A		; Green Light Signal
		ACALL	UPDATE_R1
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
		RET

		; Function to wrap around yellow light
UPDATE_R2_END:	MOV	A,#0F7H	; Wrap around 0111 => 1110
		MOV	R2, A	; Update the value of R2
		RET

		; Function to wrap around R&G light
UPDATE_R1_END:	MOV	A,#00H	; Wrap around 0-7 of A
		MOV	R1, A	; Update the value of R1
		RET

		; Function to delay for Green Light and Red Light
DELAY:		MOV 	R0,#0FFh
DELAY1: 	MOV 	R1,#0F0h
DELAY2: 	DJNZ 	R1,DELAY2 ;Decrement register1 and jump to delay2 if it is not 0
		DJNZ    R0,DELAY1 ;Decrement register0 and jump to delay1 if it is not 0	
		RET

		; Function to countdown for Yellow Light (Act as Delay)
COUNTDOWN:	MOV	R3,#0FFh
COUNTDOWN1:	MOV	R4,#0F0h
COUNTDOWN2:	DJNZ	R4,COUNTDOWN2
		DJNZ	R3,COUNTDOWN1
		RET

	; Decoder to Green Light and Red Light Display for 4 Traffic
	; G1R1 G2R2 G3R3 G4R4
	; 0 means output
	; 1 means no output
	
	; Traffic 1
	; 01 10 10 10 => 6AH	G1 is turned on while other R keep turned on
	; 00 10 10 10 => 2AH	G1 is turned off for Y while other R keep turned on

	; Traffic 2
	; 10 01 10 10 => 9AH	G2 is turned on while other R keep turned on
	; 10 00 10 10 => 8AH	G2 is turned off for Y while other R keep turned on

	; Traffic 3
	; 10 10 01 10 => A6H	G3 is turned on while other R keep turned on
	; 10 10 00 10 => A2H	G3 is turned off for Y while other R keep turned on

	; Traffic 4
	; 10 10 10 01 => A9H	G4 is turned on while other R keep turned on
	; 10 10 10 00 => A8H	G4 is turned off for Y while other R keep turned on

TRAFFIC:	DB	6AH,2AH,9AH,8AH,0A6H,0A2H,0A9H,0A8H
		END

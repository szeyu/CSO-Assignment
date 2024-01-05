	ORG	00H
	AJMP	MAIN

MAIN:	MOV	A,#00H
	MOV	P1,A	; Set Port 1 as output for Green Light and Red Light

	MOV	A,#00H
	MOV	P2,A	; Set Port 2 as output for Yellow Light

	MOV	A,#00H
	MOV	R1,A	; Set R1 initial state to 000 state
			; There will be 8 state in R1 from 000 to 111
			; Will be decoded to TRAFFIC signal

	MOV	A,#08H
	MOV	R2,A	; Set R2 initial state to 1000 state
			; There will be 4 state in R2
			; Sequence:
			; 1000 => 0100 => 0010 => 0001 => 1000
			; Will be updated using Rotator function

	MOV	DPTR,#TRAFFIC	; Data pointer for Traffic signal

START:	MOV	A,#0FFH
	MOV	P2,A		; Clear Yellow Light output

	ACALL	UPDATE_TRAFFIC	; Green Light and Red Light Signal

	ACALL	DELAY		; Delay for Green Light and Red Light

	ACALL	UPDATE_R1	; Update traffic signal
	ACALL	UPDATE_TRAFFIC	; Off the Green Light and be ready for Yellow Signal

	ACALL	COUNTDOWN	; Count down and Yellow Signal

	ACALL	UPDATE_R1	; Update traffic signal
	AJMP	START

UPDATE_TRAFFIC:	; Function to update and output Traffic signal
		MOV	A,R1		; Selector input for decoder
		MOVC	A,@A+DPTR	; Decode to Traffic signal
		MOV	P1,A		; Green Light Signal
		RET

UPDATE_R1:	; Function to update R1
		; Keep adding R1 by 1
		; Change back to 000 state if become 1000
		RET

ROTATE_R2:	; Function to update R2
		; Follow the sequence:
		; 1000 => 0100 => 0010 => 0001 => 1000
		RET

DELAY:		; Function to delay for Green Light and Red Light
		RET

COUNTDOWN:	; Function to countdown for Yellow Light (Act as Delay)
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

; ECE 109- Spring 2021
; Mohamed Ali April 22 2021
; Program 3: This program allows two users to play tic tac toe. First, the program clears the screen
; Then, it draws two white lines and prompts the first user to draw an X. The program then checks for 
; illegal inputs or q. If q, halt program. If not, then it prompts the O move. The same checks are implemented for the O
; move, in addition to checking if the space is already occupied. If occupied or illegal, re-prompt user. If not, go back
; and prompt X move again. This goes on forever until a user hits q.


		.ORIG x3000
		
		LD R0, BLACK
		LD R1, CC01
		LD R2, ROW	; loads colors and coordinates
		LD R4, HIH
		
LP1 	STR R0, R1, #0	; clears screen
		ADD R1, R1, #1
		ADD R2, R2, #-1
		BRp	LP1
		LD R2, ROW
		ADD R4, R4, #-1 ; decrement counter
		BRp LP1
		BRnz BLOCK
		
CC01	.FILL xC000
BLACK	.FILL x0000
ROW	.FILL #124
HIH	.FILL #128
WHITE	.FILL x7FFF 
PIX		.FILL #90
COOR	.FILL xCF00
COOR2	.FILL xDE00
COOR3	.FILL xC01E
COOR4	.FILL xC03C
PROMPT	.STRINGZ "\nX move: "
PROMPT2	.STRINGZ "\nO move: "
Z0		.FILL #0
O1		.FILL #-1
T2		.FILL #-2
T3		.FILL #-3
F4		.FILL #-4
F5		.FILL #-5
S6		.FILL #-6
S7		.FILL #-7
E8		.FILL #-8

BLOCK	JSR DRAWH	; draw lines
		JSR DRAWV
		
BACK	LEA R0, PROMPT ; print prompt string
		PUTS
		
		JSR GETMOV ; call subroutine
		LD R1, NEG9
		ADD R2, R1, R0
		BRz OVER
		BRnp CLEAN
		
OVER	HALT		
	
CLEAN	LD R1, RIGHT
		ADD R3, R1, R0 ; checks for illegal input
		BRz BACK
		BRnp GO
		
GO		ST R0, NUM3
		JSR DRAWX
		BRnzp NEO
		
NEO		LEA R0, PROMPT2	; get O move
		PUTS
		
		JSR GETMOV ; call subroutine for O
		LD R1, NEG9
		ADD R2, R1, R0
		BRz QQT
		BRnp CH2
		
QQT		HALT	

CH2		AND R3, R3, #0	; checks if space is occupied
		LD R2, NUM3	
		NOT R2, R2
		ADD R2, R2, #1
		ADD R3, R2, R0
		BRz NEO
		BRnp NEMO
		
NEMO	AND R3, R3, #0	; checks for illegal input
		LD R1, RIGHT
		ADD R3, R1, R0
		BRz NEO
		BRnp INP2
		
INP2	ST R0, NUM4
		JSR DRAWB ; draws O
		BRnzp BACK ; branch back to X move
		
		
DRAWH	LD R0, WHITE	; horizontal line
		LD R1, COOR
		LD R3, PIX
		
L1		STR R0, R1, #0		; write pixel
		ADD R1, R1, #1		; increment to next pixel
		ADD R3, R3, #-1		; decrement counter
		BRp L1
		
		LD R0, WHITE	; horizontal line
		LD R1, COOR2
		LD R3, PIX
		
L2		STR R0, R1, #0		; write pixel
		ADD R1, R1, #1		; increment to next pixel
		ADD R3, R3, #-1		; decrement counter
		BRp L2
		
		RET
		
DRAWV	LD R0, WHITE	; vertical line
		LD R1, COOR3
		LD R3, PIX
		LD R4, HIH
		
L3		STR R0, R1, #0
		ADD R1, R1, R4 	; next row
		ADD R3, R3, #-1
		BRp L3
		
		LD R0, WHITE	; vertical line
		LD R1, COOR4
		LD R3, PIX
		LD R4, HIH
		
L4		STR R0, R1, #0
		ADD R1, R1, R4 	; next row
		ADD R3, R3, #-1
		BRp L4
		
		RET
		
NUM3	.BLKW #1		
RIGHT	.FILL #1		
NEG9	.FILL #-9		
NEG0	.FILL #-48
NEG8	.FILL #-56
Q		.FILL #-113
NUM1	.BLKW #1
ONE		.FILL #-49
TWO		.FILL #-50
THREE	.FILL #-51
FOUR	.FILL #-52
FIVE	.FILL #-53
SIX		.FILL #-54
SEV		.FILL #-55
LF		.FILL #-10
NUM2	.BLKW #1
PR7		.BLKW #1
NUM4	.BLKW #1
		
GETMOV	AND R0, R0, #0	; clears registers
		AND R1, R1, #0	
		AND R2, R2, #0	
		AND R3, R3, #0	
		AND R4, R4, #0	
		AND R5, R5, #0	
		
		ST R7, PR7	; save R7
				
		GETC				
		ST R0, NUM1	; store input
		OUT
		
		LD R1, NUM1
		LD R0, Q	; check for q
		ADD R0, R1, R0
		
		BRz FINISH
		BRnp CHECK
		
FINISH	AND R0, R0, #0	; return 9
		ADD R0, R0, #9
		BRnzp URN
		
ILLEGAL	AND R0, R0, #0
		ADD R0, R0, #-1	; return -1
		BRnzp URN
		
CHECK	LD R3, NEG0
		ADD R4, R1, R3	; check if valid
		BRn ILLEGAL		
		BRzp VALID1

VALID1	LD R5, NEG8
		ADD R6, R1, R5	; check if valid
		BRp ILLEGAL
		BRnz VALID2
		
VALID2	GETC
		ST R0, NUM2	; get second character
		OUT
		
		LD R1, NUM2
		
		AND R5, R5, #0
		AND R6, R6, #0
		LD R5, LF	; check for linefeed
		ADD R6, R1, R5
		BRz INP
		BRnp ILLEGAL
		
INP		LEA R3, NUM1	; loads input into memory
		
		LDR R0, R3, #0	; this code checks the input 
		LD R1, NEG0
		ADD R2, R1, R0
		BRz DRAW0	; checks for zero
		AND R2, R2, #0
		LD R1, ONE
		ADD R2, R1, R0
		BRz DRAW1	; checks for one
		AND R2, R2, #0
		
		LD R1, TWO
		ADD R2, R1, R0
		BRz DRAW2	; checks for two
		AND R2, R2, #0
		LD R1, THREE
		ADD R2, R1, R0	
		BRz DRAW3	; checks for three
		AND R2, R2, #0
		
		LD R1, FOUR
		ADD R2, R1, R0
		BRz DRAW4	; checks for four
		AND R2, R2, #0
		LD R1, FIVE	; this code checks the input to draw colors
		ADD R2, R1, R0
		BRz DRAW5	; checks for 5
		AND R2, R2, #0
		
		LD R1, SIX
		ADD R2, R1, R0
		BRz DRAW6	; checks for 6
		AND R2, R2, #0
		
		LD R1, SEV
		ADD R2, R1, R0
		BRz DRAW7
		AND R2, R2, #0	; checks for 7
		LD R1, NEG8
		ADD R2, R1, R0
		BRz DRAW8	; checks for 8

DRAW0	AND R0, R0, #0
		ADD R0, R0, #0	; puts 0 in R0
		BRnzp URN
		
DRAW1	AND R0, R0, #0
		ADD R0, R0, #1	; puts 1 in R0
		BRnzp URN
		
DRAW2	AND R0, R0, #0	
		ADD R0, R0, #2	; puts 2 in R0
		BRnzp URN
		
DRAW3	AND R0, R0, #0
		ADD R0, R0, #3	; puts 3 in R0
		BRnzp URN
		
DRAW4	AND R0, R0, #0
		ADD R0, R0, #4	; puts 4 in R0
		BRnzp URN
		
DRAW5	AND R0, R0, #0
		ADD R0, R0, #5	; puts 5 in R0
		BRnzp URN
		
DRAW6	AND R0, R0, #0
		ADD R0, R0, #6	; puts 6 in R0
		BRnzp URN
		
DRAW7	AND R0, R0, #0
		ADD R0, R0, #7	; puts 7 in R0
		BRnzp URN
		
DRAW8	AND R0, R0, #0
		ADD R0, R0, #8	; puts 8 in R0
		BRnzp URN

URN		LD R7, PR7	; restores R7
		RET
		
X	.FILL xA000
O	.FILL xA200		
XX	.FILL xC285
XX1	.FILL xC2A3
XX2	.FILL xC2C1
XX3	.FILL xD185
XX4	.FILL xD1A4
XX5	.FILL xD1C1
XX6	.FILL xE085
XX7 .FILL xE0A3
XX8 .FILL xE0C1
TWENTY	.FILL #20
CMT	.FILL #108
DIA	.FILL x81
YELLOW	.FILL x7FED
AID		.FILL x7F
DEED	.BLKW #1
GREEN	.FILL x03E0

DRAWX	LD R6, X
		LEA R5, XX     ; changed from LD R5
		
		LD R4, NUM3	; get input
		ADD R5, R5, R4
		LDR R3, R5, #0	
		
		LD R1, TWENTY
		LD R2, TWENTY
		
TABA	LDR R0, R6, #0	;new code here
		BRz MYBLKA
		LD R0, YELLOW
		BRnzp MYGOA
		
MYBLKA	AND R0, R0, #0	; new code ends here


MYGOA	STR R0, R3, #0 ; drawX
		
		ADD R3, R3, #1
		ADD R6, R6, #1
		ADD R2, R2, #-1	; decrement counter
		BRp TABA
		
		LD R2, TWENTY
		ADD R3, R3, #12
		ADD R3, R3, #12
		ADD R3, R3, #12
		ADD R3, R3, #12	; draw 108 pixels 
		ADD R3, R3, #12
		ADD R3, R3, #12
		ADD R3, R3, #12
		ADD R3, R3, #12
		ADD R3, R3, #12
		ADD R1, R1, #-1
		BRp TABA
		
		RET
		
DRAWB	LD R6, O
		LEA R5, XX     ; changed from LD R5
		
		LD R4, NUM4	; get input
		ADD R5, R5, R4
		LDR R3, R5, #0	
		
		LD R1, TWENTY
		LD R2, TWENTY
		
TAB		LDR R0, R6, #0	;new code here
		BRz MYBLK
		LD R0, GREEN
		BRnzp MYGO
		
MYBLK	AND R0, R0, #0	; new code ends here


MYGO	STR R0, R3, #0 ; Draw O
		
		ADD R3, R3, #1
		ADD R6, R6, #1
		ADD R2, R2, #-1	; decrement counter
		BRp TAB
		
		LD R2, TWENTY
		ADD R3, R3, #12
		ADD R3, R3, #12
		ADD R3, R3, #12
		ADD R3, R3, #12	; draw 108 pixels 
		ADD R3, R3, #12
		ADD R3, R3, #12
		ADD R3, R3, #12
		ADD R3, R3, #12
		ADD R3, R3, #12
		ADD R1, R1, #-1
		BRp TAB
		
		RET
		
.END		
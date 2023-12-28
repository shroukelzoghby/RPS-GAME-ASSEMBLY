.model SMALL
.stack 100h
.data
        
 HEADER DB  13,10,"==========================================================="
    DB 13,10,    "||                                                       ||"
    DB 13,10,    "||               Rock Paper Scissors GAME                ||"  
    DB 13,10,    "||                                                       ||"
    DB 13,10,    "===========================================================$"  
           
;=========================================================================================    
      
CR      db 13,10,'$'
MSG     db 13,10,13,10,'GAME Instruction: Rock=1, Paper= 2, Scissors= 3, $', 0
PL1     db 'Player 1: $', 0
PL2     db 'Player 2: $', 0
PL1_Win db 13,10,'Player 1 is the winner! $', 0
PL2_Win db 13,10,'Player 2 is the winner! $', 0
PLEQ    db 13,10,'Player 1 = Player 2 $', 0
retry   db 13,10,13,10,'PLAY AGAIN [y/n] ? ' ,'$'
;================================================


.code   
        
MAIN PROC FAR 
 
        MOV AX, @data
        MOV DS, AX
        MOV ES, AX 
        
        MOV DX, OFFSET HEADER      ; Game Name
        MOV AH, 09h
        INT 21h
         
    f1:        
        MOV DX, OFFSET MSG      ; Game Instruction
        MOV AH, 09h
        INT 21h
        
        MOV DX, OFFSET CR       ; print Carrier Return
        MOV AH, 09h
        INT 21h
        
        MOV DX, OFFSET PL1      ; Prompt of player1
        MOV AH, 09h
        INT 21h
        
        MOV AH,08               ; Function to read a char from keyboard (Input by Player1)
        INT 21h                 ; the char saved in AL
        MOV AH,02               ; Function to display a char  
        MOV BL,AL               ; Copy a saved char in AL to BL 
        MOV DL,AL               ; Copy AL to DL to output it
        INT 21h
        
        MOV DX, OFFSET CR       ; print Carrier Return
        MOV AH, 09h
        INT 21h
        
        MOV DX, OFFSET PL2      ; Prompt of player2
        MOV AH, 09h
        INT 21h
;=======================================================
 RANDOM:
    MOV AH, 00h       ; AH = 00h selects the Get System Time function
    INT 1AH           ; CX:DX now holds the number of clock ticks since midnight
    
    mov ax, dx        ; Move the value of DX (clock ticks) to AX
    xor dx, dx        ; Clear DX for division
    mov cx, 3         ; Set the divisor (3 for generating numbers between 0 and 2)
    div cx            ; Divide AX by CX, result in AX (quotient), remainder in DX
    ; DX now contains a pseudo-random number between 0 and 2

    INC DX            ; Increment DX by 1 (adjust to 1-3 range)
    
    
    
    
    
    ADD DL, '0'       ; Convert the numerical value in DL to its ASCII equivalent
    MOV BH, DL        ; Move DL (the remainder) to BH
    MOV AH, 2h        ; AH = 2h selects the Display Character function
    INT 21h           ; Display the ASCII character corresponding to the value in DL
 ;======================================================
        MOV DX, OFFSET CR       ; print Carrier Return
        MOV AH, 09h
        INT 21h 
        
        CMP BL, BH
        JE  EQUAL    
        
;======================================= 



       
        CMP BL, '1'
        JE  EQ1   
        CMP BL, '2'
        JE  EQ2
        CMP BL, '3'
        JE  EQ3
        
    EQ1:
        CMP BH, '2'
        JE  P2_Win   
        CMP BH, '3'
        JE  P1_Win   

    EQ2:  
        CMP BH, '1'
        JE  P1_Win   
        CMP BH, '3'
        JE  P2_Win 
 
    EQ3:  
        CMP BH, '1'
        JE  P2_Win   
        CMP BH, '2'
        JE  P1_Win 

;=======================================
   
    P1_Win:                     ;Player 1 is winner
        MOV DX, OFFSET PL1_Win     
        MOV AH, 09h
        INT 21h
        JMP while_retry
      
    EQUAL:                      ;Player 1 == Player 2
        MOV DX, OFFSET PLEQ   
        MOV AH, 09h
        INT 21h
        JMP while_retry
        
    P2_Win:                     ;Player 2 is winner
        MOV DX, OFFSET PL2_Win     
        MOV AH, 09h
        INT 21h
        JMP while_retry
;=======================================

while_retry:

    MOV dx, offset retry    ; load address to DX
 
    MOV ah, 9h              
    INT 21h                 
 
    MOV ah, 1h              ; Read character 
    INT 21h                 
 
    CMP al, 6Eh             ; check if input is 'n'
    JE Final                ; go to 'final' label
 
    CMP al, 79h             ; check if input is 'y'
    JE restart              ; call 'restart' label is input is 'y' ..
                            
;=======================================

restart:
    JMP f1
;=======================================
    Final:   
        MOV AH,4Ch              ; Function to exit
        MOV AL,00               ; Return 00
        INT 21h
MAIN ENDP


        
END MAIN
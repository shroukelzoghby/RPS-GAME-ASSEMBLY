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
        
BEGIN:  
 
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
        
        MOV AH,08               ; Function to read a char from keyboard (Input by Player2)
        INT 21h                 ; the char saved in AL
        MOV AH,02               ; Function to display a char  
        MOV BH,AL               ; Copy a saved char in AL to BH 
        MOV DL,AL               ; Copy AL to DL to output it
        INT 21h

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
        
end BEGIN
.model SMALL
.stack 100h
.data
        
 HEADER DB  13,10,"==========================================================="
    DB 13,10,    "||                                                       ||"
    DB 13,10,    "||               Rock Paper Scissors GAME                ||"  
    DB 13,10,    "||                                                       ||"
    DB 13,10,    "===========================================================$"          
CR      db 13,10,'$'
MSG     db 13,10,13,10,'GAME Instruction: Rock=1, Paper= 2, Scissors= 3, $', 0
PL1     db 'Player 1: $', 0
PL2     db 'Player 2: $', 0
PL1_Win db 13,10,'Player 1 is the winner! $', 0
PL2_Win db 13,10,'Player 2 is the winner! $', 0
PLEQ    db 13,10,'Player 1 = Player 2 $', 0
retry   db 13,10,13,10,'PLAY AGAIN [y/n] ? ' ,'$'



.code   
        
MAIN PROC FAR 
 
        MOV AX, @data
        MOV DS, AX
        MOV ES, AX 
        
        MOV DX, OFFSET HEADER      
        MOV AH, 09h
        INT 21h
         
    f1:        
        MOV DX, OFFSET MSG      
        MOV AH, 09h
        INT 21h
        
        MOV DX, OFFSET CR       
        MOV AH, 09h
        INT 21h
        
        MOV DX, OFFSET PL1      
        MOV AH, 09h
        INT 21h
        
        MOV AH,08               
        INT 21h                 
        MOV AH,02                 
        MOV BL,AL                
        MOV DL,AL               
        INT 21h
        
        MOV DX, OFFSET CR       
        MOV AH, 09h
        INT 21h
        
        MOV DX, OFFSET PL2      
        MOV AH, 09h
        INT 21h

 RANDOM:
    MOV AH, 00h       
    INT 1AH           
    
    mov ax, dx        
    xor dx, dx        
    mov cx, 3         
    div cx            
   

    INC DX            
    
    
    ADD DL, '0'       
    MOV BH, DL       
    MOV AH, 2h        
    INT 21h           

        MOV DX, OFFSET CR       
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
   
    P1_Win:                     
        MOV DX, OFFSET PL1_Win     
        MOV AH, 09h
        INT 21h
        JMP while_retry
      
    EQUAL:                      
        MOV DX, OFFSET PLEQ   
        MOV AH, 09h
        INT 21h
        JMP while_retry
        
    P2_Win:                     
        MOV DX, OFFSET PL2_Win     
        MOV AH, 09h
        INT 21h
        JMP while_retry
;=======================================

while_retry:

    MOV dx, offset retry    
 
    MOV ah, 9h              
    INT 21h                 
 
    MOV ah, 1h             
    INT 21h                 
 
    CMP al, 6Eh             ;'n'= 6EH (ASCII)
    JE Final                
 
    CMP al, 79h             ; 'y'= 79H (ASCII)
    JE restart             
                            
;=======================================

restart:
    JMP f1
;=======================================
    Final:   
        MOV AH,4Ch              
        MOV AL,00              
        INT 21h
MAIN ENDP


        
END MAIN
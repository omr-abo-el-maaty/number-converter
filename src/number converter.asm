.MODEL MEDIUM
.DATA
    
    COUNT DB ?
    COUNT_HEX DW 0     
    inp dw ?
	
    
    OP_MESSAGE DB 0DH , 0AH , 0DH , 0AH , 'ALL OPERATIONS : $'
    MESSAGE_1 DB 0DH , 0AH , '1. BINARY TO HEXA-DECIMAL CONVERSION $'
    MESSAGE_2 DB 0DH , 0AH , '2. HEXA-DECIMAL TO BINARY CONVERSION $'
    MESSAGE_3 DB 0DH , 0AH , '3. EXIT PROGRAM $'
    PRESS_CHOICE DB 0DH , 0AH , 'PRESS A NUMBER (1 or 2) TO DO THAT OPERATION : $'
    ERROR_MESSAGE DB 0DH , 0AH , 'PLEASE , ENTER THE NUMER AGAIN APPROPROAITELY... !!! $'
    INVALID DB 0DH , 0AH , 'INVALID NUMBER. TRY AGAIN... $'
    TRY_AGAIN DB 0DH , 0AH , 'DO YOU WANT TRY AGAIN? PRESS Y OR N: $'
    
    BINARY_NUMBER DB 0DH , 0AH , 'INPUT A BINARY NUMBER : $'
    HEXA_NUMBER DB 0DH , 0AH , 'INPUT THE HEXADECIMAL NUMBER ( MAXIMUM OF 4 DIGIT ) : $'
    
    SHOW_HEX DB 0DH , 0AH , 'IN HEXA-DECIMAL : $'

    SHOW_BIN DB 0DH , 0AH , 'IN BINARY : $'
    
    NEW_LINE DB 0DH , 0AH , '$'    
   
    
       
	

.CODE
    
    MAIN PROC   FAR
        
        .STARTUP
		

        MENU_BAR:                  
            
            LEA DX , OP_MESSAGE          
            MOV AH , 9
            INT 21H
            
            LEA DX , NEW_LINE
            MOV AH , 9
            INT 21H
            
            LEA DX , MESSAGE_1      
            MOV AH , 9
            INT 21H
            
            LEA DX , MESSAGE_2
            MOV AH , 9
            INT 21H

            
            LEA DX , MESSAGE_3
            MOV AH , 9
            INT 21H
            
            LEA DX , NEW_LINE       
            MOV AH , 9
            INT 21H
            
            LEA DX , PRESS_CHOICE   
            MOV AH , 9
            INT 21H            
			
                
        INPUT_CHOICE:            
        
            MOV AH , 1          
            INT 21H        
            
            CMP AL , "1"          
            JE BIN_TO_HEX
            
            CMP AL , "2"
            JE HEX_TO_BIN

            
            CMP AL , "3"
            JE EXIT
            
            CMP AL , "1"        
            JL ERROR
            
            CMP AL , "3"                                            
            JG ERROR
        
        
        ERROR:                          
            
            LEA DX , NEW_LINE
            MOV AH , 9
            INT 21H
            
            LEA DX , ERROR_MESSAGE      
            MOV AH , 9
            INT 21H
            
            JMP MENU_BAR               
        
               
        AGAIN:                   
        
            LEA DX,NEW_LINE     
            MOV AH,9     
            INT 21H 
             
            LEA DX,TRY_AGAIN       
            MOV AH,9     
            INT 21H
             
            MOV AH,1       
            INT 21H         
                     
            CMP AL,89
            JE  MENU_BAR        
    
            CMP AL,121
            JE  MENU_BAR  
    
            CMP AL,89       
            JNE  EXIT  
    
            CMP AL,121
            JNE  EXIT
                
        
        ERROR_BIN:                
        
            LEA DX , NEW_LINE
            MOV AH , 9
            INT 21H
            
            LEA DX , INVALID    
            MOV AH , 9
            INT 21H
                    
        
        BIN_TO_HEX:                     
            
            LEA DX , NEW_LINE       
            MOV AH , 9
            INT 21H
            
            LEA DX , BINARY_NUMBER      
            MOV AH , 9
            INT 21H
               
        
        
        INPUT_BINARY:      
         
            XOR AX , AX    
            XOR BX , BX
            XOR CX , CX
            XOR DX , DX
            MOV CL , 1     
			MOV INP , 0
            
               
        INPUT_BINARY2:          
         
            MOV AH , 1          
            INT 21H
            
            CMP AL , 0DH        
            JE ENTER                       
            
            CMP AL , 48
            JNE BINARY_CHECK
            
             
        BINARY_CONTINUE:            
        
            SUB AL , 48
            SHL BX , CL
            OR BL , AL
            
            INC INP
            CMP INP , 16
            JE OUTPUT_HEXA
            JMP INPUT_BINARY2          
                
        
        BINARY_CHECK:               
        
            CMP AL , 49             
            JNE ERROR_BIN          
            JMP BINARY_CONTINUE    
        
                
        ENTER:                  
                

            JMP OUTPUT_HEXA
         
            
        
        OUTPUT_HEXA:                
        
            XOR DX , DX
            LEA DX , NEW_LINE
            MOV AH , 9
            INT 21H
            
            LEA DX , SHOW_HEX       
            MOV AH , 9
            INT 21H
            
            MOV CL , 1              
            MOV CH , 0              
            
                   
        
        OUTPUT_HEXA2:            
        
            CMP CH , 4        
            JE AGAIN
            INC CH
            
            MOV DL , BH
            SHR DL , 4
            
            CMP DL , 0AH
            JL HEXA_DIGIT
            
            ADD DL,37H     
            MOV AH,2        
            INT 21H          
            ROL BX,4               
            
            JMP OUTPUT_HEXA2
                   
        
        HEXA_DIGIT:             
        
            ADD DL,30H         
            MOV AH,2       
            INT 21H            
            ROL BX,4
                        
            JMP OUTPUT_HEXA2                    

        
        ERROR_HEX:

            LEA DX,INVALID          
            MOV AH,9                
            INT 21H
                       
        
        HEX_TO_BIN:                
                   
            LEA DX , NEW_LINE
            MOV AH , 9
            INT 21H
        
            LEA DX,HEXA_NUMBER
            MOV AH,9                
            INT 21H                                      
                                
    
        START:
            
            XOR BX,BX                   
            MOV COUNT,0               
    
    
        INPUT:
    
            MOV AH,1                    
            INT 21H
    
            CMP AL,0DH                 
            JNE SKIP
    
            CMP COUNT, 0               
            JLE ERROR_HEX               
               


        SKIP:
    
            CMP AL,"A"     
            JL DECIMAL      
    
            CMP AL,"F"      
            JG ERROR_HEX    
    
            SUB AL,55     
            JMP PROCESS     
    

        DECIMAL:
            
            CMP AL,9      
            JG ERROR_HEX   
                            
            CMP AL,0      
            JL ERROR_HEX       
    
            JMP PROCESS       
    

        PROCESS:
    
            INC COUNT
    
            AND AL,0FH       
            MOV CL,4       
            SHL AL,CL       
            MOV CX,4        

    
        LOOP_1:
    
            SHL AL,1        
            RCL BX,1          
    
            LOOP LOOP_1     

            CMP COUNT, 4   
            JE END          
            JMP INPUT
        
        
        END:
            
            LEA DX , NEW_LINE
            MOV AH , 9
            INT 21H
            
            LEA DX,SHOW_BIN     
            MOV AH,9
            INT 21H

            MOV CX,16
            MOV AH,2
        
        
        LOOP_2:

            SHL BX,1        
                             
            JC ONE
                                              
            MOV DL,30H
            JMP DISPLAY                                          
        
        
        ONE:

            MOV DL,31H
    

        DISPLAY:

            INT 21H  
            LOOP LOOP_2

            JMP AGAIN
                    
			
        
        EXIT: 
        
           .EXIT  
            
      MAIN endp
      end MAIN
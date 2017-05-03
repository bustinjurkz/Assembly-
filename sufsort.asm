%include "asm_io.inc"
global asm_main

SECTION .data

errargc: db "Incorrect number of arguments LMFAO", 10, 0
errlen: db "Wrong string length LMAO", 10, 0
errchar: db "You can only use '0', '1', or '2'!", 10, 0
ssmsg: db "sorted suffixes: ", 10, 0



SECTION .bss
  X: resd 32
  N: resd 1 ;;integer array length
  innervar: resd 32
  sufvar1: resd 32
  sufvar2: resd 32
  sufvar3: resd 1

  

SECTION .text

asm_main:
  enter 0, 0
  pusha
  
   ; check argc
   mov eax, dword [ebp+8] 
   ; check that it has value 2
   cmp eax, dword 2
   je RUN1
   mov eax, errargc
   call print_string
   jmp ENDCODE
   
   
   
   
  RUN1: 

  mov ebx, dword [ebp+12]
  mov ebx, [ebx + 4]
  mov edx, 0
  
  LOOP1: 
     cmp byte [ebx], byte 0 ;null character terminator
     je LOOP1_EXIT
     mov al, byte [ebx]

          cmp al, '0'
          jne test1
          jmp continue
          test1:
          cmp al, '1'
          jne test2
          jmp continue
          test2:
          cmp al, '2'
          jne ERRCHAR
     continue:
     mov [X + edx], al
     inc ebx
     inc edx
     jmp LOOP1
  
  LOOP1_EXIT:
  ; length check
     cmp edx, dword 29
     jnle LENERR
     mov [N], edx
     jmp CONT
     
  ERRCHAR:
    mov eax, errchar
     call print_string
     jmp ENDCODE
     
  LENERR:
     mov eax, errlen
     call print_string
     jmp ENDCODE
     
   CONT:
     mov eax, X
     call print_string
     call print_nl
     mov eax, edx     
     mov edx, [N]
     mov eax, ssmsg
     call print_string
     mov ecx, dword 0
     ;;;
     MAINLOOP:
     cmp ecx, [N]
     je MAINLOOPEXIT
     mov [innervar + ecx*4], ecx
     mov eax, [innervar+ecx*4]
     inc ecx
     jmp MAINLOOP
     
     MAINLOOPEXIT:
     mov edx, [N]
     
     MAINLOOP2:
     cmp edx, dword 0
     je EXITML2
     dec edx
     mov ebx, dword 0
     
     MAINLOOP3:
     cmp ebx, edx
     je MAINLOOP2
     mov eax, [innervar + ebx*4]
     push eax
     mov eax, [innervar + ebx*4+4]
     push eax
     call sufsort
     add esp, dword 8
     cmp eax, dword 0
     jnle CHANGEARR
     inc ebx
     jmp MAINLOOP3
     CHANGEARR: ;;change
     mov ecx, dword [innervar+ ebx*4]
     mov eax, dword [innervar + ebx*4+4]  
     mov [innervar + ebx*4], eax
     mov [innervar + ebx*4+4], ecx
     inc ebx
     mov eax, [innervar + ebx*4]
     jmp MAINLOOP3
     
     EXITML2:
     mov ebx, dword -1
     jmp MAINLOOP4
     
     MAINLOOP4:
     cmp ebx, dword [N]
     je EXITML3
          
     mov [sufvar1 + edx], byte 0
     mov eax, sufvar1
     call print_string
     call print_nl     
     inc ebx
     mov edx, [innervar + ebx*4]
     mov ecx, 0
     mov [sufvar1], dword 0
     mov [sufvar1+8], dword 0
     mov [sufvar1+16], dword 0
     mov [sufvar1+24], dword 0
     
     MAINLOOP4INNER:
     cmp edx, [N]
     je MAINLOOP4
     mov al, byte [X + edx]
     mov [sufvar1 + ecx], al
     inc ecx
     inc edx
     jmp MAINLOOP4INNER
     
     EXITML3:
     call read_char
    jmp ENDCODE     
          
  ENDCODE:
  popa
  leave
  ret
  
sufsort:
     enter 0, 0
     pusha
     mov ecx, 0
     mov [sufvar1], dword 0
     mov [sufvar2], dword 0
     mov ebx, [ebp + 8] 
     mov edx, [ebp + 12] 
     
     SUFL1:
     cmp ecx, [N]
     je SUFL2
     mov al, byte[edx + ecx + X]
     mov [sufvar2 + ecx], al
          inc ecx
          jmp SUFL1
          
     SUFL2:
          mov edx, [N]
          sub edx, eax
          mov [sufvar2 + edx], byte 0
          mov ecx, 0
     
     SUFL3:
          cmp ecx, [N]
          je CARRYON
         mov al, byte[X + ecx + ebx]
          mov [sufvar1 + ecx], al
          inc ecx
          jmp SUFL3
          
     CARRYON:
          mov edx, [N]
          sub edx, ebx
          mov [sufvar1 + edx], byte 0
          mov ecx, 0
      
     
     SUFLASTL:
          cmp ecx, edx
          je EXIT2
          mov al, byte [sufvar2 + ecx]
          mov bl, byte [sufvar1 + ecx]
          cmp al, bl
          jnle EXIT2
          cmp eax, ebx
          jnge EXIT1
          inc ecx
          jmp SUFLASTL
          EXIT1:
               mov [sufvar3], dword -1
               jmp SUFEND
          EXIT2:
               mov [sufvar3], dword 1
               jmp SUFEND
     SUFEND:
          
     popa
     mov eax, dword [sufvar3]
     leave
     ret
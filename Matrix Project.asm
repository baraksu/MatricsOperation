.MODEL small
.STACK 100h

.DATA
msgSize db 13,10,'please enter how many by how many do you want your matrix.',13,10,'numbers allowed: 1 to 9',13,10,'matrix 1: $'
backspace db 8,32,8,'$'
msgMat2 db 13,10,'matrix 2: $'
by db ' by $'                 
x1 db ?
y1 db ?
x2 db ?
y2 db ?
mat1 db 82 dup(0FFh)
mat2 db 82 dup(0FFh)
crlf db 13,10,'$'
space db ' $'            
msgInput1 db 13,10,13,10,'please enter the values in matrix 1:',13,10,'$'  
msgInput2 db 13,10,'please enter the values in matrix 2:',13,10,'$'

.CODE
start:
    mov ax,@data
    mov ds,ax
    
    call matrixDimantionInput
    sub x1,'0'
    sub y1,'0'
    sub x2,'0'
    sub y2,'0'
    
    push offset mat1
    xor ax,ax
    mov al,y1
    push ax
    xor ax,ax
    mov al,x1
    push ax
    push offset msgInput1
    call matrixInput
    
    lea dx,mat2
    push dx
    xor ax,ax
    mov al,y2
    push ax
    xor ax,ax
    mov al,x2
    push ax
    push offset msgInput2
    call matrixInput
    
    push offset mat1
    call asciiToNumber
    
    lea dx,mat2
    push dx
    call asciiToNumber
                   
    push offset mat1
    call numberToAscii 
    
    
exit:
    mov ah,4ch
    int 21h

print proc
    push bp
    mov bp,sp
    push dx
    push ax
    mov dx,[bp+4]
    mov ah,09h
    int 21h
    pop ax
    pop dx
    pop bp
    ret 2
print endp
    
dimantionInput proc
    push bp
    mov bp,sp
    push ax
    push bx
    push dx
    jmp input
    invalid:
        push offset backspace  
        call print
    input:
        mov ah,1
        int 21h
        mov bx,[bp+4]
        mov [bx],al
        cmp [bx],'1'
        jb invalid
        cmp [bx],'9'
        ja invalid
    pop dx
    pop bx
    pop ax
    pop bp
    ret 2
dimantionInput endp

matrixDimantionInput proc
    push offset msgSize
    call print
    
    push offset x1   
    call dimantionInput
    
    push offset by
    call print
    
    push offset y1   
    call dimantionInput
    
    push offset msgMat2
    call print
    
    mov dl,y1
    mov ah,2
    int 21h
    mov al,y1
    mov x2,al
    
    push offset by
    call print
    
    push offset y2
    call dimantionInput
    ret
matrixDimantionInput endp

matrixInput proc
    push bp
    mov bp,sp
    push dx
    push bx
    push ax
    push cx
    
    push [bp+4]
    call print
    mov bx,[bp+10]
    xor cx,cx
    row:
        xor dx,dx
        collumn:
            jmp continue
            invalid1:
                push offset backspace
                call print
            continue: 
            mov ah,1
            int 21h
            cmp al,'1'
            jb invalid1
            cmp al,'9'
            ja invalid1
            mov [bx],al
            inc bx                        
            push offset space
            call print
            inc dx
            cmp dl,[bp+8]
            jne collumn
        push offset crlf
        call print
        inc cx
        cmp cl,[bp+6]
        jne row 
       
    pop cx
    pop ax
    pop bx
    pop dx
    pop bp
    ret 8    
matrixInput endp

asciiToNumber proc
    push bp
    mov bp,sp
    push bx
    mov bx,[bp+4]
    looping:
        sub [bx],'0'
        inc bx
        cmp [bx],0ffh
        jne looping
    pop bx
    pop bp
    ret 2
asciiToNumber endp

numberToAscii proc
    push bp
    mov bp,sp
    push bx
    mov bx,[bp+4]
    looping1:
        add [bx],'0'
        inc bx
        cmp [bx],0ffh
        jne looping1
    pop bx
    pop bp
    ret 2
numberToAscii endp

END
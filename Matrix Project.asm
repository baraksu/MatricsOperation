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
mat1 db 100 dup(0)
mat2 db 100 dup(0)

.CODE
start:
    mov ax,@data
    mov ds,ax
    
    call matrixDimantionInput
    

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
        lea dx,backspace
        mov ah,09h
        int 21h
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

END
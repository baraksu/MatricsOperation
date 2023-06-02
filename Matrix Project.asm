.MODEL small
.STACK 100h

.DATA
<<<<<<< HEAD
=======

>>>>>>> 1a27b7b591e4c38569fce688816f8f7b4e2b6f1c
msgSize db 13,10,'please enter how many by how many do you want your matrix.',13,10,'numbers allowed: 1 to 6',13,10,'matrix 1: $'
backspace db 8,32,8,'$'
msgMat2 db 13,10,'matrix 2: $'
by db ' by $'                 
x1 db ?    ;contains the horizotal length of the first matrix
y1 db ?    ;contains the vertical length of the first matrix
x2 db ?    ;contains the horizotal length of the second matrix
y2 db ?    ;contains the vertical length of the second matrix
mat1 db 44 dup(0FFh)  ;contains the values in the first inputed matrix
mat2 db 44 dup(0FFh)  ;contains the values in the second inputed matrix
mat3 db 44 dup(0FFh)  ;contains the values in the multipied matrix
crlf db 13,10,'$'
space db ' $'
msgExit db 13,10,'hit any key to exit$'            
msgInput1 db 13,10,13,10,'please enter the values in matrix 1:',13,10,'$'  
msgInput2 db 13,10,'please enter the values in matrix 2:',13,10,'$'
msgMat3 db 13,10,'the multipied matrix is:',13,10,'$'
msgLoading db 13,10,'loading$'
dot db '.$'
<<<<<<< HEAD
msgBackSpace db 13,10,'you entered backspace, please try again:  $'
msgStart1 db 13,10,'  __  __       _        _         ____                       _   _             $'
msgStart2 db 13,10,' |  \/  |     | |      (_)       / __ \                     | | (_)            $'
msgStart3 db 13,10,' | \  / | __ _| |_ _ __ ___  __ | |  | |_ __   ___ _ __ __ _| |_ _  ___  _ __  $'
msgStart4 db 13,10,' | |\/| |/ _` | __| '__| \ \/ / | |  | | '_ \ / _ \ '__/ _` | __| |/ _ \| '_ \ $'
msgStart5 db 13,10,' | |  | | (_| | |_| |  | |>  <  | |__| | |_) |  __/ | | (_| | |_| | (_) | | | |$'
msgStart6 db 13,10,' |_|  |_|\__,_|\__|_|  |_/_/\_\  \____/| .__/ \___|_|  \__,_|\__|_|\___/|_| |_|$'
msgStart7 db 13,10,'                                       | |                                     $'
msgStart8 db 13,10,'                                       |_|                                      $',13,10,'$'
=======
>>>>>>> 1a27b7b591e4c38569fce688816f8f7b4e2b6f1c

.CODE
start:
    mov ax,@data
    mov ds,ax
    
    push offset msgStart1
    call print
    push offset msgStart2
    call print
    push offset msgStart3
    call print
    push offset msgStart4
    call print
    push offset msgStart5
    call print
    push offset msgStart6
    call print
    push offset msgStart7
    call print
    push offset msgStart8
    call print
    
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
    
    push offset msgLoading
    call print
    
    push offset mat1
    call asciiToNumber    
    lea dx,mat2
    push dx
    call asciiToNumber
        
    xor cx,cx
    xor ax,ax
    mov cl,x1
    

    i:
        cmp cx,0
        je next
        mov al,y2  
        dec cx
        j:
            push offset dot
            call print 
            cmp ax,0
            je i
            dec ax
            push ax
            push cx         
            call multipy
            jmp j
        jmp i
            
    next:     
    push offset crlf
    call print
    push offset msgMat3
    call print
    call printMat3                                    
    
    
exit:
    push offset msgExit
    call print
    mov ah,01
    int 21h
    push offset backspace
    call print
    mov ah,4ch
    int 21h

print proc ;printing massage. paramenter: offset of massage
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

printMat3 proc ;print mat3. no parameters
    push bp
    mov bp,sp
    push ax
    push bx
    push cx
    push dx
    
    xor cl,cl      
    xor bx,bx
    printing:
        xor ax,ax
        mov al,mat3[bx]
        mov dl,100
        div dl
        mov dl,al
        add dl,'0'
        mov ah,2
        int 21h
        
        xor ax,ax
        mov al,mat3[bx]
        mov dl,10
        div dl
        mov dh,ah
        xor ah,ah
        div dl
        mov dl,ah
        add dl,'0'
        mov ah,2
        int 21h 
        mov dl,dh
        add dl,'0'
        int 21h
        push offset space
        call print
        
        inc cl
        cmp cl,y2
        jne dontIncrease
            push offset crlf
            call print
            xor cl,cl         
        dontIncrease:            
        inc bx
        cmp mat3[bx],0ffh
        jne printing           
    
    pop dx
    pop cx      
    pop bx
    pop ax
    pop bp
    ret
printMat3 endp

multipy proc ;multupy row of matrix one in collumn of matrix two. parameters: collumn, row
    push bp
    mov bp,sp
    push ax
    push bx
    push cx
    push dx
    
    mov al,[bp+4]
    mul y2
    mov bx,ax
    add bx,[bp+6]
    mov mat3[bx],0
    
    mov al,y1                    
    mul [bp+4]
    mov [bp+4],ax
    mov cl,y1
    add [bp+4],cl
    mov dx,ax
    
    
    multiping:
        push bx
        mov bx,dx
        mov al,mat1[bx]
        mov bx,[bp+6]
        mul mat2[bx]
        pop bx
        add mat3[bx],al
        
        mov al,y2
        add [bp+6],al
        inc dx
        cmp [bp+4],dx
        jne multiping
    
    
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    
    ret 4
multipy endp
    
dimantionInput proc ;get input of one matrix dimantion. paramenter: offset of a dimantion var
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
        cmp al,8
        jne notBackSpace1
            push offset msgBackSpace
            call print
        notBackSpace1:
        cmp [bx],'1'
        jb invalid
        cmp [bx],'6'
        ja invalid
    pop dx
    pop bx
    pop ax
    pop bp
    ret 2
dimantionInput endp

matrixDimantionInput proc ;get input of the both matrices' dimantions. no paramenters
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

matrixInput proc ;input of the values of a matrix. parameters: offset of massage, offset of x, offset of y, offset of matrix
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
            cmp al,8
            jne notBackSpace
                push offset msgBackSpace
                call print
            notBackSpace:
            cmp al,'1'
            jb invalid1
            cmp al,'6'
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

asciiToNumber proc ;convert values in matrix from ascii to numbers. parameter: offset of a matrix
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

END
org 0x100    


star_width = 16      ; steaua este o matrice patratica de 16 x 16
screen_width = 320     ; rezolutia ecranului grafic 
screen_height = 240
jmp start
star_axa_x dw 144
star_axa_y dw 84
star_color db 2

start proc far
    mov ax, cs
    mov ds, ax
    mov es, ax
    mov ah, 0
    mov al, 13h
    int 10h
draw_star:
    mov bx, star_axa_x
    mov dx, star_axa_y
    mov si, star
    call puticon
    inc star_color
    mov cx, 10
    mov dx, 0
    mov ah, 86h
    int 15h
    jmp draw_star

    ret
start endp

; input: bx = axa x
; dx = axa y
; si = imaginea   

beep PROC                    ; procedura care genereaza un bip
    mov ah, 02
    mov dl, 07h
    int 21h
    ret
beep ENDP

puticon proc
    mov ax, 0A000h           ; inainte de a incepe desenul, setez graphics screen "0A000h"
    mov es, ax               ; pe registrul ES                                                             
    mov ax, screen_width     ; pun in AX latimea ferestrei pentru ca urmeaza sa desenez pe linii
    mul dx
    add bx, ax
    jnc no_carry
    inc dx
no_carry:
    mov cx, star_width
next_y:            
    push cx
    mov cx, star_width
next_x:
    mov di, bx               ; desenul este alcatuit dintr-o matrice de 0 si 1 (vezi structura jos)
    mov al, [si]             ; next_x parcurge linia si verifica daca a gasit 0 sau 1
    cmp al, 0                ; in cazul in care 0 a fost gasit
    je transparent           ; nu pune nimic si continua prin a verifica
                             ; daca e 1, pune * in culoarea curenta si trece mai departe 
    call beep                ; apeleaza procedura beep de fiecare data cand se gaseste 1
    mov al, star_color       
    mov es:[di], al
transparent:
    inc si
    add bx, 1
    jnc no_car_x
    inc dx
no_car_x:
    loop next_x              ; dupa gasirea lui 1, se repeta next_x si se reia procesul
    pop cx
    add bx, screen_width-star_width
    jnc no_car_y
    inc dx
no_car_y:
    loop next_y          
    ret
puticon endp

star:
db 1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1
db 0,1,0,0,0,0,0,1,0,0,0,0,0,0,1,0
db 0,0,1,0,0,0,0,1,0,0,0,0,0,1,0,0
db 0,0,0,1,0,0,0,1,0,0,0,0,1,0,0,0
db 0,0,0,0,1,0,0,1,0,0,0,1,0,0,0,0
db 0,0,0,0,0,1,0,1,0,0,1,0,0,0,0,0
db 0,0,0,0,0,0,1,1,0,1,0,0,0,0,0,0
db 0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0
db 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
db 0,0,0,0,0,0,1,1,0,1,0,0,0,0,0,0
db 0,0,0,0,0,1,0,1,0,0,1,0,0,0,0,0
db 0,0,0,0,1,0,0,1,0,0,0,1,0,0,0,0
db 0,0,0,1,0,0,0,1,0,0,0,0,1,0,0,0
db 0,0,1,0,0,0,0,1,0,0,0,0,0,1,0,0
db 0,1,0,0,0,0,0,1,0,0,0,0,0,0,1,0
db 1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1
             
             
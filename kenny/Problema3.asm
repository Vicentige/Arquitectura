org 100h

.DATA

pintar macro color
    push ax
    push bx
    push cx
    push dx

    mov ah, 0Ch
    mov al, color
    mov bh, 0          ; Pagina 0
    int 10h

    pop dx
    pop cx
    pop bx
    pop ax
endm

Rectangulo macro alto, ancho, x, y, color
    local ciclo
    local nueva_fila
    local salida

    push ax
    push bx
    push cx
    push dx

    mov ax, x
    add ax, ancho      ; Limite derecho
    mov bx, y
    add bx, alto       ; Limite inferior

    mov cx, x          ; X inicial
    mov dx, y          ; Y inicial

ciclo:
    cmp cx, ax
    jge nueva_fila
    pintar color
    inc cx
    jmp ciclo

nueva_fila:
    mov cx, x
    inc dx
    cmp dx, bx
    jl ciclo

salida:
    pop dx
    pop cx
    pop bx
    pop ax
endm

.CODE

; Iniciar modo grafico 640x480, 16 colores
mov ax, 0012h
int 10h

; --- CUERPO (Chaqueta roja: 4) ---
Rectangulo 48, 136, 252, 252, 4
Rectangulo 24, 150, 245, 258, 4

; --- PANTALON (Marron: 6) y ZAPATOS (Gris oscuro: 8) ---
Rectangulo 16, 118, 261, 300, 6
Rectangulo 7,  122, 259, 316, 8

; --- BOTONES Y LINEA CENTRAL (Negro: 0) ---
Rectangulo 40, 2, 320, 260, 0
Rectangulo 4,  4, 316, 266, 0
Rectangulo 4,  4, 316, 278, 0
Rectangulo 4,  4, 316, 290, 0

; --- GUANTES (Amarillo: 14) ---
Rectangulo 20, 24, 236, 270, 14
Rectangulo 20, 24, 380, 270, 14

; --- CARA (Color de la piel: 90, sobre la chaqueta) ---
Rectangulo 52, 114, 263, 198, 90
Rectangulo 12, 90,  275, 250, 90
Rectangulo 2,  70,  285, 254, 0     ; Linea de la papada

; --- OJOS (Blanco: 15) y PUPILAS (Negro: 0) ---
Rectangulo 24, 22, 294, 204, 15
Rectangulo 24, 22, 324, 204, 15
Rectangulo 4,  4,  308, 214, 0
Rectangulo 4,  4,  328, 214, 0

; --- BOCA (Negro: 0) y DIENTES (Blanco: 15) ---
Rectangulo 10, 18, 311, 236, 0
Rectangulo 3,  5,  314, 237, 15
Rectangulo 3,  5,  321, 237, 15

; --- GORRO (Cyan claro: 11) y DETALLES (Amarillo: 14) ---
Rectangulo 12, 30,  305, 140, 14    ; Pompon
Rectangulo 10, 56,  292, 152, 11
Rectangulo 12, 86,  277, 162, 11
Rectangulo 16, 110, 265, 174, 11
Rectangulo 8,  114, 263, 190, 14    ; Borde amarillo

; Esperar una tecla antes de cerrar
mov ah, 00h
int 16h

salir:
    ret
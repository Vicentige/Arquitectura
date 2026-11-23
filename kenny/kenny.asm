org 100h

.DATA

Rectangulo macro alto, ancho, x, y, color
    local ciclo, nueva_fila

    push ax
    push bx
    push cx
    push dx
    push si
    push di

    mov si, x
    add si, ancho      ; SI = limite derecho
    mov di, y
    add di, alto       ; DI = limite inferior

    mov cx, x          ; X inicial
    mov dx, y          ; Y inicial
    mov bh, 0          ; Pagina 0

ciclo:
    cmp cx, si
    jge nueva_fila
    mov ah, 0Ch
    mov al, color
    int 10h
    inc cx
    jmp ciclo

nueva_fila:
    mov cx, x
    inc dx
    cmp dx, di
    jl ciclo

    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
endm

.CODE

; Iniciar modo grafico 640x480, 16 colores
mov ax, 0012h
int 10h

; --- CABELLO TRASERO Y LATERAL (Amarillo: 14) ---
Rectangulo 12, 84,  278, 114, 14
Rectangulo 16, 108, 266, 126, 14
Rectangulo 32, 128, 256, 142, 14
Rectangulo 36, 22,  254, 174, 14   ; Mechon izquierdo
Rectangulo 36, 22,  364, 174, 14   ; Mechon derecho
Rectangulo 12, 24,  256, 242, 14   ; Hombrera izquierda
Rectangulo 12, 24,  360, 242, 14   ; Hombrera derecha

; --- CAPUCHA NARANJA (Rojo claro: 12) ---
Rectangulo 20, 84,  278, 152, 12
Rectangulo 66, 104, 268, 172, 12
Rectangulo 14, 84,  278, 238, 12

; --- INTERIOR DE LA CAPUCHA (Marron: 6) ---
Rectangulo 56, 76, 282, 170, 6
Rectangulo 12, 56, 292, 226, 6

; --- CARA (Gris claro: 7), OJOS (Blanco: 15) y PUPILAS (Negro: 0) ---
Rectangulo 46, 52, 294, 178, 7
Rectangulo 22, 18, 300, 186, 15    ; Ojo izquierdo
Rectangulo 22, 18, 322, 186, 15    ; Ojo derecho
Rectangulo 4,  4,  310, 196, 0     ; Pupila izquierda
Rectangulo 4,  4,  326, 196, 0     ; Pupila derecha

; --- CORDONES DE LA CAPUCHA (Negro: 0) ---
Rectangulo 2,  56, 292, 232, 0
Rectangulo 18, 2,  317, 234, 0
Rectangulo 18, 2,  321, 234, 0

; --- CORONA (Banda Marron/Dorado: 6, Puntas Amarillo: 14) ---
Rectangulo 10, 124, 258, 134, 6
Rectangulo 16, 20,  310, 124, 14   ; Cresta central
Rectangulo 14, 5,   266, 128, 14
Rectangulo 14, 5,   282, 128, 14
Rectangulo 14, 5,   298, 128, 14
Rectangulo 14, 5,   337, 128, 14
Rectangulo 14, 5,   353, 128, 14
Rectangulo 14, 5,   369, 128, 14

; --- TRENZAS CON CINTAS (Amarillo: 14, Blanco: 15, Punta: 8) ---
Rectangulo 42, 10, 268, 210, 14    ; Trenza izquierda
Rectangulo 4,  10, 268, 218, 15
Rectangulo 4,  10, 268, 230, 15
Rectangulo 4,  10, 268, 242, 15
Rectangulo 5,  8,  269, 252, 8

Rectangulo 42, 10, 362, 210, 14    ; Trenza derecha
Rectangulo 4,  10, 362, 218, 15
Rectangulo 4,  10, 362, 230, 15
Rectangulo 4,  10, 362, 242, 15
Rectangulo 5,  8,  363, 252, 8

; --- VESTIDO MORADO (Magenta: 5) y COLLAR (Amarillo: 14, Cyan: 11) ---
Rectangulo 30, 92, 274, 252, 5
Rectangulo 3,  44, 298, 254, 14
Rectangulo 5,  5,  308, 257, 11
Rectangulo 5,  5,  318, 258, 11
Rectangulo 5,  5,  328, 257, 11

; --- FALDA BLANCA (15) y BROCHE (Amarillo: 14, Rojo: 4) ---
Rectangulo 26, 104, 268, 282, 15
Rectangulo 12, 30,  305, 284, 14
Rectangulo 5,  5,   307, 286, 4
Rectangulo 5,  5,   328, 286, 4
Rectangulo 4,  4,   318, 292, 4

; --- BRAZOS (Gris claro: 7) y GUANTES (Blanco: 15) ---
Rectangulo 26, 14, 262, 254, 7
Rectangulo 26, 14, 364, 254, 7
Rectangulo 18, 20, 258, 276, 15
Rectangulo 18, 20, 362, 276, 15

; --- PARTE INFERIOR (Naranja: 12) y ZAPATOS (Gris oscuro: 8) ---
Rectangulo 10, 88, 276, 308, 12
Rectangulo 6,  94, 273, 318, 8

; Esperar una tecla antes de cerrar
mov ah, 00h
int 16h

salir:
    ret
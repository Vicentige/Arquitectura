org 100h

.DATA

msg1 db 'Presione una tecla para empezar a dibujar el personaje de una serie...$'
msg2a db 'Presione una tecla para empezar a$'
msg2b db 'dibujar el personaje de un juego...$'

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

; =========================================================
; 1. MENSAJE INICIAL (antes de dibujar)
; =========================================================
mov ah, 09h
mov dx, offset msg1
int 21h

mov ah, 00h            ; Esperar tecla
int 16h

; Iniciar modo grafico 640x480, 16 colores
mov ax, 0012h
int 10h

; =========================================================
; 2. DIBUJAR A CARTMAN (izquierda)
; =========================================================
; --- CUERPO (Chaqueta roja: 4) ---
Rectangulo 48, 136, 112, 252, 4
Rectangulo 24, 150, 105, 258, 4

; --- PANTALON (Marron: 6) y ZAPATOS (Gris oscuro: 8) ---
Rectangulo 16, 118, 121, 300, 6
Rectangulo 7,  122, 119, 316, 8

; --- BOTONES Y LINEA CENTRAL (Negro: 0) ---
Rectangulo 40, 2, 180, 260, 0
Rectangulo 4,  4, 176, 266, 0
Rectangulo 4,  4, 176, 278, 0
Rectangulo 4,  4, 176, 290, 0

; --- GUANTES (Amarillo: 14) ---
Rectangulo 20, 24, 96,  270, 14
Rectangulo 20, 24, 240, 270, 14

; --- CARA (Color: 90) ---
Rectangulo 52, 114, 123, 198, 90
Rectangulo 12, 90,  135, 250, 90
Rectangulo 2,  70,  145, 254, 0     ; Linea de la papada

; --- OJOS (Blanco: 15) y PUPILAS (Negro: 0) ---
Rectangulo 24, 22, 154, 204, 15
Rectangulo 24, 22, 184, 204, 15
Rectangulo 4,  4,  168, 214, 0
Rectangulo 4,  4,  188, 214, 0

; --- BOCA (Negro: 0) y DIENTES (Blanco: 15) ---
Rectangulo 10, 18, 171, 236, 0
Rectangulo 3,  5,  174, 237, 15
Rectangulo 3,  5,  181, 237, 15

; --- GORRO (Cyan claro: 11) y DETALLES (Amarillo: 14) ---
Rectangulo 12, 30,  165, 140, 14    ; Pompon
Rectangulo 10, 56,  152, 152, 11
Rectangulo 12, 86,  137, 162, 11
Rectangulo 16, 110, 125, 174, 11
Rectangulo 8,  114, 123, 190, 14    ; Borde amarillo

; =========================================================
; 3. CONFIRMACION PARA CONTINUAR
; =========================================================
mov ah, 02h
mov bh, 0
mov dh, 1              ; Fila 1
mov dl, 1              ; Columna 1
int 10h

mov ah, 09h
mov dx, offset msg2a
int 21h

mov ah, 02h
mov bh, 0
mov dh, 3              ; Fila 3 (deja espacio para que no se encimen)
mov dl, 1              ; Columna 1
int 10h

mov ah, 09h
mov dx, offset msg2b
int 21h

mov ah, 07h            ; Esperar confirmacion (cualquier tecla)
int 21h

; =========================================================
; 4. DIBUJAR A PRINCESS KENNY (derecha)
; =========================================================
; --- CABELLO TRASERO Y LATERAL (Amarillo: 14) ---
Rectangulo 12, 84,  418, 114, 14
Rectangulo 16, 108, 406, 126, 14
Rectangulo 32, 128, 396, 142, 14
Rectangulo 36, 22,  394, 174, 14   ; Mechon izquierdo
Rectangulo 36, 22,  504, 174, 14   ; Mechon derecho
Rectangulo 12, 24,  396, 242, 14   ; Hombrera izquierda
Rectangulo 12, 24,  500, 242, 14   ; Hombrera derecha

; --- CAPUCHA NARANJA (Rojo claro: 12) ---
Rectangulo 20, 84,  418, 152, 12
Rectangulo 66, 104, 408, 172, 12
Rectangulo 14, 84,  418, 238, 12

; --- INTERIOR DE LA CAPUCHA (Marron: 6) ---
Rectangulo 56, 76, 422, 170, 6
Rectangulo 12, 56, 432, 226, 6

; --- CARA (Color: 90), OJOS (Blanco: 15) y PUPILAS (Negro: 0) ---
Rectangulo 46, 52, 434, 178, 90
Rectangulo 22, 18, 440, 186, 15    ; Ojo izquierdo
Rectangulo 22, 18, 462, 186, 15    ; Ojo derecho
Rectangulo 4,  4,  450, 196, 0     ; Pupila izquierda
Rectangulo 4,  4,  466, 196, 0     ; Pupila derecha

; --- CORDONES DE LA CAPUCHA (Negro: 0) ---
Rectangulo 2,  56, 432, 232, 0
Rectangulo 18, 2,  457, 234, 0
Rectangulo 18, 2,  461, 234, 0

; --- CORONA (Banda Marron/Dorado: 6, Puntas Amarillo: 14) ---
Rectangulo 10, 124, 398, 134, 6
Rectangulo 16, 20,  450, 124, 14   ; Cresta central
Rectangulo 14, 5,   406, 128, 14
Rectangulo 14, 5,   422, 128, 14
Rectangulo 14, 5,   438, 128, 14
Rectangulo 14, 5,   477, 128, 14
Rectangulo 14, 5,   493, 128, 14
Rectangulo 14, 5,   509, 128, 14

; --- TRENZAS CON CINTAS (Amarillo: 14, Blanco: 15, Punta: 8) ---
Rectangulo 42, 10, 408, 210, 14    ; Trenza izquierda
Rectangulo 4,  10, 408, 218, 15
Rectangulo 4,  10, 408, 230, 15
Rectangulo 4,  10, 408, 242, 15
Rectangulo 5,  8,  409, 252, 8

Rectangulo 42, 10, 502, 210, 14    ; Trenza derecha
Rectangulo 4,  10, 502, 218, 15
Rectangulo 4,  10, 502, 230, 15
Rectangulo 4,  10, 502, 242, 15
Rectangulo 5,  8,  503, 252, 8

; --- VESTIDO MORADO (Magenta: 5) y COLLAR (Amarillo: 14, Cyan: 11) ---
Rectangulo 30, 92, 414, 252, 5
Rectangulo 3,  44, 438, 254, 14
Rectangulo 5,  5,  448, 257, 11
Rectangulo 5,  5,  458, 258, 11
Rectangulo 5,  5,  468, 257, 11

; --- FALDA BLANCA (15) y BROCHE (Amarillo: 14, Rojo: 4) ---
Rectangulo 26, 104, 408, 282, 15
Rectangulo 12, 30,  445, 284, 14
Rectangulo 5,  5,   447, 286, 4
Rectangulo 5,  5,   468, 286, 4
Rectangulo 4,  4,   458, 292, 4

; --- BRAZOS (Color: 90) y GUANTES (Blanco: 15) ---
Rectangulo 26, 14, 402, 254, 90
Rectangulo 26, 14, 504, 254, 90
Rectangulo 18, 20, 398, 276, 15
Rectangulo 18, 20, 502, 276, 15

; --- PARTE INFERIOR (Naranja: 12) y ZAPATOS (Gris oscuro: 8) ---
Rectangulo 10, 88, 416, 308, 12
Rectangulo 6,  94, 413, 318, 8

; Esperar una tecla antes de cerrar
mov ah, 07h
int 21h

salir:
    ret
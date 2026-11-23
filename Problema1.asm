; Ejercicio 1: Acierta al resultado

org 100h

.DATA
    aciertos    dw 0
    ronda       dw 1
    op1         dw 0
    op2         dw 0
    operador    dw 0            ; 0: suma, 1: resta, 2: division entera
    resCorrecto dw 0
    posCorrecta dw 1            ; posicion correcta entre 1 y 5
    opciones    dw 5 dup(0)     ; arreglo con las 5 opciones

    msgRonda    db 10, 13, "Pregunta $"
    msgDosPtos  db ": $"
    msgMas      db " + $"
    msgMenos    db " - $"
    msgDiv      db " / $"
    msgIgual    db " = ?$"
    msgSel      db 10, 13, "Ingrese opcion (1-5): $"
    msgVictoria db 10, 13, 10, 13, "=== VICTORIA === Aciertos: $"
    msgDerrota  db 10, 13, 10, 13, "=== DERROTA === Aciertos: $"

; Macro para imprimir cadenas terminadas en '$' (INT 21h, AH=09h)
imprimir_str macro cad
    push ax
    push dx
    mov ah, 09h
    lea dx, cad
    int 21h
    pop dx
    pop ax
endm

; Macro para imprimir un caracter (INT 21h, AH=02h)
imprimir_char macro car
    push ax
    push dx
    mov ah, 02h
    mov dl, car
    int 21h
    pop dx
    pop ax
endm

; Macro para leer una opcion (1-5) y convertir de ASCII a numero

leer_opcion macro
    local pedir_opcion
    push bx
pedir_opcion:
    imprimir_str msgSel         ; Imprime salto de linea + "Ingrese opcion (1-5): "
    mov ah, 01h
    int 21h
    cmp al, '1'
    jb pedir_opcion             ; Si es menor que '1', vuelve a pedir
    cmp al, '5'
    ja pedir_opcion             ; Si es mayor que '5', vuelve a pedir
    sub al, 30h                 ; Convierte ASCII ('1'..'5') a numero (1..5)
    mov ah, 0
    pop bx
endm



.CODE
    mov cx, 5                   ; 5 preguntas en total
ciclo_juego:
    call generar_pregunta
    call armar_opciones
    call mostrar_pregunta_y_opciones

    leer_opcion                 ; eleccion del usuario (1..5) en AX

    cmp ax, posCorrecta
    je acerto_ronda
    jmp game_over               ; si se equivoca, termina de inmediato

acerto_ronda:
    inc aciertos
    inc ronda
    loop ciclo_juego

    call pantalla_victoria
    jmp salir

game_over:
    call pantalla_derrota

salir:
    ret

; --- Subrutinas (CALL / RET) ---

generar_pregunta:
    push ax
    push bx
    push cx
    push dx

    ; op1 entero aleatorio en [0, 99]
    mov ah, 2Ch                 ; DL = centesimas (0..99)
    int 21h
    mov al, dl
    mov ah, 0
    mov bl, 100
    div bl
    mov al, ah                  ; residuo 0..99
    mov ah, 0
    mov op1, ax

    ; op2 entero aleatorio en [0, 99]
    mov ah, 2Ch
    int 21h
    mov al, cl                  ; CL = minutos
    add al, dl                  ; mezclar con centesimas
    mov ah, 0
    mov bl, 100
    div bl
    mov al, ah                  ; residuo 0..99
    mov ah, 0
    mov op2, ax

    ; operador aleatorio: 0 = suma, 1 = resta, 2 = division entera
    mov ah, 2Ch
    int 21h
    mov al, dh                  ; DH = segundos
    add al, dl
    mov ah, 0
    mov bl, 3
    div bl
    mov al, ah                  ; residuo 0..2
    mov ah, 0
    mov operador, ax

    ; calcular resultado correcto
    mov ax, op1
    cmp operador, 0
    je hacer_suma
    cmp operador, 1
    je hacer_resta

    ; division entera (evitar dividir por 0)
    cmp op2, 0
    jne hacer_div
    mov resCorrecto, 0
    jmp fin_preg

hacer_div:
    mov dx, 0
    div op2                     ; cociente entero en AX
    mov resCorrecto, ax
    jmp fin_preg

hacer_suma:
    add ax, op2
    mov resCorrecto, ax
    jmp fin_preg

hacer_resta:
    sub ax, op2
    mov resCorrecto, ax

fin_preg:
    pop dx
    pop cx
    pop bx
    pop ax
    ret

armar_opciones:
    push ax
    push bx
    push cx
    push dx
    push si

    ; elegir posicion correcta aleatoria entre 1 y 5
    mov ah, 2Ch
    int 21h
    mov al, dl
    add al, dh
    mov ah, 0
    mov bl, 5
    div bl
    mov al, ah                  ; residuo 0..4
    mov ah, 0
    inc ax                      ; posicion 1..5
    mov posCorrecta, ax

    ; generar 5 valores distintos para que no sean obvios
    mov ax, resCorrecto
    add ax, 2
    call ajustar_si_igual_correcta
    mov opciones[0], ax

    mov ax, resCorrecto
    sub ax, 3
    call ajustar_si_igual_correcta
    mov opciones[2], ax

    mov ax, resCorrecto
    add ax, 5
    call ajustar_si_igual_correcta
    mov opciones[4], ax

    mov ax, resCorrecto
    sub ax, 1
    call ajustar_si_igual_correcta
    mov opciones[6], ax

    mov ax, resCorrecto
    add ax, 8
    call ajustar_si_igual_correcta
    mov opciones[8], ax

    ; colocar resCorrecto en su posicion (posCorrecta - 1) * 2
    mov si, posCorrecta
    dec si
    add si, si
    mov ax, resCorrecto
    mov opciones[si], ax

    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; Evita que un distractor quede exactamente igual a resCorrecto
ajustar_si_igual_correcta:
    cmp ax, resCorrecto
    jne fin_ajuste
    add ax, 1
fin_ajuste:
    ret

mostrar_pregunta_y_opciones:
    push ax
    push bx
    push cx
    push dx
    push si

    imprimir_str msgRonda
    mov ax, ronda
    call imprimir_numero
    imprimir_str msgDosPtos

    mov ax, op1
    call imprimir_numero

    cmp operador, 0
    je imp_mas
    cmp operador, 1
    je imp_menos
    imprimir_str msgDiv
    jmp imp_op2

imp_mas:
    imprimir_str msgMas
    jmp imp_op2

imp_menos:
    imprimir_str msgMenos

imp_op2:
    mov ax, op2
    call imprimir_numero
    imprimir_str msgIgual

    ; mostrar las 5 opciones en lineas separadas (1 a 5)
    mov cx, 5
    mov si, 0
    mov bx, 1

ciclo_imp_opc:
    imprimir_char 10
    imprimir_char 13

    mov dx, bx
    add dl, 30h
    mov ah, 02h
    int 21h

    imprimir_char ')'
    imprimir_char ' '

    mov ax, opciones[si]
    call imprimir_numero

    add si, 2
    inc bx
    loop ciclo_imp_opc

    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; Imprime un entero en AX (soporta negativos mostrando '-')
imprimir_numero:
    push ax
    push bx
    push cx
    push dx

    cmp ax, 0
    jge num_positivo

    imprimir_char '-'
    neg ax                      ; convertir a positivo para imprimir digitos

num_positivo:
    mov cx, 0
    mov bx, 10

    cmp ax, 0
    jne dividir_digitos
    imprimir_char '0'
    jmp fin_imp_num

dividir_digitos:
    cmp ax, 0
    je sacar_digitos
    mov dx, 0
    div bx                      ; cociente en AX, resto en DX
    push dx
    inc cx
    jmp dividir_digitos

sacar_digitos:
    cmp cx, 0
    je fin_imp_num
    pop dx
    add dl, 30h
    mov ah, 02h
    int 21h
    dec cx
    jmp sacar_digitos

fin_imp_num:
    pop dx
    pop cx
    pop bx
    pop ax
    ret

pantalla_victoria:
    push ax
    push dx
    imprimir_str msgVictoria
    mov ax, aciertos
    call imprimir_numero
    pop dx
    pop ax
    ret

pantalla_derrota:
    push ax
    push dx
    imprimir_str msgDerrota
    mov ax, aciertos
    call imprimir_numero
    pop dx
    pop ax
    ret

end




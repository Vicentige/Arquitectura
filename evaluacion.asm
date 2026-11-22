; ================================
; Ejercicio 2: Poker version ICI 
; ================================
ORG 100h
     
.DATA

MAZO_VAL  DB 24 DUP(0)
MAZO_PINTA DB 24 DUP(0)
CARTAS_RESTANTES DB 24

MANO_J1_VAL DB 3 DUP(0)
MANO_J1_PIN DB 3 DUP(0)

MANO_J2_VAL DB 3 DUP(0)
MANO_J2_PIN DB 3 DUP(0)

AUX_MANO DB 3 DUP(0)
AUX_PINTA DB 3 DUP(0)

PTS_J1 DB 0
PTS_J2 DB 0 

;C = Carta 
C_ALTA_J1 DB 0
C_ALTA_J2 DB 0

VICT_J1 DB 0
VICT_J2 DB 0

RONDA DB 1

;Nombres de pintas
J_PROFESORES DB "!Nuestros profes!$"
J_ESCALA_R DB "Escala real$"
J_ESCALA_F DB "Escala falsa$"
J_TRIO DB "Trio$"
J_DOS    DB "Dos$"
J_POBRE  DB "Mano pobre$"


;Textos
MSG_TITULO DB "POKER VERSION ICI$"
MSG_RONDA DB "RONDA NUMERO $"
MSG_J1 DB "JUGADOR_1: $"
MSG_J2 DB "JUGADOR_2: $"
SALTO DB 13,10,"$"
MSG_JUGADA DB "Jugada: $"   
MSG_MARCADOR DB "Marcador$"
MSG_VICTORIA_J1 DB "Victoria del jugador 1$"
MSG_VICTORIA_J2 DB "Victoria del jugador 2$"
MSG_SIN_CARTAS DB "Se agoto el mazo$"
MSG_PAUSA DB "Presione una tecla para continuar $"

MSG_GANA_R1 DB "Ganador de la ronda: Jugador 1$"
MSG_GANA_R2 DB "Ganador de la ronda: Jugador 2$"
MSG_EMPATE  DB "Empate en la ronda (no suma puntos)$"
MSG_CARTA_PROTITIPO DB " - $"

; Nombres de cartas especiales (5..8)
C_PHILIP      DB "Philip$"
C_CARLITOS    DB "Carlitos$"
C_MARCO       DB "Marco$"
C_HUGO        DB "Hugo$"
; Conector y nombres de pintas (1..3)
MSG_DE        DB " de $"
P_INGENIERO   DB "Ingeniero$"
P_INFORMATICO DB "Informatico$"
P_DOCENTE     DB "Docente$"
; Formato para mostrar puntaje junto a la jugada
MSG_PTS_INI   DB " ($"
MSG_PTS_FIN   DB " pts)$"



.CODE
IMPRIMIR MACRO MSG
    PUSH AX 
    PUSH DX
    LEA DX, MSG
    MOV AH, 9h
    INT 21H
    POP DX
    POP AX
ENDM

IMPRIMIR_MARCADOR MACRO V1, V2
    PUSH AX
    IMPRIMIR MSG_MARCADOR
    IMPRIMIR SALTO
    IMPRIMIR MSG_J1
    MOV AL, V1
    CALL IMPRIMIR_NUM
    IMPRIMIR SALTO
    IMPRIMIR MSG_J2
    MOV AL, V2
    CALL IMPRIMIR_NUM
    IMPRIMIR SALTO
    

    ;Pausa para que el sistema no se ejecute instantaneamente, esperando respuesta del usuario
    IMPRIMIR MSG_PAUSA
    MOV AH, 07h ; SE PASUA ESPERANDO UNA TECLA
    INT 21h
    IMPRIMIR SALTO
    IMPRIMIR SALTO
    POP AX
ENDM

ORDENAR_PAR MACRO I, J
    LOCAL NO_SWAP
    MOV AL, AUX_MANO + I
    MOV AH, AUX_MANO + J
    CMP AL, AH
    JBE NO_SWAP

    ; Intercambiar valores
    MOV AUX_MANO + I, AH
    MOV AUX_MANO + J, AL
    
    ; Intercambiar tambien sus pintas para que cada carta mantenga la suya
    MOV AL, AUX_PINTA + I
    MOV AH, AUX_PINTA + J
    MOV AUX_PINTA + I, AH
    MOV AUX_PINTA + J, AL
NO_SWAP:
ENDM

JMP INICIO



INICIO:
    CALL INIT_MAZO
    CALL INIT_RANDOM
    
    IMPRIMIR MSG_TITULO
    IMPRIMIR SALTO

CICLO_RONDAS:

    ; Primero se verifica si alguien ya gano 2 veces
    CMP VICT_J1, 2
    JLE SIGUE_J1
    JMP FIN_PARTIDA

SIGUE_J1:

    CMP VICT_J2, 2
    JLE SIGUE_J2
    JMP FIN_PARTIDA

SIGUE_J2:

    ; Verifica si queda al menos 6 cartas en el mazo
    CMP CARTAS_RESTANTES, 6
    JAE HAY_CARTAS
    JMP MAZO_AHOGADO

HAY_CARTAS:

    ; Mostrar numero de ronda
    IMPRIMIR MSG_RONDA
    MOV AL, RONDA
    CALL IMPRIMIR_NUM
    IMPRIMIR SALTO

    ;Repartir 3 cartas a cada jugador
    LEA DI, MANO_J1_VAL
    LEA BX, MANO_J1_PIN
    CALL REPARTIR_MANO

    LEA DI, MANO_J2_VAL
    LEA BX, MANO_J2_PIN
    CALL REPARTIR_MANO

    ;Evaluar mano jugador 1
    LEA SI, MANO_J1_VAL
    LEA BX, MANO_J1_PIN
    CALL EVALUAR_MANO
    MOV PTS_J1, AL
    MOV C_ALTA_J1, AH

    ;Evaluar mano jugador 2
    LEA SI, MANO_J2_VAL
    LEA BX, MANO_J2_PIN
    CALL EVALUAR_MANO
    MOV PTS_J2, AL
    MOV C_ALTA_J2, AH

    ;Mostrar mano y jugada J1  
    IMPRIMIR MSG_J1
    IMPRIMIR SALTO
    LEA SI, MANO_J1_VAL
    LEA BX, MANO_J1_PIN
    CALL MOSTRAR_MANO
    IMPRIMIR MSG_JUGADA
    MOV AL, PTS_J1
    CALL MOSTRAR_JUGADA
    IMPRIMIR SALTO
    
    ;Mostrar mano y jugada J2
     
    IMPRIMIR MSG_J2
    IMPRIMIR SALTO
    LEA SI, MANO_J2_VAL
    LEA BX, MANO_J2_PIN
    CALL MOSTRAR_MANO
    IMPRIMIR MSG_JUGADA
    MOV AL, PTS_J2
    CALL MOSTRAR_JUGADA
    IMPRIMIR SALTO

    ;Determinar el ganador de la ronda
    CALL RESOLVER_RONDA

    ;Mostrar Marcador (puntajes)
    
    IMPRIMIR_MARCADOR VICT_J1, VICT_J2
    IMPRIMIR SALTO

    INC RONDA
    JMP CICLO_RONDAS

MAZO_AHOGADO:
    LEA DX, MSG_SIN_CARTAS
    MOV AH, 9
    INT 21H
    IMPRIMIR SALTO
    JMP FIN

FIN_PARTIDA:
    MOV AL, VICT_J1
    CMP AL, VICT_J2
    JA GANA_TOTAL_J1
    JMP GANA_TOTAL_J2

GANA_TOTAL_J1:
    IMPRIMIR MSG_VICTORIA_J1
    JMP FIN

GANA_TOTAL_J2:
    IMPRIMIR MSG_VICTORIA_J2
    JMP FIN

FIN:
    IMPRIMIR SALTO
    MOV AX, 4C00h
    INT 21h

INIT_RANDOM:
    MOV AH, 2Ch
    INT 21h              ; Devuelve segundos y centesimas en DX
    MOV AX, DX           ; Lo pasamos directo a AX
    CMP AX, 0
    JE  USAR_DEFECTO
    RET   
    
USAR_DEFECTO:
    MOV AX, 1ACEh
    RET
    

;Subrutinas necesarias
    
INIT_MAZO:
    MOV SI, 0
    MOV BL, 1

CICLO_PINTA:
    MOV BH, 1      ; valor: 1...8

CICLO_VALOR_C:
    MOV MAZO_PINTA[SI], BL
    MOV MAZO_VAL[SI], BH
    INC SI
    INC BH
    CMP BH, 8
    JBE CICLO_VALOR_C     ;salta si es menor o igual a 8
    INC BL 
    CMP BL, 3
    JBE CICLO_PINTA
    MOV CARTAS_RESTANTES, 24
    RET

ROBAR_CARTA:
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    PUSH DI

    CALL INIT_RANDOM     ; Ya deja el numero aleatorio listo en AX
    MOV DX, 0
    MOV BL, CARTAS_RESTANTES
    MOV BH, 0
    DIV BX               ; DX = residuo (0 .. CARTAS_RESTANTES - 1)
    MOV SI, DX           ; Indice de la carta en el mazo
    MOV AL, MAZO_VAL[SI]
    MOV AH, MAZO_PINTA[SI]

    DEC CARTAS_RESTANTES
    MOV BL, CARTAS_RESTANTES
    MOV BH, 0
    MOV DI, BX
    MOV BL, MAZO_VAL[DI]
    MOV MAZO_VAL[SI], BL
    MOV BL, MAZO_PINTA[DI]
    MOV MAZO_PINTA[SI], BL

    POP DI
    POP SI
    POP DX
    POP CX
    POP BX
    RET


REPARTIR_MANO:
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH DI
    MOV CX, 3

CICLO_REPARTIR:
    CALL ROBAR_CARTA
    MOV [DI], AL
    MOV [BX], AH
    INC DI
    INC BX
    LOOP CICLO_REPARTIR

    POP DI
    POP DX
    POP CX
    POP BX
    POP AX
    RET



;Ordena el valor de las cartas por pinta y de menero a mayor

EVALUAR_MANO:
    PUSH BX
    PUSH CX
    PUSH SI
    PUSH DI

    MOV CX, 3
    MOV DI, 0

COPIAR_AUX:
    MOV AL, [SI]
    MOV AUX_MANO[DI], AL
    MOV AL, [BX]
    MOV AUX_PINTA[DI], al
    
    INC SI
    INC BX
    INC DI

    LOOP COPIAR_AUX

;-------ordenar las 3 cartas de menor a mayor-----------
    ORDENAR_PAR 0, 1
    ORDENAR_PAR 1, 2
    ORDENAR_PAR 0, 1


;-------Evaluamos de mayor a menor puntaje-----------
; 1.- !Nuestros profes! (15 pts): la de menor valor >=5
MOV AL, AUX_MANO
CMP AL, 5
JB NO_PROFES
MOV AL, 15
JMP FIN_EVALUAR

NO_PROFES:
    ; 2. Escalas: verificar consecutivas (v1 = v0 + 1 y v2 = v1 + 1)
    MOV AL, AUX_MANO + 0
    INC AL
    CMP AL, AUX_MANO + 1
    JNE REVISAR_TRIO
    MOV AL, AUX_MANO + 1
    INC AL
    CMP AL, AUX_MANO + 2
    JNE REVISAR_TRIO

    ; Son consecutivas -> revisar si todas tienen la misma pinta

    MOV AL, AUX_PINTA + 0
    CMP AL, AUX_PINTA + 1
    JNE ES_ESCALA_FALSA
    CMP AL, AUX_PINTA + 2
    JNE ES_ESCALA_FALSA
    MOV AL, 10               ; Escala real
    JMP FIN_EVALUAR
ES_ESCALA_FALSA:
    MOV AL, 5                ; Escala falsa
    JMP FIN_EVALUAR
REVISAR_TRIO:
    ; 3. Trio (3 pts): ordenadas, si 1ra == 3ra, todas son iguales

    MOV AL, AUX_MANO + 0
    CMP AL, AUX_MANO + 2
    JNE REVISAR_DOS
    MOV AL, 3
    JMP FIN_EVALUAR
REVISAR_DOS:
    ; 4. Dos (2 pts): ordenadas, dos iguales quedan juntas

    MOV AL, AUX_MANO + 0
    CMP AL, AUX_MANO + 1
    JE ES_DOS

    MOV AL, AUX_MANO + 1
    CMP AL, AUX_MANO + 2
    JE ES_DOS

    ; 5. Mano pobre (1 pt)

    MOV AL, 1
    JMP FIN_EVALUAR
ES_DOS:
    MOV AL, 2
FIN_EVALUAR:
    MOV AH, AUX_MANO + 2     ; Devolver en AH la carta mas alta
    POP DI
    POP SI
    POP CX
    POP BX
    RET
    




MOSTRAR_MANO:
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH SI
    MOV CX, 3

CICLO_MOSTRAR_MANO:
    IMPRIMIR MSG_CARTA_PROTITIPO
    MOV AL, [SI]
    MOV AH, [BX]
    CALL MOSTRAR_CARTA
    IMPRIMIR SALTO
    INC SI
    INC BX
    LOOP CICLO_MOSTRAR_MANO
    POP SI
    POP CX
    POP BX
    POP AX
    RET
    




;Imprime 1 carta, la que esta en AL es el valor, y la que esta en AH es la pinta
MOSTRAR_CARTA:
    PUSH AX
    PUSH BX

    MOV BL, AH

    CMP AL, 4

    JA VALOR_PROFE
    CALL IMPRIMIR_NUM
    JMP IMPRIMIR_PINTA

VALOR_PROFE:
    CMP AL, 5
    JE ES_PHILIP
    CMP AL, 6
    JE ES_CARLITOS
    CMP AL, 7
    JE ES_MARCO
    IMPRIMIR C_HUGO          ; Si no es 5, 6 ni 7, es 8 (Hugo)
    JMP IMPRIMIR_PINTA

ES_PHILIP:
    IMPRIMIR C_PHILIP
    JMP IMPRIMIR_PINTA
ES_CARLITOS:
    IMPRIMIR C_CARLITOS
    JMP IMPRIMIR_PINTA
ES_MARCO:
    IMPRIMIR C_MARCO

IMPRIMIR_PINTA:
    IMPRIMIR MSG_DE
    
    CMP BL, 1
    JE ES_INGENIERO
    CMP BL, 2
    JE ES_INFORMATICO
    IMPRIMIR P_DOCENTE       ; Si no es 1 ni 2, es 3 (Docente)
    JMP FIN_MOSTRAR_CARTA

ES_INGENIERO:
    IMPRIMIR P_INGENIERO
    JMP FIN_MOSTRAR_CARTA

ES_INFORMATICO:
    IMPRIMIR P_INFORMATICO

FIN_MOSTRAR_CARTA:
    POP BX
    POP AX
    RET

; Imprime el nombre de la jugada y el puntaje recibido en AL
MOSTRAR_JUGADA:
    PUSH AX

    CMP AL, 15
    JE JUG_PROFES
    CMP AL, 10
    JE JUG_ESC_R
    CMP AL, 5
    JE JUG_ESC_F
    CMP AL, 3
    JE JUG_TRIO
    CMP AL, 2
    JE JUG_DOS_C

    IMPRIMIR J_POBRE         ; Por defecto 1 punto
    JMP IMPRIMIR_PTS_JUGADA

JUG_PROFES:
    IMPRIMIR J_PROFESORES
    JMP IMPRIMIR_PTS_JUGADA
JUG_ESC_R:
    IMPRIMIR J_ESCALA_R
    JMP IMPRIMIR_PTS_JUGADA
JUG_ESC_F:
    IMPRIMIR J_ESCALA_F
    JMP IMPRIMIR_PTS_JUGADA
JUG_TRIO:
    IMPRIMIR J_TRIO
    JMP IMPRIMIR_PTS_JUGADA
JUG_DOS_C:
    IMPRIMIR J_DOS

IMPRIMIR_PTS_JUGADA:
    IMPRIMIR MSG_PTS_INI
    CALL IMPRIMIR_NUM        ; AL sigue intacto porque IMPRIMIR respalda AX
    IMPRIMIR MSG_PTS_FIN

    POP AX
    RET


    

RESOLVER_RONDA:
    MOV AL, PTS_J1
    CMP AL, PTS_J2
    JA R_GANA_J1    ;Salta si el primero es mayor 
    JB R_GANA_J2    ;Salta si el primero es menor
    
    ;Si los dos tienen mismos puntajes, se desempata con la carta más Carta mas alta
    CMP AL, 1
    JNE R_EMPATE        ;Salta si no es igual
    MOV AL, C_ALTA_J1
    CMP AL, C_ALTA_J2
    JA R_GANA_J1    ;Salta si el primero es mayor 
    JB R_GANA_J2    ;Salta si el primero es menor

R_EMPATE:
    IMPRIMIR MSG_EMPATE
    IMPRIMIR SALTO
    RET

R_GANA_J1:
    INC VICT_J1
    IMPRIMIR MSG_GANA_R1
    IMPRIMIR SALTO
    RET

R_GANA_J2:
    INC VICT_J2
    IMPRIMIR MSG_GANA_R2
    IMPRIMIR SALTO
    RET


;Imprime un numero contendio en AL   
IMPRIMIR_NUM:
    PUSH AX
    PUSH BX
    PUSH DX

    CMP AL, 10
    JB UN_DIGITO

    MOV AH, 0
    MOV BL, 10
    DIV BL      ;AL = DECENA , AH = UNIDAD
    MOV BH, AH  ;GUARDA LA UNIDAD EN BH ANTES DE USAR AH EN INT 21h

    MOV DL, AL
    ADD DL, 30h
    MOV AH, 2h
    INT 21h
    
    MOV AL, BH

UN_DIGITO:
    MOV DL, AL
    ADD DL, 30h        ; Convertir unidad (o digito unico) a ASCII
    MOV AH, 2h
    INT 21h            ; Imprimir digito
    
    POP DX             ; Restaurar registros en orden inverso (LIFO)
    POP BX
    POP AX
    RET
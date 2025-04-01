; Esempio semplice di programma Assembly per EMU8086
; - Input/output di base
; - Operazioni semplici
; - Struttura condizionale
; - Subroutine base

.MODEL SMALL
.STACK 100h
.DATA
    ; Definizione dati
    messaggio DB 'Esempio semplice di Assembly!$'
    richiesta DB 'Inserisci un numero (0-9): $'
    risultato DB 'Hai inserito: $'
    maggiore DB 'Il numero e maggiore di 5!$'
    minore DB 'Il numero e minore o uguale a 5!$'
    numero DB ?
    newline DB 13, 10, '$'  ; Caratteri CR+LF (a capo)
    testo DB 'Hello$'
    buffer DB 10 DUP(?)

.CODE
main PROC
    ; Inizializzazione segmento dati
    MOV AX, @DATA
    MOV DS, AX
    
    ; Visualizza messaggio iniziale
    LEA DX, messaggio
    CALL stampa_messaggio
    
    ; Nuova linea
    LEA DX, newline
    CALL stampa_messaggio
    
    ; Richiesta input
    LEA DX, richiesta
    CALL stampa_messaggio
    
    ; Leggi un carattere
    MOV AH, 1
    INT 21h
    
    ; Converti da ASCII a valore numerico
    SUB AL, '0'
    MOV numero, AL
    
    ; Nuova linea
    LEA DX, newline
    CALL stampa_messaggio
    
    ; Visualizza messaggio risultato
    LEA DX, risultato
    CALL stampa_messaggio
    
    ; Visualizza il numero inserito
    MOV DL, numero
    ADD DL, '0'    ; Converti in ASCII
    MOV AH, 2      ; Funzione per visualizzare carattere
    INT 21h
    
    ; Nuova linea
    LEA DX, newline
    CALL stampa_messaggio
    
    ; Semplice confronto con 5
    CMP numero, 5
    JG numero_maggiore
    
    ; Se minore o uguale
    LEA DX, minore
    CALL stampa_messaggio
    JMP fine_confronto
    
numero_maggiore:
    LEA DX, maggiore
    CALL stampa_messaggio
    
fine_confronto:
    ; Nuova linea
    LEA DX, newline
    CALL stampa_messaggio
    
    ; Esempio di copia stringa semplice
    CALL copia_stringa
    
    ; Visualizza stringa copiata
    LEA DX, buffer
    CALL stampa_messaggio
    
    ; Termina il programma
    MOV AH, 4Ch
    INT 21h
main ENDP

; Subroutine per stampare un messaggio
stampa_messaggio PROC
    MOV AH, 9
    INT 21h
    RET
stampa_messaggio ENDP

; Subroutine semplice per copiare una stringa
copia_stringa PROC
    CLD
    LEA SI, testo
    LEA DI, buffer
    
    MOV CX, 6      ; Lunghezza massima (incluso $)
    
ciclo_copia:
    LODSB          ; Carica carattere da SI in AL
    STOSB          ; Memorizza AL in DI
    CMP AL, '$'    ; Controlla fine stringa
    JE fine_copia
    LOOP ciclo_copia
    
fine_copia:
    RET
copia_stringa ENDP

END main
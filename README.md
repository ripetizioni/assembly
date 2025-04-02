# Appunti di Assembly - Corso di Sistemi e Reti

[Debugger Enhancements for 8086/8088 (PCjs)](https://www.pcjs.org/software/pcx86/util/other/enhdebug/1.32b/)

## Indice
1. [Introduzione al Linguaggio Assembly](#1-introduzione-al-linguaggio-assembly)
   1.1 [I Registri del Processore](#11-i-registri-del-processore)
2. [Metodi di Indirizzamento](#2-metodi-di-indirizzamento)
3. [Ambiente di Simulazione EMU8086](#3-ambiente-di-simulazione-emu8086)
4. [Strutture di Controllo](#4-strutture-di-controllo)
5. [Operazioni di Input/Output](#5-operazioni-di-inputoutput)
6. [Le Subroutine](#6-le-subroutine)
7. [Le Stringhe](#7-le-stringhe)
- [Riferimenti Utili](#riferimenti-utili)

## 1. Introduzione al Linguaggio Assembly

Il linguaggio Assembly è un linguaggio di programmazione di basso livello che rappresenta un'interfaccia diretta con l'hardware del computer. A differenza dei linguaggi di alto livello come Python o Java, l'Assembly ha una corrispondenza quasi diretta con il linguaggio macchina (sequenze di 0 e 1) eseguito dal processore.

### Caratteristiche principali:
- **Dipendenza dall'architettura**: ogni famiglia di processori ha il proprio set di istruzioni Assembly
- **Controllo preciso dell'hardware**: permette di controllare direttamente i registri e la memoria
- **Efficienza**: programmi ben scritti in Assembly possono essere estremamente efficienti
- **Complessità**: richiede conoscenza dettagliata dell'hardware

### 1.1 I Registri del Processore

I registri sono unità di memoria ad accesso veloce interne al processore. Nell'architettura x86, ogni registro ha funzioni specifiche:

#### Registri General-Purpose (16 bit)
- **AX (Accumulatore)**: Operazioni aritmetiche, I/O, moltiplicazioni/divisioni
  - **AH, AL**: Parti alta e bassa di AX (8 bit ciascuna)
- **BX (Base)**: Indirizzamento in memoria, calcolo indirizzi
  - **BH, BL**: Parti alta e bassa di BX
- **CX (Contatore)**: Conteggio cicli, operazioni su stringhe
  - **CH, CL**: Parti alta e bassa di CX
- **DX (Data)**: I/O, operazioni aritmetiche estese, parte alta in divisioni/moltiplicazioni
  - **DH, DL**: Parti alta e bassa di DX

##### Parti alta e bassa dei registri
Ciascun registro general-purpose da 16 bit può essere utilizzato come un unico registro a 16 bit (es. AX) o come due registri separati da 8 bit ciascuno:
- **Parte alta (H)**: gli 8 bit più significativi (es. AH = bits 15-8 di AX)
- **Parte bassa (L)**: gli 8 bit meno significativi (es. AL = bits 7-0 di AX)

Questa suddivisione permette:
- Operazioni più efficienti su dati a 8 bit
- Accesso separato a byte singoli senza dover estrarre/mascherare manualmente i bit
- Retrocompatibilità con processori 8-bit precedenti

Esempio di manipolazione delle parti:
```assembly
MOV AL, 12h     ; Modifica solo la parte bassa di AX
MOV AH, 34h     ; Modifica solo la parte alta di AX
                ; Ora AX contiene 3412h

MOV CL, 5       ; Modifica solo la parte bassa di CX
SHL CH, 1       ; Operazione solo sulla parte alta di CX
```

#### Registri Indice e Puntatori
- **SI (Source Index)**: Puntatore sorgente per operazioni su stringhe
- **DI (Destination Index)**: Puntatore destinazione per operazioni su stringhe
- **SP (Stack Pointer)**: Puntatore al top dello stack
- **BP (Base Pointer)**: Referenziazione parametri e variabili locali nello stack

#### Registri Segmento
- **CS (Code Segment)**: Segmento di codice corrente
- **DS (Data Segment)**: Segmento dati predefinito
- **SS (Stack Segment)**: Segmento dello stack
- **ES (Extra Segment)**: Segmento extra per operazioni su stringhe

#### Registro Istruzioni
- **IP (Instruction Pointer)**: Puntatore alla prossima istruzione da eseguire

#### Registro Flag
Contiene i bit di stato che riflettono il risultato delle operazioni:
- **CF (Carry Flag)**: Riporto in operazioni aritmetiche
- **ZF (Zero Flag)**: Risultato operazione uguale a zero
- **SF (Sign Flag)**: Risultato operazione negativo
- **OF (Overflow Flag)**: Overflow in operazioni aritmetiche
- **DF (Direction Flag)**: Direzione per operazioni su stringhe (0=incremento, 1=decremento)

## 2. Metodi di Indirizzamento

I metodi di indirizzamento definiscono come le istruzioni Assembly accedono ai dati in memoria o nei registri.

### Principali metodi di indirizzamento:

1. **Indirizzamento immediato**: il valore è specificato direttamente nell'istruzione
   ```assembly
   MOV AX, 1234h  ; Carica il valore immediato 1234h nel registro AX
   ```

2. **Indirizzamento a registro**: l'operando è contenuto in un registro
   ```assembly
   MOV AX, BX     ; Copia il contenuto del registro BX in AX
   ```

3. **Indirizzamento diretto**: l'indirizzo di memoria è specificato direttamente
   ```assembly
   MOV AX, [1234h]  ; Carica in AX il contenuto della memoria all'indirizzo 1234h
   ```

4. **Indirizzamento indiretto a registro**: l'indirizzo è contenuto in un registro
   ```assembly
   MOV AX, [BX]   ; Carica in AX il valore dalla memoria all'indirizzo contenuto in BX
   ```

5. **Indirizzamento basato**: indirizzo = base + offset
   ```assembly
   MOV AX, [BX+10]  ; Carica in AX il valore dalla memoria all'indirizzo BX+10
   ```

6. **Indirizzamento indicizzato**: utilizza registri indice (SI, DI)
   ```assembly
   MOV AX, [SI]   ; Carica in AX il valore dalla memoria all'indirizzo in SI
   ```

## 3. Ambiente di Simulazione EMU8086

EMU8086 è un emulatore e assemblatore per processori Intel 8086, utilizzato per apprendere la programmazione Assembly.

### Principali caratteristiche:

- **Assemblatore integrato**: converte il codice Assembly in codice macchina
- **Debugger**: permette di eseguire il codice istruzione per istruzione
- **Visualizzazione registri e memoria**: mostra lo stato dei registri e della memoria durante l'esecuzione
- **Modalità step-by-step**: esecuzione controllata del programma

### Utilizzo base:
1. Scrittura del codice nell'editor
2. Assemblaggio (F9)
3. Esecuzione (F5) o esecuzione passo-passo (F8)
4. Monitoraggio dei registri e della memoria

## 4. Strutture di Controllo

### La Sequenza

L'esecuzione sequenziale è il flusso base in Assembly: le istruzioni vengono eseguite una dopo l'altra.

```assembly
MOV AX, 5    ; Prima istruzione
ADD AX, 10   ; Seconda istruzione
MOV BX, AX   ; Terza istruzione
```

### La Selezione (if)

In Assembly, la selezione viene implementata con istruzioni di salto condizionato.

```assembly
; Esempio di if: se AX > 10, allora BX = 1
MOV BX, 0      ; Valore predefinito
CMP AX, 10     ; Confronta AX con 10
JLE fine_if    ; Salta se AX <= 10
MOV BX, 1      ; Eseguito solo se AX > 10
fine_if:       ; Etichetta di destinazione
```

### La Selezione (if/else)

```assembly
; Esempio if/else: se AX > 10, BX = 1, altrimenti BX = 2
CMP AX, 10     ; Confronta AX con 10
JLE else_part  ; Salta alla parte else se AX <= 10
MOV BX, 1      ; Parte "if" (AX > 10)
JMP end_if     ; Salta alla fine della struttura
else_part:     ; Parte "else"
MOV BX, 2
end_if:        ; Fine della struttura if/else
```

### Il Ciclo While

```assembly
; Esempio: while (BX > 0) { AX += 2; BX--; }
inizio_while:
CMP BX, 0       ; Controlla la condizione
JLE fine_while  ; Esce se BX <= 0
ADD AX, 2       ; Corpo del ciclo
DEC BX          ; Decrementa BX
JMP inizio_while ; Torna all'inizio
fine_while:
```

### Il Ciclo For

```assembly
; Esempio: for (CX = 0; CX < 10; CX++) { AX += 5; }
MOV CX, 0       ; Inizializzazione
inizio_for:
CMP CX, 10      ; Controllo condizione
JGE fine_for    ; Esce se CX >= 10
ADD AX, 5       ; Corpo del ciclo
INC CX          ; Incremento
JMP inizio_for  ; Ripete
fine_for:
```

## 5. Operazioni di Input/Output

In Assembly, l'I/O può essere gestito attraverso interrupt software o porte di I/O.

### Input da tastiera
```assembly
; Lettura di un carattere
MOV AH, 1       ; Funzione di input carattere
INT 21h         ; Chiamata all'interrupt DOS
; Il carattere letto è ora in AL
```

### Output a schermo
```assembly
; Visualizzazione di un carattere
MOV AH, 2       ; Funzione di output carattere
MOV DL, 'A'     ; Carattere da visualizzare
INT 21h         ; Chiamata all'interrupt DOS
```

### Visualizzazione di stringhe
```assembly
; Visualizzazione di una stringa
MOV AH, 9       ; Funzione di output stringa
LEA DX, stringa ; Indirizzo della stringa (deve terminare con '$')
INT 21h         ; Chiamata all'interrupt DOS

; ... altrove nel codice ...
stringa DB 'Hello, World!$'  ; Definizione della stringa
```

## 6. Le Subroutine

Le subroutine (o procedure) permettono di organizzare il codice in blocchi riutilizzabili.

### Definizione e chiamata di una subroutine
```assembly
; Chiamata alla subroutine
CALL somma_numeri

; ... altro codice ...

; Definizione della subroutine
somma_numeri PROC
    MOV AX, 5
    ADD AX, 10
    RET           ; Ritorno dalla subroutine
somma_numeri ENDP
```

### Passaggio di parametri (tramite registri)
```assembly
; Chiamata con parametri
MOV AL, 5
MOV BL, 10
CALL moltiplica
; Risultato in AX

; Subroutine
moltiplica PROC
    MUL BL        ; AX = AL * BL
    RET
moltiplica ENDP
```

### Uso dello stack per salvare registri
```assembly
subroutine PROC
    PUSH BX       ; Salva BX nello stack
    PUSH CX       ; Salva CX nello stack
    
    ; Corpo della subroutine che modifica BX e CX
    
    POP CX        ; Ripristina CX
    POP BX        ; Ripristina BX
    RET
subroutine ENDP
```

## 7. Le Stringhe

In Assembly, le stringhe sono sequenze di byte in memoria che possono essere elaborate con istruzioni specializzate.

### Definizione di stringhe
```assembly
messaggio DB 'Hello, World!', 0  ; Stringa terminata da zero
nome DB 10 DUP(?)                ; Buffer di 10 byte non inizializzati
```

### Istruzioni per l'elaborazione di stringhe

- **MOVSB/MOVSW**: sposta un byte/word dalla memoria puntata da SI alla memoria puntata da DI
- **LODSB/LODSW**: carica un byte/word dalla memoria puntata da SI in AL/AX
- **STOSB/STOSW**: memorizza AL/AX nella memoria puntata da DI
- **CMPSB/CMPSW**: confronta byte/word in memoria
- **SCASB/SCASW**: confronta AL/AX con memoria puntata da DI

### Esempio: copia di una stringa
```assembly
; Copia stringa da SOURCE a DEST
CLD              ; Direzione in avanti (incrementa SI e DI)
LEA SI, SOURCE   ; Carica indirizzo sorgente
LEA DI, DEST     ; Carica indirizzo destinazione
MOV CX, 10       ; Lunghezza della stringa
REP MOVSB        ; Ripeti MOVSB CX volte

; ... altrove nel codice ...
SOURCE DB 'Test String'
DEST   DB 10 DUP(0)
```

## Riferimenti Utili

- Manuale di riferimento EMU8086
- Intel 8086/8088 Instruction Set

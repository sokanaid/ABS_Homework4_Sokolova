%include "io64.inc"
section .data
    fmtstr  db      "%d -> %f",10,0
    fileIntVar  db  "testIn.txt",0  ; имя файла хранящего double  переменную
    toRead      db  "r"
    intFormat   db  "%f"

    fileDoubleVar   dq  "doublevar.txt",0  ; имя файла сохраняющего действительную переменную
    toWrite     db  "w"
    dobleOutFormat  db  "%f",10,0

section .bss
    d       resq    1
    intVar  resd    1       ; целочисленное прочитанное значение
    FILE    resq    1       ; Указатель на FILE
section .text
global CMAIN
CMAIN:
    push    rbp
    mov     rbp,rsp
        ; Чтение из файла целочисленной переменной
    mov     rdi, fileIntVar     ; имя открываемого файла
    lea     rsi, toRead         ; открыть для чтений
    mov     rax, 0              ; нет чисел с плавающей точкой
    call    fopen
    mov     [FILE], rax         ; сохранение указателя на файл

    mov     rdi, rax            ; пересылка дескриптора файла в 1-й аргумент
    mov     rsi, intFormat      ; формат для чтения переменной из файла
    mov     edx, intVar         ; запись адреса переменной в 3-й аргумент
    call    fscanf              ; вызов функции чтения из файла

    mov     rdi, [FILE]         ; передача указателя на закрываемый файл
    call    fclose

    ; Преобразование в число с плавающей точкой
    mov     eax, [intVar]
    cvtsi2sd    xmm0, eax
    movsd [d], xmm0

    mov     rdi, fmtstr ; first argument for printf
    mov     rsi, [intVar]    ; second argument for printf
    movsd   xmm0, [d]   ; third argument for printf
    mov     rax, 1      ; xmm registers involved
    call    printf      ; call the function

    ; Запись в файл действительной переменной и строки с преобразованием
    mov     rdi, fileDoubleVar  ; имя открываемого файла
    lea     rsi, toWrite        ; открыть для чтений
    call    fopen
    mov     [FILE], rax         ; сохранение указателя на файл

    mov     rdi, rax            ; пересылка дескриптора файла в 1-й аргумент
    mov     rsi, dobleOutFormat ; формат для записи переменной в файл
    movsd   xmm0, [d]           ; действительный аргумент передаваемый в файл
    mov     rax, 1              ; есть числа с плавающей точкой
    call    fprintf             ; вызов функции чтения из файла

    mov     rdi, [FILE]         ; пересылка дескриптора файла в 1-й аргумент
    mov     rsi, fmtstr         ; формат для записи пары значений
    mov     rdx, [intVar]       ; целочисленный аргумент, выводимый в файл
    movsd   xmm0, [d]           ; действительный аргумент передаваемый в файл
    mov     rax, 1              ; есть числа с плавающей точкой
    call    fprintf             ; вызов функции чтения из файла

    mov     rdi, [FILE]         ; передача указателя на закрываемый файл
    call    fclose

    pop     rbp
    mov     rax,60
    mov     rdi,0
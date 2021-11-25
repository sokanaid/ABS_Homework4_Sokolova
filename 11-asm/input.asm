; file.asm - использование файлов в NASM
extern printf
extern fscanf

extern TRAIN
extern SHIP
extern PLANE

;----------------------------------------------
; Ввод параметров поезда из файла
global InTrain
InTrain:
section .data
    .infmt db "%d%d%lg",0
section .bss
    .FILE   resq    1   ; временное хранение указателя на файл
    .prect  resq    1   ; адрес поезда
section .text
push rbp
mov rbp, rsp

    ; Сохранение принятых аргументов
    mov     [.prect], rdi          ; сохраняется адрес поезда
    mov     [.FILE], rsi          ; сохраняется указатель на файл

    ; Ввод поезда из файла
    mov     rdi, [.FILE]
    mov     rsi, .infmt         ; Формат - 1-й аргумент
    mov     rdx, [.prect]       ; &x - int numberOfRailwayCarriage 
    mov     rcx, [.prect]
    add     rcx, 4              ; &y = &x + 4 - int speed
    mov     r8, [.prect]     
    add     r8, 8               ;&z = &x + 4+4 - double distance
    mov     rax, 1
    call    fscanf   
leave
ret

; // Ввод параметров ship из файла
;void In(ship &s, ifstream &ifst) {
;    int type;
;    ifst >> double s.displacement >> int type >> int s.speed >> double s.distance;
;    s.type = (shipType)type;
;}
;
global InShip
InShip:
section .data
    .infmt db "%d%d%d%lg",0
    .outf db "Inship",0

section .bss
    .FILE   resq    1   ; временное хранение указателя на файл
    .trian  resq    1   ; адрес ship
section .text
push rbp
mov rbp, rsp

    ; Сохранение принятых аргументов
    mov     [.trian], rdi          ; сохраняется адрес ship
    mov     [.FILE], rsi          ; сохраняется указатель на файл

    ; Ввод корабля из файла
    mov     rdi, [.FILE]
    mov     rsi, .infmt         ; Формат - 1-й аргумент
    mov     rdx, [.trian]       ; &a int s.displacement
    mov     rcx, [.trian]
    add     rcx, 4              ; &b = &a + 4 int type
    mov     r8, [.trian]
    add     r8, 8               ; &c = &x + 4+4 int s.speed
    mov     r9, [.trian]
    add     r9, 12               ; &d = &x + 4+4+4 double s.distance
    mov     rax, 1              ; нет чисел с плавающей точкой
    call    fscanf
    ;mov rdi,.outf
;    call printf
leave
ret

global InPlane
InPlane:
section .data
    .infmt db "%d%d%d%lg",0
    .outf db "plane",0
section .bss
    .FILE   resq    1   ; временное хранение указателя на файл
    .plane  resq    1   ; адрес треугольника
section .text
push rbp
mov rbp, rsp

    ; Сохранение принятых аргументов
    mov     [.plane], rdi          ; сохраняется адрес треугольника
    mov     [.FILE], rsi          ; сохраняется указатель на файл

    ; Ввод корабля из файла
    mov     rdi, [.FILE]
    mov     rsi, .infmt         ; Формат - 1-й аргумент
    mov     rdx, [.plane]       ; &a int flightrange
    mov     rcx, [.plane]
    add     rcx, 4              ; &b = &a + 4 int liftingcompacity
    mov     r8, [.plane]
    add     r8, 8               ; &c = &x + 4+4 int s.speed
    mov     r9, [.plane]
    add     r9, 12               ; &d = &x + 4+4+4 double s.distance
    mov     rax, 1              ; нет чисел с плавающей точкой
    call    fscanf
    ;mov rdi,.outf
;    call printf

leave
ret
; // Ввод параметров обобщенной фигуры из файла
; int InTransport(void *s, FILE *ifst) {
;     int k;
;     fscanf(ifst, "%d", &k);
;     switch(k) {
;         case 1:
;             *((int*)s) = RECTANGLE;
;             InRectangle(s+intSize, ifst);
;             return 1;
;         case 2:
;             *((int*)s) = TRIANGLE;
;             InShip(s+intSize, ifst);
;             return 1;
;         default:
;             return 0;
;     }
; }
global InTransport
InTransport:
section .data
    .tagFormat   db      "%d",0
    .tagOutFmt   db     "Tag is: %d",10,0
section .bss
    .FILE       resq    1   ; временное хранение указателя на файл
    .ptransport     resq    1   ; адрес фигуры
    .transportTag   resd    1   ; признак фигуры
section .text
push rbp
mov rbp, rsp

    ; Сохранение принятых аргументов
    mov     [.ptransport], rdi          ; сохраняется адрес фигуры
    mov     [.FILE], rsi            ; сохраняется указатель на файл

    ; чтение признака фигуры и его обработка
    mov     rdi, [.FILE]
    mov     rsi, .tagFormat
    mov     rdx, [.ptransport]      ; адрес начала фигуры (ее признак)
    xor     rax, rax            ; нет чисел с плавающей точкой
    call    fscanf

    ;; Тестовый вывод признака фигуры
;     mov     rdi, .tagOutFmt
;     mov     rax, [.ptransport]
;     mov     esi, [rax]
;     call    printf

    mov rcx, [.ptransport]          ; загрузка адреса начала фигуры
    mov eax, [rcx]              ; и получение прочитанного признака
    cmp eax, [TRAIN]
    je .trainIn
    cmp eax, [SHIP]
    je .shipIn
    cmp eax, [PLANE]
    je .planeIn
    xor eax, eax    ; Некорректный признак - обнуление кода возврата
    jmp     .return
.trainIn:
    ; Ввод прямоугольника
    mov     rdi, [.ptransport]
    add     rdi, 4
    mov     rsi, [.FILE]
    call    InTrain
    mov     rax, 1  ; Код возврата - true
    jmp     .return
.shipIn:
    ; Ввод треугольника
    mov     rdi, [.ptransport]
    add     rdi, 4
    mov     rsi, [.FILE]
    call    InShip
    mov     rax, 1  ; Код возврата - true
    jmp     .return
.planeIn:
    mov     rdi, [.ptransport]
    add     rdi, 4
    mov     rsi, [.FILE]
    call    InPlane
    mov     rax, 1  ; Код возврата - true
    jmp     .return
.return:

leave
ret

; // Ввод содержимого контейнера из указанного файла
; void InContainer(void *c, int *len, FILE *ifst) {
;     void *tmp = c;
;     while(!feof(ifst)) {
;         if(InTransport(tmp, ifst)) {
;             tmp = tmp + shapeSize;
;             (*len)++;
;         }
;     }
; }
global InContainer
InContainer:
section .bss
    .pcont  resq    1   ; адрес контейнера
    .plen   resq    1   ; адрес для сохранения числа введенных элементов
    .FILE   resq    1   ; указатель на файл
section .text
push rbp
mov rbp, rsp

    mov [.pcont], rdi   ; сохраняется указатель на контейнер
    mov [.plen], rsi    ; сохраняется указатель на длину
    mov [.FILE], rdx    ; сохраняется указатель на файл
    ; В rdi адрес начала контейнера
    xor rbx, rbx        ; число фигур = 0
    mov rsi, rdx        ; перенос указателя на файл
.loop:
    ; сохранение рабочих регистров
    push rdi
    push rbx

    mov     rsi, [.FILE]
    mov     rax, 0      ; нет чисел с плавающей точкой
    call    InTransport     ; ввод фигуры
    cmp rax, 0          ; проверка успешности ввода
    jle  .return        ; выход, если признак меньше или равен 0

    pop rbx
    inc rbx

    pop rdi
    add rdi, 24             ; адрес следующей фигуры

    jmp .loop
.return:
    mov rax, [.plen]    ; перенос указателя на длину
    mov [rax], ebx      ; занесение длины
leave
ret


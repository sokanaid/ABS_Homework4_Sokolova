; file.asm - использование файлов в NASM
extern printf
extern rand


extern TRAIN
extern SHIP
extern PLANE


;----------------------------------------------
; // rnd.c - содержит генератор случайных чисел в диапазоне от 1 до 20
; int Random() {
;     return rand() % 20 + 1;
; }
global Random
Random:
section .data
    .i20     dq      20
    .rndNumFmt       db "Random number = %d",10,0
section .text
push rbp
mov rbp, rsp

    xor     rax, rax    ;
    call    rand        ; запуск генератора случайных чисел
    xor     rdx, rdx    ; обнуление перед делением
    idiv    qword[.i20]       ; (/%) -> остаток в rdx
    mov     rax, rdx
    inc     rax         ; должно сформироваться случайное число

    ;mov     rdi, .rndNumFmt
    ;mov     esi, eax
    ;xor     rax, rax
    ;call    printf


leave
ret

;inline auto RandomDistance() {
;    return rand() % 10000 + 1 + (double) rand() / RAND_MAX;
;}
global RandomDistance
RandomDistance:
section .data
    .i20     dq      10000
    .rndNumFmt       db "Random number = %lg",10,0
section .bss
    .prect  resq 1   ;случайно числа
section .text
push rbp
mov rbp, rsp

    xor     rax, rax    
    call    rand
    xor     rdx, rdx    ; обнуление перед делением
    idiv    qword[.i20]   
    mov     rax, rdx
    cvtsi2sd    xmm0 , rax
    mov rax, [.i20]
    cvtsi2sd    xmm1 , rax
    divsd    xmm0 , xmm1 ; дробная часть в xmm0
    movsd xmm2 , xmm0
     ;Вывод дробной части
     ;mov     rdi, .rndNumFmt
;     movsd  xmm0 , xmm2
;    mov     rax, 1
;    call    printf

    xor     rax, rax    ;
    call    rand        ; запуск генератора случайных чисел
    xor     rdx, rdx    ; обнуление перед делением
    idiv    qword[.i20]       ; (/%) -> остаток в rdx
    mov     rax, rdx
    inc     rax         ; должно сформироваться случайное число
    cvtsi2sd    xmm1, rax
    addsd   xmm2 , xmm1
    movsd xmm0 , xmm2
    

    ;mov     rdi, .rndNumFmt
;    mov     [rsi], xmm0
;    mov     rax, 1
;    call    printf


leave
ret

;inline auto RandomShipType() {
;    return rand() % 3 + 1;
;}
global RandomShipType
RandomShipType:
section .data
    .i20     dq      3
    .rndNumFmt       db "Random number = %d",10,0
section .text
push rbp
mov rbp, rsp

    xor     rax, rax    ;
    call    rand        ; запуск генератора случайных чисел
    xor     rdx, rdx    ; обнуление перед делением
    idiv    qword[.i20]       ; (/%) -> остаток в rdx
    mov     rax, rdx
    inc     rax         ; должно сформироваться случайное число

    ;mov     rdi, .rndNumFmt
    ;mov     esi, eax
    ;xor     rax, rax
    ;call    printf


leave
ret

;inline auto RandomSpeed() {
;    return rand() % 500 + 1;
;}
global RandomSpeed
RandomSpeed:
section .data
    .i20     dq      500
    .rndNumFmt       db "Random number = %d",10,0
section .text
push rbp
mov rbp, rsp

    xor     rax, rax    ;
    call    rand        ; запуск генератора случайных чисел
    xor     rdx, rdx    ; обнуление перед делением
    idiv    qword[.i20]       ; (/%) -> остаток в rdx
    mov     rax, rdx
    inc     rax         ; должно сформироваться случайное число

    ;mov     rdi, .rndNumFmt
    ;mov     esi, eax
    ;xor     rax, rax
    ;call    printf


leave
ret

;inline auto RandomDisplacement() {
;    return rand() % 50000 + 10;
;}

global RandomDisplacement
RandomDisplacement:
section .data
    .i20     dq      50000
    .rndNumFmt       db "Random number = %d",10,0
section .text
push rbp
mov rbp, rsp

    xor     rax, rax    ;
    call    rand        ; запуск генератора случайных чисел
    xor     rdx, rdx    ; обнуление перед делением
    idiv    qword[.i20]       ; (/%) -> остаток в rdx
    mov     rax, rdx
    add     rax,10         ; должно сформироваться случайное число

    ;mov     rdi, .rndNumFmt
    ;mov     esi, eax
    ;xor     rax, rax
    ;call    printf
leave
ret

;----------------------------------------------
;// Случайный ввод параметров поезда
;void InRnd(train &t) {
;    t.numberOfRailwayCarriage = Random();
;    t.speed = RandomSpeed();
;    t.distance = RandomDistance();
;}
global InRndTrain
InRndTrain:
section .data
    .outf  db "InRNDTRAIN, %d",10,0
section .bss
    .prect  resq 1   ; адрес поезда
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес поезда
    mov     [.prect], rdi
    ; Генерация параметров поезда
    call    Random
    mov     rbx, [.prect]
    mov     [rbx], eax
    call    RandomSpeed
    mov     rbx, [.prect]
    mov     [rbx+4], eax
    call    RandomDistance

    mov     rbx, [.prect]
    movsd  [rbx+8], xmm0
    
;    mov rdi, .outf
;    movsd xmm0 ,[rbx+8]
;    mov rax,1
;    call printf
    
leave
ret

;----------------------------------------------
;// Ввод параметров самолета из потока
;void In(plane &p, ifstream &ifst) {
;    ifst >> p.flightRange >> p.liftingCapacity >> p.speed >> p.distance;
;
;}
;
;// Случайный ввод параметров самолета
;void InRnd(plane &p) {
;    p.liftingCapacity = RandomDisplacement();
;    p.flightRange = RandomDisplacement();
;    p.speed = RandomSpeed();
;    p.distance = RandomDistance();
;}
global InRndPlane
InRndPlane:
section .bss
    .prect  resq 1   ; адрес ship
section .text
push rbp
mov rbp, rsp
    ; В rdi адрес поезда
    mov     [.prect], rdi
    ; Генерация параметров корабля
    call    RandomDisplacement
    mov     rbx, [.prect]
    mov     [rbx], eax
    call    RandomDisplacement
    mov     rbx, [.prect]
    mov     [rbx+4], eax
    call    RandomSpeed
    mov     rbx, [.prect]
    mov     [rbx+8], eax
    call    RandomDistance
    mov     rbx, [.prect]
    movsd  [rbx+12], xmm0
    
;    mov rdi, .outf
;    movsd xmm0 ,[rbx+8]
;    mov rax,1
;    call printf
leave
ret

;// Ввод параметров корабля из потока
;void In(ship &s, ifstream &ifst) {
;    int type;
;    ifst >> s.displacement >> type >> s.speed >> s.distance;
;    s.type = (shipType)type;
;}
;
;// Случайный ввод параметров корабля
;void InRnd(ship &s) {
;    s.displacement =RandomDisplacement();
;    s.type = (shipType)RandomShipType();
;    s.speed = RandomSpeed();
;    s.distance = RandomDistance();
;}
global InRndShip
InRndShip:
section .bss
    .prect  resq 1   ; адрес ship
section .text
push rbp
mov rbp, rsp
    ; В rdi адрес поезда
    mov     [.prect], rdi
    ; Генерация параметров корабля
    call    RandomDisplacement
    mov     rbx, [.prect]
    mov     [rbx], eax
    call    RandomShipType
    mov     rbx, [.prect]
    mov     [rbx+4], eax
    call    RandomSpeed
    mov     rbx, [.prect]
    mov     [rbx+8], eax
    call    RandomDistance
    mov     rbx, [.prect]
    movsd  [rbx+12], xmm0
    
;    mov rdi, .outf
;    movsd xmm0 ,[rbx+8]
;    mov rax,1
;    call printf
leave
ret

;----------------------------------------------
;// Случайный ввод обобщенной фигуры
;int InRndTransport(void *s) {
    ;int k = rand() % 2 + 1;
    ;switch(k) {
        ;case 1:
            ;*((int*)s) = RECTANGLE;
            ;InRndTrain(s+intSize);
            ;return 1;
        ;case 2:
            ;*((int*)s) = TRIANGLE;
            ;InRndShip(s+intSize);
            ;return 1;
        ;default:
            ;return 0;
    ;}
;}
global InRndTransport
InRndTransport:
section .data
    .rndNumFmt       db "Random number = %d",10,0
section .bss
    .pshape     resq    1   ; адрес фигуры
    .key        resd    1   ; ключ
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес фигуры
    mov [.pshape], rdi

    ; Формирование признака фигуры
    xor     rax, rax    ;
    call     RandomShipType       ; запуск генератора случайных чисел
    ;mov eax, 1;- генерируется только поезд
    ;mov     [.key], eax
    ;mov     rdi, .rndNumFmt
    ;mov     esi, [.key]
    ;xor     rax, rax
    ;call    printf
    ;mov     eax, [.key]

    mov     rdi, [.pshape]
    mov     [rdi], eax      ; запись ключа в фигуру
    cmp eax, [TRAIN]
    je .trainInrnd
    cmp eax, [SHIP]
    je .shipInRnd
    cmp eax, [PLANE]
    je .planeInRnd
    xor eax, eax        ; код возврата = 0
    jmp     .return
.trainInrnd:
    ; Генерация поезда
    add     rdi, 4
    call    InRndTrain
    mov     eax, 1      ;код возврата = 1
    jmp     .return
.shipInRnd:
    ; Генерация ship
    add     rdi, 4
    call    InRndShip
    mov     eax, 1      ;код возврата = 1
    jmp     .return
.planeInRnd:
    ; Генерация ship
    add     rdi, 4
    call    InRndPlane
    mov     eax, 1      ;код возврата = 1
    jmp     .return
.return:
leave
ret

;----------------------------------------------
;// Случайный ввод содержимого контейнера
;void InRndContainer(void *c, int *len, int size) {
    ;void *tmp = c;
    ;while(*len < size) {
        ;if(InRndTransport(tmp)) {
            ;tmp = tmp + shapeSize;
            ;(*len)++;
        ;}
    ;}
;}
global InRndContainer
InRndContainer:
section .bss
    .pcont  resq    1   ; адрес контейнера
    .plen   resq    1   ; адрес для сохранения числа введенных элементов
    .psize  resd    1   ; число порождаемых элементов
section .text
push rbp
mov rbp, rsp

    mov [.pcont], rdi   ; сохраняется указатель на контейнер
    mov [.plen], rsi    ; сохраняется указатель на длину
    mov [.psize], edx    ; сохраняется число порождаемых элементов
    ; В rdi адрес начала контейнера
    xor ebx, ebx        ; число фигур = 0
.loop:
    cmp ebx, edx
    jge     .return
    ; сохранение рабочих регистров
    push rdi
    push rbx
    push rdx

    call    InRndTransport     ; ввод фигуры
    cmp rax, 0          ; проверка успешности ввода
    jle  .return        ; выход, если признак меньше или равен 0

    pop rdx
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

; file.asm - использование файлов в NASM
extern printf
extern fprintf

extern IdealTimeTrain
extern IdealTimeShip
extern IdealTimePlane

extern TRAIN
extern SHIP
extern PLANE

;----------------------------------------------
;void Out(train &t, ofstream &ofst) {
;    ofst << "It is a train: number of railway carriage = "
;         << t.numberOfRailwayCarriage << ", speed = " << t.speed
;         << ", distance = " << t.distance
;         << ". Ideal time = " << IdealTime(t) << "\n";
;}
global OutTrain
OutTrain:
section .data
    .outfmt db "It is a train: number of railway carriage = %d, speed = %d, distance = %lg. Ideal time = %lg",10,0
section .bss
    .prect  resq  1
    .FILE   resq  1       ; временное хранение указателя на файл
    .p      resq  1       ; вычисленный периметр прямоугольника
section .text
push rbp
mov rbp, rsp

    ; Сохранени принятых аргументов
    mov     [.prect], rdi          ; сохраняется адрес поезда
    mov     [.FILE], rsi          ; сохраняется указатель на файл

    ; Вычисление идеального времени поезда (адрес уже в rdi)
    mov     rdi, [.prect]
    call    IdealTimeTrain
    movsd   [.p], xmm0          ; сохранение (может лишнее) идельного времени

    ; Вывод информации о поезде в консоль
;     mov     rdi, .outfmt        ; Формат - 1-й аргумент
;     mov     rax, [.prect]       ; адрес прямоугольника
;     mov     esi, [rax]          ; x
;     mov     edx, [rax+4]        ; y
;     movsd   xmm0, [.p]
;     mov     rax, 1              ; есть числа с плавающей точкой
;     call    printf

    ; Вывод информации о поезде в файл
    mov     rdi, [.FILE]
    mov     rsi, .outfmt        ; Формат - 2-й аргумент
    mov     rax, [.prect]        ; адрес поезда
    mov     edx, [rax]          ; x
    mov     ecx, [rax+4]        ; y
    movsd   xmm0, [rax+8]
    movsd   xmm1, [.p]
    mov     rax, 1              ; есть числа с плавающей точкой
    call    fprintf

leave
ret

;----------------------------------------------
; // Вывод параметров корабля в файл
;void Out(ship &s, ofstream &ofst) {
;    ofst << "It is a ship: displacement = "
;         << s.displacement << ", type = " << s.type << ", speed = " << s.speed
;         << ", distance = " << s.distance
;         << ". Ideal time = " << IdealTime(s) << "\n";
;}
global OutShip
OutShip:
section .data
    .outfmt db "It is a ship: type = %d, displacement =  %d, speed = %d, distance =  %lg. Ideal time = %lg",10,0
section .bss
    .ptrian  resq  1
    .FILE   resq  1       ; временное хранение указателя на файл
    .p      resq  1       ; вычисленный периметр треугольника
section .text
push rbp
mov rbp, rsp

    ; Сохранени принятых аргументов
    mov     [.ptrian], rdi        ; сохраняется адрес ship
    mov     [.FILE], rsi          ; сохраняется указатель на файл

    ; Вычисление периметра треугольника (адрес уже в rdi)
    call    IdealTimeShip
    movsd   [.p], xmm0          ; сохранение (может лишнее) периметра

    ; Вывод информации о треугольнике в консоль
;     mov     rdi, .outfmt        ; Формат - 1-й аргумент
;     mov     rax, [.ptrian]       ; адрес треугольника
;     mov     esi, [rax]          ; a
;     mov     edx, [rax+4]        ; b
;     mov     ecx, [rax+8]        ; c
;     movsd   xmm0, [.p]
;     mov     rax, 1              ; есть числа с плавающей точкой
;     call    printf

    ; Вывод информации о ship в файл
    mov     rdi, [.FILE]
    mov     rsi, .outfmt        ; Формат - 2-й аргумент
    mov     rax, [.ptrian]      ; адрес треугольника
    mov     rcx,[rax]          ; 0 int displacement
    mov     rdx, [rax+4]        ; +4 int type
    mov     r8, [rax+8]       ; +4+4 int speed
    movsd   xmm0, [rax+12]    ; +4+4+4 double distance
    movsd   xmm1, [.p]
    mov     rax, 1              ; есть числа с плавающей точкой
    call    fprintf

leave
ret

;// Вывод параметров самолета в поток
;void Out(plane &p, ofstream &ofst) {
;    ofst << "It is a plane: flight range = "
;         << p.flightRange << ", lifting capacity = " << p.liftingCapacity << ", speed = " << p.speed
;         << ", distance = " << p.distance
;         << ". Ideal time = " << IdealTime(p) << "\n";
;}
global OutPlane
OutPlane:
section .data
    .outfmt db "It is a plane: flight range =  %d, lifting capacity = %d, speed = %d, distance = %lg. Ideal time = %lg",10,0
section .bss
    .prect  resq  1
    .FILE   resq  1       ; временное хранение указателя на файл
    .p      resq  1       ; вычисленный периметр прямоугольника
section .text
push rbp
mov rbp, rsp

    ; Сохранени принятых аргументов
    mov     [.prect], rdi          ; сохраняется адрес поезда
    mov     [.FILE], rsi          ; сохраняется указатель на файл

    ; Вычисление идеального времени поезда (адрес уже в rdi)
    mov     rdi, [.prect]
    call    IdealTimePlane
    movsd   [.p], xmm0          ; сохранение (может лишнее) идельного времени

    ; Вывод информации о поезде в консоль
;     mov     rdi, .outfmt        ; Формат - 1-й аргумент
;     mov     rax, [.prect]       ; адрес прямоугольника
;     mov     esi, [rax]          ; x
;     mov     edx, [rax+4]        ; y
;     movsd   xmm0, [.p]
;     mov     rax, 1              ; есть числа с плавающей точкой
;     call    printf

    ; Вывод информации о поезде в файл
    mov     rdi, [.FILE]
    mov     rsi, .outfmt        ; Формат - 2-й аргумент
    mov     rax, [.prect]        ; адрес поезда
    mov     rdx, [rax]          ; x
    mov     rcx, [rax+4]        ; y
    mov     r8, [rax+8]
    movsd   xmm0, [rax+12]
    movsd   xmm1, [.p]
    mov     rax, 1              ; есть числа с плавающей точкой
    call    fprintf

leave
ret
;----------------------------------------------
; // Вывод параметров текущей фигуры в файл
; void OutShape(void *s, FILE *ofst) {
;     int k = *((int*)s);
;     if(k == RECTANGLE) {
;         OutRectangle(s+intSize, ofst);
;     }
;     else if(k == TRIANGLE) {
;         OutShip(s+intSize, ofst);
;     }
;     else {
;         fprintf(ofst, "Incorrect figure!\n");
;     }
; }
global OutShape
OutShape:
section .data
    .erShape db "Incorrect figure!",10,0
    .outf db "type transoirt  = %d",10,0
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес фигуры
    mov eax, [rdi]
    
;    mov rsi, [rdi]
;    mov rdi, .outf
;    mov rax , 0
;    call printf
;    mov [rdi], rsi
;    
    
    cmp eax, [TRAIN]
    je trainOut
    cmp eax, [SHIP]
    je shipOut
    cmp eax, [PLANE]
    je planeOut
    mov rdi, .erShape
    mov rax, 0
    call fprintf
    jmp     return
trainOut:
    ; Вывод train
    add     rdi, 4
    call    OutTrain
    jmp     return
shipOut:
    ; Вывод ship
    add     rdi, 4
    call    OutShip
    jmp     return
planeOut:
    add     rdi, 4
    call    OutPlane
    jmp     return
return:
leave
ret

;----------------------------------------------
; // Вывод содержимого контейнера в файл
; void OutContainer(void *c, int len, FILE *ofst) {
;     void *tmp = c;
;     fprintf(ofst, "Container contains %d elements.\n", len);
;     for(int i = 0; i < len; i++) {
;         fprintf(ofst, "%d: ", i);
;         OutShape(tmp, ofst);
;         tmp = tmp + shapeSize;
;     }
; }
global OutContainer
OutContainer:
section .data
    numFmt  db  "%d: ",0
section .bss
    .pcont  resq    1   ; адрес контейнера
    .len    resd    1   ; адрес для сохранения числа введенных элементов
    .FILE   resq    1   ; указатель на файл
section .text
push rbp
mov rbp, rsp

    mov [.pcont], rdi   ; сохраняется указатель на контейнер
    mov [.len],   esi     ; сохраняется число элементов
    mov [.FILE],  rdx    ; сохраняется указатель на файл

    ; В rdi адрес начала контейнера
    mov rbx, rsi            ; число фигур
    xor ecx, ecx            ; счетчик фигур = 0
    mov rsi, rdx            ; перенос указателя на файл
.loop:
    cmp ecx, ebx            ; проверка на окончание цикла
    jge .return             ; Перебрали все фигуры

    push rbx
    push rcx

    ; Вывод номера фигуры
    mov     rdi, [.FILE]    ; текущий указатель на файл
    mov     rsi, numFmt     ; формат для вывода фигуры
    mov     edx, ecx        ; индекс текущей фигуры
    xor     rax, rax,       ; только целочисленные регистры
    call fprintf

    ; Вывод текущей фигуры
    mov     rdi, [.pcont]
    mov     rsi, [.FILE]
    call OutShape     ; Получение периметра первой фигуры

    pop rcx
    pop rbx
    inc ecx                 ; индекс следующей фигуры

    mov     rax, [.pcont]
    add     rax, 24         ; адрес следующей фигуры
    mov     [.pcont], rax
    jmp .loop
.return:
leave
ret


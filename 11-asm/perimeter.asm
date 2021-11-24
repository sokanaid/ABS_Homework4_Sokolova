;------------------------------------------------------------------------------
; perimeter.asm - единица компиляции, вбирающая функции вычисления идеального времени и сортировки контейнера
;------------------------------------------------------------------------------
extern printf
extern TRAIN
extern SHIP
extern PLANE
extern OutShape
;----------------------------------------------
; Вычисление идеального времени поезда

global IdealTimeTrain
IdealTimeTrain:
section .bss
    d       resq    1

section .text
push rbp
mov rbp, rsp

    ; В rdi адрес поезда
    mov     eax, [rdi+4]
    cvtsi2sd    xmm0, eax
    movsd [d], xmm0
    movsd   xmm0,[rdi+8]
    movsd   xmm1, [d]
    divsd    xmm0, xmm1

leave
ret

;----------------------------------------------
; double IdealTimeShip(void *t) {
;    return (double)(*((int*)t)
;       + *((int*)(t+intSize))
;       + *((int*)(t+2*intSize)));
;}
global IdealTimeShip
IdealTimeShip:
section .bss
    .d       resq    1

section .text
push rbp
mov rbp, rsp

    ; В rdi адрес ship
    mov     eax, [rdi+8]
    cvtsi2sd    xmm0, eax
    movsd [.d], xmm0
    movsd   xmm0,[rdi+12]
    movsd   xmm1, [.d]
    divsd    xmm0, xmm1

leave
ret

global IdealTimePlane
IdealTimePlane:
section .bss
    .d       resq    1

section .text
push rbp
mov rbp, rsp

    ; В rdi адрес ship
    mov     eax, [rdi+8]
    cvtsi2sd    xmm0, eax
    movsd [.d], xmm0
    movsd   xmm0,[rdi+12]
    movsd   xmm1, [.d]
    divsd    xmm0, xmm1

leave
ret
;----------------------------------------------
; Вычисление периметра фигуры
;double PerimeterShape(void *s) {
;    int k = *((int*)s);
;    if(k == RECTANGLE) {
;        return PerimeterRectangle(s+intSize);
;    }
;    else if(k == TRIANGLE) {
;        return IdealTimeShip(s+intSize);
;    }
;    else {
;        return 0.0;
;    }
;}
global PerimeterShape
PerimeterShape:
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес фигуры
    mov eax, [rdi]
    cmp eax, [TRAIN]
    je idealTimeTrain
    cmp eax, [SHIP]
    je idealTimeship
    cmp eax, [PLANE]
    je idealTimePlane
    xor eax, eax
    cvtsi2sd    xmm0, eax
    jmp     return
idealTimeTrain:
    ; Вычисление идеального времени поезда
    add     rdi, 4
    call    IdealTimeTrain
    jmp     return
idealTimeship:
    ; Вычисление идеального времени корабля.
    add     rdi, 4
    call    IdealTimeShip
    jmp     return
idealTimePlane:
    ; Вычисление идеального времени корабля.
    add     rdi, 4
    call    IdealTimePlane
    jmp     return
return:
leave
ret

;----------------------------------------------
;// Сортировка Шелла
;string ShellSort(container &c) {
;    int first = 0, last = c.len;
;    for (auto d = (last - first) / 2; d != 0; d /= 2)
;        for (auto i = first + d; i != last; ++i)
;            for (auto j = i; j - first >= d && IdealTime(*c.cont[j]) < IdealTime(*c.cont[(j - d)]); j -= d) {
;                auto tmp = *c.cont[j];
;                *c.cont[j] = *c.cont[(j - d)];
;                *c.cont[(j - d)] = tmp;
;            }
;    return "Container was sorted.";
;}
global PerimeterSumContainer
PerimeterSumContainer:
section .data
    .sum    dq  0
    .outf db "first = %d,second = %d %d",10,0
    .outf1 db "d = %d",10,0
    .outf2 db "rdi1 = %d , rdi2 = %d",10,0
    .outf3 db "work",10,0
    .outf4 db "xmm0 = %lg %d, xmm1 = %lg",10,0
    .outf5 db "rdi = %d, rsi = %d",10,0
    .zero db 0
    .two db 24
    
    .outf6 db "rsi = %d, rdi = %d ", 10 , 0
section .bss
    .first resq 1
    .last resq 1
    .len resq 1
    .d resq 1
    .i resq 1
    .j resq 1
    .g resq 1
    .start resq 1 ; начало контейнера
    .idealtime1 resq 1;
    .idealtime2 resq 1;
    .adress1 resq 2;
    .adress2 resq 1;
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес начала контейнера
    mov [.start], rdi
    mov [.last], esi            ; число фигур
    mov esi, 0
    mov [.first] , esi
    
;    mov rdi, .outf
;    mov rsi,[.first]
;    mov rdx, [.last]
;    mov rax, 0
;    call printf
    mov rsi, [.last] ;d = (last - first) / 2
    sub rsi,[.first]
    sar rsi, 1
    mov [.d], rsi
    
;    mov rdi, .outf1
;    mov rsi, [.d]
;    mov rax,0
;    call printf
.firstloop: ;for (auto d = (last - first) / 2; d != 0; d /= 2)
    mov rsi, [.d] ;if(d == 0) break
    cmp rsi, 0
    je .return
    
    mov rsi, [.first] ;auto i = first + d
    add rsi, [.d]
    mov [.i], rsi
    
    mov rdi, .outf1
    mov rsi, [.i]
    mov rax,0
    call printf
    .secondloop: ;for (auto i = first + d; i != last; ++i)
        mov rsi, [.i] ; if(i == last) break;
        cmp rsi,[.last]
        je .continueFirstLoop
        
        mov rsi,[.i] ;j = i
        mov [.j], rsi
        
        ;mov rdi, .outf1
;        mov rsi, [.j]
;        mov rax,0
;        call printf
        .3loop: ;for (auto j = i; j - first >= d && IdealTime(*c.cont[j]) < IdealTime(*c.cont[(j - d)]); j -= d)
            mov rsi,[.j]     ;if(j - first < d) break
            sub rsi,[.first]
            
           mov rdi, .outf1
            mov rax,0
            call printf
            
            cmp rsi, [.d]
            jl .continue2loop
            
            mov rdi, [.start];*c.cont[j] in rdi
            mov rsi, [.j]
            imul rsi, 24
            add rdi, rsi
            mov [.adress1], rdi
          ;  mov [.start], rdi
;            mov rdi, .outf3
;            mov rax, 0
;            call printf
;                mov rax , rdi
;                mov rdi, .outf
;                mov rsi,[rax]
;                mov rdx, [rax+4]
;                mov rcx, [rax+8]
;                mov rax, 0
;                call printf
;                mov rdi, rax
            
            ;call OutShape             
            call PerimeterShape ;результат в xmm0
            
          ; mov [.start], rdi
;            mov rdi, .outf3
;            mov rax, 0
;            call printf
            
            movsd [.idealtime1], xmm0 ; IdealTime(*c.cont[j]) .idealtime1
            
            mov rdi, [.start];*c.cont[j-d] in rdi
            mov rsi, [.j]
            sub rsi, [.d]
            imul rsi, 24
            add rdi, rsi          
            ;mov r8, [rdi+4]   
            mov [.adress2], rdi
            call PerimeterShape ;результат в xmm0 IdealTime(*c.cont[(j - d)])
            

;            mov rdi, .outf4
;            mov rsi, r8
;            mov rax, 1
;            call printf
            movsd xmm1, xmm0
            movsd [.idealtime2], xmm0
            movsd xmm0, [.idealtime1]
;            
            mov rdi, .outf4
            mov rsi, r8
            mov rax, 1
            call printf
            
;            mov rdi, .outf3
;            mov rax, 0
;            call printf
            
            movsd xmm0, [.idealtime1]
            movsd xmm1, [.idealtime2]

            cld
            ;cmpsd
            ;comiss  xmm0 , xmm1 ;IdealTime(*c.cont[j])? IdealTime(*c.cont[(j - d)])
            UCOMISD xmm0,xmm1
            jnb .continue2loop ;if (IdealTime(*c.cont[j]) >= IdealTime(*c.cont[(j - d)])) break;

            ;comiss  xmm0 , xmm1 ;IdealTime(*c.cont[j])? IdealTime(*c.cont[(j - d)])
            ;je .continue2loop
            

            mov rdi, .outf3
            mov rax, 0
            call printf
            ;код обмена
             
            ;mov rax, [.adress1]
;            mov rdi, [rax]
;            mov rax, [.adress2]
;            mov rsi, [rax]
;            mov rsi, rdi
;            mov rdx, rsi
;            mov rdi, .outf6
;            mov rax, 0
;            call printf
            
;            mov rdi, [.adress1]
;            mov rsi, [.adress2]
            ;XCHG rdi, rsi
            mov rax , 0
            mov [.g] , rax
            .change:
                mov rax, [.g]
                cmp rax, 6
                je .endchange
                mov r8, [.g]
                imul r8, 4
                
                mov rax, [.adress1]
                add rax, r8
                mov ecx, [rax]
                
                mov rax, [.adress2]
                add rax, r8
                mov edx, [rax]
                
                mov rax, [.adress1]
                add rax, r8
                mov [rax],edx
                
                mov rax, [.adress2]
                add rax, r8
                mov [rax], ecx
                
                mov rax, [.g]; g++
                inc rax
                mov [.g], rax
                jmp .change
            
            
            ;код обмена
            .endchange:
            mov rsi, [.j];j -= d
            sub rsi, [.d];
            mov [.j], rsi
            jmp .3loop
        .continue2loop:
        mov rsi, [.i]; ++i
        inc rsi
        mov [.i],rsi
        jmp .secondloop
    .continueFirstLoop:
    mov rsi, [.d];d /= 2
    sar rsi, 1
    mov [.d], rsi
    jmp .firstloop
; СУММА ПЕРИМЕТРОВ:
;    xor ecx, ecx            ; счетчик фигур
;    movsd xmm1, [.sum]      ; перенос накопителя суммы в регистр 1
;.loop:
;    cmp ecx, ebx            ; проверка на окончание цикла
;    jge .return             ; Перебрали все фигуры
;
;    mov r10, rdi            ; сохранение начала фигуры
;    call PerimeterShape     ; Получение периметра первой фигуры
;    addsd xmm1, xmm0        ; накопление суммы
;    inc rcx                 ; индекс следующей фигуры
;    add r10, 24             ; адрес следующей фигуры
;    mov rdi, r10            ; восстановление для передачи параметра
;    jmp .loop
.return:
    movsd xmm0, xmm1
leave
ret

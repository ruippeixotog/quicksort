section .data                   ; // compile-time constants

  num_fmt db "%d", 0
  num_sp_fmt db "%d ", 0
  nl: db 0xA, 0

section .bss                    ; // variables

  n: resd 1                     ; int n;
  arr: resq 1                   ; int* arr;

  i: resd 1                     ; int i;

section .text                   ; // code

  global main
  extern malloc, printf, scanf
  default rel

  swap:                         ; void swap(int* it1, int* it2) {
    push rcx
    push rdx
    mov ecx, [rdi]              ;   int c = *it1;
    mov edx, [rsi]              ;   int d = *it2;
    mov [rdi], edx              ;   *it1 = d;
    mov [rsi], ecx              ;   *it2 = c;
    pop rdx
    pop rcx
    ret                         ; }

  quicksort:                    ; void quicksort(int* st, int* end) {
    mov r9, rdi
    mov r10, rsi
    mov rax, r9                 ;   int* _it = st;

    cmp r9, r10
    je .end_if                  ;   if(st != end) {
      mov rcx, r9               ;     int* _sep = st;
      mov ebx, [rdi]            ;     int _pivot = *st;

      .loop:
        add rax, 4
        
        cmp rax, r10
        je .end_loop            ;     while((++_it) != end) {

          cmp [rax], ebx
          jge .loop             ;       if(*_it >= _pivot) continue;

          add rcx, 4
          mov rdi, rcx
          mov rsi, rax
          call swap             ;       swap(++_sep, _it);
          jmp .loop             ;     }

      .end_loop:
      mov rdi, r9
      mov rsi, rcx
      call swap                 ;     swap(st, _sep);

      push r10
      push rcx
      mov rdi, r9
      mov rsi, rcx
      call quicksort            ;     quicksort(st, _sep);

      pop rdi
      add rdi, 4
      pop rsi
      call quicksort            ;     quicksort(++_sep, end);

    .end_if:                    ;   }
    ret                         ; }

  read_arr:                     ; void read_arr() {
    mov ecx, [n]
    mov [i], ecx                ;   int i = n;
    mov rbx, [arr]              ;   int* _arr = arr;

    .loop:
      sub dword [i], 1
      js .end_loop              ;   while((--i) >= 0) {

      lea rdi, [num_fmt]
      mov rsi, rbx
      xor al, al
      call scanf WRT ..plt      ;     scanf("%d", _arr);

      add rbx, 4                ;     _arr++;
      jmp .loop                 ;   }

    .end_loop:
    ret                         ; }

  write_arr:                    ; void write_arr() {
    mov ecx, [n]
    mov [i], ecx                ;   int i = n;
    mov rbx, [arr]              ;   int* _arr = arr;

    .loop:
      sub dword [i], 1
      js .end_loop              ;   while((--i) >= 0) {

      jnz .else
        lea rdi, [num_fmt]
        jmp .end_if
      .else:
        lea rdi, [num_sp_fmt]
      .end_if:

      mov esi, [rbx]
      xor al, al
      call printf WRT ..plt     ;     printf(i ? "%d " : "%d", *_arr);

      add rbx, 4                ;     _arr++;
      jmp .loop                 ;   }

    .end_loop:
    lea rdi, [nl]
    xor al, al
    call printf WRT ..plt       ;   printf("\n");
    ret                         ; }

  main:                         ; void main() {
    lea rdi, [num_fmt]
    lea rsi, [n]
    xor al, al
    call scanf WRT ..plt        ;   scanf("%d", &n);

    mov edi, [n]
    imul edi, 4
    call malloc WRT ..plt
    mov [arr], rax              ;   arr = malloc(4 * n);

    call read_arr               ;   read_arr();

    mov rdi, [arr]
    xor rsi, rsi
    mov esi, [n]
    imul rsi, 4
    add rsi, rdi
    call quicksort              ;   quicksort(arr, arr + n);

    call write_arr              ;   write_arr();
    ret                         ; }

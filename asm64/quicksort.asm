section .data                   ; // compile-time constants

  num_fmt db "%lld", 0
  num_sp_fmt db "%lld ", 0
  nl: db 0xA, 0

section .bss                    ; // variables

                                ; typedef long long ll;
  n: resq 1                     ; ll n;
  arr: resq 1                   ; ll* arr;

  i: resq 1                     ; ll i;

section .text                   ; // code

  global main
  extern malloc, printf, scanf
  default rel

  swap:                         ; void swap(ll* it1, ll* it2) {
    push rcx
    push rdx
    mov rcx, [rdi]              ;   ll c = *it1;
    mov rdx, [rsi]              ;   ll d = *it2;
    mov [rdi], rdx              ;   *it1 = d;
    mov [rsi], rcx              ;   *it2 = c;
    pop rdx
    pop rcx
    ret                         ; }

  quicksort:                    ; void quicksort(ll* st, ll* end) {
    mov r9, rdi
    mov r10, rsi
    mov rax, r9                 ;   ll* _it = st;

    cmp r9, r10
    je .end_if                  ;   if(st != end) {
      mov rcx, r9               ;     ll* _sep = st;
      mov rbx, [rdi]            ;     ll _pivot = *st;

      .loop:
        add rax, 8
        
        cmp rax, r10
        je .end_loop            ;     while((++_it) != end) {

          cmp [rax], rbx
          jge .loop             ;       if(*_it >= _pivot) continue;

          add rcx, 8
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
      add rdi, 8
      pop rsi
      call quicksort            ;     quicksort(++_sep, end);

    .end_if:                    ;   }
    ret                         ; }

  read_arr:                     ; void read_arr() {
    mov rcx, [n]
    mov [i], rcx                ;   int i = n;
    mov rbx, [arr]              ;   int* _arr = arr;

    .loop:
      sub qword [i], 1
      js .end_loop              ;   while((--i) >= 0) {

      lea rdi, [num_fmt]
      mov rsi, rbx
      xor rax, rax
      call scanf WRT ..plt      ;     scanf("%d", _arr);

      add rbx, 8                ;     _arr++;
      jmp .loop                 ;   }

    .end_loop:
    ret                         ; }

  write_arr:                    ; void write_arr() {
    mov rcx, [n]
    mov [i], rcx                ;   int i = n;
    mov rbx, [arr]              ;   int* _arr = arr;

    .loop:
      sub qword [i], 1
      js .end_loop              ;   while((--i) >= 0) {

      mov rsi, [rbx]

      jnz .else
        lea rdi, [num_fmt]
        jmp .end_if
      .else:
        lea rdi, [num_sp_fmt]
      .end_if:

      xor rax, rax
      call printf WRT ..plt     ;     printf(i ? "%d " : "%d", *_arr);

      add rbx, 8                ;     _arr++;
      jmp .loop                 ;   }

    .end_loop:
    lea rdi, [nl]
    xor rax, rax
    call printf WRT ..plt       ;   printf("\n");
    ret                         ; }

  main:                         ; void main() {
    lea rdi, [num_fmt]
    lea rsi, [n]
    xor rax, rax
    call scanf WRT ..plt        ;   scanf("%d", &n);

    mov rdi, [n]
    imul rdi, 8
    call malloc WRT ..plt
    mov [arr], rax              ;   arr = malloc(8 * n);

    call read_arr               ;   read_arr();

    mov rdi, [arr]
    mov rsi, [n]
    imul rsi, 8
    add rsi, rdi
    call quicksort              ;   quicksort(arr, arr + n);

    call write_arr              ;   write_arr();
    ret                         ; }

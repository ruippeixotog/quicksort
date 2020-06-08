%define MAXN 10                 ; #define MAXN 10

section .data                   ; // compile-time constants

  num_fmt db "%lld", 0
  num_sp_fmt db "%lld ", 0
  nl: db 0xA, 0

section .bss                    ; // variables

  n: resq 1                     ; long long n;
  arr: resq MAXN                ; long long arr[MAXN];

  i: resq 1                     ; long long i;

section .text                   ; // code

  global main
  extern printf, scanf
  default rel

  swap:                         ; void swap(int i, int j) {
    push rcx
    push rdx
    lea r8, [arr]
    mov rcx, [r8+8*rdi]         ;   int c = arr[i];
    mov rdx, [r8+8*rsi]         ;   int d = arr[j];
    mov [r8+8*rdi], rdx         ;   arr[i] = d;
    mov [r8+8*rsi], rcx         ;   arr[j] = c;
    pop rdx
    pop rcx
    ret                         ; }

  quicksort:                    ; void quicksort(int st, int end) {
    mov r9, rdi
    mov r10, rsi
    mov rax, r9                 ;   int _i = st;

    cmp r9, r10
    je .end_if                  ;   if(st != end) {
      mov rcx, r9               ;     int _sep = st;
      lea r8, [arr]
      mov rbx, [r8+8*rdi]       ;     int _pivot = arr[st];

      .loop:
        add rax, 1
        
        cmp rax, r10
        je .end_loop            ;     while((++_i) != end) {

          lea r8, [arr]
          cmp [r8+8*rax], rbx
          jge .loop             ;       if(arr[_i] >= _pivot) continue;

          add rcx, 1
          mov rdi, rcx
          mov rsi, rax
          call swap             ;       swap(++_sep, _i);
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
      add rdi, 1
      pop rsi
      call quicksort            ;     quicksort(++_sep, end);

    .end_if:                    ;   }
    ret                         ; }

  read_arr:                     ; void read_arr() {
    mov rcx, [n]
    mov [i], rcx                ;   int i = n;
    lea rbx, [arr]              ;   int* _arr = arr;

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
    lea rbx, [arr]              ;   int* _arr = arr;

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

    call read_arr               ;   read_arr();

    xor rdi, rdi
    mov rsi, [n]
    call quicksort              ;   quicksort(0, n);

    call write_arr              ;   write_arr();
    ret                         ; }

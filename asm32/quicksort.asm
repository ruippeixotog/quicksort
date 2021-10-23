%define MAXN 10                 ; #define MAXN 10

section .data                   ; // compile-time constants

  num_fmt db "%d", 0
  num_sp_fmt db "%d ", 0
  nl: db 0xA, 0

section .bss                    ; // variables

  n: resd 1                     ; int n;
  arr: resd MAXN                ; int arr[MAXN];

  i: resd 1                     ; int i;

section .text                   ; // code

  global main
  extern printf, scanf

  swap:                         ; void swap(int* it1, int* it2) {
    pusha
    mov eax, [esp+32+4]
    mov ebx, [esp+32+8]
    mov ecx, [eax]              ;   int c = *it1;
    mov edx, [ebx]              ;   int d = *it2;
    mov [eax], edx              ;   *it1 = d;
    mov [ebx], ecx              ;   *it2 = c;
    popa
    ret                         ; }

  quicksort:                    ; void quicksort(int* st, int* end) {
    mov eax, [esp+4]            ;   int* _it = st;
    mov edx, [esp+8]
    cmp eax, edx
    je .end_if                  ;   if(st != end) {
      mov ecx, eax              ;     int* _sep = st;
      mov ebx, [eax]            ;     int _pivot = *st;

      .loop:
        add eax, 4

        cmp eax, edx
        je .end_loop            ;     while((++_it) != end) {

          cmp [eax], ebx
          jge .loop             ;       if(*_it >= _pivot) continue;

          add ecx, 4
          push eax
          push ecx
          call swap
          add esp, 8            ;       swap(++_sep, _it);
    
          jmp .loop             ;     }
         
      .end_loop:
      push ecx
      push dword [esp+8]
      call swap
      add esp, 8                ;     swap(st, _sep);

      push ecx
      push dword [esp+8]
      call quicksort
      add esp, 4
      pop ecx                   ;     quicksort(st, _sep);

      push dword [esp+8]
      add ecx, 4
      push ecx
      call quicksort
      add esp, 8                ;     quicksort(++_sep, end);

    .end_if:                    ;   }
    ret                         ; }

  read_arr:                     ; void read_arr() {
    mov ecx, [n]
    mov [i], ecx                ;   int i = n;
    mov ebx, arr                ;   int* _arr = arr;

    .loop:
      sub dword [i], 1
      js .end_loop              ;   while((--i) >= 0) {

      push ebx
      push num_fmt
      call scanf
      add esp, 8                ;     scanf("%d", _arr);

      add ebx, 4                ;     _arr++;
      jmp .loop                 ;   }

    .end_loop:
    ret                         ; }

  write_arr:                    ; void write_arr() {
    mov ecx, [n]
    mov [i], ecx                ;   int i = n;
    mov ebx, arr                ;   int* _arr = arr;

    .loop:
      sub dword [i], 1
      js .end_loop              ;   while((--i) >= 0) {

      push dword [ebx]

      jnz .else
        push num_fmt
        jmp .end_if
      .else:
        push num_sp_fmt
      .end_if:

      call printf
      add esp, 8                ;     printf(i ? "%d " : "%d", *_arr);

      add ebx, 4                ;     _arr++;
      jmp .loop                 ;   }

    .end_loop:
    push nl
    call printf
    add esp, 4                  ;   printf("\n");
    ret                         ; }

  main:                         ; void main() {
    push n
    push num_fmt
    call scanf
    add esp, 8                  ;   scanf("%d", &n);

    call read_arr               ;   read_arr();

    mov eax, [n]
    imul eax, 4
    add eax, arr
    push eax
    push arr
    call quicksort
    add esp, 8                  ;   quicksort(arr, arr + n);

    call write_arr              ;   write_arr();
    ret                         ; }

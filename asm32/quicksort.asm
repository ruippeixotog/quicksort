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

  swap:                         ; void swap(int i, int j) {
    pusha
    mov eax, [esp+32+4]
    mov ebx, [esp+32+8]
    mov ecx, [arr+4*eax]        ;   int c = arr[i];
    mov edx, [arr+4*ebx]        ;   int d = arr[j];
    mov [arr+4*eax], edx        ;   arr[i] = d;
    mov [arr+4*ebx], ecx        ;   arr[j] = c;
    popa
    ret                         ; }

  quicksort:                    ; void quicksort(int st, int end) {
    mov eax, [esp+4]            ;   int _i = st;
    mov edx, [esp+8]
    cmp eax, edx
    je .end_if                  ;   if(st != end) {
      mov ecx, eax              ;     int _sep = st;
      mov ebx, [arr+4*eax]      ;     int _pivot = arr[st];

      .loop:
        add eax, 1

        cmp eax, edx
        je .end_loop            ;     while((++_i) != end) {

          cmp [arr+4*eax], ebx  ;
          jge .loop             ;       if(arr[_i] >= _pivot) continue;

          add ecx, 1
          push eax
          push ecx
          call swap
          add esp, 8            ;       swap(++_sep, _i);
    
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
      add ecx, 1
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

    push dword [n]
    push 0
    call quicksort
    add esp, 8                  ;   quicksort(0, n);

    call write_arr              ;   write_arr();
    ret                         ; }

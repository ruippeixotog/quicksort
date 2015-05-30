#include <stdio.h>
#include <stdlib.h>

void swap(int* arr, int i, int j) {
  int tmp = arr[i]; arr[i] = arr[j]; arr[j] = tmp;
}

void quicksort(int* arr, int st, int end) {
  if(st == end) return;

  int i, sep = st;
  for(i = st + 1; i < end; i++) {
    if(arr[i] < arr[st]) swap(arr, ++sep, i);
  }

  swap(arr, st, sep);
  quicksort(arr, st, sep);
  quicksort(arr, sep + 1, end);
}

int main() {
  int n; scanf("%d", &n);
  int* arr = malloc(n * sizeof(int));

  int i;
  for(i = 0; i < n; i++)
    scanf("%d", &arr[i]);

  quicksort(arr, 0, n);

  for(i = 0; i < n; i++)
    printf(i == 0 ? "%d" : " %d", arr[i]);
  printf("\n");

  free(arr);
  return 0;
}

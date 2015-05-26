import java.util.Scanner;

public class Quicksort {
  private static Scanner sc = new Scanner(System.in);

  private static void swap(int[] arr, int i, int j) {
    int tmp = arr[i]; arr[i] = arr[j]; arr[j] = tmp;
  }

  private static void quicksort(int[] arr, int st, int end) {
    if(st == end) return;

    int sep = st;
    for(int i = st + 1; i < end; i++) {
      if(arr[i] < arr[st]) {
        swap(arr, ++sep, i);
      }
    }

    swap(arr, st, sep);
    quicksort(arr, st, sep);
    quicksort(arr, sep + 1, end);
  }

  public static void quicksort(int[] arr) {
    quicksort(arr, 0, arr.length);
  }

  public static void main(String[] args) {
    int n = sc.nextInt();
    int[] arr = new int[n];

    for(int i = 0; i < n; i++) {
      arr[i] = sc.nextInt();
    }

    quicksort(arr);

    for(int i = 0; i < n; i++) {
      System.out.print((i == 0 ? "" : " ") + arr[i]);
    }
    System.out.println();
  }
}

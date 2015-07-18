package main

import "fmt"

func quicksort(arr []int) {
	if len(arr) > 1 {
		sep := 0
		for i := 1; i < len(arr); i++ {
			if arr[i] < arr[0] {
				sep++
				arr[i], arr[sep] = arr[sep], arr[i]
			}
		}

		arr[0], arr[sep] = arr[sep], arr[0]
		quicksort(arr[:sep])
		quicksort(arr[sep+1:])
	}
}

func main() {
	var n int
	fmt.Scanf("%d", &n)

	var arr = make([]int, n)
	for i := 0; i < n; i++ {
		fmt.Scanf("%d", &arr[i])
	}

	quicksort(arr)

	for i := 0; i < n; i++ {
		if i > 0 {
			fmt.Printf(" ")
		}
		fmt.Printf("%d", arr[i])
	}
	fmt.Println()
}

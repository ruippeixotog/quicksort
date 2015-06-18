def quicksort(List<Integer> list, int st = 0, int end = list.size) {
  if(st != end) {
    def sep = st

    for(i = st + 1; i < end; i++) {
      if(list[i] < list[st])
        list.swap(++sep, i)
    }

    list.swap(st, sep)
    quicksort(list, st, sep)
    quicksort(list, sep + 1, end)
  }
}

sc = new Scanner(System.in)
n = sc.nextInt()
list = (1..n).collect { sc.nextInt() }

quicksort(list)
println list.join(' ')

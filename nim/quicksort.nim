import sequtils, strutils

proc quicksort(arr: var openArray[int], st: int, en: int): void =
  if st == en: return

  var sep = st
  for i in countup(st + 1, en - 1):
    if arr[i] < arr[st]:
      sep += 1
      swap(arr[sep], arr[i])

  swap(arr[st], arr[sep])
  quicksort(arr, st, sep)
  quicksort(arr, sep + 1, en)

discard readLine(stdin)
var arr = map(split(readLine(stdin), " "), parseInt)
quicksort(arr, 0, arr.len)
echo join(arr, " ")

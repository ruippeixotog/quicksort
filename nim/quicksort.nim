import sequtils, strutils

proc quicksort(arr: var openArray[int], st: int, en: int) =
  if st == en: return

  var sep = st
  for i in countup(st + 1, en - 1):
    if arr[i] < arr[st]:
      inc(sep)
      swap(arr[sep], arr[i])

  swap(arr[st], arr[sep])
  quicksort(arr, st, sep)
  quicksort(arr, sep + 1, en)

discard stdin.readLine
var arr = stdin.readLine.split(" ").map(parseInt)
quicksort(arr, 0, arr.len)
echo arr.join(" ")

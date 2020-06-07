func quicksort(arr: inout ArraySlice<Int>) {
  if arr.isEmpty { return }

  var sep = arr.startIndex
  for i in arr.indices.dropFirst() {
    if arr[i] < arr.first! {
      sep += 1
      arr.swapAt(sep, i)
    }
  }

  if sep != arr.startIndex {
    arr.swapAt(arr.startIndex, sep)
  }
  quicksort(arr: &arr[arr.startIndex..<sep])
  quicksort(arr: &arr[(sep + 1)..<arr.endIndex])
}

_ = readLine(strippingNewline: true)!
var arr = readLine(strippingNewline: true)!.split { $0 == " " }.map { Int($0)! }

quicksort(arr: &arr[0..<arr.count])
print(arr.map(String.init).joined(separator: " "))

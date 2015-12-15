import Foundation

func quicksort(inout arr: ArraySlice<Int>) {
  if arr.isEmpty { return }

  var sep = arr.startIndex
  for i in arr.indices.dropFirst() {
    if arr[i] < arr.first && ++sep != i {
      swap(&arr[sep], &arr[i])
    }
  }

  if sep != arr.startIndex {
    swap(&arr[arr.startIndex], &arr[sep])
  }
  quicksort(&arr[arr.startIndex..<sep])
  quicksort(&arr[(sep + 1)..<arr.endIndex])
}

let stdin = NSFileHandle.fileHandleWithStandardInput()
let arrStr = NSString(data: stdin.availableData,
                      encoding: NSUTF8StringEncoding)! as String

var arr = arrStr.characters.split { $0 == " " || $0 == "\n" }
  .dropFirst().map { Int(String($0))! }
  
quicksort(&arr[0..<arr.count])
print(arr.map(String.init).joinWithSeparator(" "))

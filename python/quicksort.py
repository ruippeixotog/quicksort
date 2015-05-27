import sys

def quicksort(arr):
  if not arr:
    return []
  else:
    pivot = arr[0]
    lower = [x for x in arr[1:] if x < pivot]
    upper = [x for x in arr[1:] if x >= pivot]
    return quicksort(lower) + [pivot] + quicksort(upper)

lines = sys.stdin.readlines()
arr = [int(x) for x in lines[1].split(' ')]
sorted = quicksort(arr)

print ' '.join(str(x) for x in sorted)

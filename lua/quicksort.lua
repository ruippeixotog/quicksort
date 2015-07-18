function quicksort(arr, st, en)
  if(st > en) then return end

  local sep = st
  for i = st + 1, en, 1 do
    if arr[i] < arr[st] then
      sep = sep + 1
      arr[i], arr[sep] = arr[sep], arr[i]
    end
  end

  arr[st], arr[sep] = arr[sep], arr[st]
  quicksort(arr, st, sep - 1)
  quicksort(arr, sep + 1, en)
end

local n = io.read("*n")
local arr = {}
for i = 1, n, 1 do arr[i] = io.read("*n") end

quicksort(arr, 1, n)
print(table.concat(arr, " "))

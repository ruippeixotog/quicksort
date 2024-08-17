function quicksort(arr)
  if length(arr) == 0
    return []
  end
  pivot = pop!(arr)
  return vcat(quicksort(arr[arr .< pivot]), pivot, quicksort(arr[arr .>= pivot]))
end

readline()
arr = collect(parse.(Int, eachsplit(readline(), " ")))
sorted = quicksort(arr)
println(join(sorted, " "))

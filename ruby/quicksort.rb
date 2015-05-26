#!/usr/bin/env ruby

def quicksort(arr)
  if arr.empty? then arr
  else
    pivot = arr[0]
    lower, upper = arr[1..-1].partition { |x| x < pivot }
    [quicksort(lower), pivot, quicksort(upper)].flatten
  end
end

_ = gets
arr = gets.split(' ').map(&:to_i)
sorted = quicksort(arr)
puts sorted.join(' ')

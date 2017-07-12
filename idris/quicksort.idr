quicksort : List Int -> List Int
quicksort [] = []
quicksort (pivot :: xs) with (partition (< pivot) xs)
  | (lower, upper) = quicksort lower ++ [pivot] ++ quicksort upper

main : IO ()
main = do n <- getLine
          arr <- getLine
          let sorted = quicksort (map cast (words arr))
          putStrLn (unwords (map show sorted))

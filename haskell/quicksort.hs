import Data.List

quicksort :: [Int] -> [Int]
quicksort [] = []
quicksort (pivot : xs) =
  let (lower, upper) = partition (< pivot) xs
  in quicksort lower ++ [pivot] ++ quicksort upper

main = do n <- getLine
          arr <- getLine
          let sorted = quicksort (map read (words arr))
          putStrLn (unwords (map show sorted))

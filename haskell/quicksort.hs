import Data.List

quicksort :: [Int] -> [Int]
quicksort [] = []
quicksort (pivot : xs) =
  let (lower, upper) = partition (< pivot) xs
  in quicksort lower ++ [pivot] ++ quicksort upper

readIntList :: String -> [Int]
readIntList = (map read) . words

showIntList :: [Int] -> String
showIntList = (intercalate " ") . (map show)

main = do n <- getLine
          arr <- getLine
          let sorted = quicksort $ readIntList arr
          putStrLn $ showIntList sorted

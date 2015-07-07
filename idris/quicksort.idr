import Data.List

quicksort : List Int -> List Int
quicksort [] = []
quicksort (pivot :: xs) with (partition (< pivot) xs)
  | (lower, upper) = quicksort lower ++ [pivot] ++ quicksort upper

readIntList : String -> List Int
readIntList = (map cast) . words

showIntList : List Int -> String
showIntList = pack . (intercalate [' ']) . (map (unpack . show))

main : IO ()
main = do n <- getLine
          arr <- getLine
          let sorted = quicksort $ readIntList arr
          putStrLn $ showIntList sorted

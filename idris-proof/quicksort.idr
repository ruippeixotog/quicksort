import Data.Vect
import Data.Vect.Quantifiers

data Partition : Nat -> elem -> Type where
  MkPart : Vect p elem -> Vect q elem -> Partition (p + q) elem

partitionP : (elem -> Bool) -> Vect len elem -> Partition len elem
partitionP pred [] = MkPart [] []
partitionP pred (x :: xs) =
  case (pred x, partitionP pred xs) of
    (True, MkPart inPred notPred) => MkPart (x :: inPred) notPred
    (False, MkPart {p} {q} inPred notPred) =>
      rewrite plusSuccRightSucc p q in (MkPart inPred (x :: notPred))

quicksort : Vect n Int -> Vect n Int
quicksort [] = []
quicksort (pivot :: xs) with (partitionP (< pivot) xs)
  | MkPart {p} {q} lower upper =
      rewrite plusSuccRightSucc p q in
        quicksort lower ++ [pivot] ++ quicksort upper

readIntVect : String -> (n ** Vect n Int)
readIntVect str = (_ ** fromList (map cast (words str)))

showIntVect : Vect n Int -> String
showIntVect = unwords . toList . (map show)

main : IO ()
main = do n <- getLine
          arrStr <- getLine
          let (_ ** arr) = readIntVect arrStr
          let sorted = quicksort arr
          putStrLn (showIntVect sorted)

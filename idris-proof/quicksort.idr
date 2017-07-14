import Data.Vect
import Data.Vect.Quantifiers

%default total

data Partition : Nat -> a -> Type where
  MkPart : Vect p a -> Vect q a -> Partition (p + q) a

partitionP : (a -> Bool) -> Vect len a -> Partition len a
partitionP pred [] = MkPart [] []
partitionP pred (x :: xs) =
  case (pred x, partitionP pred xs) of
    (True, MkPart inPred notPred) => MkPart (x :: inPred) notPred
    (False, MkPart {p} {q} inPred notPred) =>
      rewrite plusSuccRightSucc p q in (MkPart inPred (x :: notPred))

quicksort : Vect n Int -> Vect n Int
quicksort [] = []
quicksort (pivot :: xs) = case partitionP (< pivot) xs of
  MkPart {p} {q} lower upper =>
    rewrite plusSuccRightSucc p q in
      quicksort (assert_smaller (pivot :: xs) lower) ++ pivot ::
      quicksort (assert_smaller (pivot :: xs) upper)

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

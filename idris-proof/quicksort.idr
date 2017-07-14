import Data.Vect
import Data.Vect.Quantifiers

%default total

data Partition : Nat -> Nat -> Type where
  MkPart : Vect p Nat -> Vect q Nat -> Partition (p + q) pivot

partitionP : (pivot : Nat) -> Vect len Nat -> Partition len pivot
partitionP _ [] = MkPart [] []
partitionP pivot (x :: xs) =
  case (x < pivot, partitionP pivot xs) of
    (True, MkPart lts gtes) => MkPart (x :: lts) gtes
    (False, MkPart {p} {q} lts gtes) =>
      rewrite plusSuccRightSucc p q in (MkPart lts (x :: gtes))

---

quicksort : Vect n Nat -> Vect n Nat
quicksort [] = []
quicksort (pivot :: xs) = case partitionP pivot xs of
  MkPart {p} {q} lower upper =>
    rewrite plusSuccRightSucc p q in
      quicksort (assert_smaller (pivot :: xs) lower) ++ pivot ::
      quicksort (assert_smaller (pivot :: xs) upper)

readIntVect : String -> (n ** Vect n Nat)
readIntVect str = (_ ** fromList (map cast (words str)))

showIntVect : Vect n Nat -> String
showIntVect = unwords . toList . (map show)

main : IO ()
main = do n <- getLine
          arrStr <- getLine
          let (_ ** arr) = readIntVect arrStr
          let sorted = quicksort arr
          putStrLn (showIntVect sorted)

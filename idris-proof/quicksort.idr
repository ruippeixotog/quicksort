import Data.Vect
import Data.Vect.Quantifiers

%default total

data CmpNatP : Nat -> Nat -> Type where
  CmpLTP : {auto prf : LT a b} -> CmpNatP a b
  CmpEQP : {auto prf : a = b} -> CmpNatP a b
  CmpGTP : {auto prf : GT a b} -> CmpNatP a b

cmpP : (a : Nat) -> (b : Nat) -> CmpNatP a b
cmpP Z Z = CmpEQP
cmpP Z (S k) = CmpLTP
cmpP (S k) Z = CmpGTP
cmpP (S k) (S j) = case cmpP k j of
  CmpLTP => CmpLTP
  CmpEQP {prf} => CmpEQP {prf = cong prf}
  CmpGTP => CmpGTP

---

data Partition : Nat -> Nat -> Type where
  MkPart : (lts : Vect p Nat) -> (gtes : Vect q Nat) ->
           {auto ltPrfs : All (\a => LT a pivot) lts} -> {auto gtePrfs : All (\a => GTE a pivot) gtes} ->
           Partition (p + q) pivot

partitionP : (pivot : Nat) -> Vect len Nat -> Partition len pivot
partitionP _ [] = MkPart [] []
partitionP pivot (x :: xs) =
  case (cmpP x pivot, partitionP pivot xs) of
    (CmpLTP, MkPart lts gtes) => MkPart (x :: lts) gtes
    (CmpEQP {prf = Refl}, MkPart {p} {q} lts gtes {gtePrfs}) =>
      rewrite plusSuccRightSucc p q in
        MkPart lts (x :: gtes) {gtePrfs = lteRefl :: gtePrfs}
    (CmpGTP {prf}, MkPart {p} {q} lts gtes {gtePrfs}) =>
      rewrite plusSuccRightSucc p q in
        MkPart lts (x :: gtes) {gtePrfs = lteSuccLeft prf :: gtePrfs}

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

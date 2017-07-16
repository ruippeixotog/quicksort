import Data.List.Quantifiers

%default total

||| Proof that if a number is not less than another, it is greater than or equal to it
ifNotLtThenGte : (LT a b -> Void) -> GTE a b
ifNotLtThenGte {a = Z} {b = Z} _ = lteRefl
ifNotLtThenGte {a = Z} {b = (S k)} notLt = absurd (notLt (LTESucc LTEZero))
ifNotLtThenGte {a = (S k)} {b = Z} _ = LTEZero
ifNotLtThenGte {a = (S k)} {b = (S j)} notLt = LTESucc (ifNotLtThenGte (notLt . LTESucc))

---

||| Proof that a list is a permutation of another
data Perm : List e -> List e -> Type where
  Empty : Perm [] []
  SameHead : (x : e) -> Perm xs ys -> Perm (x :: xs) (x :: ys)
  Compose : Perm xs ys -> Perm ys zs -> Perm xs zs
  Insert : (x : e) -> Perm xs (ys ++ zs) -> Perm (x :: xs) (ys ++ x :: zs)
  Cat : Perm xs zs -> Perm ys ws -> Perm (xs ++ ys) (zs ++ ws)

---

AllLT : List Nat -> Nat -> Type
AllLT xs pivot = All (\a => LT a pivot) xs

AllGTE : List Nat -> Nat -> Type
AllGTE xs pivot = All (\a => GTE a pivot) xs

||| The contract for a function that correctly partitions a list of numbers into those that are
||| smaller than a pivot and those that are not
data Partition : Nat -> List Nat -> List Nat -> List Nat -> Type where
  MkPart : (lts : List Nat) -> (gtes : List Nat) ->
           {auto permPrf : Perm xs (lts ++ gtes)} ->
           {auto ltPrfs : AllLT lts pivot} -> {auto gtePrfs : AllGTE gtes pivot} ->
           Partition pivot xs lts gtes

partitionLtProof : Partition pivot xs lts gtes -> LT x pivot -> Partition pivot (x :: xs) (x :: lts) gtes
partitionLtProof (MkPart _ _) ltPrf = MkPart _ _

partitionNotLtProof : Partition pivot xs lts gtes -> (LT x pivot -> Void) -> Partition pivot (x :: xs) lts (x :: gtes)
partitionNotLtProof {x} (MkPart _ _ {permPrf}) notLtPrf =
  let headPermPrf = Insert x permPrf
      headGtePrf = ifNotLtThenGte notLtPrf in MkPart _ _

partitionP : (pivot : Nat) -> (xs : List Nat) ->
             (lts : List Nat ** (gtes : List Nat ** Partition pivot xs lts gtes))
partitionP pivot [] = ([] ** ([] ** (MkPart _ _)))
partitionP pivot (x :: xs) with (partitionP pivot xs)
  | (lts ** (gtes ** tailPrf)) = case isLTE (S x) pivot of
      Yes ltPrf => ((x :: lts) ** (gtes ** partitionLtProof tailPrf ltPrf))
      No notLtPrf => (lts ** ((x :: gtes) ** partitionNotLtProof tailPrf notLtPrf))

---

||| The contract for a function that correctly sorts a list
Sort : List Nat -> List Nat -> Type
Sort xs xsSorted = Perm xs xsSorted -- TODO check for ordering

quicksortProof : Partition pivot xs lts gtes -> Sort lts ltsSrt -> Sort gtes gtesSrt ->
                 Sort (pivot :: xs) (ltsSrt ++ pivot :: gtesSrt)
quicksortProof {xs} {pivot} (MkPart _ _ {permPrf}) ltsPerm gtesPerm =
  Insert pivot (Compose permPrf (Cat ltsPerm gtesPerm))

quicksort : (xs : List Nat) -> (xsSrt : List Nat ** Sort xs xsSrt)
quicksort [] = ([] ** Empty)
quicksort (pivot :: xs) = case partitionP pivot xs of
  (lts ** (gtes ** partPrf)) =>
    let (ltsSrt ** ltsSrtPrf) = quicksort (assert_smaller (pivot :: xs) lts)
        (gtesSrt ** gtesSrtPrf) = quicksort (assert_smaller (pivot :: xs) gtes) in
          (ltsSrt ++ pivot :: gtesSrt ** quicksortProof partPrf ltsSrtPrf gtesSrtPrf)

---

main : IO ()
main = do n <- getLine
          arr <- getLine
          let (sorted ** _) = quicksort (map cast (words arr))
          putStrLn (unwords (map show sorted))

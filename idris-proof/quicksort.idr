import Data.List.Quantifiers

%default total

||| Proof that a Nat is either less than, equal or greater than another
data CmpNatP : Nat -> Nat -> Type where
  CmpLTP : LT a b -> CmpNatP a b
  CmpEQP : a = b -> CmpNatP a b
  CmpGTP : GT a b -> CmpNatP a b

cmpP : (a : Nat) -> (b : Nat) -> CmpNatP a b
cmpP Z Z = CmpEQP Refl
cmpP Z (S k) = CmpLTP (LTESucc LTEZero)
cmpP (S k) Z = CmpGTP (LTESucc LTEZero)
cmpP (S k) (S j) = case cmpP k j of
  CmpLTP ltPrf => CmpLTP (LTESucc ltPrf)
  CmpEQP eqPrf => CmpEQP (cong eqPrf)
  CmpGTP gtPrf => CmpGTP (LTESucc gtPrf)

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

partitionEqProof : Partition pivot xs lts gtes -> x = pivot -> Partition pivot (x :: xs) lts (x :: gtes)
partitionEqProof {x} (MkPart _ _ {permPrf} {gtePrfs}) Refl =
  let headPermPrf = Insert x permPrf
      consGtePrf = lteRefl :: gtePrfs in MkPart _ _

partitionGtProof : Partition pivot xs lts gtes -> GT x pivot -> Partition pivot (x :: xs) lts (x :: gtes)
partitionGtProof {x} (MkPart _ _ {permPrf}) gtPrf =
  let headPermPrf = Insert x permPrf
      headGtePrf = lteSuccLeft gtPrf in MkPart _ _

partitionP : (pivot : Nat) -> (xs : List Nat) ->
             (lts : List Nat ** (gtes : List Nat ** Partition pivot xs lts gtes))
partitionP pivot [] = ([] ** ([] ** (MkPart _ _)))
partitionP pivot (x :: xs) = case (cmpP x pivot, partitionP pivot xs) of
  (CmpLTP ltPrf, (lts ** (gtes ** tailPrf))) => ((x :: lts) ** (gtes ** partitionLtProof tailPrf ltPrf))
  (CmpEQP eqPrf, (lts ** (gtes ** tailPrf))) => (lts ** ((x :: gtes) ** partitionEqProof tailPrf eqPrf))
  (CmpGTP gtPrf, (lts ** (gtes ** tailPrf))) => (lts ** ((x :: gtes) ** partitionGtProof tailPrf gtPrf))

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

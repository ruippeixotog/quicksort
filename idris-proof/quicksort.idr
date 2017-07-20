import Data.List.Quantifiers

%default total

||| Proof that if a number is not less than another, it is greater than or equal to it
ifNotLtThenGte : (LT a b -> Void) -> GTE a b
ifNotLtThenGte {a = Z} {b = Z} _ = lteRefl
ifNotLtThenGte {a = Z} {b = (S k)} notLt = absurd (notLt (LTESucc LTEZero))
ifNotLtThenGte {a = (S k)} {b = Z} _ = LTEZero
ifNotLtThenGte {a = (S k)} {b = (S j)} notLt = LTESucc (ifNotLtThenGte (notLt . LTESucc))

AllLT : List Nat -> Nat -> Type
AllLT xs pivot = All (\a => LT a pivot) xs

AllGTE : List Nat -> Nat -> Type
AllGTE xs pivot = All (\a => GTE a pivot) xs

---

||| Proof that a list is equal to another with an element inserted somewhere
data EqPlus : e -> List e -> List e -> Type where
  Here : EqPlus x xs (x :: xs)
  There : EqPlus x xs xys -> EqPlus x (y :: xs) (y :: xys)

eqPlusInsert : EqPlus x (ys ++ zs) (ys ++ x :: zs)
eqPlusInsert {ys = []} = Here
eqPlusInsert {ys = y :: ys'} = There eqPlusInsert

eqPlusCat : EqPlus x xs xxs -> EqPlus x (xs ++ ys) (xxs ++ ys)
eqPlusCat Here = Here
eqPlusCat (There ep) = There (eqPlusCat ep)

eqPlusSwap : EqPlus x xs xxs -> EqPlus y xxs yxxs -> (yxs ** (EqPlus y xs yxs, EqPlus x yxs yxxs))
eqPlusSwap ep Here = (_ ** (Here, There ep))
eqPlusSwap Here (There ep) = (_ ** (ep, Here))
eqPlusSwap (There ep1) (There ep2) with (eqPlusSwap ep1 ep2)
  | (_ ** (ep1', ep2')) = (_ ** (There ep1', There ep2'))

---

||| Proof that a list is a permutation of another
data Perm : List e -> List e -> Type where
  Empty : Perm [] []
  Insert : EqPlus x ys xys -> Perm xs ys -> Perm (x :: xs) xys

permComposeView : EqPlus x ys' ys -> Perm ys zs -> (zs' ** (EqPlus x zs' zs, Perm ys' zs'))
permComposeView Here (Insert ep perm) = (_ ** (ep, perm))
permComposeView (There ep1) (Insert ep2 perm) with (permComposeView ep1 perm)
  | (_ ** (ep1', perm')) with (eqPlusSwap ep1' ep2)
    | (_ ** (ep1'', ep2'')) = (_ ** (ep2'', Insert ep1'' perm'))

permCompose : Perm xs ys -> Perm ys zs -> Perm xs zs
permCompose perm Empty = perm
permCompose (Insert epX permXs) permYZ with (permComposeView epX permYZ)
  | (_ ** (q, qs)) = Insert q (permCompose permXs qs)

permCat : Perm xs zs -> Perm ys ws -> Perm (xs ++ ys) (zs ++ ws)
permCat Empty perm = perm
permCat (Insert ep perm1) perm2 with (permCat perm1 perm2)
  | perm' = Insert (eqPlusCat ep) perm'

permForall : All p xs -> Perm xs ys -> All p ys

data Ordered : List e -> Type where
  EmptyOrdered : Ordered []
  SingletonOrdered : Ordered [x]
  ConsOrdered : LTE x x2 -> Ordered (x2 :: xs) -> Ordered (x :: x2 :: xs)

---

||| The contract for a function that correctly partitions a list of numbers into those that are
||| smaller than a pivot and those that are not
Partition : Nat -> List Nat -> List Nat -> List Nat -> Type
Partition pivot xs lts gtes = (Perm xs (lts ++ gtes), AllLT lts pivot, AllGTE gtes pivot)

partitionNilProof : Partition pivot [] [] []
partitionNilProof = (Empty, Nil, Nil)

partitionLtProof : Partition pivot xs lts gtes -> LT x pivot ->
                   Partition pivot (x :: xs) (x :: lts) gtes
partitionLtProof {x} (xsPerm, ltPrfs, gtPrfs) ltPrf =
  (Insert Here xsPerm, ltPrf :: ltPrfs, gtPrfs)

partitionNotLtProof : Partition pivot xs lts gtes -> (LT x pivot -> Void) ->
                      Partition pivot (x :: xs) lts (x :: gtes)
partitionNotLtProof {x} (xsPerm, ltPrfs, gtPrfs) notLtPrf =
  (Insert eqPlusInsert xsPerm, ltPrfs, ifNotLtThenGte notLtPrf :: gtPrfs)

partitionP : (pivot : Nat) -> (xs : List Nat) ->
             (lts : List Nat ** (gtes : List Nat ** Partition pivot xs lts gtes))
partitionP pivot [] = ([] ** ([] ** partitionNilProof))
partitionP pivot (x :: xs) with (partitionP pivot xs)
  | (lts ** (gtes ** tailPrf)) = case isLTE (S x) pivot of
      Yes ltPrf => ((x :: lts) ** (gtes ** partitionLtProof tailPrf ltPrf))
      No notLtPrf => (lts ** ((x :: gtes) ** partitionNotLtProof tailPrf notLtPrf))

---

||| The contract for a function that correctly sorts a list
Sort : List Nat -> List Nat -> Type
Sort xs xsSorted = (Perm xs xsSorted, Ordered xsSorted)

qsortNilProof : Sort [] []
qsortNilProof = (Empty, EmptyOrdered)

qsortConsPermProof : Perm xs (lts ++ gtes) -> Perm lts ltsSrt -> Perm gtes gtesSrt ->
                     Perm (pivot :: xs) (ltsSrt ++ pivot :: gtesSrt)
qsortConsPermProof permPrf ltsPerm gtesPerm =
  Insert eqPlusInsert (permCompose permPrf (permCat ltsPerm gtesPerm))

qsortConsOrdProof : Ordered xs -> Ordered ys -> AllLT xs pivot -> AllGTE ys pivot ->
                    Ordered (xs ++ pivot :: ys)
qsortConsOrdProof {xs = []} {ys = []} _ _ _ _ = SingletonOrdered
qsortConsOrdProof {xs = []} {ys = y :: ys'} _ ysOrd _ (gtePrf :: _) = ConsOrdered gtePrf ysOrd
qsortConsOrdProof {xs = x :: []} _ ysOrd (ltPrf :: Nil) ysGte =
  let restOrd = qsortConsOrdProof EmptyOrdered ysOrd Nil ysGte in
    ConsOrdered (lteSuccLeft ltPrf) restOrd
qsortConsOrdProof {xs = x :: x2 :: xs'} (ConsOrdered ltPrf xsRestOrd) ysOrd (_ :: xsRestLt) ysGte =
  let restOrd = qsortConsOrdProof xsRestOrd ysOrd xsRestLt ysGte in
    ConsOrdered ltPrf restOrd

qsortConsProof : Partition pivot xs lts gtes -> Sort lts ltsSrt -> Sort gtes gtesSrt ->
                 Sort (pivot :: xs) (ltsSrt ++ pivot :: gtesSrt)
qsortConsProof (xsPerm, ltPrfs, gtePrfs) (ltsPerm, ltsOrd) (gtesPerm, gtesOrd) =
  (qsortConsPermProof xsPerm ltsPerm gtesPerm,
   qsortConsOrdProof ltsOrd gtesOrd (permForall ltPrfs ltsPerm) (permForall gtePrfs gtesPerm))

quicksort : (xs : List Nat) -> (xsSrt : List Nat ** Sort xs xsSrt)
quicksort [] = ([] ** qsortNilProof)
quicksort (pivot :: xs) = case partitionP pivot xs of
  (lts ** (gtes ** partPrf)) =>
    let (ltsSrt ** ltsSrtPrf) = quicksort (assert_smaller (pivot :: xs) lts)
        (gtesSrt ** gtesSrtPrf) = quicksort (assert_smaller (pivot :: xs) gtes) in
          (ltsSrt ++ pivot :: gtesSrt ** qsortConsProof partPrf ltsSrtPrf gtesSrtPrf)

---

main : IO ()
main = do n <- getLine
          arr <- getLine
          let (sorted ** _) = quicksort (map cast (words arr))
          putStrLn (unwords (map show sorted))

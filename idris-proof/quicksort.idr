import Data.List.Quantifiers

%default total

||| An integer is either a positive `Nat` or the negated successor of a `Nat`.
data ZZ = Pos Nat | NegS Nat

||| Successor of a `ZZ`.
ZZS : ZZ -> ZZ
ZZS (Pos n) = Pos (S n)
ZZS (NegS Z) = Pos Z
ZZS (NegS (S n)) = NegS n

data ZZLTE : ZZ -> ZZ -> Type where
  ||| If n, m are `Nat` and n <= m, then n <= m in `ZZ`
  ZZLTEPos : LTE n m -> ZZLTE (Pos n) (Pos m)
  ||| If n, m are `Nat` and n <= m, then -m >= -n in `ZZ`
  ZZLTENeg : LTE n m -> ZZLTE (NegS m) (NegS n)
  ||| Negative numbers are always smaller than positive or zero ones 
  ZZLTENegPos : ZZLTE (NegS n) (Pos m)

||| Greater than or equal to
ZZGTE : ZZ -> ZZ -> Type
ZZGTE left right = ZZLTE right left

||| Strictly less than
ZZLT : ZZ -> ZZ -> Type
ZZLT left right = ZZLTE (ZZS left) right

||| If n, m are `Nat` and n <= m in `ZZ`, then n <= m in `Nat`
ifPosZZLTEThenLTE : ZZLTE (Pos n) (Pos m) -> LTE n m
ifPosZZLTEThenLTE (ZZLTEPos ltePrf) = ltePrf

||| If n, m are `Nat` and -n <= -m in `ZZ`, then m <= n in `Nat`
ifNegZZLTEThenGTE : ZZLTE (NegS n) (NegS m) -> LTE m n
ifNegZZLTEThenGTE (ZZLTENeg ltePrf) = ltePrf

||| A positive number is never less than or equal to a negative number
posNotZZLTEThanNeg : Not (ZZLTE (Pos n) (NegS m))
posNotZZLTEThanNeg ltePrf impossible

||| A decision procedure for `ZZLTE`
isZZLTE : (m : ZZ) -> (n : ZZ) -> Dec (ZZLTE m n)
isZZLTE (Pos n) (Pos m) with (isLTE n m)
  isZZLTE (Pos n) (Pos m) | (Yes prf) = Yes (ZZLTEPos prf)
  isZZLTE (Pos n) (Pos m) | (No contra) = No (contra . ifPosZZLTEThenLTE)
isZZLTE (NegS n) (NegS m) with (isLTE m n)
  isZZLTE (NegS n) (NegS m) | (Yes prf) = Yes (ZZLTENeg prf)
  isZZLTE (NegS n) (NegS m) | (No contra) = No (contra . ifNegZZLTEThenGTE)
isZZLTE (NegS n) (Pos m) = Yes ZZLTENegPos
isZZLTE (Pos n) (NegS m) = No posNotZZLTEThanNeg

||| n + 1 < m implies n < m
zzLteSuccLeft : ZZLTE (ZZS n) m -> ZZLTE n m
zzLteSuccLeft (ZZLTEPos ltePrf) {n = Pos k} = ZZLTEPos (lteSuccLeft ltePrf)
zzLteSuccLeft (ZZLTEPos ltePrf) {n = NegS Z} = ZZLTENegPos
zzLteSuccLeft (ZZLTENeg ltePrf) {n = NegS (S k)} = ZZLTENeg (lteSuccRight ltePrf)
zzLteSuccLeft ZZLTENegPos {n = NegS (S k)} = ZZLTENegPos

||| If a number is not less than another, it is greater than or equal to it.
notZZLTImpliesZZGTE : (ZZLT n m -> Void) -> ZZGTE n m
notZZLTImpliesZZGTE {n = Pos k} {m = Pos j} notLt = ZZLTEPos $ notLTImpliesGTE (notLt . ZZLTEPos)
notZZLTImpliesZZGTE {n = NegS Z} {m = NegS j} _ = ZZLTENeg LTEZero
notZZLTImpliesZZGTE {n = NegS (S k)} {m = NegS j} notLt = ZZLTENeg $ notLTImpliesGTE (notLt . ZZLTENeg . fromLteSucc)
notZZLTImpliesZZGTE {n = Pos k} {m = NegS j} _ = ZZLTENegPos
notZZLTImpliesZZGTE {n = NegS Z} {m = Pos j} notLt = absurd $ notLt (ZZLTEPos LTEZero)
notZZLTImpliesZZGTE {n = NegS (S k)} {m = Pos j} notLt = absurd $ notLt ZZLTENegPos

Cast Integer ZZ where
  cast n = if n >= 0 then Pos (cast n) else NegS (cast $ -n - 1)

Cast String ZZ where
  cast str = cast (the Integer (cast str))

Show ZZ where
  showPrec d (Pos n) = showPrec d n
  showPrec d (NegS n) = showParens (d >= PrefixMinus) $ "-" ++ showPrec PrefixMinus (S n)

---

||| Proof that a list is equal to another with an element inserted somewhere.
data EqPlus : e -> List e -> List e -> Type where
  Here : EqPlus x xs (x :: xs)
  There : EqPlus x xs xys -> EqPlus x (y :: xs) (y :: xys)

||| Given any ys and zs, (ys ++ x :: zs) is equal to (ys ++ zs) with x inserted.
eqPlusInsert : EqPlus x (ys ++ zs) (ys ++ x :: zs)
eqPlusInsert {ys = []} = Here
eqPlusInsert {ys = y :: ys'} = There eqPlusInsert

||| Appending a list to both sides of an EqPlus is still an EqPlus.
eqPlusCat : EqPlus x xs xxs -> EqPlus x (xs ++ ys) (xxs ++ ys)
eqPlusCat Here = Here
eqPlusCat (There ep) = There (eqPlusCat ep)

||| If yxxs results of inserting x followed by y into xs, adding first y and then x into xs still
||| results in yxxs.
eqPlusSwap : EqPlus x xs xxs -> EqPlus y xxs yxxs -> (yxs ** (EqPlus y xs yxs, EqPlus x yxs yxxs))
eqPlusSwap ep Here = (_ ** (Here, There ep))
eqPlusSwap Here (There ep) = (_ ** (ep, Here))
eqPlusSwap (There ep1) (There ep2) with (eqPlusSwap ep1 ep2)
  | (_ ** (ep1', ep2')) = (_ ** (There ep1', There ep2'))

---

||| Proof that a list is a permutation of another.
data Perm : List e -> List e -> Type where
  PEmpty : Perm [] []
  PInsert : EqPlus x ys xys -> Perm xs ys -> Perm (x :: xs) xys

permComposeView : EqPlus x ys' ys -> Perm ys zs -> (zs' ** (EqPlus x zs' zs, Perm ys' zs'))
permComposeView Here (PInsert ep perm) = (_ ** (ep, perm))
permComposeView (There ep1) (PInsert ep2 perm) with (permComposeView ep1 perm)
  | (_ ** (ep1', perm')) with (eqPlusSwap ep1' ep2)
    | (_ ** (ep1'', ep2'')) = (_ ** (ep2'', PInsert ep1'' perm'))

||| Permutations are composable.
permCompose : Perm xs ys -> Perm ys zs -> Perm xs zs
permCompose perm PEmpty = perm
permCompose (PInsert epX permXs) permYZ with (permComposeView epX permYZ)
  | (_ ** (q, qs)) = PInsert q (permCompose permXs qs)

||| Permutations can be concatenated.
permCat : Perm xs zs -> Perm ys ws -> Perm (xs ++ ys) (zs ++ ws)
permCat PEmpty perm = perm
permCat (PInsert ep perm1) perm2 with (permCat perm1 perm2)
  | perm' = PInsert (eqPlusCat ep) perm'

||| If xys is ys with x inserted, given proofs for x and for all elements of ys, there is a proof
||| for all elements of xys.
forallEqPlusInsert : EqPlus x ys xys -> p x -> All p ys -> All p xys
forallEqPlusInsert Here px pys = px :: pys
forallEqPlusInsert (There ep) px (py :: pys) = py :: forallEqPlusInsert ep px pys

||| Proofs for all elements of xs are also proofs for all elements of a permutation of xs.
forallPerm : All p xs -> Perm xs ys -> All p ys
forallPerm [] PEmpty = []
forallPerm (px :: pxs) (PInsert ep perm) with (forallPerm pxs perm)
  | pxs' = forallEqPlusInsert ep px pxs'

---

||| Proof that an integer list is sorted.
data Sorted : List ZZ -> Type where
  SEmpty : Sorted []
  SSingleton : Sorted [x]
  SCons : ZZLTE x x2 -> Sorted (x2 :: xs) -> Sorted (x :: x2 :: xs)

---

AllLT : List ZZ -> ZZ -> Type
AllLT xs pivot = All (\a => ZZLT a pivot) xs

AllGTE : List ZZ -> ZZ -> Type
AllGTE xs pivot = All (\a => ZZGTE a pivot) xs

||| The contract for a function that correctly partitions a list of integers into those that are
||| smaller than a pivot and those that are not.
Partition : ZZ -> List ZZ -> List ZZ -> List ZZ -> Type
Partition pivot xs lts gtes = (Perm xs (lts ++ gtes), AllLT lts pivot, AllGTE gtes pivot)

partitionNilProof : Partition pivot [] [] []
partitionNilProof = (PEmpty, Nil, Nil)

partitionLtProof : Partition pivot xs lts gtes -> ZZLT x pivot ->
                   Partition pivot (x :: xs) (x :: lts) gtes
partitionLtProof {x} (xsPerm, ltPrfs, gtPrfs) ltPrf =
  (PInsert Here xsPerm, ltPrf :: ltPrfs, gtPrfs)

partitionNotLtProof : Partition pivot xs lts gtes -> (ZZLT x pivot -> Void) ->
                      Partition pivot (x :: xs) lts (x :: gtes)
partitionNotLtProof {x} (xsPerm, ltPrfs, gtPrfs) notLtPrf =
  (PInsert eqPlusInsert xsPerm, ltPrfs, notZZLTImpliesZZGTE notLtPrf :: gtPrfs)

partitionP : (pivot : ZZ) -> (xs : List ZZ) ->
             (lts : List ZZ ** (gtes : List ZZ ** Partition pivot xs lts gtes))
partitionP pivot [] = ([] ** ([] ** partitionNilProof))
partitionP pivot (x :: xs) with (partitionP pivot xs)
  | (lts ** (gtes ** tailPrf)) = case isZZLTE (ZZS x) pivot of
      Yes ltPrf => ((x :: lts) ** (gtes ** partitionLtProof tailPrf ltPrf))
      No notLtPrf => (lts ** ((x :: gtes) ** partitionNotLtProof tailPrf notLtPrf))

---

||| The contract for a function that correctly sorts a list.
Sort : List ZZ -> List ZZ -> Type
Sort xs xsSorted = (Perm xs xsSorted, Sorted xsSorted)

qsortNilProof : Sort [] []
qsortNilProof = (PEmpty, SEmpty)

qsortConsPermProof : Perm xs (lts ++ gtes) -> Perm lts ltsSrt -> Perm gtes gtesSrt ->
                     Perm (pivot :: xs) (ltsSrt ++ pivot :: gtesSrt)
qsortConsPermProof permPrf ltsPerm gtesPerm =
  PInsert eqPlusInsert (permCompose permPrf (permCat ltsPerm gtesPerm))

qsortConsOrdProof : Sorted xs -> Sorted ys -> AllLT xs pivot -> AllGTE ys pivot ->
                    Sorted (xs ++ pivot :: ys)
qsortConsOrdProof {xs = []} {ys = []} _ _ _ _ = SSingleton
qsortConsOrdProof {xs = []} {ys = y :: ys'} _ ysOrd _ (gtePrf :: _) = SCons gtePrf ysOrd
qsortConsOrdProof {xs = x :: []} _ ysOrd (ltPrf :: Nil) ysGte =
  let restOrd = qsortConsOrdProof SEmpty ysOrd Nil ysGte in
    SCons (zzLteSuccLeft ltPrf) restOrd
qsortConsOrdProof {xs = x :: x2 :: xs'} (SCons ltPrf xsRestOrd) ysOrd (_ :: xsRestLt) ysGte =
  let restOrd = qsortConsOrdProof xsRestOrd ysOrd xsRestLt ysGte in
    SCons ltPrf restOrd

qsortConsProof : Partition pivot xs lts gtes -> Sort lts ltsSrt -> Sort gtes gtesSrt ->
                 Sort (pivot :: xs) (ltsSrt ++ pivot :: gtesSrt)
qsortConsProof (xsPerm, ltPrfs, gtePrfs) (ltsPerm, ltsOrd) (gtesPerm, gtesOrd) =
  (qsortConsPermProof xsPerm ltsPerm gtesPerm,
   qsortConsOrdProof ltsOrd gtesOrd (forallPerm ltPrfs ltsPerm) (forallPerm gtePrfs gtesPerm))

quicksort : (xs : List ZZ) -> (xsSrt : List ZZ ** Sort xs xsSrt)
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

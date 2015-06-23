trait TypeDefs {

  // type-level natural numbers (with aliases for common ones)

  sealed trait Nat
  final class _0 extends Nat
  final class Succ[A <: Nat] extends Nat

  type _1 = Succ[_0]
  type _2 = Succ[_1]
  type _3 = Succ[_2]
  type _4 = Succ[_3]
  type _5 = Succ[_4]
  type _6 = Succ[_5]
  type _7 = Succ[_6]
  type _8 = Succ[_7]
  type _9 = Succ[_8]
  type _10 = Succ[_9]

  // heterogeneous lists

  sealed trait HList
  final class HNil extends HList
  final class ::[A, Tail <: HList] extends HList
}

trait TypeOps { this: TypeDefs =>

  // disjunction of evidences

  trait ||[A, B]
  implicit def leftOr[A, B](implicit ev: A) = new (A || B) {}
  implicit def rightOr[A, B](implicit ev: B) = new (A || B) {}

  // Nat comparators

  trait <[A, B]
  implicit def zeroLessThanSucc[A <: Nat] = new (_0 < Succ[A]) {}
  implicit def succLessThanSucc[A <: Nat, B <: Nat](implicit ev: A < B) = new (Succ[A] < Succ[B]) {}

  trait >[A, B]
  implicit def succGreaterThanZero[A <: Nat] = new (Succ[A] > _0) {}
  implicit def succGreaterThanSucc[A <: Nat, B <: Nat](implicit ev: A > B) = new (Succ[A] > Succ[B]) {}

  type <=[A, B] = (A < B) || (A =:= B)
  type >=[A, B] = (A > B) || (A =:= B)

  // HList operations

  trait :::[Xs <: HList, Ys <: HList] { type Out <: HList }
  implicit def concatWithHNil[Ys <: HList] = new (HNil ::: Ys) { type Out = Ys }
  implicit def concatWithHCons[A, Tail <: HList, Ys <: HList](implicit ev: Tail ::: Ys) =
    new ((A :: Tail) ::: Ys) { type Out = A :: ev.Out }

  trait Partition[Pivot <: Nat, Xs <: HList] { type Out1 <: HList; type Out2 <: HList }

  implicit def hNilPartition[Pivot <: Nat] = new Partition[Pivot, HNil] { type Out1 = HNil; type Out2 = HNil }

  implicit def hConsPartition[Pivot <: Nat, A <: Nat, Tail <: HList](implicit ev: Partition[Pivot, Tail], ev2: A < Pivot) =
    new Partition[Pivot, A :: Tail] { type Out1 = A :: ev.Out1; type Out2 = ev.Out2 }

  implicit def hConsPartition2[Pivot <: Nat, A <: Nat, Tail <: HList](implicit ev: Partition[Pivot, Tail], ev2: A >= Pivot) =
    new Partition[Pivot, A :: Tail] { type Out1 = ev.Out1; type Out2 = A :: ev.Out2 }

  // Quicksort definition

  trait Quicksort[Xs <: HList] { type Out <: HList }

  implicit def hNilQuicksort = new Quicksort[HNil] { type Out = HNil }

  implicit def hConsQuicksort[A <: Nat, Tail <: HList, Lower <: HList, Upper <: HList,
                              LowerSorted <: HList, UpperSorted <: HList](
    implicit ev: Partition[A, Tail] { type Out1 = Lower; type Out2 = Upper },
             ev2: Quicksort[Lower] { type Out = LowerSorted },
             ev3: Quicksort[Upper] { type Out = UpperSorted },
             ev4: LowerSorted ::: A :: UpperSorted) = new Quicksort[A :: Tail] {

    type Out = ev4.Out
  }

  // generation of string representations of types

  trait StringRepr[A] { def stringRepr: String }

  def repr[A](implicit t: StringRepr[A]) = t.stringRepr

  implicit def zeroRepr = new StringRepr[_0] { def stringRepr = "0" }
  implicit def succRepr[A <: Nat: StringRepr] =
    new StringRepr[Succ[A]] { def stringRepr = (repr[A].toInt + 1).toString }

  implicit def hNilRepr = new StringRepr[HNil] { def stringRepr = "" }
  implicit def hConsLastRepr[A: StringRepr] = new StringRepr[A :: HNil] { def stringRepr = repr[A] }
  implicit def hConsRepr[A: StringRepr, Tail <: HList: StringRepr] =
    new StringRepr[A :: Tail] { def stringRepr = repr[A] + " " + repr[Tail] }
}

object Quicksort extends App with TypeDefs with TypeOps {
  type Xs = _5 :: _1 :: _9 :: _3 :: _7 :: _6 :: _4 :: _8 :: _10 :: _2 :: HNil

  def quicksort[A <: HList] = new {
    def repr[B <: HList](implicit ev: Quicksort[A] { type Out = B }, ev2: StringRepr[B]) = ev2.stringRepr
  }

  println(quicksort[Xs].repr)
}

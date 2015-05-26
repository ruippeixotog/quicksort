import scala.io.Source

object Quicksort extends App {

  def quicksort(xs: List[Int]): List[Int] = xs match {
    case Nil => Nil
    case pivot :: tail =>
      val (lower, upper) = tail.partition(_ < pivot)
      quicksort(lower) ::: pivot :: quicksort(upper)
  }

  val xs = Source.stdin.mkString.split("\\s").drop(1).map(_.toInt).toList
  val sorted = quicksort(xs)
  println(sorted.mkString(" "))
}

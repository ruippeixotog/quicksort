structure Quicksort = struct

open TextIO
open List

fun quicksort [] = []
  | quicksort (pivot :: xs) = let
      val (lower, upper) = partition (fn x => x < pivot) xs
    in
      (quicksort lower) @ pivot :: (quicksort upper)
    end

fun showInt x =
  if x < 0 then "-" ^ Int.toString (~x)
  else Int.toString x

val readIntList = (mapPartial Int.fromString) o (String.tokens Char.isSpace)
val showIntList = (String.concatWith " ") o (map showInt)

fun main (_, args) =
  let
    val _ = inputLine stdIn
    val SOME arr = Option.map readIntList (inputLine stdIn)
    val _ = print ((showIntList (quicksort arr)) ^ "\n")
  in
    0
  end
end

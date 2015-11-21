fun quicksort(xs: List<Int>): List<Int> =
    if (xs.isEmpty()) xs
    else {
        val pivot = xs.first()
        val (lower, upper) = xs.subList(1, xs.size).partition { it < pivot }
        quicksort(lower) + listOf(pivot) + quicksort(upper)
    }

fun main(args: Array<String>) {
    readLine()
    val xs = readLine()!!.split(" ").map { it.toInt() }.toList()
    val sorted = quicksort(xs)
    println(sorted.joinToString(" "))
}

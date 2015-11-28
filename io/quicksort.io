List quicksort := method(
    if(p := removeFirst,
        select(< p) quicksort with(p) appendSeq(select(>= p) quicksort),
        self
    )
)

in := File standardInput
in readLine
in readLine split map(asNumber) quicksort join(" ") println

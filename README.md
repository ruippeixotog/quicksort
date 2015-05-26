# Quicksort

Several implementations of quicksort in multiple languages. Inspired by @hugopeixoto's [mergesort](https://github.com/hugopeixoto/mergesort) project.

## Rules

1. Unless the language does not provide a standard IO library or there is no reasonable way to pass input to the program, programs should read the array to sort from stdin and output it sorted to stdout:
  1. Valid inputs are composed by two lines. The first contains a single integer, the number *N* of elements in the array. The second contains _N_ integers separated by single spaces, the elements of the array to sort;
  1. The program should output a single line containing the _N_ integers of the input array sorted and separated by single spaces, ending with a single newline;
1. If possible, programs should not define a maximum size for the input _apriori_. They should be able to handle any array of reasonable size, which means they should allocate the necessary memory dynamically;
1. Programs should be implemented using each language's data structures and idioms;
  1. There is no problem if the idiomatic way to implement quicksort in a language comes with a performance hit (for example, by not sorting in-place), but the implementation must not have an expected running time worse than O(_n_ log _n_).

## Testing

The commands to compile and run each implementation are on the `test` script. To run a set of tests against an implementation, run:

```
./test <folder_name>
```

The tests to run are defined in the `_test` folder.

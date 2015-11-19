#!/bin/bash

partition() {
  xargs -I{} bash -c "test {} -lt $1 && echo {} >> $2 || echo {} >> $3"
}

quicksort() {
  read pivot && test -n $pivot && {
    lower=$(mktemp); upper=$(mktemp)
    partition $pivot $lower $upper
    cat <(quicksort < $lower) <(echo $pivot) <(quicksort < $upper)
    rm $lower $upper
  }
}

read n
tr ' ' '\n' | quicksort | tr '\n' ' ' | sed 's/ $//'

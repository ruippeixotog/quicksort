#!/bin/bash
declare -a arr

function swap {
  local tmp=${arr[$1]}
  arr[$1]=${arr[$2]}
  arr[$2]=$tmp
}

function quicksort {
  local st=$1
  local end=$2

  if [ $st != $end ]; then
    local sep=$st
    
    for ((i=st+1; i<end; i++)); do
      if ((arr[i] < arr[st])); then
        swap $((++sep)) $i
      fi
    done

    swap $st $sep
    quicksort $st $sep
    quicksort $((sep + 1)) $end
  fi
}

read n
IFS=' ' read -a arr
quicksort 0 $n
IFS=' ' echo ${arr[@]}

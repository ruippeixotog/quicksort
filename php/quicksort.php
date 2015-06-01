<?php
  function swap(&$arr, $i, $j) {
    $tmp = $arr[$i]; $arr[$i] = $arr[$j]; $arr[$j] = $tmp;
  }

  function quicksort(&$arr, $st, $end) {
    if($st == $end) return;

    $sep = $st;
    for($i = $st + 1; $i < $end; $i++) {
      if($arr[$i] < $arr[$st]) swap($arr, ++$sep, $i);
    }

    swap($arr, $st, $sep);
    quicksort($arr, $st, $sep);
    quicksort($arr, $sep + 1, $end);
  }

  $arr = array(5, 1, 9, 3, 7, 6, 4, 8, 10, 2);
  quicksort($arr, 0, count($arr));
  echo implode(" ", $arr);
?>

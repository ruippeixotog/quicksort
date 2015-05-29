var readline = require('readline');
var input = readline.createInterface({ input: process.stdin });

function swap(arr, i, j) {
  var tmp = arr[i]; arr[i] = arr[j]; arr[j] = tmp;
}

function quicksort(arr, st, end) {
  if(st == end) return;

  var sep = st;
  for(var i = st + 1; i < end; i++) {
    if(arr[i] < arr[st]) swap(arr, ++sep, i);
  }

  swap(arr, st, sep);
  quicksort(arr, st, sep);
  quicksort(arr, sep + 1, end);
}

input.on('line', function(n) {
  input.on('line', function(xs) {
    arr = xs.split(' ').map(Number);
    quicksort(arr, 0, arr.length);
    console.log(arr.join(' '));
    input.close();
  });
});

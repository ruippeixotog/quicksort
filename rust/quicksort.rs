use std::io;
use std::io::BufRead;

fn quicksort(v: &mut [i32]) {
  if !v.is_empty() {
    let mut sep = 0;
    for i in 1..v.len() {
      if v[i] < v[0] {
        sep += 1;
        v.swap(sep, i);
      }
    }

    v.swap(0, sep);
    quicksort(&mut v[..sep]);
    quicksort(&mut v[(sep + 1)..]);
  }
}

fn main() {
  let stdin = io::stdin();
  let mut v: Vec<i32> = stdin.lock().lines().nth(1)
    .unwrap().unwrap().split(' ').flat_map(|s| s.parse()).collect();

  quicksort(&mut v);

  let v_str: Vec<String> = v.iter().map(|x| x.to_string()).collect();
  println!("{}", v_str.join(" "));
}

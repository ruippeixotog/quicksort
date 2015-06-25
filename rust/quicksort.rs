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
  let s = match stdin.lock().lines().nth(1) {
    Some(Ok(s)) => s,
    _ => unreachable!()
  };

  let mut v: Vec<i32> = s.split(' ').flat_map(|s| s.parse()).collect();
  quicksort(&mut v);

  let v_str: Vec<String> = v.iter().map(|x| x.to_string()).collect();
  println!("{}", v_str.connect(" "));
}

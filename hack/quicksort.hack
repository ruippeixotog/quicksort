use namespace HH\Lib\{C, IO, Str, Vec};

function quicksort(vec<int> $vec): vec<int> {
  if(C\count($vec) <= 1) return $vec;

  $pivot = C\pop_back(inout $vec);
  list($lower, $upper) = Vec\partition($vec, $e ==> $e <= $pivot);
  return Vec\concat(quicksort($lower), vec[$pivot], quicksort($upper));
}

<<__EntryPoint>>
async function main(): Awaitable<void> {
  $input = (await IO\request_input()->readAllAsync())
    |> Str\trim($$)
    |> Str\split($$, "\n")
    |> C\last($$)
    |> Str\split($$, " ")
    |> Vec\map($$, $e ==> Str\to_int($e));

  $output = quicksort($input);
  echo Str\join($output, " ").\PHP_EOL;
}

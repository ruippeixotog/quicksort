-module(quicksort).

quicksort([]) -> []; 
quicksort([Pivot|Rest]) ->
  {Lower,Upper} = lists:partition(fun(A) -> A < Pivot end, Rest),
  quicksort(Lower) ++ [Pivot] ++ quicksort(Upper).

read_int() -> {_,[N]} = io:fread("", "~d"), N.

main(_) ->
  N = read_int(),
  List = [read_int() || _ <- lists:seq(1, N)],
  Sorted = quicksort(List),
  io:fwrite("~s~n", [string:join([integer_to_list(X) || X <- Sorted], " ")]).

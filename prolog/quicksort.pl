quicksort([], []).
quicksort([Pivot|List], Sorted) :-
  partition(@>=(Pivot), List, Lower, Upper),
  quicksort(Lower, LowerSorted), quicksort(Upper, UpperSorted),
  append([LowerSorted, [Pivot], UpperSorted], Sorted).

read_num_list(NumList) :-
  read_string(current_input, "\n", "\r", _, Str),
  split_string(Str, " ", " ", StrList),
  maplist(number_string, NumList, StrList).

main :- prompt(_, ''),
        readln(_), read_num_list(List),
        quicksort(List, Sorted),
        atomics_to_string(Sorted, " ", Joined),
        writeln(Joined).

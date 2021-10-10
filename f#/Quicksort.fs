let rec quicksort = function
  | [] -> []
  | pivot :: tail ->
      let lower, upper = List.partition (fun x -> x < pivot) tail
      quicksort lower @ [pivot] @ quicksort upper

let _ = stdin.ReadLine()
let xs = stdin.ReadLine().Split(' ') |> List.ofArray |> List.map int
let sorted = quicksort xs
printfn "%s" (sorted |> List.map (sprintf "%i") |> String.concat " ")

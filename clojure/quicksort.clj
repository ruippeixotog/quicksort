(defn quicksort [xs]
  (if (empty? xs) xs
      (let [pivot (first xs)
            {lower false upper true} (group-by #(>= % pivot) (rest xs))]
        (concat (quicksort lower) (list pivot) (quicksort upper)))))

(def n (read))
(def xs (repeatedly n #(read)))
(println (clojure.string/join " " (quicksort xs)))

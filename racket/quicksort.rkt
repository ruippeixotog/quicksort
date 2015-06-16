#lang racket

(define (quicksort xs)
  (if (null? xs) null
      (let*-values ([(pivot) (car xs)]
                    [(lower upper) (partition (curry >= pivot) (cdr xs))])
        (append (quicksort lower) (list pivot) (quicksort upper)))))

(define n (read))
(define xs (for/list ([i (in-range n)]) (read)))

(define sorted (quicksort xs))
(displayln (string-join (map number->string sorted)))

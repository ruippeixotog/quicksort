(defun partition (f xs)
  (labels ((aux (p1 p2 ys)
                (if (null ys) (cons p1 p2)
                    (destructuring-bind
                      (head . tail) ys
                      (if (funcall f head)
                          (aux (cons head p1) p2 tail)
                          (aux p1 (cons head p2) tail))))))
          (aux '() '() xs)))

(defun quicksort (xs)
  (if (null xs) xs
      (let* ((pivot (car xs))
             (part (partition (lambda (x) (< x pivot)) (cdr xs))))
        (append (quicksort (car part)) (list pivot) (quicksort (cdr part))))))

(defvar n (read))
(defvar xs (loop for i below n collect (read)))
(princ (format nil "~{~A~^ ~}~%" (quicksort xs)))

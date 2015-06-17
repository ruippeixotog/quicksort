(defun partition (f xs)
  (loop for x in xs
        if (funcall f x) collect x into l
        else collect x into r
        finally (return (cons l r))))

(defun quicksort (xs)
  (if (null xs) xs
      (let* ((pivot (car xs))
             (part (partition (lambda (x) (< x pivot)) (cdr xs))))
        (append (quicksort (car part)) (list pivot) (quicksort (cdr part))))))

(defvar n (read))
(defvar xs (loop for i below n collect (read)))
(princ (format nil "~{~A~^ ~}~%" (quicksort xs)))

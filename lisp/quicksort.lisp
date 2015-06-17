(defun partition (f xs)
  (loop for x in xs
        if (funcall f x) collect x into l
        else collect x into r
        finally (return (values l r))))

(defun quicksort (xs)
  (when xs
    (let ((pivot (car xs)))
      (multiple-value-bind (l r) (partition (lambda (x) (< x pivot)) (cdr xs))
        (append (quicksort l) (list pivot) (quicksort r))))))

(defvar n (read))
(defvar xs (loop for i below n collect (read)))
(princ (format nil "~{~A~^ ~}~%" (quicksort xs)))

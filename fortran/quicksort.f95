SUBROUTINE swap(arr, n, i, j)
  INTEGER :: arr(n), n, i, j, tmp

  tmp = arr(i)
  arr(i) = arr(j)
  arr(j) = tmp
END SUBROUTINE swap

RECURSIVE SUBROUTINE quicksort(arr, n, st, en)
  INTEGER :: arr(n), n, st, en, sep, i

  IF (st <= en) THEN
    sep = st

    DO i = st + 1, en
      IF (arr(i) < arr(st)) THEN
        sep = sep + 1
        CALL swap(arr, n, sep, i)
      END IF
    END DO

    CALL swap(arr, n, st, sep)
    CALL quicksort(arr, n, st, sep - 1)
    CALL quicksort(arr, n, sep + 1, en)
  END IF
END

SUBROUTINE print_array(arr, n)
  INTEGER :: arr(n), n, i

  IF (n > 0) THEN
    WRITE (*, '(i0)', advance='no') arr(1)
  END IF

  DO i = 2, n - 1
    WRITE (*, '(a1,i0)', advance='no') ' ', arr(i)
  END DO

  IF (n > 1) THEN
    WRITE (*, '(a1,i0)') ' ', arr(n)
  END IF
END SUBROUTINE print_array

PROGRAM main
  INTEGER :: n
  INTEGER, ALLOCATABLE :: arr(:)

  READ *, n
  ALLOCATE (arr(n))
  READ *, arr

  CALL quicksort(arr, n, 1, n)
  CALL print_array(arr, n)
  DEALLOCATE (arr)
END PROGRAM main

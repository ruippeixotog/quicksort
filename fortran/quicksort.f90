program main

    use, intrinsic :: iso_fortran_env, only: &
        ip     => INT32, &
        stdout => OUTPUT_UNIT, &
        stdin  => INPUT_UNIT

    ! Explicit typing only
    implicit none

    !--------------------------------------------------------------------------------
    ! Dictionary
    !--------------------------------------------------------------------------------
    integer (ip), allocatable    :: array(:)
    integer (ip), allocatable    :: sorted_array(:)
    !--------------------------------------------------------------------------------

    ! Read from standard input
    array = read_data()

    ! Perform quicksort
    sorted_array = quicksort( data = array )

    ! Reverse array from decreasing to increasing
    sorted_array = sorted_array(ubound(sorted_array,1):lbound(sorted_array,1):-1)

    ! Print results to standard output
    call print_results_to_standard_output( sorted_array )

    ! Free memory (this is not necessary but gfortran has a lot of bugs)
    deallocate( array, sorted_array )

contains
    !
    !*****************************************************************************************
    !
    recursive function quicksort( data ) result( return_value )
        !--------------------------------------------------------------------------------
        ! Dictionary: calling arguments
        !--------------------------------------------------------------------------------
        integer (ip), intent (in)   :: data(:)
        integer (ip), allocatable   :: return_value(:)
        !--------------------------------------------------------------------------------

        associate( n => size(data) )

            ! Check if array is already allocated
            if ( allocated(return_value) ) deallocate(return_value)

            ! Allocate array for sorted data
            allocate( return_value(1:n) )

            ! Perform quicksort algorithm
            if ( n > 1 ) then
                return_value = &
                    [ quicksort( pack( data(2:), data(2:) > data(1) ) ), &
                    data(1),                                             &
                    quicksort( pack( data(2:), data(2:) <= data(1) ) ) ]
            else
                return_value = data
            end if
        end associate

    end function quicksort
    !
    !*****************************************************************************************
    !
    function read_data() result (return_value)
        !--------------------------------------------------------------------------------
        ! Dictionary: calling arguments
        !--------------------------------------------------------------------------------
        integer (ip), allocatable :: return_value(:)
        !--------------------------------------------------------------------------------
        ! Dictionary: local variables
        !--------------------------------------------------------------------------------
        integer (ip) :: n
         !--------------------------------------------------------------------------------

        read( stdin, fmt = *) n

        allocate( return_value(n) )

        read( stdin, fmt = *) return_value

    end function read_data
    !
    !*****************************************************************************************
    !
    subroutine print_results_to_standard_output( array )
        !--------------------------------------------------------------------------------
        ! Dictionary: calling arguments
        !--------------------------------------------------------------------------------
        integer (ip), intent (in) :: array(:)
        !--------------------------------------------------------------------------------
        ! Dictionary: local variables
        !--------------------------------------------------------------------------------
        integer (ip) :: i !! Counter
        !--------------------------------------------------------------------------------

        associate( n => size(array) )

            if (n > 0) then
                write( stdout, '(i0)', advance='no') array(1)
            end if

            do i = 2, n - 1
                write( stdout, '(a,i0)', advance='no') ' ', array(i)
            end do

            if (n > 1) then
                write( stdout, '(a,i0)') ' ', array(n)
            end if

        end associate

    end subroutine print_results_to_standard_output
    !
    !*****************************************************************************************
    !
end program main

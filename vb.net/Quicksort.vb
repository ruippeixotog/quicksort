Module Quicksort
    Private Sub Swap(arr As Integer(), i As Integer, j As Integer)
        Dim tmp As Integer = arr(i)
        arr(i) = arr(j)
        arr(j) = tmp
    End Sub
 
    Private Sub Quicksort(arr As Integer(), st As Integer, en As Integer)
        If st <> en Then
            Dim sep As Integer = st
            For i As Integer = st + 1 To en - 1
                If arr(i) < arr(st) Then
                    Swap(arr, ++sep, i)
                End If
            Next
 
            Swap(arr, st, sep)
            Quicksort(arr, st, sep)
            Quicksort(arr, sep + 1, en)
        End If
    End Sub
 
    Sub Main()
        Dim n As Integer = Integer.Parse(Console.ReadLine())
        Dim strArr As String() = Console.ReadLine().Split()
 
        Dim arr(n) As Integer
        For i As Integer = 0 To n - 1
            arr(i) = Integer.Parse(strArr(i))
        Next
 
        Quicksort(arr, 0, n)
 
        For i As Integer = 0 To n - 1
            If i <> 0 Then
                Console.Write(" ")
            End If
            Console.Write(arr(i))
        Next
        Console.WriteLine()
    End Sub
End Module

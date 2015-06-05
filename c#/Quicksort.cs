using System;
using System.Linq;

class QuicksortMain
{
    private static void Swap(int[] arr, int i, int j)
    {
        var tmp = arr[i];
        arr[i] = arr[j];
        arr[j] = tmp;
    }

    private static void Quicksort(int[] arr, int st, int end)
    {
        if (st == end) return;

        var sep = st;
        for (var i = st + 1; i < end; i++)
        {
            if (arr[i] < arr[st])
            {
                Swap(arr, ++sep, i);
            }
        }

        Swap(arr, st, sep);
        Quicksort(arr, st, sep);
        Quicksort(arr, sep + 1, end);
    }

    private static void Quicksort(int[] arr)
    {
        Quicksort(arr, 0, arr.Length);
    }

    static void Main()
    {
        Console.ReadLine();
        var arr = Console.ReadLine().Split().Select(int.Parse).ToArray();
        Quicksort(arr);
        Console.WriteLine(string.Join(" ", arr));
    }
}

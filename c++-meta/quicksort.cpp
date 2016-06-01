#include <iostream>

// conditional
template <bool cond, typename Then, typename Else>
struct if_;

template <typename Then, typename Else>
struct if_<true, Then, Else> {
  typedef Then res;
};

template <typename Then, typename Else>
struct if_<false, Then, Else> {
  typedef Else res;
};

// linked list
struct nil;

template <int head, typename Tail>
struct cons;

// concat
template <typename List1, typename List2>
struct concat;

template <typename List2>
struct concat<nil, List2> {
  typedef List2 res;
};

template <int head, typename Tail, typename List2>
struct concat<cons<head, Tail>, List2> {
  typedef typename concat<Tail, List2>::res inner;
  typedef cons<head, inner> res;
};

// partition
template <int pivot, typename List>
struct partition;

template <int pivot>
struct partition<pivot, nil> {
  typedef nil lower;
  typedef nil upper; 
};

template <int pivot, int head, typename Tail>
struct partition<pivot, cons<head, Tail> > {
  typedef partition<pivot, Tail> inner;

  typedef typename if_<(head < pivot), cons<head, typename inner::lower>, typename inner::lower>::res lower;
  typedef typename if_<(head >= pivot), cons<head, typename inner::upper>, typename inner::upper>::res upper;
};

// quicksort
template <typename List>
struct quicksort;

template <>
struct quicksort<nil> {
  typedef nil res;
};

template <int head, typename Tail>
struct quicksort<cons<head, Tail> > {
  typedef partition<head, Tail> part;
  typedef typename quicksort<typename part::lower>::res lowerInner;
  typedef typename quicksort<typename part::upper>::res upperInner;

  typedef typename concat<lowerInner, cons<head, upperInner> >::res res;
};

// printer
template<typename List>
struct printer {
  static void print() { std::cout << std::endl; }
};

template <int head>
struct printer<cons<head, nil> > {
  static void print() { std::cout << head << std::endl; }
};

template <int head, typename Tail>
struct printer<cons<head, Tail> > {
  static void print() { std::cout << head << " "; printer<Tail>::print(); }
};

int main() {
  typedef cons<5, cons<1, cons<9, cons<3, cons<7,
    cons<6, cons<4, cons<8, cons<10, cons<2, nil> > > > > > > > > > xs;

  typedef quicksort<xs>::res sorted;
  printer<sorted>::print();
  return 0;
}

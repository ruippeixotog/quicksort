# Delete first line
1d

# Prepend "@" to positive numbers ("+" has special meaning in regexes)
s/(^| )([0-9])/\1@\2/g

# Prepend "," to each digit to use as a marker
s/[0-9]/,&/g

# Convert digits into o's (e.g. ",4" -> ",oooo", ",1,2" -> ",o,oo")
s/0//g
s/1/o/g
s/2/oo/g
s/3/ooo/g
s/4/oooo/g
s/5/ooooo/g
s/6/oooooo/g
s/7/ooooooo/g
s/8/oooooooo/g
s/9/ooooooooo/g

# Expand base 10 numbers into o's (e.g. ",o,oo" -> ",oooooooooooo")
:to_os
  s/,(o+),(o*)/,\1\1\1\1\1\1\1\1\1\1\2/
t to_os

# Swap plus/minus signs with marker (e.g. "@,oo" -> ",@oo", "-,o" -> ",-o")
s/([-@]),/,\1/g

:quicksort

  # Mark a single number as pivot by switching "," to "p"
  # If not found, jump to cleanup phase
  s/,/p/
  t partition
  b cleanup

  # Find "," numbers lower than the pivot and move them to its left
  :partition
    # Case 1: positive pivot, negative number
    s/p@(o*)([^p]*) ,-(o*)/,-\3 p@\1\2/
    
    # Case 2: positive pivot and number, pivot has higher number of o's
    s/p@(o*)(o+)(|[^o][^p]*) ,@\1([^o]|$)/,@\1 p@\1\2\3\4/

    # Case 3: negative pivot and number, number has higher number of o's
    s/p-(o*)(|[^o][^p]*) ,-\1(o+)([^o]|$)/,-\1\3 p-\1\2\4/
  t partition

b quicksort

:cleanup

# Convert o's back into base 10 numbers (e.g. "-oooooooooooo" -> "-12")
s/([-@])/\10/g
:to_digits
  s/([-@])o/\10o/g
  s/0o/1/g
  s/1o/2/g
  s/2o/3/g
  s/3o/4/g
  s/4o/5/g
  s/5o/6/g
  s/6o/7/g
  s/7o/8/g
  s/8o/9/g
  s/9o/o0/g
t to_digits

# Remove "p" markers and positive signs
s/[p@]//g

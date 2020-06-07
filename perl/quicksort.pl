use strict;
use warnings;

sub quicksort {
  return @_ if @_ <= 1;

  my (@lower, @upper);
  foreach my $e (@_[1..$#_]) {
    push @{$e < $_[0] ? \@lower : \@upper}, $e;
  }

  quicksort(@lower), $_[0], quicksort(@upper);
}

<STDIN>;
my @arr = split /\s+/, <STDIN>;
print join(' ', quicksort(@arr)) . "\n";

#!/usr/bin/perl -w

use strict;

my $arg=shift @ARGV // 0;
my $seed=shift @ARGV // $$^time;

srand($seed);

for(my $i=0;$i<$arg;++$i)
{
  print '', (int(rand(10)<5))? '' : '-', $i, "\n";
}
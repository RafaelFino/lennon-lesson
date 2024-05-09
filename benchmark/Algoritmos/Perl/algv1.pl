#!/usr/bin/perl -w

use strict;
use Time::HiRes qw(time);

if(!@ARGV)
{
  die "\n$0 : vetor\n";
}

my $preparse=time();
if(&parseARGV($ARGV[0])<0)
{
  die "\n$0 : ERRO no parse de ($ARGV[0])\n";
}

my $precalc=time();
my $somaMaxima=&somaMaximaV1(\@ARGV);
if(!defined $somaMaxima)
{
  die "\n$0 : ERRO ao obter a soma maxima\n";
}
my $poscalc=time();
print "\n$0 : Tempo Alocacao memoria vetor (".($precalc-$preparse).")\n";
print "\n$0 : Tempo Calculo da soma maxima (".($poscalc-$precalc).")\n";
print "\n$0 : A soma maxima do array com (".scalar(@ARGV).") posicoes eh ($somaMaxima)\n";

sub somaMaximaV1
{
  my $v=shift;

  my $n=scalar(@$v);
  if(!$n)
  {
    return undef;
  }

  my $r=$v->[0];
  #para todas as posicoes iniciais
  for(my $i=0;$i<$n;++$i)
  {
    #para todas as posicoes finais
    for(my $j=$i;$j<$n;++$j)
    {
      my $s=0;
      #faca a soma dos elementos entre a posicao inicial e a final
      for(my $k=$i;$k<=$j;++$k)
      {
        $s+=$v->[$k];
      }
      if($s>$r)
      {
        $r=$s;
      }
    }
  }
  return $r;
}

sub parseARGV
{
  my $arg=shift;

  if(!defined $arg)
  {
    return -1;
  }

  if($arg=~/^-?\d+$/)
  {
    return 1;
  }

  my $infile;
  if($arg=~/-?-?[Ss][Tt][Dd](?:[Ii][Nn])?$/)
  {
    $infile=*STDIN;
  }
  else
  {
    if(!open($infile,'<',$arg))
    {
      return -2;
    }
  }
  my $c=$ARGV[1];
  @ARGV=();
  if((defined $c)&&($c=~/^[1-9]\d*$/))
  {
    $#ARGV=$c-1;
  }
  my $x=0;
  while(my $line=<$infile>)
  {
    chomp($line);
    #push @ARGV, $line;
    $ARGV[$x++]=$line;
  }
  if(($x>0)&&($x<$c))
  {
    $#ARGV=$x-1;
  }
  return 2;
}

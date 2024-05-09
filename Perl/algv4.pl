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
my $somaMaxima=&somaMaximaV4(\@ARGV);
if(!defined $somaMaxima)
{
  die "\n$0 : ERRO ao obter a soma maxima\n";
}
my $poscalc=time();
print "\n$0 : Tempo Alocacao memoria vetor (".($precalc-$preparse).")\n";
print "\n$0 : Tempo Calculo da soma maxima (".($poscalc-$precalc).")\n";
print "\n$0 : A soma maxima do array com (".scalar(@ARGV).") posicoes eh ($somaMaxima)\n";

sub somaMaximaV4
{
  my $v=shift;

  my $n=scalar(@$v);
  if(!$n)
  {
    return undef;
  }

  #solucao do caso de somente um elemento
  my $r=$v->[0];
  my $s=$v->[0];

  #para as demais posicoes
  for(my $i=1;$i<$n;++$i)
  {
    #se a soma ate o momento eh positiva
    if($s>=0)
    {
      #adiciona o elemento corrente
      $s+=$v->[$i];
    }
    else
    {
      #se a soma eh negativa a soma eh o elemento corrente
      $s=$v->[$i];
    }
    if($s>$r)
    {
      $r=$s;
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
  my $c=$ARGV[1] // 0;
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
  if($x>0)
  {
    $#ARGV=$x-1;
  }
  return 2;
}

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
my $somaMaxima=&somaMaximaV3(\@ARGV);
if(!defined $somaMaxima)
{
  die "\n$0 : ERRO ao obter a soma maxima\n";
}
my $poscalc=time();
print "\n$0 : Tempo Alocacao memoria vetor (".($precalc-$preparse).")\n";
print "\n$0 : Tempo Calculo da soma maxima (".($poscalc-$precalc).")\n";
print "\n$0 : A soma maxima do array com (".scalar(@ARGV).") posicoes eh ($somaMaxima)\n";

sub somaMaximaV3
{
  my $v=shift;
  return &somaMaximaV3Recursivo(0,scalar(@$v)-1,$v);
}

sub somaMaximaV3Recursivo
{
  my $esquerda=shift;
  my $direita=shift;
  my $v=shift;

  my $n=scalar(@$v);
  if(!$n)
  {
    return undef;
  }

  #se so tem uma posicao o resultado eh o valor desta posicao
  if($esquerda==$direita)
  {
    return $v->[$esquerda];
  }

  #caso com mais de uma posicao
  my $meio=int(($esquerda+$direita)/2);

  #calcula soma maxima a esquerda do ponto mediano
  my $somaMaximaEsquerda=&somaMaximaV3Recursivo($esquerda,$meio,$v);

  #calcula soma maxima a direita do ponto mediano
  my $somaMaximaDireita=&somaMaximaV3Recursivo($meio+1,$direita,$v);

  #inicia soma parcial esquerda
  my $s=$v->[$meio];

  #inicial resultado parcial esquerdo
  my $rEsquerda=$v->[$meio];

  #para todas as posicoes a esquerda
  for(my $i=$meio-1;$i>=$esquerda;--$i)
  {
    $s+=$v->[$i];
    if($s>$rEsquerda)
    {
      $rEsquerda=$s;
    }
  }

  #inicia soma parcial direita
  $s=$v->[$meio+1];

  #inicial resultado parcial direito
  my $rDireita=$v->[$meio+1];

  #para todas as posicoes a direita
  for(my $i=$meio+2;$i<=$direita;++$i)
  {
    $s+=$v->[$i];
    if($s>$rDireita)
    {
      $rDireita=$s;
    }
  }

  my $r=&maximo($somaMaximaEsquerda,$rEsquerda+$rDireita,$somaMaximaDireita);
  return $r;
}

sub maximo
{
  if(!@_)
  {
    return undef;
  }
  my $max=shift;
  while(@_)
  {
    my $x=shift;
    if($x>$max)
    {
      $max=$x;
    }
  }
  return $max;
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
    $ARGV[$x++]=int($line);
  }
  if($x>0)
  {
    $#ARGV=$x-1;
  }
  return 2;
}

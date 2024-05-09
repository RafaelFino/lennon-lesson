#!/usr/bin/python3

import sys
import re
from datetime import datetime

def parseARGV(args):
  if args is None:
    return None
  arg=args[1]
  v=[]
  m=re.match(r'^-?\d+$',arg)
  if m is not None:
    n=len(args)
    for i in range(1,n):
      v.append(int(args[i]))
    return v
  infile=sys.stdin
  m=re.match(r'^-?-?[Ss][Tt][Dd](?:[Ii][Nn])?$',arg)
  cap=0
  if m is None:
    infile=open(arg,'r',encoding="utf-8")
  if len(sys.argv)>2:
    arg=args[2]
    m=re.match(r'^[1-9]\d*$',arg)
    if m is not None:
      cap=int(arg)
      v=[0]*cap
  if cap==0:
    for line in infile:
      v.append(int(line))
    return v
  x=0
  for line in infile:
    v[x]=int(line)
    x=x+1
    if x==cap:
      break
  for line in infile:
    v.append(int(line))
    x=x+1
  if x<cap:
    del v[x:]
  return v

def somaMaximaV1(v):
  if len(v)==0:
    return None

  r=v[0]
  n=len(v)
  #para todas as posicoes iniciais
  for i in range(0,n):
    #para todas as posicoes finais
    for j in range(i,n):
      s=0
      #faca a soma dos elementos entre a posicao inicial e a final
      for k in range(i,j+1):
        s=s+v[k]
      if s>r:
        r=s
  return r

if len(sys.argv)<2:
  print(f'{sys.argv[0]} : vetor\n')
  sys.exit(1)

preparse=datetime.now()
v=parseARGV(sys.argv)
if v is None:
  print(f'{sys.argv[0]} : ERRO no parse de ({sys.argv[1]})\n')
  sys.exit(2)

precalc=datetime.now()
somaMaxima=somaMaximaV1(v)
poscalc=datetime.now()

aloctime=precalc-preparse
algtime=poscalc-precalc

print(f'\n{sys.argv[0]} : Tempo Alocacao memoria vetor ({aloctime.total_seconds()})')
print(f'\n{sys.argv[0]} : Tempo Calculo da soma maxima ({algtime.total_seconds()})')
print(f'\n{sys.argv[0]} : A soma maxima do array com ({len(v)}) posicoes eh ({somaMaxima})')

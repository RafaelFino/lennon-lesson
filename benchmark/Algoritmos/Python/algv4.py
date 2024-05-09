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

#https://www.youtube.com/watch?v=Qgevy75co8c

def somaMaximaV4(v):
  n=len(v)
  if n==0:
    return None

  #solucao do caso de somente um elemento
  r=v[0]
  s=v[0]

  #para as demais posicoes
  for i in range(1,n):
    #se a soma ate o momento eh positiva
    if s>=0:
      #adiciona o elemento corrente
      s=s+v[i]
    else:
      #se a soma eh negativa a soma eh o elemento corrente
      s=v[i]
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
somaMaxima=somaMaximaV4(v)
poscalc=datetime.now()

aloctime=precalc-preparse
algtime=poscalc-precalc

print(f'\n{sys.argv[0]} : Tempo Alocacao memoria vetor ({aloctime.total_seconds()})')
print(f'\n{sys.argv[0]} : Tempo Calculo da soma maxima ({algtime.total_seconds()})')
print(f'\n{sys.argv[0]} : A soma maxima do array com ({len(v)}) posicoes eh ({somaMaxima})')

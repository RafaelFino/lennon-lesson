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
def somaMaximaV3(v):
  if v is None:
    return None
  if len(v)==0:
    return None
  return somaMaximaV3Recursivo(v,0,len(v)-1)

def somaMaximaV3Recursivo(v,esquerda,direita):
  #se so tem uma posicao o resultado eh o valor desta posicao
  if esquerda==direita:
    return v[esquerda]

  #caso com mais de uma posicao
  meio=(esquerda+direita)//2

  #calcula soma maxima a esquerda do ponto mediano
  somaMaximaEsquerda=somaMaximaV3Recursivo(v,esquerda,meio)

  #calcula soma maxima a direita do ponto mediano
  somaMaximaDireita=somaMaximaV3Recursivo(v,meio+1,direita)

  #inicia soma parcial esquerda
  s=v[meio]

  #inicial resultado parcial esquerdo
  rEsquerda=v[meio]

  #para todas as posicoes a esquerda
  for i in range(meio-1,esquerda-1,-1):
    s=s+v[i]
    if s>rEsquerda:
      rEsquerda=s

  #inicia soma parcial direita
  s=v[meio+1]

  #inicial resultado parcial direito
  rDireita=v[meio+1]

  #para todas as posicoes a direita
  for i in range(meio+2,direita+1):
    s=s+v[i]
    if s>rDireita:
      rDireita=s

  r=max(somaMaximaEsquerda,rEsquerda+rDireita,somaMaximaDireita)
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
somaMaxima=somaMaximaV3(v)
poscalc=datetime.now()

aloctime=precalc-preparse
algtime=poscalc-precalc

print(f'\n{sys.argv[0]} : Tempo Alocacao memoria vetor ({aloctime.total_seconds()})')
print(f'\n{sys.argv[0]} : Tempo Calculo da soma maxima ({algtime.total_seconds()})')
print(f'\n{sys.argv[0]} : A soma maxima do array com ({len(v)}) posicoes eh ({somaMaxima})')

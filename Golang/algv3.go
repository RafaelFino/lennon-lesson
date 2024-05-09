package main

import (
	"os"
	"regexp"
  "strconv"
	"fmt"
	"io"
	"bufio"
	"time"
)

func parseARGV(args []string) ([]int64) {
  arg := args[1]
  m, _ := regexp.MatchString("^-?\\d+$",arg)
  if m == true {
		v := make([]int64,0)
    n := len(args)
    for i := 1; i<n; i++ {
			x, _ := strconv.ParseInt(args[i],10,0)
      v = append(v,x)
    }
    return v
  }

	var cap int64 = 0
	mi, _ := regexp.MatchString("^-?-?[Ss][Tt][Dd](?:[Ii][Nn])?$",arg)

	if len(args)>2 {
		arg = args[2]
		me, _ := regexp.MatchString("^[1-9]\\d*$",arg)
		if me == true {
			cap, _ = strconv.ParseInt(arg,10,0)
		}
	}

	if mi == true {
		v := make([]int64,cap)
		rdr := bufio.NewReader(os.Stdin)
		var ct int64 = 0
		for {
			switch line, err := rdr.ReadString('\n'); err {
			case nil:
				line = line[:len(line)-1]
				x, _ := strconv.ParseInt(line,10,0)
				v = append(v,x)
				ct+=1
			case io.EOF:
				if ct < cap {
					v=v[:ct]
				}
				return v
			default:
					fmt.Fprintln(os.Stderr,"error:",err)
					os.Exit(-1)
			}
		}
	}

	file, err := os.Open(args[1])
	if err != nil {
		fmt.Fprintln(os.Stderr,"error:",err)
		os.Exit(-2)
	}
	defer file.Close()

	if cap==0 {
		v := make([]int64,0)
		scanner := bufio.NewScanner(file)
		for scanner.Scan() {
			text := scanner.Text()
			x, _ := strconv.ParseInt(text,10,0)
			v = append(v,x)
		}
		return v
	}

	var ct int64 = 0
	v := make([]int64,cap)
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		text := scanner.Text()
		x, _ := strconv.ParseInt(text,10,0)
		v[ct] = x
		ct+=1
		if ct==cap {
			break
		}
	}
	for scanner.Scan() {
		text := scanner.Text()
		x, _ := strconv.ParseInt(text,10,0)
		v = append(v,x)
		ct+=1
	}
	if ct < cap {
		v=v[:ct]
	}
	return v
}

func somaMaximaV3(v []int64) (int64) {
  n := len(v)
  if n==0 {
    return 0
	}
  return somaMaximaV3Recursivo(v,0,n-1)
}

func max(x int64,y int64,z int64) (int64) {
  if x>y {
    if x>z {
      return x
    }
    return z
  }
  //x<=y
  if z>y {
    return z
  }
  return y
}

func somaMaximaV3Recursivo(v []int64,esquerda int,direita int) (int64) {
  //se so tem uma posicao o resultado eh o valor desta posicao
  if esquerda==direita {
    return v[esquerda]
  }

  //caso com mais de uma posicao
  var meio int = (esquerda+direita)/2

  //calcula soma maxima a esquerda do ponto mediano
  somaMaximaEsquerda := somaMaximaV3Recursivo(v,esquerda,meio)

  //calcula soma maxima a direita do ponto mediano
  somaMaximaDireita := somaMaximaV3Recursivo(v,meio+1,direita)

  //inicia soma parcial esquerda
  s := v[meio]

  //inicial resultado parcial esquerdo
  rEsquerda := v[meio]

  //para todas as posicoes a esquerda
  for i := meio-1; i>=esquerda; i-- {
    s=s+v[i]
    if s>rEsquerda {
      rEsquerda=s
    }
  }

  //inicia soma parcial direita
  s=v[meio+1]

  //inicial resultado parcial direito
  rDireita := v[meio+1]

  //para todas as posicoes a direita
  for i := meio+2; i<direita; i++ {
    s=s+v[i]
    if s>rDireita {
      rDireita=s
    }
  }

  r := max(somaMaximaEsquerda,rEsquerda+rDireita,somaMaximaDireita)
  return r
}

func main() {
	if len(os.Args) < 2 {
		println(os.Args[0],": vetor")
		os.Exit(1)
	}

	preparse := time.Now()
	v := parseARGV(os.Args)
	if v == nil {
	  println(os.Args[0]," : ERRO no parse de (",os.Args[1],")")
	  os.Exit(2)
	}

	precalc := time.Now()
	somaMaxima := somaMaximaV3(v)
	poscalc := time.Now()

	fmt.Printf("\n%s : Tempo Alocacao memoria vetor (%.9f)\n",os.Args[0],precalc.Sub(preparse).Seconds())
	fmt.Printf("\n%s : Tempo Calculo da soma maxima (%.9f)\n",os.Args[0],poscalc.Sub(precalc).Seconds())
	fmt.Printf("\n%s : A soma maxima do array com (%d) posicoes eh (%d)\n",os.Args[0],len(v),somaMaxima)
	os.Exit(0)
}

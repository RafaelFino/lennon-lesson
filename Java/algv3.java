import java.lang.*;
import java.util.*;
import java.io.*;
import java.io.File;
import java.util.regex.Pattern;
import java.time.*;

public class algv3
{
	public static int len=0;
	public static int cap=0;

	public static long[] parseARGV(String[] args)
	{
		String arg=args[0];
		long[] v=null;
		int n=args.length;
		boolean m=Pattern.matches("^-?\\d+$",arg);
		if(m)
		{
			int i;
			v=new long[n];
			for(i=0;i<n;++i)
			{
				try
				{
					long x=Long.parseLong(args[i]);
					v[i]=x;
				}
				catch(NumberFormatException e)
				{
					return null;
				}
			}
			len=n;
			cap=n;
			return v;
		}
		m=Pattern.matches("^-?-?[Ss][Tt][Dd](?:[Ii][Nn])?$",arg);
		Scanner s=null;
		if(m)
		{
			s=new Scanner(System.in);
		}
		else
		{
			try
			{
				s=new Scanner(new File(arg));
			}
			catch(FileNotFoundException e)
			{
				return null;
			}
		}
		int cp=16;
		if(n>1)
		{
			arg=args[1];
			m=Pattern.matches("^[1-9]\\d*$",arg);
			if(m)
			{
				try
				{
					int x=Integer.parseInt(arg);
					cp=x;
				}
				catch(NumberFormatException e)
				{
					s.close();
					return null;
				}
			}
		}
		s.useDelimiter("\n");
		int size=0;
		v=new long[cp];
    while(s.hasNextLong())
		{
			long x=s.nextLong();
			if(size==cp)
			{
				cp<<=1;
				long[] newv=Arrays.copyOf(v,cp);
				v=newv;
			}
			v[size++]=x;
    }
	s.close();
		len=size;
		cap=cp;
		return v;
	}

	public static long max(long x,long y,long z)
	{
	  if(x>y)
		{
	    if(x>z)
			{
	      return x;
	    }
	    return z;
	  }
	  //x<=y
	  if(z>y)
		{
	    return z;
	  }
	  return y;
	}


	public static long somaMaximaV3Recursivo(long[] v,int esquerda,int direita)
	{
	  //se so tem uma posicao o resultado eh o valor desta posicao
	  if(esquerda==direita)
		{
	    return v[esquerda];
	  }

	  //caso com mais de uma posicao
	  int meio=(esquerda+direita)/2;

	  //calcula soma maxima a esquerda do ponto mediano
	  long somaMaximaEsquerda=somaMaximaV3Recursivo(v,esquerda,meio);

	  //calcula soma maxima a direita do ponto mediano
	  long somaMaximaDireita=somaMaximaV3Recursivo(v,meio+1,direita);

	  //inicia soma parcial esquerda
	  long s=v[meio];

	  //inicial resultado parcial esquerdo
	  long rEsquerda=v[meio];

	  //para todas as posicoes a esquerda
	  for(int i=meio-1;i>=esquerda;--i)
		{
	    s=s+v[i];
	    if(s>rEsquerda)
			{
	      rEsquerda=s;
	    }
	  }

	  //inicia soma parcial direita
	  s=v[meio+1];

	  //inicial resultado parcial direito
	  long rDireita=v[meio+1];

	  //para todas as posicoes a direita
	  for(int i=meio+2;i<direita;++i)
		{
	    s=s+v[i];
	    if(s>rDireita)
			{
	      rDireita=s;
	    }
	  }

	  long r=max(somaMaximaEsquerda,rEsquerda+rDireita,somaMaximaDireita);
	  return r;
	}

	public static long somaMaximaV3(long[] v)
	{
	  int n=len;
	  if(n==0)
		{
	    return 0L;
		}
	  return somaMaximaV3Recursivo(v,0,n-1);
	}

	public static void main(String args[])
	{
		//String execfile=new java.io.File(algv1.class.getProtectionDomain().getCodeSource().getLocation().getPath()).getName();
		String execfile=algv3.class.getName();

		if(args.length<1)
		{
			System.out.println("\n"+execfile+" : vetor\n");
			System.exit(1);
		}

		Instant preparse=Instant.now();
		long[] v=parseARGV(args);
		if(v==null)
		{
			System.out.println("\n"+execfile+" : ERRO no parse de ("+args[0]+")\n");
			System.exit(2);
		}

		Instant precalc=Instant.now();
		//System.out.println("\n"+execfile+" : V ("+Arrays.toString(v)+")\n");
		long somaMaxima=somaMaximaV3(v);
		Instant poscalc=Instant.now();

		Duration parse=Duration.between(preparse,precalc);
		Duration alg=Duration.between(precalc,poscalc);

		System.out.printf("\n%s : Tempo Alocacao memoria vetor (%d.%09d)\n",execfile,parse.getSeconds(),parse.getNano());
		System.out.printf("\n%s : Tempo Calculo da soma maxima (%d.%09d)\n",execfile,alg.getSeconds(),alg.getNano());
		System.out.printf("\n%s : A soma maxima do array com (%d) posicoes eh (%d)\n",execfile,len,somaMaxima);
		System.exit(0);
	}
}

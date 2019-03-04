/*********************************************
 * OPL 12.5 Model
 * Author: parallels
 * Creation Date: Mar 3, 2019 at 2:10:02 PM
 *********************************************/
int T=...;
int M=...;

int dmin=...;
int dmax=...;

range mode=1..M;
range temps=1..T;

int p[temps][mode]=...;
int f[temps][mode]=...;
int e[temps][mode]=...;

int h[temps]=...;
float d[temps];
int Emax[temps]=...;

float a= 1 /(dmax-dmin);
//variables
dvar float+ x[temps][mode];
dvar float+ s[temps];
dvar boolean y[temps][mode]; 
//dexpr float expr1[t in temps] = sum(m in mode)x[m][t]-s[t] + s[t-1]==d[t];

execute{
  for(var t in temps){
    	d[t]=a;
    }
  }
//objective
minimize
  sum(m in mode)(sum(t in temps)(p[t][m]*x[t][m]+f[t][m]*y[t][m]))+sum(t in temps)h[t]*s[t];
subject to{
	forall(t in temps){
	  forall(t2 in temps){
	    if(t2==t-1){
	    	sum(m in mode)x[t][m]-s[t] + s[t2]==d[t];
	    }
 	  }	  
	}	 
	    
	forall(t in temps){
       forall(t1 in temps){
			forall(m in mode){          
              if(t1==t){
		    	(sum(t1 in t1..T)d[t1])*y[t][m]>=x[t][m];
		      }
		   }
		}
    }
    //global 
    sum(t in temps)(sum(m in mode)((e[t][m]-Emax[t])*x[t][m]))<=0;
}

execute{
    writeln("s[");
	for(var t in temps){
	      write(s[t]);
	}
	writeln("]");
	writeln("x[");
	for(var t in temps){
	      write(x[t]);
	} 
	writeln("]");
	writeln("y[");
	for(var t in temps){
	      writeln(y[t]);
	} 
	writeln("]");
}
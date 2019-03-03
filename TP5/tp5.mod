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

int p[mode][temps]=...;
int f[mode][temps]=...;
int e[mode][temps]=...;

int h[temps]=...;
float d[temps];
int Emax[temps]=...;

float a= 1 div (dmax-dmin);
//variables
dvar float+ x[mode][temps];
dvar float+ s[temps];
dvar boolean y[mode][temps];
execute{
  for(var t in temps){
    	d[t]=a;
    }
  }
//objective
minimize
  sum(m in mode)(sum(t in temps)(p[m][t]*x[m][t]+f[m][t]*y[m][t]))+sum(t in temps)h[t]*s[t];
subject to{
	forall(t in temps)
		sum(m in mode)x[m][t]-s[t]+s[t-1]==d[t];
    forall(m in mode){
      forall(t in temps){
		x[m][t]<=(sum(t1 in temps)d[t1])*y[m][t];
        }
      }
    //period
    forall(t in temps){
      sum(m in mode)(e[m][t]-Emax[t])*x[m][t]<=0;
      }
    /*
    //global
    forall(t in temps){
      sum(t in temps)(sum(m in mode)(e[m][t]-Emax[t])*x[m][t])<=0;
      }*/
    //
}

execute{
	for(var m in mode){
	  for(var t in temps){
	      writeln("x:"+x[m][t]+",");
	    }
	  }
  
}
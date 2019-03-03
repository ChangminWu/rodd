/*********************************************
 * OPL 12.5 Model
 * Author: parallels
 * Creation Date: Mar 3, 2019 at 2:10:02 PM
 *********************************************/
int T=...;
int M=...;
int Emax_t=...;
int dmin=...;
int dmax=...;

range mode=1..M;
range temps=1..T;

int p[mode][temps]=...;
int f[mode][temps]=...;
int e[mode][temps]=...;

int h[temps]=...;
int d[temps];

execute{
  //generate uniform
     for(var t in T){
         d[t]=1/(dmax-dmin);
       }
  };

//variables
dvar float+ x[mode][temps];
dvar float+ s[temps];
dvar boolean y[mode][temps];

//objective
minimize
  sum(m in mode)(sum(t in temps)(p[m][t]*x[m][t]+f[m][t]*y[m][t]))+sum(t in temps)h[t]*s[t];
subject to{
	forall(t in temps){
	  sum(m in mode)x[m][t]-s[t]+s[t-1]==d[t];
	  }  
    forall(m in mode){
      forall(t in temps){
		x[m][t]<=(sum(t1 in temps)d[t1])*y[m][t];
        }
      }
    //manque une contrain
}
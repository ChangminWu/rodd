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
int d[temps]=[20,25,30,35,40,45,50,55,60,65];
int Emax[temps]=...;
int R=5;
/*
//generate d[t] par random
int myRange = 50;
int randomArray[i in 1..10] = 20 + rand(myRange);
execute{
    for(t in temps){
      d[t]=randomArray[t];
      }
	writeln("randomArray="+randomArray);
}
*/
//variables
dvar float+ x[temps][mode];
dvar float+ s[temps];
dvar boolean y[temps][mode]; 

//objective
minimize
  sum(t in temps)(sum(m in mode)(p[t][m]*x[t][m]+f[t][m]*y[t][m])+h[t]*s[t]);

subject to{
	forall(t in 2..T){
	  forall(t1 in 1..T-1:t1==t-1)
	      (sum(m in mode)x[t][m])-s[t] + s[t1]==d[t];  
	}	 
	
	sum(m in mode)x[1][m]-s[1]==d[1];
	    
	forall(t in temps){
       forall(t1 in temps:(t1==t)){
			forall(m in mode){
		    	(sum(t1 in t1..T)d[t1])*y[t][m]>=x[t][m];
		   }
		}
    }
    
    //contrainte glissante
	forall(t in 1..T-R+1)
		sum(t1 in t..t+R-1)(sum(m in mode)((e[t1][m]-Emax[t1])*x[t1][m]))<=0;
	
	//contrainte global
	//sum (t1 in temps)(sum(m in mode)((e[t1][m]-Emax[t1])*x[t1][m]))<=0;
	//contrainte period
	//forall(t1 in temps)
	//	(sum(m in mode)((e[t1][m]-Emax[t1])*x[t1][m]))<=0;
	/*	
	sum(t1 in 1..5)(sum(m in mode)((e[t1][m]-Emax[t1])*x[t1][m]))<=0;
	sum(t1 in 2..6)(sum(m in mode)((e[t1][m]-Emax[t1])*x[t1][m]))<=0;
	sum(t1 in 3..7)(sum(m in mode)((e[t1][m]-Emax[t1])*x[t1][m]))<=0;
	sum(t1 in 4..8)(sum(m in mode)((e[t1][m]-Emax[t1])*x[t1][m]))<=0;
	sum(t1 in 5..9)(sum(m in mode)((e[t1][m]-Emax[t1])*x[t1][m]))<=0;
	sum(t1 in 6..10)(sum(m in mode)((e[t1][m]-Emax[t1])*x[t1][m]))<=0;
	*/
}

execute{
    writeln("s[");
	for(var t in temps){
	      write(s[t]," ");
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

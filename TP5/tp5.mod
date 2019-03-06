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

int R=1;
int period=ftoi(floor(T/R));
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
  sum(m in mode)(sum(t in temps)(p[t][m]*x[t][m]+f[t][m]*y[t][m]))+sum(t in temps)h[t]*s[t];

subject to{
	forall(t in temps){
	  forall(t2 in temps){
	    if(t2==t-1){
	      (sum(m in mode)x[t][m])-s[t] + s[t2]==d[t];
	    }
 	  }	  
	}	 
	    
	forall(t in temps){
       forall(t1 in temps){
			forall(m in mode){          
              if(t1==t){
		    	(sum(t1 in t1..T)d[t1])*y[t1][m]>=x[t1][m];
		      }
		   }
		}
    }
    //period
    /*forall(t in temps)
      (sum(m in mode)((e[t][m]-Emax[t])*x[t][m]))<=0;
    */
    //global 
    //sum(t in temps)(sum(m in mode)((e[t][m]-Emax[t])*x[t][m]))<=0;
	//glissant
	/*
	sum(t in 1..5)(sum(m in mode)((e[t][m]-Emax[t])*x[t][m]))<=0;
	sum(t in 6..10)(sum(m in mode)((e[t][m]-Emax[t])*x[t][m]))<=0;
	*/
	
	forall(p in 1..period)
	   {sum(t1 in (((p-1)*R+1)..p*R))(sum(m in mode)((e[t1][m]-Emax[t1])*x[t1][m]))<=0;}
	
	sum(t1 in (period*R+1)..T)(sum(m in mode)((e[t1][m]-Emax[t1])*x[t1][m]))<=0;
	
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
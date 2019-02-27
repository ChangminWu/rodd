/*********************************************
 * OPL 12.5 Model
 * Author: dascim
 * Creation Date: Feb 6, 2019 at 4:44:35 PM
 *********************************************/
int N = ...;
int Nm = ...;
int Nf = ...;
int C = ...;
int G = ...;
int A = ...;
int T = ...;
float init = ...;

int individu[1..N][1..C][1..G][1..A] = ...;
int group[1..N][1..G];

dvar float+ y[1..G][1..A];
dvar int+ x[1..N];
dvar float+ z[1..G][1..A];

execute{
  for (var i=1; i<=N; i++){
    for (var j=1; j<G; j++){
      if (individu[i][1][j][1] == individu[i][1][j][2]) {
        group[i][j] = 1;//individu[i][1][j][1];
      }      
      else{
        group[i][j] = 0;
        }
      
      }
    }
    writeln(group);
  }
  
  
minimize
  sum(i in 1..G, j in 1..A) y[i][j];
  
subject to {
  forall (i in 1..G, j in 1..A)
    y[i][j] <= 1;
    
  forall (i in 1..G, j in 1..A)
    y[i][j] >= 0;
  
  sum(i in 1..N) x[i] == N;
  sum(i in 1..Nm) x[i] == sum(i in Nm+1..N) x[i];
  
  forall (i in 1..N)
    x[i] <= 3;
    
  forall (i in 1..G, j in 1..A)
    y[i][j] >= z[i][j] - sum(k in 1..N : (group[k][i] != 0)) x[k];
    
  forall (i in 1..G, j in 1..A)
    forall(r in 1..T)
    	(T-r) * ln(init) / (T-1) -1 + z[i][j] / (pow(init, (T-r)/(T-1))) >= sum(k in 1..N : group[k][i]==0) x[k] * ln(0.5); 
}  

 execute{
   	//writeln(group); 
	for(var i=1; i<=N; i++){
		writeln(x[i]);
		 	}  
} 
  
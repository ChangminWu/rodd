/*********************************************
 * OPL 12.5 Model
 * Author: dascim
 * Creation Date: Jan 23, 2019 at 2:56:32 PM
 *********************************************/
int m = ...;
int n = ...;
int p = ...;
int q = ...;

float alpha[1..(p+q)] = ...;
float proba[1..(p+q)][1..m][1..n] = ...;
int c[1..m][1..n] = ...;

dvar boolean x[1..m][1..n];
dvar boolean y[1..m][1..n];

minimize
  sum(i in 1..m, j in 1..n) c[i][j] * y[i][j];
subject to{
  
  forall(i in 2..m-1, j in 2..n-1)
    9 * x[i][j] <= sum(k in i-1..i+1, l in j-1..j+1) y[k][l];
  forall(j in 1..n)
    x[1][j] == 0;
  forall(j in 1..n)
    x[m][j] == 0;    
  forall(i in 1..m)
    x[i][1] == 0;
  forall(i in 1..m)
    x[i][n] == 0;
/*  
  forall(j in 2..n-1)
    6 * x[1][j] <= sum(k in 1..2, l in j-1..j+1) y[k][l];
  forall(j in 2..n-1)
    6 * x[m][j] <= sum(k in m-1..m, l in j-1..j+1) y[k][l];
  forall(i in 2..m-1)
    6 * x[i][1] <= sum(k in i-1..i+1, l in 1..2) y[k][l];
  forall(i in 2..m-1)
    6 * x[i][n] <= sum(k in i-1..i+1, l in n-1..n) y[k][l];
  
  4*x[1][1] <= sum(k in 1..2, l in 1..2) y[k][l];
  4*x[m][1] <= sum(k in m-1..m, l in 1..2) y[k][l];
  4*x[1][n] <= sum(k in 1..2, l in n-1..n) y[k][l];
  4*x[m][n] <= sum(k in m-1..m, l in n-1..n) y[k][l];
*/
  forall(k in 1..p)
    sum(i in 1..m, j in 1..n) log(1-proba[k][i][j]) * x[i][j] <= log(1-alpha[k]);
  
  forall(l in p+1..(p+q))
    sum(i in 1..m, j in 1..n) log(1-proba[l][i][j]) * y[i][j] <= log(1-alpha[l]);
 }
 
 execute{
	for(var i=1; i<=m; i++){
		for(var j=1; j<=n; j++){
		  	if(y[i][j]==1){
		  	  writeln(i);
		  	  writeln(j);
		 	}
		};
		writeln();  
	};  
}



/*********************************************
 * OPL 12.8.0.0 Model
 * Author: dascim
 * Creation Date: Feb 13, 2019 at 3:27:12 PM
 *********************************************/
int P = ...;
int m = ...;
int n = ...;
 
int w1 = ...;
int w2 = ...;
 
float g = ...;
int L = ...;
 
int t[1..m][1..n] = ...;
int adj[1..m][1..n][1..m][1..n];

execute{
	var i, j, k, b;

	for (i=1; i<=m; i++) {
		for (j=1; j<=n; j++){
			for (k=1; k<=m; k++) {
				for (b=1; b<=n; b++) {
					adj[i][j][k][b] = 0;				
					if (Math.abs(k-i)==1 && k!=i && b==j) {
						adj[i][j][k][b] = 1;					
					} 
					if (Math.abs(b-j)==1 && b!=j && k==i) {
						adj[i][j][k][b] = 1;						
					} 							
				}			
			}		
		}	
	}
}

// TU matrice: Point extremes sont entier, donc pas besoin de mettre x, y = int
// quand ajout contraint, plus TU. faut mettre x = int
dvar float+ x[1..m][1..n];
dvar float+ y[1..m][1..n][1..m][1..n];
maximize
  w1 * sum(i in 1..m, j in 1..n) t[i][j] * (1-x[i][j]) + w2 * g * L * sum(i in 1..m, j in 1..n, k in 1..m, b in 1..n)  adj[i][j][k][b] *(x[i][j] - y[i][j][k][b]) + w2 * g * L * sum(i in 1..m) (x[i][1] + x[i][n]) + w2 * g * L * sum(i in 1..n) (x[1][i] + x[m][i]);
subject to{
	forall (i in 1..m, j in 1..n, k in 1..m, b in 1..n: adj[i][j][k][b]==1) {
		1-x[i][j]-x[k][b]+y[i][j][k][b] >= 0;
		y[i][j][k][b]>=0;}
		//y[i][j][k][b]<=x[i][j];
		//y[i][j][k][b]<=x[k][b]; }	
	forall (i in 1..m, j in 1..n) {
		x[i][j] <= 1;	
	}
//	sum (i in 1..m, j in 1..n) x[i][j] >= 60;
} 
//dvar float+ d[1..m][1..n];
//maximize
//  w1 * sum(i in 1..m, j in 1..n) t[i][j] * (1-x[i][j]) + w2 * g * L * sum(i in 1..m, j in 1..n) (4*x[i][j]-d[i][j]);
//subject to {
// forall (i in 1..m, j in 1..n) 
// 	x[i][j] <= 1;
// forall (i in 1..m, j in 1..n)
//    d[i][j] >= sum(k in 1..m, b in 1..n) adj[i][j][k][b] * x[k][b] - sum(k in 1..m, b in 1..n) adj[i][j][k][b] * (1-x[i][j]);
// sum(i in 1..m, j in 1..n) x[i][j] >= 60;   
//}  

execute{
	var eff1 = 0;
	var eff2 = 0; 
	var cons = 0;
	for(var i=1; i<=m; i++) {
		for(var j=1; j<=n; j++) {
			eff1 += w1 * t[i][j] * (1-x[i][j]);
			cons += x[i][j];			
		}	
	}
	//writeln(cons);
	writeln(eff1);
	for(var i=1; i<=m; i++) {
		for(var j=1; j<=n; j++) {
			if (x[i][j]==1) {
				writeln(i, ", ", j);
			}			
		}	
	}
	//writeln(y[9][9]);
}
    

 

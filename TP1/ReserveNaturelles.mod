// LOAD from DAT
//int m = ...;
//int n = ...;
//int p = ...;
//int q = ...;

//float alpha[1..(p+q)] = ...;
//float proba[1..(p+q)][1..m][1..n] = ...;
//int c[1..m][1..n] = ...;
int p = 3;
int q = 3;
float alpha[1..(p+q)] =[0.5,0.5,0.5,0.5,0.5,0.5];
int m = 70;
int n = 70;
int c[1..m][1..n];
float proba[1..(p+q)][1..m][1..n];
float rare_range[1..5] = [0.1, 0.2, 0.3, 0.4, 0.5];
float common_range[1..5] = [0.2, 0.3, 0.4, 0.5, 0.6];
int seed;
execute{
	var now = new Date();
	seed = Opl.srand(Math.round(now.getTime()/1000));
	for (var i=1; i<=m; i++) {
		for (var j=1; j<=n; j++) {
			c[i][j] = Opl.rand() % 10 + 1;
			writeln(c[i][j]);
			for (var k=1; k<=p; k++){
				if (Opl.rand() % 3 == 1) {			
					proba[k][i][j] = rare_range[Opl.rand() % 5 + 1 ];
  				}
  				else {
  				    proba[k][i][j] = 0;				
  				}										
			}
			for (var l=p+1; l<=p+q; l++){
				if (Opl.rand() % 2 == 1) {			
					proba[l][i][j] = common_range[Opl.rand() % 5 + 1];
  				}
  				else {
  				    proba[l][i][j] = 0;				
  				}										
			}
				
		}	
			
	}
}



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

  forall(k in 1..p)
    sum(i in 1..m, j in 1..n) log(1-proba[k][i][j]) * x[i][j] <= log(1-alpha[k]);
  
  forall(l in p+1..(p+q))
    sum(i in 1..m, j in 1..n) log(1-proba[l][i][j]) * y[i][j] <= log(1-alpha[l]);
 }
 
//execute{
//    for(var k=1; k<=p; k++){
//		for(var i=1; i<=m; i++){
//			for(var j=1; j<=n; j++){
//				pro = pro + log(1-proba[k][i][j]) * x[i][j];
//		};
//		writeln(1-exp(pro));  
//	};
//}	  
//}



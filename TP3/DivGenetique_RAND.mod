int N = 8;
int Nm = ftoi(N/2);
int Nf = ftoi(N/2);
int C = 1;
int G = 3;
int A = 2;
int T = 50;
float init = 0.001;

int individu[1..N][1..C][1..G][1..A];
int seed;
execute{
	var now = new Date();
	seed = Opl.srand(Math.round(now.getTime() / 1000));
	for (var k=1; k<=N; k++) {
		for (var i=1; i<=G; i++) {
			for (var j=1; j<=A; j++) {
				individu[k][1][i][j] = Opl.rand() % 2 + 1;	
			}		
		}	
	}
}

int group[1..N][1..G][1..A];

dvar float+ y[1..G][1..A];
dvar int+ x[1..N];
dvar float+ z[1..G][1..A];

execute{
  for (var i=1; i<=N; i++){
    for (var j=1; j<=G; j++){
      if (individu[i][1][j][1] == individu[i][1][j][2]) {
        group[i][j][individu[i][1][j][1]] = 1; 
        group[i][j][3-individu[i][1][j][1]] = -1;
      }      
      else{
        group[i][j][individu[i][1][j][1]] = 0;
        group[i][j][individu[i][1][j][2]] = 0;
        }
      
      }
    }
    writeln(group);
  }
  
  
minimize
  sum(i in 1..G, j in 1..A) y[i][j];
  
subject to {
//  forall (i in 1..G, j in 1..A)
//    y[i][j] <= 1;
  
//  forall (i in 1..G, j in 1..A)
//    z[i][j] <= 1.0;
          
//  forall (i in 1..G, j in 1..A)
//    y[i][j] >= 0;
  
  sum(i in 1..Nm) x[i] == N;
  sum(i in 1..Nm) x[i] == sum(i in Nm+1..N) x[i];
  
  forall (i in 1..N)
    x[i] <= 3;
    
  forall (i in 1..G, j in 1..A)
    y[i][j] >= z[i][j] - sum(k in 1..N : (group[k][i][j] == 1)) x[k];
    
  forall (i in 1..G, j in 1..A)
    forall(r in 1..T)
    	(T-r) * ln(init) / (T-1) -1 + z[i][j] / (pow(init, (T-r)/(T-1))) >= sum(k in 1..N : group[k][i][j]==0) x[k] * ln(0.5); 
}  

 execute{
   	//writeln(group); 
   		var ts = 0;
		for(var i=1; i<=G; i++){
			for(var j=1; j<=A; j++){
				var somme = 1;
				for(var k=1; k<=N; k++){
					if (group[k][i][j]==0){
						somme *= Math.pow(0.5, x[k]);					
					}
					else if (group[k][i][j]==1) {
						somme *= 0;					
					}		
  				}
  				writeln(i, ",", j, ": ", somme);
  				ts += somme;									
			}
		} 
		writeln(ts);
} 
  

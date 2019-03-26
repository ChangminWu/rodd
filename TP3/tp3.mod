/*********************************************
 * OPL 12.5 Model
 * Author: dascim
 * Creation Date: Feb 6, 2019 at 3:05:46 PM
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
float proba[1..N][1..G][1..A];
float filter[1..G][1..A];

range genes = 1..G;
range allele = 1..A;
range human = 1..N;

dvar float+ y[1..G][1..A];
dvar int+ x[1..N];

execute{
  for (var i in human){
  	for (var j in genes){
  		for (var k in allele){
  	  		var nbr = 0;
  	  		for (var m in allele){
  	  		  if (individu[i][1][j][m]==k){
  	  		    nbr += 1;
  	  		    }
  	  		  }
  	  		 proba[i][j][k] = (A-nbr) / A; 
  	  	}
  	}  	 
 }
 
 for (var i in genes) {
   for (var j in allele){
     for (var k in human){
       if (proba[k][i][j]==0){
         filter[i][j] = 0;
         break;
         }
       else{
         filter[i][j] = 1;
         }
       }
     }
   }
}

minimize
  sum(i in 1..G, j in 1..A) y[i][j];
  
subject to {
  forall (i in 1..G, j in 1..A)
    y[i][j] <= 1;
  
  sum(i in 1..Nm) x[i] == N;
  sum(i in 1..Nm) x[i] == sum(i in Nm+1..N) x[i];
  
  forall (i in 1..N)
    x[i] <= 3;
  
  forall (i in 1..G, j in 1..A)
    forall(r in 1..T: filter[i][j] > 0)
      //if (prod(k in human) proba[k][i][j] == 0 ){
        	//y[i][j] >= 0;
      //  }
      //else{ 
    	(T-r) * ln(init) / (T-1) -1 + y[i][j] / (pow(init, (T-r)/(T-1))) >= sum(k in human) x[k] * ln(proba[k][i][j]);
	// }		
}

 execute{
   	//writeln(group); 
		for(var i=1; i<=G; i++){
			for(var j=1; j<=A; j++){
				var somme = 1;
				for(var k=1; k<=N; k++){
						somme *= Math.pow(proba[k][i][j], x[k]);						
  				}
  				writeln(i, ",", j, ": ", somme);									
			}
		} 	
} 

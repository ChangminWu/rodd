/*********************************************
 * OPL 12.5 Model
 * Author: dascim
 * Creation Date: Jan 30, 2019 at 4:00:58 PM
 *********************************************/
int m = ...;
int n = ...;
int B = ...;
int Amin = ...;
int Amax = ...;

range col = 1..m;
range row = 1..n;

int c[1..m][1..n] = ...;
float lambda = ...;

float distance[1..m][1..n][1..m][1..n];

dvar boolean x[1..m][1..n];
dvar boolean y[1..m][1..n][1..m][1..n];
dvar float+ f ;
dvar float+ g ;
 
execute{
	for(var i in col){
		for(var j in row){
		  for(var ii in col){
		    for(var jj in row){
		      distance[i][j][ii][jj] = Math.sqrt(Math.pow(i - ii,2) + Math.pow(j - jj,2));
  			}		 	
		   }
		 }  
	  }   
}

minimize
    f - lambda * g;
    
subject to{
    f == sum(i in col, j in row, ii in col, jj in row: (i!=ii) || (j!=jj)) distance[i][j][ii][jj] * y[i][j][ii][jj];
    g == sum(i in col, j in row) x[i][j];

    sum(i in col, j in row) 10 * c[i][j] * x[i][j] <= B;
    sum(i in col, j in row) x[i][j] <= Amax;
    sum(i in col, j in row) x[i][j] >= Amin;
  	
    forall(i in col, j in row)
  	  forall(ii in col, jj in row)
  	  	 y[i][j][ii][jj] <= x[ii][jj];
  	  	
    forall(i in col, j in row)
         y[i][j][i][j] == 0;
  	  	
    forall(i in col, j in row)
         sum(ii in col, jj in row) y[i][j][ii][jj] == x[i][j];
}

execute{
  //writeln("Distance: ", distance[1][1]);
  for (var i in col) {
    for (var j in row) {
       if (x[i][j] == 1) {
         	//writeln("col: ", i);
         	//writeln("row: ", j);
      		//writeln(y[i][j]);
      }
      }
    }
   
   var s = 0
   for (var i in col) {
    for (var j in row) {
       s += c[i][j] * x[i][j];
      }
    }
   writeln(s);
  }

main{
  	var new_lambda;
  	
	
	var masterDef = thisOplModel.modelDefinition;
    var masterCplex = cplex;
    var masterData = thisOplModel.dataElements;
    
    var masterOpl = new IloOplModel(masterDef, masterCplex);
   	masterOpl.addDataSource(masterData);
   	masterOpl.generate()
   	
   	var curr = 10;
   	
   	while(curr > 0.00){
   	  writeln("Solve master.");
       masterCplex.solve() ;
       masterOpl.postProcess();
        
        curr = masterCplex.getObjValue();
        writeln();
        writeln("MASTER OBJECTIVE: ",curr);
       
     var fx= masterOpl.f;
     var gx= masterOpl.g;
     
     new_lambda = fx / gx;
     masterData.lambda = new_lambda;
     writeln("new fx: ", fx);
     writeln("new gx: ", gx);
     writeln("lambda: ", masterData.lambda);
      
     masterOpl.end();
      
     masterOpl = new IloOplModel(masterDef,masterCplex);
     masterOpl.addDataSource(masterData);
     masterOpl.generate();
   	}     
}

	
	






int NbParcelles = ...;
range Parcelles =1..NbParcelles;
int T = ...;
range Periode=1..T;
int SURF = ...;
int lmax = ...;
int amax = ...;
{int} C[1..2] = ...;
int s[t in Periode]=(t%2==1)?1:2;
{int} Cultures=C[1] union C[2];
int Demande[Cultures][Periode]=...;

tuple sommet{
 int l; //age de la jachere
 int a; // age de la culture
 int j; //culture ou jachere en cours 
 }
 
 
 
{sommet} Sommets=...;

tuple arc {
  sommet i; //extremite initiale
  sommet f; //extremite finale
  int rend;
}  
 
{arc} Arcs=...;

{arc} InitArc=
 {<<2,0,0>,<2,0,0>,0>,
  <<2,0,0>,<2,1,1>,120>
};

dvar boolean x[Parcelles][Periode][Arcs];

minimize
  sum(p in Parcelles, t in Periode, arc in Arcs) x[p][t][arc];
  
subject to {
	forall (t in Periode)
	  sum(p in Parcelles, arc in Arcs: arc.f.j == s[t]) x[p][t][arc] * arc.rend >= Demande[s[t]][t];
	
	forall (p in Parcelles)
		  sum(arc in InitArc) x[p][1][arc] <= 1;
		  
	forall (p in Parcelles)
	  sum(arc in InitArc) x[p][1][arc] == sum(arc in Arcs) x[p][1][arc];
	  
	forall (p in Parcelles)
	  forall (t in Periode: t<T)
	    forall (node in Sommets)
	    	sum(arc in Arcs: arc.f==node) x[p][t][arc] == sum(arc in Arcs: arc.i==node) x[p][t+1][arc];
}

execute{
  var obj = 0;	
  for (var i in Parcelles) {
    for (var j in Periode) {
    	for (var k in Arcs) {
    		obj+=x[i][1][k];
    	}    
      }
    }
   writeln(obj/T);
  }
#include <ilcplex/ilocplex.h>
#include <string>
#include <iostream>
#include <sstream>
#include <fstream>
#include <cstdlib>
#include <cmath>
#include <chrono> 
using namespace std;

ILOSTLBEGIN

typedef IloArray<IloNumVarArray> DataMatrix;
typedef IloArray<IloNumArray> SolMatrix;
typedef IloArray<IloBoolVarArray> BoolMatrix;

int main(int argc, char **argv) {
    IloEnv env;
    auto start = chrono::high_resolution_clock::now();
    int i, j, k;
    float readFloat;
    
    IloInt T;
    IloInt M;
    IloInt R;
    IloNum E_MAX;
    IloNum h;
    IloNum pt_m;

    IloNumArray f;
    IloNumArray e;
    IloNumArray dt;
    
    try{
        if (argc > 1) {
            T = atoi(argv[1]);
            M = atoi(argv[2]);
            R = atoi(argv[3]);
            E_MAX = atof(argv[4]);
            h = atof(argv[5]);
            pt_m = atof(argv[6]);

            f = IloNumArray(env);
            istringstream istream(argv[7]);
            for (i=0; i<M; i++){
                istream >> readFloat; 
                f.add(readFloat);
            }

            e = IloNumArray(env);
            istringstream istream1(argv[8]);
            for (i=0; i<M; i++){
                istream1 >> readFloat; 
                e.add(readFloat); 

            }

            dt = IloNumArray(env);
            istringstream istream2(argv[9]);
            for (i=0; i<T; i++){
                istream2 >> readFloat;
                dt.add(readFloat);
            }
        }
        else {
            T = 10;
            M = 4;
            R = 3;
            E_MAX = 3;
            h = 1;
            pt_m = 0;
            dt = IloNumArray(env, T, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65);
            f = IloNumArray(env, M, 10, 30, 60, 90);
            e = IloNumArray(env, M, 8, 6, 4, 2);
        }
        
        DataMatrix x(env, T);
        for (i=0; i<T; i++) {
            x[i] = IloNumVarArray(env, M, 0.0, IloInfinity);
        }

        IloNumVarArray s = IloNumVarArray(env, T, 0.0, IloInfinity);

        BoolMatrix y(env, T); 
        for (i=0; i<T; i++) {
            y[i] = IloBoolVarArray(env, M);
        }

        IloModel model(env);

        IloExpr objective(env);
        for (i=0; i<T; i++) {
            for (j=0; j<M; j++) {
                objective += pt_m * x[i][j] + f[j] * y[i][j];
            }
            objective += h * s[i];
        }

        IloObjective obj(env, objective, IloObjective::Minimize);
        model.add(obj);

        for (i=0; i<T; i++) {
            IloExpr equa(env);
            for (j=0; j<M; j++) {
                equa += x[i][j];
            }
            if (i>0) {
                equa += s[i-1] - s[i];
            }
            else {equa -= s[i];}
            model.add(equa == dt[i]);
            equa.end();
        }

        for (i=0; i<T; i++) {
            for (j=0; j<M; j++) {
                IloExpr inequa(env);
                for (k=i; k<T; k++) {
                    inequa += dt[k] * y[i][j];
                }
                model.add(x[i][j]<=inequa);
                inequa.end();
            }
        }

        for (i=0; i<=T-R; i++) {
            IloExpr inequa(env);
            for (j=0; j<M; j++) {
                for (k=i; k<i+R; k++) {
                    inequa += (e[j] - E_MAX) * x[k][j];
                }
            }
            model.add(inequa<=0);
            inequa.end();
        }

        IloCplex cplex (model);
        cplex.setOut(env.getNullStream());
        cplex.setWarning(env.getNullStream());

        if ( cplex.solve() ) {
            auto finish = chrono::high_resolution_clock::now();
            chrono::duration<double> elapsed = finish - start;
            IloAlgorithm::Status solStatus= cplex.getStatus();

            SolMatrix xSol(env, T);
            for (i=0; i<T; i++) {
                xSol[i] = IloNumArray(env, M);
                cplex.getValues(xSol[i], x[i]);
            }

            float emission_sum = 0;
            float prod_sum = 0;

            for (i=0; i<T; i++) {
                for (j=0; j<M; j++) {
                    emission_sum += xSol[i][j] * e[j];
                    prod_sum += xSol[i][j];
                }
            }

            float mean_emission = emission_sum / prod_sum;

            env.out() << "Solution status:" << solStatus << endl;
            env.out() << "Total cost:"  << cplex.getObjValue() << endl;
            env.out() << "Mean emission:"  << mean_emission << endl;
            env.out() << "Taken time:" << elapsed.count() << " s" << endl;
        }

        else {
            env.out() << endl << "Solution status:" << "No solution available" << endl;
        }
    }
    catch (IloException& e) {
        cerr << "Concert exception caught: " << e << endl;
    }
    catch (...) {
        cerr << "Unknown exception caught" << endl;
    }
    
    env.end();
    return 0;
}

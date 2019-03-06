import os
import subprocess
import time 
import pandas as pd 
import glob
import numpy as np
import pickle
import copy
import random 
import matplotlib as mpl
mpl.use('Agg')
import matplotlib.pyplot as plt
import seaborn as sns

def process_output(output_text):
    data = {"status": np.NaN, "cost": np.NaN,  "emission": np.NaN, "time": np.NaN}
    info_list = output_text.split("\n")
    for info in info_list:
        temp = info.split(":")
        if temp[0] == "Solution status":
            data["status"] = temp[1]
        elif temp[0] == "Total cost":
            data["cost"] = float(temp[1])
        elif temp[0] == "Mean emission":
            data["emission"] = float(temp[1])
        elif temp[0] == "Taken time":
            data["time"] = float(temp[1].split(" ")[0])

    return data

def main(Ts, Ms, E_MAXs, h=1, pt_m=0):
    for T in Ts:
        dt = np.random.uniform(20,70,T)
        Rs = np.arange(1,T+1)
        np.savetxt("./parameters/T-{}-dt.txt".format(T), dt)
        for M in Ms:
            f = [10,30,60,90]
            e = [8,6,4,2]
            if len(f) != M:
                for _ in range(len(f), M):
                    f.append(np.random.randint(low=10, high=90))
                    e.append(np.random.randint(low=2, high=8))    
            np.savetxt("./parameters/M-{}-dt.txt".format(M), (f,e))
            if M!=4 and T!=10:
                break
            for E_MAX in E_MAXs:
                fname = "{}-{}-{}".format(T,M,E_MAX)
                print(fname)
                df = pd.DataFrame(0, index=np.arange(T), columns=["intervalle", "cost", "emission", "time"])
                for idx, R in enumerate(Rs):
                    commande = ([str(T)]  + [str(M)]  + [str(R)]  + [str(E_MAX)] 
                                + [str(h)]  + [str(pt_m)]  + [" ".join(map(str, f))]  + [" ".join(map(str, e))]  + [" ".join(map(str, dt))])
                    output = subprocess.Popen(["./lot_sizing"] + commande, stdout=subprocess.PIPE, shell=False).communicate()
                    text = output[0].decode("utf-8")
                    data = process_output(text)  

                    cost = data["cost"]
                    emission = data["emission"]
                    tiC = data["time"]

                    df.loc[idx, "intervalle"] = R
                    df.loc[idx, "cost"] = cost
                    df.loc[idx, "emission"] = emission
                    df.loc[idx, "time"] = tiC
                
                df.to_csv("./results/" + fname + ".csv")

                rs = df["intervalle"].values
                cost = df["cost"].values
                emission = df["emission"].values
                fig, ax1 = plt.subplots(figsize=(20, 10))
                color = 'tab:red'
                ax1.grid()
                ax1.set_xlabel("Longueur de l’intervalle", fontsize=20)
                ax1.tick_params(axis='x', labelsize=15)
                ax1.set_ylabel('Coût', color=color, fontsize=20)
                l1 = ax1.plot(rs, cost, color=color, label="coût total")
                ax1.tick_params(axis='y', labelcolor=color, labelsize=15)

                ax2 = ax1.twinx() 

                color = 'tab:blue'
                ax2.set_ylabel('Emission', color=color, fontsize=20)  # we already handled the x-label with ax1
                l2 = ax2.plot(rs, emission, color=color, label="l'émission moyen")
                ax2.tick_params(axis='y', labelcolor=color, labelsize=15)

                plt.title("L’évolution du coût total et l’émission moyen en fonction de la longueur de l’intervalle", fontsize=20)
                lns = l1+l2
                labs = [l.get_label() for l in lns]
                ax1.legend(lns, labs, fontsize=15, loc=9)

                fig.tight_layout() 
                fig.savefig("./graphs/" + fname + ".png", dpi=600)
                plt.close()

if __name__ == "__main__":
    Ts = [10, 12, 15, 20, 25, 30, 40, 50]
    Ms = [4, 5, 6, 8, 10]
    E_MAXs = [3,3.5,4,4.5,5,5.5,6,7,8,10]
    main(Ts=Ts, Ms=Ms, E_MAXs=E_MAXs, h=1, pt_m=0)



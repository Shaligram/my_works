#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd # powerful data visualization library
import numpy as np
import matplotlib.pyplot as plt # allows us to plot things
import csv # allows us to import and use CSV commands which are simple but effective
import seaborn as sns #https://seaborn.pydata.org/generated/seaborn.boxplot.html
# This website saved my life https://www.pythonforengineers.com/introduction-to-pandas/
# use this to check the available styles: plt.style.available
from statsmodels.tsa.seasonal import seasonal_decompose
from dateutil.parser import parse

plot_dir = "/tmp/"

plot_dir = input("Enter the output directory:")

csv_file = "./proxy_ue.csv"


csv_file = plot_dir + csv_file

def plotter():
    x = []
    y = []

    new_data = pd.read_csv(csv_file, skiprows=[i for i in range(0,0)], usecols=usecols) #skiprows allows you to skip the comments on top... & ecoding allows pandas to work on this CSV
    #new_data = data.loc[[flow_list]]
    
    # Multiplicative Decomposition 
   # result_mul = seasonal_decompose(new_data['sum_bps'], model='multiplicative', extrapolate_trend='freq')
    #df_ma = new_data.value.rolling(3, center=True, closed='both').mean()
    #df_ma.plot(ax=axes[3], title='Moving Average (3)')

    #plt.rcParams.update({'figure.figsize': (10,10)})
    #result_mul.plot().suptitle('Multiplicative Decompose', fontsize=22)
    #plt.show()

    
    sns.set(style="whitegrid") 
    ax = sns.lineplot(x='logId', y='session_bps', data=new_data, color="0.25") 
    plt.plot(x, y, label='Loaded from file!')
    plt.savefig(plot_dir + "session-bps")
    plt.show() # shows the plot to the user
    
    ax = sns.lineplot(x='logId', y='sum_bps', data=new_data, color="0.50") 
    plt.plot(x, y, label='Loaded from file!')
    plt.savefig(plot_dir + "sum-bps")
    
    
 #   df_T = pd.DataFrame(df.iloc[:,7])
 #   df_T['CMA_4'] = df_T.expanding(min_periods=4).mean()
    
    #new_data['EMA'] = new_data.iloc[:,5].ewm(span=40,adjust=False).mean()
    #ax = sns.lineplot(x='logId', y='EMA',  data=new_data, ci=None) 
    #plt.show()
    
    new_data['CMA'] = new_data.iloc[:,5].expanding(min_periods=10).mean() 
    
    #new_data.to_csv('/tmp/cma')
    ax = sns.lineplot(x='logId', y='CMA',  data=new_data, ci=None) 
    plt.savefig(plot_dir + "sum-bps")
    plt.show()
    

def plot_flows(): 

    for flow_list in flows:
     print ("Plots for {} for flow_bps".format(flow_list))
     x = []
     y = []
     x.clear();
     y.clear();

     data = pd.read_csv(csv_file, encoding="ISO-8859-1", skiprows=[i for i in range(0,0)], index_col="remote->local",usecols=usecols) #skiprows allows you to skip the comments on top... & ecoding allows pandas to work on this CSV
     new_data = data.loc[[flow_list]]
     #print(((new_data)) )
    
     sns.set(style="whitegrid") 
     ax = sns.lineplot(x='logId', y='flow_bps',  data=new_data, ci=None) 
    
     #plt.figure()
     #plt.subplot(2,2,1)
     #plt.plot(x, y, label='Loaded from file!')
     plt.title(flow_list)
     plt.savefig(plot_dir + flow_list)
     #plt.show() # shows the plot to the user


 

sns.set(rc={'figure.figsize':(10,5)}) #resize plot graphs


range1 = [i for i in range(1,5)]
range2 = [i for i in range(9,16)]
usecols = range1 + range2

data = pd.read_csv(csv_file)
flows = data['remote->local'].unique()
print(((flows)) )


plotter()
#plot_flows()
#plt.show()


# 

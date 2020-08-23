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

plot_dir = "/tmp/exp/750/"


#plot_dir = input("Enter the output directory")

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
    plt.xlabel('Mbps') 
    plt.legend() 
    
    sns.set(style="whitegrid") 
    ax = sns.lineplot(x='logId', y='session_bps', data=new_data, color="0.25") 
    plt.plot(x, y, label="session_bps")
    plt.savefig(plot_dir + "session-bps")
    

    #plt.show() # shows the plot to the user
    
    ax = sns.lineplot(x='logId', y='sum_bps', data=new_data, color="0.50") 
    plt.plot(x, y, label="sum_bps")
    plt.savefig(plot_dir + "sum-bps")
    
    
 #   df_T = pd.DataFrame(df.iloc[:,7])
 #   df_T['CMA_4'] = df_T.expanding(min_periods=4).mean()
    
    #new_data['EMA'] = new_data.iloc[:,5].ewm(span=40,adjust=False).mean()
    #ax = sns.lineplot(x='logId', y='EMA',  data=new_data, ci=None) 
    #plt.show()
    
    new_data['CMA'] = new_data.iloc[:,5].expanding(min_periods=10).mean() 
    
    #new_data.to_csv('/tmp/cma')
    #ax = sns.lineplot(x='logId', y='CMA',  data=new_data, ci=None) 
    #plt.savefig(plot_dir + "sum-bps")
    
    plt.show()
    

def plot_flows(): 

    #constant
    my_style = ["whitegrid", "dark"]
    max_row_per_page = 10
    pending_graphs = 0
    sns.set(rc={'figure.figsize':(20,2*max_row_per_page)}) #resize plot graphs
    sns.set(style="whitegrid") 
    fig, axes = plt.subplots(nrows=max_row_per_page, ncols=1)    
    total_flow_count = 0
    
    for flow_list in flows:
     print ("Plots for {} for flow_bps".format(flow_list))
     x = []
     y = []

     data = pd.read_csv(csv_file, encoding="ISO-8859-1", skiprows=[i for i in range(0,0)], index_col="remote->local",usecols=usecols) #skiprows allows you to skip the comments on top... & ecoding allows pandas to work on this CSV
     new_data = data.loc[[flow_list]]
     #print(((new_data)) )
    
    # plt.figure()
     

     sns.set(style=my_style[total_flow_count%2])
     ab = sns.lineplot(x='logId', y='flow_bps',  data=new_data, ax=axes[total_flow_count] )
     
     #ab.set(xlabel=flow_list)
     #ab.set_title(flow_list, fontsize=10)
     ab.axes.set_title(flow_list,fontsize=10)
     ab.set_ylabel("flow_bps",fontsize=10)
     ab.set_xlabel("logId",fontsize=10)
     #
     
     #plt.savefig(plot_dir + flow_list)
     if total_flow_count == max_row_per_page-1:
        #ab.plot()
        plt.suptitle("flow_bps vs logId")
        plt.savefig(plot_dir + flow_list)
        plt.show() # shows the plot to the user
        fig, axes = plt.subplots(nrows=max_row_per_page, ncols=1)    
        print ("done plotting 3 ")
        total_flow_count = 0
        pending_graphs = 0
        #break;
     else:
        total_flow_count += 1
        pending_graphs = 1
     
     #plt.show()
    #end of for loop
    if pending_graphs == 1:
        print ("last plot")
        plt.savefig(plot_dir + flow_list)
     
 


 

#sns.set(rc={'figure.figsize':(10,5)}) #resize plot graphs


range1 = [i for i in range(1,5)]
range2 = [i for i in range(9,16)]
usecols = range1 + range2

data = pd.read_csv(csv_file)
flows = data['remote->local'].unique()
#print(((flows)) )
print ("\ntotal flows present : ",flows.size )

#plotter()
plot_flows()
#plt.show()


# In[2]:


import matplotlib.pyplot as plt
#   plot 0     plot 1    plot 2   plot 3
x=[[1,2,3,4],[1,4,3,4],[1,2,3,4],[9,8,7,4]]
y=[[3,2,3,4],[3,6,3,4],[6,7,8,9],[3,2,2,4]]

plots = zip(x,y)

def loop_plot(plots):
    figs={}
    axs={}
    for idx,plot in enumerate(plots):
        figs[idx]=plt.figure()
        axs[idx]=figs[idx].add_subplot(111)
        axs[idx].plot(plot[0],plot[1])
    return figs, axs

figs, axs = loop_plot(plots)
axs[0].set_title("Now I can klhrdcontrol it!")

fig, axs = plt.subplots(nrows=3, ncols=1)


# In[3]:


import seaborn as sns
import numpy as np
 
# Data
data = np.random.normal(size=(20, 6)) + np.arange(6) / 2
 
# Proposed themes: darkgrid, whitegrid, dark, white, and ticks
 
sns.set_style("darkgrid")
sns.boxplot(data=data);
plt.title("darkgrid")
 
sns.set_style("white")
sns.boxplot(data=data);
plt.title("white")
 
sns.set_style("dark")
sns.boxplot(data=data);
plt.title("dark")
 
sns.set_style("ticks")
sns.boxplot(data=data);
plt.title("ticks")


# In[ ]:





# In[ ]:





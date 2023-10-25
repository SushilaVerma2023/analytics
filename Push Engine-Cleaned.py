#!/usr/bin/env python
# coding: utf-8

# Student Table

# In[ ]:


import pandas as pd
####fetching data from qb"
import psycopg2
try:
    connection = psycopg2.connect(
        dbname='prod',
        user='sushila_verma',
        password='Sushila_verma_pw1!',
        host='allendigital-prod.cze9tl5zevtk.ap-south-1.redshift.amazonaws.com',
        port='5439'
    )
    print("Connection established successfully!")
except Exception as e:
    print("Error:", e)
cursor = connection.cursor()
query = '''Select * from analytics.dummy_attendance_tobedeleted
'''
cursor.execute(query)
result = cursor.fetchall()
# cursor.close()
# connection.close()
# print("Connection closed.")

##creating dataframe
df = pd.DataFrame(result)
# adding column name to the respective columns
df.columns =['student_id','batch_id','center','student_name','enrollment_no','gender','student_stream','course_name'
             ,'student_class','questions_60d','questions_30d','questions_10d','questions_7d','attendance_7d','attendance_10d','attendance_30d', 'attendance_60d', 'attendance_90d', 'class_count','faculty_count','avg_actual_class_duration','avg_student_duration','avg_class_duration','attendance_per',]
df.head()


# importing G Sheet

# In[ ]:


pip install pygsheets


# In[ ]:


import gspread
from oauth2client.service_account import ServiceAccountCredentials

# Set the path to your credentials JSON file
credentials_path = '/Users/sushilaverma/Downloads/project-allen-402506-88848b400419.json'

# Connect to Google Sheets using your credentials
scope = ['https://spreadsheets.google.com/feeds', 'https://www.googleapis.com/auth/drive']
creds = ServiceAccountCredentials.from_json_keyfile_name(credentials_path, scope)
client = gspread.authorize(creds)

# Open the Google Sheet by title
sheet = client.open('behaviour shaping')

# Select a specific worksheet by title
worksheet = sheet.worksheet('Rule_Template')

# Fetch data from the worksheet
data = worksheet.get_all_records()

# Print the data
for row in data:
    print(row)


# In[ ]:


pip install oauth2client


# In[ ]:


data


# In[ ]:


data=pd.DataFrame(data)


# Changing the Format of the Template Rule

# In[ ]:


pd.set_option('display.html.use_mathjax', False)


# In[ ]:


data


# In[ ]:


#Cheching Student Table here (reading all Columns here)

pd.set_option('display.max_columns', None)
df


# Replacing and fetching the Values from Rule_Template

# In[ ]:


def final_text(text,df):
    #print(df)
    numbers=[] 
    for x in range(len(text)-1):
        if (text[x]=="<") & (text[x+1]=="$") :
            numbers.append(x+1)
        elif (text[x]=="$") & (text[x+1]==">"):
            numbers.append(x)
            cols=[]
    for x in range(0,len(numbers),2):
        y=x+1
        #print(text[numbers[x]+1:numbers[y]])
        cols.append(text[numbers[x]+1:numbers[y]])
    #print(df[cols])
    for x in cols:
        text=text.replace(x,str(df[x]))
    text=text.replace("<$","")
    text=text.replace("$>","")
    return text
    


# Changing the Meta Data to json for the output

# In[ ]:


def meta_data(meta,df):
    meta=eval(meta)
    print(meta)
    meta_json={}
    for x in meta: 
        meta_json[x]=df[x]
    return meta_json


# In[ ]:


data=data.head(4)
data


# In[ ]:


df2=df.copy()
df2


# In[ ]:


final_df=pd.DataFrame()
for x in data.index:
    #print(x)
    #col=data.loc[x,"Column_name"]
    value=data.loc[x,"Ideal Value"]
    #comparison=data.loc[x,"comparison"]
    Rule_Template=data.loc[x,"Rule_Template"]
    rule_boolean=data.loc[x,"rule_boolean"]
    metadata=data.loc[x,"Meta Data"]
    df3=df2.query(rule_boolean)      
    df3["message"]=df3.apply(lambda x: final_text(Rule_Template,x),axis=1)
    df3["meta_data"]=df3.apply(lambda x: meta_data(metadata,x),axis=1)
    final_df=final_df.append(df3)


# FINAL OUTPUT

# In[ ]:


final_df


# CHECKS

# In[ ]:


final_df.loc[9,"meta_data"]


# In[ ]:


df3


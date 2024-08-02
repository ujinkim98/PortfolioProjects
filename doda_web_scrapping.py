import csv
import requests
from bs4 import BeautifulSoup

file_name = "C:\\Users\\ujinkim\\Downloads\\shared\\Data_Job_list.csv"
f = open(file_name, "w", encoding="utf-8-sig", newline="")
writer = csv.writer(f)

columns_name = ["Company Name", "Summary"]
writer.writerow(columns_name)

url = "https://doda.jp/DodaFront/View/JobSearchList.action?pr=13&oc=020602S%2C0320M&ss=1&op=17&pic=1&ds=0&tp=1&bf=1&mpsc_sid=10&oldestDayWdtno=0&leftPanelType=1&usrclk_searchList=PC-logoutJobSearchList_searchConditionArea_locModal_kyujinSearchButton-ocM-ocS-locPrefecture-employment"
res = requests.get(url)
res.raise_for_status()
soup = BeautifulSoup(res.text, "lxml")

#name = soup.select('a._JobListToDetail > span.company.width688')
#summary = soup.select('a._JobListToDetail > span.job.width688')
#for i in range(len(name)):
    #data=[name[i].text,summary[i].text]
    #print(data)

role_dt = soup.select('dl.listJpbSpec02.clrFix > dt')
role_dd = soup.select('dl.listJpbSpec02.clrFix > dd')
print(len(role_dt))

data = [None]*6

for i in range(len(role_dt)):        
    if(role_dt[i].text == '仕事内容'):
        data[0] = role_dd[i].text
        #count0 = count0 + 1
    elif(role_dt[i].text == '対象'):
        data[1] = role_dd[i].text
        #count1 = count1 + 1
    elif(role_dt[i].text == '勤務地'):
        data[2] = role_dd[i].text
        #count2 = count2 + 1
    elif(role_dt[i].text == '最寄り駅'):
        data[3] = role_dd[i].text
        #count3 = count3 + 1
    elif(role_dt[i].text == '給与'):
        data[4] = role_dd[i].text
        #count4 = count4 + 1
    elif(role_dt[i].text == '事業概要'):
        data[5] = role_dd[i].text
        writer.writerow(data)
        data = [None]*6
        #count5 = count5 + 1
"""
    if(count0 == 0):
        data[0] = None
        count0 = count0 + 1
    if(count1 == 0):
        data[1] = None
        count1 = count1 + 1
    if(count2 == 0):
        data[2] = None
        count2 = count2 + 1
    if(count3 == 0):
        data[3] = None
        count3 = count3 + 1
    if(count4 == 0):
        data[4] = None
        count4 = count4 + 1
    if(count5 == 0):
        data[5] = None
        count5 = count5 + 1
    if(count0 == 1 && count1 == 1 && count2 == 1 && count3 == 1 && count4 == 1 && count5 == 1):
        writer.writerow(data)
        count0 = 0
        count1 = 0
        count2 = 0
        count3 = 0
        count4 = 0
        count5 = 0



name = soup.select('a._JobListToDetail > span.company.width688')
name_array = []
for i in range(len(name)):
    name_array.append(name[i].text)
for i in range(len(name_array)):
    print(name_array[i])

summary = soup.select('a._JobListToDetail > span.job.width688')
summary_array = []
for i in range(len(summary)):
    summary_array.append(summary[i].text)
for i in range(len(summary_array)):
    print(summary_array[i])

for i in range(len(name_array)):
    data=[name_array[i],summary_array[i]]
    print(data)
    writer.writerow(data)
"""
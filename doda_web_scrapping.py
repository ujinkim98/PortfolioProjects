# I can improve this code by using selenium so that I can open the webpage of specific recruit and bring more detailed info. 

import math
import csv
import requests
from bs4 import BeautifulSoup

file_name = "C:\\Users\\ujinkim\\Downloads\\shared\\Data_Jobs_list.csv"
f = open(file_name, "w", encoding="utf-8-sig", newline="")
writer = csv.writer(f)

columns_name = ["Company Name", "Role Summary", "Role", "Target Candidate", "Location", "Close Subway Station", "Salary", "Business Summary"]
writer.writerow(columns_name)

url = "https://doda.jp/DodaFront/View/JobSearchList.action?pr=13&oc=020602S%2C0320M&ss=1&op=17&pic=1&ds=1&tp=1&bf=1&mpsc_sid=10&oldestDayWdtno=0&leftPanelType=1&usrclk_searchList=PC-logoutJobSearchList_searchResultHeaderArea_sortConditions_newArrival"
res = requests.get(url)
res.raise_for_status()
soup = BeautifulSoup(res.text, "lxml")
soup1 = BeautifulSoup(res.content, "lxml")

#print(soup1)
print(soup1.select("a[href]"))

"""
name = soup.select('a._JobListToDetail > span.company.width688')
summary = soup.select('a._JobListToDetail > span.job.width688')
role_category = soup.select('dl.listJpbSpec02.clrFix > dt')
role_content = soup.select('dl.listJpbSpec02.clrFix > dd')
# len(name) = len(summary) = 50
# len(role_category) = len(role_content) = 296

data = [None]*8
j = 0

for i in range(len(name)):
    data[0] = name[i].text
    data[1] = summary[i].text
    while(True):
        if(role_category[j].text == '仕事内容'):
            data[2] = role_content[j].text
            j = j + 1
        elif(role_category[j].text == '対象'):
            data[3] = role_content[j].text
            j = j + 1
        elif(role_category[j].text == '勤務地'):
            data[4] = role_content[j].text
            j = j + 1
        elif(role_category[j].text == '最寄り駅'):
            data[5] = role_content[j].text
            j = j + 1
        elif(role_category[j].text == '給与'):
            data[6] = role_content[j].text
            j = j + 1
        elif(role_category[j].text == '事業概要'):
            data[7] = role_content[j].text
            j = j + 1
            break
    writer.writerow(data)
    data = [None]*8

total_jobs_number = soup.select('div.boxLeft.clrFix > p.counter > span.number')
total_jobs_number_int = int(total_jobs_number[0].text.replace(',',''))
page_number_float = total_jobs_number_int/50.0
page_number_int = math.ceil(page_number_float)

for k in range(2, page_number_int+1):
    next_urls=f"https://doda.jp/DodaFront/View/JobSearchList.action?pr=13&pic=1&ds=1&oc=0320M%2C020602S&so=50&op=17&pf=0&tp=1&page={k}&prsrt=1"
    res = requests.get(next_urls)
    res.raise_for_status()
    soup = BeautifulSoup(res.text, "lxml")

    name = soup.select('a._JobListToDetail > span.company.width688')
    summary = soup.select('a._JobListToDetail > span.job.width688')
    role_category = soup.select('dl.listJpbSpec02.clrFix > dt')
    role_content = soup.select('dl.listJpbSpec02.clrFix > dd')

    data = [None]*8
    j = 0

    for i in range(len(name)):
        data[0] = name[i].text
        data[1] = summary[i].text
        while(True):
            if(role_category[j].text == '仕事内容'):
                data[2] = role_content[j].text
                j = j + 1
            elif(role_category[j].text == '対象'):
                data[3] = role_content[j].text
                j = j + 1
            elif(role_category[j].text == '勤務地'):
                data[4] = role_content[j].text
                j = j + 1
            elif(role_category[j].text == '最寄り駅'):
                data[5] = role_content[j].text
                j = j + 1
            elif(role_category[j].text == '給与'):
                data[6] = role_content[j].text
                j = j + 1
            elif(role_category[j].text == '事業概要'):
                data[7] = role_content[j].text
                j = j + 1
                break
        writer.writerow(data)
        data = [None]*8
"""

'''
    import requests
    from bs4 import BeautifulSoup
    
    # initialize the list of discovered urls
    # with the first page to visit
    urls = ["https://www.scrapingcourse.com/ecommerce/"]
    
    # until all pages have been visited
    while len(urls) != 0:
        # get the page to visit from the list
        current_url = urls.pop()
        
        # crawling logic
        response = requests.get(current_url)
        soup = BeautifulSoup(response.content, "html.parser")
    
        link_elements = soup.select("a[href]")
        for link_element in link_elements:
            url = link_element['href']
            if "https://www.scrapingcourse.com/ecommerce/" in url:
                urls.append(url)
'''
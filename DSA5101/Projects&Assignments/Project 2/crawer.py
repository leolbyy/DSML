import re
import requests
from bs4 import BeautifulSoup
import os
import socket
import urllib.request
import pandas as pd
import multiprocessing


data = []
url = 'https://www.imdb.com/chart/top/'


socket.setdefaulttimeout(15)

opener = urllib.request.build_opener()
opener.addheaders = [('User-Agent', 'Mozilla/5.0')]
urllib.request.install_opener(opener)

session = requests.session()
headers = {'User-Agent': 'Mozilla/5.0'}
response = session.get(url, headers=headers)
webpage = response.text
soup = BeautifulSoup(webpage, 'html.parser')

prefix = "https://www.imdb.com/"

tops = soup.find_all('td', {"class":"titleColumn"})



def get_data(top):
    ranking = int(top.get_text().strip().split('.')[0])

    item_url = prefix + top.find('a').get('href')
    item_response = requests.session().get(item_url, headers=headers)
    item_webpage = item_response.text
    item_soup = BeautifulSoup(item_webpage, 'html.parser')

    title = item_soup.find('h1', {"data-testid":"hero-title-block__title"})
    poster = item_soup.find('img', {'class':'ipc-image'}).get('src')
    duration = item_soup.find('ul', {'data-testid':'hero-title-block__metadata'}).find_all('li')[2].get_text()

    # get grading in Singapore
    grading_url = prefix + item_soup.find('ul', {'data-testid':'hero-title-block__metadata'}).find_all('li')[1].find('a').get('href')
    grading_soup = BeautifulSoup(session.get(grading_url, headers=headers).text, 'html.parser')
    all_gradings = [i.get_text() for i in grading_soup.find('section', {'id':'certificates'}).find('ul', {'class':'ipl-inline-list'}).find_all('a')]
    singapore_gradings = [i.split(':')[-1] for i in all_gradings if 'Singapore' in i]
    if len(singapore_gradings) == 0: 
        grading = None
    else:
        grading = singapore_gradings[-1]

    return [title, poster, duration, grading]


pool = multiprocessing.Pool(5)
result = pool.map(get_data, tops)
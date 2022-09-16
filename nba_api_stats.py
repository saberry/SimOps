from bs4 import BeautifulSoup
import multiprocessing
import numpy as np
import pandas as pd
import re
import requests
import time

link = "https://stats.nba.com/stats/leaguegamelog"

headers = {"Accept" : "application/json, text/plain, */*", 
  "Accept-Encoding" : "gzip, deflate, br",
  "Accept-Language" : "en-US,en;q:0.5",
  "Connection" : "keep-alive",
  "DNT" : "1",
  "Host" : "stats.nba.com",
  "Origin" : "https://www.nba.com",
  "Referer" : "https://www.nba.com/",
  "Sec-Fetch-Dest" : "empty",
  "Sec-Fetch-Mode" : "cors",
  "Sec-Fetch-Site" : "same-site",
  "User-Agent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:104.0) Gecko/20100101 Firefox/104.0", 
  "x-nba-stats-origin" : "stats",
  "x-nba-stats-token" : "true",
  'Pragma' : 'no-cache',
  'Cache-Control' : 'no-cache'
}

params = {"Counter": "0",
  "DateFrom": "", 
  "DateTo": "",
  "Direction": "DESC",
  "LeagueID": "00", 
  "PlayerOrTeam": "P",
  "Season": "2021-22",
  "SeasonType": "Regular Season", 
  "Sorter": "DATE"
}

nba_data = requests.get(link, params=params, headers=headers)

nba_json = nba_data.json()

nba_results = nba_json['resultSets']

column_names = nba_results[0].get('headers')

out = pd.json_normalize(nba_results, 'rowSet')

out.columns = column_names

out.to_csv("nba_data.csv")

box_scores = pd.read_csv("C:/Users/sberry5/Documents/teaching/SimOps/nba_data.csv")

player_ids = box_scores['PLAYER_ID'].unique()

info_list = []

def player_info_func(player_id_num):
  time.sleep(np.random.uniform(.5, 2))

  base_link = "https://www.nba.com/player/"

  player_link = base_link + str(player_id_num)

  player_request = requests.get(player_link)
  
  player_soup = BeautifulSoup(player_request.content)
  
  player_info = player_soup.select_one("p[class*='PlayerSummary_main']")
  
  if player_info != None:
  
    player_info = player_info.text
  
    player_position = re.findall("[A-z]+-?[A-z]+$", player_info)[0]
  
    player_dict = {'position': player_position, "PLAYER_ID": player_id_num}
  
    player_df = pd.DataFrame(player_dict, index=[0])
  
    info_list.append(player_df)

for i in player_ids:
  player_info_func(i)

all_data = pd.concat(info_list)


box_scores = box_scores.join(all_data, lsuffix = "_box", rsuffix = "_position")

all_data.to_csv("C:/Users/sberry5/Documents/teaching/SimOps/nba_positions.csv")

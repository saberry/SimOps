import pandas as pd
import requests

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

params = {"Counter": "100",
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
out.to_csv("~/Documents/SimOps/nba_data.csv")
pd.DataFrame.to

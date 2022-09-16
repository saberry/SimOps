library(furrr)
library(future)
library(httr)
library(rvest)

player_stats <- read.csv("nba_data.csv")

player_ids <- unique(player_stats$PLAYER_ID)

plan(strategy = multisession, workers = availableCores() - 1)

cookie <- c("ak_bmsc" = "CD7BD332DF526F8928B9D03EE7EC78B2~000000000000000000000000000000~YAAQJ6tZaGxYUPyCAQAAhlEOQhHWEAh7ewjDKBy0O2E61/AvOVItAfumnFn6xP18offNT61csUV1nZCY7c4A4LUylTlOo2XAGvQaeGkEQj4mRI2aBbBMRDadqaGO/IliYfVW67anRjWyvOUsv1neEZEJY5P86G5VD33ZEXrsZJ79zyugEhEjlrp9ItlR1wAla5N+2hIcnIJU5n8pmuSfIv+J9xulSyCH24wJ5fwCihbb+WpZglFQxDRmK921/i5LRufynQ0PcmI5q09QnxMt/iPuPrLQN3oASDdHCtTlR32R49ZrAgdnPATNNMq3htKjCpPFwZB+0ODT03IW2xKsoS7AeEfACDQxZCoy7WnUxVv+16pSaex5aTiRmtnG6Sjv0rofmICsMXBr8LCstZdw4SrpE/PEEnmQZeP5xTZeHaDJRjZWLRXnzjpC…m/games%22%2C%22sref%22:%22https://www.nba.com/player/1626149%22%2C%22sts%22:1663261936459%2C%22slts%22:0}",
            "_parsely_visitor" = "{%22id%22:%22pid=44fe70eb8c0c8477d56f5209c2d0f927%22%2C%22session_count%22:1%2C%22last_session_ts%22:1663261936459}",
            "parsely_slot_click" = "{%22url%22:%22https://www.nba.com/games%22%2C%22x%22:900%2C%22y%22:104%2C%22xpath%22:%22//*[@id=%5C%22nav-ul%5C%22]/li[5]/div[1]/ul[1]/li[2]/a[1]%22%2C%22href%22:%22https://www.nba.com/stats/players%22}",
            "OptanonAlertBoxClosed" = "2022-09-15T17:23:21.841Z")

player_positions <- furrr::future_map_dfr(player_ids, ~{
  Sys.sleep(runif(1, 0, 2))
  
  player_link <- paste0("https://www.nba.com/player/", .x)
  
  player_page <- GET(player_link, 
                   add_headers("Host" = "stats.nba.com", 
                               "Origin" = "https://www.nba.com", 
                               "Referer" = "https://www.nba.com/",
                               "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:98.0) Gecko/20100101 Firefox/98.0", 
                               "x-nba-stats-origin" = "stats", 
                               "x-nba-stats-token" = "true"))
  
  player_content <- content(player_page, as = "text")
  
  players <- read_html(player_content) |> 
    html_elements("p[class*='PlayerSummary_main']") |> 
    html_text() 
  
  player_pos <- stringr::str_extract(players, "([:alnum:]+-)?[:alnum:]+$")
  
  out <- tryCatch({
    data.frame(PLAYER_ID = .x, 
               position = player_pos)
  }, error = function(x) {
    data.frame(PLAYER_ID = .x, 
               position = "Unknown")
  })
})

plan(strategy = "default")

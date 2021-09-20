library(furrr)
library(future)
library(gganimate)
library(ggplot2)
library(rvest)

all_results <- replicate(1000, expr = {
  alive_plants <- 1000
  
  number_days <- 65
  
  for(i in 1:number_days) {
    
    day <- i
    
    pump_failure <- rbinom(1, 1, .01)
    
    if(pump_failure == 1) {
      live_dead <- rbinom(alive_plants, 1, .90)
    } else live_dead <- rbinom(alive_plants, 1, .999)
    
    daily_dead <- sum(live_dead == 0)
    
    alive_plants <- alive_plants - daily_dead
  }
  
  alive_plants
})

hist(all_results)

t1 <- proc.time()
dollar_breaks <- map_dfr(1:10000, ~{
  
  day <- 0
  brokedown <- 0
  total_breakdown <- 0
  counter <- 0
  dollars_made <- 0
  
  for(i in 1:365) {
    brokedown <- brokedown - 1
    
    if(rbinom(1, 1, .1) == 1) { # Break downs happen 10%
      # brokedown <- sample(1:3, 1, prob = c(.1, .8, .1)) # Usually for 2 days
      brokedown <- rpois(1, 2)
      total_breakdown <- total_breakdown + brokedown
    }
    
    if(brokedown < 1) {
      dollar_sample <- rnorm(1, 180, 25)
      dollars_made <- dollars_made + dollar_sample
    }  
    day <- day + 1
  }
  
  data.frame(dollars = dollars_made, 
             days = total_breakdown, 
             run = .x)
})
proc.time() - t1


plan(multisession, workers = 7)

t1 <- proc.time()
dollar_breaks <- future_map_dfr(1:10000, ~{
  
  day <- 0
  brokedown <- 0
  total_breakdown <- 0
  counter <- 0
  dollars_made <- 0
  
  for(i in 1:365) {
    brokedown <- brokedown - 1
    
    if(rbinom(1, 1, .1) == 1) { # Break downs happen 10%
      # brokedown <- sample(1:3, 1, prob = c(.1, .8, .1)) # Usually for 2 days
      brokedown <- rpois(1, 2)
      total_breakdown <- total_breakdown + brokedown
    }
    
    if(brokedown < 1) {
      dollar_sample <- rnorm(1, 180, 25)
      dollars_made <- dollars_made + dollar_sample
    }  
    day <- day + 1
  }
  
  data.frame(dollars = dollars_made, 
             days = total_breakdown, 
             run = .x)
}, .options = furrr_options(seed = TRUE))
proc.time() - t1

ggplot(dollar_breaks, aes(days, dollars)) +
  geom_point() +
  theme_minimal()

ggplot(dollar_breaks, aes(dollars)) +
  geom_density() +
  theme_minimal()

ggplot(dollar_breaks, aes(days)) +
  geom_density() +
  theme_minimal()

nba_poss <- read_html("https://www.teamrankings.com/nba/stat/possessions-per-game") %>% 
  html_table() %>% 
  `[[`(1) 

nba_shooting <- read_html("https://www.teamrankings.com/nba/stat/shooting-pct") %>% 
  html_table() %>% 
  `[[`(1) 

nba_shooting$Home <- as.numeric(gsub("%", "", nba_shooting$Home))
nba_shooting$Away <- as.numeric(gsub("%", "", nba_shooting$Away))

game_sim <- function(sim_number) {
  
  home_possessions <- round(rnorm(1, mean(nba_poss$Home), sd(nba_poss$Home)))
  away_possessions <- round(rnorm(1, mean(nba_poss$Away), sd(nba_poss$Away)))
  
  home_shooting <- rbinom(home_possessions, 1, mean(nba_shooting$Home) / 100)
  away_shooting <- rbinom(away_possessions, 1, mean(nba_shooting$Away) / 100)
  
  game_res <- data.frame(home_score = sum(home_shooting) * 2, 
                         away_score = sum(away_shooting) * 2, 
                         home_poss = home_possessions, 
                         away_poss = away_possessions)
  
  game_res$winner <- ifelse(game_res$home_score > game_res$away_score,
                            "home",
                            "away")
  
  game_res$sim_number <- sim_number
  
  # game_res <- reshape2::melt(game_res, id.var = "sim_number")
  
  return(game_res)
}

game_sims_1000 <- purrr::map_df(1:2460, ~game_sim(.x))

summary(as.factor(game_sims_1000$winner))

summary(as.factor(game_sims_1000$winner))["home"] / 2460
# Historically, home teams win 62% of the time, but has shrunk to 55%
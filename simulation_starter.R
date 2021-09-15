# This is our problem:
# 30candy + 40gummies + 80bag
# 1candy + 1gummies - 10bag <= 500
# 4candy + 3gummies - 20bag <= 200
# 1candy + 0gummies - 2bag <= 100
# 1candy + 1gummies + 0bag >= 1000
# Tweak demand

library(ggplot2)
library(ROI)
library(ROI.plugin.glpk)

test_values <- round(runif(1000, 900, 1100))

demand_test <- purrr::map_df(test_values, ~{
  
  cvec <- c(candy = 30,
            gummies = 40,
            bag = 80)
  
  bvec <- c(distillate = 500,
            flower = 200,
            trichromes = 100,
            batch_need = .x)
  
  constDirs <- c("<=", "<=", "<=", ">=")
  
  aMat <- rbind(dis_const = c(1, 1, -10),
                flow_const = c(4, 3, -20),
                trich_const = c(1, 0, -2),
                batch_const = c(1, 1, 0))
  
  model_constraints <- L_constraint(L = aMat, 
                                    dir = constDirs, 
                                    rhs = bvec)
  
  model_creation <- OP(objective = cvec, 
                       constraints = model_constraints, 
                       types = rep("I", length(cvec)), 
                       maximum = FALSE)
  
  model_solved <- ROI_solve(model_creation)
  
  solution_primal <- solution(model_solved, "primal")
  solution_objval <- solution(model_solved, "objval")
  
  data.frame(t(solution_primal), 
             objval = solution_objval, 
             demand = .x)
})

ggplot(demand_test, aes(demand, objval)) +
  geom_point() +
  theme_minimal()

reshape2::melt(demand_test[, -4], id = "demand") |>
  ggplot(aes(demand, value, color = variable)) +
  geom_point() +
  theme_minimal()

alive_plants <- 1000

number_days <- 65

for(i in 1:number_days) {
  
  day <- i
  
  # n is number of observations
  # size is number of trials
  # Makes this really more like a Bernouli
  
  live_dead <- rbinom(alive_plants, 1, .999)
  
  daily_dead <- sum(live_dead == 0)
  
  print(paste0("On day ", i, ", ", daily_dead, " plants died"))
  
  alive_plants <- alive_plants - daily_dead
}

alive_plants

alive_plants <- 1000

number_days <- 65

for(i in 1:number_days) {
  
  day <- i
  
  pump_failure <- rbinom(n = 1, size = 1, prob = .01)
  # n is number of observations
  # size is number of trials
  # Makes this really more like a Bernouli
  
  if(pump_failure == 1) {
    print(paste0("The pump failed on day ", i))
    live_dead <- rbinom(alive_plants, 1, .90)
  } else live_dead <- rbinom(alive_plants, 1, .999)
  
  daily_dead <- sum(live_dead == 0)
  
  print(paste0("On day ", i, ", ", daily_dead, " plants died"))
  
  alive_plants <- alive_plants - daily_dead
}

alive_plants

alive_plants <- 1000

number_days <- 65

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

day <- 0
brokedown <- 0
counter <- 0

for(i in 1:100) {
  brokedown <- brokedown - 1
  
  if(rbinom(1, 1, .25) == 1) {
    brokedown <- 3
  }
  
  if(brokedown < 1) {
    counter <- counter + 1
  }  
  
  print(brokedown)
  day <- day + 1
  
}

#########################
###   Using ompr:     ###
### Blessing or Curse ###
#########################

install.packages(c("ompr", "ompr.roi"))

library(ompr)
library(ompr.roi)
library(ROI.plugin.glpk)
library(magrittr)

# Nothing new is happening below here:

advert <- read.csv("https://raw.githubusercontent.com/saberry/SimOps/main/advertising_data.csv", 
                   row.names = 1)

dropDemos <- which(names(advert) == "demographic_total")

objectiveFunction <- as.matrix(advert["cost", -c(dropDemos)])

dropCost <- which(rownames(advert) == "cost")

constraintMargins <- as.matrix(advert[-c(dropCost), "demographic_total"])

constraintMatrix <- as.matrix(advert[-c(dropCost), -c(dropDemos)])

# Now things get weird:

n <- length(objectiveFunction)
v <- objectiveFunction

model <- MIPModel() |> 
  add_variable(x[i], i = 1:n) |> 
  set_objective(sum_expr(v[i] * x[i], i = 1:n), sense = "min") |> 
  add_constraint(sum_expr(constraintMatrix[j, i] * x[i], i = 1:n) >= 
                   constraintMargins[j], j = 1:6)

model$variables
model$objective
model$constraints

result <- solve_model(model, with_ROI(solver = "glpk", verbose = TRUE))
get_solution(result, x[i])

# To something more interesting!

# Read in data from .csv file
fantasyData <- read.csv("https://www.nd.edu/~sberry5/data/fantasyDataComplete.csv")

fantasyRow <- nrow(fantasyData)
projectedPoints <- fantasyData$ProjectedPoints
salary <- as.numeric(fantasyData$Salary)
salaryMax <- 50
playerMax <- 8

pg <- fantasyData$Position_PG 
sg <- fantasyData$Position_SG
pf <- fantasyData$Position_PF 
sf <- fantasyData$Position_SF 
cen <-fantasyData$Position_C 

# Build the model
model <- MIPModel() %>%
  add_variable(x[i], i=1:fantasyRow, type = "binary") |> 
  set_objective(sum_expr(x[i] * projectedPoints[i], i=1:fantasyRow))  |> 
  add_constraint(sum_expr(salary[i] * x[i], i=1:fantasyRow) <= salaryMax)  |> 
  add_constraint(sum_expr(x[i], i=1:fantasyRow) <= playerMax) |> 
  # The following is given to you, but you will need to 
  # construct something similar for all other positions.
  add_constraint(sum_expr(pg[i] * x[i], i=1:fantasyRow) >= 1) 

solved <- solve_model(model, with_ROI("glpk"))

result <- get_solution(solved, x[i])
result[result$value == 1, "i"]

# Those are row values...how can you find the players?
library(ompr)

advert <- read.csv("https://raw.githubusercontent.com/saberry/SimOps/main/advertising_data.csv", 
                   row.names = 1)

dropDemos <- which(names(advert) == "demographic_total")

objectiveFunction <- as.matrix(advert["cost", -c(dropDemos)])

dropCost <- which(rownames(advert) == "cost")

constraintMargins <- as.matrix(advert[-c(dropCost), "demographic_total"])

constraintMatrix <- as.matrix(advert[-c(dropCost), -c(dropDemos)])

n <- length(objectiveFunction)

library(ompr)
library(ompr.roi)
library(ROI.plugin.glpk)
library(magrittr)

model <- MIPModel() |> 
  add_variable(x[i], i = 1:n, type = "continuous", lb = 1) |> 
  set_objective(sum_expr(v[i] * x[i], i = 1:n), sense = "min") |> 
  add_constraint(sum_expr(constraintMatrix[j, i] * x[i], i = 1:n) >= constraintMargins[j], j = 1:6)

model$variables
model$objective
model$constraints

result <- solve_model(model, with_ROI(solver = "glpk", verbose = TRUE))
get_solution(result, x[i])
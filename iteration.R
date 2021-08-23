#################
### Iteration ###
###  Control  ###
#################

# The Humble For Loop

## Vector Pre-allocation

empty_data <- data.frame(trial = numeric(length = 100), 
                         x_value = numeric(length = 100), 
                         y_value = numeric(length = 100), 
                         comp_value = numeric(length = 100))

empty_data <- matrix(0, ncol = 4, nrow = 100) |>
  data.frame() |>
  setNames(c("trial", "x_value", "y_value", "comp_value"))

test_set <- expand.grid(x = rnorm(10, mean = 10, sd = 1), 
                        y = rnorm(10, mean = 50, sd = 10))

i <- 1

for(i in 1:nrow(empty_data)) {
  
  empty_data[i, "trial"] <- i
  
  empty_data$x_value[i] <- test_set$x[i]
  
  empty_data$y_value[i] <- test_set$y[i]
  
  empty_data$comp_value[i] <- test_set$x[i] * test_set$y[i]

}

for(i in 1:nrow(empty_data)) {
  i <- i
  
  if(i %% 2) {
    empty_data[i, 1] <- 1 + (i - 1)
  } else {
    empty_data[i, 1] <- 1 + i
  }
  
  print(i)
  
  i <- i + 1
}

# The While Loop

empty_data <- matrix(0, ncol = 3, nrow = 100) |>
  data.frame() |>
  setNames(c("x", "y", "z"))

i <- 1

while(i < 75) {
  i <- i
  
  empty_data[i, 1] <- 1 + (i - 1)
  
  print(i)
  
  i <- i + 1
}

# The Apply Family

## lapply

lapply(empty_data$x, function(x) x + 1)

## sapply

sapply(empty_data$x, function(x) x + 1, simplify = TRUE)

# Modern R

## purrr::map
 
purrr::map_df()
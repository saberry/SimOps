#################
### Iteration ###
###  Control  ###
#################

# The Humble For Loop

## Vector Pre-allocation & Why

empty_data <- matrix(0, ncol = 4, nrow = 100) |>
  data.frame() |>
  setNames(c("trial", "x_value", "y_value", "comp_value"))

for(i in 1:nrow(empty_data)) {
  
  x <- rnorm(1, mean = 10, sd = 1) 
  
  y <- rnorm(1, mean = 50, sd = 10)
  
  empty_data[i, "trial"] <- i
  
  empty_data$x_value[i] <- x
  
  empty_data$y_value[i] <- y
  
  empty_data$comp_value[i] <- mean(c(x, y))

}

for(i in 1:nrow(empty_data)) {
  
  x <- rnorm(1, mean = 10, sd = 1) 
  
  y <- rnorm(1, mean = 50, sd = 10)
  
  x_y_mean <- mean(c(x, y))
  
  empty_data[i, "trial"] <- i
  
  empty_data$x_value[i] <- x
  
  empty_data$y_value[i] <- y
  
  if(round(x_y_mean) %% 2) {
    empty_data[i, "comp_value"] <- x_y_mean
  } else {
    empty_data[i, "comp_value"] <- round(x_y_mean)
  }
}

# The While Loop

empty_data <- matrix(0, ncol = 5, nrow = 100) |>
  data.frame() |>
  setNames(c("trial", "x_value", "y_value", "comp_value", "cumul_value"))

cumul_value_list <- matrix(0, ncol = 1, nrow = 100)

cumul_value <- 0

i <- 1

while(cumul_value < 1000L) {

  x <- rnorm(1, mean = 10, sd = 1) 
  
  y <- rnorm(1, mean = 50, sd = 10)
  
  x_y_mean <- mean(c(x, y))
  
  empty_data[i, "trial"] <- i
  
  empty_data$x_value[i] <- x
  
  empty_data$y_value[i] <- y
  
  empty_data[i, "comp_value"] <- x_y_mean
  
  cumul_value_list[i, 1] <- x_y_mean
  
  empty_data[i, "cumul_value"] <- cumsum(cumul_value_list[i, 1])
  
  cumul_value <- sum(cumul_value_list[, 1])
  
  i <- i + 1
}

# The Apply Family

## lapply


lapply_example <- lapply(1:100, function(i) {
  
  x <- rnorm(1, mean = 10, sd = 1) 
  
  y <- rnorm(1, mean = 50, sd = 10)
  
  x_y_mean <- mean(c(x, y))
  
  new_data <- data.frame(trial = numeric(1L), 
                         x_value = numeric(1L), 
                         y_value = numeric(1L), 
                         comp_value = numeric(1L))
  
  new_data$trial <- i
  
  new_data$x_value <- x
  
  new_data$y_value <- y
  
  if(round(x_y_mean) %% 2) {
    new_data$comp_value <- x_y_mean
  } else {
    new_data$comp_value <- round(x_y_mean)
  }
  
  return(new_data)
})

do.call("rbind", lapply_example)

## sapply

sapply(1:100, function(i) {
  x <- rnorm(1, mean = 10, sd = 1) 
  
  y <- rnorm(1, mean = 50, sd = 10)
  
  x_y_mean <- mean(c(x, y))
  
  new_data <- data.frame(trial = numeric(1L), 
                         x_value = numeric(1L), 
                         y_value = numeric(1L), 
                         comp_value = numeric(1L))
  
  new_data$trial <- i
  
  new_data$x_value <- x
  
  new_data$y_value <- y
  
  if(round(x_y_mean) %% 2) {
    new_data$comp_value <- x_y_mean
  } else {
    new_data$comp_value <- round(x_y_mean)
  }
  
  return(new_data)
}, simplify = FALSE)

# Modern R

## purrr::map
 
map_df_example <- purrr::map_df(.x = 1:100, ~{
  x <- rnorm(1, mean = 10, sd = 1) 
  
  y <- rnorm(1, mean = 50, sd = 10)
  
  x_y_mean <- mean(c(x, y))
  
  new_data <- data.frame(trial = numeric(1L), 
                         x_value = numeric(1L), 
                         y_value = numeric(1L), 
                         comp_value = numeric(1L))
  
  new_data$trial <- .x
  
  new_data$x_value <- x
  
  new_data$y_value <- y
  
  if(round(x_y_mean) %% 2) {
    new_data$comp_value <- x_y_mean
  } else {
    new_data$comp_value <- round(x_y_mean)
  }
  
  return(new_data)
})

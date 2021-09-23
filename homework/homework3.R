############################
###      Homework 3      ###
### A Tour of Simulation ###
############################

### Part 1 ###



### An Airport Simulation ###

# A passenger arrives to security at a rate of 1 person every 30 seconds. 
# The first inspection point has a mean working time of 1 minute with a 
# standard deviation of .1 minutes. After completing the initial screen, 
# 10% of people are selected for enhanced screening. This extra security 
# station takes an average of 5 minutes, with a standard deviation of 1 
# minute. All inspection points can handle 1 person at a time.

# Run the simulation for 3 hours worth of time. 

# Testing proportions of .1 to .4 (by .05), what proportion of passengers 
# can pass through the additional screening line and still keep the overall 
# waiting time under 5 minutes?

# There is some code to get you started, but remember where your distributions
# should go in the trajectory and the generator. Also, keep track of what
# should go into the prob statement of the branch.
  
arrivalRate

inspection1WorkingMean
inspection1WorkingSD

additionalInspection1WorkingMean
additionalInspection1WorkingSD

line2Percentage
  
simulationTime
  
passenger <- trajectory("passenger") %>% 
  set_attribute("start_time", function() {now(airport)}) %>% 
  seize("insp1") %>% 
  timeout(function() {}) %>% 
  release("insp1") %>% 
  branch(function() sample(0:1, 1, prob = c()) == 1, 
         continue = TRUE,
         trajectory() %>% 
           seize("insp2") %>% 
           timeout(function() {}) %>% 
           release("insp2")
  )

airport <- simmer("airport") %>% 
  add_resource("insp1", capacity = 2, queue_size = Inf) %>% 
  add_resource("insp2", capacity = 2, queue_size = Inf) %>% 
  add_generator("passenger", passenger, mon = 2, function() {})

run(airport, simulationTime)

ap_data <- get_mon_arrivals(airport)

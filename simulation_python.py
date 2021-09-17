import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

days = 65

alive_plants = 1000

for i in range(1, days):
  
  days = i
  
  live_dead = np.random.binomial(1, .999, size=alive_plants)

  daily_dead = sum(live_dead == 0)
  
  "On day %d, %d plants died" % (days, daily_dead)
  
  alive_plants = alive_plants - daily_dead

alive_plants


sim_runs = [0] * 1000

for j in range(1, 1000):
  print("Starting run %d" % (j))
  days = 65

  alive_plants = 1000

  for i in range(1, days):
  
    days = i
  
    live_dead = np.random.binomial(1, .999, size=alive_plants)

    daily_dead = sum(live_dead == 0)
  
    alive_plants = alive_plants - daily_dead
      
  sim_runs[j] = alive_plants


# Generate data on commute times.
size, scale = 1000, 10

plants_frame = pd.Series(sim_runs)

plants_frame.plot.hist(grid=True, bins=20, rwidth=0.9,
                   color='#607c8e')
                   
plt.grid(axis='y', alpha=0.75)


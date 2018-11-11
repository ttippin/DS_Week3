#Chapter 5.7.1 homework #1-8
library(nycflights13)
library(tidyverse)

#1: Refer back to the lists of useful mutate and filtering functions. Describe how each operation changes when you combine it with grouping.
#Find the worst members of each group, find all groups bigger than a threshold, standardise to compute per group metrics
#The grouuped mutates/filters are populating based on the groups. If you were not to group_by, it would mutate/filter over the entire dataset.

#2: Which plane (tailnum) has the worst on-time record?
flights %>% filter(!is.na(arr_delay), arr_delay > 0) %>%
  group_by(tailnum) %>%
  summarise(avg_ontime_record = mean(arr_delay), na.rm = TRUE) %>%
  arrange(-avg_ontime_record)
#N844MH

#3: What time of day should you fly if you want to avoid delays as much as possible?
flights %>% filter(!is.na(dep_delay)) %>%
  group_by(hour) %>%
  summarise(avg_dep_delay = mean(dep_delay, na.rm = TRUE)) %>%
  arrange(avg_dep_delay)
#5am

#4: For each destination, compute the total minutes of delay. For each flight, compute the proportion of the total delay for its destination.
flights %>% filter(!is.na(dep_delay), arr_delay > 0) %>%
  group_by(dest) %>%
  mutate(total_delay = sum(arr_delay) ,
            delay_prop = arr_delay / total_delay)

#5: Delays are typically temporally correlated: even once the problem that caused the initial delay has been resolved, later flights are delayed to allow earlier flights to leave. Using lag(), explore how the delay of a flight is related to the delay of the immediately preceding flight.
lags <- flights %>%
  arrange(origin, year, month, day, dep_time) %>%
  group_by(origin) %>%
  mutate(lag_dep_delay = lag(dep_delay)) %>%
  filter(!is.na(lag_dep_delay),!is.na(dep_delay))

lags %>% group_by(lag_dep_delay) %>%
  summarise(avg_dep_delay = mean(dep_delay)) %>%
  ggplot(aes(y = avg_dep_delay, x = avg_dep_delay)) +
  geom_point() +
  labs(y = "Dep Delay", x = "Last Dep Delay")

lags %>% summarise(diff_in_delay = mean(dep_delay - lag_dep_delay), na.rm = TRUE)


#6: Look at each destination. Can you find flights that are suspiciously fast? (i.e. flights that represent a potential data entry error). Compute the air time a flight relative to the shortest flight to that destination. Which flights were most delayed in the air?
flights2 <- flights %>% group_by (dest,tailnum) %>%
  filter(!is.na(dep_time),!is.na(arr_time),!is.na(air_time)) %>%
  mutate(min_airtime = air_time - min(air_time, na.rm = TRUE)) %>%
  arrange(-air_time)

flights3 <- select(flights2, tailnum, min_airtime,dest,distance,origin)

flights3

#looks like flights to Honolulu are the most inaccurate. They are travelling from JFK/Newark but apparently only take ~80-120 minutes. Just by googling, this should be an 11 hour flight.


#7: Find all destinations that are flown by at least two carriers. Use that information to rank the carriers.

flights %>% group_by(dest) %>%
  filter(n_distinct(carrier) > 2) %>%
  group_by(carrier) %>%
  summarise(n = n_distinct(dest)) %>%
  arrange(-n)

#8: For each plane, count the number of flights before the first delay of greater than 1 hour.
flights %>%
  arrange(tailnum, year, month, day) %>%
  group_by(tailnum) %>%
  mutate(delay_gt1hr = dep_delay > 60) %>%
  mutate(before_delay = cumsum(delay_gt1hr)) %>%
  filter(before_delay < 1) %>%
  count(sort = TRUE)


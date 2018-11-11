#Homework for ch 5.6.7
library(nycflights13)
library(tidyverse)


#2: Come up with another approach that will give you the same output as not_cancelled %>% count(dest) and not_cancelled %>% count(tailnum, wt = distance) (without using count()).
not_cancelled <- flights %>%
filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled %>% count(dest)

#New definition:
not_cancelled %>%
group_by(dest) %>%
summarise(n = n())

not_cancelled %>% count(tailnum, wt = distance)

#New definition:
not_cancelled %>%
group_by(tailnum) %>%
summarize(n = sum(distance))

#3: Our definition of cancelled flights (is.na(dep_delay) | is.na(arr_delay) ) is slightly suboptimal. Why? Which is the most important column?
#This includes flights that either don't have a departure time OR arrival time. This could be suboptimal if current flights are in progress and there is a dep_delay time but not an arr_delay time if the flight hasn't landed yet.
#We should just look to see if dep_delay is NA from now on to prevent this in the future.
  
#4: Look at the number of cancelled flights per day. Is there a pattern? Is the proportion of cancelled flights related to the average delay?
flights %>%
  group_by(year, month, day) %>%
  summarise(cancelled_flights = mean(is.na(dep_delay)),
            mean_dep = mean(dep_delay, na.rm = TRUE),
            mean_arr = mean(arr_delay, na.rm = TRUE)) %>%
  ggplot(aes(y = cancelled_flights)) +
  geom_point(aes(x = mean_dep), colour = "orange") +
  geom_point(aes(x = mean_arr), colour = "blue") +
  labs(x = "Avg daily delay", y = "Daily cancelled flights")


#5: Which carrier has the worst delays? Challenge: can you disentangle the effects of bad airports vs. bad carriers? Why/why not? (Hint: think about flights %>% group_by(carrier, dest) %>% summarise(n()))

delays <- flights %>% group_by(carrier) %>%
  summarise(avg_dep_delay = mean(dep_delay, na.rm = TRUE),
            avg_arr_delay = mean(arr_delay, na.rm = TRUE),
         n = n())
        

ggplot(data = delays, aes(y = n, x = carrier)) +
  geom_point(aes(x = avg_dep_delay), colour = "orange") +
  geom_point(aes(x= avg_arr_delay), colour = "blue")

arrange(delays, -avg_dep_delay)

filter(airlines, carrier == "F9")

#Frontier Airlines has the worst delays for both departures and arrivals

#6: What does the sort argument to count() do. When might you use it?
#Sort arranges the results in order of 'n' and this can be used when running a count() followed by an arrange()



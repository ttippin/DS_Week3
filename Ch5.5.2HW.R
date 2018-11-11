#1: Currently dep_time and sched_dep_time are convenient to look at, but hard to compute with because they’re not really continuous numbers. Convert them to a more convenient representation of number of minutes since midnight.
flights_raw <- flights

flights1 <- mutate(flights_raw,
                   dep_time_mins = (dep_time %/% 100 * 60 + dep_time %% 100) %% 1440,
                   sched_dep_time_mins = (sched_dep_time %/% 100 * 60 + sched_dep_time %% 100) %% 1440)

select(flights1,contains("sched_time"),contains("dep_time"))

#2: Compare air_time with arr_time - dep_time. What do you expect to see? What do you see? What do you need to do to fix it?
#Expectation is that air time should equal arr_time - dep_time. However, I think time zones could affect this if they are not using the same CST/EST/PST metric to define this timestamp. This is how I'd check:
flights2 <- select(flights, air_time, arr_time, dep_time, origin, dest)

mutate(flights2,
       altered_time = arr_time - dep_time)

#Doesn't appear that air_time == altered_time. Below is an equation I wrote to try to see if the timezone was the culprit but the #s are off by a lot more than just a quick hour change. After googling for a while, I'm not quick sure how to correct this or if this is even the right answer.

filter(flights2, origin =="JFK", dest == "LAX")

#3: Compare dep_time, sched_dep_time, and dep_delay. How would you expect those three numbers to be related?

delays <- select(flights, dep_time, sched_dep_time, dep_delay)
delays

#I would expect these numbers to line up but I can do what I did in #1 and try to get them to be in mins since midnight
flights_raw2 <- flights

flights3 <- mutate(flights_raw2,
                   dep_time_mins = (dep_time %/% 100 * 60 + dep_time %% 100) %% 1440,
                   sched_dep_time_mins = (sched_dep_time %/% 100 * 60 + sched_dep_time %% 100) %% 1440,
                   delay_time_mins = (dep_delay %/% 100 * 60 + dep_delay %% 100) %% 1440,
                   delay_diff = dep_delay - dep_time_mins + sched_dep_time_mins)

filter(flights3, delay_diff != 0)
#A lot of the results from the function above lead me to believe there is something occurring with timestamp since all of the hours appear to be close to midnight or maybe a flight could be arriving the next day and that's throwing it off.


#4 Find the 10 most delayed flights using a ranking function. How do you want to handle ties? Carefully read the documentation for min_rank().

delay <- flights
delay2 <- mutate(delay,
                 dep_delayed_most = min_rank(-dep_delay))
delay3 <- filter(delay2, dep_delayed_most <= 10)
arrange(delay3,dep_delayed_most)

#5 What does `1:3 + 1:10` return? Why?
1:3 + 1:10
#It choose the largest range and returned the results from 1:10
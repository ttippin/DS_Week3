#Chapter 19.3.1 homework #1-4

#1: Read the source code for each of the following three functions, puzzle out what they do, and then brainstorm better names.

prefix <- function(string, prefix) {
  substr(string, 1, nchar(prefix)) == prefix
}
exclude_last_variable <- function(x) {
  if (length(x) <= 1) return(NULL)
  x[-length(x)]
}
repeat_y_for_every_x <- function(x, y) {
  rep(y, length.out = length(x))
}

#2: Take a function that you’ve written recently and spend 5 minutes brainstorming a better name for it and its arguments.

SuspiciouslyFastFlights <- flights %>% group_by (dest,tailnum) %>%
  filter(!is.na(dep_time),!is.na(arr_time),!is.na(air_time)) %>%
  mutate(min_airtime = air_time - min(air_time, na.rm = TRUE)) %>%
  arrange(-air_time)

SummarizedSuspiciouslyFastFlights <- select(SuspiciouslyFastFlights, tailnum, min_airtime,dest,distance,origin)

SummarizedSuspiciouslyFastFlights

#3: Compare and contrast rnorm() and MASS::mvrnorm(). How could you make them more consistent?
#rnorm() = univariate normal distribution with the main arguements being n, mu and sd
#MASS::mrnorm() = multivairate normal distibution with main aruementing being n, mu and Sigma
#The difference in the functions are sigma vs. sd. Based on google searches (apologies in advance if this is totally incorrect), sigma and sd stand for the same thing = sq root of the variance of x. If they were named the same, this would make them consistent.
  
#4: Make a case for why norm_r(), norm_d() etc would be better than rnorm(), dnorm(). Make a case for the opposite.
#norm_r and norm_d group functions related to the normal distribution. r* functions always sample from distributions: rnorm, rbinom, runif, rexp. 
#rnorm and dnorm group functions related to the action they perform. d* functions calculate the probability density or mass of a distribution: dnorm, dbinom, dunif, dexp.

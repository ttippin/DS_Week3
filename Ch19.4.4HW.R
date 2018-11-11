#Chapter 19.4.4 #1-6

#1: What’s the difference between if and ifelse()? Carefully read the help and construct examples that illustrate the key differences.
#if (test_expression) {statement}. If the test_expression is TRUE, the statement gets executed. But if it’s FALSE, nothing happens. Test_expression can be a logical or numeric vector, but only the first element is taken into consideration.
#ifelse(test_expression, x, y). IfElse must be a logical vector and the return value is a vector with the same length as test_expression.

  #Nothing happens with the if clause because the expression doesn't meet the criteria defined. However, ifelse has a fallback when the criteria for "orange" isn't met.
  x <- 4
  if(x > 5) {
    print("Above5")
  }

  x <- 4
  ifelse(x > 5, "orange", "blue")

#2: Write a greeting function that says “good morning”, “good afternoon”, or “good evening”, depending on the time of day. (Hint: use a time argument that defaults to lubridate::now(). That will make it easier to test your function.)
greeting <- function(time = lubridate::now()) {
  hour <- lubridate::hour(time)
 if(hour < 11) {
  print("Good morning")
} else if (hour < 17) {
  print("Good afternoon")
} else {
  print("Good evening")
}
}
 
greeting() 
    
#3: Implement a fizzbuzz function. It takes a single number as input. If the number is divisible by three, it returns “fizz”. If it’s divisible by five it returns “buzz”. If it’s divisible by three and five, it returns “fizzbuzz”. Otherwise, it returns the number. Make sure you first write working code before you create the function.
fizzbuzz <- function(x) {
  divide_by_three <- x %% 3 == 0
  divide_by_five <- x %% 5 == 0
  if (divide_by_five & divide_by_three) {
    "fizzbuzz"
  } else if (divide_by_three) {
    "fizz"
  } else if (divide_by_five) {
    "buzz"
  }
}

fizzbuzz(10)
fizzbuzz(30)
fizzbuzz(3)

#4: How could you use cut() to simplify this set of nested if-else statements?
temp <- seq(-10, 50, by = 10)
cut(temp, c(-Inf, 0, 10, 20, 30, Inf), right = TRUE,
labels = c("hot","warm", "freezing", "cold", "cool"))

#How would you change the call to cut() if I’d used < instead of <=? What is the other chief advantage of cut() for this problem? (Hint: what happens if you have many values in temp?)
temp <- seq(-10, 50, by = 10)
cut(temp, c(-Inf, 0, 10, 20, 30, Inf), right = FALSE,
labels = c("hot","warm", "freezing", "cold", "cool"))

#5: What happens if you use switch() with numeric values?
switch(1,"orange","blue")
switch(2.5,"orange","blue")
#the switch function will choose whichever value is closest to the first # you inputted. So if I used 1, it would return n=1 which is orange. But if I did 2.5, it would return blue because 2.5 is closer to blue than to orange in ranking.

#6: What does this switch() call do? What happens if x is “e”?
  
  switch(x, 
         a = ,
         b = "ab",
         c = ,
         d = "cd"
  )
  
 #Switch function is looking for the first non-missing arguement value for the first name it matches. "E" isn't defined in this switch statement so this will appear null.
  
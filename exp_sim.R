nosim <- 1000
lambda=.20
mn=1/lambda
std=1/lambda
n=40
stderr=std/sqrt(n)

#cfunc <- function(x, n) sqrt(n) * (mean(x) - 3.5) / 1.71
cfunc <- function(x, n) sqrt(n) * (mean(rexp(n,lambda)) - mn) /std
dat <- data.frame(
  x = c(apply(matrix(sample(rexp(n,lambda), nosim * 20, replace = TRUE), 
                     nosim), 1, cfunc, 10),
        apply(matrix(sample(rexp(n,lambda), nosim * 30, replace = TRUE), 
                     nosim), 1, cfunc, 20),
        apply(matrix(sample(rexp(n,lambda), nosim * 40, replace = TRUE), 
                     nosim), 1, cfunc, 30)
        ),
  size = factor(rep(c(20, 30, 40), rep(nosim, 3))))
g <- ggplot(dat, aes(x = x, fill = size)) + geom_histogram(alpha = .20, binwidth=.3, colour = "black", aes(y = ..density..)) 
g <- g + stat_function(fun = dnorm, size = 2)
#g <- g + stat_function(fun = dexp, size = 2)
print (g + facet_grid(. ~ size))

nosim <- 1000
lambda=.20
mn=1/lambda
std=1/lambda
##n=40
##stderr=std/sqrt(n)
set.seed(79)


cfunc <- function(x, n1) sqrt(n1) * (mean(rexp(n1,lambda)) - mn) /std
dat <- data.frame(
  x = c(apply(matrix(sample(rexp(n,lambda), nosim * 5, replace = TRUE),
                     nosim), 1, cfunc, 10),
        apply(matrix(sample(rexp(n,lambda), nosim * 15, replace = TRUE),
                     nosim), 1, cfunc, 20),
        apply(matrix(sample(rexp(n,lambda), nosim * 40, replace = TRUE),
                     nosim), 1, cfunc, 30)
        ),
  size = factor(rep(c(5, 15, 40), rep(nosim, 3))))
g <- ggplot(dat, 
        aes(x = x, fill = size)) + 
        geom_histogram(alpha = .20, binwidth=.3, colour = "blue", 
                        aes(y = ..density..))
g <- g + stat_function(fun = dnorm, size = 1, colour="red")
print (g + facet_grid(. ~ size))

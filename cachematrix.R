## Put comments here that give an overall description of what your
## functions do
## Lexical Scope excersice based on the makecachVector and cachemean functions
##
## March, 2015
## In order to run, first create a square matrix
## for example: m<-matrix(rnorm(9,2,6),3,3)
## then use makeCacheMatrix: x<-makeCacheMatrix(m)
## finally use cacheSolve(x)f

## Write a short comment describing this function
## Receives: a matrix asf an argument
## Returns: a list of actios
makeCacheMatrix <- function(x = matrix()) {
    m <- NULL
    set <- function(y) {
      x <<- y
      m <<- NULL
    }
    get <- function() x
    setsolve <- function(solve) m <<- solve
    getsolve<- function() m
    list(set = set, get = get,
         setsolve = setsolve,
         getsolve = getsolve)

}


## Write a short comment describing this function
## cacheSolve()
## Returns a matrix that is the inverse of 'x'
## uses R's function "solve" to accomplish the task
## checks if a previous run is made, if so, it returns cached values
## and prints out a message indicanting cache is being used
## otherwise it applys the solve fuction to the matrix

cacheSolve <- function(x, ...) {
    m <- x$getsolve()
    if(!is.null(m)) {
        message("getting cached matrix")
        return(m)
    }
    data <- x$get()
    m <- solve(data, ...)
    x$setsolve(m)
    m
}

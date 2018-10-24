# NOT RUN {
# some arbitrary coordinates in [0,1]
x <- runif(20)
y <- runif(20)

# the following are equivalent
X <- ppp(x, y, c(0,1), c(0,1))
X <- ppp(x, y)
X <- ppp(x, y, window=owin(c(0,1),c(0,1)))

# specify that the coordinates are given in metres
X <- ppp(x, y, c(0,1), c(0,1), unitname=c("metre","metres"))


# }
# NOT RUN {
plot(X)
# }
# NOT RUN {
# marks
m <- sample(1:2, 20, replace=TRUE)
m <- factor(m, levels=1:2)
X <- ppp(x, y, c(0,1), c(0,1), marks=m)

# }
# NOT RUN {
plot(X)
# }
# NOT RUN {
# polygonal window
X <- ppp(x, y, poly=list(x=c(0,10,0), y=c(0,0,10)))

# }
# NOT RUN {
plot(X)
# }
# NOT RUN {
# circular window of radius 2
X <- ppp(x, y, window=disc(2))

# copy the window from another pattern
data(cells)
X <- ppp(x, y, window=Window(cells))
# }


; 
} 

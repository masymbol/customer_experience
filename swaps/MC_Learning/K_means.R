cells <- c(1, 1, 2, 1, 4, 3, 5, 4)
rnames <- c("A", "B", "C", "D")
cnames <- c("X", "Y")
x <- matrix(cells, nrow=4, ncol=2, byrow=TRUE, dimnames=list(rnames, cnames))
km <- kmeans(x, 2, 15)

plot(x, col = km$cluster)


x <- read.csv("/home/purva/Desktop/data.txt", header=TRUE, row.names=1)
km <- kmeans(x, 3, 15)

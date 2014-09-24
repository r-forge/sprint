library(amap)
library(rbenchmark)
library(sprint)
  

filename <- paste("benchmark_dist_results",Sys.Date(),Sys.info()["sysname"],".log",sep = "_")
logFile <- file(filename)
sink(file = logFile, append = TRUE, type = c("output"), split = FALSE)
sink(file = logFile, append = TRUE, type = c("message"), split = FALSE)

benchmark_dists <- function (cols=10, rows=100, test_method="euclidean") {
  x <- matrix(rnorm(rows*cols), nrow=rows)
  print(paste("Benchmarking dist with", cols, "cols and", rows, "rows"))
  benchmark(replications=rep(1, 1),
           dist=dist(x, method=test_method)
       #    Dist=Dist(x, method=test_method),
      #      Dist8proc=Dist(x,nbproc=8, method=test_method),
      #      Dist4proc=Dist(x,nbproc=4, method=test_method),
        #    Dist2proc=Dist(x,nbproc=2, method=test_method))
        #    columns=c('test', 'elapsed', 'replications')
      )
}

benchmark_dists()
benchmark_dists(100,100,"euclidean")
benchmark_dists(100,100,"maximum")
benchmark_dists(100,100,"manhattan")
benchmark_dists(100,100,"canberra")
benchmark_dists(100,100,"binary")

#benchmark_dists(10,1000)
#benchmark_dists(10,10000)
#benchmark_dists(10,20000)
#benchmark_dists(10,40000)
#benchmark_dists(10,50000)
#benchmark_dists(10,65000)
#benchmark_dists(10,66000)
#benchmark_dists(10,70000)
#benchmark_dists(10,80000)
#benchmark_dists(10,90000)
#benchmark_dists(10,93000)


#benchmark_dists(10,65000)
#benchmark_dists(10,66000)

#x <- matrix(rnorm((2^31)*10), nrow=2^31)
#dist=dist(x)
#Dist=Dist(x)

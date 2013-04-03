library("RUnit")

source("http://bioconductor.org/biocLite.R")
biocLite("BSgenome.Celegans.UCSC.ce2")
library("BSgenome.Celegans.UCSC.ce2")
library("ff")


for (nm in list.files("../inst/unitTests/pStringDist/", pattern = "\\.[Rr]$")){
  source(file.path("../inst/unitTests/pStringDist/", nm))
}

test.suite <- defineTestSuite("pStringDist", dirs = file.path("../inst/unitTests/pStringDist/"),testFileRegexp = '*.R')
library("sprint")
test.result <- runTestSuite(test.suite)
printTextProtocol(test.result)
pterminate()
quit()

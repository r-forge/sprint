library("RUnit")
library("sprint")
#source("http://bioconductor.org/biocLite.R")
#biocLite("Biostrings")
library("Biostrings")
#biocLite("BSgenome.Celegans.UCSC.ce2")
library("BSgenome.Celegans.UCSC.ce2")
library("ff")


for (nm in list.files("../inst/unitTests/pStringDist/", pattern = "\\.[Rr]$")){
  source(file.path("../inst/unitTests/pStringDist/", nm))
}

test.suite <- defineTestSuite("pStringDist", dirs = file.path("../inst/unitTests/pStringDist/"),testFileRegexp = '*.R')

test.result <- runTestSuite(test.suite)
printTextProtocol(test.result)
pterminate()
quit()

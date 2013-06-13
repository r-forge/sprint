library("RUnit")
library("sprint")
#source("http://bioconductor.org/biocLite.R")
#biocLite("Biostrings")
library("Biostrings")
#biocLite("BSgenome.Celegans.UCSC.ce2")
library("BSgenome.Celegans.UCSC.ce2")
library("ff")


for (nm in list.files("../inst/unitTests/pstringDist/", pattern = "\\.[Rr]$")){
  source(file.path("../inst/unitTests/pstringDist/", nm))
}

test.suite <- defineTestSuite("pstringDist", dirs = file.path("../inst/unitTests/pstringDist/"),testFileRegexp = '*.R')

test.result <- runTestSuite(test.suite)
printTextProtocol(test.result)
pterminate()
quit()

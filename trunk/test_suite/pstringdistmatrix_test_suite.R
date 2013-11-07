library("RUnit")
library("sprint")
source("http://bioconductor.org/biocLite.R")
biocLite("Biostrings")
library("Biostrings")
library("stringdist")
biocLite("BSgenome.Celegans.UCSC.ce2")
library("BSgenome.Celegans.UCSC.ce2")
library("ff")


for (nm in list.files("../inst/unitTests/pstringdistmatrix/", pattern = "\\.[Rr]$")){
  source(file.path("../inst/unitTests/pstringdistmatrix/", nm))
}

test.suite <- defineTestSuite("pstringdistmatrix", dirs = file.path("../inst/unitTests/pstringdistmatrix/"),testFileRegexp = '*.R')

test.result <- runTestSuite(test.suite)
printTextProtocol(test.result)
pterminate()
quit()

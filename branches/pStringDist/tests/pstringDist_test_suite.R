library("RUnit")
library("sprint")
#source("http://bioconductor.org/biocLite.R")
#biocLite("Biostrings")
library("Biostrings")
#biocLite("BSgenome.Celegans.UCSC.ce2")
library("BSgenome.Celegans.UCSC.ce2")
library("ff")


#for (nm in list.files("../inst/unitTests/pstringDist/", pattern = "\\.[Rr]$")){
#  source(file.path("../inst/unitTests/pstringDist/", nm))
#}
 pkg <- "sprint"
#path <- file.path(getwd(), "..", "inst", "unitTests","pstringDist")
path <- system.file(package=pkg, "unitTests")
cat("\nRunning unit tests\n")
print(list(pkg=pkg, getwd=getwd(), pathToUnitTests=path))
#test.suite <- defineTestSuite("pstringDist", dirs = file.path("../inst/unitTests/pstringDist/"),testFileRegexp = '*.R')

testSuite <- defineTestSuite(name=paste(pkg, "unit testing"),
dirs=path)
## Run
tests <- runTestSuite(testSuite)

## Default report name
pathReport <- file.path(path, "report")


## Report to stdout and text files
cat("------------------- UNIT TEST SUMMARY ---------------------\n\n")
printTextProtocol(tests, showDetails=FALSE)
printTextProtocol(tests, showDetails=FALSE,
fileName=paste(pathReport, "Summary.txt", sep=""))
printTextProtocol(tests, showDetails=TRUE,
fileName=paste(pathReport, ".txt", sep=""))

## Report to HTML file
printHTMLProtocol(tests, fileName=paste(pathReport, ".html", sep=""))

## Return stop() to cause R CMD check stop in case of
##  - failures i.e. FALSE to unit tests or
##  - errors i.e. R errors
tmp <- getErrors(tests)
if(tmp$nFail > 0 | tmp$nErr > 0) {
    stop(paste("\n\nunit testing failed (#test failures: ", tmp$nFail,
               ", #R errors: ",  tmp$nErr, ")\n\n", sep=""))
}

pterminate()
quit()

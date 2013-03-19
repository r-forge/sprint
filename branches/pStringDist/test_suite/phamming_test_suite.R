library("RUnit")
library("ShortRead")
library("e1071")


for (nm in list.files("../inst/unitTests/phamming/", pattern = "\\.[Rr]$")){
  source(file.path("../inst/unitTests/phamming/", nm))
}

test.suite <- defineTestSuite("phamming", dirs = file.path("../inst/unitTests/phamming/"),testFileRegexp = '*.R')
library("sprint")
test.result <- runTestSuite(test.suite)
printTextProtocol(test.result)
pterminate()
quit()

library("RUnit")
library("ff")
library("cluster")
# Combined Test and Training Sets from the Golub Paper
library("golubEsets")

for (nm in list.files("../inst/unitTests/pcor/", pattern = "\\.[Rr]$")){
  source(file.path("../inst/unitTests/pcor/", nm))
}
library("sprint")
test.suite <- defineTestSuite("pcor", dirs = file.path("../inst/unitTests/pcor/"),testFileRegexp = '*.R')

# === Set up finished ===

test.result <- runTestSuite(test.suite)
printTextProtocol(test.result)

pterminate()
quit()


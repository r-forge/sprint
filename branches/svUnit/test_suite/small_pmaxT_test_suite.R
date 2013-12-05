library("RUnit")
library("multtest")

for (nm in list.files("../inst/unitTests/pmaxT/", pattern = "\\.[Rr]$")){
  source(file.path("../inst/unitTests/pmaxT/", nm))
}
library("sprint")
test.suite <- defineTestSuite("pmaxT", dirs = file.path("../inst/unitTests/pmaxT/"),testFileRegexp = 'runit_small_test.R')

# === Set up finished ===

test.result <- runTestSuite(test.suite)
printTextProtocol(test.result)

pterminate()
quit()


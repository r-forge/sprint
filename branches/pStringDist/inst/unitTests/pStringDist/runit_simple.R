##########################################################################
#                                                                        #
#  SPRINT: Simple Parallel R INTerface                                   #
#  Copyright © 2008,2010 The University of Edinburgh                    #
#                                                                        #
#  This program is free software: you can redistribute it and/or modify  #
#  it under the terms of the GNU General Public License as published by  #
#  the Free Software Foundation, either version 3 of the License, or     #
#  any later version.                           			             #
#                                                                        #
#  This program is distributed in the hope that it will be useful,       #
#  but WITHOUT ANY WARRANTY; without even the implied warranty of        #
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the          #
#  GNU General Public License for more details.                          #
#                                                                        #
#  You should have received a copy of the GNU General Public License     #
#  along with this program. If not, see <http://www.gnu.or/licenses/>.   #
#                                                                        #
##########################################################################

#================= Sample data =================

#a <- readFastq("../inst/data/smallData.fastq")



## Randomly extract 10000 40-mers from C.elegans chrI:
# Big test, a bit slow to run, put it back for final testing.
extractRandomReads <- function(subject, nread, readlength)
{
	if (!is.integer(readlength))
	readlength <- as.integer(readlength)
	start <- sample(length(subject) - readlength + 1L, nread,
					replace=TRUE)
	DNAStringSet(subject, start=start, width=readlength)
}

# Change this to test scaling.
nreads <- 10000
rndreads <- extractRandomReads(Celegans$chrI, nreads, 40)

filename_ <- "pStringDist_result.out"
strings <- c("lazy", "HaZy", "rAzY")

# tests that pStringDist accepts simple strings, not just DNAStringSet objects
test.stringDistSimple <- function()
{
	expected_result <- stringDist(strings, method="hamming")
	result <- pStringDist(x=strings, method="hamming")
	actual_result <- as.dist(result[,])
	checkTrue(all.equal(expected_result, actual_result, check.attributes=FALSE), "pStringDist and stringDist with list of strings.")
	checkEquals(dimnames(expected_result), dimnames(actual_result), "Test labels on dist")
}

# tests pStringDist with a larger data set
test.stringDistScalingLarge <- function()
{
	DEACTIVATED("Not running large function.")
	
	nreads <- 70000 #Large enough for ordinary stringDist to refuse.
	rndreads <- extractRandomReads(Celegans$chrI, nreads, 40)
	
#	stime_original <- proc.time()["elapsed"]
#	expected_result <- stringDist(rndreads, method="hamming")
#	etime_original <- proc.time()["elapsed"]
	
	stime_sprint <- proc.time()["elapsed"]
	result <- pStringDist(rndreads, method="hamming", filename="large.ff")
	etime_sprint <- proc.time()["elapsed"]
	
#	actual_result <- as.dist(result[,])
	
	print(paste("Number of strings: ")); print(paste(nreads))
#	print(paste("Original stringDist time: ")); print(paste(etime_original-stime_original))
	print(paste("SPRINT pStringDist time: ")); print(paste(etime_sprint-stime_sprint))
	
#TODO find way to check result.
	
#checkTrue(all.equal(expected_result, actual_result, check.attributes=FALSE), "pStringDist and stringDist with list of strings.")
#checkEquals(dimnames(expected_result), dimnames(actual_result), "Test labels on dist")
}


# tests pStringDist with a small data set
test.stringDistScalingSmall <- function()
{
	nreads <- 10
	rndreads <- extractRandomReads(Celegans$chrI, nreads, 40)
	
	stime_original <- proc.time()["elapsed"]
	expected_result <- stringDist(rndreads, method="hamming")
	etime_original <- proc.time()["elapsed"]
	
	stime_sprint <- proc.time()["elapsed"]
	result <- pStringDist(rndreads, method="hamming", filename="small.ff")
	etime_sprint <- proc.time()["elapsed"]
	
	actual_result <- as.dist(result[,])
	
	print(paste("Number of strings: ")); print(paste(nreads))
	print(paste("Original stringDist time: ")); print(paste(etime_original-stime_original))
	print(paste("SPRINT pStringDist time: ")); print(paste(etime_sprint-stime_sprint))
	
	checkTrue(all.equal(expected_result, actual_result, check.attributes=FALSE), "pStringDist and stringDist with list of strings.")
	checkEquals(dimnames(expected_result), dimnames(actual_result), "Test labels on dist")
}



# test XStringSet dimnames check
test.stringDistDimnames <- function()
{
	x0 <- c("GTAT", "TTGA", "AGAG")
	width(x0)
	x1 <- BStringSet(x0)
	
	expected_result <- stringDist(x1, method="hamming")
	result <- pStringDist(x1, method="hamming")
	actual_result <- as.dist(result[,])
	checkTrue(all.equal(expected_result, actual_result, check.attributes=FALSE), "pStringDist and stringDist with BStringSet.")
	checkEquals(dimnames(expected_result), dimnames(actual_result), "Test labels on dist")
}

# Checking with different args
test.stringDistAllArgs <- function()
{
	expected_result <- stringDist(strings, method="hamming")
	result <- pStringDist(x=strings, method="hamming", filename=filename_)
	actual_result <- as.dist(result[,])
	checkTrue(all.equal(expected_result, actual_result, check.attributes=FALSE), "pStringDist and stringDist with list of strings.")
}

# Checking with different args
test.stringDistDataArgOnly <- function()
{
	expected_result <- stringDist(strings, method="hamming")
	result  <- pStringDist( filename=filename_, x=strings, method="hamming") #args in different orders
	actual_result <- as.dist(result[,])
	checkTrue(all.equal(expected_result, actual_result, check.attributes=FALSE), "pStringDist and stringDist with list of strings.")
}


test.wrongMethodArg <- function()
{
	expected_message = "pStringDist only supports the 'hamming' method. Please choose method=\"hamming\"."
	checkException(pStringDist(x=strings, method="levenshtein"), "An exception should be raised when pStringDist is passed a method other than hamming")
	checkTrue(as.logical(grep(expected_message, geterrmessage())), "Expected error message when non-hamming method passed to pStringDist.")
}


#  tests that pStringDist returns correct dimnames
test.stringDistPhageWithNames <- function()
{
	data(phiX174Phage)
	strings <- phiX174Phage
	
	sdist <- stringDist(strings, method="hamming")
	actual_result <- pStringDist(strings, filename=filename_)
	expected_result <- as.matrix(sdist)
	strLength <- length(strings)
	checkTrue(all.equal(expected_result[], actual_result[], check.attributes=FALSE), "pStringDist and stringDist should give same simple results")
    checkEquals(expected_result[], actual_result[], "Test simple matrix")
	checkEquals(labels(sdist), labels(as.dist(actual_result[,])), "Test labels on dist")
}


test.stringDistPhi <- function()
{	
#	DNAStringSet
	data(srPhiX174)
	strings <- srPhiX174[1:4]
	strLength <- length(strings)
	
	sdist <- stringDist(strings, method="hamming")
	actual_result <- pStringDist(strings, filename=filename_)
	expected_result <- as.matrix(sdist)
	checkTrue(all.equal(expected_result[], actual_result[], check.attributes=FALSE), "pStringDist and stringDist should give same simple results")
	checkEquals(expected_result[], actual_result[], "Test simple matrix")
}





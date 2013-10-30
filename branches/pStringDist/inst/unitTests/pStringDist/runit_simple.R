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
nreads <- 100
rndreads <- extractRandomReads(Celegans$chrI, nreads, 40)

filename_ <- "pstringDist_result.out"
strings <- c("lazy", "HaZy", "rAzY")
other.strings <- c("lazy", "Hazy")

# tests that pstringDist accepts simple strings, not just DNAStringSet objects
test.stringDistMatrixSimple <- function()
{
	expected_result <- stringdistmatrix(strings, strings, method="h")
	actual_result <- pstringdistmatrix(strings, strings, method="h")
	
	checkTrue(all.equal(expected_result, actual_result[,], check.attributes=FALSE), 
			  "pstringdistmatrix and stringdistmatrix with list of strings.")
	checkEquals(dimnames(expected_result), dimnames(actual_result[,]), "Test labels on dist")
}

# tests pstringDist with a larger data set
test.stringDistScalingLarge <- function()
{
#	DEACTIVATED("Not running large function.")
	
	nreads <- 6
	rndreads <- extractRandomReads(Celegans$chrI, nreads, 40)
	
	stime_original <- proc.time()["elapsed"]
	expected_result <- stringdistmatrix(rndreads, rndreads, method="h")
	etime_original <- proc.time()["elapsed"]
	
	stime_sprint <- proc.time()["elapsed"]
	actual_result <- pstringdistmatrix(rndreads, rndreads, method="h", filename="large.ff")
	etime_sprint <- proc.time()["elapsed"]

	
	checkTrue(all.equal(expected_result[], actual_result[], check.attributes=FALSE), 
			  "pstringdistmatrix and stringdistmatrix should give same simple results")
	
#	print(paste("Number of strings: ")); print(paste(nreads))
#	print(paste("Original stringDist time: ")); print(paste(etime_original-stime_original))
#	print(paste("SPRINT pstringDist time: ")); print(paste(etime_sprint-stime_sprint))

	checkTrue(all.equal(expected_result, actual_result[,], check.attributes=FALSE), 
			  "pstringdistmatrix and stringdistmatrix with list of strings.")
	checkEquals(dimnames(expected_result), dimnames(actual_result[,]), "Test labels on dist")
}


# tests pstringDist with a small data set
test.stringDistScalingSmall <- function()
{
	nreads <- 10
	rndreads <- extractRandomReads(Celegans$chrI, nreads, 40)
	
	stime_original <- proc.time()["elapsed"]
	expected_result <- stringdistmatrix(rndreads, rndreads, method="h")
	etime_original <- proc.time()["elapsed"]
	
	stime_sprint <- proc.time()["elapsed"]
	actual_result <- pstringdistmatrix(rndreads, rndreads, method="h", filename="small.ff")
	etime_sprint <- proc.time()["elapsed"]
	
	checkTrue(all.equal(expected_result, actual_result[], check.attributes=FALSE), 
			  "pstringdistmatrix and stringdistmatrix with list of strings.")
	checkEquals(dimnames(expected_result), dimnames(actual_result[,]), "Test labels on dist")
}



# test XStringSet dimnames check
test.stringDistDimnames <- function()
{
	x0 <- c("GTAT", "TTGA", "AGAG")
	width(x0)
	x1 <- BStringSet(x0)
	
	expected_result <- stringdistmatrix(x1, x1, method="h")
	actual_result <- pstringdistmatrix(x1, x1, method="h")
	checkTrue(all.equal(expected_result, actual_result[,], check.attributes=FALSE), 
			  "pstringdistmatrix and stringdistmatrix with BStringSet.")
	checkEquals(dimnames(expected_result), dimnames(actual_result[,]), "Test labels on dist")
}

# Checking with different args
test.stringDistAllArgs <- function()
{	expected_result <- stringdistmatrix(strings, strings, method="h")
	actual_result <- pstringdistmatrix(strings, strings, method="h", filename=filename_)
	checkTrue(all.equal(expected_result, actual_result[,], check.attributes=FALSE), 
			  "pstringdistmatrix and stringdistmatrix with list of strings.")
}

# Checking with different args
test.stringDistDataArgOnly <- function()
{
	expected_result <- stringdistmatrix(strings, strings, method="h")
	actual_result  <- pstringdistmatrix(filename=filename_, a=strings, b=strings, method="h")#args in different orders
	checkTrue(all.equal(expected_result, actual_result[,], check.attributes=FALSE), 
			  "pstringdistmatrix and stringdistmatrix with list of strings.")
}


test.wrongMethodArg <- function()
{
	expected_message = "pstringdistmatrix only supports the hamming method. Please choose method=\"h\"."
	checkException(pstringdistmatrix(a=strings, b=strings, method="lv"), 
				   "An exception should be raised when pstringDist is passed a method other than hamming")
	checkTrue(as.logical(grep(expected_message, geterrmessage())), 
			  "Expected error message when non-hamming method passed to pstringDist.")
}


#  tests that pstringDist returns correct dimnames
test.stringDistPhageWithNames <- function()
{
	data(phiX174Phage)
	strings <- phiX174Phage
	
	expected_result <- stringdistmatrix(strings, strings, method="h")
	actual_result <- pstringdistmatrix(strings, strings, method="h", filename=filename_)
	strLength <- length(strings)
	checkTrue(all.equal(expected_result, actual_result[,], check.attributes=FALSE), 
			  "pstringdistmatrix and stringdistmatrix should give same simple results")
}


test.stringDistPhi <- function()
{	
#	DNAStringSet
	data(srPhiX174)
	strings <- srPhiX174[1:4]
	strLength <- length(strings)
	
	expected_result <- stringdistmatrix(strings, strings, method="h")
	actual_result <- pstringdistmatrix(strings, strings, method="h", filename=filename_)
	checkTrue(all.equal(expected_result, actual_result[,], check.attributes=FALSE), 
			  "pstringdistmatrix and stringdistmatrix should give same simple results for a DNAStringSet")
}

test.differentInputs <- function(){
	
	expected_message = "pstringdistmatrix only works when both input sets of strings are the same."
	checkException(pstringdistmatrix(strings, other.strings, method="h"), 
				   "An exception should be raised when pstringdistmatrix is passed 2 different sets of strings")
	checkTrue(as.logical(grep(expected_message, geterrmessage())), 
			  "Expected error message when 2 different sets of strings passed to pstringdistmatrix.")
	
# TODO this is the test for when the code does handle 2 diff lists of strings.	
#	expected_result <- stringdistmatrix(strings, other.strings, method="h")
#	actual_result <- pstringdistmatrix(strings, other.strings, method="h")
#	checkTrue(all.equal(expected_result, actual_result[,], check.attributes=FALSE), 
#			  "pstringdistmatrix and stringdistmatrix should be able to compare 2 different lists of strings.")
}

test.AllInputs <- function(){
	expected_result <- stringdistmatrix(strings, strings, method="h", weight=c(0.5,1,1,1), maxDist=0, ncores=1)
	actual_result <- pstringdistmatrix(strings, strings, method="h", weight=c(0.5,1,1,1), maxDist=0, ncores=1) 
	checkTrue(all.equal(expected_result, actual_result[,], check.attributes=FALSE), 
			  "pstringdistmatrix should ignore unnecessary parameters.")
}

test.maxDistError <- function(){	
	expected_message = "maxDist is not used by pstringdistmatrix. Please set maxDist=0, or remove the maxDist parameter."
	checkException(pstringdistmatrix(strings, strings, method="h", maxDist=1), 
				   "An exception should be raised when pstringDist is passed maxDist>0")
	checkTrue(as.logical(grep(expected_message, geterrmessage())), 
			  "Expected error message when maxDist>0 passed to pstringdistmatrix.")
}

test.ErrorIfNCores <- function(){
	expected_message = "ncores is not used by pstringdistmatrix. Please refer to the SPRINT user guide for how to run in parallel."
	checkException(pstringdistmatrix(a=strings, b=strings, method="h", ncores=4), 
				   "An exception should be raised when pstringDist is passed ncores>1")
	checkTrue(as.logical(grep(expected_message, geterrmessage())), 
			  "Expected error message when ncores>1 passed to pstringdistmatrix.")
}


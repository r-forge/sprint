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


#===============================================

# Compare simple strings - not implimented by pStringDist.
#test.simple_string_compare <- function()
#{
#	expected_result = hamming.distance(x, y)
#	pStringDist_result = pStringDist.distance(x, y)
#	
#	checkEquals(expected_result, pStringDist_result, "Test simple string")
#}

# Compare simple matrix
#test.simple_string_compare <- function()
#{
#	expected_result = hamming.distance(w)
#	pStringDist_result = pStringDist.distance(w, pStringDist_result.out)	
#checkEquals(expected_result, pStringDist_result, "Test simple matrix")
#}

## Randomly extract 10000 40-mers from C.elegans chrI:
# Big test, a bit slow to run, put it back for final testing.
#extractRandomReads <- function(subject, nread, readlength)
#{
#	if (!is.integer(readlength))
#	readlength <- as.integer(readlength)
#	start <- sample(length(subject) - readlength + 1L, nread,
#					replace=TRUE)
#	DNAStringSet(subject, start=start, width=readlength)
#}
nreads <- 10
#rndreads <- extractRandomReads(Celegans$chrI, nreads, 40)

vmode_ <- "integer"
caching_ <- "mmeachflush"
finalizer_ <- "close"
length_ <- nreads * nreads
filename_ <- "pStringDist_result.out"


#test.stringDistHamming <- function()
#{
#	pStringDist(rndreads, filename_)
#	sdist <- stringDist(rndreads, method="hamming")
#	expected_result <- as.matrix(sdist)
#	actual_result <- ff(
#				dim=c(nreads,nreads)
#				, filename=filename_
#				, vmode=vmode_
#				, caching=caching_
#				, finalizer=finalizer_
#				, length=length_
#				)
#	
#	checkTrue(all.equal(expected_result[], actual_result[], check.attributes=FALSE),"pStringDist and stringDist should give same results")
#checkEquals(expected_result[], actual_result[], "Test simple matrix")
#}

# TODO make pStringDist accept simple strings, not just ShortReadQ or DNAStringSet objects
test.stringDistSimple <- function()
{
	strings <- c("lazy", "HaZy", "rAzY")
	sdist <- stringDist(strings, method="hamming")
	actual_result <- pStringDist(strings, filename_)
	expected_result <- as.matrix(sdist)
	strLength <- length(strings)
	checkTrue(all.equal(expected_result[], actual_result[], check.attributes=FALSE), "pStringDist and stringDist should give same simple results")
	checkEquals(expected_result[], actual_result[], "Test simple matrix")
}

# TODO return correct dimnames
test.stringDistPhageWithNames <- function()
{
	data(phiX174Phage)
	strings <- phiX174Phage
	
	sdist <- stringDist(strings, method="hamming")
	actual_result <- pStringDist(strings, filename_)
	expected_result <- as.matrix(sdist)
	strLength <- length(strings)
#	actual_result <- ff(
#						dim=c(strLength,strLength)
#						, filename=filename_
#						, vmode=vmode_
#						, caching=caching_
#						, finalizer=finalizer_
#						, length=strLength*strLength
#						)
	checkTrue(all.equal(expected_result[], actual_result[], check.attributes=FALSE), "pStringDist and stringDist should give same simple results")
    checkEquals(expected_result[], actual_result[], "Test simple matrix")
}


test.stringDistPhi <- function()
{
	data(srPhiX174)
	strings <- srPhiX174[1:4]
	strLength <- length(strings)
	
	sdist <- stringDist(strings, method="hamming")
	actual_result <- pStringDist(strings, filename_)
	expected_result <- as.matrix(sdist)
	checkTrue(all.equal(expected_result[], actual_result[], check.attributes=FALSE), "pStringDist and stringDist should give same simple results")
	checkEquals(expected_result[], actual_result[], "Test simple matrix")
}


# expected input data
#item{data}{ShortReadQ or DNAStringSet objects}
#item{output_filename}{results will be stored here as binary data}




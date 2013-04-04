##########################################################################
#                                                                        #
#  SPRINT: Simple Parallel R INTerface                                   #
#  Copyright © 2008,2010 The University of Edinburgh                     #
#                                                                        #
#  This program is free software: you can redistribute it and/or modify  #
#  it under the terms of the GNU General Public License as published by  #
#  the Free Software Foundation, either version 3 of the License, or     #
#  any later version.                            pStringDist                        #
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

#rndreads <- extractRandomReads(Celegans$chrI, nreads, 40)

vmode_ <- "integer"
caching_ <- "mmeachflush"
finalizer_ <- "close"
filename_ <- "pStringDist_result.out"

# TODO make pStringDist accept simple strings, not just ShortReadQ or DNAStringSet objects
test.stringDistSimple <- function()
{
	strings <- c("lazy", "HaZy", "rAzY")
	sdist <- stringDist(strings, method="hamming")
	pStringDist(strings, filename_)
	expected_result <- as.matrix(sdist)
	strLength <- length(strings)
	actual_result <- ff(
						dim=c(strLength,strLength)
						, filename=filename_
						, vmode=vmode_
						, caching=caching_
						, finalizer=finalizer_
						, length=strLength*strLength
						)
	checkTrue(all.equal(expected_result[], actual_result[], check.attributes=FALSE), "pStringDist and stringDist should give same simple results")
# checkEquals(expected_result[], actual_result[], "Test simple matrix")
}

# TODO test with different string lengths
# strings <- c("lazy", "HaZy", "crAzY")
 
# TODO also test with just one string
# strings <-  "HaZy"

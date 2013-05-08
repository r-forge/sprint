##########################################################################
#                                                                        #
#  SPRINT: Simple Parallel R INTerface                                   #
#  Copyright © 2008,2010 The University of Edinburgh                     #
#                                                                        #
#  This program is free software: you can redistribute it and/or modify  #
#  it under the terms of the GNU General Public License as published by  #
#  the Free Software Foundation, either version 3 of the License, or     #
#  any later version.                                                    #
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


x <- c(1, 0, 0)
y <- c(1, 0, 1)
z <- c(1, 1, 1)
w <- rbind(x,y,z)
rownames(w) <- c("Fred", "Tom", "Bob")

#a <- readFastq("../inst/data/smallData.fastq")

#===============================================

# Compare simple strings - not implimented by phamming.
#test.simple_string_compare <- function()
#{
#	expected_result = hamming.distance(x, y)
#	phamming_result = phamming.distance(x, y)
#	
#	checkEquals(expected_result, phamming_result, "Test simple string")
#}

# Compare simple matrix
#test.simple_string_compare <- function()
#{
#	expected_result = hamming.distance(w)
#	phamming_result = phamming.distance(w, phamming_result.out)	
#checkEquals(expected_result, phamming_result, "Test simple matrix")
#}

# Compare small fastq dataset
#test.small_fastq_compare <- function()
#{
#expected_result = hamming.distance(w)
	#phamming_result = phamming.distance(a, "phamming_result.out")
#	phamming_result
#checkEquals(expected_result, phamming_result, "Test simple matrix")
#}

# expected input data
#item{data}{ShortReadQ or DNAStringSet objects}
#item{output_filename}{results will be stored here as binary data}




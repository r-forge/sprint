##########################################################################
#                                                                        #
#  SPRINT: Simple Parallel R INTerface                                   #
#  Copyright © 2008,2009 The University of Edinburgh                     #
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


# = =============================================================== =
# =  Massive unit test to check all possible combinations of input  =
# =  parameters and make sure that the output matches the output    =
# =  from the serial version.                                       =
# = =============================================================== =

# = Copy of one of the pmaxT tests(runit_correct_args) that can be 
# = run as a stand alone test for timing.

library("RUnit")
library("multtest")
library("sprint")


test.correct_args <- function() {

    size_of_rows <- 2000
	
    # Load test data and class label
    data(golub)
    classlabel_1 <- golub.cl
    classlabel_2 <- rep(c(0,1),19)
    classlabel_3 <- rep(0:18,2)
	
    # Suspend quiting on stop
    options(error = expression(NULL))
	
	# Get a random set of rows
	smallgd <- golub[sample(1:dim(golub)[1], size_of_rows),]
	
	classlabel <- classlabel_1
	
	pmaxT(smallgd, classlabel, test="t", side="abs", fixed.seed.sampling="y", nonpara="y")
  
    # Enable stop functionality
    options(error = NULL)

}

system.time(test.correct_args())
pterminate()
quit()


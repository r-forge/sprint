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

test.correct_args <- function() {

    size_of_rows <- 1000
    size_of_columns <- 50

    # ----------------------------------------------------------------------------
    #  For loop to check the result of the pcor (normal correlation coefficients)
    #  Executes the same test with 5 different random arrays
    # ----------------------------------------------------------------------------
    for(i in 1:5 ) {

        # Create a random array for input
        input_dataset <- rnorm(size_of_rows * size_of_columns)
        dim(input_dataset) <- c(size_of_columns, size_of_rows)

        # Execute parallel version
        res_from_pcor <- pcor(t(input_dataset))

        # Execute serial version
        res_from_cor <- cor(t(input_dataset))

        invisible(checkEqualsNumeric(res_from_cor, res_from_pcor[,]))

        # CLoses (and deletes) the ff object
        close(res_from_pcor)

    }

    for(i in 1:5 ) {

        # Create a random array for input
        input_dataset_X<- rnorm(size_of_rows * size_of_columns)
        dim(input_dataset_X) <- c(size_of_columns, size_of_rows)

        # Create a random array for input
        input_dataset_Y<- rnorm(size_of_rows * size_of_columns)
        dim(input_dataset_Y) <- c(size_of_columns, size_of_rows)

        # Execute parallel version
        res_from_pcor <- pcor(t(input_dataset_X),
                              t(input_dataset_Y))

        # Execute serial version
        res_from_cor <- cor(t(input_dataset_X),
                            t(input_dataset_Y))

        invisible(checkEqualsNumeric(res_from_cor, res_from_pcor[,]))

        # CLoses (and deletes) the ff object
        close(res_from_pcor)

    }

    # ----------------------------------------------------------------------------
    #  For loop to check the result of the pcor (normal correlation coefficients)
    #  Executes the same test with 5 different random arrays
    # ----------------------------------------------------------------------------
    for(i in 1:5 ) {

        # Create a random array for input
        input_dataset <- rnorm(size_of_rows * size_of_columns)
        dim(input_dataset) <- c(size_of_columns, size_of_rows)

        # Execute parallel version
        res_from_pcor <- pcor(t(input_dataset), distance=TRUE)

        # Execute serial version
        res_from_cor <- 1 - cor(t(input_dataset))

        invisible(checkEqualsNumeric(res_from_cor, res_from_pcor[,]))

        # CLoses (and deletes) the ff object
        close(res_from_pcor)

    }

}



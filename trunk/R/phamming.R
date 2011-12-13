##########################################################################
#                                                                        #
#  SPRINT: Simple Parallel R INTerface                                   #
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

## consistent error / warning messages; could use for internationalization
..msg <- list(error =
              c(non.dna = "Function only accepts ShortReadQ or DNAStringSet objects",
                empty = "data object is empty"
                ), warn = c()
              )

phamming.distance <- function (data) {

  objectType <- class(data)
  if(!length(data)) stop(..msg$error["empty"])
  
  if (objectType=='ShortReadQ') {  
    data <- sread(data)
  } else if (objectType!='DNAStringSet') {
    stop(..msg$error["non.dna"])
  }

  w <- width(data[1])
  l <- length(data)

  return_val <- .C("phamming",
                   as.character(IRanges::unlist(data)),
                   as.integer(w),
                   as.integer(l)                   
                   )

  return(return_val)
}

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

#Arguments:

# x: a character vector or an XStringSet object.

#method: calculation method. One ofâ"levenshtein"â"hamming"â
#"quality"â or "substitutionMatrix".

#ignoreCase: logical value indicating whether to ignore case during
#scoring.


#library(ShortRead)

#(x, method="hamming", filename="output_file")
pstringDist <- function (x, method="hamming", filename=NULL) {
	
	data <- x
	
	if(!method=="hamming"){
		stop(..sprintMsg$error["hamming"])	}
	
    if (is.null(filename)){
# temporary ff object
		filename <- tempfile(pattern =  "ff" , tmpdir = getwd())
    }
	
	
# Load the "Biostrings" package in case is not already loaded. Warn user in case the package is missing
    if( !require("Biostrings", quietly=TRUE) ) {
        warning("Function pstringDist was unable to execute - failed to load package \"Biostrings\". Please check that the package is installed and try again.")
        return(NA)
    }
	
# Load the "ff" package in case is not already loaded. Warn user in case the package is missing
    if( !require("ff", quietly=TRUE) ) {
        warning("Function pstringDist was unable to execute - failed to load package \"ff\". Please check that the package is installed and try again.")
        return(NA)
    }

  objectType <- class(data)
  if(!length(data)) stop(..sprintMsg$error["empty"])
  
  if (objectType=='character') {  
	flatData <- paste(data, collapse = '')
  }
  else if (objectType!='XStringSet') {
	  flatData <- IRanges::unlist(data)
	  dataNames <- names(data)
  }
  else {
    stop(..sprintMsg$error["non.dna"])
  }

  sample_width <- width(data[1])
  number_of_samples <- length(data)
	
	if(!exists("dataNames")||is.null(dataNames)){
		dataNames <- as.character(c(1:number_of_samples))
	}

  if(sample_width<1 || number_of_samples<2) stop(..sprintMsg$error["empty"])

  return_val <- .C("pstringDist",
                   as.character(flatData),
                   as.character(filename),
                   as.integer(sample_width),
                   n=as.integer(number_of_samples)                   
                   )

	# The number_of_samples is overloaded to also indicate whether MPI is initialized.
	# -1    -->     MPI is not initialized
	
	vmode_ <- "integer"
	caching_ <- "mmeachflush"
	finalizer_ <- "close"
	filename_ <- as.character(filename)
	
		if ( return_val$n == -1 )  {
			warning(paste("MPI is not initialized. Function is aborted.\n"))
			result <- FALSE
		} else {
# Open result binary file and return as ff object
		result = ff(
		   dim=c(number_of_samples,number_of_samples),
		   dimnames=list(dataNames,dataNames),
		   , filename=filename_
		   , vmode=vmode_
		   , caching=caching_
		   , finalizer=finalizer_
#	   , length=(number_of_samples*number_of_samples)
		   )
    } 
  return(result)
}

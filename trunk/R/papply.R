##########################################################################
#                                                                        #
#  SPRINT: Simple Parallel R IN..sprintMsgTerface                                   #
#  Copyright � 2008,2009 The University of Edinburgh                     #
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

## consistent error / warning messages; could use for internationalization


# This stub function simply calls down to a stub in the library.

papply <- function(data, fun, margin=1, out_filename=NULL)
{
  ncols = nrows = 0
  IS_MATRIX = FALSE
  IS_LIST = FALSE
	
	if(exists("is.ff") && is.ff(data)) {
    ## check type of input ff object 
    if(vmode(data) != "double") 
      stop(..sprintMsg$error["non.double"])
    
    if(data.class(data) != "ff_matrix") {
      stop(..sprintMsg$error["non.ffmatrix"]) 
    }
    # get dimensions of the ff matrix
    nrows = dim.ff(data)[1]
    ncols = dim.ff(data)[2]

    filename = attr(attr(data, "physical"), "filename")
    if (!is.character(filename)) {
      stop(..sprintMsg$error["no.filename"])
    }
    data = filename;

    if (is.null(out_filename)){
      # temporary ff object
      out_filename <- tempfile(pattern =  "ff" , tmpdir = getwd())
    }
    
    MAP_FILE = TRUE
  } else {
	  
    MAP_FILE = FALSE
    
    if(is.matrix(data)) {
		
      IS_MATRIX = TRUE
      dims = dim(data)
		
    } else if(is.list(data)) {
		
		IS_LIST = TRUE
        # check that every list entry is a matrix
		if(!all(unlist(lapply(data, is.matrix)))){
			stop(..sprintMsg$error["non.supportedtype"])
		}
	} else {
		
		stop(..sprintMsg$error["non.supportedtype"])
	}
  }

  # serialise function definition or function name into character type
  
  if (is.function(fun)) {
    deparsed_fun <- deparse(substitute(fun))
  } else {
    stop(..sprintMsg$error["non.function"])
  }
  
#  pass an R object that will store the result
  return_val <- .Call("papply",                      
                      data,
                      as.integer(margin),
                      deparsed_fun,
                      as.integer(nrows),
                      as.integer(ncols),
                      out_filename
                      )
  # If the value is numeric then it means that
  # MPI is not initialized and the function should abort
  # and return FALSE
  if ( is.numeric(return_val) ) {
      warning(paste("MPI is not initialized. Function is aborted.\n"))
      return_val <- FALSE
  }

  if(IS_MATRIX && !is.null(return_val) && margin == 1 || margin == 2) {
    return (return_val[[1]])
  } else if (IS_LIST) {
    return (return_val[[1]])
  }    
  return (return_val)
}

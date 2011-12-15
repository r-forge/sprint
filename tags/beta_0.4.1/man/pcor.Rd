\name{pcor}
\alias{pcor}
\title{Parallel Correlation}
\description{
Parallel Pearson's correlation. It either takes a 2D array as input and 
correlates each row with every other row or takes two 2D arrays and correlates
the columns of the first matrix with the columns of the second matrix. The 
output can either be the matrix of correlation coefficient or the distance 
matrix.
}
\usage{
pcor(data_x, data_y = NULL, distance = FALSE, caching_ = "mmeachflush", 
     filename_ = NULL)
}
\arguments{
    \item{data_x}{double precision 2D array of data}
    \item{data_y}{NULL or second double precision 2D array of data}
    \item{distance}{boolean, whether the distance or correlation coefficient
                    matrix is returned}
    \item{caching_}{string, either "mmeachflush" or "mmnoflush" select the 
                    back-end caching scheme}
    \item{filename_}{string, name of the result file}
}
\examples{
ff_obj <- pcor(t(inData))
ff_obj <- pcor(t(inData_x), t(inData_y))
ff_obj <- pcor(t(inData), filename_="output.dat") 
ff_obj <- pcor(data, caching_="mmeachflush", filename_="output.dat")
ff_obj <- pcor(t(inData), distance=TRUE, filename_="output.dat")
}
\seealso{
   \code{\link{cor}}
   \code{\link{SPRINT}}
}
\author{
University of Edinburgh SPRINT Team
    \email{sprint@ed.ac.uk}
    \url{www.r-sprint.org}
    }
\keyword{utilities}
\keyword{interface}
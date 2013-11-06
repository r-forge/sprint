\name{pstringdistmatrix}
\alias{pstringdistmatrix}
\title{Parallel compute hamming distance between strings}
\description{Calculates the hamming distance matrix between strings.
}
\usage{
  pstringdistmatrix(data, output_filename)
}
\arguments{
  \item{a}{a: R object (target); will be converted by ‘as.character’.}
  \item{b}{b: R object (target); will be converted by ‘as.character’. Must be the same as argument a in this version of the software.}
  \item{method}{Method for distance calculation - only option 'h' for hamming distance is supported.}
  \item{filename}{results will be stored here as binary data}
}
\details{
  Calculates the hamming distance between each pair of strings. Returns an ff result matrix.
}
\author{
  University of Edinburgh SPRINT Team
  \email{sprint@ed.ac.uk}
  \url{www.r-sprint.org}
}
\keyword{utilities}
\keyword{interface}


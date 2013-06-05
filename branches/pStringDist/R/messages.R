..sprintMsg <- list(
	error =
	c(non.double = "x must be of type double",
	non.square = "x is not and cannot be converted to a square matrix",
	non.ff = "x must be a valid ff object",
	non.ffmatrix = "ff object must be a matrix", 
	no.filename = "The filename of the ff object cannot be read",
	non.function = "The fun argument needs to be a function",
	non.supportedtype = "papply only supports matrix, list of matrices or ff data",
	non.numeric = "PCOR only accepts numeric matrices",
	no.dims = "Dimensions of x and y matrices do not match",
	non.dna = "Function only accepts a character vector or an 'XStringSet' object",
	empty = "Data object is empty",
	no_file = "Output filename is missing",
	no.valid.k = "Number of clusters `k' must be in {1,2, .., n-1}; hence n >= 2",
	no.filename = "The filename of the ff object cannot be read",
	hamming = "pStringDist only supports the 'hamming' method. Please choose method=\"hamming\"."
	), 
	warn = c()
)
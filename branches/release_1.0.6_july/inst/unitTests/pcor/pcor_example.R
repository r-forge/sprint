test.correct_row_names_2_matrices <- function() {
# 2 matrices

library(sprint)
library(ff)
# random filled 3 by 4 matrices
	mat1 <- matrix(rexp(12), nrow=3)
	rownames(mat1) <- c('A','B','C')
	colnames(mat1) <- c('w','x','y','z')

	mat2 <- matrix(rexp(12), nrow=3)
	rownames(mat2) <- c('D','E','F')
	colnames(mat2) <- c('o','p','q','r')

	cor_result = cor(mat1, mat2)
	pcor_result = pcor(mat1, mat2)
	result_matrix = pcor_result[,]

	invisible(checkEqualsNumeric(cor_result, pcor_result[,]))

	checkEquals(rownames(cor_result), rownames(pcor_result), "results should have same rownames")
	checkEquals(colnames(cor_result), colnames(pcor_result), "results should have same colnames")
}
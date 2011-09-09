##' Reads in data in matrix market format
##' 
##' Warning: This is slow.
##' 
##' TODO: Wrap matrix market C code (mmio.{h|c})
##' 
##' @param mtx.file The path to the matrix market file
##' @return A (dense) matrix
read.matrix.mart <- function(mtx.file, as.sparse=TRUE, use.c=FALSE) {
  mtx.file <- as.character(mtx.file[1L])
  as.sparse <- as.logical(as.sparse[1L])
  use.c <- as.logical(use.c[1L])
  
  stopifnot(file.exists(mtx.file))
  
  if (use.c) {
    stop("TODO: Need to fix memory not mapped errors when reading banner")
    ret <- .Call("read_matrix_market", mtx.file, as.sparse, PACKAGE="buckshot")
    nr <- ret$nrows
    nc <- ret$ncols
    rows <- ret$rows
    cols <- ret$cols
    vals <- ret$vals
    nnz <- length(rows)
  } else {
    mtx <- read.table(mtx.file, header=FALSE, comment.char="%")
    nr <- mtx[1,1]
    nc <- mtx[1,2]
    nnz <- mtx[1,3]
    rows <- mtx[, 1]
    cols <- mtx[, 2]
    vals <- mtx[, 3]
  }
  
  m <- matrix(0, nrow=nr, ncol=nc)
  m[mtx[,1] * mtx[,2]] <- mtx[,3]
  m
}
#' Remove objects if exist
#'
#' Intended in scripts where, e.g. looping variables need to be cleaned up even
#' though the loop might not have been called. Does not issue a warning.
#'
#' @param The objects to be removed, as names (unqouted) or character strings (quoted).
#'
#' @noRd
rm_silently <- function(...) {

  obj <- sapply(as.list(match.call()[-1]), deparse)

  rm(list = intersect(ls(parent.frame()), obj), envir = parent.frame())

}

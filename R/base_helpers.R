#' Modified cytosine nucleobases
#'
#' @export
MODIFIED_C_BASES <- factor(c("C", "mC", "hmC", "fC", "caC"),
                           levels = c("C", "mC", "hmC", "fC", "caC"))

#' CpG combinations
#'
#' @export
CPG_COMBINATIONS <- c(
  p01 = "C/C",
  p02 = "C/mC",
  p03 = "C/hmC",
  p04 = "C/fC",
  p05 = "C/caC",
  p06 = "mC/mC",
  p07 = "mC/hmC",
  p08 = "mC/fC",
  p09 = "mC/caC",
  p10 = "hmC/hmC",
  p11 = "hmC/fC",
  p12 = "hmC/caC",
  p13 = "fC/fC",
  p14 = "fC/caC",
  p15 = "caC/caC",
  q02 = "mC/C",
  q03 = "hmC/C",
  q04 = "fC/C",
  q05 = "caC/C",
  q07 = "hmC/mC",
  q08 = "fC/mC",
  q09 = "caC/mC",
  q11 = "fC/hmC",
  q12 = "caC/hmC",
  q14 = "caC/fC"
)

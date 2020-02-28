#' @title Bin Data
#'
#' @description This is a demonstration of how to use functions in Shiny that
#'   are installed in an adjustment package
#'
#' @param x (`numeric`) A numeric variable.
#' @param n_bins (`integer`) A positive integer specifying the number of bins in
#'   the histogram.
#'
#' @return Bins boundaries
#' @export
#'
#' @examples
#' \dontrun{
#'   generate_bins(x = runif(100), n_bins = 10)
#' }
#'
generate_bins <- function(x, n_bins) {
    seq(min(x), max(x), length.out = n_bins + 1)
}

#' @title Say Hello
#'
#' @description This is an example function named 'hello' which prints 'Hello,
#'   world!'.
#'
#' @section Nice to Know:
#' You can learn more about package authoring with RStudio at:
#' \url{http://r-pkgs.had.co.nz/}
#'
#' Some useful keyboard shortcuts for package authoring:
#' * Install Package: 'Ctrl + Shift + B'
#' * Check Package: 'Ctrl + Shift + E'
#' * Test Package: 'Ctrl + Shift + T'
#'
#' @return NULL
#' @export
#'
#' @examples
#' \dontrun{
#'   hello()
#' }
#'
hello <- function() {
    message("Hello, world!")
    invisible()
}

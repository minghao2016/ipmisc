#' @title Formatting numeric (*p*-)values
#' @name specify_decimal_p
#'
#' @description Function to format an R object for pretty printing with a
#'   specified (`k`) number of decimal places. The function also allows really
#'   small *p*-values to be denoted as `"p < 0.001"` rather than `"p = 0.000"`.
#'   Note that if `p.value` is set to `TRUE`, the minimum value of `k` allowed
#'   is `3`. If `k` is set to less than 3, the function will ignore entered `k`
#'   value and use `k = 3` instead. **Important**: This function is not
#'   vectorized.
#'
#' @param x A numeric value.
#' @param k Number of digits after decimal point (should be an integer)
#'   (Default: `k = 3L`).
#' @param p.value Decides whether the number is a *p*-value (Default: `FALSE`).
#'
#' @return Formatted numeric value.
#'
#' @examples
#' specify_decimal_p(x = 0.0000123, k = 2, p.value = TRUE)
#' specify_decimal_p(x = 0.008675, k = 2, p.value = TRUE)
#' specify_decimal_p(x = 0.003458, k = 3, p.value = FALSE)
#' @export

# function body
specify_decimal_p <- function(x, k = 3L, p.value = FALSE) {

  # for example, if p.value is 0.002, it should be displayed as such
  if (k < 3L && isTRUE(p.value)) k <- 3L

  # formatting the output properly
  output <- trimws(format(round(x = x, digits = k), nsmall = k), which = "both")

  # if it's a p-value, then format it properly
  if (isTRUE(p.value) && output < 0.001) output <- prettyNum(x, scientific = TRUE, digits = k)

  # this will return a character
  return(output)
}

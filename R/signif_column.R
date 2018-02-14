#'
#' @title creating a column with significance labels
#' @name signif_column
#' @aliases signif_column
#' @description This function will add a new column to a dataframe containing p-values
#' @author Indrajeet Patil
#'
#' @param data data frame from which variables specified are preferentially to be taken
#' @param p the column containing p-values
#'
#' @import dplyr
#'
#' @importFrom rlang enquo
#' @importFrom tibble as_data_frame
#'
#' @examples
#' # the most common error is not adding quotes to column names that contain spaces
#' signif_column(data = measures_posthoc, p = `p-value (adjusted)`)
#' # or
#' signif_column(data = measures_posthoc, p = p.value)
#'
#' @export

signif_column <- function(data = NULL, p) {
  # if dataframe is provided
  if (!is.null(data)) {
    df <- data
    dplyr::select(.data = data,
                  p = !!rlang::enquo(p),
                  dplyr::everything()) # column corresponding to p-values
  } else {
    # if only vector is provided
    df <-
      base::cbind.data.frame(p = p) # column corresponding to p-values
  }

  # make sure the p-value column is numeric; if not, convert it to numeric and give a warning to the user
  if (!is.numeric(df$p)) {
    df$p <- as.numeric(as.character(df$p))
    warning(
      paste(
        'Entered p-values were not numeric variables, so ipmisc has converted them to numeric'
      )
    )
  }
  # add new significance column based on standard APA guidelines for describing different levels of significance
  df <- df %>%
    dplyr::mutate(
      .data = .,
      significance = dplyr::case_when(
        p >= 0.050 ~ 'ns',
        p < 0.050 &
          p >= 0.010 ~ '*',
        p < 0.010 &
          p >= 0.001 ~ '**',
        p < 0.001 ~ '***'
      )
    ) %>%
    tibble::as_data_frame(x = .)
  # if the entire dataframe was provided then this will create another column of p-values, which would be redundant
  # leave it out
  if (!is.null(data)) df$p <- NULL
  # reteurn the final dataframe
  return(df)
}
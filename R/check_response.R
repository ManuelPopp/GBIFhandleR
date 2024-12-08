#' Check response data
#'
#' Check if the input data frame matches the required format. If the input is
#' not a data frame, it will be replaced with an empty data frame. Missing
#' columns are added and filled with NA.
#'
#' @param x A data frame.
#' @return A data frame matching the required format.
#'
#' @export
check_response <- function(x) {
  if (is.data.frame(x$data)) {
    data <- x$data
  } else {
    print("Response data is not a data.frame.")
    data <- data.frame(matrix(ncol = 0, nrow = 1))
  }

  missing <- setdiff(config$COLUMNS, names(data))

  for (column in missing) {
    data[[column]] <- NA
  }

  return(data)
}

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
  response_data <- NULL

  if (is.data.frame(x$data)) {
    response_data <- x$data
  } else if (
    any(unlist(lapply(X = x, FUN = function(i){is.data.frame(i$data)})))
    ) {
    print(
      paste(
        "\nFound list of split responses (",
        paste(names(x), collapse = ", "),
        "). Trying to combine.", sep = ""
        )
    )

    df_list <- list()
    df_list_index <- 0
    for (element in x) {
      if (is.data.frame(element$data)) {
        if (nrow(element$data) > 0) {
          df_list_index <- df_list_index + 1

          # Ensure the data frames have the same columns
          missing <- setdiff(config$COLUMNS, names(element$data))
          for (column in missing) {
            element$data[[column]] <- NA
          }

          df_list[[df_list_index]] <- element$data[, config$COLUMNS]
        }
      }
    }

    if (length(df_list) > 0) {
      response_data <- do.call(rbind, df_list)
    }
  }

  if (is.null(response_data)) {
    warning("Response data is not a data frame.")
    response_data <- data.frame(matrix(ncol = 0, nrow = 1))
  }

  missing <- setdiff(config$COLUMNS, names(response_data))

  for (column in missing) {
    response_data[[column]] <- NA
  }

  return(response_data[, config$COLUMNS])
}

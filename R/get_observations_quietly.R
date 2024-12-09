#' Search GBIF for observations of a species without notifications and warnings
#'
#' A wrapper around \code{\link{get_observations}} that suppresses all messages,
#' warnings, and output during execution.
#'
#' @inheritParams get_observations
#' @return The output of \code{\link{get_observations}}.
#' @export
get_observations_quietly <- function (...) {
  output <- suppressMessages(
    suppressWarnings(
      capture.output(get_observations(...), file = "/dev/null")
      )
    )
  return(output)
}
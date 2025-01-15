#' Save species observations as comma separated file
#'
#' This function stores the output of \code{\link{get_observations}} as a .csv file
#' along with metadata.
#'
#' @param observations A list containing observation data and metadata as returned by \code{\link{get_observations}}.
#' @param filename Character. Output file.
#'
#' @details
#' This function stores the observation data along with the original query name and the matched GBIF name of the species.
#'
#' @export
save_observations <- function(observations, filename) {
  data <- observations$data
  metadata <- paste0(
    "# Data obtained via GBIFhandleR (based on rgbif)\n",
    "# Package version: ", packageVersion("GBIFhandleR"), "\n",
    "# Input name: ", observations$inputname, "\n",
    "# GBIF name: ", observations$gbifname
  )

  utils::write.table(
    data, filename,
    sep = ",", row.names = FALSE, col.names = TRUE,
    append = FALSE, quote = TRUE
  )
  obsdata <- base::readLines(filename)
  output <- c(metadata, obsdata)
  base::writeLines(output, filename)
}

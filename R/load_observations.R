#' Read species observations
#'
#' Attempt to read species observations and metadata exported via \code{\link{save_observations}}.
#'
#' @param filename Character. Input file.
#' @return A list containing observation data and metadata.
#'
#' @details
#' This function attempts to read species observation data from a .csv file along with the original query name and the matched GBIF name of the species.
#' In case valid metadata cannot be found in the input file, the first two words of the file name are extracted and set as input file name.
#'
#' @export
load_observations <- function(filename) {
  lines <- base::readLines(filename)
  metadata_lines <- lines[grepl("^#", lines)]

  if (length(metadata_lines) >= 2) {
    metadata <- do.call(
      rbind, base::strsplit(sub("^# ", "", metadata_lines[-1]), ": ")
      )
    final_data <- list(
      inputname = metadata[which(metadata[, 1] == "Input name"), 2],
      gbifname = metadata[which(metadata[, 1] == "GBIF name"), 2]
    )
  } else {
    final_data <- list(
      inputname = paste(
        base::strsplit(basename(filename), " ")[[1]][c(1, 2)],
        collapse = " "
        ),
      gbifname = NA
    )
    warning(
      paste(
        "Data was stored without valid metadata. Tried to infer species name",
        "from file name. Set inputname:", final_data$inputname
        )
      )
  }

  skiplines <- which(!grepl("^#", lines))[1] - 1
  data <- read.csv(filename, skip = skiplines)

  final_data[["data"]] <- data

  return(final_data)
}

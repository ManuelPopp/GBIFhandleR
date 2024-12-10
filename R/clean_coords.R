#' Clean geographic coordinates in a data frame
#'
#' This function uses the `CoordinateCleaner` package to clean and filter geographic coordinates
#' in a data frame, removing problematic records such as duplicates, outliers, invalid points,
#' and points located in capitals, centroids, or urban areas.
#'
#' @param x A data frame containing geographic data, including coordinates and species information.
#' @param species_column A character string specifying the name of the column containing species names. Default is `"species"`.
#' @param remove_capitals Logical. If `TRUE`, removes records located in capital cities. Default is `TRUE`.
#' @param remove_centroids Logical. If `TRUE`, removes records located in country centroids. Default is `TRUE`.
#' @param remove_duplicates Logical. If `TRUE`, removes duplicate records for the same species. Default is `TRUE`.
#' @param remove_gbif Logical. If `TRUE`, removes records associated with the GBIF headquarters. Default is `TRUE`.
#' @param remove_institutions Logical. If `TRUE`, removes records associated with institutions (e.g., herbaria). Default is `TRUE`.
#' @param remove_invalid Logical. If `TRUE`, removes invalid geographic coordinates. Default is `TRUE`.
#' @param remove_hotspots Logical. If `TRUE`, removes records associated with biodiversity hotspots such as airports or harbors. Default is `TRUE`.
#' @param remove_outliers Logical. If `TRUE`, removes spatial outliers based on the species' distribution. Default is `TRUE`.
#' @param remove_sea Logical. If `TRUE`, removes records located in the sea. Default is `TRUE`.
#' @param remove_urban Logical. If `TRUE`, removes records located in urban areas. Default is `TRUE`.
#' @param remove_zero Logical. If `TRUE`, removes records with zero latitude or longitude. Default is `TRUE`.
#' @param outlier_settings A list of additional settings for outlier detection, passed to `CoordinateCleaner::cc_outl`.
#' @param round_settings A list of additional settings. If not `NULL`, these settings are passed to `CoordinateCleaner::cd_round`.
#'   Default is `NULL`, which uses standard parameters (`tdi = 1000`, `method = "distance"`, `min_occs = 4`).
#'
#' @return A cleaned data frame with problematic records removed based on the specified criteria.
#'
#' @details
#' - This function sequentially applies a series of cleaning functions from the `CoordinateCleaner` package.
#' - Each cleaning step can be enabled or disabled using its corresponding parameter.
#' - Outlier detection (`cc_outl`) uses customizable parameters via the `outlier_settings` argument.
#' - Records with `individualCount == 0` or `occurrenceStatus == "ABSENT"` are also removed.
#'
#' @examples
#' # Example: Clean a dataset of species observations
#' data(observations)
#' clean_data <- clean_coords(
#'   x = observations$data,
#'   species_column = "scientificName",
#'   remove_outliers = TRUE,
#'   remove_sea = FALSE
#' )
#'
#'
#' @import CoordinateCleaner
#' @export
clean_coords <- function(
    x,
    species_column = "scientificName",
    remove_capitals = TRUE,
    remove_centroids = TRUE,
    remove_duplicates = TRUE,
    remove_gbif = TRUE,
    remove_institutions = TRUE,
    remove_invalid = TRUE,
    remove_hotspots = TRUE,
    remove_outliers = TRUE,
    remove_sea = TRUE,
    remove_urban = TRUE,
    remove_zero = TRUE,
    outlier_settings = list(tdi = 1000, method = "distance"),
    round_settings = NULL
) {
  if (!is.data.frame(x)) {
    stop("Input must be a data frame.")
  }
  # Remove all-NA rows
  x <- x[!apply(x, 1, function(row){all(is.na(row))}), ]

  if (nrow(x) < 1) {
    warning("Input data frame is empty.")
    return(x)
  }

  if (remove_capitals) {
    x <- CoordinateCleaner::cc_cap(x, species = species_column)
    if (nrow(x) < 1) {
      warning("No entries left after coordinate checks.")
      return(x)
    }
  }

  if (remove_centroids) {
    x <- CoordinateCleaner::cc_cen(x, species = species_column)
    if (nrow(x) < 1) {
      warning("No entries left after coordinate checks.")
      return(x)
    }
  }

  if (remove_duplicates) {
    x <- CoordinateCleaner::cc_dupl(x, species = species_column)
    if (nrow(x) < 1) {
      warning("No entries left after coordinate checks.")
      return(x)
    }
  }

  if (remove_gbif) {
    x <- CoordinateCleaner::cc_gbif(x, species = species_column)
    if (nrow(x) < 1) {
      warning("No entries left after coordinate checks.")
      return(x)
    }
  }

  if (remove_hotspots) {
    x <- CoordinateCleaner::cc_aohi(x, species = species_column)
    if (nrow(x) < 1) {
      warning("No entries left after coordinate checks.")
      return(x)
    }
  }

  if (remove_institutions) {
    x <- CoordinateCleaner::cc_inst(x, species = species_column)
    if (nrow(x) < 1) {
      warning("No entries left after coordinate checks.")
      return(x)
    }
  }

  if (remove_invalid) {
    x <- CoordinateCleaner::cc_val(x)
    if (nrow(x) < 1) {
      warning("No entries left after coordinate checks.")
      return(x)
    }
  }

  # Remove outliers
  outlier_args <- list(
    x = x,
    species = species_column,
    tdi = 1000,
    method = "distance",
    min_occs = 4
  )

  if (!is.null(outlier_settings)) {
    outlier_args <- utils::modifyList(outlier_args, outlier_settings)
  }

  if (remove_outliers) {
    x <- do.call(CoordinateCleaner::cc_outl, outlier_args)
    if (nrow(x) < 1) {
      warning("No entries left after coordinate checks.")
      return(x)
    }
  }

  # Remove raster centroids
  if (!is.null(round_settings)) {
    x <- do.call(CoordinateCleaner::cd_round, round_settings)
    if (nrow(x) < 1) {
      warning("No entries left after coordinate checks.")
      return(x)
    }
  }

  if (remove_sea) {
    x <- CoordinateCleaner::cc_sea(x)
    if (nrow(x) < 1) {
      warning("No entries left after coordinate checks.")
      return(x)
    }
  }

  if (remove_urban) {
    x <- CoordinateCleaner::cc_urb(x)
    if (nrow(x) < 1) {
      warning("No entries left after coordinate checks.")
      return(x)
    }
  }

  if (remove_zero) {
    x <- CoordinateCleaner::cc_zero(x)
    if (nrow(x) < 1) {
      warning("No entries left after coordinate checks.")
      return(x)
    }
  }

  # Remove absences
  absences <- which(x$individualCount == 0 | x$occurrenceStatus == "ABSENT")
  if (length(absences) >= 1) {
    x <- x[-absences,]
  }

  if (nrow(x) < 1) {
    warning("No entries left after coordinate checks.")
  }

  return(x)
}

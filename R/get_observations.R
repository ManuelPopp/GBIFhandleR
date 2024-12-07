#' Search GBIF for observations of a species
#'
#' This function queries the GBIF database for observation records of a
#' specified species within a given year range, optionally handling name
#' matching and data limits imposed by the GBIF API.
#' It allows retrieval of either a simple data frame or a list containing
#' additional information related to the retrieval of the data.
#'
#' @param species_name A character string specifying the scientific name
#' of the species to search for.
#' @param match_name Logical. If `TRUE`, attempts to match the species name
#' with a GBIF taxon using a helper function (`match_gbif_name`).
#' The default is `TRUE`.
#' @param start_year Numeric. The starting year for observations to include.
#' The default is `1950`.
#' @param end_year Numeric. The ending year for observations to include.
#' The default is the current year.
#' @param return_full Logical. If `TRUE`, returns a list containing full
#' details of the search, including grid information and the matched GBIF name.
#' If `FALSE`, the function only returns a data frame of observations.
#' The default is `TRUE`.
#'
#' @return A list or data frame:
#'   - If `return_full = TRUE`, returns a list with the following elements:
#'       - `data`: A data frame of observations with requested columns.
#'       - `grid`: A data frame of the grid used for dividing large datasets.
#'       - `inputname`: The input species name.
#'       - `gbifname`: The matched GBIF species name.
#'   - If `return_full = FALSE`, returns only the data frame of observations.
#'
#' @details
#' - The function uses the `rgbif` package to interact with GBIF's API.
#' - Observations are restricted to those with coordinates and without
#' geospatial issues.
#' - For large datasets (exceeding 100,000 records), the function divides the
#' search area into a grid and downloads data in smaller chunks.
#'
#' @examples
#' # Example 1: Basic search for a species
#' observations <- get_observations("Grewia rogersii")
#'
#' # Example 2: Retrieve only a simplified data frame
#' \dontrun{
#' observations <- get_observations("Tragopogon dubius", return_full = FALSE)
#' }
#'
#' @import rgbif
#' @import utils
#' @export
get_observations <- function(
    species_name, match_name = TRUE,
    start_year = 1950, end_year = format(Sys.Date(), "%Y"),
    return_full = TRUE
) {
  if (!requireNamespace("rgbif", quietly = TRUE)) {
    install.packages("rgbif")
  }

  year_interval <- paste(c(start_year, end_year), collapse = ",")

  if (match_name) {
    search_name <- match_gbif_name(species_name)
    if (is.na(search_name)) {
      warning(paste0("No GBIF taxon matches name: ", species_name, "."))
    }
  } else {
    search_name <- species_name
  }

  num_records <- count_records(search_name)

  if (num_records == 0) {
    df_obs <- check_response(list(data = NULL))
    warning(paste0("No GBIF records found for taxon ", species_name, "."))
  }

  grid <- data.frame(
    latmin = c(-90), latmax = c(90),
    lonmin = c(-180), lonmax = c(180),
    num_records = c(num_records)
  )

  # Check rGBIF limit of 100'000 records
  if (num_records <= config$GBIFMAX) {
    response <- rgbif::occ_search(
      scientificName = search_name,
      hasCoordinate = TRUE,
      hasGeospatialIssue = FALSE,
      year = year_interval,
      limit = min(num_records, config$GBIFMAX)
    )

    df_obs <- check_response(response)
  } else {
    print(
      paste0("Found too many entries (", num_records, "). Gridding area...")
    )

    grid <- data.frame(
      latmin = c(-90, -90), latmax = c(90, 90),
      lonmin = c(-180, 0), lonmax = c(0, 180),
      num_records = c(num_records)
    )

    while(max(grid$num_records) > config$GBIFMAX) {
      # Split cells
      grid <- split_grid(grid)

      # Count records again
      new_counts <- apply(
        X = as.matrix(grid), MARGIN = 1, FUN = count_records_grid,
        species_name = search_name, year = year_interval
      )
      grid$num_records <- new_counts

      # Drop empty cells
      empty <- which(grid$num_records == 0)
      if (length(empty) >= 1) {
        grid <- grid[-empty,]
      }
    }

    if (requireNamespace("progress", quietly = TRUE)) {
      pb <- progress::progress_bar$new(
        format = "  Downloading [:bar] :percent in :elapsed",
        width = 60,
        total = nrow(grid)
      )

      fancy_progress <- TRUE
    } else {
      pb = utils::txtProgressBar(min = 0, max = nrow(grid), initial = 0)
      fancy_progress <- FALSE
    }

    for (r in 1:nrow(grid)) {
      lat_range <- paste(grid[r, c("latmin", "latmax")], collapse = ",")
      lon_range <- paste(grid[r, c("lonmin", "lonmax")], collapse = ",")

      response <- rgbif::occ_search(
        scientificName = search_name,
        hasCoordinate = TRUE,
        hasGeospatialIssue = FALSE,
        year = year_interval,
        decimalLatitude = lat_range,
        decimalLongitude = lon_range,
        limit = min(num_records, config$GBIFMAX)
      )

      df_row <- check_response(response)

      if (r == 1) {
        df_obs <- df_row[, config$COLUMNS]
      } else {
        tryCatch({
          df_obs <- rbind(df_obs, df_row[, config$COLUMNS])
        }, error = function(e) {
          warning("An error occurred appending the dataframe: ", e$message)
        })
      }

      if (fancy_progress) {
        pb$tick()
      } else {
        utils::setTxtProgressBar(pb, r)
      }
    }
  }

  if (return_full) {
    return(
      list(
        data = df_obs,
        grid = grid,
        inputname = species_name,
        gbifname = search_name
      )
    )
  } else {
    return(df_obs)
  }
}

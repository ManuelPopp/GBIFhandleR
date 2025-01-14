#' Assign native/introduced status to observations
#'
#' This function intersects observation locations and documented species range
#' to assign native/introduced status to each data point.
#'
#' @param observations A list containing observation data and metadata.
#' @param range A Distribution object (typicaly created via \code{\link{get_range}}).
#'
#' @return Spatial points with an attribute `status` which is either `native`, `introduced`, or `unknown`.
#'
#' @details
#' This function performs a spatial intersection of native range and introduced range (as spatial polygon features) with the point locations of observations.
#'
#' @import sf
#' @export
assign_status <- function(observations, range) {
  obs <- observations$data
  native_range <- sf::st_union(range@geo_distribution$native)
  exotic_range <- sf::st_union(range@geo_distribution$introduced)

  obs$decimalLongitude <- as.numeric(obs$decimalLongitude)
  obs$decimalLatitude <- as.numeric(obs$decimalLatitude)

  if (any(c(is.na(obs$decimalLongitude), is.na(obs$decimalLatitude)))) {
    obs_cleaned <- obs[
      -which(is.na(obs$decimalLongitude) | is.na(obs$decimalLatitude)),
      ]
  } else {
    obs_cleaned <- obs
  }

  obs_points <- sf::st_as_sf(
    obs_cleaned,
    coords = c("decimalLongitude", "decimalLatitude"),
    crs = 4326
  )

  native_idx <- sf::st_intersects(
    obs_points, native_range, relation = "intersects"
    )
  exotic_idx <- sf::st_intersects(
    obs_points, exotic_range, relation = "intersects"
    )

  status <- ifelse(
    native_idx, "native", ifelse(exotic_idx, "introduced", "unknown")
    )

  obs_points$status <- status

  return(obs_points)
}

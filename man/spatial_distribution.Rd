% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/spatial_distribution.R
\name{spatial_distribution}
\alias{spatial_distribution}
\title{Retrieve spatial polygons for species distribution}
\usage{
spatial_distribution(locations)
}
\arguments{
\item{locations}{A list containing location information for a species, typically obtained
from the \code{\link{get_distribution_powo}} function. The list should have the following elements:
\describe{
  \item{native_tdwg}{A character vector of TDWG codes for native regions.}
  \item{introduced_tdwg}{A character vector of TDWG codes for introduced regions.}
  \item{native_name}{(Optional) A character vector of native region names.}
  \item{introduced_name}{(Optional) A character vector of introduced region names.}
}}
}
\value{
A list containing two `sf::st_sfc` objects:
\describe{
  \item{native}{A simple feature collection object containing polygons for native regions.}
  \item{introduced}{A simple feature collection object containing polygons for introduced regions.}
}
If any location codes are not found in the TDWG WGSRPD level 4 dataset, a warning is issued.
}
\description{
This function retrieves spatial polygons corresponding to native and introduced
locations for a species using TDWG WGSRPD polygons.
}
\details{
The function matches the TDWG codes from the input `locations` to the `tdwg` dataset, which contains the WGSRPD polygons combined for all levels. For unmatched codes, a warning is raised with the names of the missing locations. The function returns two spatial objects corresponding to native and introduced distributions.
}
\note{
The `tdwg` dataset must be preloaded and should contain at least two columns:
\describe{
  \item{code}{TDWG region codes (level 4).}
  \item{geometry}{The spatial polygons for the regions.}
}
}
\examples{
\dontrun{
# Example locations input
locations <- list(
  native_tdwg = c("AFC", "AMZ"),
  introduced_tdwg = c("ANT", "AUS"),
  native_name = c("Africa", "Amazon"),
  introduced_name = c("Antarctica", "Australia")
)

# Retrieve spatial polygons
spatial_data <- spatial_distribution(locations)

# View native polygons
plot(spatial_data$native)

# View introduced polygons
plot(spatial_data$introduced)
}

}
\seealso{
\link{tdwg}, \link{get_distribution_powo}
}

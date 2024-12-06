#' Match an input species name with GBIF
#'
#' This function attempts to match a given species name with the GBIF
#' taxonomic backbone to find its standardized scientific name.
#'
#' @param species_name A character string specifying the name of the species
#'     to match. This can be a scientific name or common name.
#' @param rank A character string specifying the taxonomic rank to match.
#'     The default is `"SPECIES"`. Other options include `"GENUS"`,
#'     `"FAMILY"`, etc.
#'
#' @return A character string containing the matched scientific name from GBIF.
#'   If no match is found, returns `NA`.
#'
#' @details
#' - The function uses the `rgbif::name_backbone()` function to query GBIF’s
#'     taxonomic backbone.
#' - If no match is found, the function returns `NA` and does not raise an
#'     error.
#' - Matching is not strict, allowing for flexible name matching.
#' - The rank parameter can be used to refine the matching process (e.g.,
#'     only match species or genera).
#'
#' @examples
#' # Example 1: Match a species name. The following will perform fuzzy
#'     matching and return the corrected, full species name:
#'     "Pterocarpus rotundifolius (Sond.) Druce"
#' match_gbif_name("Pterocarpus rotundifolia")
#'
#' # Example 2: Match a genus name
#' match_gbif_name("Panthera", rank = "GENUS")
#'
#' @import rgbif
#' @export
match_gbif_name <- function(species_name, rank = "SPECIES") {
  matches <- rgbif::name_backbone(
    species_name, rank = rank, verbose = FALSE, strict = FALSE
  )
  
  if(matches[1,]$matchType == "NONE") {
    return(NA)
  }
  
  return(matches[1,]$scientificName)
}
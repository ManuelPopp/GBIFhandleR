config <- list(
  COLUMNS = c(
    "scientificName", "taxonID", "taxonKey", "continent", "decimalLatitude",
    "decimalLongitude", "year"
  ),
  # GBIF maximum returned records = 100'000. Reduce number to speed up script.
  GBIFMAX = 100#0#0#0
)
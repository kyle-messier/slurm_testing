#!/usr/bin/env Rscript

cat("=== Testing sf installation and dependencies ===\n")

# Try loading sf
suppressMessages({
  library(sf)
})

cat("sf loaded successfully\n")

# Print version
cat("sf version:", as.character(packageVersion("sf")), "\n")

# Print GDAL / GEOS / PROJ versions
cat("GDAL version: ", sf::sf_extSoftVersion()["GDAL"], "\n")
cat("GEOS version: ", sf::sf_extSoftVersion()["GEOS"], "\n")
cat("PROJ version: ", sf::sf_extSoftVersion()["PROJ"], "\n")

# Check s2
cat("s2 enabled:", sf_use_s2(), "\n")

# Simple geometry test
p <- st_point(c(1, 2))
cat("Created st_point:", format(p), "\n")

# Buffer test
b <- st_buffer(p, 1)
cat("Buffered geometry class:", class(b), "\n")

cat("=== sf test complete ===\n")

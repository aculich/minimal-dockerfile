#!/usr/bin/env r

# Install devtools, so we can install versioned packages
install.packages("devtools")

# Install a bunch of R packages
# This doesn't do any dependency resolution or anything,
# so refer to `installed.packages()` for authoritative list
cran_packages <- c(
  # https://github.com/2i2c-org/pilot/issues/66
  "rJava", "1.0-5",
)

for (i in seq(1, length(cran_packages), 2)) {
  devtools::install_version(
    cran_packages[i],
    version = cran_packages[i + 1]
  )
}

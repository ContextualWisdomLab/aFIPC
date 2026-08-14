# Internal namespace bindings for deterministic tests of interactive code.
#
# Function lookup skips these NULL values during normal execution and continues
# to the corresponding base functions. testthat can temporarily replace the
# pre-existing namespace bindings during R CMD check, where the namespace is
# locked and new bindings cannot be created.
interactive <- NULL
readline <- NULL

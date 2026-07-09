test_that("IPDParmNames filtering correctly ignores variables without prefixes and correctly removes those with prefixes", {
  IPDParmNames <- c("MEAN_1", "COV_11", "ak_1", "d0", "ad0", "a1", "d", "g", "u")
  filtered <- IPDParmNames[!grepl("^(MEAN|COV|ak)|^d0$", IPDParmNames)]
  expect_equal(filtered, c("ad0", "a1", "d", "g", "u"))
})

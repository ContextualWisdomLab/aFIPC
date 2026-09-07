legacy_est_updates <- function(parms, itemtype, free_mean) {
  parms[parms$item == "GROUP", "est"] <- FALSE
  parms[parms$name == "COV_11", "est"] <- TRUE
  if (identical(itemtype, "Rasch")) {
    parms[parms$name == "a1", "est"] <- FALSE
  }
  if (isTRUE(free_mean)) {
    parms[parms$name == "MEAN_1", "est"] <- TRUE
  }
  parms
}

vector_est_updates <- function(parms, itemtype, free_mean) {
  parms$est[parms$item == "GROUP"] <- FALSE
  parms$est[parms$name == "COV_11"] <- TRUE
  if (identical(itemtype, "Rasch")) {
    parms$est[parms$name == "a1"] <- FALSE
  }
  if (isTRUE(free_mean)) {
    parms$est[parms$name == "MEAN_1"] <- TRUE
  }
  parms
}

test_that("direct est-column assignment preserves the protected data-frame result", {
  fixtures <- list(
    data.frame(
      item = c("GROUP", "item1", "item2", "GROUP", "item3"),
      name = c("MEAN_1", "COV_11", "a1", "COV_11", "d"),
      est = c(TRUE, FALSE, TRUE, TRUE, FALSE),
      value = c(0, 1, 2, 3, 4),
      row.names = c("group_mean", "cov_1", "slope", "group_cov", "difficulty"),
      stringsAsFactors = FALSE
    ),
    data.frame(
      item = c("item1", "item2"),
      name = c("d", "g"),
      est = c(TRUE, FALSE),
      value = c(-0.5, 0.2),
      row.names = c("difficulty", "guessing"),
      stringsAsFactors = FALSE
    )
  )

  for (parms in fixtures) {
    for (itemtype in c("3PL", "Rasch")) {
      for (free_mean in c(FALSE, TRUE)) {
        expect_identical(
          vector_est_updates(parms, itemtype, free_mean),
          legacy_est_updates(parms, itemtype, free_mean)
        )
      }
    }
  }
})

test_that("direct est-column assignment preserves duplicate-match behavior", {
  parms <- data.frame(
    item = c("GROUP", "GROUP", "item1", "item2", "item3"),
    name = c("MEAN_1", "MEAN_1", "COV_11", "COV_11", "a1"),
    est = rep(TRUE, 5),
    value = seq_len(5),
    stringsAsFactors = FALSE
  )

  expect_identical(
    vector_est_updates(parms, "Rasch", TRUE),
    legacy_est_updates(parms, "Rasch", TRUE)
  )
})

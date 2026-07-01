regression_fixture_prior_update <- list(
  seed = 20260701L,
  n_old = 1800L,
  n_new = 1800L,
  old_theta_mean = 0,
  old_theta_sd = 1,
  new_theta_mean = 0.85,
  new_theta_sd = 1.15,
  common_count = 6L,
  unique_count = 2L,
  itemtype = "2PL",
  expect_shifted_mean_abs_gt = 0.2
)

regression_fixture_ipd_anchor <- list(
  seed = 20260702L,
  n_old = 2200L,
  n_new = 2200L,
  common_count = 6L,
  unique_count = 2L,
  drift_common_index = 3L,
  itemtype = "2PL"
)

test_that("models perc_model", {

  perc_model()
  expect_true(file.exists("perc.model"))

})

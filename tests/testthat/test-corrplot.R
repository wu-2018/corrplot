test_that("correlation_scatter works", {
  expect_error(correlation_scatter(datasets::iris, x='Species'), 'must be numeric')
  expect_match(as.character(correlation_scatter(datasets::iris, group='Species')$layers[[2]]$layer_data()[1,2]), '0.742')
})

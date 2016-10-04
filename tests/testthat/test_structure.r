context('test structure')

test_that('rsyntax class', {
  expect_is(spss_to_r(system.file("SPSSsyntax", "getDescExamp.txt", package = "SPSStoR")),
            'rsyntax')
})

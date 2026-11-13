test_that("player names are normalized", {
  expect_equal(normalize_player_name("serena williams"), "SerenaWilliams")
  expect_equal(normalize_player_name("Rafael Nadal"), "RafaelNadal")
  expect_equal(normalize_player_name("SerenaWilliams"), "SerenaWilliams")
  expect_error(normalize_player_name(""), "non-empty")
})

test_that("JS files are parsed into one row per match", {
  expect_equal(nrow(parse_match_rows(female_js)), 3)
  expect_equal(nrow(parse_match_rows(male_js)), 3)
  expect_error(parse_match_rows("var x = 1;"), "No match data")
})

test_that("female files: opponent age is derived from date of birth", {
  df <- build_career_data(female_js, as.Date("1981-09-26"))
  expect_equal(df$opponent_age[1], 18.78, tolerance = 0.02)
  expect_equal(df$opponent, c("Anne Miller", "Alexia Dechaume Balleret", "Magui Serna"))
  expect_equal(df$age_diff, df$player_age - df$opponent_age)
})

test_that("male files: opponent age is used as given", {
  df <- build_career_data(male_js, as.Date("1986-06-03"))
  expect_equal(df$opponent_age[1], 22.264202601)
  expect_equal(df$player_age[1], 15.27, tolerance = 0.02)
  expect_equal(df$result, c("L", "L", "W"))
})

test_that("player date of birth is parsed", {
  expect_equal(parse_player_dob("var dob = 19810926;"), as.Date("1981-09-26"))
  expect_error(parse_player_dob("nothing here"), "date of birth")
})

test_that("plot_age_gap returns a ggplot and validates input", {
  df <- build_career_data(male_js, as.Date("1986-06-03"))
  expect_s3_class(plot_age_gap(df), "ggplot")
  expect_error(plot_age_gap(mtcars), "get_player_career")
})
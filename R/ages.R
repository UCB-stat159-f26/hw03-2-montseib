years_between <- function(from, to) as.numeric(to - from) / 365.25

# Women's files give the opponent's DOB (YYYYMMDD); men's give the age directly.
compute_opponent_age <- function(date, opponent_info) {
  is_dob <- grepl("^\\d{8}$", opponent_info)
  age <- suppressWarnings(as.numeric(opponent_info))
  dob <- as.Date(opponent_info[is_dob], format = "%Y%m%d")
  age[is_dob] <- years_between(dob, date[is_dob])
  age
}

add_age_columns <- function(matches, player_dob) {
  matches$player_age <- years_between(player_dob, matches$date)
  matches$opponent_age <- compute_opponent_age(matches$date, matches$opponent_info)
  matches$age_diff <- matches$player_age - matches$opponent_age
  matches$opponent_info <- NULL
  matches
}
#' Get the career matches of a tennis player
#'
#' @param player_name Player name, e.g. "serena williams",
#'   "Serena Williams" or "SerenaWilliams".
#' @return A data frame with one row per match, including `player_age`,
#'   `opponent_age`, `age_diff` and `result`.
#' @export
#' @examples
#' \dontrun{
#' serena <- get_player_career("serena williams")
#' }
get_player_career <- function(player_name) {
  player_key <- normalize_player_name(player_name)
  page <- find_player_page(player_key)
  if (is.null(page)) stop_player_not_found(player_name)
  career_js <- fetch_text(career_js_url(player_key))
  if (is.null(career_js)) stop_player_not_found(player_name)
  build_career_data(career_js, parse_player_dob(page))
}

# Pure function (no network): this is what the tests exercise.
build_career_data <- function(career_js, player_dob) {
  matches <- build_match_table(parse_match_rows(career_js))
  matches <- add_age_columns(matches, player_dob)
  matches <- matches[order(matches$date), ]
  matches <- matches[!duplicated(matches), ]
  rownames(matches) <- NULL
  matches
}


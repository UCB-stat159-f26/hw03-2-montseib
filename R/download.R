normalize_player_name <- function(player_name) {
  if (!is.character(player_name) || length(player_name) != 1 ||
      !nzchar(trimws(player_name))) {
    stop("`player_name` must be a single non-empty string.", call. = FALSE)
  }
  words <- strsplit(trimws(player_name), "\\s+")[[1]]
  rest <- substring(words, 2)
  if (length(words) > 1) rest <- tolower(rest)
  paste0(toupper(substring(words, 1, 1)), rest, collapse = "")
}

player_page_url <- function(player_key, tour) {
  cgi <- if (tour == "wta") "wplayer-classic.cgi" else "player-classic.cgi"
  sprintf("https://www.tennisabstract.com/cgi-bin/%s?p=%s&f=ACareerqq",
          cgi, player_key)
}

career_js_url <- function(player_key) {
  sprintf("https://www.tennisabstract.com/jsmatches/%sCareer.js", player_key)
}

fetch_text <- function(url) {
  resp <- httr2::request(url) |>
    httr2::req_user_agent("Mozilla/5.0") |>
    httr2::req_error(is_error = function(resp) FALSE) |>
    httr2::req_perform()
  if (httr2::resp_status(resp) != 200) return(NULL)
  httr2::resp_body_string(resp)
}

has_dob <- function(js_text) grepl("var dob\\s*=", js_text)

# Looks for the date of birth in the career JS first, then on the player pages.
find_player_dob <- function(player_key, career_js, player_name) {
  if (has_dob(career_js)) return(parse_player_dob(career_js))
  for (tour in c("wta", "atp")) {
    page <- fetch_text(player_page_url(player_key, tour))
    if (!is.null(page) && has_dob(page)) return(parse_player_dob(page))
  }
  stop(sprintf("Found matches for '%s' but could not find the player's date of birth.",
               player_name), call. = FALSE)
}

stop_player_not_found <- function(player_name) {
  stop(sprintf("Player '%s' was not found on tennisabstract.com. Check the spelling.",
               player_name), call. = FALSE)
}
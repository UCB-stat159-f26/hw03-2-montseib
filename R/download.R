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

# Returns the response body as text, or NULL if the request is not a 200.
fetch_text <- function(url) {
  resp <- httr2::request(url) |>
    httr2::req_user_agent("tennisage R package") |>
    httr2::req_error(is_error = function(resp) FALSE) |>
    httr2::req_perform()
  if (httr2::resp_status(resp) != 200) return(NULL)
  httr2::resp_body_string(resp)
}

# Tries the women's page, then the men's; returns the first page with a DOB.
find_player_page <- function(player_key) {
  for (tour in c("wta", "atp")) {
    page <- fetch_text(player_page_url(player_key, tour))
    if (!is.null(page) && grepl("var dob\\s*=", page)) return(page)
  }
  NULL
}

stop_player_not_found <- function(player_name) {
  stop(sprintf("Player '%s' was not found on tennisabstract.com. Check the spelling.",
               player_name), call. = FALSE)
}
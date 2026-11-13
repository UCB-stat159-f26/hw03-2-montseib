extract_js_array <- function(js_text, var_name) {
  pattern <- sprintf("(?s)var %s\\s*=\\s*(\\[\\[.*?\\]\\])", var_name)
  hit <- regmatches(js_text, regexpr(pattern, js_text, perl = TRUE))
  if (length(hit) == 0) return(NULL)
  json <- sub("^var \\w+\\s*=\\s*", "", hit)
  jsonlite::fromJSON(json, simplifyVector = FALSE)
}

parse_match_rows <- function(js_text) {
  rows <- c(extract_js_array(js_text, "matchmx"),
            extract_js_array(js_text, "morematchmx"))
  if (length(rows) == 0) stop("No match data found in the JS file.", call. = FALSE)
  t(vapply(rows, function(r) as.character(unlist(r[1:19])), character(19)))
}

parse_player_dob <- function(js_text) {
  m <- regmatches(js_text, regexec("var dob\\s*=\\s*['\"]?(\\d{8})", js_text))[[1]]
  if (length(m) < 2) stop("Could not find the player's date of birth.", call. = FALSE)
  as.Date(m[2], format = "%Y%m%d")
}

build_match_table <- function(raw) {
  data.frame(
    date = as.Date(raw[, 1], format = "%Y%m%d"),
    tournament = raw[, 2],
    surface = raw[, 3],
    round = raw[, 9],
    result = raw[, 5],
    score = raw[, 10],
    opponent = raw[, 12],
    opponent_rank = suppressWarnings(as.integer(raw[, 13])),
    opponent_country = raw[, 19],
    opponent_info = raw[, 17],   # DOB (women) or age (men)
    stringsAsFactors = FALSE
  )
}
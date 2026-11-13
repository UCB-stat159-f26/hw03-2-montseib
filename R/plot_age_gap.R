#' Plot player age vs. age gap with the opponent
#'
#' @param career_data Data frame returned by [get_player_career()].
#' @return A ggplot object.
#' @importFrom rlang .data
#' @export
plot_age_gap <- function(career_data) {
  check_career_data(career_data)
  keep <- stats::complete.cases(career_data[, c("player_age", "age_diff")])
  ggplot2::ggplot(career_data[keep, ],
                  ggplot2::aes(.data$player_age, .data$age_diff, color = .data$result)) +
    ggplot2::geom_hline(yintercept = 0, color = "grey60") +
    ggplot2::geom_point(alpha = 0.8, size = 2) +
    ggplot2::scale_color_manual(values = c(W = "#1b1b1b", L = "#d62728"),
                                labels = c(W = "Win", L = "Loss")) +
    ggplot2::labs(x = "Player's age", color = NULL,
                  y = "Player's age minus opponent's age (years)") +
    ggplot2::theme_minimal()
}

check_career_data <- function(career_data) {
  needed <- c("player_age", "age_diff", "result")
  if (!is.data.frame(career_data) || !all(needed %in% names(career_data))) {
    stop("`career_data` must be a data frame from get_player_career().",
         call. = FALSE)
  }
}
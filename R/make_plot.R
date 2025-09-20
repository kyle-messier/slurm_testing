make_plot <- function(data) {
  ggplot2::ggplot(data) +
    ggplot2::geom_histogram(aes(x = Ozone), bins = 12) +
    ggplot2::theme_gray(24)
}

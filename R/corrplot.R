#' Plot a Scatter Plot with Correlation Coefficient
#'
#' Plot a scatter plot with correlation coefficient added as annotations.
#' Wrapper around the \code{ggplot} and \code{cor} function.
#'
#' @param data A tibble or dataframe
#' @param x First numeric variable
#' @param y Second numeric variable
#' @param group  Variable used for grouping
#' @param cor_method  Which correlation coefficient to calculate
#' @param use Method for handling missing values
#' @param verbose Print relevant information
#' @return a ggplot object
#' @examples
#' correlation_scatter(iris, x="Sepal.Length", y="Sepal.Width", group="Species")
#' correlation_scatter(iris, cor_method="pearson")
#' @export
#' @importFrom dplyr %>%
#' @importFrom dplyr .data
correlation_scatter <- function(data, x=NULL, y=NULL, group=NULL, cor_method='pearson', use='everything', verbose=TRUE) {
  requireNamespace('dplyr')
  message('function started!\n')
  if (!is.null(group)){
    correlation <- data %>% dplyr::group_by(.data[[group]])
  } else {
    correlation <- data
  }
  if (is.null(x)) x = colnames(data)[1]
  if (is.null(y)) y = colnames(data)[2]
  if (!is.numeric(data[[x]])) stop(paste0(x, " must be numeric!\n"))
  if (!is.numeric(data[[y]])) stop(paste0(y, " must be numeric!\n"))
  if (sum(is.na(data[[x]]) > 0)) warning(paste0('NA found in ', x, '. You may want to set the `use` argument.\n'))
  if (sum(is.na(data[[y]]) > 0)) warning(paste0('NA found in ', y, '. You may want to set the `use` argument.\n'))

  correlation <- correlation %>%
    dplyr::summarise(cor_value = stats::cor(.data[[x]], .data[[y]], method = cor_method, use=use)) %>%
    dplyr::mutate(cor_value = round(cor_value, 4))
  message('Successfully calculated the correlation!')
  p <- ggplot2::ggplot(data) + ggplot2::geom_point(ggplot2::aes(x=.data[[x]], y=.data[[y]]))
  p <- p + ggplot2::geom_text(data=correlation, ggplot2::aes(x=-Inf, y=Inf), label=paste0('correlation: ', as.character(correlation$cor_value)),
                     hjust=-0.2, vjust=1.5)
  if (!is.null(group)) p <- p+ggplot2::facet_wrap(~ .data[[group]])
  return(p)
}

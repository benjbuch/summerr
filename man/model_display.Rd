% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/misc_fun.R
\name{model_display}
\alias{model_display}
\title{Display a fitted curve}
\usage{
model_display(df, ..., digits = 2)
}
\arguments{
\item{df}{A grouped data frame, created with \code{\link{model_cleanly_groupwise}}}

\item{...}{List of name-value pairs in the form \code{aesthetic = variable}
describing which variables in the layer data should be mapped to which
aesthetics used by the paired geom/stat. The expression \code{variable} is
evaluated within the layer data, so there is no need to refer to
the original dataset (i.e., use \code{ggplot(df, aes(variable))}
instead of \code{ggplot(df, aes(df$variable))}). The names for x and y aesthetics
are typically omitted because they are so common; all other aesthetics must be named.}

\item{digits}{Integer indicating the number of significant digits
to be used when fitted parameters are substituted in the model formula.
Negative values are allowed; see \link[base:Round]{signif(...)}.}
}
\value{
A \code{\link[ggplot2:ggplot]{ggplot}} that can be further customized.
}
\description{
Draw a plot after fitting a two-dimensional model.
}
\details{
The parameters of the model, usually accessible via the \code{.$tidy}
column after \code{model_cleanly_groupwise} has been called, are substituted
in the fitted formula and can be accessed as \code{.$sub.formula}.
}
\examples{
library(dplyr)
library(ggplot2)

# create some noisy data for fitting a linear model
x <- seq(1, 10)
y1 <- 3 * x + 5 + rnorm(10)
y2 <- 1 * x + 1 + rnorm(10)

my_data <- bind_rows(data1 = tibble(x, y = y1),
                     data2 = tibble(x, y = y2), .id = "dataset") \%>\%
           group_by(dataset)

my_data \%>\%
  model_cleanly_groupwise(lm, formula = y ~ x) \%>\%
  model_display(color = dataset)

## positioning of per-facet text labels in ggplot is inherently
## difficult; the visual of the example could be improved

my_data \%>\%
  model_cleanly_groupwise(lm, formula = y ~ x) \%>\%
  model_display() +
  # add substituted formula
  geom_text(aes(x = -Inf, y = Inf, label = sub.formula),
    hjust = 0, vjust = 1) +
  # add R square
  geom_text(data = . \%>\% tidyr::unnest(glance),
    aes(x = Inf, y = Inf, label = paste("R^2 =", signif(r.squared, 3))),
    hjust = 1, vjust = 1) +
  # show as facet
  facet_wrap(vars(dataset))


}

utils::globalVariables(".")

#' summerr-package
#'
#' @author Benjamin Buchmuller \email{benjamin.buchmuller@@tu-dortmund.de}
#'
#' @title summerr
#'
#' @description
#'
#' General helpers for lab fun.
#'
#' @section General Functions:
#'
#' \subsection{File and Directory Operations}{
#'
#' \link{select_directory}
#'
#' \link{select_single_file}
#'
#' \link{backup_file}
#'
#' }
#'
#' \subsection{Importing Experiment Layouts}{
#'
#' \link{import_layout_from_excel}
#'
#' \link{import_layout_from_paths}
#'
#' \link{display_plate_layout}
#'
#' }
#'
#' \subsection{Formatting Helpers}{
#'
#' \link{as_well}
#'
#' }
#'
#' @docType package
#' @name summerr-package
NULL

# STARTUP ----------------------------------------------------------------------

#' Startup parameters
#'
#' @noRd
.onAttach <- function(...) {

  # initial setup for formatting output

  options(useFancyQuotes = .Platform$OS.type == "unix")
  options(tibble.width = Inf)

  # startup messages

  if (is.null(getOption("summerr.log"))) options("summerr.log" = TRUE)

  if (getOption("summerr.log", default = FALSE)) {

    packageStartupMessage("\nVerbose logging: `options(summerr.log = TRUE)`")

  } else {

    packageStartupMessage("\nVerbose logging: `options(summerr.log = FALSE)`")

  }

  if (getOption("summerr.debug", default = FALSE)) {

    packageStartupMessage("                 `options(summerr.debug = TRUE)`")

  }

}

# GENERAL USER INTERFACE -------------------------------------------------------

#' Script from template
#'
#' Opens a new file with a template.
#'
#' @param package The name of the corresponding package this template is distributed with.
#' @param filename A generic filename of the template, e.g., "fun_template".
#' @param version  A version idtenfier, e.g., "A01".
#'
#' @export
get_template <- function(package = NULL, filename = "template", version = "") {

  tmp.name <- paste0(filename, "-", version, ".R")
  tmp.file <- system.file("extdata", tmp.name, package = package)

  tmp.cont <- readLines(tmp.file)

  tmp.cont <- sub("<<TODAY>>", format(Sys.time(), "%y%m%d %X %Z"),
                  tmp.cont, fixed = TRUE)
  tmp.cont <- sub("<<RVERSION>>", R.version.string,
                  tmp.cont, fixed = TRUE)

  tmp.spcr <- "# ##############################################################################"

  tmp.cont <- c(
    # add update reminder
    paste0("# devtools::install_github(benjbuch/", package, ")  ## Did you check for updates?"),
    tmp.spcr,
    #
    tmp.cont,
    "",
    tmp.spcr,
    # add sessionInfo()
    paste("#", utils::capture.output(utils::sessionInfo())))

  if (rstudioapi::isAvailable(version_needed = "1.4")) {

    rstudioapi::documentNew(text = tmp.cont, type = "r")

  } else {

    tmp.file <- tempfile(tmpdir = getwd(), pattern = paste0(
      filename, "-", version, "-"), fileext = ".R")
    writeLines(tmp.cont, con = tmp.file)
    utils::file.edit(tmp.file)

  }

}

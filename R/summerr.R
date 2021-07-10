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
#' \link{import_layout_from_excel} and \link{display_plate_layout}
#'
#' \link{import_layout_from_paths}
#'
#' }
#'
#' \subsection{Formatting Helpers}{
#'
#' \link{as_well}
#'
#' \link{arrange_on_page} and \link{get_border_indices}
#'
#' }
#'
#' \subsection{Model Fitting Helpers}{
#'
#' \link{model_cleanly_groupwise} and \link{model_display}
#'
#' }
#'
#' \subsection{API for summerr Packages}{
#'
#' \link{get_template}
#'
#' \link{log_debugging}, \link{log_error}, \link{log_warn}, \link{log_message},
#' and
#' \link{log_line},
#' \link{log_task}, \link{log_process}, \link{log_done}, \link{log_object}
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

#' Update the summerr suite
#'
#' @param pkgs The package to update. If \code{NULL}, all currently loaded \code{summerr}
#' packages will be updated.
#' @param git_repo A GitHub repository to fetch the latest versions from. If \code{NULL},
#' CRAN is tried.
#'
#' @export
update_summerr <- function(pkgs = NULL, git_repo = "benjbuch") {

  if (is.null(pkgs)) {

    pkgs <- loadedNamespaces()[which(startsWith(loadedNamespaces(), "summerr"))]

  }

  if (is.null(pkgs)) {

    pkgs <- c("summerr")

  }

  log_task("I am going to update", paste0("'", paste(pkgs, collapse = "', '"), "'"))

  lapply(pkgs, pkgload::unload)  # force unload even if dependencies

  # print(loadedNamespaces())

  if (is.null(git_repo)) {

    log_process("checking CRAN")
    devtools::install_cran(pkgs)

  } else {

    log_process("checking GitHub")
    devtools::install_github(paste0(git_repo, "/", pkgs))

  }

  rstudioapi::restartSession()

  log_line()

  lapply(pkgs, function(p) require(p, quietly = TRUE, character.only = TRUE))

  invisible()

}

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
    # paste0("# devtools::install_github('benjbuch/", package, "')  ## Did you check for updates?"),
    paste0("update_summerr('", package, "')  ## Did you check for updates?"),
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

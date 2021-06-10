#' Make first letter of a string uppercase
#'
#' @param x an string
#'
#' @noRd
str_first_up <- function(x) {

  # Note: stringr::str_to_sentence messes up upper case letters in paths.

  substr(x, 1, 1) <- toupper(substr(x, 1, 1))

  x

}

# LOGGERS ----------------------------------------------------------------------

#' Logging a separation line
#'
#' This logger can be conveniently activated/deactivatated by setting \code{options(summerr.log = ...)}.
#'
#' @param char the character to repeat
#' @param line the length of the line
#'
#' @export
log_line <- function(char = "=", line = getOption("width")) {

  if (getOption("summerr.log", default = TRUE)) {

    rlang::inform(message = paste0(rep(char, line), collapse = ""))

  }

}

#' Logging of tasks
#'
#' This logger can be conveniently activated/deactivatated by setting \code{options(summerr.log = ...)}.
#'
#' @param ... message
#'
#' @export
log_task <- function(...) {

  if (getOption("summerr.log", default = TRUE)) {

    rlang::inform(message = rlang::format_error_bullets(
      c(i = paste0(str_first_up(paste(...)), "."))
    ))

  }

}

#' Logging of processes
#'
#' This logger can be conveniently activated/deactivatated by setting \code{options(summerr.log = ...)}.
#'
#' @description
#' Sub-routines performed under the headline of the current task.
#'
#' @param ... message
#'
#' @export
log_process <- function(...) {

  if (getOption("summerr.log", default = TRUE)) {

    rlang::inform(message = rlang::format_error_bullets(
      c(i = paste0("... ", paste(...), "."))
    ))

  }

}

#' Logging of process completion
#'
#' This logger can be conveniently activated/deactivatated by setting \code{options(summerr.log = ...)}.
#'
#' @export
log_done <- function() {

  log_process("done")

}

#' Logging of messages
#'
#' @description
#' Anything else.
#'
#' @param ... message
#'
#' @export
log_message <- function(...) {

  if (getOption("summerr.log", default = TRUE)) {

    rlang::inform(message = rlang::format_error_bullets(
      c(i = paste("...", ...))
    ))

  }

}

#' Logging an object
#'
#' @description
#' Typically a table or else.
#'
#' @param object object
#'
#' @export
log_object <- function(object) {

  if (getOption("summerr.log", default = TRUE)) {

    print(object)

  }

}

#' Issuing of warnings
#'
#' @param ... message
#'
#' @export
log_warn <- function(...) {

  rlang::warn(message = str_first_up(paste(...)))

}

#' Handling of errors
#'
#' @param header A concise description of the error.
#' @param body A named character that indicates, e.g. which elements caused an
#' error.
#' @param ... Anything else passed to \code{\link[rlang:abort]{abort(...)}} as metadata.
#'
#' @export
log_error <- function(header, body, ...) {

  rlang::abort(message = paste0(
    str_first_up(header), "\n",
    rlang::format_error_bullets(body)), ...)

}

#' Logging for debugging
#'
#' @description
#' Will print the function name it was invoked from.
#'
#' @param ... message
#' @param object An (optional) object that should be printed to the console.
#'
#' @export
log_debugging <- function(..., object = NULL) {

  if (getOption("summerr.debug", default = FALSE)) {

    fn_call <- match.call(call = sys.call(-1))[1L]

    if (is.null(object)) {

      rlang::inform(message = rlang::format_error_bullets(
        paste0(
          "", fn_call, ": ", str_first_up(paste(...)), ".")
      ))

    } else {

      rlang::inform(message = rlang::format_error_bullets(
        paste0(
          "", fn_call, ": ", str_first_up(paste(...)))
      ))

      print(object)

    }

  }

}


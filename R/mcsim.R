#' Conduct MCSim in simulation
#'
#' The function needs both MCSim model and input files to conduct the simulation.
#'
#' @param model a string giving the name of the MCSim model file.
#' @param input a string giving the name of the MCSim input file.
#' @param dir a character to set the directory of the MCSim model file.
#'
#' @export
mcsim <- function(model, input, dir = "."){

  MD <- paste0(dir, "/", model)
  IP <- paste0(dir, "/", input)

  if (file.exists(MD) == F) stop("'", model, "' is not exist.")
  if (file.exists(IP) == F) stop("'", input, "' is not exist.")

  exc = paste0("mcsim.", model, ".exe")
  if (file.exists(exc) == F) {
    makemcsim(model, dir = dir)
    if (file.exists(exc) == F) stop("Can not create '", exc, "'.")
  }

  message(paste0("\nExecute:", " ./mcsim.", model, ".exe ", dir, "/", input))
  invisible(system(paste0("./mcsim.", model, ".exe ", dir, "/", input)))
}

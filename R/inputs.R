#' Example Input
#'
#' The example input: A four-compartment model of Tetrachloroethylene (PERC)
#' toxicokinetics. (Bois et al. 1996).
#'
#'
#' @references
#' Bois, F. Y., et al. "Population toxicokinetics of tetrachloroethylene."
#' \emph{Archives of toxicology} 70 (1996): 347-355.
#'
#' @export
#' @rdname inputs
perc_lsodes_input <- function(){
  if (file.exists("perc.lsodes.in")) stop("The 'perc.lsodes.in' is existed.")
  mpath <- system.file("inputs", "perc.lsodes.in", package="RMCSim")
  invisible(file.copy(mpath, getwd()))
  if(file.exists("perc.lsodes.in")) message("Created 'perc.lsodes.in'.")
}

#' @export
#' @rdname inputs
perc_mcmc_input <- function(){

  file_name = "perc.mcmc.in"

  if (file.exists(file_name)) stop("The 'perc.mcmc.in' is existed.")
  mpath <- system.file("inputs", "perc.lsodes.in", package = "RMCSim")
  invisible(file.copy(mpath, getwd()))
  if(file.exists(file_name)) message("Created 'perc.mcmc.in'.")
}

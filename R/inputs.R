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
perc_input <- function(){
  if (file.exists("perc.lsodes.in")) stop("The 'perc.lsodes.in' is existed.")
  mpath <- system.file("inputs", "perc.lsodes.in", package="RMCSim")
  invisible(file.copy(mpath, getwd()))
  if(file.exists("perc.lsodes.in")) message("Created 'perc.lsodes.in'.")
}

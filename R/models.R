#' Example Model
#'
#' The example model: A four-compartment model of Tetrachloroethylene (PERC)
#' toxicokinetics. (Bois et al. 1996).
#'
#'
#' @references
#' Bois, F. Y., et al. "Population toxicokinetics of tetrachloroethylene."
#' \emph{Archives of toxicology} 70 (1996): 347-355.
#'
#' @export
perc_model <- function(){
  if (file.exists("perc.model")) stop("The 'perc.model' is existed.")
  mpath <- system.file("models", "perc.model", package="RMCSim")
  invisible(file.copy(mpath, getwd()))
}



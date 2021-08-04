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
  mpath <- system.file("models", "perc.model", package="RMCSim")
  file.copy(mpath, getwd())
}

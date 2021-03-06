#' Conduct MCSim in simulation
#'
#' The function needs both MCSim model and input files to conduct the simulation.
#'
#' @param model a string giving the name of the MCSim model file.
#' @param input a string giving the name of the MCSim input file.
#' @param dir a character to set the directory of the MCSim model file.
#' @param parallel a logical value to conduct parallel computing.
#'
#' @export
mcsim <- function(model, input, dir = ".", parallel = F){

  MD <- paste0(dir, "/", model)
  IP <- paste0(dir, "/", input)

  if (file.exists(MD) == F) stop("'", model, "' is not exist.")
  if (file.exists(IP) == F) stop("'", input, "' is not exist.")

  exc = paste0("mcsim.", model, ".exe")
  if (file.exists(exc) == F) {
    makemcsim(model, dir = dir)
    if (file.exists(exc) == F) stop("Can not create '", exc, "'.")
  }

  tx  <- readLines(paste0(dir, "/", input))
  MCMC_line <- grep("MCMC \\(", x=tx)
  #MonteCarlo_line <- grep("MonteCarlo \\(", x=tx)
  #SetPoints_line <- grep("SetPoints \\(", x=tx)

  if (length(MCMC_line) != 0){

    RandomSeed <- sample(1111:9999, 1)
    tx2 <- gsub(pattern = "10101010", replacement = paste(RandomSeed), x = tx)
    checkfile <- "MCMC.check.out"

    if(file.exists(checkfile)){
      file.remove(checkfile)
    }

    if (parallel == T){
      i <- RandomSeed
      name <- gsub("\\..*", "", input)
      mcmc_input <- paste0(name, "_", i, ".in")
      mcmc_output <- paste0(name, "_", i, ".out")
      tx3 <- gsub(pattern = "MCMC.default.out", replacement = mcmc_output, x = tx2)
      writeLines(tx3, con = mcmc_input)
      system(paste("./mcsim.", model, ".exe -i 1000 ", mcmc_input, sep = ""))

    } else{
      tmp <- paste0("tmp_", input)
      writeLines(tx, con=paste0(dir, "/", input))
      writeLines(tx2, con=paste0(dir, "/", tmp))
      system(paste("./mcsim.", model, ".exe ", dir, "/", tmp, sep = ""))
      outfile <- "MCMC.default.out"
      tx2 <- gsub(pattern = ",0,", replacement = ",1,", x = tx)
      tx3 <- gsub(pattern = paste0("\"", outfile, "\",\"\""),
                  replacement = paste0("\"", checkfile, "\",\"", outfile, "\""),
                  x = tx2)
      writeLines(tx3, con=paste0(dir, "/", tmp))

      system(paste("./mcsim.", model, ".exe -i 1000 ", dir, "/", tmp, sep = ""))
      file.remove(paste0(dir, "/", tmp))
    }

    if(file.exists(checkfile)){
      message(paste0("* Create '", checkfile, "' from the last iteration."))
    }
  } else {
    message(paste0("\nExecute:", " ./mcsim.", model, ".exe ", dir, "/", input))
    invisible(system(paste0("./mcsim.", model, ".exe ", dir, "/", input)))
  }

}

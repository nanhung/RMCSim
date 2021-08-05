#' Download and install \pkg{GNU MCSim}
#'
#' Download and install the portable MCSim into the package folder.
#'
#' The model generator program 'mod.exe' is used to compile the model code
#' will be generated after the file download.
#' The function can only use for version greater than 5.3.0.
#' The Linux user need to make sure the gcc is pre-installed in your system.
#' If you use Windows OS, be sure to install Rtools first.
#' The Rtools can install through installr::install.rtools()
#'
#' @references
#' Bois, F. Y., & Maszle, D. R. (1997).
#' MCSim: a Monte Carlo simulation program.
#' \emph{Journal of Statistical Software}, 2(9): 1–60.
#'
#' @param version a character of version number.
#'
#' @import withr
#'
#' @references \url{https://www.gnu.org/software/mcsim/}
#'
#' @export
install_mcsim <- function(version = '6.2.0'){

  current_wd <- getwd()
  mcsim_directory <- paste0(system.file(package = "RMCSim"), "/mcsim")

  if(!dir.exists(mcsim_directory)) dir.create(mcsim_directory)

  withr::with_dir(mcsim_directory, files_before <- list.files())
  URL <- sprintf('http://ftp.gnu.org/gnu/mcsim/mcsim-%s.tar.gz', version)
  tf <- tempfile()
  utils::download.file(URL, tf, mode = "wb")
  withr::with_dir(mcsim_directory, utils::untar(tf))
  withr::with_dir(mcsim_directory, files_after <- list.files())

  file_name <- setdiff(files_after, files_before)
  if(file_name == "mcsim")
    withr::with_dir(mcsim_directory, file.rename("mcsim", paste0("mcsim-", version)))

  mod_directory <- paste0(mcsim_directory, "/mcsim-", version, "/mod")
  withr::with_dir(mod_directory, generate_config())
  sim_directory <- paste0(mcsim_directory, "/mcsim-", version, "/sim")
  withr::with_dir(sim_directory, generate_config())

  message("Creating 'mod' file\n")
  withr::with_dir(mod_directory, system(paste0("gcc -o ./mod.exe *.c")))
  check_mod <- withr::with_dir(mod_directory, file.exists("mod.exe"))

  if(check_mod){
    withr::with_dir(mod_directory, file.copy("mod.exe", paste0(mcsim_directory, "/mod.exe")))
    withr::with_dir(mod_directory, file.remove("mod.exe"))
    cat(paste0("Created model generator program\n"))
    message(paste0("The MCSim " , sprintf('%s', version), " is downloaded. The sourced folder is under ", mcsim_directory, "\n"))
  } else
    message(paste0("The MCSim " , sprintf('%s', version), " is downloaded; But have problem to generate model generator program\n"))

}

#' @export
find_mcsim = function(){
  mod_file <- paste0(system.file(package = "RMCSim"), "/mcsim/mod.exe")
  return(file.exists(mod_file))
}

#' @export
mcsim_version = function(){

  mod_file <- paste0(system.file(package = "RMCSim"), "/mcsim/mod.exe")

  if(file.exists(mod_file)){
    command <- paste0(mod_file, " -h")
    opt <- "mod.mcsim.txt"
    cat("", file = opt)
    sink(opt, append=TRUE)
    print(system(command, intern = TRUE))
    sink()
  } else stop("The mod file is not exist.")

  l <- readLines("mod.mcsim.txt")
  invisible(file.remove("mod.mcsim.txt"))
  version <- substr(l[4], 12, 16)
  message("The current GNU MCSim version is ", version)

}

generate_config <- function(){
  cat("#define HAVE_DLFCN_H 1 \n",
      "#define HAVE_ERFC 1 \n",
      "#define HAVE_FLOAT_H 1 \n",
      "#define HAVE_FLOOR 1 \n",
      "#define HAVE_INTTYPES_H 1 \n",
      #"#define HAVE_LIBGSL 1 \n",
      "#define HAVE_LIBGSLCBLAS 1 \n",
      "#define HAVE_LIBLAPACK 1 \n",
      "#define HAVE_LIBM 1 \n",
      #"#define HAVE_LIBSBML 1 \n",
      #"#define HAVE_LIBSUNDIALS_CVODES 1 \n",
      #"#define HAVE_LIBSUNDIALS_NVECSERIAL 1 \n",
      "#define HAVE_LIMITS_H 1 \n",
      "#define HAVE_MALLOC 1 \n",
      "#define HAVE_MEMORY_H 1 \n",
      "#define HAVE_MODF 1 \n",
      "#define HAVE_POW 1 \n",
      "#define HAVE_REALLOC 1 \n",
      "#define HAVE_SQRT 1 \n",
      "#define HAVE_STDINT_H 1 \n",
      "#define HAVE_STDLIB_H 1 \n",
      "#define HAVE_STRCHR 1 \n",
      "#define HAVE_STRINGS_H 1 \n",
      "#define HAVE_STRING_H 1 \n",
      "#define HAVE_SYS_STAT_H 1 \n",
      "#define HAVE_SYS_TYPES_H 1 \n",
      "#define HAVE_UNISTD_H 1 \n",
      file = "config.h",
      sep = "")
}

#' @export
makemcsim <- function(model, version = '6.2.0', deSolve = F, dir = "."){

  mcsim_directory <- paste0(system.file(package = "RMCSim"), "/mcsim")
  sim_directory <- paste0(mcsim_directory, "/mcsim-", version, "/sim")
  mod_file <- paste0(system.file(package = "RMCSim"), "/mcsim/mod.exe")
  exe_file <- paste0("mcsim.", model, ".exe")


  if(!file.exists(mod_file)) stop("The mod file is not exist.")

  if (deSolve == T){
    system(paste0(mod_file, " -R ", dir, "/", model, " ", model, ".c"))
    system (paste0("R CMD SHLIB ", model, ".c"))
  } else {
    system(paste0(mod_file, " ", dir, "/", model, " ", model, ".c"))
    paste0("gcc -O3 -I.. -I", sim_directory, " -o mcsim.", model, ".exe ", model, ".c ", sim_directory, "/*.c -lm ") |>
      system()
    invisible(file.remove(paste0(model, ".c")))
    if(file.exists(exe_file)) message(paste0("* Created executable program '", exe_file, "'."))
  }
}


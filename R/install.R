#' Download and install \pkg{GNU MCSim}
#'
#' Download the latest or specific version of \pkg{GNU MCSim} from the official
#' website (\url{https://www.gnu.org/software/mcsim/}) and install it to the
#' system directory.
#'
#' Download and generate the portable MCSim into the package folder (no installation).
#' The model generator program 'mod.exe' is used to compile the model code will be generated after the file download.
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
#' @references \url{https://www.gnu.org/software/mcsim/}
#'
#' @export
install_mcsim <- function(version = "6.2.0"){

  current_wd <- getwd()
  mcsim_directory <- system.file("mcsim", package = "RMCSim")
  mcsim_wd <- setwd(mcsim_directory)

  files_before <- list.files()

  message("Start install")
  version <- version
  URL <- sprintf('http://ftp.gnu.org/gnu/mcsim/mcsim-%s.tar.gz', version)
  tf <- tempfile()
  utils::download.file(URL, tf, mode = "wb")
  utils::untar(tf)

  files_after <- list.files()

  file_name <- setdiff(files_after, files_before)
  if(file_name == "mcsim") file.rename("mcsim", paste0("mcsim-", version))


  if (Sys.info()[['sysname']] == "Windows") {
    if(Sys.which("gcc") == ""){ # echo $PATH
      PATH = "C:\\rtools40\\mingw64\\bin; C:\\rtools40\\usr\\bin"
      Sys.setenv(PATH = paste(PATH, Sys.getenv("PATH"), sep=";"))
    } # PATH=$PATH:/c/Rtools/mingw_32/bin; export PATH
  } # PATH=$PATH:/c/MinGW/msys/1.0/local/bin


  setwd(paste0(mcsim_directory, "/mcsim-", version, "/mod"))
  generate_config.h()
  system(paste0("gcc -o ./mod.exe *.c"))
  if(file.exists("mod.exe")){
    cat(paste0("Created model generator program 'mod.exe'\n"))
    message(paste0("The MCSim " , sprintf('%s', version), " is downloaded. The sourced folder is under ", mcsim_directory, "\n"))
  } else
    message(paste0("The MCSim " , sprintf('%s', version), " is downloaded; But have problem to generate model generator program 'mod.exe'\n"))

  setwd(paste0(mcsim_directory, "/mcsim-", version, "/sim"))
  generate_config.h()
  setwd(current_wd)
  cat("\n")
}

generate_config.h <- function(){
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

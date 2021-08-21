.onLoad <- function(...) {
  set_PATH()
}

set_PATH <- function(PATH = "C:\\rtools40\\mingw64\\bin; C:\\rtools40\\usr\\bin"){

  if (Sys.info()[['sysname']] == "Windows") {
    if(Sys.which("gcc") == ""){ # echo $PATH
      Sys.setenv(PATH = paste(PATH, Sys.getenv("PATH"), sep=";"))
    } # PATH=$PATH:/c/Rtools/mingw_32/bin; export PATH
  } # PATH=$PATH:/c/MinGW/msys/1.0/local/bin
}

.onUnload <- function (libpath) {
  library.dynam.unload("RMCSim", libpath)
}

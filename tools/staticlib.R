# Rust build target from command args
args <- commandArgs(TRUE)
target <- if ( length(args) > 0 ) args[1] else NULL

# Where is Cargo? game
cargo_is_found <- (Sys.which("cargo") != "")

# Detecting OS type
osType <- function() {
  info <- Sys.info()
  sysname <- info["sysname"]
  if ( ( ! grepl("^x86", info["machine"]) ) || ( ! ( sysname %in% c("Windows","Darwin","Linux") ) ) ) sprintf("%s-%s",info["sysname"],info["machine"])
  else if ( sysname == "Windows" ) "windows"
  else if ( sysname == "Darwin" ) "macosx"
  else if ( sysname == "Linux" ) "linux"
  else sysname
}
osType <- osType()

# Detecting cargo installed version
requiredCargoVersion <- "1.36.0"
cat(paste0("Cargo version ", requiredCargoVersion, " or newer is required for compilation.\n"))

if(!cargo_is_found && (osType != 'windows')){
  cat("Cargo is a requirement to compile the Rust library. Please visit https://rustup.rs to install it. You do not need admin rights.\n")
  quit()
}
if(cargo_is_found && (osType == 'windows')){
  installedCargoVersion <- gsub("cargo ([^ ]+).*", "\\1", system2("cargo","--version",stdout=TRUE))
  cat(paste0("Cargo version ", installedCargoVersion, " found.\n"))
  installedCargoVersion <- strsplit(installedCargoVersion, '-')[[1]][1]
  is_installed_newer <- (compareVersion(installedCargoVersion, requiredCargoVersion) > 0)
  
  # Compiling if cargo version is OK
  if(is_installed_newer){
    cat("Compiling the Rust library.\n")
    system2("cargo",c("build",paste0('--target ', target),"--release","--manifest-path=rustlib/Cargo.toml"))
    quit(status = 0)
  } else {
    cat("Cargo version too old. Run rustup update in a terminal.\n")
  }
}

# Using pre-compiled shared library on Windows
cat("Getting pre-compiled Rust library.\n")
destDir <- sprintf("rustlib/target/%s/release", target)
headDir <- if ( substr(target,1,3) == "x86" ) "x64" else "i386"
dir.create(destDir, recursive = TRUE)
file.copy(from = paste0('../tools/', target), to = 'rustlib/target', recursive = TRUE)

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
  else if ( sysname == "Darwin-arm64") "macosx-arm"
  else if ( sysname == "Linux" ) "linux"
  else sysname
}
osType <- osType()

if(!(osType %in% c('windows', 'macosx', 'linux', 'macosx-arm'))){
  cat(paste0(osType, ' is not a supported platform.\n',
             'Compilation and installation may be possible if the Rust compiler is available.\n',
             'It is recommended to use baseflow package with Windows, GNU/Linux or macOS.\n'))
  #quit(status = 1)
}

# Detecting cargo installed version
requiredCargoVersion <- "1.42.0"
cat(paste0("Cargo version ", requiredCargoVersion, " or newer is required for compilation.\n"))

if(!cargo_is_found && !(osType %in% c("windows", "macosx", "macosx-arm"))){
  cat("Cargo is a requirement to compile the Rust library. Please visit https://rustup.rs to install it. You do not need admin rights.\n")
  quit(status = 1)
}
if(cargo_is_found && (osType == 'windows')){
  installedCargoVersion <- gsub("cargo ([^ ]+).*", "\\1", system2("cargo","--version",stdout=TRUE))
  cat(paste0("Cargo version ", installedCargoVersion, " found.\n"))
  installedCargoVersion <- strsplit(installedCargoVersion, '-')[[1]][1]
  is_installed_newer <- (compareVersion(installedCargoVersion, requiredCargoVersion) >= 0)
  
  # Compiling if cargo version is OK
  if(is_installed_newer){
    cat("Compiling the Rust library.\n")
    system2("cargo",c("build",paste0('--target ', target),"--release","--manifest-path=rustlib/Cargo.toml"))
    quit(status = 0)
  } else {
    cat("Cargo version too old. Run rustup update in a terminal.\n")
    quit(status = 1)
  }
}
if(cargo_is_found && (osType != 'windows')){
  installedCargoVersion <- gsub("cargo ([^ ]+).*", "\\1", system2("cargo","--version",stdout=TRUE))
  cat(paste0("Cargo version ", installedCargoVersion, " found.\n"))
  installedCargoVersion <- strsplit(installedCargoVersion, '-')[[1]][1]
  is_installed_newer <- (compareVersion(installedCargoVersion, requiredCargoVersion) >= 0)
  
  # Compiling if cargo version is OK
  if(is_installed_newer){
    cat("Compiling the Rust library.\n")
    system2("cargo",c("build","--release","--manifest-path=rustlib/Cargo.toml"))
    if(osType == 'macosx'){
      system2("strip", c("-x", "rustlib/target/release/librustlib.a"))
    } else {
      system2("strip", c("--strip-unneeded", "rustlib/target/release/librustlib.a"))
    }
    quit(status = 0)
  } else {
    cat("Cargo version too old. Run rustup update in a terminal.\n")
    quit(status = 1)
  }
}

# Using pre-compiled shared library on Windows and MacOS
if(!cargo_is_found && (osType == 'macosx')){
  target <- "x86_64-apple-darwin"
  cat("Downloading pre-compiled Rust library.\n")
  download.file('https://gitlab.irstea.fr/HYCAR-Hydro/baseflow/-/raw/master/tools/tools.tar.gz',
                destfile = 'tools.tar.gz')
  dir.create('./ext_tools')
  untar('tools.tar.gz', list = FALSE, exdir = './ext_tools')
  
  destDir <- "rustlib/target/release"
  dir.create(destDir, recursive = TRUE)
  
  files_list <- c('librustlib.d', 'librustlib.rlib', 'librustlib.a')
  for(f in files_list){
    file.copy(from = paste0('./ext_tools/', target, '/release/', f),
              to = paste0(destDir, '/', f), overwrite = TRUE)
    file.remove(paste0('./ext_tools/', target, '/release/', f))
  }
}
if(!cargo_is_found && (osType == 'macosx-arm')){
  target <- "aarch64-apple-darwin"
  cat("Downloading pre-compiled Rust library.\n")
  download.file('https://gitlab.irstea.fr/HYCAR-Hydro/baseflow/-/raw/master/tools/tools.tar.gz',
                destfile = 'tools.tar.gz')
  dir.create('./ext_tools')
  untar('tools.tar.gz', list = FALSE, exdir = './ext_tools')
  
  destDir <- "rustlib/target/release"
  dir.create(destDir, recursive = TRUE)
  
  files_list <- c('librustlib.d', 'librustlib.rlib', 'librustlib.a')
  for(f in files_list){
    file.copy(from = paste0('./ext_tools/', target, '/release/', f),
              to = paste0(destDir, '/', f), overwrite = TRUE)
    file.remove(paste0('./ext_tools/', target, '/release/', f))
  }
}
if(!cargo_is_found && (osType == 'windows')){
  cat("Downloading pre-compiled Rust library.\n")
  download.file('https://gitlab.irstea.fr/HYCAR-Hydro/baseflow/-/raw/master/tools/tools.tar.gz',
                destfile = 'tools.tar.gz')
  dir.create('./ext_tools')
  untar('tools.tar.gz', list = FALSE, exdir = './ext_tools')
  
  destDir <- sprintf("rustlib/target/%s/release", target)
  dir.create(destDir, recursive = TRUE)
  
  files_list <- c('librustlib.d', 'librustlib.rlib', 'librustlib.a')
  for(f in files_list){
    file.copy(from = paste0('./ext_tools/', target, '/release/', f),
              to = paste0(destDir, '/', f), overwrite = TRUE)
    file.remove(paste0('./ext_tools/', target, '/release/', f))
  }
}

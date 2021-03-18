# Rust build target from command args
args <- commandArgs(TRUE)
target <- if ( length(args) > 0 ) args[1] else NULL

# Finding cargo
if(Sys.which("cargo") != ""){ # Searching for CARGO in PATH
  cargo_is_found <- TRUE
  cargo <- "cargo"
} else if(file.exists(paste0(Sys.getenv("HOME"), "/.cargo/bin/cargo"))){ # Searching in ~/.cargo/bin on Unix
  cargo_is_found <- TRUE
  cargo <- paste0(Sys.getenv("HOME"), "/.cargo/bin/cargo")
} else if(file.exists(paste0(Sys.getenv("USERPROFILE"), "/.cargo/bin/cargo.exe"))){ # Searching on Windows
  cargo_is_found <- TRUE
  cargo <- paste0(Sys.getenv("USERPROFILE"), "/.cargo/bin/cargo.exe")
} else {
  cargo_is_found <- FALSE
}

# Finding rustc
if(Sys.which("rustc") != ""){ # Searching for rustc in PATH
  rustc_is_found <- TRUE
  rustc <- Sys.which("rustc")
} else if(file.exists(paste0(Sys.getenv("HOME"), "/.cargo/bin/rustc"))){ # Searching in ~/.cargo/bin on Unix
  rustc_is_found <- TRUE
  rustc <- paste0(Sys.getenv("HOME"), "/.cargo/bin/rustc")
} else if(file.exists(paste0(Sys.getenv("USERPROFILE"), "/.cargo/bin/rustc.exe"))){ # Searching on Windows
  rustc_is_found <- TRUE
  rustc <- paste0(Sys.getenv("USERPROFILE"), "/.cargo/bin/rustc.exe")
} else {
  rustc_is_found <- FALSE
}

# Detecting OS type
osType <- function() {
  info <- Sys.info()
  sysname <- info["sysname"]
  if(sysname == "Windows"){
    cat("Detected platform: Windows\n")
    return("windows")
  }
  if(sysname == "Linux"){
    cat("Detected platform: Linux\n")
    return("Linux")
  }
  if(sysname == "Darwin"){
    if(info["machine"] == "x86_64"){
      cat("Detected platform: macOS on x86_64\n")
      return("macosx")
    }
    if(info["machine"] == "arm64"){
      cat("Detected platform: macOS on ARM64\n")
      return("macosx-arm")
    }
  }
  cat(paste0("Detected platform: ", sysname, " on ", info["machine"], "\n"))
  return(sysname)
}
osType <- osType()

if(!(osType %in% c('windows', 'macosx', 'linux', 'macosx-arm'))){
  cat(paste0(osType, ' is not a supported platform.\n',
             'Compilation and installation may be possible if the Rust compiler is available.\n',
             'It is recommended to use baseflow package with Windows, GNU/Linux or macOS.\n'))
}

# Detecting cargo installed version
requiredCargoVersion <- "1.42.0"
cat(paste0("Cargo version ", requiredCargoVersion, " or newer is required for compilation.\n"))

if(!cargo_is_found && !(osType %in% c("windows", "macosx", "macosx-arm"))){
  cat("Cargo is a requirement to compile the Rust library. Please visit https://rustup.rs to install it. You do not need admin rights.\n")
  quit(status = 1)
}
if((cargo_is_found & !rustc_is_found) & !(osType %in% c("windows", "macosx", "macosx-arm"))){
  cat("Cargo was found but no Rust compiler seems to be installed. Your cargo install may be broken.\n")
  cargo_is_found <- FALSE
  quit(status = 1)
}
if((cargo_is_found & !rustc_is_found) & (osType %in% c("windows", "macosx", "macosx-arm"))){
  cat("Cargo was found but no Rust compiler seems to be installed.\n")
  cargo_is_found <- FALSE
}

## On Windows: if cargo is too old or install is broken, we switch to pre-compiled library
if(cargo_is_found & (osType == 'windows')){
  cargo_version_status <- system2(cargo,"--version",stdout = FALSE, stderr = FALSE)
  if(cargo_version_status != 0){
    cat(paste0("Cargo error while checking version.\n"))
    cargo_is_found <- FALSE
  } else {
    installedCargoVersion <- gsub("cargo ([^ ]+).*", "\\1", system2(cargo,"--version",stdout=TRUE))
    cat(paste0("Cargo version ", installedCargoVersion, " found.\n"))
    installedCargoVersion <- strsplit(installedCargoVersion, '-')[[1]][1]
    is_installed_newer <- (compareVersion(installedCargoVersion, requiredCargoVersion) >= 0)
    
    # Compiling if cargo version is OK
    if(is_installed_newer){
      cargo_home_backup <- Sys.getenv("CARGO_HOME")
      rustc_backup <- Sys.getenv("RUSTC")
      Sys.setenv(CARGO_HOME = paste0(getwd(), '/.cargo'))
      Sys.setenv(RUSTC = rustc)
      if(!dir.exists(Sys.getenv("CARGO_HOME"))){
        dir.create(Sys.getenv("CARGO_HOME"))
      }
      #file.copy('../tools/config.toml', './.cargo/config.toml', overwrite = TRUE)
      cat("Compiling the Rust library.\n")
      cargo_status <- system2(cargo,c("build",paste0('--target ', target),"--release","--manifest-path=rustlib/Cargo.toml"))
      if(dir.exists('./.cargo')){
        unlink('./.cargo', recursive = TRUE, force = TRUE)
      }
      cat('Restoring environment variables to their previous values.\n')
      Sys.setenv(CARGO_HOME = cargo_home_backup)
      Sys.setenv(RUSTC = rustc_backup)
      if(cargo_status != 0){
        cat("Error during Rust compilation.\n")
        cargo_is_found <- FALSE
      } else {
        quit(status = 0)
      }
    } else {
      cat("Cargo version too old. You can use \"rustup.exe update\" command to get an up-to-date version.\n")
      cargo_is_found <- FALSE
    }
  }
}

## On macOS: if cargo is too old or install is broken, we switch to pre-compiled library
if(cargo_is_found & (osType %in% c("macosx", "macosx-arm"))){
  cargo_version_status <- system2(cargo,"--version",stdout = FALSE, stderr = FALSE)
  if(cargo_version_status != 0){
    cat(paste0("Cargo error while checking version.\n"))
    cargo_is_found <- FALSE
  } else {
    installedCargoVersion <- gsub("cargo ([^ ]+).*", "\\1", system2(cargo,"--version",stdout=TRUE))
    cat(paste0("Cargo version ", installedCargoVersion, " found.\n"))
    installedCargoVersion <- strsplit(installedCargoVersion, '-')[[1]][1]
    is_installed_newer <- (compareVersion(installedCargoVersion, requiredCargoVersion) >= 0)
    
    # Compiling if cargo version is OK
    if(is_installed_newer){
      cargo_home_backup <- Sys.getenv("CARGO_HOME")
      rustc_backup <- Sys.getenv("RUSTC")
      Sys.setenv(CARGO_HOME = paste0(getwd(), '/.cargo'))
      Sys.setenv(RUSTC = rustc)
      if(!dir.exists(Sys.getenv("CARGO_HOME"))){
        dir.create(Sys.getenv("CARGO_HOME"))
      }
      cat("Compiling the Rust library.\n")
      cargo_status <- system2(cargo,c("build","--release","--manifest-path=rustlib/Cargo.toml"))
      if(dir.exists('./.cargo')){
        unlink('./.cargo', recursive = TRUE, force = TRUE)
      }
      cat('Restoring environment variables to their previous values.\n')
      Sys.setenv(CARGO_HOME = cargo_home_backup)
      Sys.setenv(RUSTC = rustc_backup)
      if(cargo_status != 0){
        cat("Error during Rust compilation.\n")
        cargo_is_found <- FALSE
      } else {
        system2("strip", c("-x", "rustlib/target/release/librustlib.a"))
        quit(status = 0)
      }
    } else {
      cat("Cargo version too old. You can use \"rustup.exe update\" command to get an up-to-date version.\n")
      cargo_is_found <- FALSE
    }
  }
}

## On Linux: no pre-compiled library available
if(cargo_is_found & !(osType %in% c('windows', 'macosx', 'macosx-arm'))){
  cargo_version_status <- system2(cargo,"--version",stdout = FALSE, stderr = FALSE)
  if(cargo_version_status != 0){
    cat(paste0("Cargo error while checking version.\n"))
    quit(status = 1)
  } else {
    installedCargoVersion <- gsub("cargo ([^ ]+).*", "\\1", system2(cargo,"--version",stdout=TRUE))
    cat(paste0("Cargo version ", installedCargoVersion, " found.\n"))
    installedCargoVersion <- strsplit(installedCargoVersion, '-')[[1]][1]
    is_installed_newer <- (compareVersion(installedCargoVersion, requiredCargoVersion) >= 0)
    
    # Compiling if cargo version is OK
    if(is_installed_newer){
      cargo_home_backup <- Sys.getenv("CARGO_HOME")
      rustc_backup <- Sys.getenv("RUSTC")
      Sys.setenv(CARGO_HOME = paste0(getwd(), '/.cargo'))
      Sys.setenv(RUSTC = rustc)
      if(!dir.exists(Sys.getenv("CARGO_HOME"))){
        dir.create(Sys.getenv("CARGO_HOME"))
      }
      cat("Compiling the Rust library.\n")
      cargo_status <- system2(cargo,c("build","--release","--manifest-path=rustlib/Cargo.toml"))
      if(dir.exists('./.cargo')){
        unlink('./.cargo', recursive = TRUE, force = TRUE)
      }
      cat('Restoring environment variables to their previous values.\n')
      Sys.setenv(CARGO_HOME = cargo_home_backup)
      Sys.setenv(RUSTC = rustc_backup)
      if(cargo_status != 0){
        cat("Error during Rust compilation.\n")
        quit(status = 1)
      } else {
        system2("strip", c("--strip-unneeded", "rustlib/target/release/librustlib.a"))
        quit(status = 0)
      }
    } else {
      cat("Cargo version too old. You can use \"rustup.exe update\" command to get an up-to-date version.\n")
      quit(status = 1)
    }
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
    #file.remove(paste0('./ext_tools/', target, '/release/', f))
  }
  system2("strip", c("-x", "rustlib/target/release/librustlib.a"))
  file.remove("tools.tar.gz")
  unlink('./ext_tools', recursive = TRUE, force = TRUE)
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
    #file.remove(paste0('./ext_tools/', target, '/release/', f))
  }
  system2("strip", c("-x", "rustlib/target/release/librustlib.a"))
  file.remove("tools.tar.gz")
  unlink('./ext_tools', recursive = TRUE, force = TRUE)
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
    #file.remove(paste0('./ext_tools/', target, '/release/', f))
  }
  file.remove("tools.tar.gz")
  unlink('./ext_tools', recursive = TRUE, force = TRUE)
}

# baseflow

This package computes hydrograph separation using the conceptual automated process from Pelletier and Andreassian, 2019. The present README file describes installation instructions.

*baseflow* is a R package whose computing core is made of a Rust library. Integration was realized through [RustR](https://github.com/rustr/rustr) API and [rustinr](https://github.com/rustr/rustinr) R package.

## Installation

### Requirements

This package has been tested on Linux (openSUSE Leap 15.0 x64) and Windows (7 and 10). It is developed with cross-platform languages (Rust and R) so it is supposed to work on other platforms. Package is available as binaries for Windows and as sources, that need to be compiled, for other operating systems.

Software requirements for the binary installation are the following:

* **R** (package is developed with version 3.6.0)
* **airGR** R package (available on CRAN or [here](https://webgr.irstea.fr/airGR-website))

For the source compilation, in addition to the requirements above, the following are needed:

* **Rtools** for Windows (available [here](https://cran.r-project.org/bin/windows/Rtools/)) or a building environmment on other platforms, generally installed with R on linux distributions. At least, a C/C++ compiler like a recent version of `gcc`
* **cargo** Rust compilation platform. Detailed installation instructions are given below.

### Rust platform

General instructions to install the Rust compilation platform are given on the website [RustUp](https://rustup.rs/). It can be installed without administrator privileges - you do not need to ask your local computer technician that does not know Rust.

#### Windows

On Windows, download and lauch the rustup-init.exe script (64 bits version is [here](https://win.rustup.rs/x86_64), 32 bits is [here](https://win.rustup.rs/i686)). In the command prompt window, choose the second option `Customize installation` and set configuration as below.

```
default host triple: i686-pc-windows-gnu
default toolchain: beta
modify PATH variable: yes
```

Then, choose the first option `Proceed with installation`.

On 64-bits Windows systems, you also need to install the x64 toolchain. After installation, open a terminal and type:

```
rustup target add x86_64-pc-windows-gnu
```

#### GNU/Linux

On GNU/Linux platforms, launch the following command into a terminal:

```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```
Here again, chose the second option `Customize installation` and set configuration as below.

For 64 bits systems:

```
default host triple: x86_64-unknown-linux-gnu
default toolchain: beta
modify PATH variable: yes
```

For 32 bits systems:

```
default host triple: i686-unknown-linux-gnu
default toolchain: beta
modify PATH variable: yes
```
  
After modifying configuration, choose option 1 `Proceed with installation`. After the end of installation, close and re-open your user session, or restart your computer, to update your environment variables.

### Package compilation and installation

Download the source package as a `.tar.gz` file. Start R and run the following command in the console, where `path_to_package` is the path of the downloaded `.tar.gz` file of the package.

```
install.packages("path_to_package", repos = NULL, type = "source")
```  

On Windows, you can directly download the binary `.zip` file, and run the following command, where `path_to_binary_package` is the path of the downloaded `.zip` file of the package.

```
install.packages("path_to_binary_package", repos = NULL, type = "win.binary")
```
  
After installation, try to load package using command

```
library(baseflow)
```  
